library ieee;
use ieee.std_logic_1164.all;
ieee.numeric_std.all

entity ula is
    port( 
        in0,in1: in unsigned(15 downto 0); --16 bits cada entrada 
        op: in unsigned (1 downto 0) ; -- entrada do usuário para escolher a operação
        e_out: out unsigned (15 downto 0);
    );
end entity;

architecture a_ula of ula is
       component mux8bits
       port(   
        mux_in0 : in  unsigned(15 downto 0);
        mux_in1 : in  unsigned(15 downto 0);
        mux_in2 : in  unsigned(15 downto 0);
        mux_in3 : in  unsigned(15 downto 0);
        sel   : in  unsigned(1 downto 0); -- bits de seleção num só bus
        saida : out unsigned(15 downto 0)  -- lembre: sem ';' aqui
        )
   
        end component;
        signal mux_in0, mux_in1,mux_in2,mux_in3, saida: unsigned(15 downto 0);
        signal sel : unsigned(1 downto 0);
        
begin
        -- sel <= op;
        mux8bits_inst: mux8bits port map(
            mux_in0 => mux_in0 ,
            mux_in1 => mux_in1 ,
            mux_in2 => mux_in2 ,
            mux_in3 => mux_in3 ,
            sel     => op      ,
            saida   => saida   ,
        )


    mux


    soma <= in0 + in1;
    subt<= in0 - in1;





end architecture;
