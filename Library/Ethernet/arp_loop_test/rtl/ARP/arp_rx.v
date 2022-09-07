/*--------------------------------------------------------------------------------------
    创建时间：2022/8/21 22:00
    器件: Xilinx xc7z020clg400-2
    模块名：arp_rx
    所属工程：ethernet
    版本：V1.0
    
    介绍：
    ARP协议 中的 ARP接受模块
--------------------------------------------------------------------------------------*/
module arp_rx
#(   
    parameter   BOARD_MAC = 48'h00_11_22_33_44_55,          // 开发板MAC地址
                BOARD_IP  = {8'd192,8'd168,8'd1,8'd10}      // 开发板IP地址
)
(
    input  wire          clk         ,
    input  wire          rst_n       ,
    input  wire          gmii_rx_dv  ,   // 输入的数据有效信号
    input  wire   [7:0]  gmii_rx_data,   // 输入数据
    output reg           arp_rx_done ,   // 接受完成信号
    output reg           arp_rx_type ,   // 接受到的类型 0：请求 1：应答
    output reg  [47:0]   source_mac  ,   // 源MAC地址
    output reg  [31:0]   source_ip       // 源IO地址
);

parameter     IDLE  =  5'b00001,        // 空闲状态
              PRE   =  5'b00010,        // 前导码和SFD解析
              HEAD  =  5'b00100,        // 以太网帧头
              DATA  =  5'b01000,        // APR数据接受
              WAIT  =  5'b10000;        // 等待数据接受完毕

parameter     ETH_TPYE = 16'h0806;     //以太网帧类型 ARP              

reg    [4:0]     state         ;
reg    [5:0]     cnt_byte      ;   // 记录当前数据的比特数
reg    [47:0]    des_mac_reg   ;   // 寄存帧头以及ARP中的目的MAC地址
reg    [31:0]    des_ip_reg    ;   // 寄存APR协议中的目的IP地址
reg    [7:0]     eth_type_high ;   // 寄存以太网类型的高8位
reg    [15:0]    op_data_reg   ;   // 寄存ARP协议中的OP操作字
reg    [47:0]    source_mac_reg;   // 寄存ARP协议中的源MAC地址
reg    [31:0]    source_ip_reg ;   // 寄存ARP协议中的源IP地址
 
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        state <= IDLE;
    else begin
        case(state)
            IDLE :  
                if (gmii_rx_dv && gmii_rx_data == 8'h55)
                    state <= PRE;
                else 
                    state <= IDLE;
            PRE  :
                // 校验前导码是否全为11
                if ((cnt_byte <= 6'd5 && gmii_rx_data != 8'h55) ||
                // 校验SFD码是否为 8'hd5
                    (cnt_byte == 6'd6 && gmii_rx_data != 8'hd5))
                    state <= WAIT;
                else if (cnt_byte == 6'd6 && gmii_rx_data == 8'hd5)
                    state <= HEAD;
                else 
                    state <= PRE;
            HEAD :   
                // 校验目的MAC地址是否为板子地址MAC或者广播MAC地址
                if ((cnt_byte == 6'd6 && des_mac_reg != BOARD_MAC && des_mac_reg != 48'hff_ff_ff_ff_ff_ff) ||  
                // 校验类型是否为ARP类型
                    (cnt_byte == 6'd13 && eth_type_high != 8'h08)||
                    (cnt_byte == 6'd13 && gmii_rx_data != 8'h06))
                    state <= WAIT;
                else if (cnt_byte == 6'd13 && eth_type_high == 8'h08 && gmii_rx_data == 8'h06)
                    state <= DATA;
                else
                    state <= HEAD;
            DATA : 
                // 28位数据接受完成后进行跳转 （包含等待一个时钟周期）
                if (cnt_byte == 6'd28)
                    state <= WAIT;
                else 
                    state <= DATA;
            WAIT :
                if (~gmii_rx_dv)
                    state <= IDLE;
                else 
                    state <= WAIT;
            default: state <= IDLE;
        endcase 
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        cnt_byte <= 6'd0;
    else case(state)
        IDLE,WAIT : cnt_byte <= 6'd0;
        PRE  : 
            if(cnt_byte == 6'd6)
                cnt_byte <= 6'd0;
            else 
                cnt_byte <= cnt_byte + 1'b1;
        HEAD :
            if(cnt_byte == 6'd13)
                cnt_byte <= 6'd0;
            else 
                cnt_byte <= cnt_byte + 1'b1;
        DATA :
            if(cnt_byte == 6'd28)
                cnt_byte <= 6'd0;
            else 
                cnt_byte <= cnt_byte + 1'b1;
        default : ;
    endcase
end

// 当 STATE == DATA cnt == 28 且目标IP为本机IP时候对所有值进行赋值
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        arp_rx_done <= 1'b0;
        arp_rx_type <= 1'b0;
        source_mac  <= 48'h0;
        source_ip   <= 32'h0;
    end
    else if (state == IDLE) begin
        arp_rx_done <= 1'b0;
        arp_rx_type <= 1'b0;
        source_mac  <= 48'h0;
        source_ip   <= 32'h0;
    end
    else if (state == DATA && cnt_byte == 6'd28 && des_ip_reg == BOARD_IP) begin
        arp_rx_done <= 1'b1;
        source_mac  <= source_mac_reg;
        source_ip   <= source_ip_reg;
        if (op_data_reg ==  16'd1)
            arp_rx_type <= 1'b0;
        else if (op_data_reg == 16'd2)
            arp_rx_type <=  1'b1;
    end
end

// 目的MAC地址的赋值 （高位在前）以及ARP协议中的目的MAC地址
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        des_mac_reg <= 48'h0;
    else if (state == WAIT)
        des_mac_reg <= 48'h0;
    else if (state == HEAD && cnt_byte <= 6'd5 )
        des_mac_reg <= {des_mac_reg[39:0],gmii_rx_data};
end
// 以太网类型高位寄存器的赋值
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        eth_type_high <= 8'h0;
    else if (state == WAIT)
        eth_type_high <= 8'h0;
    else if (state == HEAD && cnt_byte == 6'd12)
        eth_type_high <= gmii_rx_data;
end
// ARP协议中的OP操作字
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        op_data_reg <= 16'h0;
    else if (state == WAIT)
        op_data_reg <= 16'h0;
    else if (state == DATA && cnt_byte >= 6'd6 && cnt_byte <= 6'd7)
        op_data_reg <= {op_data_reg[7:0],gmii_rx_data};
end
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        source_mac_reg <= 48'h0;
    else if (state == WAIT)
        source_mac_reg <= 48'h0;
    else if (state == DATA && cnt_byte >= 5'd8 && cnt_byte <= 5'd13)
        source_mac_reg <= {source_mac_reg[39:0],gmii_rx_data};
end
// ARP协议中的源IP地址
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        source_ip_reg <= 32'h0;
    else if (state == WAIT)
        source_ip_reg <= 32'h0;
    else if (state == DATA && cnt_byte >= 6'd14 && cnt_byte <= 6'd17)
        source_ip_reg <= {source_ip_reg[23:0],gmii_rx_data};
end
// ARP协议中的目的IP地址
always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        des_ip_reg <= 32'h0;
    else if (state == WAIT)
        des_ip_reg <= 32'h0;
    else if (state == DATA && cnt_byte >= 6'd24 && cnt_byte <= 6'd27)
        des_ip_reg <= {des_ip_reg[23:0],gmii_rx_data};
end
endmodule