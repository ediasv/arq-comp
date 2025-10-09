library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity bank_of_registers is
  port (clk      : in  std_logic;
        rst      : in  std_logic;
        wr_en    : in  std_logic;
        addr_wr  : in  std_logic_vector(2 downto 0); -- address to select one of the 8 registers
        data_in  : in  unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
       );
end entity;

architecture a_bank_of_registers of bank_of_registers is

  -- Declaracao dos 8 registradores de 16 bits
  component reg16bits
    port (clk      : in  std_logic;
          rst      : in  std_logic;
          wr_en    : in  std_logic;
          data_in  : in  unsigned(15 downto 0);
          data_out : out unsigned(15 downto 0)
         );
  end component;

  type reg_array_type is array (0 to 7) of unsigned(15 downto 0);
  signal reg_array : reg_array_type;

  signal wr_en_array : std_logic_vector(0 to 7);

begin

  gen_wr_en: for i in 0 to 7 generate
    wr_en_array(i) <= '1' when (wr_en = '1' and to_integer(unsigned(addr_wr)) = i) else '0';
  end generate;

  gen_regs: for i in 0 to 7 generate
    reg_i: reg16bits
      port map (
        clk      => clk,
        rst      => rst,
        wr_en    => wr_en_array(i),
        data_in  => data_in,
        data_out => reg_array(i)
      );
  end generate;

  data_out <= reg_array(to_integer(unsigned(addr_wr)));

end architecture;
