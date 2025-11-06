library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity state_machine is
  port (clk      : in  std_logic;
        rst      : in  std_logic;
        sm_out   : out std_logic
       );
end entity;

architecture a_state_machine of state_machine is
    signal estado : std_logic := '0';
begin
  process (clk, rst) -- acionado se houver mudança em clk ou rst
  begin
    if rst = '1' then
        estado <= '0';
    elsif rising_edge(clk) then
        estado <= not estado;
    end if;
  end process;

  sm_out <= estado;
end architecture;
