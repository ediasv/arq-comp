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
    0      => "001100000000101", -- LD R3, 0  

-- Carrega R4 com 0
    1      => "010000000000101", -- LD R4, 0 

-- Soma R3 com R4 e guarda em R4
    2      => "000100000110100", -- MV A, R3 
    3      => "000100001000001", -- ADD A, R4
    4      => "000010010000100", -- MV R4, A

-- Soma 1 em R3
    5      => "100000000010101",  --  LD  A, 1    
    6      => "000100000110001", --  ADD  A, R3     
    7      => "000001110000100", --  MV  R3, A      

-- Se R3<30 salta para a instrução do passo C * (soma r3 com r4)
    8      => "100000111100101", -- LD A, 30
    9     => "000100000110010", -- SUB A, R3

    10     => "100011110000111", -- BEQ 2


-- Copia valor de R4 para R5
    11     => "000010101000100", -- MV R5, R4


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
