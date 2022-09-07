module mdio_driver
#(
    parameter PHY_ADDR = 5'b00_001,  // PHY 地址
    parameter CLK_FRE  = 6'd8       // 得到MDC的分频系数 频率 = 50M/CLK_FRE
)
(
    input wire          clk             ,
    input wire          rst_n           ,
    input wire          mdio_start      , // mdio开始信号
    input wire          mdio_rh_wl      , // MDIO读写控制信号 读H，写L
    input wire  [4:0]   mdio_reg_addr   , // 寄存器地址
    input wire  [15:0]  mdio_wr_data    , // 写数据

    output reg  [15:0]  mdio_rd_data    ,
    output reg          mdio_done       , //完成信号
    output reg          mdio_rd_ack_n   , //读应答信号，低电平有效
    output reg          dri_clk         , //驱动时钟
    output reg          eth_mdc         , //MDC信号线
    inout wire          eth_mdio         //MDIO信号线
);

parameter   IDLE    =  6'b000_001,   // 空闲状态
            PRE     =  6'b000_010,   // PRE 
            START   =  6'b000_100,   // OP 和 START 阶段 读写不同
            ADDR    =  6'b001_000,   // PHY 及 REG 地址
            WR_DATA =  6'b010_000,   // TA + 写入写数据
            RD_DATA =  6'b100_000;   // TA + 读入读数据

parameter   OP_RD   =  2'b10,
            OP_WR   =  2'b01;

reg [5:0] cnt_dri ; // 用于生成驱动时钟 在
reg [6:0] cnt_bit ; // 记录当前一共传输了多少个bit 单数时候为mdc下降沿，双数为上升沿
reg [5:0] state   ; 
wire       mdio_in ; // mdio三态控制
reg       mdio_out; // mdio三态控制
reg       mdio_en ; // mdio三态控制 1 为输出，0为高阻态

reg [15:0] mdio_wr_data_reg ;
reg [4:0]  mdio_reg_addr_reg;
 
wire [5:0] clk_divide ; //Eth_mdc 的分配系数

assign clk_divide = CLK_FRE >> 1;

