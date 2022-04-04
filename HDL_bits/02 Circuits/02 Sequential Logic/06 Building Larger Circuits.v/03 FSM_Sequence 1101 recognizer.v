// 构建有限状态机来在比特流中寻找序列1101
// 找到序列后将stary_shifting 一直拉高，后续还会扩展这个有限状态机
module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output start_shifting);

parameter IDLE = 1'b1,
          SHIFTING = 1'b0;

reg state;
reg [2:0] seq_reg;


always @(posedge clk ) begin
    if (reset)
        seq_reg <= 3'b0;
    else 
        seq_reg <= {seq_reg[1:0],data};    
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
                state <= SHIFTING;
            default: state <= IDLE;
        endcase
end

assign start_shifting = (state == SHIFTING);

endmodule
