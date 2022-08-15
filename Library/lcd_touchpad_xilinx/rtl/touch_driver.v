module touch_driver 
#(
    parameter DEV_ADDR       =  7'h14       ,   // 器件地址
              ADDR_NUM       =  1'b1        ,   // 地址位数 1表示16位（与IIC匹配）
              STATE_REG_ADDR =  16'h814e    ,   // 状态寄存器地址
              LOC_START_ADDR =  16'h8150    ,   // 存放位置信息的起始地址
              CNT_MS_MAX     =  16'd49_999  ,
              IIC_GAP        =  13'd5_000   //计数器计满为1ms 、
)
(
    input  wire            clk             ,
    input  wire            rst_n           ,
    input  wire   [7:0]    i2c_data_in     ,
    input  wire            i2c_done_flag   ,

    output reg             wr_en           ,
    output wire   [6:0]    dev_addr        ,
    output wire   [15:0]   addr            ,
    output wire   [7:0]    wr_data         ,
    output reg             rd_en           ,
    output wire            addr_num        ,
    inout  wire            touch_init      ,
    output reg             touch_reset     ,
    output reg    [15:0]   touch_x_loc     ,
    output reg    [15:0]   touch_y_loc     ,
    output reg             touch_data_flag  
);

//定义状态机
parameter    IDLE       = 4'b0001 ,    // 空闲状态，再次状态下等待1ms后会进入至INIT状态
             INIT       = 4'b0010 ,    // 初始化状态，根据操作时序对期间进行初始化
             DETECT     = 4'b0100 ,    // 检测模式，每20ms对状态寄存器进行检测，有输入跳转至获取坐标状态
             GET_LOC    = 4'b1000 ;    // 获取坐标输出



reg  [15:0]   cnt_ms       ;    // 计数器计满为1ms
reg           cnt_ms_en    ;    // 计数器使能信号，为1时开始计数
reg  [3:0]    state        ;    // 状态机
reg  [7:0]    ms_count     ;    // 记录进行了多少ms
reg           touch_init_reg ;  // 寄存touch_init，用于三态控制
wire          touch_init_in  ;  // 寄存输入的touch_init 用于三态控制
reg  [4:0]    rd_data_cnt  ;    // 用于计数读取了多少个数据

reg  [7:0]    dev_state_reg;    // 寄存状态寄存器数据
reg           done_flag_reg;    // 对IIC完成信号进行打拍子
reg           rd_vaild     ;    // 读过程有效信号
reg           touch_valid  ;    // 触摸有效信号，检测到触摸信号后拉高
reg           wr_en_cnt_en ;    // 用于控制每次读完之后的写
reg  [15:0]   wr_en_cnt    ;
reg           rd_en_cnt_en ;    // 用于控制GET_LOC的读间隔
reg  [15:0]   rd_en_cnt    ;
reg           get_loc_wait_cnt_en ;    // 用于控制GET_LOC的读间隔
reg  [15:0]   get_loc_wait_cnt    ;

// cnt_ms 的赋值
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        cnt_ms <= 16'd0;
    else if (cnt_ms_en && cnt_ms == CNT_MS_MAX)
        cnt_ms <= 16'd0;
    else if (cnt_ms_en)
        cnt_ms <= cnt_ms + 1'b1;
    else 
        cnt_ms <= 1'b0;    
end

// cnt_ms_en 的赋值
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        cnt_ms_en <= 1'b0;
    else 
        case(state)
            IDLE,INIT: cnt_ms_en <= 1'b1;
            DETECT   :     // 发出一次读使能信号后，拉低，等到读取完成后再拉高，若读取到有效数据，则拉低。
                if (rd_vaild)
                    cnt_ms_en <= 1'b0;   
                else if (touch_valid)
                    cnt_ms_en <= 1'b0;
                else
                    cnt_ms_en <= 1'b1;
            GET_LOC: 
                    cnt_ms_en <= 1'b0;
            default: cnt_ms_en <= 1'b0;
        endcase 
