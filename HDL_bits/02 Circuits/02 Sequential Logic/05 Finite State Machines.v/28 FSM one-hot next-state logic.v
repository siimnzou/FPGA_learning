module top_module (
    input [6:1] y,
    input w,
    output Y2,
    output Y4);

parameter A  = 6'b000001,
          B  = 6'b000010,
          C  = 6'b000100,
          D  = 6'b001000,
          E  = 6'b010000,
          F  = 6'b100000;

reg [6:1] next_state;

assign next_state[1] = (y[1] && w  || y[4] && w);
assign next_state[2] = (y[1] && !w );
assign next_state[3] = (y[2] && !w || y[5] && !w);
assign next_state[4] = (y[2] && w  || y[3] && w || y[5] && w || y[6] && w);
assign next_state[5] = (y[3] && !w || y[5] && !w);
assign next_state[6] = (y[4] && !w );



assign Y2 = next_state[2] ;
assign Y4 = next_state[4] ;



endmodule

