----------------------------------------------------------------------
----                                                              ----
---- Parallel Scrambler.                                              
----                                                              ----
---- This file is part of the Configurable Parallel Scrambler project 
---- http://opencores.org/project,parallel_scrambler              ----
----                                                              ----
---- Description                                                  ----
---- Test bench for Parallel scrambler/descrambler module         ----
----                                                              ----
----                                                              ----
---- License: LGPL                                                ----
---- -                                                            ----
----                                                              ----
---- Author(s):                                                   ----
---- - Howard Yin, sparkish@opencores.org                         ----
----                                                              ----
----------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_par_scram is
end tb_par_scram;

architecture behavior of tb_par_scram is

  -- Component Declaration for the Unit Under Test (UUT)

  component par_scrambler
    generic (
      Data_Width : integer;
      Polynomial_Order : integer
    );
    port (
      rst, clk : in std_logic;
      scram_rst : in std_logic;
      Polynomial : in std_logic_vector(Polynomial_Order downto 0);
      data_in : in std_logic_vector(Data_Width - 1 downto 0);
      scram_en : in std_logic;
      data_out : out std_logic_vector(Data_Width - 1 downto 0);
      out_valid : out std_logic
    );
  end component;

  constant DATA_W : integer := 20;
  constant POLY_ORDER : integer := 9;
  constant poly : std_logic_vector(POLY_ORDER downto 0) := "1000010001"; -- (De)scrambler G2(X)=x^9+x^4+1

  --Inputs
  signal data_in : std_logic_vector(DATA_W - 1 downto 0) := (others => '0');
  signal scram_en : std_logic := '0';
  signal scram_start : std_logic := '0';
  signal rst : std_logic := '1';
  signal clk : std_logic := '0';

  --Outputs
  signal scram_data_out : std_logic_vector(DATA_W - 1 downto 0);
  signal descram_data_out : std_logic_vector(DATA_W - 1 downto 0);
  signal scram_data_valid : std_logic;
  signal descram_data_valid : std_logic;

  -- Clock period definitions
  constant clk_period : time := 20 ns;

begin

  -- Instantiate the Unit Under Test (UUT)
  scram_mod : par_scrambler
  generic map(
    Data_Width => DATA_W,
    Polynomial_Order => POLY_ORDER
  )
  port map(
    Polynomial => poly,
    data_in => data_in,
    scram_en => scram_en,
    scram_rst => scram_start,
    rst => rst,
    clk => clk,
    data_out => scram_data_out,
    out_valid => scram_data_valid
  );

  descram_mod : par_scrambler
  generic map(
    Data_Width => DATA_W,
    Polynomial_Order => POLY_ORDER
  )
  port map(
    Polynomial => poly,
    data_in => scram_data_out,
    scram_en => scram_data_valid,
    scram_rst => scram_start,
    rst => rst,
    clk => clk,
    data_out => descram_data_out,
    out_valid => descram_data_valid
  );

  -- Clock process definitions
  clk_process : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;

  -- Stimulus process
  stim_proc : process
  begin
    -- hold reset state for 100 ns.
    rst <= '1';
    wait for 90 ns;
    rst <= '0';
    wait for clk_period * 10;
    scram_start <= '1';
    wait for clk_period;
    scram_start <= '0';
    wait for clk_period * 10;

    report "start of test" severity note;

    for i in 0 to DATA_W - 1 loop
      wait until (rising_edge(clk));
      scram_en <= '1';
      data_in <= std_logic_vector(to_unsigned(i, DATA_W));
      --assert data_in report "data in" severity note;
    end loop;
    wait until (rising_edge(clk));
    scram_en <= '0';

    wait for clk_period * 10;

    for i in 0 to DATA_W - 1 loop
      wait until (rising_edge(clk));
      scram_en <= '1';
      data_in <= std_logic_vector(to_unsigned(i, DATA_W));
      wait until (rising_edge(clk));
      scram_en <= '0';
      wait for clk_period * 10;
    end loop;

    assert false report "end of test" severity note;
    wait;
  end process;

end architecture;