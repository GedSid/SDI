library ieee;
  use ieee.std_logic_1164.all;

entity sdi_tx_out is
  generic(
    DATA_W      : positive := 10;
    VERT_POS_W  : positive := 11;
    POLY_ORDER  : positive := 18
  );
  port (
    clk           : in  std_logic;  -- 148.5 MHz (HD) or 297 MHz (SD)
    rst           : in  std_logic;
    d_rdy_i       : in  std_logic;
    -- ce:             in  std_logic_vector(1 downto 0);               -- runs at scrambler data rate:..
    --                                                                 --   27 MHz, 74.25 MHz or 148.5 MHz
    mode          : in  std_logic_vector(1 downto 0); -- HD/3GA=00, SD=01
    data_ay_i     : in  std_logic_vector(DATA_W-1 downto 0);               -- SD; HD, 3G, dual-link A Y
    data_ac_i     : in  std_logic_vector(DATA_W-1 downto 0);               -- HD, 3G, dual-link A C
    data_by_i     : in  std_logic_vector(DATA_W-1 downto 0);               -- dual-link B Y
    data_bc_i     : in  std_logic_vector(DATA_W-1 downto 0);               -- dual-link B C
    insert_crc    : in  std_logic;
    insert_ln     : in  std_logic;
    insert_edh    : in  std_logic;
    ln_a          : in  std_logic_vector(VERT_POS_W-1 downto 0);
    ln_b          : in  std_logic_vector(VERT_POS_W-1 downto 0);
    eav           : in  std_logic;
    sav           : in  std_logic;
    data_tx_o     : out std_logic_vector(2*DATA_W-1 downto 0);
    ce_align_err  : out std_logic                                 -- 1 if ce 5/6/5/6 cadence is broken
  );
end sdi_tx_out;

architecture rtl of sdi_tx_out is

  signal data_ay_r  : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal data_ac_r  : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal data_by_r  : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal data_bc_r  : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal ln_a_r     : std_logic_vector(VERT_POS_W-1 downto 0) := (others => '0');
  signal ln_b_r     : std_logic_vector(VERT_POS_W-1 downto 0) := (others => '0');
  signal mode_r     : std_logic_vector(1 downto 0) := (others => '0');
  signal eav_r      : std_logic := '0';
  signal sav_r      : std_logic := '0';
  signal ins_crc_r  : std_logic := '0';
  signal ls_ins_r   : std_logic := '0';
  signal ins_edh_r  : std_logic := '0';
  signal eav_dly    : std_logic_vector(3 downto 0) := (others => '0');
  signal mode_sd    : std_logic := '0';
  signal mode_3gb   : std_logic := '0';
  signal data_ln_crc_ac : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal data_ln_crc_ay : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal data_ln_crc_bc : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal data_ln_crc_by : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal data_crc_scram_ac : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal data_crc_scram_ay : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal data_crc_scram_bc : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal data_crc_scram_by : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal data_scram_c   : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal data_scram_y   : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal scram_out      : std_logic_vector(2*DATA_W-1 downto 0) := (others => '0');
  signal data_mux_y     : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal data_tx_o_r    : std_logic_vector(2*DATA_W-1 downto 0) := (others => '0');