// 驱动时钟计时器
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        cnt_dri <= 1'b0;
    else if (cnt_dri == clk_divide[5:1] - 1'b1)
        cnt_dri <= 1'b0;
    else 
        cnt_dri <= cnt_dri + 1'b1;
end
// 驱动时钟dri_clk的赋值为MDC的2倍频 （此处为12.5MHz）
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        dri_clk <= 1'b0;
    else if (cnt_dri == clk_divide[5:1] - 1'b1)
        dri_clk <= ~dri_clk;
end

// 对输入数据进行寄存
always @(posedge dri_clk or negedge rst_n ) begin
    if (~rst_n) begin
        mdio_wr_data_reg <= 16'd0;
        mdio_reg_addr_reg <= 5'd0;
    end
    else if (mdio_start)begin
        mdio_wr_data_reg <= mdio_wr_data;
        mdio_reg_addr_reg <= mdio_reg_addr;
    end
end

// 状态机的跳转
always @(posedge dri_clk or negedge rst_n ) begin
    if (~rst_n)
        state <= IDLE;
    else begin
        case(state)
        IDLE   :
            if(mdio_start)
                state <= PRE;
            else 
                state <= IDLE;
        PRE    :
            if(cnt_bit == 7'd63)
                state <=  START;
            else 
                state <= PRE;
        START     :
            if (cnt_bit == 7'd7)
                state <=  ADDR;
            else 
                state <= START;
        ADDR   :
            if (cnt_bit == 7'd19  && mdio_rh_wl)
                state <=  RD_DATA;
            else if (cnt_bit == 7'd19  && ~mdio_rh_wl)
                state <=  WR_DATA;
            else 
                state <=  ADDR;
        WR_DATA :
            if (cnt_bit == 7'd39)
                state <= IDLE;
            else
                state <= WR_DATA;
        RD_DATA :
            if (cnt_bit == 7'd39)
                state <= IDLE;
            else
                state <= RD_DATA;
        default : state <= IDLE ;
        endcase
    end
end
// cnt_bit 的赋值
always @(posedge dri_clk or negedge rst_n ) begin
    if (~rst_n)
        cnt_bit <= 7'd0;
    else begin
        case(state)
            IDLE  :
                cnt_bit <= 7'd0;
            PRE   :
            if (cnt_bit == 7'd63)
                cnt_bit <= 7'd0;
            else
                cnt_bit <= cnt_bit + 1'b1;
            START  :
            if (cnt_bit == 7'd7)
                cnt_bit <= 7'd0;
            else
                cnt_bit <= cnt_bit + 1'b1;   
            ADDR   :
            if (cnt_bit == 7'd19)
                cnt_bit <= 7'd0;
            else
                cnt_bit <= cnt_bit + 1'b1;
            WR_DATA,RD_DATA:
            if (cnt_bit == 7'd39)
                cnt_bit <= 7'd0;
            else
                cnt_bit <= cnt_bit + 1'b1;
            default : ;
        endcase
    end
end
// eth_mdc MDC时钟赋值
always @(posedge dri_clk or negedge rst_n ) begin
    if (~rst_n)
        eth_mdc <= 1'b1;
    else if (~cnt_bit[0])
        eth_mdc <= 1'b1;
    else 
        eth_mdc <= 1'b0;
end

//mdio、mdio_done、rd_ack_n 的赋值
always @(posedge dri_clk or negedge rst_n ) begin
    if (~rst_n) begin
        mdio_out <= 1'b1;
        mdio_done <= 1'b0;
        mdio_rd_ack_n <= 1'b1;
        mdio_en  <= 1'b0;
    end
       
    else begin
        case(state)
            IDLE  : begin
                mdio_done <= 1'b0;
                mdio_en  <= 1'b0;
                mdio_out <= 1'b1;
                mdio_rd_ack_n <= 1'b1;
                mdio_rd_data <= 16'd0;
            end
            PRE   : begin
                mdio_en  <= 1'b1;
                mdio_out <= 1'b1;
            end
            START  : 
                case(cnt_bit)
                    7'd1 : mdio_out <= 1'b0;
                    7'd3 : mdio_out <= 1'b1;
                    7'd5 : 
                        if (mdio_rh_wl)
                            mdio_out <= OP_RD[1];
                        else if (~mdio_rh_wl)
                            mdio_out <= OP_WR[1];
                    7'd7 : 
                        if (mdio_rh_wl)
                            mdio_out <= OP_RD[0];
                        else if (~mdio_rh_wl)
                            mdio_out <= OP_WR[0];
                    default : ;
                endcase 
            ADDR   :
                case(cnt_bit)
                    7'd1  : mdio_out <= PHY_ADDR[4];
                    7'd3  : mdio_out <= PHY_ADDR[3];
                    7'd5  : mdio_out <= PHY_ADDR[2];
                    7'd7  : mdio_out <= PHY_ADDR[1];
                    7'd9  : mdio_out <= PHY_ADDR[0];
                    7'd11 : mdio_out <= mdio_reg_addr_reg[4];
                    7'd13 : mdio_out <= mdio_reg_addr_reg[3];
                    7'd15 : mdio_out <= mdio_reg_addr_reg[2];
                    7'd17 : mdio_out <= mdio_reg_addr_reg[1];
                    7'd19 : mdio_out <= mdio_reg_addr_reg[0];
                    default : ;
                endcase
            WR_DATA: begin
                case(cnt_bit) 
                    7'd1  : mdio_out <= 1'b1;
                    7'd3  : mdio_out <= 1'b0;
                    7'd5  : mdio_out <= mdio_wr_data_reg[15];
                    7'd7  : mdio_out <= mdio_wr_data_reg[14];
                    7'd9  : mdio_out <= mdio_wr_data_reg[13];
                    7'd11 : mdio_out <= mdio_wr_data_reg[12];
                    7'd13 : mdio_out <= mdio_wr_data_reg[11];
                    7'd15 : mdio_out <= mdio_wr_data_reg[10];
                    7'd17 : mdio_out <= mdio_wr_data_reg[9];
                    7'd19 : mdio_out <= mdio_wr_data_reg[8];
                    7'd21 : mdio_out <= mdio_wr_data_reg[7];
                    7'd23 : mdio_out <= mdio_wr_data_reg[6];
                    7'd25 : mdio_out <= mdio_wr_data_reg[5];
                    7'd27 : mdio_out <= mdio_wr_data_reg[4];
                    7'd29 : mdio_out <= mdio_wr_data_reg[3];
                    7'd31 : mdio_out <= mdio_wr_data_reg[2];
                    7'd33 : mdio_out <= mdio_wr_data_reg[1];
                    7'd35 : mdio_out <= mdio_wr_data_reg[0];
                    7'd37 : begin
                            mdio_en  <= 1'b0;
                            mdio_out <= 1'b1;
                        end
                    7'd39 : begin
                            mdio_out <= 1'b1;
                            mdio_done <= 1'b1;
                    end
                    default : ;
                endcase
            end
            RD_DATA: begin
                case(cnt_bit)    // 此处应该在上升沿采集数据
                    7'd1  : begin
                        mdio_out <= 1'b1;
                        mdio_en  <= 1'b0;
                    end
                    7'd2  : ;
                    7'd4  :mdio_rd_ack_n    <=  mdio_in ;
                    7'd6  :mdio_rd_data[15] <=  mdio_in ;
                    7'd8  :mdio_rd_data[14] <=  mdio_in ;
                    7'd10 :mdio_rd_data[13] <=  mdio_in ;
                    7'd12 :mdio_rd_data[12] <=  mdio_in ;
                    7'd14 :mdio_rd_data[11] <=  mdio_in ;
                    7'd16 :mdio_rd_data[10] <=  mdio_in ;
                    7'd18 :mdio_rd_data[9]  <=  mdio_in ;
                    7'd20 :mdio_rd_data[8]  <=  mdio_in ;
                    7'd22 :mdio_rd_data[7]  <=  mdio_in ;
                    7'd24 :mdio_rd_data[6]  <=  mdio_in ;
                    7'd26 :mdio_rd_data[5]  <=  mdio_in ;
                    7'd28 :mdio_rd_data[4]  <=  mdio_in ;
                    7'd30 :mdio_rd_data[3]  <=  mdio_in ;
                    7'd32 :mdio_rd_data[2]  <=  mdio_in ;
                    7'd34 :mdio_rd_data[1]  <=  mdio_in ;
                    7'd36 :mdio_rd_data[0]  <=  mdio_in ;
                    7'd39 :mdio_done <= 1'b1;
                    default : ;
                endcase
            end
                default : ;
        endcase
    end
end
assign eth_mdio = mdio_en ? mdio_out : 1'bz;
assign mdio_in  = eth_mdio;

endmodule