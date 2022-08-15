onbreak {quit -f}
onerror {quit -f}

vsim -lib xil_defaultlib clk_50_to_clk_33_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {clk_50_to_clk_33.udo}

run -all

quit -force