begin

  in_and_dly_reg_p: process(clk, rst)
  begin
    if (rst = '1') then
      data_ay_r    <= (others => '0');
      data_ac_r    <= (others => '0');
      data_by_r    <= (others => '0');
      data_bc_r    <= (others => '0');
      ln_a_r    <= (others => '0');
      ln_b_r    <= (others => '0');
      mode_r    <= (others => '0');
      eav_r     <= '0';
      sav_r     <= '0';
      ins_crc_r <= '0';
      ls_ins_r  <= '0';
      ins_edh_r <= '0';
      eav_dly   <= (others => '0');
    elsif rising_edge(clk) then
      if (d_rdy_i = '1') then
        data_ay_r    <= data_ay_i;
        data_ac_r    <= data_ac_i;
        data_by_r    <= data_by_i;
        data_bc_r    <= data_bc_i;
        ln_a_r    <= ln_a;
        ln_b_r    <= ln_b;
        mode_r    <= mode;
        eav_r     <= eav;
        sav_r     <= sav;
        ins_crc_r <= insert_crc;
        ls_ins_r  <= insert_ln;
        ins_edh_r <= insert_edh;
        eav_dly   <= (eav_dly(2 downto 0) & eav_r);
      end if;
    end if;
  end process;

  mode_sd   <= '1' when mode_r = "01" else '0';
  mode_3gb <= '1' when mode_r = "10" else '0';

  ln_a_u: entity work.ln_insert
  generic map (
    DATA_W      => DATA_W,
    VERT_POS_W  => VERT_POS_W
  )
  port map (
    ln_ins_en => ls_ins_r,
    ln_word0  => eav_dly(0),
    ln_word1  => eav_dly(1),
    data_c_i  => data_ac_r,
    data_y_i  => data_ay_r,
    ln_i      => ln_a_r,
    data_c_o  => data_ln_crc_ac,
    data_y_o  => data_ln_crc_ay
  );

  ln_b_u: entity work.ln_insert
  generic map (
    DATA_W      => DATA_W,
    VERT_POS_W  => VERT_POS_W
  )
  port map (
    ln_ins_en => ls_ins_r,
    ln_word0  => eav_dly(0),
    ln_word1  => eav_dly(1),
    data_c_i  => data_bc_r,
    data_y_i  => data_by_r,
    ln_i      => ln_b_r,
    data_c_o  => data_ln_crc_bc,
    data_y_o  => data_ln_crc_by
  );

  crc_a_u: entity work.crc_insert
  generic map (
    DATA_W      => DATA_W,
    POLY_ORDER  => POLY_ORDER
  )
  port map (
    clk         => clk,
    rst         => rst,
    d_rdy_i     => d_rdy_i,
    sav         => sav,
    eav_dly     => eav_dly(1),
    data_c_i    => data_ln_crc_ac,
    data_y_i    => data_ln_crc_ay,
    crc_ins_en  => ins_crc_r,
    crc_word0   => eav_dly(2),
    crc_word1   => eav_dly(3),
    data_c_o    => data_crc_scram_ac,
    data_y_o    => data_crc_scram_ay
  );

  crc_b_u: entity work.crc_insert
  generic map (
    DATA_W      => DATA_W,
    POLY_ORDER  => POLY_ORDER
  )
  port map (
    clk         => clk,
    rst         => rst,
    d_rdy_i     => d_rdy_i,
    sav         => sav,
    eav_dly     => eav_dly(1),
    data_c_i    => data_ln_crc_bc,
    data_y_i    => data_ln_crc_by,
    crc_ins_en  => ins_crc_r,
    crc_word0   => eav_dly(2),
    crc_word1   => eav_dly(3),
    data_c_o    => data_crc_scram_bc,
    data_y_o    => data_crc_scram_by
  );

  -- Por ahora NO hay EDH!!!

-- Scrambler input selector. In SD, HD, and 3G level A modes, they simply pass data_ay_i and data_ac_i through.
  data_mux_y <= data_crc_scram_ac when mode_3gb = '1' and d_rdy_i = '0' else
                  data_crc_scram_ay;

  data_scram_c <= data_crc_scram_by when mode_3gb = '1' and d_rdy_i = '1' else
                  data_crc_scram_bc when mode_3gb = '1' and d_rdy_i = '0' else
                  data_crc_scram_ac;

  -- SD or HD/3G selector.
  -- data_scram_y <= edh_mux when mode_sd = '1' else data_mux_y;
  data_scram_y <= data_mux_y;

-- SDI scrambler
  scram_u : entity work.sdi_enc
  generic map(
    DATA_W      => DATA_W
  )
  port map (
    clk         => clk,
    rst         => rst,
    -- ce          => ce(0),
    hd_notsd    => mode_sd,
    nrzi_en     => '1',
    scram_en    => '1',
    data_c_i    => data_scram_c,
    data_y_i    => data_scram_y,
    data_o      => scram_out
  );

  out_r_p: process(clk)
  begin
    if (rst = '1') then
      data_tx_o_r <= (others => '0');
    elsif (rising_edge(clk)) then
      data_tx_o_r <= scram_out;
    end if;
  end process;

  data_tx_o <= data_tx_o_r;

end;