module top_module (
    input clk,
    input reset,   // Synchronous reset
    input x,
    output z
);

parameter S0 = 3'b000,
          S1 = 3'b001,
          S2 = 3'b010,
          S3 = 3'b011,
          S4 = 3'b100;
          
reg [2:0] state; 

always @(posedge clk ) begin
    if (reset)
        state <= S0;
    else
        case (state)
                S0 :
                    if(x) 
                        state <= S1;
                    else
                        state <= S0;
                S1 :
                    if (x)
                        state <= S4;
                    else 
                        state <= S1;
                S2 :
                    if (x)
                        state <= S1;
                    else 
                        state <= S2; 
                S3 :
                    if (x)
                        state <= S2;
                    else 
                        state <= S1;                 
                S4 :
                    if (x)
                        state <= S4;
                    else 
                        state <= S3;
                default:
                    state <= S0;
        endcase                     
end

assign z = (state == S3 || state == S4);

endmodule
