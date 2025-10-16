library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

  entity external_circuit is
    port (
        data_ext_in  : in  unsigned(6 downto 0);
        data_ext_out : out unsigned(6 downto 0)
    );
  end entity;

  architecture a_external_circuit of external_circuit is
  begin
    data_ext_out <= data_ext_in + 1;
  end architecture;