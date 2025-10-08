library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bank_of_registers_tb is 
end entity;

architecture a_bank_of_registers_tb of bank_of_registers_tb is
    
   component bank_of_registers
      port( clk        : in std_logic;
            rst        : in std_logic;
            wr_en      : in std_logic;
            addr_wr    : in unsigned(2 downto 0); -- 3 bits para 8 registradores
            addr_rd   : in unsigned(2 downto 0);
            data_in    : in unsigned(7 downto 0);
            data_out  : out unsigned(7 downto 0)
      );
   end component;

   signal clk       : std_logic := '0';
   signal rst       : std_logic := '1';
   signal wr_en     : std_logic := '0';
   signal addr_wr   : unsigned(2 downto 0) := (others => '0');
   signal addr_rd   : unsigned(2 downto 0) := (others => '0');
   signal data_in   : unsigned(7 downto 0) := (others => '0');
   signal data_out  : unsigned(7 downto 0);

    process    -- sinal de clock
    begin
        clk <= '0';
        wait for 50 ns;
        clk <= '1';
        wait for 50 ns;
    end process;
    
    process    -- sinal de reset
    begin
        rst <= '1';
        wait for 100 ns;
        rst <= '0';
        wait;
    end process;
   constant clk_period: time := 10 ns;



    begin
        bank_inst: bank_of_registers
            port map(
                clk      => clk,
                rst      => rst,
                wr_en    => wr_en,
                addr_wr  => addr_wr,
                addr_rd  => addr_rd,
                data_in  => data_in,
                data_out => data_out
            );
    process
    begin
    --------------------------------------------------------
        wait for clk_period*2;
        wr_en <= '1';
        addr_wr <= "000"; -- Registrador 0
        data_in <= "00000001"; -- Dado 1
        wait for clk_period*2;
        
        addr_wr <= "001"; -- Registrador 1
        data_in <= "00000010"; -- Dado 2
        wait for clk_period*2;
        
        addr_wr <= "010"; -- Registrador 2
        data_in <= "00000011"; -- Dado 3
        wait for clk_period*2;
        
        addr_wr <= "011"; -- Registrador 3
        data_in <= "00000100"; -- Dado 4
        wait for clk_period*2;
        
        addr_wr <= "100"; -- Registrador 4
        data_in <= "00000101"; -- Dado 5
        wait for clk_period*2;
        
        addr_wr <= "101"; -- Registrador 5
        data_in <= "00000110"; -- Dado 6
        wait for clk_period*2;
        
        addr_wr <= "110"; -- Registrador 6
        data_in <= "00000111"; -- Dado 7
        wait for clk_period*2;
        
        addr_wr <= "111"; -- Registrador 7
        data_in <= "00001000"; -- Dado 8
        wait for clk_period*2;
        
        wr_en <= '0'; -- Desabilita escrita
        
        addr_rd <= "000"; -- Lê do Registrador 0
        wait for clk_period*2;
        
        addr_rd <= "001"; -- Lê do Registrador 1
        wait for clk_period*2;
        
        addr_rd <= "010"; -- Lê do Registrador 2
        wait for clk_period*2;
        
        addr_rd <= "011"; -- Lê do Registrador 3
        wait for clk_period*2;
        
        addr_rd <= "100"; -- Lê do Registrador 4
        wait for clk_period*2;
        
        addr_rd <= "101"; -- Lê do Registrador 5
        wait for clk_period*2;
        
        addr_rd <= "110"; -- Lê do Registrador 6
        wait for clk_period*2;
        
        addr_rd <= "111"; --


        wait;
        end process;

end architecture;