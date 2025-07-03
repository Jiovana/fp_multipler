`timescale 1ns / 1ps

module tb_dequantizer_parallel;

  parameter NUM_BLOCKS = 8;
  parameter PIPELINE_LATENCY = 5;
  parameter MAX_LINES_PER_BLOCK = 100000;

  logic clk = 0;
  logic rst = 0;

  always #5 clk = ~clk;

  // DUT signals
  logic [31:0] level_int   [NUM_BLOCKS];
  logic        is_weight   [NUM_BLOCKS];
  logic [31:0] weight_fp   [NUM_BLOCKS];

  // Instantiate DUTs
  genvar i;
  generate
    for (i = 0; i < NUM_BLOCKS; i++) begin : deq_blocks
      dequantizer_block dut (
        .clk(clk),
        .rst(rst),
        .level_int(level_int[i]),
        .is_weight(is_weight[i]),
        .weight_fp_reg(weight_fp[i])
      );
    end
  endgenerate

  typedef struct packed {
    logic [31:0] level;
    logic        is_weight;
    logic [31:0] expected;
  } test_vector_t;

  string file_names[NUM_BLOCKS] = '{
    "test_vectors/test_vectors_alexnet.csv", "test_vectors/test_vectors_bmjsh.csv", "test_vectors/test_vectors_cheng.csv", "test_vectors/test_vectors_deeplab.csv",
    "test_vectors/test_vectors_inception.csv", "test_vectors/test_vectors_ssd.csv", "test_vectors/test_vectors_unet.csv", "test_vectors/test_vectors_yolo11s.csv"
  };

  int file_handles[NUM_BLOCKS];
  int test_counts [NUM_BLOCKS];
  int error_counts[NUM_BLOCKS];

  test_vector_t test_queue[NUM_BLOCKS][MAX_LINES_PER_BLOCK + PIPELINE_LATENCY];

  initial begin
    int j, idx, dummy, fd;
    int level_val;
    int weight_flag;
    string hex_str;
    int expected_val;
    int cycle;
    test_vector_t tv_expected, tv_temp;
    static int max_cycles = MAX_LINES_PER_BLOCK + PIPELINE_LATENCY + 10;
    int total_errors;
    string line;

    $display("[INFO] Starting parallel dequantizer test...");

    for (j = 0; j < NUM_BLOCKS; j++) begin
      fd = $fopen(file_names[j], "r");
      if (fd == 0) begin
        $fatal("[ERROR] Failed to open %s", file_names[j]);
      end

      idx = 0;
		dummy = $fgets(line, fd); // eats the header line
      while (!$feof(fd) && idx < MAX_LINES_PER_BLOCK) begin
        line = "";
        dummy = $fgets(line, fd); // get the whole line
        if (line.len() > 0) begin
          dummy = $sscanf(line, "%d,%d,%s", level_val, weight_flag, hex_str);
          if (dummy == 3) begin
            dummy = $sscanf(hex_str, "0x%x", expected_val);
            if (dummy == 1) begin
              tv_temp.level     = level_val;
              //$display("level_val %d\n", tv_temp.level);
              tv_temp.is_weight = weight_flag; // <-- this is the problematic line
              tv_temp.expected  = expected_val;
              test_queue[j][idx] = tv_temp;
            end else begin
              $display("[ERROR] Failed to parse hex string: %s", hex_str);
            end
          end else begin
            $display("[ERROR] Failed to parse CSV line: %s", line);
          end
        end
      
         //test_queue[j][idx] = '{level: level_val, is_weight: weight_flag, expected: expected_val};
        idx++;
      end
      test_counts[j] = idx;
      $fclose(fd);
    end

    rst = 0;
    repeat (2) @(negedge clk);
    rst = 1;

    
    
    for (cycle = 0; cycle < max_cycles; cycle++) begin
      @(negedge clk);
      for (j = 0; j < NUM_BLOCKS; j++) begin
        if (cycle < test_counts[j]) begin
          level_int[j]  = test_queue[j][cycle].level;
          is_weight[j]  = test_queue[j][cycle].is_weight;
        end else begin
          level_int[j]  = 'x;
          is_weight[j]  = 'x;
        end

        if (cycle >= PIPELINE_LATENCY && (cycle - PIPELINE_LATENCY) < test_counts[j]) begin
          idx = cycle - PIPELINE_LATENCY;
          tv_expected = test_queue[j][idx];

          if (weight_fp[j] !== tv_expected.expected) begin
            error_counts[j]++;
            $display("[FAIL] DUT %0d | Cycle %0d | Input: %0d | is_weight: %0b | Got: %08x | Expected: %08x",
                      j, cycle, tv_expected.level, tv_expected.is_weight, weight_fp[j], tv_expected.expected);
          end else begin
            $display("[PASS] DUT %0d | Cycle %0d | Result: %08x", j, cycle, weight_fp[j]);
          end
        end
      end
    end

    total_errors = 0;
    for (j = 0; j < NUM_BLOCKS; j++) begin
      $display("[SUMMARY] DUT %0d: %0d tests, %0d errors", j, test_counts[j], error_counts[j]);
      total_errors += error_counts[j];
    end

    if (total_errors == 0) begin
      $display("[INFO] All dequantizer tests passed!");
    end else begin
      $display("[INFO] Found %0d total mismatches!", total_errors);
    end

    $stop;
  end
endmodule