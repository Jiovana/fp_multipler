library verilog;
use verilog.vl_types.all;
entity int_to_fp32_pipeline is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        int_in          : in     vl_logic_vector(31 downto 0);
        Exception       : out    vl_logic;
        Overflow        : out    vl_logic;
        Underflow       : out    vl_logic;
        result          : out    vl_logic_vector(31 downto 0)
    );
end int_to_fp32_pipeline;
