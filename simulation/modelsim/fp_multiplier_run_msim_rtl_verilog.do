transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/Jiovana/Documents/FP_multiplier {C:/Users/Jiovana/Documents/FP_multiplier/int_to_fp32.v}
vlog -vlog01compat -work work +incdir+C:/Users/Jiovana/Documents/FP_multiplier {C:/Users/Jiovana/Documents/FP_multiplier/miao_lzc32.v}

vlog -vlog01compat -work work +incdir+C:/Users/Jiovana/Documents/FP_multiplier {C:/Users/Jiovana/Documents/FP_multiplier/tb_int_to_fp32.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneiii_ver -L rtl_work -L work -voptargs="+acc"  tb_int_to_fp32

add wave *
view structure
view signals
run -all
