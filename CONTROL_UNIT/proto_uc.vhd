library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity proto_uc is
  port (uc_data_in  : in  unsigned(14 downto 0);
        uc_data_out : out unsigned(6 downto 0)
       );
end entity;

architecture a_proto_uc of proto_uc is
  signal opcode : unsigned(3 downto 0);
  signal addr   : unsigned(6 downto 0);
begin
  opcode <= uc_data_in(14 downto 11);
  addr   <= uc_data_in(6 downto 0);

  uc_data_out <= addr when opcode = "1111" else -- jump
                 addr + 1;  -- NOP
 end architecture;
