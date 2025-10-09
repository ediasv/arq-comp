library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity reg16bits_tb is
end entity;

architecture a_reg16bits_tb of reg16bits_tb is

  component reg16bits
    port (clk      : in  std_logic;
          rst      : in  std_logic;
          wr_en    : in  std_logic;
          data_in  : in  unsigned(15 downto 0);
          data_out : out unsigned(15 downto 0)
         );
  end component;

  signal clk      : std_logic                := '0';
  signal rst      : std_logic                := '0';
  signal wr_en    : std_logic                := '0';
  signal data_in  : unsigned(15 downto 0)    := (others => '0');
  signal data_out : unsigned(15 downto 0);

  constant clk_period : time := 100 ns;

begin

  -- Clock generation
  clk_process: process
  begin
    clk <= '0';
    wait for clk_period / 2;
    clk <= '1';
    wait for clk_period / 2;
  end process;

  -- Unit under test
  uut: reg16bits
    port map (
      clk      => clk,
      rst      => rst,
      wr_en    => wr_en,
      data_in  => data_in,
      data_out => data_out
    );

  -- Stimulus process
  stimulus: process
  begin
    -- Test 1: Reset test
    rst <= '1';
    wait for clk_period * 2;
    rst <= '0';
    wait for clk_period;

    -- Test 2: Write enable test - write a value
    wr_en <= '1';
    data_in <= x"1234";
    wait for clk_period;
    
    -- Test 3: Write another value
    data_in <= x"ABCD";
    wait for clk_period;

    -- Test 4: Disable write, data should be held
    wr_en <= '0';
    data_in <= x"FFFF"; -- Try to write, but wr_en is low
    wait for clk_period;

    -- Test 5: Write enable again
    wr_en <= '1';
    data_in <= x"5678";
    wait for clk_period;

    -- Test 6: Reset while write is enabled
    rst <= '1';
    data_in <= x"9999";
    wait for clk_period;
    rst <= '0';
    wait for clk_period;

    -- Test 7: Write zero
    wr_en <= '1';
    data_in <= x"0000";
    wait for clk_period;

    -- Test 8: Write max value
    data_in <= x"FFFF";
    wait for clk_period;

    -- Test 9: Disable write and hold value
    wr_en <= '0';
    wait for clk_period * 2;

    -- End simulation
    wait;
  end process;

end architecture;
