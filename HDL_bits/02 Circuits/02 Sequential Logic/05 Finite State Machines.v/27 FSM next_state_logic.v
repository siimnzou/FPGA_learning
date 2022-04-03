module top_module (
    input [3:1] y,
    input w,
    output Y2);

parameter A  = 3'b000,
          B  = 3'b001,
          C  = 3'b010,
          D  = 3'b011,
          E  = 3'b100,
          F  = 3'b101;

reg [2:0] next_state;

always@(*) begin
    case (y)
        A :  
            if(!w)
                next_state = B;
            else 
                next_state = A;
        B :  
            if(!w)
                next_state = C;
            else 
                next_state = D;
        C :  
            if(!w)
                next_state = E;
            else 
                next_state = D;
        D :  
            if(!w)
                next_state = F;
            else 
                next_state = A;
        E :  
            if(!w)
                next_state = E;
            else 
                next_state = D;
        F :  
            if(!w)
                next_state = C;
            else 
                next_state = D;
        default:
            next_state = A;
    endcase
end

assign Y2 = next_state[1] ;



endmodule

