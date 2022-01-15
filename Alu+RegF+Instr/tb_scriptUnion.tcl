if {[file exists work]} {
vdel -lib work -all
}
vlib work
vcom -explicit  -2008 "Union.vhd"
vcom -explicit  -2008 "RegisterFile.vhd"
vcom -explicit  -2008 "MUX.vhd"
vcom -explicit  -2008 "MUX5.vhd"
vcom -explicit  -2008 "SignExt.vhd"
vcom -explicit  -2008 "ALU.vhd"
vcom -explicit  -2008 "InstrMemory.vhd"
vcom -explicit  -2008 "tb_Union.vhd"
vsim -t 1ns   -lib work tb_Union
add wave sim:/tb_Union/*
#add wave -position insertpoint  \
sim:/tb_union/DUT/internal_RD1
#add wave -position insertpoint  \
sim:/tb_union/DUT/internal_RD2
#add wave -position insertpoint  \
sim:/tb_union/DUT/Reg_inst/A1
#add wave -position insertpoint  \
sim:/tb_union/DUT/Reg_inst/A2
#add wave -position insertpoint  \
sim:/tb_union/DUT/Reg_inst/A3
#add wave -position insertpoint  \
sim:/tb_union/DUT/MUX_InstDM/InB
#add wave -position insertpoint  \
sim:/tb_union/DUT/ALU_inst/SrcA
#add wave -position insertpoint  \
sim:/tb_union/DUT/ALU_inst/SrcB
#add wave -position insertpoint  \
sim:/tb_union/DUT/Sign_Ext/value
#add wave -position insertpoint  \
sim:/tb_union/DUT/Sign_Ext/valueEXT
#add wave -position insertpoint  \
sim:/tb_union/DUT/Reg_inst/WD3
#do {wave.do}
view wave
view structure
view signals
run 300 ns
#quit -force