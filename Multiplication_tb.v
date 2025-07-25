module Multiplication_pipe_tb;

  reg clk, rst;
  reg [31:0] a_operand;
  reg [31:0] b_operand;
  wire [31:0] result;
  wire exception, overflow, underflow;

  // Instantiate the unit under test
  Multiplication_pipeline dut (
    .clk(clk),
    .rst(rst),
    .a_operand(a_operand),
    .b_operand(b_operand),
    .exception(exception),
    .overflow(overflow),
    .underflow(underflow),
    .result(result)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Constants
  localparam B_QSTEP1 = 32'h3abfffe0;  // 0.00146484
  localparam B_QSTEP2 = 32'h36200013;  // 0.00000238419

  task run_test;
    input [31:0] a;
    input [31:0] b;
    input [31:0] expected;
    input [8*32:1] label;
    begin
      @(negedge clk);
      a_operand = a;
      b_operand = b;
      @(posedge clk); // stage 1
      @(posedge clk); // stage 2
      @(posedge clk); // stage 3 (result ready)

      $display("Test: %s", label);
      $display("A = %h", a);
      $display("B = %h", b);
      $display("Result = %h, Expected = %h", result, expected);
      if (result !== expected)
        $display("[FAILED] ✗\n");
      else
        $display("[PASSED] ✓\n");
    end
  endtask

  initial begin
    $display("Starting pipelined FP multiplier tests...");

    clk = 0;
    rst = 0;
    a_operand = 32'd0;
    b_operand = 32'd0;

    @(negedge clk);
    rst = 1;

    // Wait for pipeline to reset
    @(posedge clk);
    @(posedge clk);

    // Test examples
    run_test(32'h45800000, B_QSTEP1, 32'h41aaaaab, "4096 * 0.00146484 = 6.0");
    run_test(32'h46160000, B_QSTEP1, 32'h421a6666, "11648 * 0.00146484 = 17.060");
    run_test(32'h00000000, B_QSTEP1, 32'h00000000, "0 * 0.00146484 = 0");
    run_test(32'h45800000, B_QSTEP2, 32'h3b800000, "4096 * 2.38419e-6 ≈ 0.00977");
    run_test(32'hc5800000, B_QSTEP1, 32'hc1aaaaab, "-4096 * 0.00146484 = -6.0");

    $display("All tests finished.");
    $finish;
  end

endmodule
