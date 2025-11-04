library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity sm_tb is
end entity;

architecture a_sm_tb of sm_tb is

  component sm
    port (
      clk    : in  std_logic;
      rst    : in  std_logic;
      estado : out unsigned(1 downto 0)
    );
  end component;

  signal clk    : std_logic              := '0';
  signal rst    : std_logic              := '0';
  signal estado : unsigned(1 downto 0);

  constant clk_period : time := 100 ns;

begin

  -- Clock generation
  clk <= not clk after clk_period / 2;

  -- Instantiate state machine
  uut: sm
    port map (
      clk    => clk,
      rst    => rst,
      estado => estado
    );

  -- Test process
  stimulus: process
  begin
    -- Test 1: Reset
    rst <= '1';
    wait for clk_period * 2;
    rst <= '0';
    wait for clk_period;

    -- Test 2: State progression (00 -> 01 -> 10 -> 00)
    wait for clk_period * 6;

    -- Test 3: Reset during operation
    rst <= '1';
    wait for clk_period;
    rst <= '0';
    wait for clk_period;

    -- Test 4: Continue state progression
    wait for clk_period * 5;

    wait;
  end process;

end architecture;
