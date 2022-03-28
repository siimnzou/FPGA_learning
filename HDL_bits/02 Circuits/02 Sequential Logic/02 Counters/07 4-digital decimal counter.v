module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q);

assign ena[1] = (q[3:0] == 4'h9) ? 1'b1 : 1'b0 ;
assign ena[2] = (q[7:4] == 4'h9 && q[3:0] == 4'h9) ? 1'b1 : 1'b0 ;
assign ena[3] = (q[11:8] == 4'h9 && q[7:4] == 4'h9 && q[3:0] == 4'h9) ? 1'b1 : 1'b0 ;

always @(posedge clk ) begin
    if (reset)
        q <= 16'b0;
    else if (q == 16'h9999)
        q <= 16'h0;
    else if (ena[3] == 1'b1 && ena[2] == 1'b1 && ena[1] == 1'b1)  // 此处需要注意越苛刻的条件需要放在前面，防止满足前者后直接运行而不考虑后者了
        begin
            q[11:0] <= 12'h000;
            q[15:12] <= q[15:12] + 1'b1;
        end
    else if (ena[2] == 1'b1 && ena[1] == 1'b1)
        begin
            q[7:0] <= 8'h0;
            q[11:8] <= q[11:8] + 1'b1;
        end
    else if (ena[1] == 1'b1)
        begin
            q[3:0] <= 4'h0;
            q[7:4] <= q[7:4] + 1'b1;
        end 
    else 
        q[3:0] <= q[3:0] + 1'b1;
end

endmodule
