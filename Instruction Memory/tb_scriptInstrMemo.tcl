if {[file exists work]} {
vdel -lib work -all
}
vlib work
vcom -explicit  -2008 "InstrMemory.vhd"
vcom -explicit  -2008 "tb_InstrMemory.vhd"
vsim -t 1ns   -lib work tb_InstrMemory
add wave sim:/tb_InstrMemory/*
add wave -position insertpoint  \
sim:/tb_instrmemory/DUT/rom_addr
#do {wave.do}
view wave
view structure
view signals
run 260ns
#quit -force