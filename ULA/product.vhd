library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all

entity product is
    port(   
            product_in0 : in  unsigned(15 downto 0);
            product_in1 : in  unsigned(15 downto 0);
            out_product : out unsigned(15 downto 0)  
    )
end entity;

architecture a_product of product is
    begin
        out_product <= product_in0 * product_in1;
    end architecture;