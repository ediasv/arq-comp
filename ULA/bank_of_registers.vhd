library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity bank_of_registers is
  port (clk         : in  std_logic;
        rst         : in  std_logic;
        wr_en       : in  std_logic;
        addr_dest   : in  std_logic_vector(2 downto 0);
        addr_source : in  std_logic_vector(2 downto 0); 
        data_in     : in  unsigned(15 downto 0);
        data_out    : out unsigned(15 downto 0)
       );
end entity;

architecture a_bank_of_registers of bank_of_registers is

  component reg16bits
    port (clk      : in  std_logic;
          rst      : in  std_logic;
          wr_en    : in  std_logic;
          data_in  : in  unsigned(15 downto 0);
          data_out : out unsigned(15 downto 0)
         );
  end component;

  type reg_array_type is array (0 to 7) of unsigned(15 downto 0);
  signal regs_data_out : reg_array_type;
  signal wr_en_array   : std_logic_vector(0 to 7) := (others => '0');

begin

  wr_en_array(0) <= '1' when (wr_en = '1' and addr_dest = "000") else '0';
  wr_en_array(1) <= '1' when (wr_en = '1' and addr_dest = "001") else '0';
  wr_en_array(2) <= '1' when (wr_en = '1' and addr_dest = "010") else '0';
  wr_en_array(3) <= '1' when (wr_en = '1' and addr_dest = "011") else '0';
  wr_en_array(4) <= '1' when (wr_en = '1' and addr_dest = "100") else '0';
  wr_en_array(5) <= '1' when (wr_en = '1' and addr_dest = "101") else '0';
  wr_en_array(6) <= '1' when (wr_en = '1' and addr_dest = "110") else '0';
  wr_en_array(7) <= '1' when (wr_en = '1' and addr_dest = "111") else '0';

  gen_regs: for i in 0 to 7 generate
    reg_inst: reg16bits
      port map (
        clk      => clk,
        rst      => rst,
        wr_en    => wr_en_array(i),
        data_in  => data_in,
        data_out => regs_data_out(i)
      );
  end generate gen_regs;

  with addr_source select
    data_out <= regs_data_out(0) when "000",
                regs_data_out(1) when "001",
                regs_data_out(2) when "010",
                regs_data_out(3) when "011",
                regs_data_out(4) when "100",
                regs_data_out(5) when "101",
                regs_data_out(6) when "110",
                regs_data_out(7) when "111",
                (others => '0')  when others;

end architecture;
