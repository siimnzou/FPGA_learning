// 序列识别
// 识别一串数据流中的101，当识别到后输出一个flag信号，可以做到连续识别

module top_module (
    input clk,
    input aresetn,    // Asynchronous active-low reset
    input x,
    output z ); 

parameter FIRST = 3'b001,
          SECOND = 3'b010,
          THIRD  = 3'b100;

reg [2:0] state;

always @(posedge clk or negedge aresetn) begin
    if (!aresetn)
        state <= FIRST;
    else 
        case (state)
            FIRST:
                if (x)
                    state <= SECOND;
                else 
                    state <= FIRST;
            SECOND:
                if (!x)
                    state <= THIRD;
                else 
                    state <= SECOND;
            THIRD : 
                if (x)
                    state <= SECOND;
                else 
                    state <= FIRST;
            default : state <= FIRST;
        endcase  
end 

assign z = (state == THIRD && x);

endmodule