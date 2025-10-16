library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity rom is
   port( clk      : in std_logic;
         endereco : in unsigned(6 downto 0); -- 2⁷ = 128 endereços (com 7 bits, escrevo de 0 a 127)
         dado     : out unsigned(14 downto 0) 
   );
end entity;

--TAMANHO DA INSTRUÇÃO: 15 bits
--ROM síncrona

architecture a_rom of rom is
   type mem is array (0 to 127) of unsigned(14 downto 0);
   constant conteudo_rom : mem := ( 
      -- caso endereco => conteudo
      0  => "000000000000000",
      1  => "000000000000000",
      2  => "000000000000000",
      3  => "000000000000000",
      4  => "000000000000000",
      5  => "000000000000000",
      6  => "000000000000000",
      7  => "000000000000000",
      8  => "000000010000000",
      9  => "000000000000000",
      10 => "000000000000000", 
      --os endereços de 0 a 10 possuem os valores acima, os demais endereços estão setados como zeros => (zero em todos os bits)
      others => (others=>'0')
   );
begin
   process(clk)
   begin
      if(rising_edge(clk)) then
         dado <= conteudo_rom(to_integer(endereco));
      end if;
   end process;
end architecture;