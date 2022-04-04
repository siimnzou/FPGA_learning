// 原代码
/*
module andgate ( output out, input a, input b, input c, input d, input e );

module top_module (input a, input b, input c, output out);//

    andgate inst1 ( a, b, c, out );

endmodule
*/
module top_module (input a, input b, input c, output out);//



    andgate inst1 ( out,a, b, c,);

endmodule
