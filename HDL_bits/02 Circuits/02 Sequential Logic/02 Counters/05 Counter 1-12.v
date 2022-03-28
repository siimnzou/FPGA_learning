module top_module (
    input clk,
    input reset,
    input enable,
    output [3:0] Q,
    output c_enable,
    output c_load,
    output [3:0] c_d
); //

assign c_enable = (c_load)? 1'b0:enable; // c_load比enable的优先级更高
assign c_load   = reset || (4'd12 == Q && enable == 1'b1);
assign c_d = 4'd1;

    count4 the_counter (clk, c_enable, c_load, c_d ,Q/*, ... */ );

endmodule