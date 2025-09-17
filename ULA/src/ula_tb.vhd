library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end entity;

architecture a_ula_tb of ula_tb is
  component ula
    port (
      in0, in1 : in  unsigned(15 downto 0);
      op       : in  unsigned(1 downto 0);
      ula_out  : out unsigned(15 downto 0)
    );
  end component;

  signal in0, in1 : unsigned(15 downto 0);
  signal op       : unsigned(1 downto 0);
  signal ula_out  : unsigned(15 downto 0);
begin
  ula_inst: ula
    port map (
      in0     => in0,
      in1     => in1,
      op      => op,
      ula_out => ula_out
    );

  process
  begin
    --------------------------------------------------------
    -- addition
    op  <= "00";

    -- sum of two positive integers
    in0 <= to_unsigned(10, 16);
    in1 <= to_unsigned(5, 16);
    wait for 50 ns;

    -- sum of a positive and a negative integer
    in0 <= to_unsigned(-15, 16);
    in1 <= to_unsigned(5, 16);
    wait for 50 ns;

    -- sum of a positive and a negative integer
    in0 <= to_unsigned(-15, 16);
    in1 <= to_unsigned(5, 16);
    wait for 50 ns;

    -- sum of two negative integers
    in0 <= to_unsigned(-10, 16);
    in1 <= to_unsigned(-5, 16);
    wait for 50 ns;

    -- sum resulting in overflow
    in0 <= to_unsigned(32760, 16);
    in1 <= to_unsigned(10, 16);
    wait for 50 ns;

    --------------------------------------------------------
    -- subtraction
    op  <= "01"; -- sub

    -- subtraction of two positive integers
    in0 <= to_unsigned(20, 16);
    in1 <= to_unsigned(7, 16);
    wait for 50 ns;

    -- subtraction resulting in negative
    in0 <= to_unsigned(5, 16);
    in1 <= to_unsigned(10, 16);
    wait for 50 ns;

    -- subtraction resulting in overflow
    in0 <= to_unsigned(-32760, 16);
    in1 <= to_unsigned(10, 16);
    wait for 50 ns;

    -- subtraction of two negative integers
    in0 <= to_unsigned(-20, 16);
    in1 <= to_unsigned(-7, 16);
    wait for 50 ns;

    --------------------------------------------------------
    -- AND
    op  <= "10";

    in0 <= x"00FF";
    in1 <= x"0F0F";
    wait for 50 ns;

    --------------------------------------------------------
    -- OR
    op  <= "11";
    
    in0 <= x"00F0";
    in1 <= x"0F00";
    wait for 50 ns;

    wait;
  end process;
end architecture a_ula_tb;