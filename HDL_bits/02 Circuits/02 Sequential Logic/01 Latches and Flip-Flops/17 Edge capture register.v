module top_module (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

reg  [31:0] in_reg;
wire [31:0] out_flag;

always @(posedge clk ) begin
    in_reg <= in;
end

//提取每个bit的下降沿信号
assign out_flag = (~in[31:0]) & (in_reg[31:0]);


// 使用for循环根据下降沿信号将out信号的每位拉高
integer i = 0;
always @(posedge clk ) begin
    if (reset)
        out <= 32'b0;
    else 
        for (i = 0 ; i < 32 ; i = i + 1) begin
            if (out_flag[i] == 1'b1)
                out[i] <= 1'b1;
            else 
                out[i] <= out[i];
        end            
end

endmodule
