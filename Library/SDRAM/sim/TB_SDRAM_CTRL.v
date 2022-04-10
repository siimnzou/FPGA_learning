`timescale 1ns/1ns
module TB_SDRAM_CTRL();


defparam  SDRAM_MODULE_INST.addr_bits = 13;
defparam  SDRAM_MODULE_INST.data_bits = 16;
defparam  SDRAM_MODULE_INST.col_bits = 9;
defparam  SDRAM_MODULE_INST.mem_sizes = 2*1024*1024;

defparam  SDRAM_CTRL_INST.SDRAM_AREF_INST.AREF_CYCLE = 50;

reg         clk;
reg         rst_n;
wire        clk_50;
wire        clk_100;
wire        clk_100_shift;  
wire        locked;
wire        rst_n_lock;
reg        wr_en     ;
reg        rd_en     ;
wire        wr_ack    ;
wire        rd_ack;
wire [15:0] sdram_rd_data_out ;
wire        sdram_cke   ;
wire        sdram_cs_n  ;
wire        sdram_cas_n;
wire        sdram_ras_n;
wire        sdram_we_n ;
wire [1:0]  sdram_ba    ;
wire [12:0] sdram_addr;
wire  [15:0] sdram_dq   ;
reg  [15:0]  wr_data_in;
wire       init_end ;

initial begin
    clk = 1'b1;
    rst_n <= 1'b0;
    #20
    rst_n <= 1'b1;
end
always #10 clk = ~ clk;
assign rst_n_lock = rst_n & locked;

always @(posedge clk_100 or negedge rst_n) begin
    if(~rst_n)
        wr_en <= 1'b1;
    else if (wr_data_in == 16'd10)
        wr_en <= 1'b0;
    else 
        wr_en <= wr_en;
end

always @(posedge clk_100 or negedge rst_n) begin
    if(~rst_n)
        rd_en <= 1'b0;
    else if (~wr_en)
        rd_en <= 1'b1;
    else 
        rd_en <= rd_en;
end

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

clk_gen	clk_gen_inst 
(
	.areset (~rst_n  ),
	.inclk0 (  clk),
	.c0 (clk_50 ),
	.c1 ( clk_100 ),
	.c2 ( clk_100_shift ),
	.locked ( locked)
);

SDRAM_CTRL   SDRAM_CTRL_INST
(
    .clk                (clk_100)    ,
    .rst_n              (rst_n_lock)    ,
    .init_end           (init_end)    ,

    .sdram_wr_req       (wr_en)    ,
    .sdram_wr_data      (wr_data_in)    ,
    .sdram_wr_addr      (24'h000000)    ,
    .sdram_wr_burst_len (10'd10)    ,
    .sdram_wr_ack       (wr_ack)    ,  

    .sdram_rd_req       (rd_en)    ,
    .sdram_rd_addr      (24'h000000)    ,
    .sdram_rd_burst_len (10'd10)    ,
    .sdram_rd_ack       (rd_ack)    ,
    .sdram_rd_data_out  (sdram_rd_data_out)    ,

    .sdram_cke          (sdram_cke   )    ,
    .sdram_cs_n         (sdram_cs_n  )    ,
    .sdram_cas_n        (sdram_cas_n )    ,
    .sdram_ras_n        (sdram_ras_n )    ,
    .sdram_we_n         (sdram_we_n  )    ,
    .sdram_ba           (sdram_ba    )    ,
    .sdram_addr         (sdram_addr  )    ,
    .sdram_dq           (sdram_dq    )
);

sdram_model_plus SDRAM_MODULE_INST
(
    .Dq(sdram_dq), 
    .Addr(sdram_addr),
    .Ba(sdram_ba),
    .Clk(clk_100_shift), 
    .Cke(sdram_cke), 
    .Cs_n(sdram_cs_n), 
    .Ras_n(sdram_ras_n), 
    .Cas_n(sdram_cas_n), 
    .We_n(sdram_we_n), 
    .Dqm(2'b00),
    .Debug(1'b1)
);

endmodule