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
    6   => "000100000100100",  --MV ACC, R2
    7   => "000100000111011",  --SW ACC, R3
      
    8   => "010001010100101",  --LD R4, 42
    9   => "010110111110101",  --LD R5, 95
    10  => "000100001000100",  --MV ACC, R4
    11  => "000100001011011",  --SW ACC, R5
      
    12  => "011010110010101",  --LD R6, 89
    13  => "011100111110101",  --LD R7, 31
    14  => "000100001100100",  --MV ACC, R6
    15  => "000100001111011",  --SW ACC, R7
      
    16  => "000100111010101",  --LD R1,29
    17  => "000011110000101",  --LD R0, 120
    18  => "000100000000100",  --MV ACC, R0
    19  => "000100000011011",  --SW ACC, R1

    20  => "000001100100101",  --LD R0, 50
    21  => "000100110010101",  --LD R1, 25
    22  => "000100000000100",  --MV A, R0
    23  => "000100000010001",  --ADD A, R1
    24  => "000001010000100",  --MV R2, A

    25  => "001100010100101",  --LD R3, 10
    26  => "000100000100100",  --MV A, R2
    27  => "000100000110010",  --SUB A, R3
    28  => "000010010000100",  --MV R4, A

    29  => "000000000110101",  --LD R0, 3
    30  => "000100000000100",  --MV ACC, R0
    31  => "000010110001010",  --LW R5, ACC

    32  => "000100100010101",  --LD R1, 17
    33  => "000100000010100",  --MV ACC, R1
    34  => "000011010001010",  --LW R6, ACC

    35  => "001001010100101",  --LD R2, 42
    36  => "000100000100100",  --MV ACC, R2
    37  => "000011110001010",  --LW R7, ACC

    38  => "010010110010101",  --LD R4, 89
    39  => "000100001000100",  --MV ACC, R4
    40  => "000001110001010",  --LW R3, ACC

    41  => "000111110000101",  --LD R1, 120
    42  => "000100000010100",  --MV ACC, R1
    43  => "000000010001010",  --LW R0, ACC
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
