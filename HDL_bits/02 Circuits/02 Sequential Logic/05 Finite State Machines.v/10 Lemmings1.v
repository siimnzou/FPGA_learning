// 旅鼠的2维世界里，旅鼠有两个状态，向左走和向右走，当有障碍的时候转换方向，当同时碰到障碍的时候也会转变方向
module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right); 

parameter LEFT = 1'b1 , RIGHT = 1'b0;

reg state;

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= LEFT;
    else
        case(state)
            LEFT :
                if(bump_left)
                    state <= RIGHT;
                else 
                    state <= LEFT;
            RIGHT:
                if (bump_right)
                    state <= LEFT;
                else 
                    state <= RIGHT;
            default: state <= LEFT;
        endcase   
end

assign walk_right = (state == RIGHT)? 1'b1 : 1'b0;
assign walk_left  =  ~walk_right;

endmodule