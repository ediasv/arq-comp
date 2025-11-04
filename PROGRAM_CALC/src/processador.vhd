library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity processador is
  port (
    rst  : in  std_logic;
    clk  : in  std_logic;
    zero : out std_logic;
    sig  : out std_logic
  );
end entity;

architecture a_processador of processador is

  --  Carga de constantes, transferência de valores entre registradores, salto incondicional e nop;
  -- 'Registrador de Instruções': ['wr_en no primeiro estado'],
  -- 'Incremento do PC': ['PC+1 gravado entre o primeiro e segundo estado E jmp Executado no último estado']}

  -----------------
  -- Componentes --
  -----------------

  -- Maquina de estados
  component sm
    port (
      clk, rst : in  std_logic;
      estado   : out unsigned(1 downto 0)
    );
  end component;

  -- PC
  component program_counter
    port (
      clk      : in  std_logic;
      wr_en    : in  std_logic;
      data_in  : in  unsigned(6 downto 0);
      data_out : out unsigned(6 downto 0)
    );
  end component;

  -- ROM
  component rom
    port (
      clk      : in  std_logic;
      endereco : in  unsigned(6 downto 0);
      dado     : out unsigned(14 downto 0)
    );
  end component;

  -- Unidade de Controle
  component uc
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
  end component;

  -- Banco de Registradores
  component bank_of_registers
    port (
      clk         : in  std_logic;
      rst         : in  std_logic;
      wr_en       : in  std_logic;
      addr_dest   : in  unsigned(3 downto 0);
      addr_source : in  unsigned(3 downto 0);
      data_in     : in  unsigned(15 downto 0);
      data_out    : out unsigned(15 downto 0)
    );
  end component;

  -- ULA
  component ula
    port (
      in0, in1  : in  unsigned(15 downto 0);
      op        : in  unsigned(1 downto 0);
      ula_out   : out unsigned(15 downto 0);
      zero, sig : out std_logic
    );
  end component;

  -- Registrador de 16 bits (ACC)
  component reg16bits
    port (
      clk      : in  std_logic;
      rst      : in  std_logic;
      wr_en    : in  std_logic;
      data_in  : in  unsigned(15 downto 0);
      data_out : out unsigned(15 downto 0)
    );
  end component;

  -- Registrador de 15 bits (REG_INSTR)
  component reg15bits
    port (
      clk      : in  std_logic;
      rst      : in  std_logic;
      wr_en    : in  std_logic;
      data_in  : in  unsigned(14 downto 0);
      data_out : out unsigned(14 downto 0)
    );
  end component;

  ---------------------
  -- Sinais Internos --
  ---------------------

  -- Sinal de entrada do PC
  signal mux_to_pc : unsigned(6 downto 0) := (others => '0');

  -- Sinal de saída do PC
  signal pc_data_out : unsigned(6 downto 0) := (others => '0');

  -- Sinal de saída da ROM
  signal rom_data_out : unsigned(14 downto 0) := (others => '0');

  -- Sinal de saída do registrador de instruções
  signal instr_reg_out : unsigned(14 downto 0) := (others => '0');

  -- Sinal de estado da máquina de estados
  signal estado_sig : unsigned(1 downto 0) := (others => '0');

  -- Sinais do endereço de destino do banco de registradores
  signal mux_addr_dest : unsigned(3 downto 0) := (others => '0');

  -- Sinal do data_in do banco de registradores
  signal bank_data_in : unsigned(15 downto 0) := (others => '0');

  -- Sinal de saída do banco de registradores
  signal bank_data_out : unsigned(15 downto 0) := (others => '0');

  -- Sinais da ULA
  signal mux_to_ula : unsigned(15 downto 0) := (others => '0');
  signal ula_out    : unsigned(15 downto 0) := (others => '0');

  -- Sinais do acumulador
  signal acc_in  : unsigned(15 downto 0) := (others => '0');
  signal acc_out : unsigned(15 downto 0) := (others => '0');

  -- Sinais da Unidade de Controle
  signal instr_format_sig : std_logic                    := '0';
  signal sel_ula_op_sig   : unsigned(1 downto 0)         := (others => '0');
  signal sel_bank_in_sig  : std_logic_vector(1 downto 0) := (others => '0');
  signal sel_acc_in_sig   : std_logic                    := '0';
  signal sel_ula_in_sig   : std_logic                    := '0';
  signal en_is_jmp_sig    : std_logic                    := '0';
  signal en_acc_sig       : std_logic                    := '0';
  signal en_bank_sig      : std_logic                    := '0';
  signal en_instr_reg_sig : std_logic                    := '0';
  signal en_pc_sig        : std_logic                    := '0';

