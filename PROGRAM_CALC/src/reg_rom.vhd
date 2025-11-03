library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity reg_rom is
  port (clk      : in  std_logic;
        rst      : in  std_logic;
        wr_en    : in  std_logic;
        data_from_rom  : in  unsigned(14 downto 0);
        data_out : out unsigned(14 downto 0)
       );
end entity;

architecture a_reg_rom of reg_rom is
  signal registro : unsigned(14 downto 0);
begin
  process (clk, rst) -- acionado se houver mudança em clk ou rst
  begin
    if rst = '1' then
      registro <= (others => '0');
    elsif rising_edge(clk) then
      if wr_en = '1' then
        registro <= data_from_rom;
      end if;
    end if;
  end process;

  data_out <= registro;
end architecture;
