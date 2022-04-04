// 构建用于电机控制的状态机，有电机的输入x和y，产生控制电机的输出f和g 一个时钟和一个复位
// 复位有时进入开始状态A,复位有效就一直保持在A，当复位无效的时候，在下一个时钟沿之后将输出f拉高一个周期
// 然后观察x，当x在三个连续的时钟周期中产生101时。应在下一个时钟周期将g拉高
// g拉高后监控y，如果在最多两个周期内为1.g永久保持1直到复位但是如果两个周期都没有不变1 则永久置0.

module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input x,
    input y,
    output f,
    output g
); 

parameter  IDLE  = 6'b000001,
           START = 6'b000010,
           X_MON = 6'b000100,
           Y_MON = 6'b001000,
           G1    = 6'b010000,
           G0    = 6'b100000;

reg [5:0] state ;
reg [1:0] x_reg ;
reg y_reg;
reg [1:0] cnt;


always @(posedge clk) begin
    if (!resetn)
        state <= IDLE;
    else 
        case(state)
            IDLE:
                state <= START;  
            START:
                state <= X_MON;
            X_MON:
                if (x_reg == 2'b10 && x )
                    state <= Y_MON;
                else 
                    state <= X_MON;
            Y_MON:
                if (y_reg && cnt == 2'd1 || y && cnt == 2'd1)
                    state <= G1;
                else if(!y_reg && cnt == 2'd1 || !y && cnt == 2'd1)
                    state <= G0;
                else
                    state <= Y_MON;
            G1 :
                state <= G1;
            G0 :
                state <= G0;
            default : state <= IDLE;
        endcase
end

always @(posedge clk ) begin
    if(!resetn)
        cnt <= 2'b0;
    else if(state == Y_MON && cnt == 2'd1)
        cnt <= 2'b0; 
    else if (state == Y_MON)
        cnt <= cnt + 1'b1;
    else 
        cnt <= 2'b0;
end

always @(posedge clk ) begin
    if(!resetn)
        x_reg <= 2'b00;
    else if(state == X_MON)
        x_reg <= {x_reg[0],x};
    else 
        x_reg <= 2'b00;
end

always @(posedge clk ) begin
    if(!resetn)
        y_reg <= 1'b0;
    else if(state == Y_MON)
        y_reg <= y;
    else 
        y_reg <= 1'b0;
end

assign f = (state == START);
assign g = (state == Y_MON || state == G1)? 1'b1 : 1'b0;

endmodule
