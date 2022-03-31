// 没有采用题中格式
module top_module(clk, reset, in, out);
    input clk;
    input reset;    // Synchronous reset to state B
    input in;
    output out;//  
    reg out;

    // Fill in state name declarations
parameter A=1'b0,B=1'b1;
reg state;

always@(posedge clk)begin
    if (reset)
        state <= B;
    else
        case(state)
        A:
            if(!in)
                state <= B;
            else 
                state <= A;
        B:
            if(!in)
                state <= A;
            else 
                state <= B;
        endcase
end

assign out = (state == B) ? 1'b1 : 1'b0;


endmodule
