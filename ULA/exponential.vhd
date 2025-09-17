library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all

entity exponential is
    port(   
            exponential_in0 : in  unsigned(15 downto 0);
            exponential_in1 : in  unsigned(15 downto 0);
            out_exponential : out unsigned(15 downto 0)  
    )
end entity;

architecture a_exponential of exponential is
    begin
        out_exponential <= exponential_in0 + exponential_in1;
    end architecture;