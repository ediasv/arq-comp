library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
entity mux16bits is
    port(   in_constant   : in  unsigned(15 downto 0);
            in_reg   : in  unsigned(15 downto 0);
            op    : in    std_logic; 
            mux_out : out unsigned(15 downto 0)
      ); 
end entity;


architecture a_mux16bits of mux16bits is
begin
    mux_out <=   in_constant when op='1' else -- op with constant
                 in_reg when op='0' else
                 (others => '0');  
                            
end architecture;