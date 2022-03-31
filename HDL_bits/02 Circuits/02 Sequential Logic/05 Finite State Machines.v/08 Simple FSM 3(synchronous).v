module top_module(
    input clk,
    input in,
    input areset,
    output out); //

parameter A=4'd0001, B=4'b0010, C=4'b0100, D=4'b1000;
reg [3:0] state;


always @(posedge clk ) begin
    if (areset)
        state <= A;
    else 
        case (state)
            A:
                if (in)
                    state = B;
                else 
                    state = A;
            B:     
                if (in)
                    state = B;
                else 
                    state = C;
            C:     
                if (in)
                    state = D;
                else 
                    state = A;    
            D:     
                if (in)
                    state = B;
                else 
                    state = C;  
        endcase                               
end// State transition logic: next_state = f(state, in)

assign out = (state == D)? 1'b1 : 1'b0;
    // Output logic:  out = f(state) for a Moore state machine

endmodule

