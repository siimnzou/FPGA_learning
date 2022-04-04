// 带有异步复位，同步装载(更优先)，和使能信号，向右移位
module top_module(
    input clk,
    input areset,  // async active-high reset to zero
    input load,
    input ena,
    input [3:0] data,
    output reg [3:0] q); 

always @(posedge clk  or posedge areset) begin
    if (areset)
        q <= 4'd0;
    else if (load)
        q <= data;
    else if (ena )
        q <= q >> 1 ;
    else 
        q <= q;    
end

endmodule