end

// ms_count 赋值 
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        ms_count <= 8'b0;
    else if ((state == IDLE && cnt_ms == CNT_MS_MAX) ||
             (state == INIT && ms_count == 8'd74 && cnt_ms == CNT_MS_MAX )||
             (state == DETECT && ms_count == 8'd19 && cnt_ms == CNT_MS_MAX) ||
             (~cnt_ms_en))
        ms_count <= 8'b0; 
    else if (cnt_ms == CNT_MS_MAX)
        ms_count <= ms_count + 1'b1;
end

// 状态机的跳转
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        state <= IDLE;
    else begin
        case(state)
            IDLE:
                if(cnt_ms == CNT_MS_MAX)      // 上电等待1ms 后跳转
                    state <= INIT;
                else 
                    state <= IDLE;
            INIT:
                if (cnt_ms == CNT_MS_MAX && ms_count == 8'd74)  // 完成初始信号并且RESET拉高60秒后跳转
                    state <= DETECT;
                else 
                    state <= INIT;
            DETECT:
                if (touch_valid && done_flag_reg)   // 当触摸信号有效且写操作完成后跳转
                    state <= GET_LOC;
                else 
                    state <= DETECT; 
            GET_LOC:                                // 当获取到坐标数据后跳转
                if (touch_data_flag)
                    state <= DETECT;
                else 
                    state <= GET_LOC;
            default:state <= IDLE;
        endcase
    end
end

//get_loc_flag 进入get_loc状态后等待100us再进行读取
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        get_loc_wait_cnt_en <= 1'b0;
    else if (state == DETECT && touch_valid && done_flag_reg)
        get_loc_wait_cnt_en <= 1'b1;
    else if (wr_en_cnt == IIC_GAP)
        get_loc_wait_cnt_en <= 1'b0;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
       get_loc_wait_cnt <= 16'd0;
    else if (get_loc_wait_cnt_en && get_loc_wait_cnt == IIC_GAP)
       get_loc_wait_cnt <= 16'd0;
    else if (get_loc_wait_cnt_en)
       get_loc_wait_cnt <= get_loc_wait_cnt + 1'b1;
end

// touch_reset 赋值  在INIT阶段等待15秒后便拉高。之后不再改变
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        touch_reset  <= 1'b0;
    else if (state == INIT && ms_count == 8'd14 && cnt_ms == CNT_MS_MAX)
        touch_reset  <= 1'b1;
end




// touch_init的赋值
//（通过touch_init_reg来实现三态控制）
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        touch_init_reg <= 1'b0;
    else if((state == INIT && ms_count <= 19) ||
            (state == INIT && ms_count >= 25 && ms_count <= 29)||
            (state == INIT && ms_count >= 35))
        touch_init_reg <= 1'b1;
    else if (state == INIT)
        touch_init_reg <= 1'b0;
end

// touch_init 的三态控制
assign touch_init    = (state == IDLE || state == INIT)? touch_init_reg : 1'bz;
assign touch_init_in = touch_init;

// 读使能rd_en信号的赋值
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        rd_en <= 1'b0;
    else if ((state == DETECT && cnt_ms == CNT_MS_MAX && ms_count == 8'd19) ||
             (state == GET_LOC && get_loc_wait_cnt_en && get_loc_wait_cnt == IIC_GAP) ||
             (state == GET_LOC && rd_en_cnt_en && rd_en_cnt == IIC_GAP && rd_data_cnt <= 2))
        rd_en <= 1'b1;
    else
        rd_en <= 1'b0;
end

// 读有效信号（用于控制在DETECT期间读取状态寄存器后都对状态寄存器进行清零）
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        rd_vaild <= 1'b0;
    else if (state == DETECT && rd_en)
        rd_vaild <= 1'b1;
    else if (i2c_done_flag)
        rd_vaild <= 1'b0;
    else 
        rd_vaild <= rd_vaild;
end

// 当检测到读信号完成时，写使能信号计数开始，准备发送写信号
// 读完成后延时100us进行IIC写，把数据清零
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        wr_en_cnt_en <= 1'b0;
    else if (rd_vaild && i2c_done_flag)
        wr_en_cnt_en <= 1'b1;
    else if (wr_en_cnt == IIC_GAP)
        wr_en_cnt_en <= 1'b0;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        wr_en_cnt <= 16'd0;
    else if (wr_en_cnt_en && wr_en_cnt == IIC_GAP)
        wr_en_cnt <= 16'd0;
    else if (wr_en_cnt_en)
        wr_en_cnt <= wr_en_cnt + 1'b1;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        wr_en <= 1'b0;
    else if (wr_en_cnt_en && wr_en_cnt == IIC_GAP )
        wr_en <= 1'b1;
    else
        wr_en <= 1'b0;
end

// 在GET_LOC阶段的读使能信号之间的间隔同样为100us
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        rd_en_cnt_en <= 1'b0;
    else if (state == GET_LOC && i2c_done_flag)
        rd_en_cnt_en <= 1'b1;
    else if (rd_en_cnt == IIC_GAP)
        rd_en_cnt_en <= 1'b0;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        rd_en_cnt <= 16'd0;
    else if (rd_en_cnt_en && rd_en_cnt == IIC_GAP)
        rd_en_cnt <= 16'd0;
    else if (rd_en_cnt_en)
        rd_en_cnt <= rd_en_cnt + 1'b1;
end


// 读写地址的赋值
assign addr = ( state == GET_LOC )? LOC_START_ADDR + rd_data_cnt : STATE_REG_ADDR;
assign wr_data = 8'b0;

// 状态寄存器数据
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        dev_state_reg <= 8'b0;
    else if (state == DETECT && rd_vaild && i2c_done_flag)
        dev_state_reg <= i2c_data_in;
    else if (state == GET_LOC)
        dev_state_reg <= 8'b0;
end

// 对I2c完成信号进行打拍 用作后续的判断标志
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        done_flag_reg <= 1'b0;
    else 
        done_flag_reg <= i2c_done_flag;
end

// 触摸有效信号的判断
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        touch_valid <= 1'b0;
    else if (state == DETECT && done_flag_reg && dev_state_reg[7] == 1'b1 && dev_state_reg[3:0] >= 4'd1 && dev_state_reg[3:0] <= 4'd5)
        touch_valid <= 1'b1;
    else if (state == GET_LOC)
        touch_valid <= 1'b0;             
end


// rd_data_cnt 赋值
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        rd_data_cnt <= 5'd0;
    else if (state == GET_LOC && touch_data_flag)
        rd_data_cnt <= 5'd0; 
    else if (state == GET_LOC && i2c_done_flag)
        rd_data_cnt <= rd_data_cnt + 1'b1;
end

// touch_x_loc 赋值
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        touch_x_loc <= 16'b0;
    else if (state == GET_LOC && i2c_done_flag && rd_data_cnt == 5'd0)
        touch_x_loc[7:0]  <=  i2c_data_in;
    else if (state == GET_LOC && i2c_done_flag && rd_data_cnt == 5'd1)
        touch_x_loc[15:8] <=  i2c_data_in;
end
// touch_y_loc
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        touch_y_loc <= 16'b0;
    else if (state == GET_LOC && i2c_done_flag && rd_data_cnt == 5'd2)
        touch_y_loc[7:0]  <=  i2c_data_in;
    else if (state == GET_LOC && i2c_done_flag && rd_data_cnt == 5'd3)
        touch_y_loc[15:8] <=  i2c_data_in;
end
// touch_data_flag 赋值
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        touch_data_flag <= 1'b0;
    else if (state == GET_LOC && done_flag_reg && rd_data_cnt == 5'd4)
        touch_data_flag <= 1'b1;
    else 
        touch_data_flag <= 1'b0;
end

assign dev_addr = DEV_ADDR;
assign addr_num = ADDR_NUM;

endmodule