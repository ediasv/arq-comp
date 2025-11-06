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
  signal acc_value : unsigned(15 downto 0) := (others => '0');
begin

  process (clk, rst) -- acionado se houver mudança em clk ou rst
  begin
    if rst = '1' then
      acc_value <= (others => '0');
    elsif rising_edge(clk) then
      if wr_en = '1' then
        acc_value <= data_in;
      end if;
    end if;
  end process;

  data_out <= acc_value;

end architecture;
