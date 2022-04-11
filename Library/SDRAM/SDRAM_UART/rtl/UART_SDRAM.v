module UART_SDRAM
(
    input clk,
    input rst_n,
    input rx,

    output wire        tx ,
    output wire        sdram_clk ,
    output wire        sdram_cke ,
    output wire        sdram_cs_n,
    output wire        sdram_cas_n,
    output wire        sdram_ras_n,
    output wire        sdram_we_n,
    output wire [1:0]  sdram_ba,
    output wire [12:0] sdram_addr,
    output wire [1:0]  sdram_dqm ,
    inout  wire [15:0] sdram_dq   
);

parameter  UART_BPS  = 'd9600,
           CLK_FREQ  = 'd50_000_000;

parameter  DATA_NUM  = 'd10;

parameter WAIT_MAX  = 'd750;

wire        clk_50;
wire        clk_100;
wire        clk_100_shift;  
wire        locked;
wire [7:0]  rx_data;
wire        rx_flag;
wire [7:0]  rd_fifo_rd_data;
wire        rd_fifo_rd_req ;
wire [9:0]  rd_fifo_num ;
wire [7:0]  tx_data;
wire        tx_flag;
reg         read_valid;
reg  [15:0] cnt_wait;
reg  [23:0] data_num;
wire        rst_n_locked ;

always @(posedge clk_50 or negedge rst_n) begin
    if(~rst_n)
        cnt_wait <= 16'd0;
    else if (cnt_wait == WAIT_MAX)    
        cnt_wait <= 16'd0;
    else if (data_num == DATA_NUM)
        cnt_wait <= cnt_wait + 1'b1;
end

always @(posedge clk_50 or negedge rst_n) begin
    if(~rst_n)
        data_num <= 24'd0;
    else if (read_valid)    
        data_num <= 24'd0;
    else if (rx_flag) 
        data_num <= data_num + 1'b1;
    else 
        data_num <= data_num ;
end

always @(posedge clk_50 or negedge rst_n) begin
    if(~rst_n)
        read_valid <= 1'b0;
    else if (cnt_wait == WAIT_MAX)    
        read_valid <= 1'b1;
    else if (rd_fifo_num == DATA_NUM) 
        read_valid <= 1'b0;
end

assign rst_n_lock = rst_n & locked;

clk_gen	clk_gen_inst 
(
	.areset (~rst_n  ),
	.inclk0 (  clk),
	.c0 (clk_50 ),
	.c1 ( clk_100 ),
	.c2 ( clk_100_shift ),
	.locked ( locked)
);

uart_rx 
#(
    . UART_BPS (UART_BPS ) ,
    . CLK_FREQ (CLK_FREQ )
)
uart_rx_inst
(
   .  sys_clk   (clk_50  )    ,
   .  sys_rst_n (rst_n_lock)    ,
   .  rx        (rx       )    ,

   . po_data    (rx_data )   ,
   . po_flag    (rx_flag )
);



SDRAM SDRAM_INST
(
    .clk(clk_100),
    .rst_n(rst_n_lock),
    .clk_out(clk_100_shift),


    .wr_fifo_wr_clk  (clk_50),
    .wr_fifo_wr_req  (rx_flag),
    .wr_fifo_wr_data ({8'b0,rx_data}),
    .sdram_wr_b_addr (24'd0),
    .sdram_wr_e_addr (DATA_NUM),
    .wr_burst_len    (DATA_NUM),
    .wr_rst          (~rst_n_lock),               // 写地址清零信号 

    .rd_fifo_rd_clk (clk_50),
    .rd_fifo_rd_req (rd_fifo_rd_req),
    .sdram_rd_b_addr(24'd0),
    .sdram_rd_e_addr(DATA_NUM),
    .rd_burst_len   (DATA_NUM),
    .rd_valid       (read_valid),
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

uart_tx
#(
    .UART_BPS (UART_BPS   ),
    .CLK_FREQ (CLK_FREQ   )
)
uart_tx_inst
(
   .sys_clk      (clk_50  ) ,
   .sys_rst_n    (rst_n_lock) ,
   .pi_data      (tx_data  ) , 
   .pi_flag      (tx_flag  ) ,
   
   .tx (tx)             
);

FIFO_READ FIFO_READ_INST
(
    .clk             (clk_50 ),    
    .rst_n           (rst_n_lock),    
    .rd_fifo_num     (rd_fifo_num),     
    .rd_fifo_rd_data (rd_fifo_rd_data),    
    .brust_len       (DATA_NUM), 

    .rd_en           (rd_fifo_rd_req),   
    .tx_data         (tx_data),  
    .tx_flag         (tx_flag)    
);

endmodule