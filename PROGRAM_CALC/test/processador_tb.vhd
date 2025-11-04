library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity processador_tb is
end entity;

architecture a_processador_tb of processador_tb is

  component processador
    port (
      rst  : in  std_logic;
      clk  : in  std_logic;
      zero : out std_logic;
      sig  : out std_logic
    );
  end component;

  signal clk  : std_logic := '0';
  signal rst  : std_logic := '0';
  signal zero : std_logic;
  signal sig  : std_logic;

  constant clk_period : time := 100 ns;

begin

  -- Clock generation
  clk <= not clk after clk_period / 2;

  -- Instantiate processor
  uut: processador
    port map (
      clk  => clk,
      rst  => rst,
      zero => zero,
      sig  => sig
    );

  -- Test process
  stimulus: process
  begin

    -- Test 2: State progression (00 -> 01 -> 10 -> 00)
    wait for clk_period * 60;

    wait;
  end process;

end architecture;
