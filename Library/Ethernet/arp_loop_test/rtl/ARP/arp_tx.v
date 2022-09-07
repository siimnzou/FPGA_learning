/*--------------------------------------------------------------------------------------
    创建时间：2022/9/6 16:00
    器件: Xilinx xc7z020clg400-2
    模块名：arp_tx
    所属工程：ethernet
    版本：V1.0
    
    介绍：
    ARP协议 中的 ARP发送模块
--------------------------------------------------------------------------------------*/
module arp_tx
#(
    parameter   BOARD_MAC = 48'h00_11_22_33_44_55,                  //开发版MAC
                BOARD_IP  = {8'd192,8'd168,8'd1,8'd10},             //开发板IP
                DES_MAC   = 48'hff_ff_ff_ff_ff_ff,                  //目的MAC
                DES_IP    = {8'd192,8'd168,8'd1,8'd102}             //目的IP
)
(
    input   wire            clk            , //时钟信号
    input   wire            rst_n          , //复位信号，低电平有效

    input   wire            arp_tx_en      , //ARP发送使能信号
    input   wire            arp_tx_type    , //ARP发送类别? 0:请求  1:应答
    input   wire    [47:0]  des_mac        , //发送的目标MAC地址
    input   wire    [31:0]  des_ip         , //发送的目标IP地址
    input   wire    [31:0]  crc_data       , //CRC校验数据
    input   wire    [7:0]   crc_next       , //CRC下次校验完成数据
    output  reg             arp_tx_done    , //以太网发送完成信号
    output  reg             gmii_tx_dv     , //GMII输出数据有效信号
    output  reg     [7:0]   gmii_tx_data   , //GMII输出数据
    output  reg             crc_en         , //CRC开始校验使能
    output  reg             crc_clr          //CRC数据复位信号 
);

parameter       IDLE    =    5'b00001,
                PRE     =    5'b00010,
                HEAD    =    5'b00100,
                DATA    =    5'b01000,
                CRC     =    5'b10000;

localparam  ETH_TYPE     = 16'h0806 ; //以太网帧类型 ARP协议
localparam  HD_TYPE      = 16'h0001 ; //硬件类型 以太网
localparam  PROTOCOL_TYPE= 16'h0800 ; //上层协议为IP协议

reg       [4:0]      state          ;
reg       [6:0]      cnt_byte       ;
reg                  arp_tx_en_ff   ;    // 用于提取其上升沿
reg                  arp_tx_en_ff2  ;    // 用于提取其上升沿
wire                 arp_tx_flag    ;

reg  [7:0]  preamble[7:0] ; //前导码+SFD
reg  [7:0]  eth_head[13:0]; //HEAD
reg  [7:0]  arp_data[27:0]; //ARP数据

// 提取 arp_tx_en 的上升沿
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        arp_tx_en_ff  <= 1'b0;
        arp_tx_en_ff2 <= 1'b0;
    end
    else begin
        arp_tx_en_ff  <= arp_tx_en;
        arp_tx_en_ff2 <= arp_tx_en_ff;
    end
end

assign arp_tx_flag = arp_tx_en_ff && ~arp_tx_en_ff2;

