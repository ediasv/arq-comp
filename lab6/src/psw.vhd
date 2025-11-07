library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity psw is
  port (
      clk      : in  std_logic;
        rst      : in  std_logic;
        wr_en    : in  std_logic;
        data_in  : in  unsigned(1 downto 0);
      -- Flags individuais
      
         flag_z   : out std_logic;  -- Zero
         flag_v   : out std_logic   -- Overflow
         -- flag_c   : out std_logic;  -- Carry
         -- flag_n   : out std_logic;  -- Negative
       );
end entity;

architecture a_psw of psw is
  signal flag : unsigned(3 downto 0) := (others => '0');
begin
  process (clk, rst)
  begin
    if rst = '1' then
      flag <= (others => '0');
    elsif rising_edge(clk) then
      if wr_en = '1' then
        flag <= data_in;
      end if;
    end if;
  end process;

--   flag_n <= flag(3);  -- MI/PL: Negative flag
--   flag_c <= flag(1);  -- CS/CC: Carry flag
flag_v <= flag(1);  -- VS/VC: Overflow flag
flag_z <= flag(0);  -- EQ/NE: Zero flag


  end architecture;

-- EQ Equal Z = 1
-- NE Not equal Z = 0
-- CS Carry set (identical to HS) C = 1
-- CC Carry clear (identical to LO) C = 0
-- MI Minus or negative result N = 1
-- PL Positive or zero result N = 0
-- VS Overflow V = 1
-- VC Now overflow V = 0
-- AL Always. This is the default 


