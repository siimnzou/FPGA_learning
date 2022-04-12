`timescale 1ns/1ns
module TB_VGA_COLORBAR();

reg          clk;
reg          rst_n;
wire  [15:0] rgb_565;
wire         hsync; 
wire         vsync; 

initial begin
    clk = 1'b1;
    rst_n <= 1'b0;
    #20
    rst_n <= 1'b1;
end

always #20 clk = ~ clk;

VGA_COLORBAR VGA_COLORBAR
(
    .clk  (clk  ),
    .rst_n(rst_n),

    .rgb_565(rgb_565),
    .hsync  (hsync  ),
    .vsync  (vsync  )
);

endmodule