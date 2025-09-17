library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity add is
    port(
        add_in0 : in  unsigned(15 downto 0);
        add_in1 : in  unsigned(15 downto 0);
        out_add : out unsigned(15 downto 0)
    );
end entity;

architecture a_add of add is
begin
    out_add <= add_in0 + add_in1;
end architecture;