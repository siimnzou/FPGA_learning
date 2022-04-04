// 这个题好像没法用到时序逻辑？？

module top_module (
    input clk,
    input [2:0] y,
    input x,
    output Y0,
    output z
);

parameter S0 = 3'b000,
          S1 = 3'b001,
          S2 = 3'b010,
          S3 = 3'b011,
          S4 = 3'b100;
          
reg [2:0] state; 
reg [2:0] next_state;

always @(*) begin
        case (y)
                S0 :
                    if(x) 
                        next_state = S1;
                    else
                        next_state = S0;
                S1 :
                    if (x)
                       next_state = S4;
                    else 
                        next_state = S1;
                S2 :
                    if (x)
                        next_state = S1;
                    else 
                        next_state = S2; 
                S3 :
                    if (x)
                        next_state = S2;
                    else 
                        next_state = S1;                 
                S4 :
                    if (x)
                        next_state = S4;
                    else 
                        next_state = S3;
                default:
                    next_state = S0;
        endcase                     
end


assign z = (y == S3 || y == S4);
assign Y0 = next_state[0];

endmodule
