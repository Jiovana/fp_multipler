library verilog;
use verilog.vl_types.all;
entity Multiplication2 is
    port(
        a_operand       : in     vl_logic_vector(31 downto 0);
        b_operand       : in     vl_logic_vector(31 downto 0);
        Exception       : out    vl_logic;
        Overflow        : out    vl_logic;
        Underflow       : out    vl_logic;
        result          : out    vl_logic_vector(31 downto 0)
    );
end Multiplication2;
