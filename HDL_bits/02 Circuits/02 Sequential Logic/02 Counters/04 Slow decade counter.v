module top_module (
    input clk,
    input slowena,
    input reset,
    output [3:0] q);

always @(posedge clk ) begin
    if (reset)
        q <= 4'd0;
    else if (4'd9 == q && 1'b1 == slowena)
        q <= 4'd0;
    else if (1'b1 == slowena)
        q <= q + 1'b1; 
    else 
        q <= q;
end

endmodule
