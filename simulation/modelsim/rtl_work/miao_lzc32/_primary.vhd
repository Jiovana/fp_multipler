library verilog;
use verilog.vl_types.all;
entity miao_lzc32 is
    port(
        \in\            : in     vl_logic_vector(31 downto 0);
        out_z           : out    vl_logic_vector(4 downto 0);
        v               : out    vl_logic
    );
end miao_lzc32;
