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
    );
end entity;

architecture a_ula of ula is
  signal subtraction_result, and_result, or_result: std_logic_vector(15 downto 0);
  signal sum_result: std_logic_vector(16 downto 0);
  signal ula_result: std_logic_vector(15 downto 0);
begin
  -- Addition with carry out
  sum_result         <= std_logic_vector(resize(signed(in0), 17) + resize(signed(in1), 17));
  subtraction_result <= std_logic_vector(signed(in0) - signed(in1));
  and_result         <= in0 and in1;
  or_result          <= in0 or in1;
  ula_out            <= ula_result;

  zero  <= '1' when ula_result = x"0000" else '0';



  ula_result <= sum_result(15 downto 0) when op = "00" else
                subtraction_result      when op = "01" else
                and_result              when op = "10" else
                or_result               when op = "11" else
                (others => '0');
end architecture;
