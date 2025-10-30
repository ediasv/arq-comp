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
    op        : in  std_logic_vector(1 downto 0);
    ula_out   : out unsigned(15 downto 0);
    zero, sig : out std_logic
  );
end entity;

architecture a_ula of ula is
  signal sum_result, subtraction_result, and_result, or_result, temp_ula_out : unsigned(15 downto 0);
begin

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
  zero    <= '1' when temp_ula_out = x"0000" else '0';
  sig     <= temp_ula_out(15);
end architecture;
