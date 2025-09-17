library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity mux is
  port (
    mux_in0 : in  std_logic_vector(15 downto 0);
    mux_in1 : in  std_logic_vector(15 downto 0);
    mux_in2 : in  std_logic_vector(15 downto 0);
    mux_in3 : in  std_logic_vector(15 downto 0);
    sel     : in  std_logic_vector(1 downto 0);
    out_mux : out std_logic_vector(15 downto 0)
  );
end entity;

architecture a_mux of mux is
begin
  out_mux <= mux_in0 when sel = "00" else -- adicao
             mux_in1 when sel = "01" else -- subtracao
             mux_in2 when sel = "10" else -- and
             mux_in3 when sel = "11" else -- or
               (others => '0');
end architecture;