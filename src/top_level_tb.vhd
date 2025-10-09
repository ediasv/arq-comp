library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity top_level_tb is
end entity;

architecture behavior of top_level_tb is

  component top_level
    port (clk              : in  std_logic;
          rst              : in  std_logic;
          wr_en            : in  std_logic;
          acc_en           : in  std_logic;
          op_with_constant : in  std_logic;
          addr_wr          : in  std_logic_vector(2 downto 0); -- 3 bits para 8 registradores
          data_in          : in  unsigned(15 downto 0);
          data_out         : out unsigned(15 downto 0);
          ula_op           : in  std_logic_vector(1 downto 0);
          ula_zero         : out std_logic;
          ula_sig          : out std_logic
         );
  end component;

  signal clk : std_logic := '0';
  signal rst : std_logic := '0';
  signal wr_en : std_logic := '0';
  signal acc_en : std_logic := '0';
  signal op_with_constant : std_logic := '0';
  signal addr_wr : std_logic_vector(2 downto 0) := (others => '0');
  signal data_in : unsigned(15 downto 0) := (others => '0');
  signal data_out : unsigned(15 downto 0);
  signal ula_op : std_logic_vector(1 downto 0) := (others => '0');
  signal ula_zero : std_logic;
  signal ula_sig : std_logic;

  constant clk_period : time := 100 ns;

begin

  uut: top_level
    port map (
      clk              => clk,
      rst              => rst,
      wr_en            => wr_en,
      acc_en           => acc_en,
      op_with_constant => op_with_constant,
      addr_wr          => addr_wr,
      data_in          => data_in,
      data_out         => data_out,
      ula_op           => ula_op,
      ula_zero         => ula_zero,
      ula_sig          => ula_sig
    );

  clk_process: process
  begin
    clk <= '0';
    wait for clk_period / 2;
    clk <= '1';
    wait for clk_period / 2;
  end process;

  stimulus_process: process
  begin
    rst <= '1';
    wait for 20 ns;
    rst <= '0';

    -- soma de dois regs (R0 + R1)
    wait for clk_period;
    acc_en <= '1';
    ula_op <= "00"; -- ADD
    addr_wr <= "000"; -- Registrador 0
    wait for clk_period;
    addr_wr <= "001"; -- Registrador 1
    wait for clk_period;
    acc_en <= '0';
    wr_en <= '1';
    wait for clk_period;

    -- teste LD

    -- subtracao de dois regs

    -- subtracao com constante


    wait;
  end process;
end architecture;
