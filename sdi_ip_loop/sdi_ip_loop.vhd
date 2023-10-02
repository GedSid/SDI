library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sdi_ip_loop is
	port (
		tx_rst                  : in  std_logic                      := '0';             --                  tx_rst.reset
		-- tx_enable_crc           : in  std_logic                      := '0';             --           tx_enable_crc.export
		-- tx_enable_ln            : in  std_logic                      := '0';             --            tx_enable_ln.export
		-- tx_ln                   : in  std_logic_vector(10 downto 0)  := (others => '0'); --                   tx_ln.export
		tx_datain               : in  std_logic_vector(19 downto 0)  := (others => '0'); --               tx_datain.export
		tx_datain_valid         : in  std_logic                      := '0';             --         tx_datain_valid.export
		tx_trs                  : in  std_logic                      := '0';             --                  tx_trs.export
		tx_dataout_valid        : out std_logic;                                         --        tx_dataout_valid.export
		tx_pclk                 : in  std_logic                      := '0';             --                 tx_pclk.clk
		tx_coreclk              : in  std_logic                      := '0';             --              tx_coreclk.clk
		rx_dataout              : out std_logic_vector(19 downto 0);                     --              rx_dataout.export
		rx_dataout_valid        : out std_logic;                                         --        rx_dataout_valid.export
		-- rx_f                    : out std_logic_vector(0 downto 0);                      --                    rx_f.export
		-- rx_v                    : out std_logic_vector(0 downto 0);                      --                    rx_v.export
		-- rx_h                    : out std_logic_vector(0 downto 0);                      --                    rx_h.export
		-- rx_ap                   : out std_logic_vector(0 downto 0);                      --                   rx_ap.export
		-- rx_format               : out std_logic_vector(4 downto 0);                      --               rx_format.export
		-- rx_eav                  : out std_logic_vector(0 downto 0);                      --                  rx_eav.export
		-- rx_trs                  : out std_logic_vector(0 downto 0);                      --                  rx_trs.export
		-- rx_align_locked         : out std_logic;                                         --         rx_align_locked.export
		-- rx_trs_locked           : out std_logic_vector(0 downto 0);                      --           rx_trs_locked.export
		-- rx_frame_locked         : out std_logic;                                         --         rx_frame_locked.export
		-- rx_ln                   : out std_logic_vector(10 downto 0);                     --                   rx_ln.export
		rx_clkout               : out std_logic;                                         --               rx_clkout.clk
		-- rx_coreclk_is_ntsc_paln : in  std_logic                      := '0';             -- rx_coreclk_is_ntsc_paln.export
		-- rx_clkout_is_ntsc_paln  : out std_logic;                                         --  rx_clkout_is_ntsc_paln.export
		-- rx_rst_proto_out        : out std_logic;                                         --        rx_rst_proto_out.export
		rx_rst                  : in  std_logic                      := '0';             --                  rx_rst.reset
		rx_coreclk              : in  std_logic                      := '0';             --              rx_coreclk.clk
		xcvr_refclk             : in  std_logic                      := '0';             --             xcvr_refclk.clk
		sdi_tx                  : out std_logic;                                         --                  sdi_tx.export
		-- tx_pll_locked           : out std_logic;                                         --           tx_pll_locked.export
		-- tx_clkout               : out std_logic;                                         --               tx_clkout.clk
		sdi_rx                  : in  std_logic                      := '0'             --                  sdi_rx.export
		-- rx_pll_locked           : out std_logic;                                         --           rx_pll_locked.export
		-- reconfig_to_xcvr        : in  std_logic_vector(139 downto 0) := (others => '0'); --        reconfig_to_xcvr.reconfig_to_xcvr
		-- reconfig_from_xcvr      : out std_logic_vector(91 downto 0)                      --      reconfig_from_xcvr.reconfig_from_xcvr
	);
end entity;

