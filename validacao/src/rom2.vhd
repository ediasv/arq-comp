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
    0     => "000100001110101", -- LD R1, 7
    1     => "000000000000000", -- NOP
    2     => "011000001010101", -- LD R6, 5 --750ns

    3     => "000100001100001", -- ADD A, R6 --1050ns

    4     => "000100000010010", -- SUB A, R1 - 1350ns 
    
    5     => "100000001110011", -- SUBI A, 7 - 1650ns -> ACC = 5

    6     => "000001010000100", -- MV R2, A

    7    => "000000000000000", -- NOP

    8     => "010000001010101", -- LD R4, 5

    9     => "000100001000010", -- SUB A, R4

    10    => "000000000100111", -- BEQ 2 -- relativo

   

    12    => "011111111110101", -- LD R7, 127
    13    => "000100001110100", -- MV A, R7        (ACC = 127)

    14    => "000100001110001", -- ADD A, R7       (ACC = 254)
    15    => "000011110000100", -- MV R7, A        (R7 = 254)
    16    => "000100001110001", -- ADD A, R7       (ACC = 508)
    17    => "000011110000100", -- MV R7, A        (R7 = 508)
    18    => "000100001110001", -- ADD A, R7       (ACC = 1016)
    19    => "000011110000100", -- MV R7, A        (R7 = 1016)
    20    => "000100001110001", -- ADD A, R7       (ACC = 2032)
    21    => "000011110000100", -- MV R7, A        (R7 = 2032)
    22    => "000100001110001", -- ADD A, R7       (ACC = 4064)
    23    => "000011110000100", -- MV R7, A        (R7 = 4064)
    24    => "000100001110001", -- ADD A, R7       (ACC = 8128)
    25    => "000011110000100", -- MV R7, A        (R7 = 8128)
    26    => "000100001110001", -- ADD A, R7       (ACC = 16256)
    27    => "000011110000100", -- MV R7, A        (R7 = 16256)
    28    => "000100001110001", -- ADD A, R7       (ACC = 32512)
    29    => "000011110000100", -- MV R7, A        (R7 = 32512)
    30    => "000100001110001", -- ADD A, R7       (ACC = 65024) 
   
    
    31    => "000000001101000",    -- BVS 6 

    37    => "000000000110101", -- LD R0, 3
    38    => "000100000000100", -- MV A, R0
    39    => "000111001000101", -- LD R1, 100
    40    => "000100000011011", -- SW A, R1


    41    => "000010110001010", -- LW R5, A
    42    => "000000010100110", -- JMP 10
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


