onbreak {quit -force}
onerror {quit -force}

asim +access +r +m+clk_50_to_clk_33 -L xpm -L fifo_generator_v13_2_7 -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.clk_50_to_clk_33 xil_defaultlib.glbl

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure

do {clk_50_to_clk_33.udo}

run -all

endsim

quit -force
