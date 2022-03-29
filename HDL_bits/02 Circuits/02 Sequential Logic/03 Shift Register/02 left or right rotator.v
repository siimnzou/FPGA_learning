// 构建一个左/右旋转器，具有同步的加载和左移右移使能信号
// 加载信号有效时赋值data，ena[0] 控制右移，ena[1] 控制左移，均为高电平有效 同时为高或低时不变
module top_module(
    input clk,
    input load,
    input [1:0] ena,
    input [99:0] data,
    output reg [99:0] q); 

always @(posedge clk ) begin
    if (load)
        q <= data;
    else
        case(ena)
            2'b01 : q <= {q[0],q[99:1]};
            2'b10 : q <= {q[98:0],q[99]};
            2'b00 , 2'b11 : q <= q;
            default : q <= q;
        endcase   
end

endmodule
