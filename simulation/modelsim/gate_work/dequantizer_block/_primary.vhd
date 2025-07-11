library verilog;
use verilog.vl_types.all;
entity dequantizer_block is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        level_int       : in     vl_logic_vector(31 downto 0);
        is_weight       : in     vl_logic;
        weight_fp_reg   : out    vl_logic_vector(31 downto 0)
    );
end dequantizer_block;
