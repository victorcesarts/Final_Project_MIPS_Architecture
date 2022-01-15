onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_union/read_data_inPC
add wave -noupdate /tb_union/flag_write
add wave -noupdate -radix hexadecimal /tb_union/data_in_addres
add wave -noupdate -radix unsigned /tb_union/data_in_data
add wave -noupdate /tb_union/data_in_RegWrite
add wave -noupdate /tb_union/data_in_ALUSrc
add wave -noupdate /tb_union/data_in_MemtoReg
add wave -noupdate /tb_union/data_in_RegDst
add wave -noupdate /tb_union/data_in_ALUControl
add wave -noupdate /tb_union/in_clk
add wave -noupdate /tb_union/ZeroOutput
add wave -noupdate -radix unsigned /tb_union/Resultout
add wave -noupdate -radix unsigned /tb_union/Writetoutput
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 204
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {7 ns} {227 ns}
