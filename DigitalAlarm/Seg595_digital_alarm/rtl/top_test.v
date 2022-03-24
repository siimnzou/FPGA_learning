// 用于产生 0-999999的数来验证数码管程序是否工作正常
module top_test
(
    input clk,
    input rst_n,
    
    output wire stcp,
    output wire shcp,
    output wire ds,  
    output wire oe   
);

// 定义0.1s使数据加1
parameter CNT_0_1S_MAX = 23'd5_000_000;

reg [22:0] cnt_0_1s; 
reg [19:0] data;

wire [5:0]  sel;
wire [7:0]  seg;
 
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        cnt_0_1s <= 23'd0;
    else if (cnt_0_1s == CNT_0_1S_MAX - 1 )
        cnt_0_1s <= 23'd0;
    else 
        cnt_0_1s <= cnt_0_1s + 1'b1;
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        data <= 20'd0;
    else if (cnt_0_1s == CNT_0_1S_MAX - 1 && data == 20'd999_999)
        data <= 20'd0;
    else if (cnt_0_1s == CNT_0_1S_MAX - 1 )
        data <= data + 1'b1;
    else 
        data <= data;
end

data_trans data_trans_inst
(
    . data  (data ),
    . clk   (clk  ),
    . rst_n (rst_n),
    . sign  (1'b0 ),    // 1表示负号 ， 0表示正号（不显示）
    . point (),

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