architecture rtl of sdi_ip_loop is
	
	component sdi_ip_ii_tx is
	port (
		tx_rst             : in  std_logic                      := '0';             --             tx_rst.reset
		tx_enable_crc      : in  std_logic                      := '0';             --      tx_enable_crc.export
		tx_enable_ln       : in  std_logic                      := '0';             --       tx_enable_ln.export
		tx_ln              : in  std_logic_vector(10 downto 0)  := (others => '0'); --              tx_ln.export
		tx_datain          : in  std_logic_vector(19 downto 0)  := (others => '0'); --          tx_datain.export
		tx_datain_valid    : in  std_logic                      := '0';             --    tx_datain_valid.export
		tx_trs             : in  std_logic                      := '0';             --             tx_trs.export
		tx_dataout_valid   : out std_logic;                                         --   tx_dataout_valid.export
		tx_pclk            : in  std_logic                      := '0';             --            tx_pclk.clk
		tx_coreclk         : in  std_logic                      := '0';             --         tx_coreclk.clk
		xcvr_refclk        : in  std_logic                      := '0';             --        xcvr_refclk.clk
		sdi_tx             : out std_logic;                                         --             sdi_tx.export
		tx_pll_locked      : out std_logic;                                         --      tx_pll_locked.export
		tx_clkout          : out std_logic;                                         --          tx_clkout.clk
		reconfig_to_xcvr   : in  std_logic_vector(139 downto 0) := (others => '0'); --   reconfig_to_xcvr.reconfig_to_xcvr
		reconfig_from_xcvr : out std_logic_vector(91 downto 0)                      -- reconfig_from_xcvr.reconfig_from_xcvr
	);
	end component;
	
	component sdi_ip_ii_rx is
		port (
			rx_dataout              : out std_logic_vector(19 downto 0);                    --              rx_dataout.export
			rx_dataout_valid        : out std_logic;                                        --        rx_dataout_valid.export
			rx_f                    : out std_logic_vector(0 downto 0);                     --                    rx_f.export
			rx_v                    : out std_logic_vector(0 downto 0);                     --                    rx_v.export
			rx_h                    : out std_logic_vector(0 downto 0);                     --                    rx_h.export
			rx_ap                   : out std_logic_vector(0 downto 0);                     --                   rx_ap.export
			rx_format               : out std_logic_vector(4 downto 0);                     --               rx_format.export
			rx_eav                  : out std_logic_vector(0 downto 0);                     --                  rx_eav.export
			rx_trs                  : out std_logic_vector(0 downto 0);                     --                  rx_trs.export
			rx_align_locked         : out std_logic;                                        --         rx_align_locked.export
			rx_trs_locked           : out std_logic_vector(0 downto 0);                     --           rx_trs_locked.export
			rx_frame_locked         : out std_logic;                                        --         rx_frame_locked.export
			rx_ln                   : out std_logic_vector(10 downto 0);                    --                   rx_ln.export
			rx_clkout               : out std_logic;                                        --               rx_clkout.clk
			rx_coreclk_is_ntsc_paln : in  std_logic                     := '0';             -- rx_coreclk_is_ntsc_paln.export
			rx_clkout_is_ntsc_paln  : out std_logic;                                        --  rx_clkout_is_ntsc_paln.export
			rx_rst_proto_out        : out std_logic;                                        --        rx_rst_proto_out.export
			rx_rst                  : in  std_logic                     := '0';             --                  rx_rst.reset
			rx_coreclk              : in  std_logic                     := '0';             --              rx_coreclk.clk
			xcvr_refclk             : in  std_logic                     := '0';             --             xcvr_refclk.clk
			sdi_rx                  : in  std_logic                     := '0';             --                  sdi_rx.export
			rx_pll_locked           : out std_logic;                                        --           rx_pll_locked.export
			reconfig_to_xcvr        : in  std_logic_vector(69 downto 0) := (others => '0'); --        reconfig_to_xcvr.reconfig_to_xcvr
			reconfig_from_xcvr      : out std_logic_vector(45 downto 0)                     --      reconfig_from_xcvr.reconfig_from_xcvr
		);
	end component;

begin

	-- Instantiate the Unit Under Test (UUT)
	sdi_tx_u: component sdi_ip_ii_tx
	port map(
		tx_rst             => tx_rst,
		tx_enable_crc      => '0',
		tx_enable_ln       => '0',
		tx_ln              => (others => '0'),
		tx_datain          => tx_datain,
		tx_datain_valid    => tx_datain_valid,
		tx_trs             => '0',
		tx_dataout_valid   => tx_dataout_valid,
		tx_pclk            => tx_pclk,
		tx_coreclk         => tx_coreclk,
		xcvr_refclk        => xcvr_refclk,
		sdi_tx             => sdi_tx,
		tx_pll_locked      => open,
		tx_clkout          => open,
		reconfig_to_xcvr   => (others => '0'),
		reconfig_from_xcvr => open
	);

	sdi_rx_u: component sdi_ip_ii_rx
	port map (
		rx_dataout              => rx_dataout,
		rx_dataout_valid        => rx_dataout_valid,
		rx_f                    => open,
		rx_v                    => open,
		rx_h                    => open,
		rx_ap                   => open,
		rx_format               => open,
		rx_eav                  => open,
		rx_trs                  => open,
		rx_align_locked         => open,
		rx_trs_locked           => open,
		rx_frame_locked         => open,
		rx_ln                   => open,
		rx_clkout               => rx_clkout,
		rx_coreclk_is_ntsc_paln => '0',
		rx_clkout_is_ntsc_paln  => open,
		rx_rst_proto_out        => open,
		rx_rst                  => rx_rst,
		rx_coreclk              => rx_coreclk,
		xcvr_refclk             => xcvr_refclk,
		sdi_rx                  => sdi_rx,
		rx_pll_locked           => open,
		reconfig_to_xcvr        => (others => '0'),
		reconfig_from_xcvr      => open
	);

end;