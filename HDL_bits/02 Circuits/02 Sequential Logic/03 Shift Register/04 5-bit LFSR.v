//线性反馈移位寄存器  通常会存在异或门来产生其下一个状态
// Galois LFSR （可以用来产生伪随机序列 初始值是伪随机种子 影响下一个状态的比特位叫抽头，
// 抽头的取值范围是 1 - 2^n-1 同时如果合理的选择抽头则可以得到2^n-1个状态，没有全0）
module top_module(
    input clk,
    input reset,    // Active-high synchronous reset to 5'h1
    output [4:0] q
); 

always @(posedge clk ) begin
    if (reset)
        q <= 5'b1;
    else
        q <= {q[0]^1'b0,q[4],q[0]^q[3],q[2],q[1]}; 
end

endmodule