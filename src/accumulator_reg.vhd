library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity accumulator_reg is
  port (clk      : in  std_logic;
        rst      : in  std_logic;
        wr_en    : in  std_logic;
        data_in  : in  unsigned(15 downto 0);
        data_out : out unsigned(15 downto 0)
       );
end entity;

architecture a_accumulator_reg of accumulator_reg is
  component reg16bits
    port (clk      : in  std_logic;
          rst      : in  std_logic;
          wr_en    : in  std_logic;
          data_in  : in  unsigned(15 downto 0);
          data_out : out unsigned(15 downto 0)
         );
  end component;

begin
  reg_acc: reg16bits
    port map (
      clk      => clk,
      rst      => rst,
      wr_en    => wr_en,
      data_in  => data_in,
      data_out => data_out
    );

  data_out <= data_out + data_in when wr_en = '1' else data_out;

end architecture;
