// Testbench for parallel dequantizer_blockx4 wrapper
`timescale 1ns/1ps

module tb_dequantizer_multiple;

  parameter int NUM_UNITS = 1;
  parameter int NUM_FILES = 8;
  parameter string FILE_NAMES[NUM_FILES] = '{
    "test_vectors/test_vectors_alexnet.csv", "test_vectors/test_vectors_bmjsh.csv", "test_vectors/test_vectors_cheng.csv", "test_vectors/test_vectors_deeplab.csv",
    "test_vectors/test_vectors_inception.csv", "test_vectors/test_vectors_ssd.csv", "test_vectors/test_vectors_unet.csv", "test_vectors/test_vectors_yolo11s.csv"
  };

  parameter int MAX_ENTRIES = 100_000 * NUM_FILES;
  parameter int PIPELINE_LATENCY = 5;

  typedef struct packed {
    logic [31:0] level;
    logic        is_weight;
    logic [31:0] expected;
  } test_vector_t;

  typedef test_vector_t cycle_vector_t[NUM_UNITS];

  cycle_vector_t input_history[MAX_ENTRIES];
  test_vector_t all_vectors[MAX_ENTRIES];
  int num_entries;
  int push_ptr = 0;
  int pop_ptr = 0;

  logic clk;
  logic rst;

  logic [31:0] level_bus[NUM_UNITS];
  logic        is_weight_bus[NUM_UNITS];
  logic [31:0] weight_fp_bus[NUM_UNITS];

  // DUT instance
  //dequantizer_blockx4 dut (
   // .clk(clk),
    //.rst(rst),
    //.level1(level_bus[0]), .is_weight1(is_weight_bus[0]), .weight_fp1(weight_fp_bus[0]),
    //.level2(level_bus[1]), .is_weight2(is_weight_bus[1]), .weight_fp2(weight_fp_bus[1]),
    //.level3(level_bus[2]), .is_weight3(is_weight_bus[2]), .weight_fp3(weight_fp_bus[2]),
    //.level4(level_bus[3]), .is_weight4(is_weight_bus[3]), .weight_fp4(weight_fp_bus[3])
  //);

   //dequantizer_blockx2 dut (
   // .clk(clk),
    //.rst(rst),
    //.level1(level_bus[0]), .is_weight1(is_weight_bus[0]), .weight_fp1(weight_fp_bus[0]),
    //.level2(level_bus[1]), .is_weight2(is_weight_bus[1]), .weight_fp2(weight_fp_bus[1])
  //);
  
    dequantizer_block dut (
       .clk(clk),
       .rst(rst),
       .level_int(level_bus[0]),
       .is_weight(is_weight_bus[0]),
       .weight_fp_reg(weight_fp_bus[0])
    );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Load test vectors from files
  initial begin
    string line;
    string hex_str;
    int fd;
    int dummy;
    int level_val;
    int weight_flag;
    int expected_val;
    int file_idx;

    num_entries = 0;

    for (file_idx = 0; file_idx < NUM_FILES; file_idx++) begin
      fd = $fopen(FILE_NAMES[file_idx], "r");
      if (!fd) begin
        $error("[ERROR] Failed to open file %s", FILE_NAMES[file_idx]);
        $finish;
      end

      line = "";
      dummy = ($fgets(line, fd)); // Skip header

      while (!$feof(fd) && num_entries < MAX_ENTRIES) begin
        dummy = $fscanf(fd, "%d,%d,%s\n", level_val, weight_flag, hex_str);
        if (dummy == 3) begin
          dummy = $sscanf(hex_str, "0x%x", expected_val);
          if (dummy == 1) begin
            all_vectors[num_entries].level     = level_val;
            all_vectors[num_entries].is_weight = weight_flag;
            all_vectors[num_entries].expected  = expected_val;
            num_entries++;
          end
        end
      end

      $fclose(fd);
      $display("[INFO] Loaded from %s", FILE_NAMES[file_idx]);
    end

    $display("[INFO] Total entries loaded: %0d", num_entries);
  end

  // Apply inputs and verify outputs
  initial begin
    int cycle;
    int errors;
    int idx;
    int j;
    int line_idx;
    cycle_vector_t inputs_this_cycle;
    cycle_vector_t compare_cycle;
    test_vector_t vec;

    cycle = 0;
    errors = 0;
    rst = 0;
    repeat (2) @(negedge clk);
    rst = 1;
	 
    for (idx = 0; idx < (num_entries / NUM_UNITS); idx++) begin
      for (j = 0; j < NUM_UNITS; j++) begin
        line_idx = NUM_UNITS * idx + j;
        if (line_idx < num_entries) begin
          level_bus[j]     = all_vectors[line_idx].level;
          is_weight_bus[j] = all_vectors[line_idx].is_weight;
          inputs_this_cycle[j] = all_vectors[line_idx];
        end else begin
          level_bus[j]     = 0;
          is_weight_bus[j] = 0;
          inputs_this_cycle[j] = '{default: '0};
        end
      end

      for (j = 0; j < NUM_UNITS; j++) begin
        input_history[push_ptr][j] = inputs_this_cycle[j];
      end
      push_ptr++;
      @(negedge clk);

      if ((cycle + 1) >= PIPELINE_LATENCY) begin
        for (j = 0; j < NUM_UNITS; j++) begin
          compare_cycle[j] = input_history[pop_ptr][j];
        end
        for (j = 0; j < NUM_UNITS; j++) begin
          vec = compare_cycle[j];
          if (weight_fp_bus[j] !== vec.expected) begin
            $display("[FAIL] Cycle %0d | Unit %0d | Level: %0d | is_weight: %b | Got: %h | Expected: %h",
                     cycle, j, vec.level, vec.is_weight, weight_fp_bus[j], vec.expected);
            errors++;
          end
        end
        pop_ptr++;
      end

      cycle++;
    end

    // Drain remaining pipeline
    repeat (PIPELINE_LATENCY) begin
      @(negedge clk);
      if (pop_ptr < push_ptr) begin
        for (j = 0; j < NUM_UNITS; j++) begin
          compare_cycle[j] = input_history[pop_ptr][j];
        end
        for (j = 0; j < NUM_UNITS; j++) begin
          vec = compare_cycle[j];
          if (weight_fp_bus[j] !== vec.expected) begin
            $display("[FAIL] Final Drain | Unit %0d | Level: %0d | Got: %h | Expected: %h",
                     j, vec.level, weight_fp_bus[j], vec.expected);
            errors++;
          end
        end
        pop_ptr++;
      end
    end

    if (errors == 0)
      $display("\n[PASS] All tests passed.");
    else
      $display("\n[FAIL] %0d mismatches found.", errors);

    $stop;
  end
  
        // VCD generation
   // initial begin
     //   $dumpfile("dequantizer_x1.vcd");
      //  $dumpvars(0, tb_dequantizer_parallel);
   // end

    // SDF annotation
    //initial begin
     // $sdf_annotate("synth/outputs_final/dequantizer_block_delays.sdf",tb_dequantizer_multiple.dut,,"sdf.log", "MAXIMUM");
    //end

endmodule
