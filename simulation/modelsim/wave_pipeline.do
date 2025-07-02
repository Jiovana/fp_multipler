onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dequantizer_block_pipe_tb/clk
add wave -noupdate /dequantizer_block_pipe_tb/rst
add wave -noupdate /dequantizer_block_pipe_tb/level_int
add wave -noupdate /dequantizer_block_pipe_tb/is_weight
add wave -noupdate /dequantizer_block_pipe_tb/weight_fp_reg
add wave -noupdate /dequantizer_block_pipe_tb/ovfl_reg
add wave -noupdate /dequantizer_block_pipe_tb/unfl_reg
add wave -noupdate /dequantizer_block_pipe_tb/excp_reg
add wave -noupdate /dequantizer_block_pipe_tb/cycle
add wave -noupdate /dequantizer_block_pipe_tb/test_index
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/clk
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/rst
add wave -noupdate -radix decimal /dequantizer_block_pipe_tb/level_int
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/is_weight
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/weight_fp_reg
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/ovfl_reg
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/unfl_reg
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/excp_reg
add wave -noupdate -divider dut
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/level_fp_reg
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/weight_fp
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/qstep_reg1
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/qstep_reg2
add wave -noupdate -divider {multiplier 1 stage}
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/sign
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/a_is_zero
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/operand_a
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/operand_b
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/op_a_reg
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/op_b_reg
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/exception_reg
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/a_is_zero_reg
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/sign_reg
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/a_exponent_reg
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/b_exponent_reg
add wave -noupdate -divider {2 stage}
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/product
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/sum_exponent
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/exponent_raw
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/product_reg
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/exponent_reg
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/a_is_zero_reg2
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/exception_reg2
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/sign_reg2
add wave -noupdate -divider {3 stage}
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/normalised
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/product_normalised
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/guard_bit
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/round_bit
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/sticky_bit
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/round_up
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/product_mantissa
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/exponent
add wave -noupdate -radix hexadecimal /dequantizer_block_pipe_tb/dut/multiplier/zero
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {55000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 332
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
WaveRestoreZoom {0 ps} {106752 ps}
