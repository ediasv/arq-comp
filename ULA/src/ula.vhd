library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula is
    port (
        in0, in1 : in  std_logic_vector(15 downto 0);
        op       : in  std_logic_vector(1 downto 0); -- 00 for 'add', 01 for 'sub', 10 for 'and', 11 for 'or'
        ula_out  : out std_logic_vector(15 downto 0)
    );
end entity;

architecture a_ula of ula is
  component mux
    port (
      mux_in0 : in  std_logic_vector(15 downto 0);
      mux_in1 : in  std_logic_vector(15 downto 0);
      mux_in2 : in  std_logic_vector(15 downto 0);
      mux_in3 : in  std_logic_vector(15 downto 0);
      sel     : in  std_logic_vector(1 downto 0);
      out_mux : out std_logic_vector(15 downto 0)
    );
  end component;

  signal mux_in_sum, mux_in_sub, mux_in_and, mux_in_or: std_logic_vector(15 downto 0);
begin
  mux_in_sum <= std_logic_vector(signed(in0) + signed(in1));
  mux_in_sub <= std_logic_vector(signed(in0) - signed(in1));
  mux_in_and <= in0 and in1;
  mux_in_or  <= in0 or in1;

  mux_inst: mux
    port map(mux_in0 => mux_in_sum,
             mux_in1 => mux_in_sub,
             mux_in2 => mux_in_and,
             mux_in3 => mux_in_or,
             sel     => op,
             out_mux => ula_out);
end architecture;
