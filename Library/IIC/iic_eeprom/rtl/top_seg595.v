module top_seg595
(
    input        clk,
    input        rst_n,
    input [19:0] data,
    input        sign,
    input [5:0]  point,
    
    output wire stcp,
    output wire shcp,
    output wire ds,  
    output wire oe   
);

wire [5:0]  sel;
wire [7:0]  seg;


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