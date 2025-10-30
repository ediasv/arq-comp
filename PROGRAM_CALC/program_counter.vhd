library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_counter is
  port (
    clk      : in  std_logic;
    wr_en    : in  std_logic;
    data_in  : in  unsigned(6 downto 0);  -- 7 bits
    data_out : out unsigned(6 downto 0)
  );
end entity;

architecture a_program_counter of program_counter is
  signal pc_value : unsigned(6 downto 0) := (others => '0');

begin
  process (clk)
  begin
    if rising_edge(clk) then
      if wr_en = '1' then
        pc_value <= data_in;  
      end if;
    end if;
  end process;

  data_out <= pc_value;
end architecture;