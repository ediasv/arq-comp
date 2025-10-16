library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity top_level is
  port (clk : in std_logic;
        rst : in std_logic
       );
end entity;

architecture a_top_level of top_level is

  component proto_uc
    port (uc_data_in : in  unsigned(14 downto 0);
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
      clk      : in  std_logic;
      endereco : in  unsigned(6 downto 0);
      dado     : out unsigned(14 downto 0)
    );
  end component;

  component state_machine
    port (
      clk    : in  std_logic;
      rst    : in  std_logic;
      sm_out : out std_logic
    );
  end component;

  component external_circuit
    port (
      data_ext_in  : in  unsigned(6 downto 0);
      data_ext_out : out unsigned(6 downto 0)
    );
  end component;

  signal rom_to_uc       : unsigned(14 downto 0) := (others => '0');
  signal jump_en         : std_logic             := '0';
  signal sm_to_pc_en     : std_logic             := '0';
  signal pc_to_rom       : unsigned(6 downto 0)  := (others => '0');
  signal pc_to_plus_one  : unsigned(6 downto 0)  := (others => '0');
  signal mux_to_pc       : unsigned(6 downto 0)  := (others => '0');
  signal plus_one_to_mux : unsigned(6 downto 0)  := (others => '0');
  signal rom_to_mux      : unsigned(6 downto 0)  := (others => '0');

begin

  uc: proto_uc
    port map (
      uc_data_in => rom_to_uc,
      jump_en    => jump_en
    );

  pc: program_counter
    port map (
      clk      => clk,
      wr_en    => sm_to_pc_en,
      data_in  => mux_to_pc,
      data_out => pc_to_rom
    );

  r: rom
    port map (
      clk      => clk,
      endereco => pc_to_rom,
      dado     => rom_to_uc
    );

  sm: state_machine
    port map (
      clk    => clk,
      rst    => rst,
      sm_out => sm_to_pc_en
    );
  
  plux_one: external_circuit
    port map (
      data_ext_in  => pc_to_plus_one,
      data_ext_out => plus_one_to_mux
    );

  -- Mux entre o valor incrementado e o valor vindo da ROM
  mux_to_pc <= plus_one_to_mux when jump_en = '0' else rom_to_mux;

  -- Conecta a saída do PC à entrada do somador para incrementar
  pc_to_plus_one <= pc_to_rom;

  -- Conecta a saída da ROM à entrada do mux (para saltos)
  rom_to_mux <= rom_to_uc(6 downto 0);
end architecture;
