/*--------------------------------------------------------------------------------------
    创建时间：2022/9/7 15:40
    器件: Xilinx xc7z020clg400-2
    模块名：arp_loop_top
    所属工程：ethernet
    版本：V1.0
    
    介绍：
    ARP循环实验中的顶层模块
    该实验中，实现的功能为 当按键后，FPGA会向上位机发送ARP请求，然后接受到ARP应答
    当上位机向FPGA发送ARP请求后，FPGA会发出APR应答，将本机MAC和IP发送至上位机
--------------------------------------------------------------------------------------*/
module arp_loop_top
(
    input  wire     clk       ,
    input  wire     rst_n     ,
    input  wire     touch_in  , 
// RGMII接口
    input              eth_rxc   , //RGMII接收数据时钟
    input              eth_rx_ctl, //RGMII输入数据有效信号
    input       [3:0]  eth_rxd   , //RGMII输入数据
    output             eth_txc   , //RGMII发送数据时钟    
    output             eth_tx_ctl, //RGMII输出数据有效信号
    output      [3:0]  eth_txd   , //RGMII输出数据          
    output             eth_rst_n   //以太网芯片复位信号，低电平有效   
);


parameter  BOARD_MAC = 48'h00_11_22_33_44_55;       //开发板MAC地址     
parameter  BOARD_IP  = {8'd192,8'd168,8'd1,8'd10};  //开发板IP地址 192.168.1.10 
parameter  DES_MAC   = 48'hff_ff_ff_ff_ff_ff;       //目的MAC地址 ff_ff_ff_ff_ff_ff
parameter  DES_IP    = {8'd192,8'd168,8'd1,8'd102}; //目的IP地址 192.168.1.102

parameter IDELAY_VALUE = 0;   //输入数据IO延时(如果为n,表示延时n*78ps) 

wire          clk_200m   ; //用于IO延时的时钟 
              
wire          gmii_rx_clk; //GMII接收时钟
wire          gmii_rx_dv ; //GMII接收数据有效信号
wire  [7:0]   gmii_rx_data   ; //GMII接收数据
wire          gmii_tx_clk; //GMII发送时钟
wire          gmii_tx_en ; //GMII发送数据使能信号
wire  [7:0]   gmii_tx_data   ; //GMII发送数据
              
wire          arp_rx_done; //ARP接收完成信号
wire          arp_rx_type; //ARP接收类型 0:请求  1:应答
wire  [47:0]  source_mac    ; //接收到目的MAC地址
wire  [31:0]  source_ip     ; //接收到目的IP地址    
wire          arp_tx_dv  ; //ARP发送使能信号
wire          arp_tx_type; //ARP发送类型 0:请求  1:应答
wire          tx_done    ; //发送的目标MAC地址
wire  [47:0]  des_mac    ; //发送的目标IP地址
wire  [31:0]  des_ip     ; //以太网发送完成信号    
wire          key_flag   ;


assign des_mac = source_mac;
assign des_ip = source_ip;
assign eth_rst_n = rst_n;


clk_wiz_0 u_driven_clk
   (
    // Clock out ports
    .clk_200m(clk_200m),     // output clk_200m
    // Status and control signals
    .reset(~rst_n), // input reset
    .locked(),       // output locked
   // Clock in ports
    .clk_in1(clk));      // input clk_in1


// GMII to RGMII
gmii2rgmii 
#(
     .IDELAY_VALUE (IDELAY_VALUE)
)
    u_gmii2rgmii
(
    .idelay_clk  (  clk_200m ), //IDELAY时钟
    //以太网GMII接口
    .gmii_tx_dv  (gmii_tx_dv   ), //GMII发送数据使能信号
    .gmii_txd    (gmii_tx_data ), //GMII发送数据          
    .gmii_rx_clk (gmii_rx_clk  ), //GMII接收时钟
    .gmii_rx_dv  (gmii_rx_dv   ), //GMII接收数据有效信号
    .gmii_rxd    (gmii_rx_data     ), //GMII接收数据
    .gmii_tx_clk (gmii_tx_clk  ), //GMII发送时钟  
    //以太网RGMII接口   
    .rgmii_rxc   (eth_rxc     ), //RGMII接收时钟
    .rgmii_rx_ctl(eth_rx_ctl  ), //RGMII接收数据控制信号
    .rgmii_rxd   (eth_rxd   ), //RGMII接收数据
    .rgmii_txc   (eth_txc   ), //RGMII发送时钟    
    .rgmii_tx_ctl(eth_tx_ctl), //RGMII发送数据控制信号
    .rgmii_txd   (eth_txd   )  //RGMII发送数据          
);

arp_ctrl u_arp_ctrl(
    .clk           (gmii_rx_clk),
    .rst_n         (rst_n      ),
                   
    .touch_in      (touch_in   ),
    .arp_rx_done   (arp_rx_done),
    .arp_rx_type   (arp_rx_type),
    .arp_tx_en     (arp_tx_en  ),
    .arp_tx_type   (arp_tx_type)
    );

arp
#(
    .BOARD_MAC     (BOARD_MAC),            //开发版MAC
    .BOARD_IP      (BOARD_IP ),            //开发板IP
    .DES_MAC       (DES_MAC  ),            //目的MAC
    .DES_IP        (DES_IP   )             //目的IP
)
u_arp
(
    .rst_n         (rst_n  ),
    // GMII接口
    .gmii_rx_clk   (gmii_rx_clk ),
    .gmii_rx_dv    (gmii_rx_dv  ),
    .gmii_rx_data  (gmii_rx_data),
    .gmii_tx_clk   (gmii_tx_clk ),
    .gmii_tx_dv    (gmii_tx_dv  ),
    .gmii_tx_data  (gmii_tx_data),
    // arp_tx 接口
    .arp_tx_en     (arp_tx_en  ),
    .arp_tx_type   (arp_tx_type),
    .des_mac       (des_mac    ),
    .des_ip        (des_ip     ),
    .arp_tx_done   (arp_tx_done),
    // arp_rx 接口
    .arp_rx_type   (arp_rx_type),
    .source_mac    (source_mac ),
    .source_ip     (source_ip  ),
    .arp_rx_done   (arp_rx_done) 
);



endmodule