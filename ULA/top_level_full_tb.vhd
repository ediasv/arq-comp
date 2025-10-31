library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity top_level_full_tb is
end entity;

architecture a_top_level_full_tb of top_level_full_tb is

  component top_level
    port (
      -- Clock and Reset
      clk              : in  std_logic;
      rst              : in  std_logic;
      rst_acc          : in  std_logic;
      
      -- Control Signals
      wr_en            : in  std_logic;
      acc_en           : in  std_logic;
      op_with_constant : in  std_logic;
      
      -- Address Buses
      addr_dest        : in  std_logic_vector(2 downto 0);
      addr_source      : in  std_logic_vector(2 downto 0);
      
      -- Data Buses
      data_in          : in  unsigned(15 downto 0);
      const_in         : in  unsigned(15 downto 0);
      data_out         : out unsigned(15 downto 0);
      
      -- ULA Control and Flags
      ula_op           : in  std_logic_vector(1 downto 0);
      ula_zero         : out std_logic;
      ula_sig          : out std_logic;
      
      -- Multiplexer Control
      sel_bank_in      : in  std_logic_vector(1 downto 0)
    );
  end component;

  -- Test signals
  -- Clock and Reset
  signal clk              : std_logic                    := '0';
  signal rst              : std_logic                    := '0';
  signal rst_acc          : std_logic                    := '0';
  
  -- Control Signals
  signal wr_en            : std_logic                    := '0';
  signal acc_en           : std_logic                    := '0';
  signal op_with_constant : std_logic                    := '0';
  
  -- Address Buses
  signal addr_dest        : std_logic_vector(2 downto 0) := (others => '0');
  signal addr_source      : std_logic_vector(2 downto 0) := (others => '0');
  
  -- Data Buses
  signal data_in          : unsigned(15 downto 0)        := (others => '0');
  signal const_in         : unsigned(15 downto 0)        := (others => '0');
  signal data_out         : unsigned(15 downto 0);
  
  -- ULA Control and Flags
  signal ula_op           : std_logic_vector(1 downto 0) := (others => '0');
  signal ula_zero         : std_logic;
  signal ula_sig          : std_logic;
  
  -- Multiplexer Control
  signal sel_bank_in      : std_logic_vector(1 downto 0) := (others => '0');

  -- Constants and helper signals
  constant clk_period : time := 100 ns;
  signal finished : boolean := false;

