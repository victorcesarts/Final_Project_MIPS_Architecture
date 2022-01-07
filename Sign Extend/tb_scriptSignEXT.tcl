if {[file exists work]} {
vdel -lib work -all
}
vlib work
vcom -explicit  -2008 "SignExt.vhd"
vcom -explicit  -2008 "tb_SignExt.vhd"
vsim -t 1ns   -lib work tb_SignExt
add wave sim:/tb_SignExt/*
#do {wave.do}
view wave
view structure
view signals
run 983060 ns
#quit -force