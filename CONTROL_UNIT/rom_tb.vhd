library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity rom_tb is
end entity;

architecture a_rom_tb of rom_tb is
  component rom is
    port (clk      : in  std_logic;
          endereco : in  unsigned(6 downto 0);
          dado     : out unsigned(14 downto 0)
         );
  end component;

  signal clk      : std_logic            := '0';
  signal endereco : unsigned(6 downto 0) := (others => '0');
  signal dado     : unsigned(14 downto 0);

  constant period_time : time := 100 ns;
  signal finished : std_logic := '0';

begin
  uut: rom
    port map (
      clk      => clk,
      endereco => endereco,
      dado     => dado
    );

  -- Clock process
  clk_process: process
  begin
    while finished /= '1' loop
      clk <= '0';
      wait for period_time / 2;
      clk <= '1';
      wait for period_time / 2;
    end loop;
    wait;
  end process;

  -- Stimulus process
  stimulus: process
  begin
    -- Testa endereços de 0 a 10 (onde você tem dados)
    for i in 0 to 10 loop
      endereco <= to_unsigned(i, 7);
      wait for period_time;
    end loop;

    -- Testa alguns endereços vazios
    endereco <= to_unsigned(50, 7);
    wait for period_time;

    endereco <= to_unsigned(100, 7);
    wait for period_time;

    endereco <= to_unsigned(127, 7);
    wait for period_time;

    -- Finaliza
    finished <= '1';
    wait;
  end process;

end architecture;
