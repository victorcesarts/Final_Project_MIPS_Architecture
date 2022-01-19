if {[file exists work]} {
vdel -lib work -all
}
vlib work
vcom -explicit  -2008 "DataMemory.vhd"
vcom -explicit  -2008 "tb_DataMemory.vhd"
vsim -t 1ns     -lib work tb_DataMemory
add wave sim:/tb_DataMemory/*
#do {wave.do}
view wave
view structure
view signals
run 260ns
#quit -force