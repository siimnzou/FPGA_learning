`timescale 1ns/1ns
module TB_SDRAM_INIT ();

reg clk;
reg rst_n;

wire [3:0]  init_cmd;
wire [1:0]  init_ba;
wire [12:0] init_addr;
wire        init_end;
wire        clk_50;
wire        clk_100;
wire        clk_100_shift;  
wire        locked;
wire        rst_n_lock;

initial begin
    clk = 1'b1;
    rst_n <= 1'b0;
    #20
    rst_n <= 1'b1;
end

always #10 clk = ~ clk;

assign rst_n_lock = rst_n & locked;

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


sdram_model_plus SDRAM_MODULE_INST
(
    .Dq(), 
    .Addr(init_addr),
    .Ba(init_ba),
    .Clk(clk_100_shift), 
    .Cke(1'b1), 
    .Cs_n(init_cmd[3]), 
    .Ras_n(init_cmd[2]), 
    .Cas_n(init_cmd[1]), 
    .We_n(init_cmd[0]), 
    .Dqm(2'b00),
    .Debug(1'b1)
);

endmodule