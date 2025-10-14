library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity program_counter is
    port (
          clk      : in  std_logic;
          wr_en    : in  std_logic;
          data_in  : in std_logic;
          data_out : out  std_logic
         );
  end entity;
  
  architecture a_program_counter of program_counter is
    signal pc_value : std_logic := '0';
  begin
      process (clk)
      begin
         if rising_edge(clk) then
              if wr_en = '1' then
                  pc_value <= data_in + '1';
              end if;
          end if;
      end process;
      
      data_out <= pc_value;
  end architecture;