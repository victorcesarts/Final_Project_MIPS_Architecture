if {[file exists work]} {
vdel -lib work -all
}
vlib work
vcom -explicit  -2008 "MIPSProcessor.vhd"
vcom -explicit  -2008 "MIPS.vhd"
vcom -explicit  -2008 "DataPath.vhd"
vcom -explicit  -2008 "ControlUnit.vhd"
vcom -explicit  -2008 "Adder.vhd"
vcom -explicit  -2008 "ALU.vhd"
vcom -explicit  -2008 "ALUDecoder.vhd"
vcom -explicit  -2008 "MainDecoder.vhd"
vcom -explicit  -2008 "MUX.vhd"
vcom -explicit  -2008 "MUX5.vhd"
vcom -explicit  -2008 "PC.vhd"
vcom -explicit  -2008 "RegisterFile.vhd"
vcom -explicit  -2008 "ShiftLeft.vhd"
vcom -explicit  -2008 "SignExt.vhd"
vcom -explicit  -2008 "DataMemory.vhd"
vcom -explicit  -2008 "InstrMemory.vhd"
vcom -explicit  -2008 "tb_MIPSProcessor.vhd"
vsim -t 1ns   -lib work tb_MIPSProcessor
add wave sim:/tb_MIPSProcessor/*

#do {wave.do}
view wave
view structure
view signals
run 1050 ns
#quit -force