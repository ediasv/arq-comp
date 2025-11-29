library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity bank_of_registers is
  port (clk         : in  std_logic;
        rst         : in  std_logic;
        wr_en       : in  std_logic;
        addr_dest   : in  unsigned(3 downto 0);
        addr_source : in  unsigned(3 downto 0);
        data_in     : in  unsigned(15 downto 0);
        data_out    : out unsigned(15 downto 0);
        primo       : out unsigned(15 downto 0);
        debug       : out unsigned(15 downto 0); -- Sinal de debug para monitorar o valor de R7
        eh_primo    : out unsigned(15 downto 0)  -- sinal que indica se o numero dado é primo (R6)
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
  signal regs_data_out : reg_array_type           := (others => (others => '0'));
  signal wr_en_array   : std_logic_vector(0 to 7) := (others => '0');
  signal debug_signal  : unsigned(15 downto 0)    := (others => '0');
  signal eh_primo_sig  : unsigned(15 downto 0)    := (others => '0');
  signal primo_sig     : unsigned(15 downto 0)    := (others => '0');
begin

  wr_en_array(0) <= '1' when (wr_en = '1' and addr_dest = "0000") else '0';
  wr_en_array(1) <= '1' when (wr_en = '1' and addr_dest = "0001") else '0';
  wr_en_array(2) <= '1' when (wr_en = '1' and addr_dest = "0010") else '0';
  wr_en_array(3) <= '1' when (wr_en = '1' and addr_dest = "0011") else '0';
  wr_en_array(4) <= '1' when (wr_en = '1' and addr_dest = "0100") else '0';
  wr_en_array(5) <= '1' when (wr_en = '1' and addr_dest = "0101") else '0';
  wr_en_array(6) <= '1' when (wr_en = '1' and addr_dest = "0110") else '0';
  wr_en_array(7) <= '1' when (wr_en = '1' and addr_dest = "0111") else '0';

  gen_regs: for i in 0 to 7 generate
    reg_inst: reg16bits
      port map (
        clk      => clk,
        rst      => rst,
        wr_en    => wr_en_array(i),
        data_in  => data_in,
        data_out => regs_data_out(i)
      );
  end generate;

  with addr_source select
    data_out <= regs_data_out(0)    when "0000",
                regs_data_out(1)    when "0001",
                regs_data_out(2)    when "0010",
                regs_data_out(3)    when "0011",
                regs_data_out(4)    when "0100",
                regs_data_out(5)    when "0101",
                regs_data_out(6)    when "0110",
                regs_data_out(7)    when "0111",
                    (others => '0') when others;

  debug_signal <= regs_data_out(7); -- R7 para debug
  eh_primo_sig <= regs_data_out(6); -- R6 indica se o numero é primo
  primo_sig    <= regs_data_out(4);

  debug    <= debug_signal; -- R7 como sinal de debug
  eh_primo <= eh_primo_sig; -- R6 como sinal de primo
  primo    <= primo_sig;    -- R4 como sinal primo
end architecture;
