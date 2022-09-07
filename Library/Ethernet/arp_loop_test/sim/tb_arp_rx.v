/*--------------------------------------------------------------------------------------
    创建时间：2022/8/21 22:00
    器件: Xilinx xc7z020clg400-2
    模块名：tb_arp_rx
    所属工程：ethernet
    版本：V1.0
    
    介绍：
    arp_rx 模块测试代码
--------------------------------------------------------------------------------------*/
`timescale  1ns/1ns
module tb_arp_rx();

parameter SRC_MAC_1 = 48'h12_34_56_78_90;
parameter SRC_IP_1  = {8'd192,8'd168,8'd1,8'd100};
parameter SRC_MAC_2 = 48'h98_76_54_32_10;
parameter SRC_IP_2  = {8'd192,8'd168,8'd1,8'd200};
parameter ETH_ARP   = 16'h0806;

parameter   BOARD_MAC = 48'h00_11_22_33_44_55,          // 开发板MAC地址
            BOARD_IP  = {8'd192,8'd168,8'd1,8'd10};      // 开发板IP地址

reg          clk         ;
reg          rst_n       ;
reg          gmii_rx_dv  ;
reg   [7:0]  gmii_rx_data;

reg   [6:0]  cnt_byte    ;  // 用于生成帧数据
reg   [3:0]  cnt_frame   ;  // 记录当前发送的帧包数

wire           arp_rx_done;
wire           arp_rx_type;
wire  [47:0]   source_mac ;
wire  [31:0]   source_ip  ;

initial begin
    clk = 1'b1;
    rst_n <= 1'b0;
    #300 
    rst_n <= 1'b1;
end

always #10 clk = ~clk;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        cnt_byte <=  7'd0;
    else if (cnt_byte == 7'd80)
        cnt_byte <=  7'd0;
    else
        cnt_byte <= cnt_byte + 1'b1;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        cnt_frame <=  4'd0;
    else if (cnt_byte == 7'd80 && cnt_frame == 4'd7)
        cnt_frame <=  4'd0;
    else if (cnt_byte == 7'd80)
        cnt_frame <= cnt_frame + 1'b1;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        gmii_rx_dv <=  1'b0;
    else if (cnt_byte == 7'd74)
        gmii_rx_dv <=  1'b0;
    else if (cnt_byte == 7'd1)
        gmii_rx_dv <=  1'b1;
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n)
        gmii_rx_data <= 8'h0;
    // 源MAC地址赋值
    else if (cnt_byte >= 7'd15 && cnt_byte <= 7'd20) begin
        case(cnt_byte)
            7'd15 : gmii_rx_data <= SRC_MAC_1[47:40];
            7'd16 : gmii_rx_data <= SRC_MAC_1[39:32];
            7'd17 : gmii_rx_data <= SRC_MAC_1[31:24];
            7'd18 : gmii_rx_data <= SRC_MAC_1[23:16];
            7'd19 : gmii_rx_data <= SRC_MAC_1[15:8];
            7'd20 : gmii_rx_data <= SRC_MAC_1[7:0];
            default : ;
        endcase
    end
    else if (cnt_byte >= 7'd31 && cnt_byte <= 7'd36) begin
        case(cnt_byte)
            7'd31 : gmii_rx_data <= SRC_MAC_1[47:40];
            7'd32 : gmii_rx_data <= SRC_MAC_1[39:32];
            7'd33 : gmii_rx_data <= SRC_MAC_1[31:24];
            7'd34 : gmii_rx_data <= SRC_MAC_1[23:16];
            7'd35 : gmii_rx_data <= SRC_MAC_1[15:8];
            7'd36 : gmii_rx_data <= SRC_MAC_1[7:0];
            default : ;
        endcase
    end
    // 源IP地址赋值
    else if (cnt_byte >= 7'd37 && cnt_byte <= 7'd40) begin
            case(cnt_byte)
                7'd37 : gmii_rx_data <= SRC_IP_1[31:24];
                7'd38 : gmii_rx_data <= SRC_IP_1[23:16];
                7'd39 : gmii_rx_data <= SRC_IP_1[15:8];
                7'd40 : gmii_rx_data <= SRC_IP_1[7:0];
                default : ;
            endcase
        end
    else begin
        case (cnt_frame)
            4'd0:  // 前导码错误
                if (cnt_byte <= 7'd4)
                    gmii_rx_data <= 8'h55;
                else 
                    gmii_rx_data <= {$random} % 256;
            4'd1:  // SFD错误
                if (cnt_byte <= 7'd7)
                    gmii_rx_data <= 8'h55;
                else if (cnt_byte == 7'd8)
                    gmii_rx_data <= 8'h48;
                else 
                    gmii_rx_data <= {$random} % 256;
            4'd2:  // 目的MAC地址错误
                if (cnt_byte <= 7'd7)
                    gmii_rx_data <= 8'h55;
                else if (cnt_byte == 7'd8)
                    gmii_rx_data <= 8'hd5;
                else if (cnt_byte >= 7'd9 && cnt_byte <= 7'd12)
                    gmii_rx_data <= 8'hff;
                else 
                    gmii_rx_data <= {$random} % 256;
            4'd3:  // 类型错误
                if (cnt_byte <= 7'd7)
                    gmii_rx_data <= 8'h55;
                else if (cnt_byte == 7'd8)
                    gmii_rx_data <= 8'hd5;
                else if (cnt_byte >= 7'd9 && cnt_byte <= 7'd14)
                    gmii_rx_data <= 8'hff;
                else
                    gmii_rx_data <= {$random} % 256;
            4'd4:  // 目的IP地址错误
                if (cnt_byte <= 7'd7)
                    gmii_rx_data <= 8'h55;
                else if (cnt_byte == 7'd8)
                    gmii_rx_data <= 8'hd5;
                else if (cnt_byte >= 7'd9 && cnt_byte <= 7'd14)
                    gmii_rx_data <= 8'hff;
                else if (cnt_byte == 7'd21)
                    gmii_rx_data <= 8'h08;
                else if (cnt_byte == 7'd22)
                    gmii_rx_data <= 8'd06;
                else if (cnt_byte == 7'd29)
                    gmii_rx_data <= 8'd00;
                else if (cnt_byte == 7'd30)
                    gmii_rx_data <= 8'd01;
                else 
                    gmii_rx_data <= {$random} % 256;
            4'd5:  // 正确，目标MAC为广播
                if (cnt_byte <= 7'd7)
                    gmii_rx_data <= 8'h55;
                else if (cnt_byte == 7'd8)
                    gmii_rx_data <= 8'hd5;
                else if (cnt_byte >= 7'd9 && cnt_byte <= 7'd14)
                    gmii_rx_data <= 8'hff;
                else if (cnt_byte == 7'd21)
                    gmii_rx_data <= 8'h08;
                else if (cnt_byte == 7'd22)
                    gmii_rx_data <= 8'd06;
                else if (cnt_byte == 7'd29)
                    gmii_rx_data <= 8'd00;
                else if (cnt_byte == 7'd30)
                    gmii_rx_data <= 8'd01;
                else if (cnt_byte == 7'd47)
                    gmii_rx_data <= BOARD_IP[31:24];
                else if (cnt_byte == 7'd48)
                    gmii_rx_data <= BOARD_IP[23:16];
                else if (cnt_byte == 7'd49)                
                    gmii_rx_data <= BOARD_IP[15:8];
                else if (cnt_byte == 7'd50)                
                    gmii_rx_data <= BOARD_IP[7:0];
            4'd6:  // 正确，目标MAC为开发板MAC地址
                if (cnt_byte <= 7'd7)
                    gmii_rx_data <= 8'h55;
                else if (cnt_byte == 7'd8)
                    gmii_rx_data <= 8'hd5;
                else if (cnt_byte >= 7'd9 && cnt_byte <= 7'd14) begin
                    case(cnt_byte)
                        7'd9 :gmii_rx_data <= BOARD_MAC[47:40];
                        7'd10 :gmii_rx_data <= BOARD_MAC[39:32];
                        7'd11 :gmii_rx_data <= BOARD_MAC[31:24];
                        7'd12 :gmii_rx_data <= BOARD_MAC[23:16];
                        7'd13 :gmii_rx_data <= BOARD_MAC[15:8];
                        7'd14 :gmii_rx_data <= BOARD_MAC[7:0];
                        default : ;           
                    endcase
                end
                else if (cnt_byte == 7'd21)
                    gmii_rx_data <= 8'h08;
                else if (cnt_byte == 7'd22)
                    gmii_rx_data <= 8'd06;
                else if (cnt_byte == 7'd29)
                    gmii_rx_data <= 8'd00;
                else if (cnt_byte == 7'd30)
                    gmii_rx_data <= 8'd01;
                else if (cnt_byte == 7'd47)
                    gmii_rx_data <= BOARD_IP[31:24];
                else if (cnt_byte == 7'd48)
                    gmii_rx_data <= BOARD_IP[23:16];
                else if (cnt_byte == 7'd49)                
                    gmii_rx_data <= BOARD_IP[15:8];
                else if (cnt_byte == 7'd50)                
                    gmii_rx_data <= BOARD_IP[7:0];
            4'd7: ;
            default : ;
        endcase
    end
end

arp_rx
#(   
    .BOARD_MAC (48'h00_11_22_33_44_55     ),      // 开发板MAC地址
    .BOARD_IP  ({8'd192,8'd168,8'd1,8'd10})       // 开发板IP地址
)
arp_rx_inst
(
    .clk         (clk         ),
    .rst_n       (rst_n       ),
    .gmii_rx_dv  (gmii_rx_dv  ),   // 输入的数据有效信号
    .gmii_rx_data(gmii_rx_data),   // 输入数据
    .arp_rx_done (arp_rx_done ),   // 接受完成信号
    .arp_rx_type (arp_rx_type ),   // 接受到的类型 0：请求 1：应答
    .source_mac  (source_mac  ),   // 源MAC地址
    .source_ip   (source_ip   )    // 源IO地址
);


endmodule