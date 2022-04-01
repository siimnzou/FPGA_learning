// PS/2 鼠标协议每次发送的字节长度为3，当再一个连续字节流中，信息的开始和结束并不明显
// 唯一的标志是第一个字节的bit[3]始终会是1，而其他两个字节则取决与数据
// 目标是建立一个状态机来找出给定数据流的起点，知道找到第一个bit[3] = 1的字节前，前面的数据都会丢弃
// 这个字节会被视为是第一个字节，并且当三个字节都接收完成后发出完成信号
// 现在添加一个数据输出通道来输出这3个比特的数据。最高位是第一个数据，以此类推
module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
    output done); //

parameter IDLE = 1'b1,
          TRANS = 1'b0;

reg       state; 
reg [1:0] cnt_byte;
reg [23:0] out_bytes_reg;

always @(posedge clk) begin
    if (reset)
        state <= IDLE ;
    else
        case(state)
            IDLE : 
                if (in[3])
                    state <= TRANS;
                else 
                    state <= IDLE;
            TRANS :
                if (cnt_byte == 2'd1)
                    state <= IDLE;
                else 
                    state <= TRANS;
            default: state <= IDLE;
        endcase    
end

 // 如果IDLE状态中出现了开始信号，则开始计数，除去第一个数据后还需要另外2个数据
always @(posedge clk) begin
    if (reset)
        cnt_byte <= 2'd0 ;
    else if (state == TRANS && cnt_byte == 2'd1)
        cnt_byte <= 2'd0 ;
    else if (state == TRANS)
        cnt_byte <= cnt_byte + 1'b1;
    else 
        cnt_byte <= 2'd0;
end

always @(posedge clk ) begin
    if (reset)
        done <= 1'b0;
    else if (state == TRANS && cnt_byte == 2'd1)
        done <= 1'b1;
    else 
        done <= 1'b0;
end

always @(posedge clk ) begin
    if (reset)
        out_bytes_reg <= 24'd0;
    else if (state == IDLE)
        out_bytes_reg[23:16] <= in;
    else if (state == TRANS && cnt_byte == 2'd0)
        out_bytes_reg[15:8] <= in;
    else if (state == TRANS && cnt_byte == 2'd1)
        out_bytes_reg[7:0]  <= in;
    else 
        out_bytes_reg <= out_bytes_reg;
end

assign out_bytes = (done)? out_bytes_reg : 24'b0;
endmodule


