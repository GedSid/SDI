library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sdi_ip_loop_tb is
end entity;

architecture behavior of sdi_ip_loop_tb is
	component sdi_ip_loop is
			port (
				tx_rst                  : in  std_logic                      := '0';             --                  tx_rst.reset
				tx_datain               : in  std_logic_vector(19 downto 0)  := (others => '0'); --               tx_datain.export
				tx_datain_valid         : in  std_logic                      := '0';             --         tx_datain_valid.export
				tx_trs                  : in  std_logic                      := '0';             --                  tx_trs.export
				tx_dataout_valid        : out std_logic;                                         --        tx_dataout_valid.export
				tx_pclk                 : in  std_logic                      := '0';             --                 tx_pclk.clk
				tx_coreclk              : in  std_logic                      := '0';             --              tx_coreclk.clk
				rx_dataout              : out std_logic_vector(19 downto 0);                     --              rx_dataout.export
				rx_dataout_valid        : out std_logic;                                         --        rx_dataout_valid.export
				rx_clkout               : out std_logic;                                         --               rx_clkout.clk
				rx_rst                  : in  std_logic                      := '0';             --                  rx_rst.reset
				rx_coreclk              : in  std_logic                      := '0';             --              rx_coreclk.clk
				xcvr_refclk             : in  std_logic                      := '0';             --             xcvr_refclk.clk
				sdi_tx                  : out std_logic;                                         --                  sdi_tx.export
				sdi_rx                  : in  std_logic                      := '0'             --                  sdi_rx.export
			);
	end component;

	--Inputs
  signal data_in      : std_logic_vector(19 downto 0) := (others => '0');
  signal dv_in        : std_logic := '0';
	signal sdi_rx             : std_logic;
	-- signal ln           : std_logic := '0';
  signal start        : std_logic := '0';
  signal rst          : std_logic := '1';
  signal clk          : std_logic := '0';

  --Outputs
	signal tx_dv_out          : std_logic;
	signal data_out           : std_logic_vector(19 downto 0) := (others => '0');
  signal dv_out             : std_logic;
  signal sdi_tx             : std_logic;
  -- signal locked             : std_logic;
  -- signal clk_out            : std_logic;
	-- signal reconfig_from_xcvr : std_logic_vector(91 downto 0);

	-- Clock period definitions
  constant CLK_T : time := 6.734 ns;

begin

	-- Instantiate the Unit Under Test (UUT)
	sdi_ip_ii_u: component sdi_ip_loop
	port map(
		tx_rst             => rst,
		-- tx_enable_crc      => start,
		-- tx_enable_ln       => start,
		-- tx_ln              => (others => '0'),
		tx_datain          => data_in,
		tx_datain_valid    => dv_in,
		tx_trs             => '0',
		tx_dataout_valid   => tx_dv_out,
		tx_pclk            => clk,
		tx_coreclk         => clk,
		rx_dataout         => data_out,
		rx_dataout_valid   => dv_out,
		rx_clkout          => open,
		rx_rst             => rst,
		rx_coreclk         => clk,
		xcvr_refclk        => clk,
		sdi_tx             => sdi_tx,
		sdi_rx             => sdi_rx
		-- tx_pll_locked      => locked,
		-- tx_clkout          => clk_out,
		-- reconfig_to_xcvr   => (others => '0'),
		-- reconfig_from_xcvr => open
	);

	-- Clock process definitions
	clk_p: process
	begin
		clk <= '0';
		wait for CLK_T/2;
		clk <= '1';
		wait for CLK_T/2;
		-- clk <= '0';
		-- wait for 3 ns;
		-- clk <= '1';
		-- wait for 3 ns;
	end process;

	sdi_rx <= sdi_tx;

	-- Stimulus process
  stim_p: process
  begin
    -- hold reset state for 100 ns.
    rst <= '1';
    wait for 90 ns;
    rst <= '0';
    wait for CLK_T * 10;
    start <= '1';
    wait for CLK_T;
    start <= '0';
    wait for CLK_T * 10;

    report "start of test" severity note;

    for i in 0 to 19 loop
      wait until (rising_edge(clk));
      dv_in  <= '1';
      data_in   <= std_logic_vector(to_unsigned(i, 20));
      --assert data_in report "data in" severity note;
    end loop;
    wait until (rising_edge(clk));
    dv_in <= '0';

    wait for CLK_T * 10;

    -- for i in 0 to 19 loop
    --   wait until (rising_edge(clk));
    --   dv_in <= '1';
    --   data_in <= std_logic_vector(to_unsigned(i, 20));
    --   wait until (rising_edge(clk));
    --   dv_in <= '0';
    --   wait for CLK_T * 10;
    -- end loop;

    assert false report "end of test" severity note;
    wait;
  end process;

end;