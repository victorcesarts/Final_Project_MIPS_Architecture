if {[file exists work]} {
vdel -lib work -all
}
vlib work
vcom -explicit  -2008 "PC.vhd"
vcom -explicit  -2008 "tb_PC.vhd"
vsim -t 1ns   -lib work tb_PC
add wave sim:/tb_PC/*
#do {wave.do}
view wave
view structure
view signals
run 45130349 ns
#quit -force