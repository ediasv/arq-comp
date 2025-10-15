library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity proto_uc is
  port(uc_data_in : in unsigned(6 downto 0);
       uc_data_out : out unsigned(6 downto 0)
  );
end entity;

architecture a_proto_uc of proto_uc is
begin
  uc_data_out <= uc_data_in + 1;
end architecture;
