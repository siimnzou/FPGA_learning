// 假设FSM有输出s和w，假设reset后状态为A，当s = 0时候一直是A，知道 s = 1时候才跳转到B状态
// 在状态B的时候，检测3个周期中的两个周期w的值，如果有两个周期为1，输出1的flag信号。每3个周期检查一次
module top_module (
    input clk,
    input reset,   // Synchronous reset
    input s,
    input w,
    output z
);

parameter A = 1'b0 ,
          B = 1'b1 ;

reg state ; 
reg [1:0] cnt_times;
reg [1:0] count;


always @(posedge clk ) begin
    if(reset)
        state <= A;
    else if (state == A && s == 1'b1)
        state <= B;
    else 
        state <= state;
end


always @(posedge clk ) begin
    if(reset)
        cnt_times <= 2'd0;
    else if (state == B && cnt_times == 2'd2)
        cnt_times <= 2'd0;
    else if (state == B)
        cnt_times <= cnt_times + 1'b1;
    else 
        cnt_times <= 2'd0; 
end

always @(posedge clk ) begin
    if(reset)
        count <= 2'd0;
    else if (state == B && cnt_times == 2'd2)
        count <= 2'd0;
    else if (state == B && w)
        count <= count + 1'b1;
    else 
        count <= count; 
end

always @(posedge clk ) begin
    if(reset)
        z <= 1'b0;
    else if (cnt_times == 2'd2 && count == 2'd2 && !w || cnt_times == 2'd2 && count == 2'd1 && w)
        z <= 1'b1;
    else 
        z <= 1'b0;
end

endmodule

