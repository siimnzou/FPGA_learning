// 旅鼠的2维世界里，旅鼠有两个状态，向左走和向右走，当有障碍的时候转换方向，当同时碰到障碍的时候也会转变方向
// 除此之外当ground = 0 时，旅鼠会跌落，此时被撞不会改变方向
module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah ); 

reg walk_left_reg ;
reg walk_right_reg;
parameter LEFT = 4'b0001 , RIGHT = 4'b0010, FALL_LEFT = 4'b0100 ,FALL_RIGHT = 4'b1000;

reg [3:0] state ;

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= LEFT;
    else
        case(state)
            LEFT :
                if (!ground)  //  题意中是跌落优先，放前面
                    state <= FALL_LEFT;
                else if(bump_left)
                    state <= RIGHT;
                else 
                    state <= LEFT;
            RIGHT:
                if (!ground)  //  题意中是跌落优先，放前面
                    state <= FALL_RIGHT;   
                else if (bump_right)
                    state <= LEFT;
            
                else 
                    state <= RIGHT;
            FALL_LEFT:
                if(ground)
                    state <= LEFT;
                else 
                    state <= FALL_LEFT;
            FALL_RIGHT:
                if(ground)
                    state <= RIGHT;
                else 
                    state <= FALL_RIGHT;
            default: state <= LEFT;
        endcase   
end


            
assign walk_right = (state == RIGHT)? 1'b1 : 1'b0;
assign walk_left  =  (state == LEFT)? 1'b1 : 1'b0;
assign aaah = (state == FALL_LEFT || state == FALL_RIGHT)? 1'b1 : 1'b0;

endmodule