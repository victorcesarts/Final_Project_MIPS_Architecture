if {[file exists work]} {
vdel -lib work -all
}
vlib work
vcom -explicit  -2008 "DataPath.vhd"
vcom -explicit  -2008 "Adder.vhd"
vcom -explicit  -2008 "ALU.vhd"
vcom -explicit  -2008 "MUX.vhd"
vcom -explicit  -2008 "MUX5.vhd"
vcom -explicit  -2008 "PC.vhd"
vcom -explicit  -2008 "RegisterFile.vhd"
vcom -explicit  -2008 "ShiftLeft.vhd"
vcom -explicit  -2008 "ShiftLeftJump.vhd"
vcom -explicit  -2008 "SignExt.vhd"
vcom -explicit  -2008 "tb_DataPath.vhd"
vsim -t 1ns   -lib work tb_DataPath
add wave sim:/tb_DataPath/*
#do {wave.do}
view wave
view structure
view signals
run 1000ns
#quit -force