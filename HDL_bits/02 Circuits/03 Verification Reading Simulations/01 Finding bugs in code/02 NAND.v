// 原代码
/*
module andgate ( output out, input a, input b, input c, input d, input e );

module top_module (input a, input b, input c, output out);//

    andgate inst1 ( a, b, c, out );

endmodule
*/
module top_module (input a, input b, input c, output out);//
	wire data_and;

    andgate inst1 (data_and,a, b, c,1'b1,1'b1);
    
	assign out = ~ data_and;

endmodule
