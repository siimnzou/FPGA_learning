`timescale 1ns/1ns
module tb_clk_data_gen();

wire [19:0] data;
reg        clk;
reg        rst_n;
wire        sign; 
wire [5:0]  point;


defparam clk_data_gen_inst.CNT_1S_MAX = 26'd50;

initial begin
    clk = 1'b1;
    rst_n <= 1'b0;
    #20
    rst_n <= 1'b1;
end

always #10 clk = ~ clk;

clk_data_gen clk_data_gen_inst
(
   .clk  (clk  ),
   .rst_n(rst_n),

   .point(point),
   .data (data ),
   .sign (sign )  
);

endmodule