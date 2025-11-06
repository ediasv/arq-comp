library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity accumulator_reg_tb is
end entity;

architecture a_accumulator_reg_tb of accumulator_reg_tb is
  component accumulator_reg
    port (clk      : in  std_logic;
          rst      : in  std_logic;
          wr_en    : in  std_logic;
          data_in  : in  unsigned(15 downto 0);
          data_out : out unsigned(15 downto 0)
         );
  end component;

  signal clk      : std_logic := '0';
  signal rst      : std_logic := '0';
  signal wr_en    : std_logic := '0';
  signal data_in  : unsigned(15 downto 0) := (others => '0');
  signal data_out : unsigned(15 downto 0);

  constant clk_period : time := 10 ns;
  signal finished     : std_logic := '0';

begin
  -- Instantiate the Unit Under Test (UUT)
  uut: accumulator_reg
    port map (
      clk      => clk,
      rst      => rst,
      wr_en    => wr_en,
      data_in  => data_in,
      data_out => data_out
    );

  -- Clock generation process
  clk_process: process
  begin
    while finished /= '1' loop
      clk <= '0';
      wait for clk_period/2;
      clk <= '1';
      wait for clk_period/2;
    end loop;
    wait;
  end process;

  -- Stimulus process
  stim_process: process
  begin
    -- Test 1: Reset
    report "Test 1: Reset accumulator";
    rst <= '1';
    wait for clk_period;
    rst <= '0';
    wait for clk_period;
    assert data_out = x"0000" report "Reset failed" severity error;

    -- Test 2: First accumulation
    report "Test 2: Add 5 to accumulator";
    wr_en <= '1';
    data_in <= x"0005";
    wait for clk_period * 2.7;
    assert data_out = x"0005" report "First accumulation failed" severity error;

    -- Test 3: Second accumulation
    report "Test 3: Add 10 to accumulator";
    data_in <= x"000A";
    wait for clk_period * 1.9;
    assert data_out = x"000F" report "Second accumulation failed (expected 15)" severity error;

    -- Test 4: Hold value when wr_en is '0'
    report "Test 4: Hold value (wr_en = '0')";
    wr_en <= '0';
    data_in <= x"00FF";
    wait for clk_period * 2.8;
    assert data_out = x"000F" report "Hold failed, value changed" severity error;

    -- Test 5: Resume accumulation
    report "Test 5: Add 1 to accumulator";
    wr_en <= '1';
    data_in <= x"0001";
    wait for clk_period;
    assert data_out = x"0010" report "Resume accumulation failed" severity error;

    -- Test 6: Reset again
    report "Test 6: Reset accumulator again";
    rst <= '1';
    wait for clk_period;
    rst <= '0';
    wait for clk_period;
    assert data_out = x"0000" report "Second reset failed" severity error;

    -- Test 7: Large value accumulation
    report "Test 7: Add large value (1000)";
    wr_en <= '1';
    data_in <= x"03E8";  -- 1000 in hex
    wait for clk_period;
    assert data_out = x"03E8" report "Large value accumulation failed" severity error;

    -- Test 8: Overflow test
    report "Test 8: Test overflow behavior";
    rst <= '1';
    wait for clk_period;
    rst <= '0';
    data_in <= x"FFFF";
    wr_en <= '1';
    wait for clk_period;
    data_in <= x"0001";
    wait for clk_period;
    assert data_out = x"0000" report "Overflow handling failed" severity error;

    report "All tests completed successfully!";
    finished <= '1';
    wait;
  end process;

end architecture;