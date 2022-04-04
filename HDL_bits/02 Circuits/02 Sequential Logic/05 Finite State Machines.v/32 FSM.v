// 实现图中的仲裁电路 其中r1 具有最高的优先级，而r2 r3其次
module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input [3:1] r,   // request
    output [3:1] g   // grant
); 

parameter A = 4'b0001,
          B = 4'b0010,
          C = 4'b0100,
          D = 4'b1000;

reg [3:0]  state;

always @(posedge clk ) begin
    if(!resetn)
        state <= A;
    else 
        case (state)
            A :
                if (r[1])
                    state <= B;
                else if (!r[1] && r[2])
                    state <= C;
                else if (!r[1] && !r[2] && r[3])
                    state <= D;
                else 
                    state <= A;
            B :
                if (!r[1])
                    state <= A;
                else 
                    state <= B;
            C :
                if (!r[2])
                    state <= A;
                else 
                    state <= C;
            D :
                if (!r[3])
                    state <= A;
                else 
                    state <= D;
            default : state <= A;
        endcase    
end

assign g[1] = (state == B);
assign g[2] = (state == C);
assign g[3] = (state == D);


endmodule
