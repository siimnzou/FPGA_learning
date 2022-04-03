// 设计单输入单输出的串行两位补码状态机
// 输出x时候一系列数据，输出z是输入
// 根据补码，转换规则为 第一次出现的1不变 , 其余后面的其全部取反
// 此处采用的是Mealy 型状态机
module top_module (
    input clk,
    input areset,
    input x,
    output z
); 

parameter KEEP     = 1'b1,
          REVERSE  = 1'b0;

reg state;

always @(posedge clk  or posedge areset ) begin
    if (areset)
        state <=  KEEP;
    else 
        case (state)
            KEEP :
                if (x)
                    state <= REVERSE;
                else 
                    state <= KEEP;
            REVERSE:
                    state <= REVERSE;
            default: state <= KEEP;
        endcase
end

assign z = (state == KEEP)? x : !x;


endmodule