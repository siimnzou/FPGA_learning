`timescale 1ns/1ns
module tb_data_trans();

reg [19:0] data;
reg        clk;
reg        rst_n;
reg        sign; 
reg [5:0]  point;

wire [5:0]  sel;
wire  [7:0]  seg;

defparam data_trans_inst.CNT_1MS_MAX = 16'd50;

initial begin
    clk = 1'b1;
    rst_n <= 1'b0;
    data <= 20'd0;
    sign <= 1'b0;
    #20
    rst_n <= 1'b1;
    data <= 20'd5900;
    sign <= 1'b0;
    #20000
    data <= 20'd52233;
    sign <= 1'b1;
end

always #10 clk = ~ clk;

data_trans data_trans_inst
(
    . data  (data ),
    . clk   (clk  ),
    . rst_n (rst_n),
    . sign  (sign ),    // 1表示负号 ， 0表示正号（不显示）
    . point (),

    .sel (sel),
    .seg (seg)
);

endmodule