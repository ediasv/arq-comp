library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity rom is
  port (clk      : in  std_logic;
        endereco : in  unsigned(6 downto 0);
        dado     : out unsigned(14 downto 0)
       );
end entity;

--TAMANHO DA INSTRUÇÃO: 15 bits
--ROM síncrona de 128 enderecos

architecture a_rom of rom is
  type mem is array (0 to 127) of unsigned(14 downto 0);
  constant conteudo_rom : mem := (
    -- caso endereco => conteudo
    0      => "001100001010000", -- LD R3, 0
    1      => "010000010000000", -- LD R4, 0

-- Soma R3 com R4 e guarda em R4
    2      => "000100000110001", -- MV A, R3 
    3      => "000100000110001", -- ADD A, R4
    4      => "000100000110001", -- MV R4, A

-- Soma 1 em R3
    5      => "000010110000100", --  LD  R1, -1    
    6      => "000010110000100", --  MV  A, R1     
    7      => "000010110000100", --  SUB A, R3   
    8      => "000010110000100", --  MV  R3, A      

-- Se R3<30 salta para a instrução do passo C * (soma r3 com r4)
    9      => "001000000111110", -- LD R5, 30
    10     => "000100000111101", -- SUB A, R5
    11     => "010100000000111", -- JN 13

-- Copia valor de R4 para R5
    12     => "000010010000100", -- MV R5, R4


    others => (others => '0')
  );

  signal dado_sig : unsigned(14 downto 0) := conteudo_rom(0);
begin
  process (clk)
  begin
    if (rising_edge(clk)) then
      if (endereco >= 0 and endereco <= 127) then
        dado_sig <= conteudo_rom(to_integer(endereco));
      else
        dado_sig <= (others => '0');
      end if;
    end if;
  end process;

  dado <= dado_sig;
end architecture;
