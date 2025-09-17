library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all

entity and is
    port(   
            and_in0 : in  unsigned(15 downto 0);
            and_in1 : in  unsigned(15 downto 0);
            out_and : out unsigned(15 downto 0)  
    )
end entity;

architecture a_and of and is
    begin
        out_and <= and_in0 and and_in1
    end architecture;