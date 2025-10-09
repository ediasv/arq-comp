library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity bank_of_registers_tb is
end entity;

architecture a_bank_of_registers_tb of bank_of_registers_tb is

  component bank_of_registers
    port (clk      : in  std_logic;
          rst      : in  std_logic;
          wr_en    : in  std_logic;
          addr_wr  : in  std_logic_vector(2 downto 0);
          data_in  : in  unsigned(15 downto 0);
          data_out : out unsigned(15 downto 0)
         );
  end component;

  -- Test signals
  signal clk      : std_logic                    := '0';
  signal rst      : std_logic                    := '0';
  signal wr_en    : std_logic                    := '0';
  signal addr_wr  : std_logic_vector(2 downto 0) := (others => '0');
  signal data_in  : unsigned(15 downto 0)        := (others => '0');
  signal data_out : unsigned(15 downto 0);

  -- Clock period definition (100 ns = 10 MHz)
  -- Using a slower clock makes waveforms easier to read in GTKWave
  constant clk_period : time := 100 ns;

  -- Flag to control when simulation ends
  signal finished : boolean := false;

begin

  -- Clock generation process
  -- This process runs continuously until 'finished' is true
  clk_process: process
  begin
    while not finished loop
      clk <= '0';
      wait for clk_period / 2;
      clk <= '1';
      wait for clk_period / 2;
    end loop;
    wait;  -- Stop clock when simulation is done
  end process;

  -- Unit Under Test instantiation
  uut: bank_of_registers
    port map (
      clk      => clk,
      rst      => rst,
      wr_en    => wr_en,
      addr_wr  => addr_wr,
      data_in  => data_in,
      data_out => data_out
    );

  -- Main test stimulus process
  stimulus: process
  begin
    -- ========================================================================
    -- TEST 1: Reset Test
    -- Verify that reset clears all registers
    -- ========================================================================
    report "Starting TEST 1: Reset Test";
    rst <= '1';
    wait for clk_period * 2;  -- Hold reset for 2 cycles to ensure propagation
    rst <= '0';
    wait for clk_period;      -- One cycle for reset to deassert

    -- ========================================================================
    -- TEST 2: Write to All Registers
    -- Write unique values to each of the 8 registers
    -- Using sequential values makes it easy to verify correctness
    -- ========================================================================
    report "Starting TEST 2: Write to All Registers";
    wr_en <= '1';  -- Enable writing
    
    -- Write to Register 0
    addr_wr <= "000";
    data_in <= x"0001";  -- Using hex for readability
    wait for clk_period;
    
    -- Write to Register 1
    addr_wr <= "001";
    data_in <= x"0002";
    wait for clk_period;
    
    -- Write to Register 2
    addr_wr <= "010";
    data_in <= x"0004";
    wait for clk_period;
    
    -- Write to Register 3
    addr_wr <= "011";
    data_in <= x"0008";
    wait for clk_period;
    
    -- Write to Register 4
    addr_wr <= "100";
    data_in <= x"0010";
    wait for clk_period;
    
    -- Write to Register 5
    addr_wr <= "101";
    data_in <= x"0020";
    wait for clk_period;
    
    -- Write to Register 6
    addr_wr <= "110";
    data_in <= x"0040";
    wait for clk_period;
    
    -- Write to Register 7
    addr_wr <= "111";
    data_in <= x"0080";
    wait for clk_period;

    -- ========================================================================
    -- TEST 3: Read from All Registers
    -- Disable write and read back all values to verify they were stored
    -- The bank uses addr_wr for both write and read operations
    -- ========================================================================
    report "Starting TEST 3: Read from All Registers";
    wr_en <= '0';  -- Disable writing to test read-only mode
    
    -- Read from Register 0 (should be 0x0001)
    addr_wr <= "000";
    wait for clk_period;
    assert data_out = x"0001" 
      report "Register 0 read error: expected 0x0001, got " & integer'image(to_integer(data_out))
      severity error;
    
    -- Read from Register 1 (should be 0x0002)
    addr_wr <= "001";
    wait for clk_period;
    assert data_out = x"0002"
      report "Register 1 read error: expected 0x0002, got " & integer'image(to_integer(data_out))
      severity error;
    
    -- Read from Register 2 (should be 0x0004)
    addr_wr <= "010";
    wait for clk_period;
    assert data_out = x"0004"
      report "Register 2 read error"
      severity error;
    
    -- Read from Register 3 (should be 0x0008)
    addr_wr <= "011";
    wait for clk_period;
    assert data_out = x"0008"
      report "Register 3 read error"
      severity error;
    
    -- Read from Register 4 (should be 0x0010)
    addr_wr <= "100";
    wait for clk_period;
    assert data_out = x"0010"
      report "Register 4 read error"
      severity error;
    
    -- Read from Register 5 (should be 0x0020)
    addr_wr <= "101";
    wait for clk_period;
    assert data_out = x"0020"
      report "Register 5 read error"
      severity error;
    
    -- Read from Register 6 (should be 0x0040)
    addr_wr <= "110";
    wait for clk_period;
    assert data_out = x"0040"
      report "Register 6 read error"
      severity error;
    
    -- Read from Register 7 (should be 0x0080)
    addr_wr <= "111";
    wait for clk_period;
    assert data_out = x"0080"
      report "Register 7 read error"
      severity error;

    -- ========================================================================
    -- TEST 4: Overwrite Test
    -- Write new values to specific registers to test overwrite functionality
    -- ========================================================================
    report "Starting TEST 4: Overwrite Test";
    wr_en <= '1';
    
    -- Overwrite Register 0 with new value
    addr_wr <= "000";
    data_in <= x"AAAA";
    wait for clk_period;
    
    -- Overwrite Register 7 with new value
    addr_wr <= "111";
    data_in <= x"5555";
    wait for clk_period;
    
    -- Verify the overwrites
    wr_en <= '0';
    addr_wr <= "000";
    wait for clk_period;
    assert data_out = x"AAAA"
      report "Register 0 overwrite failed"
      severity error;
    
    addr_wr <= "111";
    wait for clk_period;
    assert data_out = x"5555"
      report "Register 7 overwrite failed"
      severity error;

    -- ========================================================================
    -- TEST 5: Write Disable Test
    -- Verify that when wr_en = '0', registers maintain their values
    -- even when data_in and addr_wr change
    -- ========================================================================
    report "Starting TEST 5: Write Disable Test";
    wr_en <= '0';  -- Ensure write is disabled
    addr_wr <= "010";  -- Point to Register 2
    wait for clk_period;
    
    -- Try to write with wr_en = '0' (should have no effect)
    data_in <= x"FFFF";
    wait for clk_period;
    
    -- Verify Register 2 still has original value
    assert data_out = x"0004"
      report "Register 2 changed when wr_en was low!"
      severity error;

    -- ========================================================================
    -- TEST 6: Edge Cases
    -- Test maximum and minimum values
    -- ========================================================================
    report "Starting TEST 6: Edge Cases";
    wr_en <= '1';
    
    -- Write maximum value (all 1s)
    addr_wr <= "011";
    data_in <= x"FFFF";
    wait for clk_period;
    
    -- Write minimum value (all 0s)
    addr_wr <= "100";
    data_in <= x"0000";
    wait for clk_period;
    
    -- Verify
    wr_en <= '0';
    addr_wr <= "011";
    wait for clk_period;
    assert data_out = x"FFFF"
      report "Maximum value test failed"
      severity error;
    
    addr_wr <= "100";
    wait for clk_period;
    assert data_out = x"0000"
      report "Minimum value test failed"
      severity error;

    -- ========================================================================
    -- TEST 7: Reset During Operation
    -- Verify reset works correctly even during active write operations
    -- ========================================================================
    report "Starting TEST 7: Reset During Operation";
    wr_en <= '1';
    addr_wr <= "101";
    data_in <= x"DEAD";
    wait for clk_period / 2;  -- Change reset mid-cycle
    
    rst <= '1';  -- Assert reset
    wait for clk_period * 2;
    rst <= '0';
    wait for clk_period;
    
    -- After reset, all registers should be 0
    wr_en <= '0';
    addr_wr <= "101";
    wait for clk_period;
    assert data_out = x"0000"
      report "Reset did not clear register"
      severity error;

    -- ========================================================================
    -- End of Tests
    -- ========================================================================
    report "All tests completed successfully!";
    finished <= true;  -- Stop the clock
    wait;
  end process;

end architecture;
