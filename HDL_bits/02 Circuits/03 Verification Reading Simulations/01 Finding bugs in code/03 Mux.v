// 原代码
/*
module mux2 (
    input sel,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out
);
module top_module (
    input [1:0] sel,
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] out  ); //

    wire mux0, mux1;
    
    mux2 mux0 ( sel[0],    a,    b, mux0 );
    mux2 mux1 ( sel[1],    c,    d, mux1 );
    mux2 mux2 ( sel[1], mux0, mux1,  out );

endmodule
*/

module top_module (
    input [1:0] sel,
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] out  ); //

    wire [7:0] mux0_data, mux1_data;
    
    mux2 mux0 ( sel[0],    a,    b, mux0_data );
    mux2 mux1 ( sel[0],    c,    d, mux1_data );
    mux2 mux2 ( sel[1], mux0_data, mux1_data,  out );

endmodule