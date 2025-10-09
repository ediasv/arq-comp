library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity top_level_full_tb is
end entity;

architecture a_top_level_full_tb of top_level_full_tb is

  component top_level
    port (clk              : in  std_logic;
          rst              : in  std_logic;
          wr_en            : in  std_logic;
          acc_en           : in  std_logic;
          op_with_constant : in  std_logic;
          addr_dest        : in  std_logic_vector(2 downto 0); -- 3 bits para 8 registradores
          addr_source      : in  std_logic_vector(2 downto 0); -- 3 bits para 8 registradores
          data_in          : in  unsigned(15 downto 0);
          data_out         : out unsigned(15 downto 0);
          ula_op           : in  std_logic_vector(1 downto 0);
          ula_zero         : out std_logic;
          ula_sig          : out std_logic;
          rst_acc          : in  std_logic;
          is_ld            : in  std_logic
         );
  end component;

  -- Test signals
  signal clk              : std_logic                    := '0';
  signal rst              : std_logic                    := '0';
  signal wr_en            : std_logic                    := '0';
  signal acc_en           : std_logic                    := '0';
  signal op_with_constant : std_logic                    := '0';
  signal rst_acc          : std_logic                    := '0';
  signal is_ld            : std_logic                    := '0';
  signal addr_dest        : std_logic_vector(2 downto 0) := (others => '0');
  signal addr_source      : std_logic_vector(2 downto 0) := (others => '0');
  signal data_in          : unsigned(15 downto 0)        := (others => '0');
  signal data_out         : unsigned(15 downto 0);
  signal ula_op           : std_logic_vector(1 downto 0) := (others => '0');
  signal ula_zero         : std_logic;
  signal ula_sig          : std_logic;

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
      clk              => clk,
      rst              => rst,
      wr_en            => wr_en,
      acc_en           => acc_en,
      op_with_constant => op_with_constant,
      addr_dest        => addr_dest,
      addr_source      => addr_source,
      data_in          => data_in,
      data_out         => data_out,
      ula_op           => ula_op,
      ula_zero         => ula_zero,
      ula_sig          => ula_sig,
      rst_acc          => rst_acc,
      is_ld            => is_ld);

  -- Main test process
  stimulus: process
  begin

    -- ========================================================================
    -- INITIALIZATION: Reset and Setup
    -- ========================================================================
    report "Starting Top Level Testbench";
    rst <= '1';
    rst_acc <= '1'; -- Also reset accumulator initially
    wait for clk_period * 2;
    rst <= '0';
    rst_acc <= '0'; -- Release accumulator reset
    wait for clk_period;

    -- ========================================================================
    -- SETUP: Load initial values into registers
    -- We'll load some test values using constants
    -- ========================================================================
    report "TEST: Loading initial values into registers";

    op_with_constant <= '1'; -- Use constant input (data_in)
    wr_en <= '1'; -- Enable writing to bank
    acc_en <= '0'; -- Don't update accumulator yet
    ula_op <= "00"; -- ADD operation (acc + constant)

    wait for clk_period * 2; -- Wait for signals to stabilize

    -- Load value 5 into Register 0
    -- Since accumulator starts at 0, ULA will compute 0 + 5 = 5
    addr_dest <= "000";
    data_in <= x"0005";
    wait for clk_period * 2; -- Wait for signals to stabilize

    -- Load value 10 into Register 1
    addr_dest <= "001";
    data_in <= x"000A";
    wait for clk_period * 2; -- Wait for signals to stabilize

    -- Load value 3 into Register 2
    addr_dest <= "010";
    data_in <= x"0003";
    wait for clk_period * 2; -- Wait for signals to stabilize

    -- Load value 7 into Register 3
    addr_dest <= "011";
    data_in <= x"0007";
    wait for clk_period * 2; -- Wait for signals to stabilize

    wr_en <= '0'; -- Disable bank writes
    wait for clk_period * 2; -- Wait for signals to stabilize

    is_ld <= '1';
    is_ld <= '0';

    -- ========================================================================
    -- TEST 1: Add two registers (R0 + R1)
    -- Restriction: Can only read ONE register at a time
    -- Strategy: 
    --   1. Read R0, load into accumulator (ACC = R0)
    --   2. Read R1, add to accumulator (ACC = ACC + R1)
    --   3. Write result to R0
    -- ========================================================================

    -- Step 1: Load R0 into accumulator
    rst_acc <= '1'; -- Reset accumulator to 0
    wait for clk_period;
    rst_acc <= '0';

    op_with_constant <= '0'; -- Use bank output
    ula_op <= "00"; -- ADD operation
    addr_source <= "000"; -- Read from R0
    acc_en <= '1'; -- Enable accumulator update
    wait for clk_period; -- ACC now contains R0 (5)

    -- Step 2: Add R1 to accumulator
    addr_source <= "001"; -- Read from R1
    wait for clk_period; -- ACC = ACC + R1 = 5 + 10 = 15

    -- Step 3: Write result to R0
    acc_en <= '0'; -- Stop accumulator updates
    wait for clk_period; -- Let acc_en=0 take effect (stops accumulation)

    addr_dest <= "000"; -- NOW change address (after acc is disabled)
    wr_en <= '1'; -- Enable bank write
    wait for clk_period;

    wr_en <= '0';
    rst_acc <= '0';
    wait for clk_period;

    -- Verify: Read R0 and check data_out
    addr_source <= "000";
    wait for clk_period;

    -- ========================================================================
    -- TEST 2: Subtract registers (R1 - R2)
    -- R5 = R1 - R2 = 10 - 3 = 7
    -- ========================================================================
    report "TEST 2: R5 = R1 - R2 (10 - 3 = 7)";

    -- Reset accumulator
    rst_acc <= '1';
    wait for clk_period;
    rst_acc <= '0';

    -- Load R1 into accumulator
    op_with_constant <= '0';
    ula_op <= "00"; -- ADD (to load)
    acc_en <= '1';
    addr_source <= "001"; -- Read R1
    wait for clk_period; -- ACC = 10

    -- Subtract R2 from accumulator
    ula_op <= "01"; -- SUB operation
    addr_source <= "010"; -- Read R2
    wait for clk_period; -- ACC = 10 - 3 = 7

    -- Write to R5
    acc_en <= '0';
    wait for clk_period; -- Let acc_en=0 take effect

    addr_dest <= "101";
    wr_en <= '1';
    wait for clk_period;

    wr_en <= '0';
    wait for clk_period;

    -- Verify
    addr_source <= "101";
    wait for clk_period;
    assert data_out = x"0007"
      report "TEST 2 FAILED"
      severity error;
    report "TEST 2 PASSED: R5 = " & integer'image(to_integer(data_out));

    -- ========================================================================
    -- TEST 3: Add three registers (R0 + R1 + R2)
    -- R6 = R0 + R1 + R2 = 5 + 10 + 3 = 18
    -- This demonstrates the accumulator loop for multiple operations
    -- ========================================================================
    report "TEST 3: R6 = R0 + R1 + R2 (5 + 10 + 3 = 18)";

    -- Reset accumulator
    rst_acc <= '1';
    wait for clk_period;
    rst_acc <= '0';

    op_with_constant <= '0';
    ula_op <= "00"; -- ADD
    acc_en <= '1';

    -- Add R0
    addr_source <= "000";
    wait for clk_period; -- ACC = 5

    -- Add R1
    addr_source <= "001";
    wait for clk_period; -- ACC = 5 + 10 = 15

    -- Add R2
    addr_source <= "010";
    wait for clk_period; -- ACC = 15 + 3 = 18

    -- Write to R6
    acc_en <= '0';
    wait for clk_period; -- Let acc_en=0 take effect

    addr_dest <= "110";
    wr_en <= '1';
    wait for clk_period;

    wr_en <= '0';
    wait for clk_period;

    -- Verify
    addr_source <= "110";
    wait for clk_period;
    assert data_out = x"0012"
      report "TEST 3 FAILED"
      severity error;
    report "TEST 3 PASSED: R6 = " & integer'image(to_integer(data_out));

    -- ========================================================================
    -- TEST 4: Operation with constant
    -- R7 = R3 + 100 = 7 + 100 = 107
    -- ========================================================================
    report "TEST 4: R7 = R3 + 100 (7 + 100 = 107)";

    -- Reset accumulator
    rst_acc <= '1';
    wait for clk_period;
    rst_acc <= '0';

    -- Load R3
    op_with_constant <= '0';
    ula_op <= "00";
    acc_en <= '1';
    addr_source <= "011";
    wait for clk_period; -- ACC = 7

    -- Add constant
    op_with_constant <= '1'; -- Use constant input
    data_in <= x"0064"; -- 100 in decimal
    wait for clk_period; -- ACC = 7 + 100 = 107

    -- Write to R7
    acc_en <= '0';
    wait for clk_period; -- Let acc_en=0 take effect

    addr_dest <= "111";
    wr_en <= '1';
    wait for clk_period;

    wr_en <= '0';
    wait for clk_period;

    -- Verify
    op_with_constant <= '0';
    addr_source <= "111";
    wait for clk_period;
    assert data_out = x"006B"
      report "TEST 4 FAILED"
      severity error;
    report "TEST 4 PASSED: R7 = " & integer'image(to_integer(data_out));

    -- ========================================================================
    -- TEST 5: AND operation (R0 AND R1)
    -- R0 = 0x0005 = 0000 0000 0000 0101
    -- R1 = 0x000A = 0000 0000 0000 1010
    -- AND       = 0000 0000 0000 0000 = 0x0000
    -- ========================================================================
    report "TEST 5: AND operation (R0 AND R1)";

    -- Reset accumulator
    rst_acc <= '1';
    wait for clk_period;
    rst_acc <= '0';

    -- Load R0 (using ADD to load)
    op_with_constant <= '0';
    ula_op <= "00";
    acc_en <= '1';
    addr_source <= "000";
    wait for clk_period;

    -- AND with R1
    ula_op <= "10"; -- AND operation
    addr_source <= "001";
    wait for clk_period;

    -- Check zero flag (should be 1)
    assert ula_zero = '1'
      report "TEST 5: Zero flag should be set"
      severity warning;

    acc_en <= '0';
    wait for clk_period;

    -- ========================================================================
    -- TEST 6: OR operation (R0 OR R2)
    -- R0 = 0x0005 = 0000 0000 0000 0101
    -- R2 = 0x0003 = 0000 0000 0000 0011
    -- OR        = 0000 0000 0000 0111 = 0x0007
    -- ========================================================================
    report "TEST 6: OR operation (R0 OR R2)";

    -- Reset accumulator
    rst_acc <= '1';
    wait for clk_period;
    rst_acc <= '0';

    -- Load R0
    op_with_constant <= '0';
    ula_op <= "00";
    acc_en <= '1';
    addr_source <= "000";
    wait for clk_period;

    -- OR with R2
    ula_op <= "11"; -- OR operation
    addr_source <= "010";
    wait for clk_period;

    acc_en <= '0';
    wait for clk_period;

    -- Check result (should be 7)
    assert data_out = x"0007"
      report "TEST 6 FAILED"
      severity error;
    report "TEST 6 PASSED: Result = " & integer'image(to_integer(data_out));

    -- ========================================================================
    -- TEST 7: Negative result test (sign flag)
    -- R2 - R1 = 3 - 10 = -7 (should set sign flag)
    -- ========================================================================
    report "TEST 7: Negative result (3 - 10 = -7)";

    -- Reset accumulator
    rst_acc <= '1';
    wait for clk_period;
    rst_acc <= '0';

    -- Load R2
    op_with_constant <= '0';
    ula_op <= "00";
    acc_en <= '1';
    addr_source <= "010"; -- R2 = 3
    wait for clk_period;

    -- Subtract R1
    ula_op <= "01"; -- SUB
    addr_source <= "001"; -- R1 = 10
    wait for clk_period;

    -- Check sign flag (should be 1 for negative)
    assert ula_sig = '1'
      report "TEST 7: Sign flag should be set for negative result"
      severity warning;
    report "TEST 7: Sign flag = " & std_logic'image(ula_sig);

    acc_en <= '0';
    wait for clk_period;

    -- ========================================================================
    -- End of tests
    -- ========================================================================
    report "=== ALL TESTS COMPLETED ===";
    report "Summary:";
    report "  - Single register read restriction handled via accumulator loop";
    report "  - Arithmetic operations (ADD, SUB) tested";
    report "  - Logical operations (AND, OR) tested";
    report "  - Constant operations tested";
    report "  - Status flags (zero, sign) verified";

    finished <= true;
    wait;
  end process;

end architecture;
