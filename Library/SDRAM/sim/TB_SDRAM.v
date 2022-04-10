`timescale 1ns/1ns
module TB_SDRAM();

reg         clk;
reg         rst_n;
wire        clk_50;
wire        clk_100;
wire        clk_100_shift;  
wire        locked;
wire        rst_n_lock;
wire   [15:0]    rd_fifo_rd_data;
wire   [9:0]     rd_fifo_num  ;  
reg   rd_valid ;

wire        sdram_clk ;
wire        sdram_cke ;
wire        sdram_cs_n;
wire        sdram_cas_n;
wire        sdram_ras_n;
wire        sdram_we_n;
wire [1:0]  sdram_ba;
wire [12:0] sdram_addr;
wire        sdram_dqm ;
wire  [15:0] sdram_dq  ;  

reg         wr_data_flag;
reg [15:0]  wr_data_in  ;
reg [2:0]   cnt_wr_wait ;
reg         wr_en ;
reg         rd_en ;
reg [3:0]      cnt_rd_data ;

always @(posedge clk_50 or negedge rst_n_lock) begin
    if(~rst_n_lock)
        cnt_wr_wait <= 3'd0;
    else if (wr_en)
        cnt_wr_wait <= cnt_wr_wait + 1'b1;
    else 
        cnt_wr_wait <= 3'd0;
end

always @(posedge clk_50 or negedge rst_n_lock) begin
    if(~rst_n_lock)
        wr_data_flag <= 1'b0;
    else    if (cnt_wr_wait == 3'd7)
        wr_data_flag <= 1'b1;
    else 
        wr_data_flag <= 1'b0;
end

always @(posedge clk_50 or negedge rst_n_lock) begin
    if(~rst_n_lock)
        wr_data_in <= 16'd0;
    else    if (cnt_wr_wait == 3'd7)
        wr_data_in <= wr_data_in + 1'b1;
    else 
        wr_data_in <= wr_data_in;
end

always @(posedge clk_50 or negedge rst_n_lock) begin
    if(~rst_n_lock)
        wr_en <= 1'b1;
    else   if (wr_data_in == 16'd10)
        wr_en <= 1'b0;
    else    
        wr_en <= wr_en;
end

always @(posedge clk_50 or negedge rst_n_lock) begin
    if(~rst_n_lock)
        rd_en <= 1'b0;
    else   if (cnt_rd_data == 4'd9)
        rd_en <= 1'b0;
    else    if (~wr_en && rd_fifo_num == 10'd10)
        rd_en <= 1'b1;
    else 
        rd_en <= rd_en;
end

always @(posedge clk_50 or negedge rst_n_lock) begin
    if(~rst_n_lock)
        cnt_rd_data <= 4'b0;
    else    if (rd_en)
        cnt_rd_data <= cnt_rd_data + 1'b1;
    else 
        cnt_rd_data <= 4'd0;
end

always @(posedge clk_50 or negedge rst_n_lock) begin
    if(~rst_n_lock)
        rd_valid <= 1'b1;
    else    if (rd_fifo_num == 10'd10)
        rd_valid <= 1'b0;
    else 
        rd_valid <= rd_valid;
end

defparam  SDRAM_MODULE_INST.addr_bits = 13;
defparam  SDRAM_MODULE_INST.data_bits = 16;
defparam  SDRAM_MODULE_INST.col_bits = 9;
defparam  SDRAM_MODULE_INST.mem_sizes = 2*1024*1024;

defparam  SDRAM_INST.SDRAM_CTRL_INST.SDRAM_AREF_INST.AREF_CYCLE = 50;

initial begin
    clk = 1'b1;
    rst_n <= 1'b0;
    #20
    rst_n <= 1'b1;
end
always #10 clk = ~ clk;
assign rst_n_lock = rst_n & locked;

SDRAM SDRAM_INST
(
    .clk(clk_100),
    .rst_n(rst_n_lock),
    .clk_out(clk_100_shift),


    .wr_fifo_wr_clk  (clk_50),
    .wr_fifo_wr_req  (wr_data_flag),
    .wr_fifo_wr_data (wr_data_in),
    .sdram_wr_b_addr (24'd0),
    .sdram_wr_e_addr (24'd10),
    .wr_burst_len    (10'd10),
    .wr_rst          (~rst_n_lock),               // 写地址清零信号 

    .rd_fifo_rd_clk (clk_50),
    .rd_fifo_rd_req (rd_en),
    .sdram_rd_b_addr(24'd0),
    .sdram_rd_e_addr(24'd10),
    .rd_burst_len   (10'd10),
    .rd_valid       (rd_valid),
    .rd_rst         (~rst_n_lock), 
    .rd_fifo_rd_data(rd_fifo_rd_data),
    .rd_fifo_num    (rd_fifo_num),

    .sdram_clk  (sdram_clk  ),
    .sdram_cke  (sdram_cke  ),
    .sdram_cs_n (sdram_cs_n ),
    .sdram_cas_n(sdram_cas_n),
    .sdram_ras_n(sdram_ras_n),
    .sdram_we_n (sdram_we_n ),
    .sdram_ba   (sdram_ba   ),
    .sdram_addr (sdram_addr ),
    .sdram_dqm  (sdram_dqm  ),
    .sdram_dq   (sdram_dq   )

);

clk_gen	clk_gen_inst 
(
	.areset (~rst_n  ),
	.inclk0 (  clk),
	.c0 (clk_50 ),
	.c1 ( clk_100 ),
	.c2 ( clk_100_shift ),
	.locked ( locked)
);

sdram_model_plus SDRAM_MODULE_INST
(
    .Dq(sdram_dq), 
    .Addr(sdram_addr),
    .Ba(sdram_ba),
    .Clk(sdram_clk), 
    .Cke(sdram_cke), 
    .Cs_n(sdram_cs_n), 
    .Ras_n(sdram_ras_n), 
    .Cas_n(sdram_cas_n), 
    .We_n(sdram_we_n), 
    .Dqm(sdram_dqm),
    .Debug(1'b1)
);

endmodule