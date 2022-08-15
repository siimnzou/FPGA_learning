######################################################################
#
# File name : tb_touch_driver_simulate.do
# Created on: Mon Aug 15 19:44:05 +0800 2022
#
# Auto generated by Vivado for 'behavioral' simulation
#
######################################################################
vsim -voptargs="+acc" -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -L xpm -lib xil_defaultlib xil_defaultlib.tb_touch_driver xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {tb_touch_driver_wave.do}

view wave
view structure
view signals

do {tb_touch_driver.udo}

run 1000ns
