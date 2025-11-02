library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level_tb is
end entity;


architecture a_top_level_tb of top_level_tb is
  component top_level is
    port (
      clk         : in  std_logic;
      rst       : in  std_logic
      );
  end component;

  signal clk         : std_logic := '0';
  signal reset       : std_logic := '0';

  constant period_time : time := 100 ns;
  signal finished : std_logic := '0';


begin

    uut: top_level port map(
      clk         => clk,
      rst       => reset

    );

    -- Clock process
    clk_process: process
    begin
      while finished /= '1' loop
        clk <= '0';
        wait for period_time/2;
        clk <= '1';
        wait for period_time/2;
      end loop;
      wait;
    end process;
  
    stimulus: process
    begin
      -- Teste 1: Reset inicial (garante estado inicial)
      report "Iniciando Teste 1: Reset inicial";
      reset <= '1';
      wait for period_time * 3;
      -- Esperado: PC = 0, State Machine = 0
      
      -- Teste 2: Libera reset e observa contagem do PC
      report "Iniciando Teste 2: Operação normal - PC incrementando";
      reset <= '0';
      wait for period_time * 20;
     
      -- Teste 3: Verifica execução das instruções na ROMme
      report "Iniciando Teste 3: Verificando instruções da ROM";
      wait for period_time * 5;
    
      -- Teste 4: Continua até endereços sem instrução (zeros)
      report "Iniciando Teste 4: Endereços vazios (após endereço 10)";
      wait for period_time * 10;
     
      -- Teste 5: Reset durante execução
      report "Iniciando Teste 5: Reset durante execução";
      reset <= '1';
      wait for period_time * 2;
      -- Esperado: PC volta para 0
      
      -- Teste 6: Retoma execução normal
      report "Iniciando Teste 6: Retomada após reset";
      reset <= '0';
      wait for period_time * 15;
      -- Esperado: PC recomeça de 0 e incrementa novamente
      
      -- Teste 7: Pulso curto de reset
      report "Iniciando Teste 7: Pulso curto de reset";
      reset <= '1';
      wait for period_time;
      reset <= '0';
      wait for period_time * 10;
      -- Esperado: PC reseta e volta a contar
      
      -- Teste 8: Deixa executar por tempo prolongado
      report "Iniciando Teste 8: Execução prolongada";
      wait for period_time * 30;
      -- Esperado: PC continua incrementando até atingir valores altos
      
      -- Finaliza simulação
      report "Finalizando simulação";
      finished <= '1';
      wait;
    end process;
        
  end architecture;