module top_module(
    input a,
    input b,
    input c,
    input d,
    output out  ); 

assign out = ((a ^ b) & (c ^! d)) || ((a ^~ b) & (c ^ d));// ab相同的时候cd不同。ad不同的时候cd相同

endmodule
