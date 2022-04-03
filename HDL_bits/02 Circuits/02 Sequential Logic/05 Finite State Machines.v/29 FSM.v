module top_module (
    input clk,
    input reset,     // synchronous reset
    input w,
    output z);

endmodule


parameter A  = 6'b000001,
          B  = 6'b000010,
          C  = 6'b000100,
          D  = 6'b001000,
          E  = 6'b010000,
          F  = 6'b100000;

reg [5:0] state;

always @(posedge clk ) begin
    if(reset)
        state <=  A;
    else 
        case (state)
            A :  
                if(!w)
                    state = B;
                else 
                    state = A;
            B :  
                if(!w)
                    state = C;
                else 
                    state = D;
            C :  
                if(!w)
                    state = E;
                else
                    state = D;
            D :  
                if(!w)
                    state = F;
                else 
                    state = A;
            E :  
                if(!w)
                    state = E;
                else 
                    state = D;
            F :  
                if(!w)
                    state = C;
                else 
                    state = D;
            default:
                state = A;
        endcase
end

assign z =  (state == E || state == F);

endmodule

