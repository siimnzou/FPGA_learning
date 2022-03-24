module top_digital_alarm
(
    input clk,
    input rst_n,
    
    output wire stcp,
    output wire shcp,
    output wire ds,  
    output wire oe   
);

wire       sign;
wire [5:0] point;
wire [19:0] data;
wire [5:0]  sel;
wire [7:0]  seg;

clk_data_gen clk_data_gen_inst
(
   .clk  (clk  ),
   .rst_n(rst_n),

   .point(point),
   .data (data ),
   .sign (sign )  
);

data_trans data_trans_inst
(
    . data  (data ),
    . clk   (clk  ),
    . rst_n (rst_n),
    . sign  (sign ),    // 1表示负号 ， 0表示正号（不显示）
    . point (point),

    .sel (sel),
    .seg (seg)
);

hc595_ctrl hc595_ctrl_inst
(
    .clk    (clk  )    ,
    .rst_n  (rst_n)    ,
    .sel    (sel )    ,
    .seg    (seg)    ,  

    .stcp (stcp),
    .shcp (shcp),
    .ds    (ds),
    .oe    (oe)
);

endmodule