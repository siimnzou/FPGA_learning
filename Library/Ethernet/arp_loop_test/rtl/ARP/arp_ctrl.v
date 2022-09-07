/*--------------------------------------------------------------------------------------
    创建时间：2022/9/6 18:30
    器件: Xilinx xc7z020clg400-2
    模块名：crc32_d8
    所属工程：ethernet
    版本：V1.0
    
    介绍：
    arp_ctrl模块，用于控制arp模块，按键后像上位机发送ARP请求，收到上位机的ARP请求后发送ARP应答
--------------------------------------------------------------------------------------*/
module arp_ctrl(
    input                clk         , //输入时钟   
    input                rst_n       , //复位信号，低电平有效
    
    input                touch_in  , //触摸按键,用于触发开发板发出ARP请求
    input                arp_rx_done , //ARP接收完成信号
    input                arp_rx_type , //ARP接收类型 0:请求  1:应答 
    output  reg          arp_tx_en   , //ARP发送使能信号
    output  reg          arp_tx_type   //ARP发送类型 0:请求  1:应答
    );

reg     touch_in_ff    ;
reg     touch_in_ff2   ;
wire     touch_in_flag  ;

always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        touch_in_ff  <= 1'b0;
        touch_in_ff2 <= 1'b0;
    end
    else begin
        touch_in_ff  <= touch_in;
        touch_in_ff2 <= touch_in_ff;
    end
end

assign touch_in_flag = touch_in_ff && ~touch_in_ff2;


//为arp_tx_en和arp_tx_type赋值
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        arp_tx_en <= 1'b0;
        arp_tx_type <= 1'b0;
    end
    else begin
        //检测到输入触摸按键
        if(touch_in_flag) begin  
            arp_tx_en <= 1'b1;           
            arp_tx_type <= 1'b0;
        end
        //接收到ARP请求,开始控制ARP发送模块应答
        else if(arp_rx_done  && ~arp_rx_type) begin
            arp_tx_en <= 1'b1;
            arp_tx_type <= 1'b1;
        end
        else
            arp_tx_en <= 1'b0;
    end
end

endmodule
