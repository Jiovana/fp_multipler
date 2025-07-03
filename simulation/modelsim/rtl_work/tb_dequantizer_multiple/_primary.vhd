library verilog;
use verilog.vl_types.all;
entity tb_dequantizer_multiple is
    generic(
        NUM_UNITS       : integer := 1;
        NUM_FILES       : integer := 8;
        FILE_NAMES      : vl_notype;
        MAX_ENTRIES     : vl_logic_vector(31 downto 0);
        PIPELINE_LATENCY: integer := 5
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NUM_UNITS : constant is 2;
    attribute mti_svvh_generic_type of NUM_FILES : constant is 2;
    attribute mti_svvh_generic_type of FILE_NAMES : constant is 4;
    attribute mti_svvh_generic_type of MAX_ENTRIES : constant is 4;
    attribute mti_svvh_generic_type of PIPELINE_LATENCY : constant is 2;
end tb_dequantizer_multiple;