begin

  -- Clock generation
  clk_process: process
  begin
    while not finished loop
      clk <= '0';
      wait for clk_period / 2;
      clk <= '1';
      wait for clk_period / 2;
    end loop;
    wait;
  end process;

  -- Unit Under Test
  uut: top_level
    port map (
      -- Clock and Reset
      clk              => clk,
      rst              => rst,
      rst_acc          => rst_acc,
      
      -- Control Signals
      wr_en            => wr_en,
      acc_en           => acc_en,
      op_with_constant => op_with_constant,
      
      -- Address Buses
      addr_dest        => addr_dest,
      addr_source      => addr_source,
      
      -- Data Buses
      data_in          => data_in,
      const_in         => const_in,
      data_out         => data_out,
      
      -- ULA Control and Flags
      ula_op           => ula_op,
      ula_zero         => ula_zero,
      ula_sig          => ula_sig,
      
      -- Multiplexer Control
      sel_bank_in      => sel_bank_in
    );

  -- Main test process
  stimulus: process
  begin
    rst <= '1';
    rst_acc <= '1';
    wait for clk_period;
    rst <= '0';
    rst_acc <= '0';
    wait for clk_period;

    
    acc_en <= '0';
    op_with_constant <= '0';
    ula_op <= "00";
    
    -- Load test values into registers R0-R3
    -- Load R0 = 5
    sel_bank_in <= "01"; -- Select data_in
    wr_en <= '1';
    addr_dest <= "000";
    data_in <= x"0005";
    wait for clk_period;
    wr_en <= '0';
    
    -- Load R1 = 10
    wr_en <= '1';
    addr_dest <= "001";
    data_in <= x"000A";
    wait for clk_period;
    wr_en <= '0';
    
    -- Load R2 = 3
    wr_en <= '1';
    addr_dest <= "010";
    data_in <= x"0003";
    wait for clk_period;
    wr_en <= '0';
    
    -- Load R3 = 7
    wr_en <= '1';
    addr_dest <= "011";
    data_in <= x"0007";
    wait for clk_period;
    wr_en <= '0';
    
    -- Set normal operation mode
    sel_bank_in <= "10"; -- Select ULA output for bank input
    wait for clk_period;

    -- ========================================================================
    -- TEST 1: Register Addition (R0 + R1 -> R0)
    -- Expected: 5 + 10 = 15 (0x000F)
    -- ========================================================================
    report "TEST 1: Register Addition (R0 + R1 -> R0)";
    
    -- Reset accumulator
    rst_acc <= '1';
    wait for clk_period;
    rst_acc <= '0';
    
    -- Load R0 into accumulator
    op_with_constant <= '0';
    ula_op <= "00"; -- ADD
    acc_en <= '1';
    addr_source <= "000"; -- R0
    wait for clk_period;
    
    -- Add R1 to accumulator
    addr_source <= "001"; -- R1
    wait for clk_period;
    -- Store result in R0
    acc_en <= '0';
    wr_en <= '1';
    addr_dest <= "000"; -- R0
    wait for clk_period;
    wr_en <= '0';
    
    -- Verify result
    addr_source <= "000";
    wait for clk_period;

    -- ========================================================================
    -- TEST 2: Register Subtraction (R1 - R2 -> R1) 
    -- Expected: 10 - 3 = 7 (0x0007)
    -- ========================================================================
    report "TEST 2: Register Subtraction (R1 - R2 -> R1)";
    
    -- Reset accumulator
    rst_acc <= '1';
    wait for clk_period;
    rst_acc <= '0';
    
    -- Load R1 into accumulator
    ula_op <= "00"; -- ADD for loading
    acc_en <= '1';
    addr_source <= "001"; -- R1
    wait for clk_period;
    
    -- Subtract R2 from accumulator
    ula_op <= "01"; -- SUB
    addr_source <= "010"; -- R2
    wait for clk_period;
    
    -- Store result in R1
    acc_en <= '0';
    wr_en <= '1';
    addr_dest <= "001"; -- R1
    wait for clk_period;
    wr_en <= '0';
    
    -- Verify result
    addr_source <= "001";
    wait for clk_period;

    -- ========================================================================
    -- TEST 3: Constant Subtraction (R3 - 100 -> R3)
    -- Expected: 7 - 100 = -93 (0xFFA5)
    -- ========================================================================
    report "TEST 3: Constant Subtraction (R3 - 100 -> R3)";

    -- Reset accumulator
    rst_acc <= '1';
    wait for clk_period;
    rst_acc <= '0';
    
    -- Load R3 into accumulator
    op_with_constant <= '0';
    ula_op <= "00"; -- ADD
    acc_en <= '1';
    addr_source <= "011"; -- R3
    wait for clk_period;
    
    -- Add constant 100
    op_with_constant <= '1';
    const_in <= x"0064"; -- 100 decimal
    ula_op <= "01"; -- ADD
    wait for clk_period;
    
    -- Store result in R3
    acc_en <= '0';
    wr_en <= '1';
    addr_dest <= "011"; -- R3
    wait for clk_period;
    wr_en <= '0';
    
    -- Verify result
    op_with_constant <= '0';
    addr_source <= "110";
    wait for clk_period;

    -- ========================================================================
    -- TEST 4: Logical AND Operation (R0 AND R1 -> R7)
    -- Expected: 0x0005 AND 0x000A = 0x0000
    -- ========================================================================
    report "TEST 4: Logical AND Operation (R0 AND R1 -> R7)";
    
    -- Reset accumulator
    rst_acc <= '1';
    wait for clk_period;
    rst_acc <= '0';
    
    -- Load R0 into accumulator
    ula_op <= "00"; -- ADD for loading
    acc_en <= '1';
    addr_source <= "000"; -- R0
    wait for clk_period;
    
    -- AND with R1
    ula_op <= "10"; -- AND
    addr_source <= "001"; -- R1
    wait for clk_period;
    
    -- Store result in R7
    acc_en <= '0';
    wr_en <= '1';
    addr_dest <= "111"; -- R7
    wait for clk_period;
    wr_en <= '0';
    
    -- Verify result and zero flag
    addr_source <= "111";
    wait for clk_period;

    -- ========================================================================
    -- TEST 5: Logical OR Operation and Sign Flag Test
    -- ========================================================================
    report "TEST 5: Logical OR Operation (R0 OR R2)";
    
    -- Reset accumulator
    rst_acc <= '1';
    wait for clk_period;
    rst_acc <= '0';
    
    -- Load R0 into accumulator
    ula_op <= "00"; -- ADD for loading
    acc_en <= '1';
    addr_source <= "000"; -- R0
    wait for clk_period;
    
    -- OR with R2
    ula_op <= "11"; -- OR
    addr_source <= "010"; -- R2
    wait for clk_period;
    
    acc_en <= '0';
    wait for clk_period;
    
    -- ========================================================================
    -- TEST 6: Sign Flag Test (R2 - R1)
    -- Expected: 3 - 10 = -7 (negative result)
    -- ========================================================================
    report "TEST 6: Sign Flag Test (R2 - R1)";
    
    -- Reset accumulator
    rst_acc <= '1';
    wait for clk_period;
    rst_acc <= '0';
    
    -- Load R2 into accumulator
    ula_op <= "00"; -- ADD for loading
    acc_en <= '1';
    addr_source <= "010"; -- R2 = 3
    wait for clk_period;
    
    -- Subtract R1
    ula_op <= "01"; -- SUB
    addr_source <= "001"; -- R1 = 10
    wait for clk_period;
    
    acc_en <= '0';
    wait for clk_period;
    
    finished <= true;
    wait;
  end process;

end architecture;
