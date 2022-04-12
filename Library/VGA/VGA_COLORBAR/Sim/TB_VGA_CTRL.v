`timescale 1ns/1ns
module TB_VGA_CTRL();

reg         clk;
reg         rst_n;
wire  [15:0] pix_data;

wire [15:0] rgb_565;
wire        hsync;
wire        vsync;
wire [11:0] x_loc;
wire [11:0] y_loc;  

initial begin
    clk = 1'b1;
    rst_n <= 1'b0;
    #20
    rst_n <= 1'b1;
end

always #1 clk = ~ clk;

assign pix_data = {y_loc[3:0],x_loc};

VGA_CTRL VGA_CTRL_INST
(
    .clk     (clk     ),
    .rst_n   (rst_n   ),  
    .pix_data(pix_data),

    .rgb_565 (rgb_565 ),
    .hsync   (hsync   ),
    .vsync   (vsync   ),
    .x_loc   (x_loc   ),
    .y_loc   (y_loc   )   // 位宽设置大一点以便于分辨率的修改
);

endmodule