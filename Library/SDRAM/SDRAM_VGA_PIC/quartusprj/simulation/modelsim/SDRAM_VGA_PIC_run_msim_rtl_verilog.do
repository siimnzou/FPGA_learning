transcript on
if ![file isdirectory verilog_libs] {
	file mkdir verilog_libs
}

vlib verilog_libs/altera_ver
vmap altera_ver ./verilog_libs/altera_ver
vlog -vlog01compat -work altera_ver {d:/fpga/quartus 2/quartus/eda/sim_lib/altera_primitives.v}

vlib verilog_libs/lpm_ver
vmap lpm_ver ./verilog_libs/lpm_ver
vlog -vlog01compat -work lpm_ver {d:/fpga/quartus 2/quartus/eda/sim_lib/220model.v}

vlib verilog_libs/sgate_ver
vmap sgate_ver ./verilog_libs/sgate_ver
vlog -vlog01compat -work sgate_ver {d:/fpga/quartus 2/quartus/eda/sim_lib/sgate.v}

vlib verilog_libs/altera_mf_ver
vmap altera_mf_ver ./verilog_libs/altera_mf_ver
vlog -vlog01compat -work altera_mf_ver {d:/fpga/quartus 2/quartus/eda/sim_lib/altera_mf.v}

vlib verilog_libs/altera_lnsim_ver
vmap altera_lnsim_ver ./verilog_libs/altera_lnsim_ver
vlog -sv -work altera_lnsim_ver {d:/fpga/quartus 2/quartus/eda/sim_lib/altera_lnsim.sv}

vlib verilog_libs/cycloneive_ver
vmap cycloneive_ver ./verilog_libs/cycloneive_ver
vlog -vlog01compat -work cycloneive_ver {d:/fpga/quartus 2/quartus/eda/sim_lib/cycloneive_atoms.v}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/quartusprj/ip_core/sdram_fifo {G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/quartusprj/ip_core/sdram_fifo/sdram_fifo.v}
vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/RTL {G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/RTL/VGA_CTRL.v}
vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/RTL {G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/RTL/uart_rx.v}
vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/RTL {G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/RTL/SDRAM_WR.v}
vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/RTL {G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/RTL/SDRAM_VGA_PIC.v}
vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/RTL {G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/RTL/SDRAM_RD.v}
vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/RTL {G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/RTL/SDRAM_INIT.v}
vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/RTL {G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/RTL/SDRAM_FIFO.v}
vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/RTL {G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/RTL/SDRAM_CTRL.v}
vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/RTL {G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/RTL/SDRAM_AREF.v}
vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/RTL {G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/RTL/SDRAM_ARBIT.v}
vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/RTL {G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/RTL/SDRAM.v}
vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/quartusprj/ip_core/clk_gen {G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/quartusprj/ip_core/clk_gen/CLK_GEN.v}
vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/quartusprj/db {G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/quartusprj/db/clk_gen_altpll.v}

vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/quartusprj/../sim {G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/quartusprj/../sim/sdram_model_plus.v}
vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/quartusprj/../sim {G:/FPGA_learning/Library/SDRAM/SDRAM_VGA_PIC/quartusprj/../sim/TB_SDRAM_VGA_PIC.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  TB_SDRAM_VGA_PIC

add wave *
view structure
view signals
run 1 us
