module SDRAM_VGA_PIC
(
    input       rx         ,
    input       clk        ,
    input       rst_n      ,

    output wire        sdram_clk ,
    output wire        sdram_cke ,
    output wire        sdram_cs_n,
    output wire        sdram_cas_n,
    output wire        sdram_ras_n,
    output wire        sdram_we_n,
    output wire [1:0]  sdram_ba,
    output wire [12:0] sdram_addr,
    output wire  [1:0] sdram_dqm ,
    inout  wire  [15:0] sdram_dq,
    output wire [15:0]  rgb_565 ,
    output wire         hsync,
    output wire         vsync
);

parameter H_VALID    = 'd1280,
          V_VALID    = 'd1024;

parameter UART_BPS   =  'd115200 ,
          CLK_FREQ   =  'd50_000_000,
          BAUD_CNT_MAX = CLK_FREQ/UART_BPS;

wire  clk_50m;
wire  clk_108m;
wire  clk_100m;
wire  clk_100m_shift;
wire  locked;
wire  locked1;
wire  rst_n_locked;
wire [7:0]  rx_data ;
wire        wr_fifo_wr_req;
wire [15:0] rd_fifo_rd_data ;
wire [15:0] pix_data ;
wire [11:0] x_loc;
wire [11:0] y_loc;
wire pix_data_req;

assign rst_n_locked = locked & rst_n & locked1;

//  RGB332 to RGB565
assign pix_data = {rd_fifo_rd_data[7:5],2'b0,rd_fifo_rd_data[4:2],3'b0,rd_fifo_rd_data[1:0],3'b0};

CLK_GEN	CLK_GEN_inst (
	.areset ( ~rst_n  ),
	.inclk0 ( clk ),
	.c0 ( clk_50m ),
	.c1 ( clk_100m ),
	.c2 ( clk_100m_shift ),
	.locked ( locked1 )
	);

CLK_VGA	CLK_VGA_inst (
	.areset ( ~rst_n ),
	.inclk0 ( clk ),
	.c0 ( clk_108m ),
	.locked ( locked )
	);



uart_rx
#(
    .UART_BPS   (UART_BPS  )      ,
    .CLK_FREQ   (CLK_FREQ) ,
    .BAUD_CNT_MAX(BAUD_CNT_MAX)
)
UART_RX_INST
(
   .sys_clk   (clk_50m)   ,
   .sys_rst_n (rst_n_locked)   ,
   .rx        (rx)   ,

   .po_data   (rx_data)    ,
   .po_flag   (wr_fifo_wr_req)
);


SDRAM SDRAM_INST
(
    .clk(clk_100m),
    .rst_n(rst_n_locked),
    .clk_out(clk_100m_shift),


    .wr_fifo_wr_clk  (clk_50m),
    .wr_fifo_wr_req  (wr_fifo_wr_req),
    .wr_fifo_wr_data ({8'b0,rx_data}),
    .sdram_wr_b_addr (24'd0),
    .sdram_wr_e_addr (H_VALID*V_VALID),
    .wr_burst_len    (10'd512),
    .wr_rst          (~rst_n_locked),               // 写地址清零信号 

    .rd_fifo_rd_clk (clk_108m),
    .rd_fifo_rd_req (pix_data_req),
    .sdram_rd_b_addr(24'd0),
    .sdram_rd_e_addr(H_VALID*V_VALID),
    .rd_burst_len   (10'd512),
    .rd_valid       (1'b1),
    .rd_rst         (), 
    .rd_fifo_rd_data(rd_fifo_rd_data),
    .rd_fifo_num    (),

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

VGA_CTRL VGA_CTRL_INST
(
    .clk        (clk_108m),
    .rst_n      (rst_n_locked),
    .pix_data   (pix_data),

    .rgb_565    (rgb_565 ),
    .hsync      (hsync ),
    .vsync      (vsync ),
    .x_loc      (x_loc),
    .y_loc      (y_loc) ,  // 位宽设置大一点以便于分辨率的修改
    .pix_data_req (pix_data_req)
);

endmodule