library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity top_level is
   port( clk        : in std_logic;
         rst        : in std_logic;
         wr_en      : in std_logic;
         addr_wr    : in unsigned(2 downto 0); 
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
            addr_rd   : in unsigned(2 downto 0);
            data_in    : in unsigned(7 downto 0);
            data_out  : out unsigned(7 downto 0)
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

   
   component ula -- Unidade Lógica e Aritmética
   port( a        : in unsigned(7 downto 0);
   b        : in unsigned(7 downto 0);
   result   : out unsigned(7 downto 0)
   );
   end component;
   
   signal bank_data_out: unsigned(7 downto 0);
   signal acummulator_out: unsigned(7 downto 0);

   begin 
      bank_inst: bank_of_registers
         port map(
            clk       => clk,
            rst       => rst,
            wr_en     => wr_en,
            addr_wr   => addr_wr,
            addr_rd  => addr_rd1,
            data_in   => data_in,
            data_out => bank_data_out1,
         );

         
         acc_inst: accumulator_reg
         port map(
            clk      => clk,
            rst      => rst,
            wr_en    => wr_en,
            data_in  => acc_data_out,
            data_out => acc_data_out
            );
            
            data_out1 <= bank_data_out;
            data_out2 <= acummulator_out;
            
            
            ula_inst: ula
               port map(
                  a      => data_out1,
                  b      => data_out2,
                  result => ula_data_out
               );


end architecture;