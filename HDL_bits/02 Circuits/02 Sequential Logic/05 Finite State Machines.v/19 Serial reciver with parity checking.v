// 在一些串行通信协议中，每个字节的发送都必须有开始位和结束位，为了帮助从数据流中划分数据
// 会有一个开始信号 0 ，然后是8个数据位 ，然后一个结束信号 1 ，在空闲状态下串行线也会处于1
// 编写状态机，开始位后记录8位数据，然后等待结束位出现后在尝试接收下一个状态
// 串口首先发送最低位
// 奇偶校验位 添加奇校验，当9bitz中奇数个数为1时候才算校验成功，数据接收正确。

module top_module(
    input clk,
    input in,
    input reset,
    output [7:0] out_byte,    
    output reg done
    
); 

reg [2:0]  cnt_bit;
reg [4:0]   state;
reg        in_reg ;
reg [7:0]  data_reg;
wire       odd;
wire       parity_in;
wire       parity_reset;             
reg        parity_valid;
reg        check_flag;

parameter IDLE  = 5'b00001,
          TRANS = 5'b00010,
          CHECK = 5'b00100,
          END   = 5'b01000,
          DISCARD = 5'b10000;

// 定义三个状态，IDLE状态，检测到开始信号后进入TRANS状态，同时cnt_bit 开始计数，计数到7后进入END状态
// 在END状态中判断是否出现结束信号，如果没有找到结束位后会进入DISCARD状态，此时等待高电平in信号后跳回IDLE但不发送done信号
// 若在EDN状态in出现高电平后发送done 信号，并且跳回IDLE状态



always @(posedge clk ) begin
    if (reset)
        state <= IDLE;
    else
        case (state)
        IDLE : 
            if (!in )  
                state <= TRANS;
            else 
                state <= IDLE;
        TRANS :
            if(cnt_bit == 3'd7)
                state <= CHECK;
            else 
                state <= TRANS;
        CHECK:
            state <= END;
        END:
            if (in)
                state <= IDLE ;
            else 
                state <= DISCARD;
        DISCARD:
            if (in)
                state <= IDLE;
            else 
                state <= DISCARD;
        default:state <= IDLE ;
        endcase 
end

always @(posedge clk ) begin
    if (reset)
        cnt_bit <= 3'd0;
    else if (state == TRANS && cnt_bit == 3'd7)
        cnt_bit <= 3'd0;
    else if (state == TRANS)
        cnt_bit <= cnt_bit + 1'b1;
    else
        cnt_bit <= 3'd0;
end

always @(posedge clk ) begin
    if (reset)
        done <= 1'b0;
    else if (state == END && in && odd == 1'b1)
        done <= 1'b1;
    else 
        done <= 1'b0;
end

always @(posedge clk ) begin
    if (reset)
        data_reg <= 8'b0;
    else if (state == TRANS)
        data_reg[cnt_bit] <= in;
    else 
        data_reg <= data_reg ;
end




assign out_byte = (done)? data_reg : 8'd0;
assign parity_reset = (state == TRANS || state == CHECK || state == END) ? 1'b0 : 1'b1;



parity parity_inst
(
    .clk(clk),
    .reset(parity_reset),
    .in(in),
    .odd(odd)
);

endmodule

