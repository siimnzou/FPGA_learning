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

vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/IIC/iic_eeprom/rtl {G:/FPGA_learning/Library/IIC/iic_eeprom/rtl/top_seg595.v}
vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/IIC/iic_eeprom/rtl {G:/FPGA_learning/Library/IIC/iic_eeprom/rtl/hc595_ctrl.v}
vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/IIC/iic_eeprom/rtl {G:/FPGA_learning/Library/IIC/iic_eeprom/rtl/data_trans.v}
vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/IIC/iic_eeprom/rtl {G:/FPGA_learning/Library/IIC/iic_eeprom/rtl/iic_eeprom.v}
vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/IIC/iic_eeprom/rtl {G:/FPGA_learning/Library/IIC/iic_eeprom/rtl/key_filter.v}
vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/IIC/iic_eeprom/rtl {G:/FPGA_learning/Library/IIC/iic_eeprom/rtl/iic_ctrl.v}
vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/IIC/iic_eeprom/quartus_prj/ip_core/FIFO {G:/FPGA_learning/Library/IIC/iic_eeprom/quartus_prj/ip_core/FIFO/FIFO.v}

vlog -vlog01compat -work work +incdir+G:/FPGA_learning/Library/IIC/iic_eeprom/quartus_prj/../sim {G:/FPGA_learning/Library/IIC/iic_eeprom/quartus_prj/../sim/tb_iic_eeprom.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_iic_eeprom

add wave *
view structure
view signals
run 1 us
