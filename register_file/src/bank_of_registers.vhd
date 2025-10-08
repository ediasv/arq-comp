library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bank_of_registers is
   port( clk        : in std_logic;
         rst        : in std_logic;
         wr_en      : in std_logic;
         addr_wr    : in unsigned(2 downto 0); -- 3 bits para 8 registradores
         addr_rd1   : in unsigned(2 downto 0);
         addr_rd2   : in unsigned(2 downto 0);
         data_in    : in unsigned(7 downto 0);
         data_out1  : out unsigned(7 downto 0);
         data_out2  : out unsigned(7 downto 0)
   );
end entity;

architecture a_bank_of_registers of bank_of_registers is

   -- Declaracao dos 8 registradores de 8 bits
   component reg8bits
      port( clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(7 downto 0);
            data_out : out unsigned(7 downto 0)
      );
   end component;

   signal reg_array: array(0 to 7) of unsigned(7 downto 0); -- array de sinais para os registradores
   signal wr_signals: array(0 to 7) of std_logic; -- sinais de escrita para cada registrador

   gen_regs: for i in 0 to 7 generate
      reg_i: reg8bits
         port map(
            clk      => clk,
            rst      => rst,
            wr_en    => wr_signals(i),
            data_in  => data_in,
            data_out => reg_array(i)
         );
   end generate;

end architecture;end architecture;