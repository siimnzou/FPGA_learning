module top_module (
    input clk,
    input x,
    output z
); 
reg q_reg1 = 1'b0;
reg q_reg2 = 1'b0;
reg q_reg3 = 1'b0;

always @(posedge clk ) begin
    q_reg1 <= x ^ q_reg1;
end

always @(posedge clk ) begin
    q_reg2 <= x & !q_reg2;
end

always @(posedge clk ) begin
    q_reg3 <= x | !q_reg3;
end

assign z = ~ (q_reg1 | q_reg2 | q_reg3);

endmodule
