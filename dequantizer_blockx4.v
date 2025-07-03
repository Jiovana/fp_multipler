module dequantizer_blockx4 (
	input clk, rst,
	input [31:0] level1, level2, level3, level4,
	input is_weight1, is_weight2, is_weight3, is_weight4,
	output [31:0] weight_fp1, weight_fp2, weight_fp3, weight_fp4
);
		dequantizer_block d_b1 (
        .clk(clk),
        .rst(rst),
        .level_int(level1),
        .is_weight(is_weight1),
        .weight_fp_reg(weight_fp1)
      );

		 dequantizer_block d_b2 (
        .clk(clk),
        .rst(rst),
        .level_int(level2),
        .is_weight(is_weight2),
        .weight_fp_reg(weight_fp2)
      );
		
		dequantizer_block d_b3 (
        .clk(clk),
        .rst(rst),
        .level_int(level3),
        .is_weight(is_weight3),
        .weight_fp_reg(weight_fp3)
      );

		 dequantizer_block d_b4 (
        .clk(clk),
        .rst(rst),
        .level_int(level4),
        .is_weight(is_weight4),
        .weight_fp_reg(weight_fp4)
      );

endmodule