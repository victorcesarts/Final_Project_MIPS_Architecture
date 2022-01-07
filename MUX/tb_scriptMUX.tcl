if {[file exists work]} {
vdel -lib work -all
}
vlib work
vcom -explicit  -2008 "MUX.vhd"
vcom -explicit  -2008 "tb_MUX.vhd"
vsim -t 1ns   -lib work tb_MUX
add wave sim:/tb_MUX/*
#do {wave.do}
view wave
view structure
view signals
run 130000 ns
#quit -force