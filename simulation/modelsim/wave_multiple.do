onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_dequantizer_multiple/num_entries
add wave -noupdate /tb_dequantizer_multiple/clk
add wave -noupdate /tb_dequantizer_multiple/rst
add wave -noupdate -radix decimal /tb_dequantizer_multiple/level_bus
add wave -noupdate /tb_dequantizer_multiple/is_weight_bus
add wave -noupdate -radix hexadecimal /tb_dequantizer_multiple/weight_fp_bus
add wave -noupdate /tb_dequantizer_multiple/dut/d_b1/level_fp
add wave -noupdate /tb_dequantizer_multiple/dut/d_b1/qstep
add wave -noupdate /tb_dequantizer_multiple/dut/d_b1/level_exception
add wave -noupdate /tb_dequantizer_multiple/dut/d_b1/level_overflow
add wave -noupdate /tb_dequantizer_multiple/dut/d_b1/level_underflow
add wave -noupdate /tb_dequantizer_multiple/dut/d_b1/level_fp_reg
add wave -noupdate /tb_dequantizer_multiple/dut/d_b1/qstep_reg1
add wave -noupdate /tb_dequantizer_multiple/dut/d_b1/qstep_reg2
add wave -noupdate -radix hexadecimal /tb_dequantizer_multiple/dut/d_b1/weight_fp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {55000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 297
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
WaveRestoreZoom {0 ps} {216963 ps}
