library ieee;
use ieee.std_logic_1164.all;
ieee.numeric_std.all

entity ula is
    port( 
        in0,in1: in unsigned(15 downto 0);  
        op: in unsigned (1 downto 0) ; -- operator to be displayed chosen by user
        ula_out: out unsigned (15 downto 0);  
    );
end entity;

architecture a_ula of ula is
      
        component add
        port(   
            add_in0 : in  unsigned(15 downto 0);
            add_in1 : in  unsigned(15 downto 0);
            out_add : out unsigned(15 downto 0)  
        )
         end component;
         signal out_add : unsigned(15 downto 0);

         component sub
         port(   
             sub_in0 : in  unsigned(15 downto 0);
             sub_in1 : in  unsigned(15 downto 0);
             out_sub : out unsigned(15 downto 0)  
         )
          end component;
          signal out_sub : unsigned(15 downto 0);


          component and
          port(   
              and_in0 : in  unsigned(15 downto 0);
              and_in1 : in  unsigned(15 downto 0);
              out_and : out unsigned(15 downto 0)  
          )
           end component;
           signal out_and : unsigned(15 downto 0);

          component or
          port(   
              or_in0 : in  unsigned(15 downto 0);
              or_in1 : in  unsigned(15 downto 0);
              out_or : out unsigned(15 downto 0)  
          )
           end component;
           signal out_or : unsigned(15 downto 0);

           component mux
           port(   
            mux_in0 : in  unsigned(15 downto 0);
            mux_in1 : in  unsigned(15 downto 0);
            mux_in2 : in  unsigned(15 downto 0);
            mux_in3 : in  unsigned(15 downto 0);
            sel     : in  unsigned(1 downto 0) ; 
            out_mux : out unsigned(15 downto 0)  
            )
       
            end component;
    
begin
     
        add_inst: add port map(
            add_in0 => in0 ,
            add_in1 => in1 ,
            out_add => out_add ,
        )

        sub_inst: sub port map(
            sub_in0 => in0 ,
            sub_in1 => in1 ,
            out_sub => out_sub ,
        )

        and_inst: and port map(
            and_in0 => in0 ,
            and_in1 => in1 ,
            out_and => out_and ,
        )

        or_inst: or port map(
            or_in0 => in0 ,
            or_in1 => in1 ,
            out_or => out_or ,
        )

        mux_inst: mux port map(
            mux_in0 => out_add ,
            mux_in1 => out_sub ,
            mux_in2 => out_and ,
            mux_in3 => out_or  ,
            sel     => op      ,
            out_mux => ula_out ,
        )


end architecture;
