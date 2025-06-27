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

  // Task to apply input and display output
  task test_input;
    input [31:0] val;
    begin
      in = val;
      #10; // wait for signals to propagate
      $display("in = %b | out_z = %2d | v = %b", in, out_z, v);
    end
  endtask

  initial begin
    $display("---- 32-bit Leading Zero Counter Test ----\n");

    test_input(32'b0000_0000_0000_0000_0000_0000_0000_0000); // All zeros
    test_input(32'b0000_0000_0000_0000_0000_0000_0000_0001); // 31 leading zeros
    test_input(32'b0000_0000_0000_0000_0000_0000_0000_0010); // 30 leading zeros
    test_input(32'b0000_0000_0000_0000_1000_0000_0000_0000); // 15 leading zeros
    test_input(32'b0000_0000_1000_0000_0000_0000_0000_0000); // 7 leading zeros
    test_input(32'b1000_0000_0000_0000_0000_0000_0000_0000); // 0 leading zeros
    test_input(32'b01000000000000000000000000000000); // 1 leading zero
    test_input(32'b00000000000000000000000000001111); // 28 leading zeros
    test_input(32'h00000010);                         // 27 leading zeros
    test_input(32'h00000080);                         // 24 leading zeros
    test_input(32'hFFFFFFFF);                         // 0 leading zeros

    $display("\n---- Test Complete ----");
    $stop;
  end

endmodule
