`timescale 1ns/1ns
module tb_VGA_digital_alarm ();

reg clk;
reg rst_n;
reg key_ctrl_in;
reg key_add_in;   

initial begin
    clk = 1'b1;
    rst_n <= 1'b0;
    key_ctrl_in <= 1'b1;
    key_add_in <= 1'b1;
    #20
    rst_n <= 1'b1;
end

always #10 clk = ~ clk;

VGA_digital_alarm VGA_digital_alarm_INST
(
    .clk        (clk        ),
    .rst_n      (rst_n      ),
    .key_ctrl_in(key_ctrl_in),
    .key_add_in (key_add_in ),

    .hsync  (hsync  )  ,
    .vsync  (vsync  )  ,
    .rgb_565(rgb_565)
);

endmodule