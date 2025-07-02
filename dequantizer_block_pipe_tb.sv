`timescale 1ns / 1ps

module dequantizer_block_pipe_tb;

  reg clk = 0;
  always #5 clk = ~clk;

  reg rst;
  reg [31:0] level_int;
  reg is_weight;
  wire [31:0] weight_fp_reg;
  wire ovfl_reg, unfl_reg, excp_reg;

  dequantizer_block dut (
    .clk(clk),
    .rst(rst),
    .level_int(level_int),
    .is_weight(is_weight),
    .weight_fp_reg(weight_fp_reg),
    .ovfl_reg(ovfl_reg),
    .unfl_reg(unfl_reg),
    .excp_reg(excp_reg)
  );

  typedef struct {
    logic [31:0] level;
    logic        is_weight;
    logic [31:0] expected;
  } testvec_t;

  localparam PIPELINE_LATENCY = 5;
  localparam NUM_TESTS = 8;

  testvec_t tests [0:NUM_TESTS-1];
  initial begin
    tests[0] = '{32'd14562, 1'b1, 32'h41aaa5e4};   // 21.33
    tests[1] = '{32'd4096,  1'b1, 32'h40bfffe0};   // 6.0
    tests[2] = '{32'd4096,  1'b0, 32'h3c200013};   // 0.00977
    tests[3] = '{32'd0,     1'b1, 32'h00000000};   // 0
    tests[4] = '{-32'd1,    1'b1, 32'hbabfffe0};   // -0.00146484
    tests[5] = '{32'd1,     1'b0, 32'h36200013};   // 2.38e-6
    tests[6] = '{32'd8192,  1'b1, 32'h413fffe0};   // 11.99996
    tests[7] = '{-32'd16384,1'b1, 32'hc1bfffe0};   // -23.99993
  end

  integer cycle;
  integer test_index;

  initial begin
    $display("\n[INFO] Starting pipelined dequantizer test...\n");

    // Reset on negedge
    rst = 0;
    level_int = 0;
    is_weight = 0;
    repeat (2) @(negedge clk);
    rst = 1;
    @(negedge clk);

    // Stimulus and checking loop
    for (cycle = 0; cycle < NUM_TESTS + PIPELINE_LATENCY; cycle++) begin
      @(negedge clk);

      if (cycle < NUM_TESTS) begin
        level_int = tests[cycle].level;
        is_weight = tests[cycle].is_weight;
      end else begin
        level_int = 0;
        is_weight = 0;
      end

      test_index = cycle - PIPELINE_LATENCY;
      if (test_index >= 0) begin
        $display("Cycle %0d | Input: %0d | Is_Weight: %b | Output: %h | Expected: %h | Ovf: %b | Unf: %b | Exc: %b",
                 test_index, tests[test_index].level, tests[test_index].is_weight,
                 weight_fp_reg, tests[test_index].expected,
                 ovfl_reg, unfl_reg, excp_reg);

        if (weight_fp_reg !== tests[test_index].expected)
          $display("  [FAIL] Mismatch! Got %h, Expected %h", weight_fp_reg, tests[test_index].expected);
        else
          $display("  [PASS]");
      end
    end

    $display("\n[INFO] Dequantizer pipelined test complete.\n");
    $stop;
  end

endmodule
