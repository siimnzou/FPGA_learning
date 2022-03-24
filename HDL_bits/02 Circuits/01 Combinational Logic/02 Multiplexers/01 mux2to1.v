module top_module
(
    input  a,b,sel,
    output  wire out
);

assign out = (sel) ? b : a ;

endmodule