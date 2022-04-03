// 设计单输入单输出的串行两位补码状态机
// 输出x时候一系列数据，输出z是输入
// 根据补码，转换规则为 第一次出现的1不变 , 其余后面的其全部取反
// 此处采用的是Moore 型状态机
// 虽然我不理解为啥明明采用Mealy型的简单易懂还要去用Moore型恶心自己
module top_module (
    input clk,
    input areset,
    input x,
    output z
); 

parameter KEEP     = 3'b001,
          REVERSE0  = 3'b010,
          REVERSE1  = 3'b100;

reg [2:0] state;

always @(posedge clk  or posedge areset ) begin
    if (areset)
        state <=  KEEP;
    else 
        case (state)
            KEEP :
                if (x)
                    state <= REVERSE1;
                else 
                    state <= KEEP;
            REVERSE1:
                if (x)
                    state <= REVERSE0;
                else
                    state <= REVERSE1;
            REVERSE0:
                if (!x)
                    state <= REVERSE1;
                else 
                    state <= REVERSE0;
            default: state <= KEEP;
        endcase
end

assign z = (state == KEEP)? 1'b0 : (state == REVERSE1)? 1'b1 : 1'b0;

endmodule