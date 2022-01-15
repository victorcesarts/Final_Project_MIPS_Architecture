if {[file exists work]} {
vdel -lib work -all
}
vlib work
vcom -explicit  -2008 "Union.vhd"
vcom -explicit  -2008 "RegisterFile.vhd"
vcom -explicit  -2008 "InstrMemory.vhd"
vcom -explicit  -2008 "tb_Union.vhd"
vsim -t 1ns   -lib work tb_Union
add wave sim:/tb_Union/*
#do {wave.do}
view wave
view structure
view signals
run 260 ns
#quit -force