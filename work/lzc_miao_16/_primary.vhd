library verilog;
use verilog.vl_types.all;
entity lzc_miao_16 is
    port(
        \in\            : in     vl_logic_vector(15 downto 0);
        out_z           : out    vl_logic_vector(3 downto 0);
        v               : out    vl_logic
    );
end lzc_miao_16;
