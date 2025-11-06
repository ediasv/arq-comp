library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity program_counter_tb is
end entity;

architecture a_program_counter_tb of program_counter_tb is
  component program_counter is
    port (
      clk      : in  std_logic;
      wr_en    : in  std_logic;
      data_in  : in  unsigned(6 downto 0);
      data_out : out unsigned(6 downto 0)
    );
  end component;

  signal clk      : std_logic := '0';
  signal wr_en    : std_logic := '0';
  signal data_in  : unsigned(6 downto 0) := (others => '0');
  signal data_out : unsigned(6 downto 0);
  
  constant period_time : time := 100 ns;
  signal finished : std_logic := '0';

begin
  uut: program_counter port map(
    clk      => clk,
    wr_en    => wr_en,
    data_in  => data_in,
    data_out => data_out
  );

  -- Clock process
  clk_process: process
  begin
    while finished /= '1' loop
      clk <= '0';
      wait for period_time/2;
      clk <= '1';
      wait for period_time/2;
    end loop;
    wait;
  end process;

  -- Stimulus process
  stimulus: process
  begin
    -- Teste 1: Incrementa a partir de 0
    wr_en <= '1';
    data_in <= to_unsigned(0, 7);
    wait for period_time;
    -- Esperado: data_out = 1

    -- Teste 2: Incrementa a partir de 5
    data_in <= to_unsigned(5, 7);
    wait for period_time;
    -- Esperado: data_out = 6

    -- Teste 3: Incrementa a partir de 10
    data_in <= to_unsigned(10, 7);
    wait for period_time;
    -- Esperado: data_out = 11

    -- Teste 4: wr_en desabilitado (mantém valor)
    wr_en <= '0';
    data_in <= to_unsigned(50, 7);
    wait for period_time;
    -- Esperado: data_out = 11 (mantém)

    wait for period_time;
    -- Esperado: data_out = 11 (mantém)

    -- Teste 5: Habilita novamente
    wr_en <= '1';
    data_in <= to_unsigned(20, 7);
    wait for period_time;
    -- Esperado: data_out = 21

    -- Teste 6: Teste de overflow (127 + 1 = 0)
    data_in <= to_unsigned(127, 7);
    wait for period_time;
    -- Esperado: data_out = 0 (overflow)

    -- Teste 7: Incrementa a partir de 126
    data_in <= to_unsigned(126, 7);
    wait for period_time;
    -- Esperado: data_out = 127

    -- Finaliza simulação
    finished <= '1';
    wait;
  end process;

end architecture;