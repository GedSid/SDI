-------------------------------------------------------------------------------
--                           Receptor de intefaz SDI                         --
-------------------------------------------------------------------------------
-- Purpose  : Top level del receptor SDI, contiene a la etapa de transceiver y 
--            y de protocolo.
--
-- Author   : Joaquin Ulloa
--
-- Comments : El tamaño de los datos está pensado para calidad 3G, por lo que
--            de usarlo en SD se deben dejar abiertos los 10 bits superores.
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

entity sdi_rx is
  port (
    clk_sys     : in  std_logic;
    rst         : in  std_logic;
    clk_deser   : in  std_logic;
    clk_deser90 : in  std_logic;
    data_i      : in  std_logic;
    locked_o    : out std_logic;
    dv_o        : out std_logic;
    data_o      : out std_logic_vector(19 downto 0);
    ts_status_o : out std_logic_vector( 7 downto 0)
--     0    indicates receiver data valid
--     1    indicates start of packet
--     2    indicates end of packet
--     3    indicates receiver error
--     5:4  indicates 00 is unlocked; 01 is 204 byte packet lock, 11 is 188 byte packet lock
--     6    indicates TS serial polarity
--     7    indicates that the data on data_o[7:0] is a valid word from the 8B10B decoder. Unlike ts_status_o[0],
--          this signal is not dependent on the correct packet or synchronization structure of the stream.
  );
end entity;

architecture rtl of sdi_rx is

  signal dv_xcvr_proto    : std_logic;
  signal data_xcvr_proto  : std_logic_vector(19 downto 0);

begin

  xcvr_u: entity work.sdi_rx_xcvr
  port map (
    rst           => rst,
    clk_sys       => clk_sys,
    clk_deser     => clk_deser,
    clk_deser90   => clk_deser90,
    --
    data_i        => data_i,
    -- OUT
    data_o        => data_xcvr_proto,
    dv_o          => dv_xcvr_proto
  );

  protocol_u: entity work.sdi_rx_prot
  port map (
    rst           => rst,
    clk_sys       => clk_sys,
    -- From XCVR
    dv_i          => dv_xcvr_proto,
    data_i        => data_xcvr_proto,
    -- SDI TS output
    locked_o      => locked_o,
    dv_o          => dv_o,
    data_o        => data_o,
    ts_status_o   => ts_status_o
  );

end architecture;
