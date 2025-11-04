library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity uc is
  port (
    uc_data_in   : in  unsigned(14 downto 0);
    estado       : in  unsigned(1 downto 0);
    instr_format : out std_logic;
    sel_ula_op   : out unsigned(1 downto 0);
    sel_bank_in  : out std_logic_vector(1 downto 0);
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

  ---------------------
  -- Sinais Internos --
  ---------------------

  -- Sinal para o opcode
  signal opcode : unsigned(3 downto 0) := (others => '0');

  -- Sinal de registrador fonte (formato S)
  signal s_inst_source_reg : unsigned(3 downto 0) := (others => '0');

  -- Sinal de registrador destino (formato S)
  signal s_inst_dest_reg : unsigned(3 downto 0) := (others => '0');

  -- Sinal de registrador destino (formato C)
  signal c_inst_dest_reg : unsigned(3 downto 0) := (others => '0');

  signal instr_format_sig : std_logic := '0';

begin

  -- opcode sempre recebe os 4 bits menos significativos
  opcode <= uc_data_in(3 downto 0);

  -- Atribuicao dos sinais de endereco de registradores
  s_inst_source_reg <= uc_data_in(7 downto 4);
  s_inst_dest_reg   <= uc_data_in(11 downto 8);
  c_inst_dest_reg   <= uc_data_in(14 downto 11);

  -- Formato da instrução
  -- As instruções de formato S têm opcode 0001, 0010, 0100
  -- As instruções de formato C têm opcode 0011, 0101, 0110
  -- O sinal instr_format é '1' para formato S e '0' para formato C
  instr_format_sig <= '1' when (opcode = "0001" or opcode = "0010" or opcode = "0100") else
                  '0';
  instr_format <= instr_format_sig;

  -- Sinal que diz se é operação de jump
  -- A instrução JMP tem opcode 0110
  en_is_jmp <= '1' when opcode = "0110" else
               '0';

  -- Sinal de enable do PC
  -- O PC é incrementado entre o primeiro e o segundo estado (estado = 00)
  en_pc <= '1' when estado = "00" else
           '0';

  -- Sinal de enable do registrador de instruções
  -- O registrador de instruções está habilitado no primeiro estado (estado = 00)
  en_instr_reg <= '1' when estado = "00" else
                  '0';

  -- Sinal de enable do acumulador
  -- O acumulador é habilitado nas instruções: 
  --   ADD (opcode = 0001) 
  --   SUB (opcode = 0010)
  --   SUBI (opcode = 0011)
  --   LD com destino acumulador (opcode = 0101 e c_inst_dest_reg = "1001")
  --   MV com destino acumulador (opcode = 0100 and s_inst_dest_reg = "1001")
  en_acc <= '1' when (opcode = "0001" or opcode = "0010" or opcode = "0011" or (opcode = "0101" and c_inst_dest_reg = "1001") or (opcode = "0100" and s_inst_dest_reg = "1001")) else
            '0';

  -- Sinal de enable do banco de registradores
  -- O banco de registradores é habilitado nas instruções:
  --   LD com destino dentro do banco (opcode = 0101 e c_inst_dest_reg /= "1001")
  --   MV com destino dentro do banco (opcode = 0100 e s_inst_dest_reg /= "1001")
  en_bank <= '1' when ((opcode = "0101" and c_inst_dest_reg /= "1001") or (opcode = "0100" and s_inst_dest_reg /= "1001")) else
             '0';

  -- Sinal de seleção da entrada do banco de registradores
  -- A entrada do banco de registradores pode ser:
  --   00: saída do banco de registradores
  --       Quando: MV com destino dentro do banco e fonte é um registrador
  --       Condição: opcode = 0100 AND s_inst_source_reg /= "1001"
  --
  --   01: saída do acumulador
  --       Quando: MV com destino dentro do banco e fonte é o acumulador
  --       Condição: opcode = 0100 AND s_inst_source_reg = "1001"
  --
  --   10: constante do formato C
  --       Quando: LD com destino dentro do banco
  --       Condição: opcode = 0101 AND c_inst_dest_reg /= "1001"
  sel_bank_in <= "00" when (opcode = "0100" and s_inst_source_reg /= "1001") else
                 "01" when (opcode = "0100" and s_inst_source_reg = "1001") else
                 "10" when (opcode = "0101" and c_inst_dest_reg /= "1001") else
                 "00";

  -- Sinal de seleção da operação da ULA
  -- A ULA pode realizar as operações:
  --   00: ADD (default)
  --       Quando: instrução ADD (opcode = 0001)
  --   01: SUB
  --       Quando: instrução SUB (opcode = 0010) OU
  --       Quando: instrução SUBI (opcode = 0011)
  --   10: AND ** INSTRUCAO NAO CODIFICADA **
  --       Quando: instrução AND (opcode = 0100)
  --   11: OR ** INSTRUCAO NAO CODIFICADA **
  --       Quando: instrução OR (opcode = 0101)
  sel_ula_op <= "01" when (opcode = "0010" or opcode = "0011") else
                "00";

  -- Sinal de seleção da entrada da ULA
  -- A entrada da ULA pode ser:
  --   0: saída do banco de registradores
  --       Quando: formato S
  --   1: constante do formato C
  --       Quando: formato C
  sel_ula_in <= '0' when instr_format_sig = '1' else
                '1';

  -- Sinal de seleção da entrada do acumulador
  -- A entrada do acumulador pode ser:
  --   0: saída da ULA
  --       Quando: instruções ADD (opcode = 0001), SUB (opcode = 0010), SUBI (opcode = 0011)
  --   1: saída do banco de registradores
  --       Quando: instrução MV com destino acumulador
  sel_acc_in <= '0' when (opcode = "0001" or opcode = "0010" or opcode = "0011") else
                '1';
end architecture;
