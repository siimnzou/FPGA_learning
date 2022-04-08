`timescale 1ns/1ns
module TB_SDRAM_RD();

reg clk;
reg rst_n;

reg         wr_en;
wire [3:0]  init_cmd;
wire [1:0]  init_ba;
wire [12:0] init_addr;
wire        init_end;
wire        clk_50;
wire        clk_100;
wire        clk_100_shift;  
wire        locked;
wire        rst_n_lock;
reg [15:0]  wr_data_in;
wire [3:0]  wr_cmd ;      
wire        wr_ack ;       
wire        wr_end ;    
wire [1:0]  wr_ba;
wire [12:0] wr_sdram_addr;
wire        wr_sdram_en;
wire [16:0] wr_sdram_data;
wire [3:0]  sdram_cmd;
wire [1:0]  sdram_ba;
wire [12:0] sdram_addr;
wire [15:0] sdram_data;

wire [3:0]  wr_rd_cmd;
wire [1:0]  wr_rd_ba;
wire [12:0] wr_rd_addr;

wire [3:0]  rd_cmd;
wire        rd_ack;
wire        rd_end;
wire [1:0]  rd_ba;
wire [12:0] rd_sdram_addr;
wire [15:0] rd_sdram_data;
reg        rd_en;

initial begin
    clk = 1'b1;
    rst_n <= 1'b0;
    #20
    rst_n <= 1'b1;
end

always #10 clk = ~ clk;

assign rst_n_lock = rst_n & locked;

assign  sdram_cmd  = (init_end)? wr_rd_cmd  : init_cmd;
assign  sdram_addr = (init_end)? wr_rd_ba   : init_addr;
assign  sdram_ba   = (init_end)? wr_rd_addr : init_ba;

assign  wr_rd_cmd   = (wr_en)? wr_cmd        : rd_cmd       ;
assign  wr_rd_ba    = (wr_en)? wr_sdram_addr : rd_sdram_addr; 
assign  wr_rd_addr  = (wr_en)? wr_ba         : rd_ba        ;    

assign  sdram_data = (wr_sdram_en) ? wr_sdram_data : 16'hzzzz;

always @(posedge clk_100 or negedge rst_n) begin
    if(~rst_n)
        wr_data_in <= 16'd0;
    else if (wr_data_in == 16'd10)
        wr_data_in <= 16'd0;
    else if (wr_ack)
        wr_data_in <= wr_data_in + 1'b1;
    else 
        wr_data_in <= wr_data_in;
end

always @(posedge clk_100 or negedge rst_n) begin
    if(~rst_n)
        wr_en <= 1'b1;
    else if (wr_end)
        wr_en <= 1'b0;
    else 
        wr_en <= wr_en;
end

always @(posedge clk_100 or negedge rst_n) begin
    if(~rst_n)
        rd_en <= 1'b0;
    else if (rd_end)
        rd_en <= 1'b0;
    else if (~wr_en)
        rd_en <= 1'b1;
    else 
        rd_en <= rd_en;
end

defparam  SDRAM_MODULE_INST.addr_bits = 13;
defparam  SDRAM_MODULE_INST.data_bits = 16;
defparam  SDRAM_MODULE_INST.col_bits = 9;
defparam  SDRAM_MODULE_INST.mem_sizes = 2*1024*1024;


clk_gen	clk_gen_inst 
(
	.areset (~rst_n  ),
	.inclk0 (  clk),
	.c0 (clk_50 ),
	.c1 ( clk_100 ),
	.c2 ( clk_100_shift ),
	.locked ( locked)
);


SDRAM_INIT SDRAM_INIT_INST
(
    .clk(clk_100),   // 时钟频率为100MHz
    .rst_n(rst_n_lock),

    .init_cmd(init_cmd),
    .init_ba(init_ba),
    .init_addr(init_addr),
    . init_end(init_end)
);

SDRAM_WR SDRAM_WR_INST
(
   .clk           (clk_100 )  ,
   .rst_n         (rst_n_lock)  ,
   .init_end      (init_end)  ,
   .wr_en         (wr_en)  ,
   .wr_addr       (24'h000_000)  ,    // 两位宽bank地址 13位宽行地址、9位宽列地址
   .wr_data       (wr_data_in)  ,    
   .wr_burst_len  (10'd10)  ,    // 采用页突发，一页512个，采用突发停止模式，可以实现任意长度的写入

   .wr_cmd        (wr_cmd        )  ,
   .wr_ack        (wr_ack        )  ,
   .wr_end        (wr_end        )  ,
   .wr_ba         (wr_ba         )  ,
   .wr_sdram_addr (wr_sdram_addr )  ,
   .wr_sdram_en  (wr_sdram_en  )  ,
   . wr_sdram_data( wr_sdram_data)
);

SDRAM_RD SDRAM_RD_INST
(
    .clk           (clk_100 ),
    .rst_n         (rst_n_lock),     
    .init_end      (init_end),
    .rd_en         (rd_en),
    .rd_addr       (24'h000_000),    // 两位宽bank地址 13位宽行地址、9位宽列地址
    .rd_data       (sdram_data),    
    .rd_burst_len  (10'd10),  // 采用页突发，一页512个，采用突发停止模式，可以实现任意长度的写入

    .rd_cmd        (rd_cmd        ),
    . rd_ack       ( rd_ack       ),
    . rd_end       ( rd_end       ),
    .rd_ba         (rd_ba         ),
    .rd_sdram_addr (rd_sdram_addr ),
    . rd_sdram_data( rd_sdram_data)

);

sdram_model_plus SDRAM_MODULE_INST
(
    .Dq(sdram_data), 
    .Addr(sdram_addr),
    .Ba(sdram_ba),
    .Clk(clk_100_shift), 
    .Cke(1'b1), 
    .Cs_n(sdram_cmd[3]), 
    .Ras_n(sdram_cmd[2]), 
    .Cas_n(sdram_cmd[1]), 
    .We_n(sdram_cmd[0]), 
    .Dqm(2'b00),
    .Debug(1'b1)
);

endmodule