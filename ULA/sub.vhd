library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all

entity sub is
    port(   
            sub_in0 : in  unsigned(15 downto 0);
            sub_in1 : in  unsigned(15 downto 0);
            out_sub : out unsigned(15 downto 0)  
    )
end entity;

architecture a_sub of sub is
    begin
        out_sub <= sub_in0 + sub_in1;
    end architecture;