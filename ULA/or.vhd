library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all

entity or is
    port(   
           or_in0 : in  unsigned(15 downto 0);
           or_in1 : in  unsigned(15 downto 0);
            out_or : out unsigned(15 downto 0)  
    )
end entity;

architecture a_or of or is
    begin
        out_or <=or_in0 or or_in1;
    end architecture;