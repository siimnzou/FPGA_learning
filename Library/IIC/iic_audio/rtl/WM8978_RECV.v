module WM8978_RECV
(
    input rst_n,
    input lrc,
    input bclk,
    input wm8978_adc_data,
    
    output reg [23:0] adc_data,
    output reg        recv_done 
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
    else if (data_cnt < 5'd24)
        data_reg[23-data_cnt] <= wm8978_adc_data;    
end

always @(posedge bclk or negedge rst_n ) begin
    if (~rst_n)
        adc_data <= 24'b0;
    else if (data_cnt == 5'd24)
        adc_data <= data_reg;
end

always @(posedge bclk or negedge rst_n) begin
    if (~rst_n)
        recv_done <= 1'b0;
    else if (data_cnt == 5'd24)
        recv_done <= 1'b1;
    else 
        recv_done <= 1'b0;
end

endmodule