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
    0   =>  "000000000110101", --LD R0, 3
    1   => "000111001000101",  --LD R1, 100
    2   => "000000100001011",  --SW R1, R0
    3   => "001000100010101",  --LD R2, 17
    4   => "001110110010101",  --LD R3, 89
    5   => "000001100101011",  --SW R3, R2
    6   => "010001010100101",  --LD R4, 42
    7   => "010110111110101",  --LD R5, 95
    8   => "000010101001011",  --SW R5, R4
    9   => "011010110010101",  --LD R6, 89
    10  => "011100111110101",  --LD R7, 31
    11  => "000011101101011",  --SW R7, R6
    12  => "000011110000101",  --LD R0, 120
    13  => "000100111010101",  --LD R1,29           
    14  => "000000100001011",  --SW R1, R0
    15  => "000001100100101",  --LD R0, 50
    16  => "000100110010101",  --LD R1, 25
    17  => "000100000000100",  --MV A, R0
    18  => "000100000010001",  --ADD A, R1
    19  => "000001010000100",  --MV R2, A
    20  => "001100010100101",  --LD R3, 10
    21  => "000100000100100",  --MV A, R2
    22  => "000100000110010",  --SUB A, R3
    23  => "000010010000100",  --MV R4, A
    24  => "000000000110101",  --LD R0, 3
    25  => "000010100001010",  --LW R5, R0
    26  => "000100100010101",  --LD R1, 17
    27  => "000011000011010",  --LW R6, R1
    28  => "001001010100101",  --LD R2, 42
    29  => "000011100101010",  --LW R7, R2
    30  => "010010110010101",  --LD R4, 89
    31  => "000001101001010",  --LW R3, R4
    32  => "000111110000101",  --LD R1, 120
    33  => "000000000011010",  --LW R0, R1
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
