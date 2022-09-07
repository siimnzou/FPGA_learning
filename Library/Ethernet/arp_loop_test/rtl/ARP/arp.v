/*--------------------------------------------------------------------------------------
    创建时间：2022/9/6 18:30
    器件: Xilinx xc7z020clg400-2
    模块名：arp
    所属工程：ethernet
    版本：V1.0
    
    介绍：
    ARP顶层模块，内部包含arp_rx,arp_tx,crc32_d8，其中为arp的收发控制协议
--------------------------------------------------------------------------------------*/
module arp
#(
    parameter   BOARD_MAC = 48'h00_11_22_33_44_55,                  //开发版MAC
                BOARD_IP  = {8'd192,8'd168,8'd1,8'd10},             //开发板IP
                DES_MAC   = 48'hff_ff_ff_ff_ff_ff,                  //目的MAC
                DES_IP    = {8'd192,8'd168,8'd1,8'd102}             //目的IP
)
(
    input wire           rst_n         ,
    // GMII接口
    input wire           gmii_rx_clk   ,
    input wire           gmii_rx_dv    ,
    input wire  [7:0]    gmii_rx_data  ,
    input wire           gmii_tx_clk   ,
    output wire          gmii_tx_dv    ,
    output wire  [7:0]   gmii_tx_data  ,
    // arp_tx 接口
    input wire           arp_tx_en      ,
    input wire           arp_tx_type    ,
    input wire   [47:0]  des_mac        ,
    input wire   [31:0]  des_ip         ,
    output wire          arp_tx_done    ,
    // arp_rx 接口
    output wire           arp_rx_type   ,
    output wire   [47:0]  source_mac    ,
    output wire   [31:0]  source_ip     ,
    output wire           arp_rx_done    
);


wire  [31:0]  crc_data  ;
wire  [31:0]  crc_next  ;
wire          crc_en    ;
wire          crc_clr   ;


arp_rx
#(   
    .BOARD_MAC( BOARD_MAC),           //开发版MAC
    .BOARD_IP ( BOARD_IP )           //开发板IP
)
arp_rx_inst
(
    .clk         (gmii_rx_clk  ),
    .rst_n       (rst_n       ),
    .gmii_rx_dv  (gmii_rx_dv  ),   // 输入的数据有效信号
    .gmii_rx_data(gmii_rx_data),   // 输入数据
    .arp_rx_done (arp_rx_done ),   // 接受完成信号
    .arp_rx_type (arp_rx_type ),   // 接受到的类型 0：请求 1：应答
    .source_mac  (source_mac  ),   // 源MAC地址
    .source_ip   (source_ip   )    // 源IO地址
);


arp_tx
#(
    .BOARD_MAC( BOARD_MAC),           //开发版MAC
    .BOARD_IP ( BOARD_IP ),           //开发板IP
    .DES_MAC  ( DES_MAC  ),            //目的MAC
    .DES_IP   ( DES_IP   )            //目的IP
)
arp_tx_inst
(
    .clk         (gmii_tx_clk)   , //时钟信号
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