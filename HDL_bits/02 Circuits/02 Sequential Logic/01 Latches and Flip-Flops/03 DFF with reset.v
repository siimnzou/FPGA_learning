module top_module (
    input clk,
    input reset,            // Synchronous reset
    input [7:0] d,
    output [7:0] q
);

always @(posedge clk) begin
    if (reset)  // 同步置位
        q <= 8'd0;
    else 
        q <= d;    
end

endmodule