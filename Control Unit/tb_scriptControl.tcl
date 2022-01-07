if {[file exists work]} {
vdel -lib work -all
}
vlib work
vcom -explicit  -2008 "ControlUnit.vhd"
vcom -explicit  -2008 "MainDecoder.vhd"
vcom -explicit  -2008 "ALUDecoder.vhd"
vcom -explicit  -2008 "tb_ControlUnit.vhd"
vsim -t 1ns   -lib work tb_ControlUnit
add wave sim:/tb_ControlUnit/*
#do {wave.do}
view wave
view structure
view signals
run 300ns
#quit -force