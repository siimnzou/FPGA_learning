module top_module (
    input clk,
    input reset,
    output OneHertz,
    output [2:0] c_enable
); //

wire [3:0] q_1  ;
wire [3:0] q_10 ;
wire [3:0] q_100;

assign c_enable[0] = 1'b1;
assign c_enable[1] = (q_1  == 4'd9) ? 1'b1 : 1'b0;
assign c_enable[2] = (q_10 == 4'd9 && q_1 == 4'd9) ? 1'b1 : 1'b0;

    bcdcount counter0 (clk, reset, c_enable[0],q_1/*, ... */);
    bcdcount counter1 (clk, reset, c_enable[1],q_10/*, ... */);
    bcdcount counter2 (clk, reset, c_enable[2],q_100/*, ... */);

assign OneHertz = (q_100 == 4'd9 && q_10 == 4'd9 && q_1 == 4'd9)? 1'b1 : 1'b0;


endmodule
