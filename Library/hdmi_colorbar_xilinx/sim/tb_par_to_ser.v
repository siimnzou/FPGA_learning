`timescale 1ns/1ns

module tb_par_to_ser();

reg			par_clk		;
reg			ser_clk		;
reg			rst_n		;
reg	[9:0]	par_data	;
wire		ser_data	;

//------------<初始化数据>----------------------------------------------
initial begin
    par_clk <= 1'b0;
    ser_clk <=  1'b0;
    rst_n <= 1'b0;
	par_data <= 10'd0;
    #200
    rst_n <= 1'b1;
end
//------------<设置时钟>----------------------------------------------
always #10	par_clk = ~par_clk;
always #2	ser_clk = ~ser_clk;
 
always #20	par_data <= $random % 1024;		//每20ns随机生成一个10位数据用于并行输入
 
//------------<例化模块>---------------------------------------- 
par_to_ser par_to_ser_test
(
    .par_clk   (par_clk ),  // 并行时钟
    .ser_clk   (ser_clk ),  // 串行时钟
    .rst_n     (rst_n   ),
    .par_data  (par_data),

    .ser_data  (ser_data )
);
 

endmodule