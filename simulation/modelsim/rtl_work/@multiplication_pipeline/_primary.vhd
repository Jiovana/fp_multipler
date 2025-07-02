library verilog;
use verilog.vl_types.all;
entity Multiplication_pipeline is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        a_operand       : in     vl_logic_vector(31 downto 0);
        b_operand       : in     vl_logic_vector(31 downto 0);
        exception       : out    vl_logic;
        overflow        : out    vl_logic;
        underflow       : out    vl_logic;
        result          : out    vl_logic_vector(31 downto 0)
    );
end Multiplication_pipeline;
