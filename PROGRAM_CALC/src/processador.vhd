library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity processador is
  port (
    rst : in std_logic;
    clk : in std_logic
  );
end entity;

architecture a_processador of processador is

  --  Carga de constantes, transferência de valores entre registradores, salto incondicional e nop;
  -- 'Registrador de Instruções': ['wr_en no primeiro estado'],
  -- 'Incremento do PC': ['PC+1 gravado entre o primeiro e segundo estado E jmp Executado no último estado']}

  -- Componentes
  component sm
    port (
      clk, rst : in  std_logic;
      estado   : out unsigned(1 downto 0)
    );
  end component;

  component uc
    port (
      uc_data_in           : in  unsigned(14 downto 0);
      sm                   : in  unsigned(1 downto 0);
      sel_mux_to_pc        : out std_logic;
      sel_mux_to_bank      : out unsigned (1 downto 0);
      sel_mux_to_ula       : out std_logic;
      sel_mux_to_acc       : out std_logic;
      sel_ula_operation    : out unsigned(1 downto 0);
      en_wr_pc             : out std_logic;
      en_wr_acc            : out std_logic;
      en_wr_reg_rom        : out std_logic;
      en_bank_of_registers : out std_logic;
      format_decoder       : out std_logic
    );
  end component;

  component program_counter
    port (
      clk      : in  std_logic;
      wr_en    : in  std_logic;
      data_in  : in  unsigned(6 downto 0);
      data_out : out unsigned(6 downto 0)
    );
  end component;

  component rom
    port (
      clk      : in  std_logic;
      endereco : in  unsigned(6 downto 0);
      dado     : out unsigned(14 downto 0)
    );
  end component;

  component reg_rom
    port (
      clk           : in  std_logic;
      rst           : in  std_logic;
      wr_en         : in  std_logic;
      data_from_rom : in  unsigned(14 downto 0);
      data_out      : out unsigned(14 downto 0)
    );
  end component;

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

  component acc
    port (
      clk      : in  std_logic;
      rst      : in  std_logic;
      wr_en    : in  std_logic;
      data_in  : in  unsigned(15 downto 0);
      data_out : out unsigned(15 downto 0)
    );
  end component;

  component ula
    port (
      in0, in1  : in  unsigned(15 downto 0);
      op        : in  unsigned(1 downto 0);
      ula_out   : out unsigned(15 downto 0);
      zero, sig : out std_logic
    );
  end component;

  signal sm_to_uc : unsigned(1 downto 0) := (others => '0'); -- fetch, decode, execute

  --mux 1
  signal sel_mux_to_pc : std_logic := '0';
  signal mux_to_pc     : unsigned(6 downto 0);
  signal pc_to_rom     : unsigned(6 downto 0);

  signal en_wr_pc             : std_logic := '0';
  signal en_wr_acc            : std_logic := '0';
  signal en_wr_reg_rom        : std_logic := '0';
  signal en_bank_of_registers : std_logic := '0';

  --mux 2
  signal rom_to_reg_rom  : unsigned(14 downto 0);
  signal reg_rom_out     : unsigned(14 downto 0);
  signal mux_to_bank     : unsigned(15 downto 0) := (others => '0');
  signal sel_mux_to_bank : unsigned (1 downto 0) := (others => '0');

  --mux 3
  signal bank_to_mux    : unsigned(15 downto 0) := (others => '0');
  signal mux_to_ula     : unsigned(15 downto 0) := (others => '0');
  signal sel_mux_to_ula : std_logic             := '0';

  --mux 4
  signal ula_to_mux     : unsigned(15 downto 0) := (others => '0');
  signal mux_to_acc     : unsigned(15 downto 0) := (others => '0');
  signal acc_to_ula     : unsigned(15 downto 0) := (others => '0');
  signal sel_mux_to_acc : std_logic             := '0';

  signal sel_ula_operation : unsigned(1 downto 0) := (others => '0');

  signal format_decoder : std_logic;
  signal mux_addr_dest  : unsigned(3 downto 0);

begin

  sm_inst: sm
    port map (
      clk    => clk,
      rst    => rst,
      estado => sm_to_uc
    );

  inst_uc: uc
    port map (
      uc_data_in           => reg_rom_out,
      sm                   => sm_to_uc,
      -- jump_en    => en_uc_to_pc,
      sel_mux_to_pc        => sel_mux_to_pc,
      sel_mux_to_ula       => sel_mux_to_ula,
      sel_ula_operation    => sel_ula_operation,
      sel_mux_to_acc       => sel_mux_to_acc,
      sel_mux_to_bank      => sel_mux_to_bank,
      en_wr_pc             => en_wr_pc,
      en_wr_acc            => en_wr_acc,
      en_wr_reg_rom        => en_wr_reg_rom,
      en_bank_of_registers => en_bank_of_registers,
      format_decoder       => format_decoder
    );

  mux_to_pc <= reg_rom_out(10 downto 4) when sel_mux_to_pc = '1' else pc_to_rom + 1;

  inst_pc: program_counter
    port map (
      clk      => clk,
      wr_en    => en_wr_pc, --ENABLE VEM DA UC
      data_in  => mux_to_pc,
      data_out => pc_to_rom
    );

  --lógica para adicionar 1 ou fazer o jump
  inst_rom: rom
    port map (
      clk      => clk,
      endereco => pc_to_rom,
      dado     => rom_to_reg_rom
    );

  inst_reg_rom: reg_rom
    port map (
      clk           => clk,
      rst           => rst,
      wr_en         => en_wr_reg_rom,
      data_from_rom => rom_to_reg_rom,
      data_out      => reg_rom_out
    );

  -- mux_to_bank <= bank_to_mux              when sel_mux_to_bank = "00" else
  --                acc_to_ula               when sel_mux_to_bank = "01" else
  --                reg_rom_out(10 downto 4) when sel_mux_to_bank = "10";

  mux_to_bank <= bank_to_mux when sel_mux_to_bank = "00" else
  acc_to_ula  when sel_mux_to_bank = "01" else
  ("000000000" & reg_rom_out(10 downto 4));  


  mux_addr_dest <= reg_rom_out(11 downto 8) when format_decoder = '1' else reg_rom_out(14 downto 11);

  inst_bank: bank_of_registers
    port map (
      clk         => clk,
      rst         => rst,
      addr_dest   => mux_addr_dest,
      addr_source => reg_rom_out(7 downto 4),
      wr_en       => en_bank_of_registers,
      data_in     => mux_to_bank,
      data_out    => bank_to_mux
    );

  inst_acc: acc
    port map (
      clk      => clk,
      rst      => rst,
      wr_en    => en_wr_acc,
      data_in  => mux_to_acc,
      data_out => acc_to_ula
    );

    mux_to_ula <= ("000000000" & reg_rom_out(10 downto 4)) when sel_mux_to_ula = '1' 
    else bank_to_mux;
    -- mux_to_ula <= reg_rom_out(10 downto 4) when sel_mux_to_ula = '1' else bank_to_mux; --reg_rom_out(10 downto 4) = constant

  inst_ula: ula
    port map (
      in0     => acc_to_ula,
      in1     => mux_to_ula,
      op      => sel_ula_operation,
      ula_out => ula_to_mux,
      zero    => open,
      sig     => open
    );

  mux_to_acc <= bank_to_mux when sel_mux_to_acc = '1' else ula_to_mux;

end architecture;
