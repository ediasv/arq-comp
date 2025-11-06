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

  stim_process: process
  begin
    -- Test reset functionality
    rst_tb <= '1';
    wait for clk_period * 2;

    rst_tb <= '0';
    wait for clk_period;

    -- Test toggle on each clock cycle
    wait for clk_period;

    wait for clk_period;

    wait for clk_period;

    wait for clk_period;
    --------------------------------

    -- Test reset functionality
    rst_tb <= '1';
    wait for clk_period;

    finished <= true;
    wait;
  end process;

end architecture;
