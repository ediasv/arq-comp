library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity proto_uc is
  port (uc_data_in : in  unsigned(14 downto 0);
        jump_en    : out std_logic
       );
end entity;

architecture a_proto_uc of proto_uc is
  signal opcode : unsigned(3 downto 0) := (others => '0');
begin
  -- opcode sempre recebe os 4 bits mais significativos
  opcode <= uc_data_in(14 downto 11);

  jump_en <= '1' when opcode = "1111" else '0';
end architecture;