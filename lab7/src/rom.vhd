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
    0   => "000000000110101",  --LD R0, 3
    1   => "000111001000101",  --LD R1, 100
    2   => "000100000000100",  --MV ACC, R0
    3   => "000100000011011",  --SW ACC, R1
    4   => "001000100010101",  --LD R2, 17
    5   => "001110110010101",  --LD R3, 89
    6   => "000001100101011",  --SW R3, R2
    7   => "010001010100101",  --LD R4, 42
    8   => "010110111110101",  --LD R5, 95
    9   => "000010101001011",  --SW R5, R4
    10  => "011010110010101",  --LD R6, 89
    11  => "011100111110101",  --LD R7, 31
    12  => "000011101101011",  --SW R7, R6
    13  => "000011110000101",  --LD R0, 120
    14  => "000100111010101",  --LD R1,29           
    15  => "000000100001011",  --SW R1, R0
    16  => "000001100100101",  --LD R0, 50
    17  => "000100110010101",  --LD R1, 25
    18  => "000100000000100",  --MV A, R0
    19  => "000100000010001",  --ADD A, R1
    20  => "000001010000100",  --MV R2, A
    21  => "001100010100101",  --LD R3, 10
    22  => "000100000100100",  --MV A, R2
    23  => "000100000110010",  --SUB A, R3
    24  => "000010010000100",  --MV R4, A
    25  => "000000000110101",  --LD R0, 3
    26  => "000010100001010",  --LW R5, R0
    27  => "000100100010101",  --LD R1, 17
    28  => "000011000011010",  --LW R6, R1
    29  => "001001010100101",  --LD R2, 42
    30  => "000011100101010",  --LW R7, R2
    31  => "010010110010101",  --LD R4, 89
    32  => "000001101001010",  --LW R3, R4
    33  => "000111110000101",  --LD R1, 120
    34  => "000000000011010",  --LW R0, R1
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
