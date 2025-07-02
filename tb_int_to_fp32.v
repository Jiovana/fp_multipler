`timescale 1ns / 1ps

module tb_int_to_fp32;

    reg  [31:0] int_in;
    wire [31:0] result;
    wire        Exception, Overflow, Underflow;

    int_to_fp32 uut (
        .int_in(int_in),
        .Exception(Exception),
        .Overflow(Overflow),
        .Underflow(Underflow),
        .result(result)
    );

    task display_result;
        input [31:0] input_val;
        begin
            int_in = input_val;
            #10;
            $display("int_in = %0d => result = %h | Sign = %b, Exp = %d, Man = %d | OF = %b, UF = %b, EXC = %b",
                     int_in, result, result[31], result[30:23], result[22:0],
                     Overflow, Underflow, Exception);
        end
    endtask

    initial begin
        $display("Starting IntToFloat32 tests...\n");

        display_result(32'd0);          // Zero
        display_result(32'd1);          // +1
        display_result(-32'd5);         // -5
        display_result(32'd2);          // +2
        display_result(-32'd2);         // -2
        display_result(32'd3);          // +3, will test rounding
        display_result(32'd255);        // +255
        display_result(32'd1023);       // Check mantissa range
        display_result(32'd8388607);    // Max int without rounding mantissa
        display_result(32'd8388608);    // Will round mantissa
        display_result(32'h7FFFFFFF);   // INT_MAX 
        display_result(32'h80000000);   // INT_MIN - negative value
        display_result(32'd16777215);   // 2^24 - 1, max int exactly representable
        display_result(32'd16777216);   // 2^24, needs rounding
		  // all tests working

        $display("\nFinished testing.");
        $stop;
    end

endmodule
