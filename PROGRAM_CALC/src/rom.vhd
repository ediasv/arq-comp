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
    0      => "001100001010101",  -- LD R3, 5
    1      => "010000010000101",  -- LD R4, 8
    2      => "000100101000100", -- MV A, R4
    3      => "000001110010001", -- ADD R3, A
    4      => "000010110010100", -- MV R5, A
    5      => "000100000010101",  -- LD R1, 1
    6      => "000100100010100", -- MV A, R1
    7      => "000010110010010", -- SUB R5, A
    8      => "000010110010100", -- MV R5, A
    9      => "000000101000110",  -- JMP 20
    10     => "000100101010100", -- MV A, R5
    11     => "000010110010010", -- SUB R5, A
    12     => "000010110010100", -- MV R5, A
    13     => "000000000000000",    -- NOP
    14     => "000000000000000",    -- NOP
    15     => "000000000000000",    -- NOP
    16     => "000000000000000",    -- NOP
    17     => "000000000000000",    -- NOP
    18     => "000000000000000",    -- NOP
    19     => "000000000000000",    -- NOP
    20     => "000001101010100", -- MV R3, R5
    21     => "000000000100110",  -- JMP 2
    22     => "000100100110100", -- MV A, R3
    23     => "000001110010010", -- SUB R3, A
    24     => "000001110010100", -- MV R3, A
    others => (others => '0')
  );

begin
  process (clk)
  begin
    if (rising_edge(clk)) then
      dado <= conteudo_rom(to_integer(endereco));
    end if;
  end process;
end architecture;
