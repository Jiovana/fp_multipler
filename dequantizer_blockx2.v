module dequantizer_blockx2 (
	input clk, rst,
	input [31:0] level1, level2,
	input is_weight1, is_weight2,
	output [31:0] weight_fp1, weight_fp2
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

endmodule