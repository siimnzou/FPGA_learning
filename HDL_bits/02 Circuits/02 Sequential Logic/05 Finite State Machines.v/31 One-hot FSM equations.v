module top_module (
    input [5:0] y,
    input w,
    output Y1,
    output Y3);

parameter A  = 6'b000001,
          B  = 6'b000010,
          C  = 6'b000100,
          D  = 6'b001000,
          E  = 6'b010000,
          F  = 6'b100000;

reg [5:0] next_state;

assign next_state[0] = (y[0] && !w  || y[3] && !w);
assign next_state[1] = (y[0] && w );
assign next_state[2] = (y[1] && w || y[4] && w);
assign next_state[3] = (y[1] && !w  || y[2] && !w || y[4] && !w || y[5] && !w);
assign next_state[4] = (y[2] && w || y[4] && w);
assign next_state[5] = (y[3] && w );



assign Y1 = next_state[1] ;
assign Y3 = next_state[3] ;



endmodule

