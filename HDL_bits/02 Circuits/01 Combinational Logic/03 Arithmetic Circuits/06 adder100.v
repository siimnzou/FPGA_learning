module top_module( 
    input [99:0] a, b,
    input cin,
    output wire cout,
    output [99:0] sum );

assign {cout,sum} = a + b + cin;

endmodule