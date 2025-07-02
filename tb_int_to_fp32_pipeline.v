`timescale 1ns / 1ps

module tb_int_to_fp32_pipeline;

    reg clk = 0, rst = 0;
    always #5 clk = ~clk; // 100 MHz clock

    reg  [31:0] int_in;
    wire [31:0] result;
    wire        Exception, Overflow, Underflow;

    // Instantiate pipelined version
    int_to_fp32_pipeline uut (
        .clk(clk),
        .rst(rst),
        .int_in(int_in),
        .Exception(Exception),
        .Overflow(Overflow),
        .Underflow(Underflow),
        .result(result)
    );

    // Pipeline delay: 2 cycles
    localparam PIPELINE_DELAY = 2;

    // Input queue and delayed checking
    reg [31:0] input_queue [0:31];
    integer i, delay_counter = 0;

    initial begin
        // Initialize input queue
        input_queue[0]  = 32'd0;           // Zero
        input_queue[1]  = 32'd1;           // +1
        input_queue[2]  = -32'd5;          // -5
        input_queue[3]  = 32'd2;           // +2
        input_queue[4]  = -32'd2;          // -2
        input_queue[5]  = 32'd3;           // +3, rounding
        input_queue[6]  = 32'd255;         // +255
        input_queue[7]  = 32'd1023;        // +1023
        input_queue[8]  = 32'd8388607;     // Max int w/o rounding
        input_queue[9]  = 32'd8388608;     // Will round mantissa
        input_queue[10] = 32'h7FFFFFFF;    // INT_MAX
        input_queue[11] = 32'h80000000;    // INT_MIN
        input_queue[12] = 32'd16777215;    // 2^24 - 1
        input_queue[13] = 32'd16777216;    // 2^24
        for (i = 14; i < 32; i = i + 1)
            input_queue[i] = 0; // pad

        $display("Starting pipelined IntToFP32 tests...\n");

        // Apply reset
        rst = 0;
        #10;
        rst = 1;

        // Feed inputs every clock
        for (i = 0; i < 32 + PIPELINE_DELAY; i = i + 1) begin
            @(posedge clk);

            if (i < 32)
                int_in <= input_queue[i];
            else
                int_in <= 0;

            // Display output after pipeline delay
            if (i >= PIPELINE_DELAY) begin
                $display("Cycle %2d | int_in = %0d => result = %h | Sign = %b, Exp = %d, Man = %d | OF = %b, UF = %b, EXC = %b",
                         i, input_queue[i - PIPELINE_DELAY], result, result[31], result[30:23], result[22:0],
                         Overflow, Underflow, Exception);
            end
        end

        $display("\nFinished pipelined tests.");
        $stop;
    end

endmodule
