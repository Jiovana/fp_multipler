transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Jiovana/Documents/FP_multiplier/fp_multipler {C:/Users/Jiovana/Documents/FP_multiplier/fp_multipler/int_to_fp32_pipeline.v}
vlog -vlog01compat -work work +incdir+C:/Users/Jiovana/Documents/FP_multiplier/fp_multipler {C:/Users/Jiovana/Documents/FP_multiplier/fp_multipler/dequantizer_block.v}
vlog -vlog01compat -work work +incdir+C:/Users/Jiovana/Documents/FP_multiplier/fp_multipler {C:/Users/Jiovana/Documents/FP_multiplier/fp_multipler/Multiplication_pipeline.v}
vlog -vlog01compat -work work +incdir+C:/Users/Jiovana/Documents/FP_multiplier/fp_multipler {C:/Users/Jiovana/Documents/FP_multiplier/fp_multipler/miao_lzc32.v}

vlog -sv -work work +incdir+C:/Users/Jiovana/Documents/FP_multiplier/fp_multipler {C:/Users/Jiovana/Documents/FP_multiplier/fp_multipler/tb_dequantizer_multiple.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiii_ver -L rtl_work -L work -voptargs="+acc"  tb_dequantizer_multiple

add wave *
view structure
view signals
run -all
