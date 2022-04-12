module VGA_COLORBAR
(
    input clk,
    input rst_n,

    output [15:0] rgb_565,
    output        hsync,
    output        vsync
);

wire  clk_108;
wire  locked;
wire  rst_n_locked ;
wire [11:0] x_loc;
wire [11:0] y_loc;
wire [15:0] pix_data;

assign rst_n_locked = rst_n & locked;

clk_gen	clk_gen_inst
(
	.areset ( ~rst_n ),
	.inclk0 ( clk ),

	.c0 ( clk_108 ),
	.locked ( locked)
	);

VGA_CTRL VGA_CTRL_INST
(
    .clk     (clk_108     ),
    .rst_n   (rst_n_locked   ),  
    .pix_data(pix_data),

    .rgb_565 (rgb_565 ),
    .hsync   (hsync   ),
    .vsync   (vsync   ),
    .x_loc   (x_loc   ),
    .y_loc   (y_loc   )   // 位宽设置大一点以便于分辨率的修改
);

PIC_DATA PIC_DATA_INST
 (
    .clk  (clk_108),
    .rst_n(rst_n_locked),
    .x_loc(x_loc),
    .y_loc(y_loc),

    .pix_data(pix_data)
 );

endmodule
