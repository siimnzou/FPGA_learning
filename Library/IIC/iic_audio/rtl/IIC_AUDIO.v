module IIC_AUDIO
(
    input clk,
    input rst_n,
    input lrc,
    input bclk,
    input wm8978_adc_data,

    output wire wm8978_dac_data,
    output wire scl,
    inout  wire sda,
    output wire mclk 
);

wire locked ;
wire clk_50m ;
wire rst_n_locked = rst_n & locked ;
wire  [23:0] adc_data ;

clk_gen	clk_gen_inst (
	.areset ( ~rst_n ),
	.inclk0 ( clk ),
	.c0 ( clk_50m ),
	.c1 ( mclk ),
	.locked (locked )
	);

WM8978_CFG WM8978_CFG_INST
(
    .clk    (clk_50m),
    .rst_n  (rst_n_locked),

    .scl (scl)         , 
    .sda (sda)         
);

WM8978_RECV WM8978_RECV_INST
(
    .rst_n    (rst_n_locked   ),
    .lrc      (lrc     ),
    .bclk     (bclk    ),
    .wm8978_adc_data (wm8978_adc_data),
    
    .adc_data (adc_data) ,
    .recv_done()
);

WM8978_SEND WM8978_SEND_INST
(
    .rst_n   (rst_n_locked   ),
    .lrc     (lrc     ),
    .bclk    (bclk    ),
    .adc_data(adc_data),
    
    .wm8978_dac_data   (wm8978_dac_data),
    .send_done ()         
);

endmodule