begin

  --------------------------------
  -- Instancias dos componentes --
  --------------------------------

  -- Máquina de Estados
  sm_inst: sm
    port map (
      clk    => clk,
      rst    => rst,
      estado => estado_sig
    );

  -- PC
  pc_inst: program_counter
    port map (
      clk      => clk,
      wr_en    => en_pc_sig,
      data_in  => mux_to_pc,
      data_out => pc_data_out
    );

  -- ROM
  rom_inst: rom
    port map (
      clk      => clk,
      endereco => pc_data_out,
      dado     => rom_data_out
    );

  -- Registrador de Instruções
  instr_reg_inst: reg15bits
    port map (
      clk      => clk,
      rst      => rst,
      wr_en    => en_instr_reg_sig,
      data_in  => rom_data_out,
      data_out => instr_reg_out
    );

  -- Unidade de Controle
  uc_inst: uc
    port map (
      uc_data_in   => instr_reg_out,
      estado       => estado_sig,
      instr_format => instr_format_sig,
      sel_ula_op   => sel_ula_op_sig,
      sel_bank_in  => sel_bank_in_sig,
      sel_acc_in   => sel_acc_in_sig,
      sel_ula_in   => sel_ula_in_sig,
      en_is_jmp    => en_is_jmp_sig,
      en_acc       => en_acc_sig,
      en_bank      => en_bank_sig,
      en_instr_reg => en_instr_reg_sig,
      en_pc       => en_pc_sig
    );

  -- Banco de Registradores
  bank_of_registers_inst: bank_of_registers
    port map (
      clk         => clk,
      rst         => rst,
      wr_en       => en_bank_sig,
      addr_dest   => mux_addr_dest,
      addr_source => instr_reg_out(7 downto 4),
      data_in     => bank_data_in,
      data_out    => bank_data_out
    );

  -- Acumulador
  acc_inst: reg16bits
    port map (
      clk      => clk,
      rst      => rst,
      wr_en    => en_acc_sig,
      data_in  => acc_in,
      data_out => acc_out
    );

  -- ULA
  ula_inst: ula
    port map (
      in0     => mux_to_ula,
      in1     => acc_out,
      op      => sel_ula_op_sig,
      ula_out => ula_out,
      zero    => zero,
      sig     => sig
    );

  ----------------------
  -- Lógica dos muxes --
  ----------------------

  -- Mux do data_in do PC
  -- PC+1 OU instr_reg_out(10 downto 4)
  -- NOTA: instr_reg_out(10 downto 4) é o endereço de salto da instrução JMP
  mux_to_pc <= pc_data_out + 1 when en_is_jmp_sig = '0' else
               instr_reg_out(10 downto 4);

  -- Mux do endereço de destino do banco de registradores
  -- instr_reg_out(14 downto 11) quando formato C OU instr_reg_out(11 downto 8) quando formato S
  mux_addr_dest <= instr_reg_out(14 downto 11) when instr_format_sig = '0' else
                   instr_reg_out(11 downto 8);

  -- Mux do data_in do banco de registradores
  -- bank_out OU acc_out OU instr_reg_out(10 downto 4)
  -- NOTA: instr_reg_out(10 downto 4) é a constante da instrução LD
  bank_data_in <= bank_data_out                                when sel_bank_in_sig = "00" else
                  acc_out                                      when sel_bank_in_sig = "01" else
                  ("000000000" & instr_reg_out(10 downto 4))   when sel_bank_in_sig = "10" else
                  (others => '0');

  -- Mux da entrada 0 da ULA
  -- bank_out OU instr_reg_out(10 downto 4)
  -- NOTA: instr_reg_out(10 downto 4) é a constante da instrução SUBI
  mux_to_ula <= bank_data_out when sel_ula_in_sig = '0' else
                ("000000000" & instr_reg_out(10 downto 4));

  -- Mux da entrada do acumulador
  -- ula_out OU bank_out
  acc_in <= ula_out when sel_acc_in_sig = '0' else
            bank_data_out;

end architecture;
