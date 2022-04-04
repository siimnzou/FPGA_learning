module top_module (
    input clk,
    input reset,     // synchronous reset
    input w,
    output z);


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
                    state = A;
                else 
                    state = B;
            B :  
                if(!w)
                    state = D;
                else 
                    state = C;
            C :  
                if(!w)
                    state = D;
                else
                    state = E;
            D :  
                if(!w)
                    state = A;
                else 
                    state = F;
            E :  
                if(!w)
                    state = D;
                else 
                    state = E;
            F :  
                if(!w)
                    state = D;
                else 
                    state = C;
            default:
                state = A;
        endcase
end

assign z =  (state == E || state == F);

endmodule

