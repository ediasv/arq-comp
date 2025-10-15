library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity state_machine_tb is
end entity;

architecture a_state_machine_tb of state_machine_tb is
  component state_machine is
    port (clk      : in  std_logic;
          rst      : in  std_logic;
          sm_out   : out std_logic
         );
  end component;

  signal clk_tb    : std_logic := '0';
  signal rst_tb    : std_logic := '0';
  signal sm_out_tb : std_logic;

  constant clk_period : time := 10 ns;
  signal finished : boolean := false;

begin
  uut: state_machine
    port map (
      clk    => clk_tb,
      rst    => rst_tb,
      sm_out => sm_out_tb
    );

  -- Clock generation
  clk_process: process
  begin
    while not finished loop
      clk_tb <= '0';
      wait for clk_period/2;
      clk_tb <= '1';
      wait for clk_period/2;
    end loop;
    wait;
  end process;

  -- Stimulus process
  stim_process: process
  begin
    -- Test reset functionality
    rst_tb <= '1';
    wait for clk_period * 2;
    assert sm_out_tb = '0' report "Reset failed: sm_out should be '0'" severity error;

    rst_tb <= '0';
    wait for clk_period;

    -- Test toggle on each clock cycle
    wait for clk_period;
    assert sm_out_tb = '1' report "Toggle failed: sm_out should be '1' after first clock" severity error;

    wait for clk_period;
    assert sm_out_tb = '0' report "Toggle failed: sm_out should be '0' after second clock" severity error;

    wait for clk_period;
    assert sm_out_tb = '1' report "Toggle failed: sm_out should be '1' after third clock" severity error;

    wait for clk_period;
    assert sm_out_tb = '0' report "Toggle failed: sm_out should be '0' after fourth clock" severity error;

    rst_tb <= '1';
    wait for clk_period;
    assert sm_out_tb = '0' report "Reset during operation failed: sm_out should be '0'" severity error;

    report "Testbench completed successfully" severity note;
    finished <= true;
    wait;
  end process;

end architecture;
