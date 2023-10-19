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
  generic (
    DATA_W : positive := 20;
    POLY_W : positive :=  9
  );
  port (
    rst     : in std_logic;
    clk_sys : in std_logic;
    -- From XCVR
    dv_i    : in std_logic;
    data_i  : in std_logic_vector(DATA_W - 1 downto 0);
    -- Norm references
    polynomial  : in std_logic_vector(POLY_W - 1 downto 0) := "1000010001"; -- x^9+x^4+1
    trs_pattern : in std_logic_vector(DATA_W - 1 downto 0) := (x"3FF" & (others => '0')); -- SD tiene largo de 34 bits
    -- VER LARGO VARIABLE PARA PATTERNS
    -- SDI TS output
    ts_locked_o : out std_logic;
    ts_dv_o     : out std_logic;
    ts_data_o   : out std_logic_vector(DATA_W - 1 downto 0);
    ts_status_o : out std_logic_vector(7 downto 0)
  );
end entity;

architecture rtl of sdi_rx_prot is

  --
  signal packet_data_in         : std_logic_vector(7 downto 0);
  signal packet_data_in_valid   : std_logic;
  signal packet_data_out        : std_logic_vector(7 downto 0);
  signal packet_data_out_valid  : std_logic;
  signal ts_sop                 : std_logic;
  signal ts_eop                 : std_logic;
  signal ts_locked              : std_logic;
  signal ts_188_204n            : std_logic;
  signal ts_error               : std_logic;

  signal dv_descram_align   : std_logic;
  signal data_descram_align : std_logic_vector(DATA_W - 1 downto 0);
  signal scram_start        : std_logic;

  signal dv_aligned   : std_logic;
  signal data_aligned : std_logic_vector(DATA_W - 1 downto 0);

  component par_scrambler is
    generic (
      Data_Width        : integer := DATA_W; -- Input/output data width
      Polynomial_Width  : integer := POLY_W -- Polynomial width
    );
    port (
      rst         : in std_logic; -- Async reset
      clk         : in std_logic; -- System clock
      scram_rst   : in std_logic; -- Scrambler reset, use for initialization.
      polynomial  : in std_logic_vector(POLY_W - 1 downto 0); -- Polynomial. Example: 1+x^4+x^6+x^7 represent as "11010001"
      data_in     : in std_logic_vector(DATA_W - 1 downto 0); -- Data input
      scram_en    : in std_logic; -- Input valid
      data_out    : out std_logic_vector(DATA_W - 1 downto 0); -- Data output
      out_valid   : out std_logic -- Output valid
    );
  end component;

begin

-- -------------------------------------------------------------------------------
-- -- Input register
--   in_reg_p: process(rst, clk) esto no necesitaría reset porque está en el data path que se depura
--   begin
--     if (rst = '1') then
--       data_reg_i  <= (others => '0');
--       dv_reg_i  <= '0';
--     elsif rising_edge(clk) then
--       data_reg_i  <= data_i;
--       dv_reg_i  <= dv_i;
--     end if;
--   end process;

  -- descrambler_in <= (sd_rxdata & "0000000000") when mode_SD_int = '1' else rxdata;

  -----------------------------------------------------------------------------
  -- NZRI and Descrambler - Prealign
  -----------------------------------------------------------------------------
  descram_u : par_scrambler
  generic map(
    Data_Width        => DATA_W,
    Polynomial_Width  => POLY_W
  )
  port map(
    rst         => rst,
    clk         => clk_sys,
    polynomial  => polynomial,
    data_in     => data_i,
    scram_en    => dv_i,
    scram_rst   => scram_start,
    data_out    => data_descram_align,
    out_valid   => dv_descram_align
  );

  -----------------------------------------------------------------------------
  -- TRS Aligner - Prealign
  -----------------------------------------------------------------------------
  -- La salida del transceiver entrega los datos desalineados a nivel de bit, es
  -- decir, los bits que componen la palabra de 10 bits que genera a la salida
  -- pueden estar desfasados respecto a la palabra que se transmitió.
  -- Este bloque busca dos comma characters consecutivos en el stream de datos
  -- de salida del transceiver y desplaza los bits para alinearlos correctamente
  trs_aligner_u : entity work.word_aligner
  generic map(
    INVALID_PERIOD => 148500
  )
  port map(
    rst             => rst,
    clk             => clk_sys,
    data_i          => data_descram_align,
    dv_i            => dv_descram_align,
    pattern         => trs_pattern,
    data_out        => data_aligned,
    data_out_valid  => dV_aligned,
    locked          => ts_locked_o,
    pattern_found   => open --pattern_found
  );

  -----------------------------------------------------------------------------
  -- Match TRS State Machine
  -----------------------------------------------------------------------------
  --match_trs_u: entity work.match_trs_fsm

  -----------------------------------------------------------------------------
  -- Packet Synchronization
  -----------------------------------------------------------------------------
  sdi_packet_sync_u : entity work.sdi_packet_sync
    port map(
      rst => rst,
      clk => clk_sys,
      data_in => packet_data_in,
      data_in_valid => packet_data_in_valid,
      data_out => packet_data_out,
      data_out_valid => packet_data_out_valid,
      ts_sop => ts_sop,
      ts_eop => ts_eop,
      ts_locked => ts_locked,
      ts_188_204n => ts_188_204n,
      ts_error => ts_error
    );

  ts_data_o <= packet_data_out;
  ts_dv_o <= packet_data_out_valid;
--  ts_status_o <= dout_val
--    & '0'
--    & ts_188_204n
--    & ts_locked
--    & ts_error
--    & ts_eop
--    & ts_sop
--    & packet_data_out_valid;

end architecture;
