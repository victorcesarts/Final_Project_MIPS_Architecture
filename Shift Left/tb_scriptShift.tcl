if {[file exists work]} {
vdel -lib work -all
}
vlib work
vcom -explicit  -2008 "ShiftLeft.vhd"
vcom -explicit  -2008 "tb_Shift.vhd"
vsim -t 1ns   -lib work tb_Shift
add wave sim:/tb_Shift/*
#do {wave.do}
view wave
view structure
view signals
run 17000 ns
#quit -force