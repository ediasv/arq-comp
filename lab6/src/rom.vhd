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

-- Carrega R3 (o registrador 3) com o valor 0
    0      => "0011 0000000 0101", -- LD R3, 0  

-- Carrega R4 com 0
    1      => "0100 0000000 0101", -- LD R4, 0 

-- Soma R3 com R4 e guarda em R4
    2      => "000 1001 0011 0100", -- MV A, R3 
    3      => "000 1001 0100 0001", -- ADD A, R4
    4      => "000 0100 1001 0100", -- MV R4, A

-- Soma 1 em R3
    5      => "0001   1011000 0101", --  LD  R1, -1    
    6      => "000  1001  0001 0100", --  MV  A, R1     
    7      => "000  1001  0011 0010", --  SUB A, R3   
    8      => "000  0011  1001 0100", --  MV  R3, A      

-- Se R3<30 salta para a instrução do passo C * (soma r3 com r4)
    9      => "0101 0011110 0101", -- LD R5, 30
    10     => "000 1000 0011 0010", -- SUB A, R5
    11     => "0010 0000000 0111", -- BEQ 2

-- Copia valor de R4 para R5
    12     => "000 0101 0100 0100", -- MV R5, R4


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
