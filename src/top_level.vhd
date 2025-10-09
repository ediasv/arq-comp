library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity top_level is
  port (clk              : in  std_logic;
        rst              : in  std_logic;
        wr_en            : in  std_logic;
        acc_en           : in  std_logic;
        op_with_constant : in  std_logic;
        addr_wr          : in  std_logic_vector(2 downto 0); -- 3 bits para 8 registradores
        data_in          : in  unsigned(15 downto 0);
        data_out         : out unsigned(15 downto 0);
        ula_op           : in  std_logic_vector(1 downto 0);
        ula_zero         : out std_logic;
        ula_sig          : out std_logic
       );
end entity;

architecture a_top_level of top_level is

  component bank_of_registers
    port (clk      : in  std_logic;
          rst      : in  std_logic;
          wr_en    : in  std_logic;
          addr_wr  : in  std_logic_vector(2 downto 0);
          data_in  : in  unsigned(15 downto 0);
          data_out : out unsigned(15 downto 0)
         );
  end component;

  component accumulator_reg
    port (clk      : in  std_logic;
          rst      : in  std_logic;
          wr_en    : in  std_logic;
          data_in  : in  unsigned(15 downto 0);
          data_out : out unsigned(15 downto 0)
         );
  end component;

  component ula
    port (
      in0, in1  : in  std_logic_vector(15 downto 0);
      op        : in  std_logic_vector(1 downto 0);
      ula_out   : out std_logic_vector(15 downto 0);
      zero, sig : out std_logic
    );
  end component;

  signal bank_data_out    : unsigned(15 downto 0);
  signal acc_data_out     : unsigned(15 downto 0);
  signal ula_out          : std_logic_vector(15 downto 0);
  signal ula_in0, ula_in1 : std_logic_vector(15 downto 0);
begin

  bank: bank_of_registers
    port map (
      clk      => clk,
      rst      => rst,
      wr_en    => wr_en,
      addr_wr  => addr_wr,
      data_in  => unsigned(ula_out),
      data_out => bank_data_out
    );

  acc: accumulator_reg
    port map (
      clk      => clk,
      rst      => rst,
      wr_en    => acc_en,
      data_in  => unsigned(ula_out),
      data_out => acc_data_out
    );

  ula_inst: ula
    port map (
      in0     => ula_in0,
      in1     => ula_in1,
      op      => ula_op,
      ula_out => ula_out,
      zero    => ula_zero,
      sig     => ula_sig
    );

  data_out <= unsigned(ula_out);
  ula_in0  <= std_logic_vector(acc_data_out);
  ula_in1  <= std_logic_vector(bank_data_out) when op_with_constant = '0' else
              std_logic_vector(data_in);

end architecture;
