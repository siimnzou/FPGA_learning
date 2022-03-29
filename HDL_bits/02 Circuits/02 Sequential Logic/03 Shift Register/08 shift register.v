//通过实例化muxdff模块来获得一个4位的移位寄存器
// 输入R为开关SW  CLK：KEY[0]  E:KEY[1]  L:KEY[2]  W:KEY[3]  Q:LEDR 


module top_module (
	input [3:0] SW,      // R
	input [3:0] KEY,     // L and clk
	output [3:0] LEDR);  // Q

MUXDFF MUXDFF0 (KEY[0],KEY[3], SW[3], KEY[1], KEY[2],LEDR[3]);
MUXDFF MUXDFF1 (KEY[0],LEDR[3], SW[2], KEY[1], KEY[2],LEDR[2]);
MUXDFF MUXDFF2 (KEY[0],LEDR[2], SW[1], KEY[1], KEY[2],LEDR[1]);
MUXDFF MUXDFF3 (KEY[0],LEDR[1], SW[0], KEY[1], KEY[2],LEDR[0]);

endmodule




module MUXDFF (
    input clk,
    input w, R, E, L,
    output Q
);

always @(posedge clk ) begin
    if (L)
        Q <= R;
    else if (E && !L)
        Q <= w;
    else 
        Q <= Q; 
end

endmodule



