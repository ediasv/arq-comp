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
    3      => "000100000100001", -- ADD A, R2
    4      => "000001010000100", -- MV R2, A
    5      => "000100000100001", -- ADD A, R2
    6      => "000100000100001", -- ADD A, R2
    7      => "010100011000101", -- LD R5, 12
    8      => "000100001010001", -- ADD A, R5
    9      => "000001010000100", -- MV R2, A
    10     => "011100000010101", -- LD R7, 1
    11     => "000100000010100", -- MV ACC, R1 (carrega_ram)
    12     => "000100001111011", -- SW ACC, R7
    13     => "000100001110001", -- ADD ACC, R7
    14     => "000000110000100", -- MV R1, ACC
    15     => "000100000010100", -- MV ACC, R1
    16     => "000100000100010", -- SUB ACC, R2
    17     => "000000000100111", -- BEQ 2
    18     => "000000010110110", -- JMP 11
    19     => "000010100100100", -- MV R5, R3 (fim_carrega_ram)
    20     => "001100111000101", -- LD R3, 28
    21     => "001000000100101", -- LD R2, 2
    22     => "000100000010101", -- LD R1, 1
    23     => "000000000000101", -- LD R0, 0
    24     => "000100000100100", -- MV A, R2 (inicio_loop_crivo)
    25     => "000010010001010", -- LW R4, A
    26     => "000100001000100", -- MV A, R4
    27     => "000100000010010", -- SUB A, R1
    28     => "000000000100111", -- BEQ 2
    29     => "000000111110110", -- JMP 31
    30     => "000011000100100", -- MV R6, R2 (tira_multiplos)
    31     => "000100001100100", -- MV A, R6 (prox_multiplo)
    32     => "000100000100001", -- ADD A, R2
    33     => "000100000001011", -- SW A, R0
    34     => "000011010000100", -- MV R6, A
    35     => "000100001010010", -- SUB A, R5
    36     => "000000000100111", -- BEQ 3
    37     => "000000000101001",  -- BLT 2
    38     => "000000111110110", -- JMP 31
    39     => "000100000100100", -- MV A, R2 (proximo_endereco_ram)
    40     => "000100000010001", -- ADD A, R1
    41     => "000001010000100", -- MV R2, A
    42     => "000100000110010", -- SUB A, R3
    43     => "000000000100111", -- BEQ 2
    44     => "000000110000110", -- JMP 24
    45     => "000000000000000", -- NOP (fim_loop_crivo)
    46     => "001000000100101", -- LD R2, 2
    47     => "000100000010101", -- LD R1, 1
    48     => "011100000000101", -- LD R7, 0
    49     => "011000000000101", -- LD R6, 0
    50     => "010000000000101", -- LD R4, 0
    51     => "000000000110101", -- LD R0, 3
    52     => "000100000100100", -- MV A, R2 (inicio_loop_validacao)
    53     => "000100001010010", -- SUB A, R5
    54     => "000000101000111", -- BEQ 20
    55     => "000100000100100", -- MV A, R2
    56     => "000001110001010", -- LW R3, A
    57     => "000100000110100", -- MV A, R3
    58     => "100000000000011", -- SUBI A, 0
    59     => "000000010100111", -- BEQ 10
    60     => "000010000100100", -- MV R4, R2
    61     => "000100000010100", -- MV A, R1
    62     => "000100000000010", -- SUB A, R0
    63     => "000000010000100", -- MV R0, A
    64     => "000000010010111", -- BEQ 9
    65     => "000100001010100", -- MV A, R5 (volta_achou_debug)
    66     => "000100000010010", -- SUB A, R1
    67     => "000100000100010", -- SUB A, R2
    68     => "000000000100111", -- BEQ 2
    69     => "000100000100100", -- MV A, R2 (volta_achou_eh_primo)
    70     => "000100000010001", -- ADD A, R1
    71     => "000001010000100", -- MV R2, A
    72     => "000001101000110", -- JMP 52
    73     => "000011100100100", -- MV R7, R2 (achou_debug)
    74     => "000010000010110", -- JMP 65
    75     => "011000000010101", -- LD R6, 1 (achou_eh_primo)
    76     => "000010001010110", -- JMP 69
    77     => "000000000000000", -- NOP (fim_loop_validacao)
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
