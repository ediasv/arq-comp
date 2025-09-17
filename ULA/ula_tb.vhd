library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end entity;

architecture a_ula_tb of ula_tb is
  component ula
    port (
      in0, in1 : in  unsigned(15 downto 0);
      op       : in  unsigned(1 downto 0);
      ula_out  : out unsigned(15 downto 0)
    );
  end component;

  signal in0, in1 : unsigned(15 downto 0);
  signal op       : unsigned(1 downto 0);
  signal ula_out  : unsigned(15 downto 0);
begin

  ula_inst: ula
    port map (
      in0     => in0,
      in1     => in1,
      op      => op,
      ula_out => ula_out
    );

  process
  begin
    op <= "00";
    wait;
  end process;

end architecture a_ula_tb;