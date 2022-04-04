module top_module (
    input clk,
    input reset,      // Synchronous reset
    output reg shift_ena);

reg [1:0] cnt ;

always @(posedge clk ) begin
    if (reset)
        cnt <= 2'd0;
    else if (cnt == 2'd3)
        cnt <= cnt;
    else 
        cnt <= cnt + 1'b1;
end

always @(posedge clk ) begin
    if (reset)
        shift_ena <= 1'b1;
    else if(cnt == 2'd3)
        shift_ena <= 1'b0;
    else 
        shift_ena <= shift_ena;
end

endmodule
