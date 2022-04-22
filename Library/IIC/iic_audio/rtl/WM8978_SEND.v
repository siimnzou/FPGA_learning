module WM8978_SEND 
(
    input rst_n,
    input lrc,
    input bclk,
    input [23:0] adc_data,
    
    output reg wm8978_dac_data,
    output reg send_done 
);

reg lrc_reg;
wire lrc_edge;

reg [4:0] data_cnt;
reg [23:0] data_reg;


// 根据时序图，需要采集LRC的上升和下降沿
    
always @(posedge bclk or negedge rst_n) begin
    if(~rst_n)
        lrc_reg <= 1'b0;
    else
        lrc_reg <= lrc;
end

assign lrc_edge = lrc ^ lrc_reg;

always @(posedge bclk or negedge rst_n ) begin
    if (~rst_n)
        data_cnt <= 5'd0;
    else if (lrc_edge)
        data_cnt <= 5'd0;
    else if (data_cnt == 5'd25)
        data_cnt <= 5'd25;
    else 
        data_cnt <= data_cnt + 1'b1;
end

always @(posedge bclk or negedge rst_n ) begin
    if (~rst_n)
        data_reg <= 24'd0;
    else if (lrc_edge)
        data_reg <= adc_data;    
end

always @(negedge bclk or negedge rst_n ) begin
    if (~rst_n)
        wm8978_dac_data <= 1'b0;
    else if (data_cnt < 5'd24)
        wm8978_dac_data <= data_reg[23 - data_cnt];
end

always @(posedge bclk or negedge rst_n) begin
    if (~rst_n)
        send_done <= 1'b0;
    else if (data_cnt == 5'd24)
        send_done <= 1'b1;
    else 
        send_done <= 1'b0;
end

endmodule