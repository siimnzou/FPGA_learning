module top_module(
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out); //

    parameter A=2'd0, B=2'd1, C=2'd2, D=2'd3;

    always @(*) begin
        case (state)
            A:
                if (in)
                    next_state = B;
                else 
                    next_state = A;
            B:     
                if (in)
                    next_state = B;
                else 
                    next_state = C;
            C:     
                if (in)
                    next_state = D;
                else 
                    next_state = A;    
            D:     
                if (in)
                    next_state = B;
                else 
                    next_state = C;  
        endcase                               
    end// State transition logic: next_state = f(state, in)

assign out = (state == D)? 1'b1 : 1'b0;
    // Output logic:  out = f(state) for a Moore state machine

endmodule
