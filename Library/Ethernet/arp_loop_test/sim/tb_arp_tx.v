/*--------------------------------------------------------------------------------------
    创建时间：2022/9/7 15:00
    器件: Xilinx xc7z020clg400-2
    模块名：tb_arp_tx
    所属工程：ethernet
    版本：V1.0
    
    介绍：
    arp_tx 模块测试代码
--------------------------------------------------------------------------------------*/
`timescale 1ns/1ns
module tb_arp_tx();

parameter   BOARD_MAC = 48'h00_11_22_33_44_55,      
            BOARD_IP  = {8'd192,8'd168,8'd1,8'd10}, 
            DES_MAC   = 48'hff_ff_ff_ff_ff_ff,      
            DES_IP    = {8'd192,8'd168,8'd1,8'd102}; 

reg             clk         ;
reg             rst_n       ;
reg             arp_tx_en   ; 
reg             arp_tx_type ;
reg    [47:0]   des_mac     ;
reg    [31:0]   des_ip      ;

wire            crc_en      ;
wire            crc_clr     ;
wire   [7:0]    gmii_tx_data;
wire            arp_tx_done ;
wire            gmii_tx_dv  ;
wire    [31:0]  crc_data    ;
wire    [31:0]  crc_next    ;

initial begin
    clk   <= 1'b1;
    rst_n <= 1'b0;
    arp_tx_en   <= 1'b0;
    arp_tx_type <= 1'b0;
    des_mac     <= 48'h0;
    des_ip      <= 32'h0;
    #300
    rst_n <= 1'b1;
    #500
    arp_tx_en    <= 1'b1;
    arp_tx_type  <= 1'b0;
    #100
    arp_tx_en    <= 1'b0;
end

always #10 clk = ~clk ;

arp_tx
#(
    .BOARD_MAC( BOARD_MAC),           //开发版MAC
    .BOARD_IP ( BOARD_IP ),           //开发板IP
    .DES_MAC  ( DES_MAC  ),            //目的MAC
    .DES_IP   ( DES_IP   )            //目的IP
)
arp_tx_inst
(
    .clk         (clk)   , //时钟信号
    .rst_n       (rst_n)   , //复位信号，低电平有效

    .arp_tx_en   (arp_tx_en      )   , //ARP发送使能信号
    .arp_tx_type (arp_tx_type    )   , //ARP发送类别? 0:请求  1:应答
    .des_mac     (des_mac     )   , //发送的目标MAC地址
    .des_ip      (des_ip      )   , //发送的目标IP地址
    .crc_data    (crc_data       )   , //CRC校验数据
    .crc_next    (crc_next[31:24])   , //CRC下次校验完成数据

    .arp_tx_done (arp_tx_done)   , //以太网发送完成信号
    .gmii_tx_dv  (gmii_tx_dv )   , //GMII输出数据有效信号
    .gmii_tx_data(gmii_tx_data)   , //GMII输出数据
    .crc_en      (crc_en)   , //CRC开始校验使能
    .crc_clr     (crc_clr)     //CRC数据复位信号 
);


crc32_d8    crc32_d8_inst
(
   .clk     (clk          ),  //时钟信号
   .rst_n   (rst_n        ),  //复位信号，低电平有效
   .data    (gmii_tx_data ),  //输入待校验8位数据
   .crc_en  (crc_en       ),  //crc使能，开始校验标志
   .crc_clr (crc_clr      ),  //crc数据复位信号     
   
   .crc_data(crc_data     ),  //CRC校验数据
   .crc_next(crc_next     )   //CRC下次校验完成数据
);


endmodule