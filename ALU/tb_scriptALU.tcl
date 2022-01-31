if {[file exists work]} {
vdel -lib work -all
}
vlib work
vcom -explicit  -2008 "ALU.vhd"
vcom -explicit  -2008 "tb_ALU.vhd"
vsim -t 1ns   -lib work tb_ALU
add wave sim:/tb_ALU/*
#do {wave.do}
view wave
view structure
view signals
run 1000 ns
#quit -force