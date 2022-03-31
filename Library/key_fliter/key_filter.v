module key_filter
#(
parameter CNT_MAX= 20'd 999999
)
(
    input wire clk,
    input wire rst_n,
    input wire key_in,
    
    output reg key_flag

);

reg [19:0] cnt_20ms;

always@(posedge clk or negedge rst_n) begin
    if (!rst_n)
        cnt_20ms <= 20'd0;
    else if (key_in == 1'b1)
        cnt_20ms <= 20'd0;
    else if (cnt_20ms == CNT_MAX)
        cnt_20ms <= cnt_20ms;
    else
        cnt_20ms <= cnt_20ms + 20'd1;
end        

always@(posedge clk or negedge rst_n) begin
    if (!rst_n)
        key_flag <= 1'b0;
    else if (cnt_20ms == (CNT_MAX-20'd1))
        key_flag <= 1'b1;
    else 
        key_flag <= 1'b0;
end

endmodule       
