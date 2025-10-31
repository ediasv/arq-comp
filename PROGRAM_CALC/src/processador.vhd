library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity processador is
  port (
   
  );
end entity;

architecture a_processador of processador is

  --  Carga de constantes, transferência de valores entre registradores, salto incondicional e nop;
  -- 'Registrador de Instruções': ['wr_en no primeiro estado'],
  -- 'Incremento do PC': ['PC+1 gravado entre o primeiro e segundo estado E jmp '
  -- 'Executado no último estado']}

  -- Sinais internos
  signal pc_out       : unsigned(6 downto 0);
  signal instr        : unsigned(15 downto 0);
  signal uc_data_in   : unsigned(14 downto 0);
  signal jump_enable  : std_logic;

    -- Componentes
    component program_counter
      port (
        clk      : in  std_logic;
        wr_en    : in  std_logic;
        data_in  : in  unsigned(6 downto 0);
        data_out : out unsigned(6 downto 0)
      );
    end component;

    component uc
      port (
        uc_data_in : in  unsigned(14 downto 0);
        jump_en    : out std_logic
      );
    end component;

    component reg16bits
      port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        wr_en    : in  std_logic;
        data_in  : in  unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
      );
    end component;

    component rom
      port (
        addr    : in  unsigned(6 downto 0);
        data_out: out unsigned(15 downto 0)
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

    begin 
    