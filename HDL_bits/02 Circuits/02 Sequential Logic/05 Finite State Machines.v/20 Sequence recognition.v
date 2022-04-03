// HDLC 协议
// 在该协议中需要寻找指示帧 开始信号和结束信号为 01111110 6个1 为了防止数据流中存在01111110，每5个数据就会加1个0
// 如果出现过多的 1111111 表示错误信息，需要输出一个错误信号
module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);

parameter ARBIT = 1'b1,
          WAIT  = 1'b0;

reg state;
reg [5:0] cnt_bit;

always @(posedge clk ) begin
    if (reset)
        cnt_bit <= 6'd0;
    else if (!in)
        cnt_bit <= 6'd0;
    else if (cnt_bit == 6'd7)
        cnt_bit <= 6'd7;
    else
        cnt_bit <= cnt_bit + 1'b1;
end

always @(posedge clk ) begin
    if (reset)
        state <= ARBIT;
    else 
        case (state)
            ARBIT :
                if (in && cnt_bit == 6'd6)
                    state <= WAIT;
                else 
                    state <= ARBIT;
            WAIT :
                if (!in)
                    state <= ARBIT;
                else 
                    state <= WAIT;
            default : state <= ARBIT;
        endcase
end

always @(posedge clk ) begin
    if (reset)
        flag <= 1'b0;
    else if (!in && cnt_bit == 6'd6)
        flag <= 1'b1;
    else 
        flag <= 1'b0;
end

always @(posedge clk ) begin
    if (reset)
        disc <= 1'b0;
    else if (!in && cnt_bit == 6'd5)
        disc <= 1'b1;
    else 
        disc <= 1'b0;
end

always @(posedge clk ) begin
    if (reset)
        err <= 1'b0;
    else if((in && cnt_bit == 6'd6 )
            ||(state == WAIT && in)) 
        err <= 1'b1;
    else
        err <= 1'b0;
end

endmodule