//  gmii_tx_dv 赋值
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        gmii_tx_dv <= 1'b0;
    else if (state == CRC && cnt_byte == 6'd4)
        gmii_tx_dv <= 1'b0;
    else if (arp_tx_flag)    
        gmii_tx_dv <= 1'b1;   
end

//  发送数据初始化 以及赋值
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        // 前导码
        preamble[0] <= 8'h55;
        preamble[1] <= 8'h55;
        preamble[2] <= 8'h55;
        preamble[3] <= 8'h55;
        preamble[4] <= 8'h55;
        preamble[5] <= 8'h55;
        preamble[6] <= 8'h55;
        preamble[7] <= 8'hd5;
        // 帧头
        eth_head[0]  <= DES_MAC[47:40]    ;      //目的MAC地址
        eth_head[1]  <= DES_MAC[39:32]    ;
        eth_head[2]  <= DES_MAC[31:24]    ;
        eth_head[3]  <= DES_MAC[23:16]    ;
        eth_head[4]  <= DES_MAC[15:8]     ;
        eth_head[5]  <= DES_MAC[7:0]      ;        
        eth_head[6]  <= BOARD_MAC[47:40]  ;    //源MAC地址
        eth_head[7]  <= BOARD_MAC[39:32]  ;    
        eth_head[8]  <= BOARD_MAC[31:24]  ;    
        eth_head[9]  <= BOARD_MAC[23:16]  ;    
        eth_head[10] <= BOARD_MAC[15:8]   ;    
        eth_head[11] <= BOARD_MAC[7:0]    ;     
        eth_head[12] <= ETH_TYPE[15:8]    ;     //以太网帧类型
        eth_head[13] <= ETH_TYPE[7:0]     ;    
        // 以太网数据
        arp_data[0]  <=   HD_TYPE[15:8]        ;    //硬件类型
        arp_data[1]  <=   HD_TYPE[7:0]         ;
        arp_data[2]  <=   PROTOCOL_TYPE[15:8]  ;    //上层协议类型
        arp_data[3]  <=   PROTOCOL_TYPE[7:0]   ;
        arp_data[4]  <=   8'h06                ;    //硬件地址长度,6
        arp_data[5]  <=   8'h04                ;    //协议地址长度,4
        arp_data[6]  <=   8'h00                ;    //OP,操作码 8'h01：ARP请求 8'h02:ARP应答
        arp_data[7]  <=   8'h01                ;
        arp_data[8]  <=   BOARD_MAC[47:40]     ;    //发送端MAC地址
        arp_data[9]  <=   BOARD_MAC[39:32]     ;
        arp_data[10] <=   BOARD_MAC[31:24]     ;
        arp_data[11] <=   BOARD_MAC[23:16]     ;
        arp_data[12] <=   BOARD_MAC[15:8]      ;
        arp_data[13] <=   BOARD_MAC[7:0]       ;
        arp_data[14] <=   BOARD_IP[31:24]      ;    //发送端IP地址
        arp_data[15] <=   BOARD_IP[23:16]      ;
        arp_data[16] <=   BOARD_IP[15:8]       ;
        arp_data[17] <=   BOARD_IP[7:0]        ;
        arp_data[18] <=   DES_MAC[47:40]       ;     //(目的)MAC地址
        arp_data[19] <=   DES_MAC[39:32]       ;
        arp_data[20] <=   DES_MAC[31:24]       ;
        arp_data[21] <=   DES_MAC[23:16]       ;
        arp_data[22] <=   DES_MAC[15:8]        ;
        arp_data[23] <=   DES_MAC[7:0]         ;  
        arp_data[24] <=   DES_IP[31:24]        ;      //(目的)IP地址
        arp_data[25] <=   DES_IP[23:16]        ;
        arp_data[26] <=   DES_IP[15:8]         ;
        arp_data[27] <=   DES_IP[7:0]          ;  
    end
    // 当目的MAC和IP地址不为0时
    else if (state == IDLE && ((des_mac != 48'b0) || (des_ip != 32'd0))) begin
        eth_head[0]  <= des_mac[47:40];
        eth_head[1]  <= des_mac[39:32];
        eth_head[2]  <= des_mac[31:24];
        eth_head[3]  <= des_mac[23:16];
        eth_head[4]  <= des_mac[15:8];
        eth_head[5]  <= des_mac[7:0];  
        arp_data[18] <= des_mac[47:40];
        arp_data[19] <= des_mac[39:32];
        arp_data[20] <= des_mac[31:24];
        arp_data[21] <= des_mac[23:16];
        arp_data[22] <= des_mac[15:8];
        arp_data[23] <= des_mac[7:0];  
        arp_data[24] <= des_ip[31:24];
        arp_data[25] <= des_ip[23:16];
        arp_data[26] <= des_ip[15:8];
        arp_data[27] <= des_ip[7:0];
    end  
    else if (state == IDLE && arp_tx_type == 1'b0)
        arp_data[7] <= 8'h01;
    else if (state == IDLE && arp_tx_type == 1'b1)
        arp_data[7] <= 8'h02;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        cnt_byte <= 6'd0;
        gmii_tx_data <= 8'h0;
    end 
    else begin
        case(state) 
            IDLE :  
                begin
                    cnt_byte <= 6'd0;
                    gmii_tx_data <= 8'h0;
                end 
            PRE  : 
                begin
                    gmii_tx_data <= preamble[cnt_byte];
                    if(cnt_byte == 6'd7) begin
                        cnt_byte <= 6'd0;
                    end
                    else 
                        cnt_byte <= cnt_byte + 1'b1;
                end 
            HEAD :
                begin
                    gmii_tx_data <= eth_head[cnt_byte];
                    if(cnt_byte == 6'd13)
                        cnt_byte <= 6'd0;
                    else 
                        cnt_byte <= cnt_byte + 1'b1;
                end
            DATA : begin
                    if (cnt_byte <= 6'd27)
                        gmii_tx_data <= arp_data[cnt_byte];
                    else 
                        gmii_tx_data <= 8'h0;
    
                    if(cnt_byte == 6'd45)
                        cnt_byte <= 6'd0;
                    else 
                        cnt_byte <= cnt_byte + 1'b1;
                end
            CRC  :  
                begin
                    if(cnt_byte == 6'd0)
                        gmii_tx_data <= {~crc_next[0], ~crc_next[1], ~crc_next[2],~crc_next[3],
                                     ~crc_next[4], ~crc_next[5], ~crc_next[6],~crc_next[7]};
                    else if(cnt_byte == 6'd1)
                        gmii_tx_data <= {~crc_data[16], ~crc_data[17], ~crc_data[18],
                                     ~crc_data[19], ~crc_data[20], ~crc_data[21], 
                                     ~crc_data[22],~crc_data[23]};
                    else if(cnt_byte == 6'd2) 
                        gmii_tx_data <= {~crc_data[8], ~crc_data[9], ~crc_data[10],
                                     ~crc_data[11],~crc_data[12], ~crc_data[13], 
                                     ~crc_data[14],~crc_data[15]};                              
                    else if(cnt_byte == 6'd3) 
                        gmii_tx_data <= {~crc_data[0], ~crc_data[1], ~crc_data[2],~crc_data[3],
                                     ~crc_data[4], ~crc_data[5], ~crc_data[6],~crc_data[7]};
    
                    if(cnt_byte == 6'd4)
                        cnt_byte <= 6'd0;
                    else 
                        cnt_byte <= cnt_byte + 1'b1;            
                end
            default : ;
        endcase
    end
end
// crc_en 赋值
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        crc_en <= 1'b0;
    else if (state == HEAD && cnt_byte == 6'd0)
        crc_en <= 1'b1;
    else if (state == CRC && cnt_byte == 6'd0)    
        crc_en <= 1'b0;   
end

// crc_clr 以及 arp_tx_done赋值
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        crc_clr      <= 1'b0;
        arp_tx_done  <= 1'b0;
    end
    else if (state == CRC && cnt_byte == 6'd4) begin   
        crc_clr      <= 1'b1;
        arp_tx_done  <= 1'b1;
    end
end


// 状态机跳转
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        state <= IDLE;
    else begin
        case(state)
            IDLE  : 
                if(arp_tx_flag)
                    state <= PRE;
                else 
                    state <= IDLE;
            PRE   :
                if (cnt_byte == 6'd7)
                    state <= HEAD;
                else 
                    state <= PRE;
            HEAD   :
                if (cnt_byte == 6'd13)
                    state <= DATA;
                else 
                    state <= HEAD;    
            DATA   :
                if (cnt_byte == 6'd45)
                    state <= CRC;
                else 
                    state <= DATA;
            CRC   :
                if (cnt_byte == 6'd4)
                    state <= IDLE;
                else 
                    state <= CRC;                    
        endcase
    end
end

endmodule