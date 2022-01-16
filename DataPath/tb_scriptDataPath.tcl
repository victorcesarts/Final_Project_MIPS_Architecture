if {[file exists work]} {
vdel -lib work -all
}
vlib work
vcom -explicit  -2008 "DataPath.vhd"
vcom -explicit  -2008 "PC.vhd"
vcom -explicit  -2008 "Adder.vhd"
vcom -explicit  -2008 "ShiftLeft.vhd"
vcom -explicit  -2008 "InstrMemory.vhd"
vcom -explicit  -2008 "Adder.vhd"
vcom -explicit  -2008 "RegisterFile.vhd"
vcom -explicit  -2008 "MUX.vhd"
vcom -explicit  -2008 "MUX5.vhd"
vcom -explicit  -2008 "SignExt.vhd"
vcom -explicit  -2008 "ALU.vhd"
vcom -explicit  -2008 "tb_DataPath.vhd"
vsim -t 1ns   -lib work tb_DataPath
add wave sim:/tb_DataPath/*
add wave -position insertpoint  \
sim:/tb_datapath/DUT/Instr_inst/instr
#do {wave.do}
view wave
view structure
view signals
run 300 ns
#quit -force