transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {fp_multiplier_6_1200mv_85c_slow.vo}

vlog -sv -work work +incdir+C:/Users/Jiovana/Documents/FP_multiplier/fp_multipler {C:/Users/Jiovana/Documents/FP_multiplier/fp_multipler/tb_dequantizer_multiple.sv}

vsim -t 1ps +transport_int_delays +transport_path_delays -L altera_ver -L cycloneiii_ver -L gate_work -L work -voptargs="+acc"  tb_dequantizer_multiple

add wave *
view structure
view signals
run -all
