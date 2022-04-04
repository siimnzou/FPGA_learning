// 当检测到 1101 的时候开始
// 移位4次来决定需要持续的时间
// 等待计数器完成计数 并且通知用户确认计数器
// 当接收到模式1101时。使得Shift_ena 拉高4周期
// 之后需要给计数输出赋值来表示他在等待计数等到 done_counting 出现之前都进行技术
// 此时，状态机必须说定时器已经超时，并且直到应答信号ACK出现后，才重置启动下一次的寻找序列。

// 基于上述FSM 实现电路
// 当检测到1101 时，电路移入下一个四位作为定时器的延时时间
// 之后，状态机发出计数输出。表示正在计数，计数器必须计数 delay + 1  个1000周期的延时
// 同时输出剩余时间，知道技术完成时候,说明计数器完成，进入DONE状态，等待用户AFK信号 

module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack );

parameter IDLE     = 4'b0001,
          SHIFTING = 4'b0010,
          COUNTING = 4'b0100,
          DONE     = 4'b1000;

reg [3:0] state;
reg [2:0] seq_reg;
reg [1:0] cnt_shifting;
reg [3:0] delay;
reg [9:0] cnt_1000;

// 用于检测序列，检测到序列后进入到SHIFTING状态，该状态维持4个周期，期间shift_ena 拉高，之后
always @(posedge clk ) begin
    if (reset)
        seq_reg <= 3'b0;
    else if (state == IDLE)
        seq_reg <= {seq_reg[1:0],data};    
    else 
        seq_reg <= 3'b0;
end

always @(posedge clk ) begin
    if (state == SHIFTING)
        delay <= {delay[2:0],data};
    else if (state == COUNTING && cnt_1000 == 10'd999)
        delay <= delay - 1'b1;
    else 
        delay <= delay;   
end

always@(posedge clk) begin
    if (reset)
        cnt_1000 <= 10'd0;
    else if (state == COUNTING && cnt_1000 == 10'd999)
        cnt_1000 <= 10'd0;
    else if(state == COUNTING)
        cnt_1000 <= cnt_1000 + 1'b1;
    else 
        cnt_1000 <= 10'd0;
end


always @(posedge clk ) begin
    if (reset)
        state <= IDLE;
    else 
        case(state)
            IDLE :
                if(seq_reg == 3'b110 && data == 1'b1)
                    state <= SHIFTING;
                else 
                    state <= IDLE;
            SHIFTING:
                if (cnt_shifting == 2'd3)
                    state <= COUNTING;
                else
                    state <= SHIFTING;
            COUNTING:
                if (cnt_1000 == 10'd999 && delay == 4'd0)
                    state <= DONE ;
                else 
                    state <= COUNTING;
            DONE:
                if (ack)
                    state <= IDLE;
                else 
                    state <= DONE;
            default: state <= IDLE;
        endcase
end

always @(posedge clk ) begin
    if (reset)
        cnt_shifting <= 2'd0;
    else if (state == SHIFTING && cnt_shifting == 2'd3)
        cnt_shifting <= cnt_shifting;
    else if (state == SHIFTING  )
        cnt_shifting <= cnt_shifting + 1'b1;
    else 
        cnt_shifting <= 2'd0;
end


assign counting = (state == COUNTING);
assign done = (state == DONE);
assign count = delay;

endmodule
