library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity proto_uc_tb is
end entity;

architecture a_proto_uc_tb of proto_uc_tb is

  component proto_uc
    port (uc_data_in : in  unsigned(14 downto 0);
          jump_en    : out std_logic
         );
  end component;

  -- Signals for testing
  signal uc_data_in : unsigned(14 downto 0) := (others => '0');
  signal jump_en    : std_logic             := '0';

begin

  -- Instantiate Unit Under Test (UUT)
  uut: proto_uc
    port map (
      uc_data_in => uc_data_in,
      jump_en    => jump_en
    );

  -- Test process
  stimulus: process
  begin

    -- Test 1: Jump Enable (opcode = 1111)
    uc_data_in <= "111111111111111"; -- All bits high
    wait for 10 ns;

    uc_data_in <= "111100000000000"; -- Lower bits = 0
    wait for 10 ns;

    uc_data_in <= "111110101010101"; -- Alternating lower bits
    wait for 10 ns;

    -- Test 2: Jump Disable (opcode != 1111)
    uc_data_in <= "000000000000000"; -- Opcode = 0000
    wait for 10 ns;

    uc_data_in <= "000111111111111"; -- Opcode = 0001
    wait for 10 ns;

    uc_data_in <= "011111111111111"; -- Opcode = 0111
    wait for 10 ns;

    uc_data_in <= "101111111111111"; -- Opcode = 1011
    wait for 10 ns;

    uc_data_in <= "110111111111111"; -- Opcode = 1101
    wait for 10 ns;

    uc_data_in <= "111011111111111"; -- Opcode = 1110
    wait for 10 ns;

    -- Test 3: Exhaustive Opcodes (0000 to 1111)
    for i in 0 to 15 loop
      uc_data_in <= to_unsigned(i, 4) & "10101010101";
      wait for 10 ns;
    end loop;

    -- Test 4: Edge Cases
    uc_data_in <= "111111111111111"; -- Enabled
    wait for 10 ns;

    uc_data_in <= "111011111111111"; -- Disabled
    wait for 10 ns;

    uc_data_in <= "000000000000000"; -- Disabled
    wait for 10 ns;

    uc_data_in <= "111100000000000"; -- Enabled
    wait for 10 ns;

    -- Test 5: Lower Bits Independence
    uc_data_in <= "000000000000000"; -- All zeros
    wait for 10 ns;

    uc_data_in <= "000011111111111"; -- Lower bits all 1
    wait for 10 ns;

    uc_data_in <= "000010101010101"; -- Alternating lower bits
    wait for 10 ns;

    wait;
  end process;

end architecture;
