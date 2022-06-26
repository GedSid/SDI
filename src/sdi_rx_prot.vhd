-------------------------------------------------------------------------------
--                      Protocolo Receptor de intefaz SDI                    --
-------------------------------------------------------------------------------
-- Purpose  : Contenedor de la implementación del protocolo del receptor SDI.
--
-- Author   : Joaquin Ulloa
--
-- Comments : Se procesan los datos deserealizados: arma las palabras,
--           decodifica de 10b a 8b y se sincroniza.
-------------------------------------------------------------------------------

library ieee;
  use ieee.std_logic_1164.all;

entity sdi_rx_prot is
  port (
    rst         : in  std_logic;
    clk_sys     : in  std_logic;
    -- From XCVR
    dv_i        : in  std_logic;
    data_i      : in  std_logic_vector(19 downto 0);
    -- SDI TS output
    locked_o    : out std_logic;
    dv_o        : out std_logic;
    data_o      : out std_logic_vector(19 downto 0);
    ts_status_o : out std_logic_vector( 7 downto 0)
  );
end entity;

architecture rtl of sdi_rx_prot is

  signal data_aligned        : std_logic_vector(9 downto 0);
  signal data_aligned_valid    : std_logic;
  --
  signal din_ena           : std_logic;
  signal din_dat           : std_logic_vector(9 downto 0);
  signal din_rd            : std_logic;
  signal dout_val          : std_logic;
  signal dout_dat          : std_logic_vector(7 downto 0);
  signal dout_k            : std_logic;
  signal dout_kerr          : std_logic;
  signal dout_rderr         : std_logic;
  signal dout_rdcomb        : std_logic;
  signal dout_rdreg         : std_logic;
  --
  signal code_error         : std_logic;
  signal kcode_found        : std_logic;
  signal sdi_sync          : std_logic;
  --
  signal packet_data_in      : std_logic_vector(7 downto 0);
  signal packet_data_in_valid  : std_logic;
  signal packet_data_out      : std_logic_vector(7 downto 0);
  signal packet_data_out_valid  : std_logic;
  signal ts_sop            : std_logic;
  signal ts_eop            : std_logic;
  signal ts_locked          : std_logic;
  signal ts_188_204n        : std_logic;
  signal ts_error          : std_logic;

  component par_scrambler is 
  generic (
    Data_Width        : integer	:= 8;		-- Input/output data width
    Polynomial_Width  : integer	:= 8		-- Polynomial width
  );
  port ( 
    rst         : in std_logic;			-- Async reset
    clk         : in std_logic;			-- System clock
    scram_rst   : in std_logic;			-- Scrambler reset, use for initialization.
    polynomial  : in std_logic_vector (Polynomial_Width downto 0);	-- Polynomial. Example: 1+x^4+x^6+x^7 represent as "11010001"
    data_in     : in std_logic_vector (Data_Width-1 downto 0);		-- Data input
    scram_en    : in std_logic; 									-- Input valid
    data_out    : out std_logic_vector (Data_Width-1 downto 0);		-- Data output
    out_valid   : out std_logic										-- Output valid
  );
  end component;

begin

  --TESTEAR LA SERIE SCRAMBLER-DESCLRAMBLER
  descram_u: par_scrambler 
  generic map (
    Data_Width        => 8,
    Polynomial_Width  => 7
  )
  port map (
    rst         => rst,
    clk         => clk_sys,
    polynomial  => "1000010001", -- x^9+x^4+1
    data_in     => data_i,
    scram_en    => dv_i,
    scram_rst   => scram_start,
    data_out    => data_descram_align,
    out_valid   => dv_descram_align
  );

  -----------------------------------------------------------------------------
  -- Word Aligner
  -----------------------------------------------------------------------------
  -- La salida del transceiver entrega los datos desalineados a nivel de bit, es
  -- decir, los bits que componen la palabra de 10 bits que genera a la salida
  -- pueden estar desfasados respecto a la palabra que se transmitió.
  -- Este bloque busca dos comma characters consecutivos en el stream de datos
  -- de salida del transceiver y desplaza los bits para alinearlos correctamente
  sdi_aligner_u: entity work.word_aligner
  generic map (
    INVALID_PERIOD     => 148500
  )
  port map (
    rst             => rst,
    clk             => clk_sys,
    data_i          => data_descram_align,
    dv_i            => dv_descram_align,
    pattern         => x"3FF000000", -- SD
    data_out        => data_aligned,
    data_out_valid  => dV_aligned,
    locked          => rx_locked,
    pattern_found   => pattern_found
  );

  -- sEGUIR ACA

  din_dat  <= data_aligned(9 downto 0);
  din_ena  <= data_aligned_valid;
  din_rd  <= dout_rdreg;


  -----------------------------------------------------------------------------
  -- Synchronization State Machine
  -----------------------------------------------------------------------------
  sdi_sync_fsm_u: entity work.sdi_sync_fsm
  port map (
    rst            => rst,
    clk            => rx_clkout,
    data_in_valid      => dout_val,
    code_error        => code_error,
    kcode_found       => kcode_found,
    sync            => sdi_sync
  );

  packet_data_in     <= dout_dat;
  packet_data_in_valid <= dout_val and (not dout_k) and sdi_sync;

  -----------------------------------------------------------------------------
  -- Packet Synchronization
  -----------------------------------------------------------------------------
  sdi_packet_sync_u: entity work.sdi_packet_sync
  port map (
    rst            => rst,
    clk            => rx_clkout,
    data_in          => packet_data_in,
    data_in_valid      => packet_data_in_valid,
    data_out         => packet_data_out,
    data_out_valid     => packet_data_out_valid,
    ts_sop          => ts_sop,
    ts_eop          => ts_eop,
    ts_locked        => ts_locked,
    ts_188_204n       => ts_188_204n,
    ts_error         => ts_error
  );

  rx_data      <= packet_data_out;
  rx_data_clk   <= rx_clkout;
  rx_data_valid  <= packet_data_out_valid;
  rx_ts_status  <=  dout_val
              & '0'
              & ts_188_204n
              & ts_locked
              & ts_error
              & ts_eop
              & ts_sop
              & packet_data_out_valid;

end architecture;
