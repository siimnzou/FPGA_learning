// 旅鼠的2维世界里，旅鼠有两个状态，向左走和向右走，当有障碍的时候转换方向，当同时碰到障碍的时候也会转变方向
// 除此之外当ground = 0 时，旅鼠会跌落，此时被撞不会改变方向
// 当旅鼠在地面的时候，如果可以挖掘，就会进行挖掘，如果挖到底面为0时候，就会开始坠落
// 挖掘时被撞没有效果，而且坠落或者没地面时候挖掘没用
// 当旅鼠下坠超过20个周期（不包括20） 他就会G，旅鼠只有在落地的时候才会G
module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 

reg walk_left_reg ;
reg walk_right_reg;
parameter LEFT = 7'b0000001 ,
          RIGHT = 7'b0000010,
          FALL_LEFT = 7'b0000100,
          FALL_RIGHT = 7'b0001000,
          DIG_LEFT  = 7'b0010000,
          DIG_RIGHT = 7'b0100000,
          GAME_OVER = 7'b1000000;


reg [6:0] state ;
reg [4:0] cnt_fall;

// 声明跌落时间的计数器 ，当计数到20时说明已经过了21个周期。保持不变，跌落后就G了
always @(posedge clk or posedge areset) begin
    if (areset)
        cnt_fall <= 5'd0;
    else if ((state == FALL_LEFT || state == FALL_RIGHT) && cnt_fall == 5'd20)
        cnt_fall <= cnt_fall;
    else if (state == FALL_LEFT || state == FALL_RIGHT)
        cnt_fall <= cnt_fall + 1'b1;
    else 
        cnt_fall = 5'd0;
end

always @(posedge clk or posedge areset) begin
    if (areset)
        state <= LEFT;
    else
        case(state)
            LEFT :
                if (!ground)  //  题意中是跌落优先，放前面
                    state <= FALL_LEFT;
                else if(dig)
                    state <= DIG_LEFT;
                else if(bump_left)
                    state <= RIGHT;
                else 
                    state <= LEFT;
            RIGHT:
                if (!ground)  //  题意中是跌落优先，放前面
                    state <= FALL_RIGHT; 
                else if(dig)
                    state <= DIG_RIGHT;      
                else if (bump_right)
                    state <= LEFT;
                else 
                    state <= RIGHT;
            FALL_LEFT:
                if (ground && cnt_fall == 5'd20)
                    state <= GAME_OVER;
                else if(ground)
                    state <= LEFT;
                else 
                    state <= FALL_LEFT;
            FALL_RIGHT:
                if (ground && cnt_fall == 5'd20)
                    state <= GAME_OVER;
                else if(ground)
                    state <= RIGHT;
                else 
                    state <= FALL_RIGHT;
            DIG_LEFT:
                if (!ground)
                    state <= FALL_LEFT; 
                else 
                    state <= DIG_LEFT;
            DIG_RIGHT:
                if (!ground)
                    state <= FALL_RIGHT;
                else 
                    state <= DIG_RIGHT;   
            GAME_OVER:
                state <= GAME_OVER;           
            default: state <= LEFT;
        endcase   
end


            
assign walk_right = (state == RIGHT)? 1'b1 : 1'b0;
assign walk_left  =  (state == LEFT)? 1'b1 : 1'b0;
assign aaah = (state == FALL_LEFT || state == FALL_RIGHT)? 1'b1 : 1'b0;
assign digging = (state == DIG_LEFT || state == DIG_RIGHT) ? 1'b1 : 1'b0;


endmodule