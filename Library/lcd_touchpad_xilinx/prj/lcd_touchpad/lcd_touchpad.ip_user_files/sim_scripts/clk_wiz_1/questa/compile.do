vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xpm
vlib questa_lib/msim/xil_defaultlib

vmap xpm questa_lib/msim/xpm
vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xpm  -incr -mfcu -sv "+incdir+../../../ipstatic" \
"E:/FPGA_xilinx_vivado_newversion/Vivado/2022.1/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm  -93 \
"E:/FPGA_xilinx_vivado_newversion/Vivado/2022.1/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr -mfcu "+incdir+../../../ipstatic" \
"../../../../lcd_touchpad.gen/sources_1/ip/clk_wiz_1/clk_wiz_1_clk_wiz.v" \
"../../../../lcd_touchpad.gen/sources_1/ip/clk_wiz_1/clk_wiz_1.v" \

vlog -work xil_defaultlib \
"glbl.v"
