module FIFO_READ
(
    input clk,
    input rst_n,
    input      [9:0] rd_fifo_num,
    input wire [7:0] rd_fifo_rd_data ,
    input wire [9:0] brust_len,

    output reg rd_en ,
    output wire [7:0] tx_data ,
    output reg tx_flag 
);

parameter BAUD_CNT_MAX = 13'd5207;

reg          fifo_wr_en ;
wire  [9:0]  fifo_data_num;
reg          rd_flag ;
reg  [12:0]  baud_cnt ;
reg  [3:0]   bit_cnt ;
reg          bit_flag ;
reg          fifo_rd_en;
reg  [9:0]   cnt_read ;



always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        rd_en <= 1'b0;
    else if (rd_fifo_num == brust_len)
        rd_en <= 1'b1;
    else if (fifo_data_num == brust_len - 2)
        rd_en <= 1'b0;
    else 
        rd_en <= rd_en;
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        fifo_wr_en <= 1'b0;
    else 
        fifo_wr_en <= rd_en;
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        rd_flag <= 1'b0;
    else if (cnt_read == brust_len)
        rd_flag <= 1'b0;
    else if (fifo_data_num == brust_len)
        rd_flag <= 1'b1;
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        baud_cnt <= 13'd0;
    else if (baud_cnt == BAUD_CNT_MAX)
        baud_cnt <= 13'd0;
    else if (rd_flag)
        baud_cnt <=  baud_cnt + 1'b1;
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        bit_flag <= 1'b0;
    else if (baud_cnt == BAUD_CNT_MAX >> 1)
        bit_flag <= 1'b1;
    else 
        bit_flag <= 1'b0;
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        bit_cnt <= 4'd0;
    else if (bit_flag  && bit_cnt == 4'd9)
        bit_cnt <= 4'd0;
    else if (bit_flag)
        bit_cnt <=   bit_cnt + 1'b1;
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        fifo_rd_en <= 1'b0;
    else if (bit_flag && bit_cnt == 4'd9)
        fifo_rd_en <= 1'b1;
    else
        fifo_rd_en <= 1'b0;
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        cnt_read <= 10'd0;
    else if (cnt_read == brust_len)
        cnt_read <= 10'd0;
    else if (fifo_rd_en)
        cnt_read <= cnt_read + 1'b1;
    else 
        cnt_read <= cnt_read;
end

always @(posedge clk or negedge rst_n) begin
    if(~rst_n)
        tx_flag <= 1'b0;
    else 
        tx_flag <= fifo_rd_en;
end

read_fifo	read_fifo_inst 
(
	.clock ( clk ),
	.data ( rd_fifo_rd_data ),
	.rdreq ( fifo_rd_en ),
	.wrreq ( fifo_wr_en ),
	.q ( tx_data ),
	.usedw ( fifo_data_num )
);

endmodule