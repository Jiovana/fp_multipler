library verilog;
use verilog.vl_types.all;
entity lzc_miao_8_old is
    port(
        \in\            : in     vl_logic_vector(7 downto 0);
        out_z           : out    vl_logic_vector(2 downto 0);
        v               : out    vl_logic
    );
end lzc_miao_8_old;
