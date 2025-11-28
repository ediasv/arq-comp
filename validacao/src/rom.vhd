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
    0      => "000100000100101", -- LD R1, 2
    1      => "001011111110101", -- LD R2, 127
    2      => "000100000100100", -- MV A, R2
    3      => "000100000100001", -- ADD A, R2 (A = 254)
    4      => "000001010000100", -- MV R2, A
    5      => "000100000100001", -- ADD A, R2 (A = 508)
    6      => "000100000100001", -- ADD A, R2 (A = 762)
    7      => "010100011000101", -- LD R5, 12
    8      => "000100001010001", -- ADD A, R5 (A = 774)
    9      => "000001010000100", -- MV R2, A (R2 = 774)
    10     => "011100000010101", -- LD R7, 1
    11     => "000100000010100", -- MV ACC, R1 (carrega_ram)
    12     => "000100001111011", -- SW ACC, R7
    13     => "000100001110001", -- ADD ACC, R7
    14     => "000000110000100", -- MV R1, ACC
    15     => "000100000010100", -- MV ACC, R1
    16     => "000100000100010", -- SUB ACC, R2
    17     => "000000000100111", -- BEQ 2 (fim_carrega_ram)
    18     => "000000010110110", -- JMP 11 (carrega_ram)
    19     => "000000000000000", -- NOP (fim_carrega_ram)
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
