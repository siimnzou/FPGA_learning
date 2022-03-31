module top_module(
    input clk,
    input reset,    
    input j,
    input k,
    output out); //  

    parameter OFF=1'b0, ON=1'b1; 
    reg state;

    always @(posedge clk) begin
        if (reset)
            state <= OFF;
        else
            case (state)
                ON:
                    if (k == 1'b1)
                        state <= OFF;
                    else 
                        state <= ON;
                OFF:
                    if (j == 1'b1)
                        state <= ON;
                    else 
                        state <= OFF;
            endcase
    end

assign out = (state == ON)? 1'b1 : 1'b0;
    // Output logic
    // assign out = (state == ...);

endmodule