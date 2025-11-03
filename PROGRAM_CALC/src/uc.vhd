library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity uc is
  port (
    uc_data_in           : in  unsigned(14 downto 0);
    sm                   : in  unsigned(1 downto 0);
    sel_mux_to_pc        : out std_logic;
    sel_mux_to_bank      : out unsigned(1 downto 0);
    sel_mux_to_ula       : out std_logic;
    sel_mux_to_acc       : out std_logic;
    sel_ula_operation    : out unsigned(1 downto 0);
    en_wr_pc             : out std_logic;
    en_wr_acc            : out std_logic;
    en_wr_reg_rom        : out std_logic;
    en_bank_of_registers : out std_logic;
    format_decoder       : out std_logic
  );
end entity;

architecture a_uc of uc is
  signal opcode : unsigned(3 downto 0) := (others => '0');
  signal reg1   : unsigned(3 downto 0) := (others => '0'); -- result register
  signal reg2   : unsigned(3 downto 0) := (others => '0');
  signal sel_mux_to_pc_internal : std_logic;
  signal format : std_logic;

begin
  -- opcode sempre recebe os 4 bits menos significativos
  --1 for S (SUBI, LD and JMP) format and 0 for C
  format <= '1' when opcode = "0011" or opcode = "0101" or opcode = "0110" else '0'; -- 1 for S format 0 for C format

  opcode <= uc_data_in(3 downto 0);
  --S format
  reg1 <= uc_data_in(11 downto 8) when format = '1' else (others => '0');
  reg2 <= uc_data_in(7 downto 4) when format = '1' else (others => '0');

  --C format
  sel_mux_to_pc_internal  <= '1' when opcode = "0110" and format = '0' else '0'; -- equals to jump_en 1 means rom_to_mux, 0 means add_to_mux
  sel_mux_to_pc <= sel_mux_to_pc_internal;
  sel_mux_to_ula <= '1' when opcode = "0011" else '0';                  -- 1 means operation with constant , 0 means    

  sel_ula_operation <= "00" when opcode = "0001" else -- ADD
                       "01" when opcode = "0010" else -- SUB
                       "01" when opcode = "0011" else -- SUBI (também subtração)
                       "00"; -- Default               

  sel_mux_to_acc <= '1' when opcode = "0100" and reg1 = "1001" else '0'; -- 1 means bank instead of ULA

  sel_mux_to_bank <= "00" when opcode = "0100" and reg1 /= "1001" else --bank 
                     "01" when opcode = "0100" and reg2 = "1001" else                      -- accumulator
                     "10" when format='0' and format = '0'; --rom

  en_wr_pc <= '1' when sm = "01" or (sm = "10" and sel_mux_to_pc_internal = '1') else '0'; -- enable write only in fetch state

  en_wr_acc <= '1' when (opcode = "0001" or opcode = "0010" or opcode = "0011") else '0';

  en_wr_reg_rom <= '1' when sm = "00" else '0'; -- enable write only in fetch state

  en_bank_of_registers <= '1' when (opcode = "0101" or (opcode = "0100" and reg1 /= "1001")) else '0';

  format_decoder <= format;

end architecture;
