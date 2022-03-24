module top_module (
    input [7:0] a,  // a and b are complement numbers
    input [7:0] b,
    output [7:0] s,
    output overflow
); //

    assign s = a + b;// assign s = ...
    assign overflow = (a[7] && b[7] && !s[7])  || (!a[7] && !b[7] && s[7]); 
    // overflowed when (a,b neg s pos) or (a,b pos s neg)

endmodule