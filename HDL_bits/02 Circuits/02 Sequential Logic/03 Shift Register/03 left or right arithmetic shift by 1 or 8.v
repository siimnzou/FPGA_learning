//构建一个64位的算术移位寄存器，具有同步加载功能，移位器可以向左和向右移动1或8位
//ena为1时:amount: 00 左移一位； 01 左移8位； 10 右移一位； 11 右移8位；
//注意该算术移位寄存器在右移的时候需要考虑符号位，符号位是不移动的 
module top_module(
    input clk,
    input load,
    input ena,
    input [1:0] amount,
    input [63:0] data,
    output reg [63:0] q); 

always @(posedge clk ) begin
    if (load)
        q <= data;
    else if(ena)
        case(amount)
            2'b00 : q <= q << 1;
            2'b01 : q <= q << 8;
            2'b10 : q <= {q[63],q[63:1]};
            2'b11 : q <= {{8{q[63]}},q[63:8]}; // 右移8次后符号位需要保持8位
            default : q <= q;
        endcase   
    else 
        q <= q;
end

endmodule
