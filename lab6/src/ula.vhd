library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

  -- 00 for 'add'
  -- 01 for 'sub'
  -- 10 for 'and'
  -- 11 for 'or'

entity ula is
  port (
    in0, in1  : in  unsigned(15 downto 0);
    op        : in  unsigned(1 downto 0);
    ula_out   : out unsigned(15 downto 0);
    flag_neg  : out std_logic;  -- Negative
    flag_zero : out std_logic;  -- Zero
    flag_carry: out std_logic;  -- Carry
    flag_over : out std_logic   -- Overflow
  );
end entity;

architecture a_ula of ula is
  signal sum_result, subtraction_result, and_result, or_result, temp_ula_out : unsigned(15 downto 0);
  signal sum_extended, sub_extended : unsigned(16 downto 0);

  begin
  
    -- Operações estendidas para detectar carry/borrow
  sum_extended <= ('0' & in0) + ('0' & in1);
  sub_extended <= ('0' & in0) - ('0' & in1);

  sum_result         <= in0 + in1;
  subtraction_result <= in0 - in1;
  and_result         <= in0 and in1;
  or_result          <= in0 or in1;

  temp_ula_out <= sum_result         when op = "00" else
                  subtraction_result when op = "01" else
                  and_result         when op = "10" else
                  or_result          when op = "11" else
                    (others => '0');

  ula_out <= temp_ula_out;

  -- Flag N (Negative): bit mais significativo do resultado
  flag_neg <= temp_ula_out(15);
  
  -- Flag Z (Zero): resultado é zero
  flag_zero <= '1' when temp_ula_out = x"0000" else '0';
  
  -- Flag C (Carry): carry da soma ou borrow da subtração
  flag_carry <= sum_extended(16) when op = "00" else  -- Carry na soma
            sub_extended(16) when op = "01" else  -- Borrow na subtração
            '0';
  
  -- Flag V (Overflow): overflow em operações com sinal
  -- Overflow ocorre quando:
  -- - Soma: operandos com mesmo sinal produzem resultado com sinal diferente
  -- - Subtração: operandos com sinais diferentes produzem resultado com sinal diferente do primeiro operando
  flag_over <= '1' when (op = "00" and in0(15) = in1(15) and temp_ula_out(15) /= in0(15)) else
            '1' when (op = "01" and in0(15) /= in1(15) and temp_ula_out(15) /= in0(15)) else
            '0';
end architecture;
