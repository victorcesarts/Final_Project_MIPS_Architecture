if {[file exists work]} {
vdel -lib work -all
}
vlib work
vcom -explicit  -2008 "RegisterFile.vhd"
vcom -explicit  -2008 "tb_REGFile.vhd"
vsim -t 1ns   -lib work tb_REGFile
add wave sim:/tb_REGFile/*
#do {wave.do}
view wave
view structure
view signals
run 280 ns
#quit -force