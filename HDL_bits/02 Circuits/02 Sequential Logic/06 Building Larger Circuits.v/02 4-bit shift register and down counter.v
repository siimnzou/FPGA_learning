// 构建四位移位寄存器，该寄存器也用作递减计数器，当移位使能信号为1时。数据向最高位移位，当count_ena = 1时，当前在寄存器中的数字递减
// 不会同时使得shift_ena 和 count_ena 同时为1
 module top_module (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q);

always @(posedge clk ) begin
    if (shift_ena)
        q <= {q[2:0],data};
    else if (count_ena)
        q <= q - 1'b1;
    else 
        q <= q;    
end

endmodule
