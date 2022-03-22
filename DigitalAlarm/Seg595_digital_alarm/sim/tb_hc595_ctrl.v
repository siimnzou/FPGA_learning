`timescale 1ns/1ns
module tb_hc595_ctrl ();

reg        clk;
reg        rst_n;
reg [5:0]  sel;
reg [7:0]  seg;

wire stcp;
wire shcp;
wire ds;
wire oe;

initial begin
    clk = 1'b1;
    rst_n <= 1'b0;
    sel  <= 6'd0;
    seg  <= 8'd0;
    #20
    rst_n <= 1'b1;
    sel  <= 6'b101010;
    seg  <= 8'b01010101;
    #20000
    sel  <= 6'b111000;
    seg  <= 8'b00001111;
end

always #10 clk = ~ clk;

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