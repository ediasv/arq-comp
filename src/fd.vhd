library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ula_tb is
end entity;

architecture a_ula_tb of ula_tb is
  component ula
    port (
      in0, in1 : in  std_logic_vector(15 downto 0);
      op       : in  std_logic_vector(1 downto 0);
      ula_out  : out std_logic_vector(15 downto 0)
    );
  end component;

  signal in0: std_logic_vector(15 downto 0) := (others => '0');
  signal in1: std_logic_vector(15 downto 0) := (others => '0');
  signal op       : std_logic_vector(1 downto 0) := (others => '0');
  signal ula_out  : std_logic_vector (15 downto 0);
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
    
    -- sum of two positive integers
    in0 <= std_logic_vector(to_signed(10, 16));
    in1 <= std_logic_vector(to_signed(5, 16));
    op  <= "00";
    wait for 50 ns;

    -- sum of a positive and a negative integer
    in0 <= std_logic_vector(to_signed(-15, 16));
    in1 <= std_logic_vector(to_signed(5, 16));
    op  <= "00";
    wait for 50 ns;

    -- sum of two negative integers
    in0 <= std_logic_vector(to_signed(-10, 16));
    in1 <= std_logic_vector(to_signed(-5, 16));
    op  <= "00";
    wait for 50 ns;

    -- sum resulting in overflow
    in0 <= std_logic_vector(to_signed(32760, 16));
    in1 <= std_logic_vector(to_signed(10, 16));
    op  <= "00";
    wait for 50 ns;

    --------------------------------------------------------
    -- subtraction
    -- sub

    -- subtraction of two positive integers
    in0 <= std_logic_vector(to_signed(20, 16));
    in1 <= std_logic_vector(to_signed(7, 16));
    op  <= "01";
    wait for 50 ns;

    -- subtraction resulting in negative
    in0 <= std_logic_vector(to_signed(5, 16));
    in1 <= std_logic_vector(to_signed(10, 16));
    op  <= "01";
    wait for 50 ns;

    -- subtraction resulting in overflow
    in0 <= std_logic_vector(to_signed(-32760, 16));
    in1 <= std_logic_vector(to_signed(10, 16));
    op  <= "01";
    wait for 50 ns;

    -- subtraction of two negative integers
    in0 <= std_logic_vector(to_signed(-20, 16));
    in1 <= std_logic_vector(to_signed(-7, 16));
    op  <= "01";
    wait for 50 ns;

    --------------------------------------------------------
    -- AND
  

    in0 <= x"00FF";
    in1 <= x"0F0F";
    op  <= "10";
    wait for 50 ns;

    --------------------------------------------------------
    -- OR
    
    
    in0 <= x"00F0";
    in1 <= x"0F00";
    op  <= "11";
    wait for 50 ns;

    wait;
  end process;
end architecture a_ula_tb;