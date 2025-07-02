module dequantizer_block (
    input clk, rst,
    input [31:0] level_int,
    input is_weight,
    output reg [31:0] weight_fp_reg,
    output reg ovfl_reg, unfl_reg, excp_reg
);

    wire  [31:0] level_fp, qstep;
    wire  level_exception, level_overflow, level_underflow;

    int_to_fp32_pipeline int_to_fp (
		  .clk(clk),
		  .rst(rst),
        .int_in(level_int),
        .Exception(level_exception),
        .Overflow(level_overflow),
        .Underflow(level_underflow),
        .result(level_fp)
    );

    reg [31:0] level_fp_reg;
	 reg [31:0] qstep_reg1, qstep_reg2;
    always @(posedge clk) begin
        if (!rst) begin
            level_fp_reg <= 'b0;
				qstep_reg1 <= 'b0;
				qstep_reg2 <= 'b0;
        end else begin
            level_fp_reg <= level_fp;
				qstep_reg1 <= (is_weight) ? 32'h3abfffe0 : 32'h36200013;
				qstep_reg2 <= qstep_reg1;				
		  end
    end

	 wire [31:0] weight_fp;
	 wire excp, ovfl, unfl;
	  Multiplication_pipeline multiplier (
		 .clk(clk),
		 .rst(rst),
		 .a_operand(level_fp_reg),
		 .b_operand(qstep_reg2),
		 .exception(excp),
		 .overflow(ovfl),
		 .underflow(unfl),
		 .result(weight_fp)
	  );
	  
	  always @(posedge clk) begin
			if (!rst) begin
				weight_fp_reg = 'b0;
				excp_reg = 'b0;				ovfl_reg = 'b0;
				unfl_reg = 'b0;				
			end else begin
				weight_fp_reg = weight_fp;
				excp_reg = excp;
				ovfl_reg = ovfl;
				unfl_reg = unfl;
			end
	  end
endmodule
