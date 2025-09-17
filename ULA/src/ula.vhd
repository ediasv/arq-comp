library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- 00 for 'add'
-- 01 for 'sub'
-- 10 for 'and'
-- 11 for 'or'
entity ula is
    port (
        in0, in1 : in  std_logic_vector(15 downto 0);
        op       : in  std_logic_vector(1 downto 0);
        ula_out  : out std_logic_vector(15 downto 0);
        zero     : out std_logic;
        carry    : out std_logic
    );
end entity;

architecture a_ula of ula is
  signal sum_result, subtraction_result, and_result, or_result: std_logic_vector(15 downto 0);
begin
  temporary_sum <= std_logic_vector(signed(('0' & in0)) + signed(('0' & in1))); --carry flag
  sum_result         <= std_logic_vector(signed(in0) + signed(in1));
  subtraction_result <= std_logic_vector(signed(in0) - signed(in1));
  and_result         <= in0 and in1;
  or_result          <= in0 or in1;

  ula_out <= sum_result         when op = "00" else
             subtraction_result when op = "01" else
             and_result         when op = "10" else
             or_result          when op = "11" else
             (others => '0');

  zero  <= '1' when ula_out = x"0000" else '0';
  carry <= temporary_sum(16) when op = "00" else
           '1' when (op = "01" and in0 < in1) else 
           '0';
end architecture;
