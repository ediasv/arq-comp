library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity uc is
  port (
    uc_data_in   : in  unsigned(14 downto 0);
    estado       : in  unsigned(1 downto 0);
    instr_format : out std_logic;
    sel_ula_op   : out unsigned(1 downto 0);
    sel_bank_in  : out std_logic;
    sel_acc_in   : out std_logic;
    sel_ula_in   : out std_logic;
    en_is_jmp    : out std_logic;
    en_acc       : out std_logic;
    en_bank      : out std_logic;
    en_instr_reg : out std_logic;
    en_pc        : out std_logic
  );
end entity;

architecture a_uc of uc is

begin

end architecture;
