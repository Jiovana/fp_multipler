library verilog;
use verilog.vl_types.all;
entity dequantizer_blockx2 is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        level1          : in     vl_logic_vector(31 downto 0);
        level2          : in     vl_logic_vector(31 downto 0);
        is_weight1      : in     vl_logic;
        is_weight2      : in     vl_logic;
        weight_fp1      : out    vl_logic_vector(31 downto 0);
        weight_fp2      : out    vl_logic_vector(31 downto 0)
    );
end dequantizer_blockx2;
