library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
  port ();
end entity;

architecture a_processador of processador is

  --  Carga de constantes, transferência de valores entre registradores, salto incondicional e nop;
  -- 'Registrador de Instruções': ['wr_en no primeiro estado'],
  -- 'Incremento do PC': ['PC+1 gravado entre o primeiro e segundo estado E jmp '
  -- 'Executado no último estado']}
  
  -- Componentes
    component sm
      port ( 
        clk,rst: in std_logic;
        estado: out unsigned(1 downto 0)
      );
      end component;

      component uc
        port (
          uc_data_in : in  unsigned(14 downto 0);
          jump_en    : out std_logic
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
        addr    : in  unsigned(6 downto 0);
        data_out: out unsigned(15 downto 0)
      );
    end component;
   

    component reg_rom
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        wr_en    : in  std_logic;
        data_from_rom  : in  unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
    );
    end component;

    component bank_of_registers
      port (
        clk         : in  std_logic;
        rst         : in  std_logic;
        wr_en       : in  std_logic;
        addr_dest   : in  unsigned(2 downto 0);
        addr_source : in  unsigned(2 downto 0);
        data_in     : in  unsigned(14 downto 0);
        data_out    : out unsigned(14 downto 0)
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
        a        : in  unsigned(15 downto 0);
        b        : in  unsigned(15 downto 0);
        opcode   : in  unsigned(3 downto 0);
        result   : out unsigned(15 downto 0)
      );
    end component;


    signal sm_to_uc  : unsigned(1 downto 0) := (others => '0'); -- fetch, decode, execute
    signal en_uc_to_pc  : unsigned(14 downto 0) := (others => '0'); 
    
    --mux 1
    signal en_uc_to_mux  : std_logic := '0';
    signal mux_to_pc  : unsigned(6 downto 0); 
    signal pc_to_rom  : unsigned(6 downto 0);
    signal rom_to_mux : unsigned(6 downto 0);
    signal add_to_mux : unsigned(6 downto 0);
  
  
   --mux 2
    -- signal inst_reg_to_uc : unsigned(6 downto 0);
    -- signal inst_reg_to_mux : unsigned(6 downto 0);
    signal rom_to_reg_rom : unsigned(14 downto 0);
    signal reg_rom_out    : unsigned(14 downto 0);
    signal mux_to_bank    : unsigned(14 downto 0) := (others => '0');
    signal acc_to_mux     : unsigned(14 downto 0) := (others => '0');
    
    --mux 3
    signal inst_reg_cte_to_mux : unsigned(6 downto 0);
    signal bank_to_mux  : unsigned(14 downto 0) := (others => '0');
    signal mux_to_ula   : unsigned(14 downto 0) := (others => '0');
  
   --mux 4
    signal ula_to_mux   : unsigned(14 downto 0) := (others => '0');
    signal mux_to_acc   : unsigned(14 downto 0) := (others => '0');
    signal acc_to_ula   : unsigned(14 downto 0) := (others => '0');


    begin 

    sm_inst : sm
      port map (
        clk   => clk,
        rst   => rst,
        estado => sm_to_uc
      );


    inst_uc : uc
      port map (
        uc_data_in => rom_to_reg_rom,
        jump_en    => en_uc_to_pc
      );

  -- mux_to_pc <= rom_to_mux when en_uc_to_pc = '1' else add_to_mux; VER DEPOIS A UC

    inst_pc : program_counter
    port map (
      clk      => clk,
      wr_en    => '0',
      data_in  => mux_to_pc,
      data_out => pc_to_rom
    );
 
--lógica para adicionar 1 ou fazer o jump

    inst_rom : rom
    port map (
      addr     => pc_to_rom,
      data_out => rom_to_reg_rom
    );

    inst_reg_rom : reg_rom
      port map (
        clk           => clk,
        rst           => rst,
        wr_en         => '1' when sm_to_uc = "00" else '0 ',
        data_from_rom => rom_to_reg_rom,
        data_out      => reg_rom_out
      );

      mux_to_bank <= reg_rom_out when sm_to_uc = "10" else
                      inst_reg_cte_to_mux;
--CONFERIR COM A PARADA DO ESTADO EXECUTE E SLA OQ QUE O JULIANO ESPECIFICOU

    inst_bank : bank_of_registers
      port map (
        clk         => clk,
        rst         => rst,
        wr_en       => '1' when sm_to_uc = "10" else '0',
        addr_dest   => inst_reg_out(5 downto 3),
        addr_source => inst_reg_out(2 downto 0),
        data_in     => mux_to_bank,
        data_out    => bank_to_mux --?? como diferenciar as duas saídas do banco de registradores??
      );

    inst_acc : acc
      port map (
        clk      => clk,
        rst      => rst,
        wr_en    => '1' when sm_to_uc = "10" else '0',
        data_in  => mux_to_acc,
        data_out => acc_to_ula
      );

  -- mux_to_ula <= bank_to_mux when ??? else
  --                acc_to_mux;

      inst_ula : ula  
      port map (
        a        => acc_to_ula,
        b        => mux_to_ula,
        opcode   => ???,
        result   => ula_to_mux
      );

    -- mux_to_acc <= ula_to_mux when ??? else
    --                bank_to_mux;



-- PONTOS QUE FALTAM: 
-- LÓGICA DOS MUXES E SINAIS DE CONTROLE PARA ELES (Unidade de Controle)
-- OPCODES DA ULA (DINHO)
-- CONFERIR OS BITS DE CADA ENTRADA E SAÍDA DOS COMPONENTES
-- CONFERIR ATRIBUIÇÕES DE ENTRADA E SAÍDA DOS COMPONENTES

    end architecture;