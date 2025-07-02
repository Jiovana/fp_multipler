library verilog;
use verilog.vl_types.all;
entity tb_dequantizer_parallel is
    generic(
        NUM_BLOCKS      : integer := 8;
        PIPELINE_LATENCY: integer := 5;
        MAX_LINES_PER_BLOCK: integer := 100000
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NUM_BLOCKS : constant is 1;
    attribute mti_svvh_generic_type of PIPELINE_LATENCY : constant is 1;
    attribute mti_svvh_generic_type of MAX_LINES_PER_BLOCK : constant is 1;
end tb_dequantizer_parallel;
