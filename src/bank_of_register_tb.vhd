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

  signal clk      : std_logic                    := '0';
  signal rst      : std_logic                    := '1';
  signal wr_en    : std_logic                    := '0';
  signal addr_wr  : std_logic_vector(2 downto 0) := (others => '0');
  signal data_in  : unsigned(15 downto 0)        := (others => '0');
  signal data_out : unsigned(15 downto 0);

  constant clk_period : time := 100 ns;

begin

  process -- sinal de clock
  begin
    clk <= '0';
    wait for 50 ns;
    clk <= '1';
    wait for 50 ns;
  end process;

  process -- sinal de reset
  begin
    rst <= '1';
    wait for 100 ns;
    rst <= '0';
    wait;
  end process;

  bank_inst: bank_of_registers
    port map (
      clk      => clk,
      rst      => rst,
      wr_en    => wr_en,
      addr_wr  => addr_wr,
      data_in  => data_in,
      data_out => data_out
    );

  process
  begin
    --------------------------------------------------------
    wait for clk_period * 2;
    wr_en <= '1';
    addr_wr <= "000"; -- Registrador 0
    data_in <= x"0001"; -- Dado 1
    wait for clk_period * 2;

    addr_wr <= "001"; -- Registrador 1
    data_in <= x"0002"; -- Dado 2
    wait for clk_period * 2;

    addr_wr <= "010"; -- Registrador 2
    data_in <= x"0003"; -- Dado 3
    wait for clk_period * 2;

    addr_wr <= "011"; -- Registrador 3
    data_in <= x"0004"; -- Dado 4
    wait for clk_period * 2;

    addr_wr <= "100"; -- Registrador 4
    data_in <= x"0005"; -- Dado 5
    wait for clk_period * 2;

    addr_wr <= "101"; -- Registrador 5
    data_in <= x"0006"; -- Dado 6
    wait for clk_period * 2;

    addr_wr <= "110"; -- Registrador 6
    data_in <= x"0007"; -- Dado 7
    wait for clk_period * 2;

    addr_wr <= "111"; -- Registrador 7
    data_in <= x"0008"; -- Dado 8
    wait for clk_period * 2;

    wr_en <= '0'; -- Desabilita escrita

    addr_wr <= "000"; -- Lê do Registrador 0
    wait for clk_period * 2;

    addr_wr <= "001"; -- Lê do Registrador 1
    wait for clk_period * 2;

    addr_wr <= "010"; -- Lê do Registrador 2
    wait for clk_period * 2;

    addr_wr <= "011"; -- Lê do Registrador 3
    wait for clk_period * 2;

    addr_wr <= "100"; -- Lê do Registrador 4
    wait for clk_period * 2;

    addr_wr <= "101"; -- Lê do Registrador 5
    wait for clk_period * 2;

    addr_wr <= "110"; -- Lê do Registrador 6
    wait for clk_period * 2;

    addr_wr <= "111"; -- Lê do Registrador 7
    wait for clk_period * 2;

    wait;
  end process;

end architecture;
