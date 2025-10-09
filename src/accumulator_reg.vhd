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

  signal acc_input : unsigned(15 downto 0);
  signal acc_value : unsigned(15 downto 0);

begin
  -- Calculate next accumulator value
  acc_input <= acc_value + data_in when wr_en = '1' else acc_value;

  reg_acc: reg16bits
    port map (
      clk      => clk,
      rst      => rst,
      wr_en    => '1',  -- Always write to capture the accumulator state
      data_in  => acc_input,
      data_out => acc_value
    );

  data_out <= acc_value;

end architecture;
