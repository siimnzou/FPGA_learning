module top_module (
    input clk,
    input d,
    output q
);

reg d_pos;
reg d_neg;

always @(posedge clk ) begin
    d_pos <= d;
end

always @(negedge clk ) begin
    d_neg <= d;
end

assign q = clk ? d_pos : d_neg;
endmodule

// 另一种解法
/*
module top_module (
    input clk,
    input d,
    output q
);

reg d_pos;
reg d_neg;

always @(posedge clk ) begin
    d_pos <= d ^ d_neg;
end

always @(negedge clk ) begin
    d_neg <= d ^ d_pos;
end

assign q = d_pos ^ d_neg;
endmodule
*/