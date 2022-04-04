module top_module (
    input clock,
    input a,
    output p,
    output q );

always @(negedge clk ) begin
    q <= ~q
end

assign p = (clk)? a : q;

endmodule
