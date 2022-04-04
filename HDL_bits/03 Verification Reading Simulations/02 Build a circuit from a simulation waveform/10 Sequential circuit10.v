module top_module (
    input clk,
    input a,
    input b,
    output q,
    output state  );

assign q = (state)? a ^~ b : a ^ b;

always @(posedge clk ) begin
    state <= a & b || a & !b % !q || !a & b & !q ;
end

endmodule
