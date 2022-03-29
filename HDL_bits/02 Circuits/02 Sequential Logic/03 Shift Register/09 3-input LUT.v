//设计一个8X1的储存器电路。写入储存器是通过移位来完成的，而读取是随机访问的（类似于RAM）
//创建一个8位移位寄存器（Q[0] - Q[7]），来接收来自输入S的数据，最高位首先被写入，使能信号控制是否移位
//将电路扩展为具有三个附加输入ABC 和输出Z的电路，ABC 为 000 时，Z=Q[0] 。。。类推、
//电路中只允许8位移位寄存器和多路复用器（这个电路又叫做3输入查找表 LUT）
module top_module (
    input clk,
    input enable,
    input S,
    input A, B, C,
    output Z ); 

reg [7:0] ram_data ;

always @(posedge clk ) begin
    if (enable)
        ram_data <= {ram_data[6:0],S};
    else 
        ram_data <= ram_data;
end

assign Z = ram_data[{A,B,C}];

endmodule
