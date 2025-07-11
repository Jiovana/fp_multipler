`timescale 1ns / 1ps

module tb_lzc_miao_32;

  reg  [31:0] in;
  wire [4:0]  out_z;
  wire        v;

  // Instantiate the module under test
  miao_lzc32 uut (
    .in     (in),
    .out_z  (out_z),
    .v      (v)
  );

  // Reference model: counts leading zeros
  function [5:0] ref_lzc;
    input [31:0] val;
    integer i;
    begin
      for (i = 0; i < 32; i = i + 1) begin
        if (val[31 - i]) begin
          ref_lzc = i;
        end
      end
      ref_lzc = 32; // All zero input
    end
  endfunction


  // Task to apply input and check output
  task test_input;
    input [31:0] val;
    integer expected_z;
    reg expected_v;
    begin
      in = val;
      #1;

      expected_z = ref_lzc(val);
      expected_v = |val;

      if ((v === expected_v) && (out_z === expected_z[4:0]))
        $display("[PASS] in = %b | out_z = %2d | v = %b", in, out_z, v);
      else
        $display("[FAIL] in = %b | out_z = %2d | v = %b | Expected: %2d, %b",
                 in, out_z, v, expected_z, expected_v);

      #9;
    end
  endtask

  initial begin
    $display("---- 32-bit Leading Zero Counter Test ----\n");

    test_input(32'b0000_0000_0000_0000_0000_0000_0000_0000); // 32
    test_input(32'b0000_0000_0000_0000_0000_0000_0000_0001); // 31
    test_input(32'b0000_0000_0000_0000_0000_0000_0000_0010); // 30
    test_input(32'b0000_0000_0000_0000_1000_0000_0000_0000); // 15
    test_input(32'b0000_0000_1000_0000_0000_0000_0000_0000); // 7
    test_input(32'b1000_0000_0000_0000_0000_0000_0000_0000); // 0
    test_input(32'b0100_0000_0000_0000_0000_0000_0000_0000); // 1
    test_input(32'b0000_0000_0000_0000_0000_0000_0000_1111); // 28
    test_input(32'h00000010); // 27
    test_input(32'h00000080); // 24
    test_input(32'hFFFFFFFF); // 0

    $display("\n---- Test Complete ----");
    $stop;
  end

endmodule
