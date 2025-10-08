library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity top_level is
   port( clk        : in std_logic;
         rst        : in std_logic;
         wr_en      : in std_logic;
         addr_wr    : in unsigned(2 downto 0); -- 3 bits para 8 registradores
         addr_rd1   : in unsigned(2 downto 0);
         addr_rd2   : in unsigned(2 downto 0);
         data_in    : in unsigned(7 downto 0);
         data_out1  : out unsigned(7 downto 0);
         data_out2  : out unsigned(7 downto 0);
         acc_data_out : out unsigned(7 downto 0)
   );
end entity;

architecture a_top_level of top_level is

   component bank_of_registers
      port( clk        : in std_logic;
            rst        : in std_logic;
            wr_en      : in std_logic;
            addr_wr    : in unsigned(2 downto 0);
            addr_rd1   : in unsigned(2 downto 0);
            addr_rd2   : in unsigned(2 downto 0);
            data_in    : in unsigned(7 downto 0);
            data_out1  : out unsigned(7 downto 0);
            data_out2  : out unsigned(7 downto 0)
      );
   end component;

   component accumulator_reg
      port( clk      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in unsigned(7 downto 0);
            data_out : out unsigned(7 downto 0)
      );
   end component;

   signal bank_data_out1: unsigned(7 downto 0);
   signal bank_data_out2: unsigned(7 downto 0);

end architecture;