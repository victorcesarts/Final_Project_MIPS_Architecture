if {[file exists work]} {
vdel -lib work -all
}
vlib work
vcom -explicit  -2008 "Adder.vhd"
vcom -explicit  -2008 "tb_Adder.vhd"
vsim -t 1ns   -lib work tb_Adder
add wave sim:/tb_Adder/*
#do {wave.do}
view wave
view structure
view signals
run 68000 ns
#quit -force