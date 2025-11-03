library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity uc is
  port (
    uc_data_in        : in  unsigned(14 downto 0);
    sm                : in  unsigned(1 downto 0);
    sel_mux_to_pc     : out std_logic;
    sel_mux_to_bank   : out std_logic;
    sel_mux_to_ula    : out std_logic;
    sel_mux_to_acc    : out std_logic;
    en_wr_pc          : out std_logic;
    sel_ula_operation : out unsigned(1 downto 0)
  );
end entity;

architecture a_uc of uc is
  signal opcode : unsigned(3 downto 0) := (others => '0');
  signal reg1   : unsigned(3 downto 0) := (others => '0'); -- result register
  signal reg2   : unsigned(3 downto 0) := (others => '0');
  signal format : std_logic;
  signal cte    : unsigned(6 downto 0) := (others => '0');

begin
  -- opcode sempre recebe os 4 bits menos significativos
  --1 for S (SUBI, LD and JMP) format and 0 for C
  format <= '1' when opcode = "0011" or opcode = "0101" or opcode = "0110" else '0';

  opcode <= uc_data_in(3 downto 0);
  --S format
  reg1 <= uc_data_in(11 downto 8) and reg2 <= uc_data_in(7 downto 4) when format = '1';
  --C format
  cte <= uc_data_in(10 downto 4) when format = '0';

  -- jump_en <= '1' when opcode = "0110" and format='0' else '0';
  sel_mux_to_pc     <= '1' when opcode = "0110" and format = '0' else '0'; -- equals to jump_en 1 means rom_to_mux, 0 means add_to_mux
  sel_mux_to_ula    <= '1' when opcode = "0011" else '0';                  -- 1 means operation with constant , 0 means
  sel_ula_operation <= "00" when opcode = "0001" else "01";               -- 1 means rom_to_mux, 0 means add_to_mux

  sel_mux_to_acc <= '1' when opcode = "0100" and reg1 = "1001" else '0'; -- 1 means bank instead of ULA

  sel_mux_to_bank <= "00" when opcode = "0100" and reg1 /= "1001" else --bank 
                     "01" when reg2 = "1001" else                      -- accumulator
                     "10" when opcode = "0101" and format = '0'; --rom

  en_wr_pc <= '1' when sm = "01" or (sm = "10" and sel_mux_to_pc = '1') else '0'; -- enable write only in fetch state

end architecture;
