library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity top_level is
  port (clk          : in  std_logic;
        rst          : in  std_logic;
        wr_en        : in  std_logic;
        addr_wr      : in  std_logic_vector(2 downto 0); -- 3 bits para 8 registradores
        data_in      : in  unsigned(15 downto 0);
        data_out     : out unsigned(15 downto 0)
       );
end entity;

architecture a_top_level of top_level is

  component bank_of_registers
    port (clk      : in  std_logic;
          rst      : in  std_logic;
          wr_en    : in  std_logic;
          addr_wr  : in  std_logic_vector(2 downto 0);
          data_in  : in  unsigned(15 downto 0);
          data_out : out unsigned(15 downto 0)
         );
  end component;

  component accumulator_reg
    port (clk      : in  std_logic;
          rst      : in  std_logic;
          wr_en    : in  std_logic;
          data_in  : in  unsigned(15 downto 0);
          data_out : out unsigned(15 downto 0)
         );
  end component;

  signal bank_data_out : unsigned(15 downto 0);

begin

  bank: bank_of_registers
    port map (
      clk      => clk,
      rst      => rst,
      wr_en    => wr_en,
      addr_wr  => addr_wr,
      data_in  => data_in,
      data_out => bank_data_out
    );

  acc: accumulator_reg
    port map (
      clk      => clk,
      rst      => rst,
      wr_en    => wr_en,
      data_in  => bank_data_out,
      data_out => data_out
    );

  data_out <= bank_data_out;

end architecture;
