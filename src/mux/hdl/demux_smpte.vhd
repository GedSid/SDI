

library ieee;
  use ieee.std_logic_1164.all;

  entity demux_smpte is
    generic (
      DATA_W : positive := 10
    );
    port (
      clk             : in  std_logic;
      clk_en          : in  std_logic;
      data_rdy_i      : in  std_logic;
      rst             : in  std_logic;
      data_y_i        : in  std_logic_vector(DATA_W-1 downto 0);
      data_c_i        : in  std_logic_vector(DATA_W-1 downto 0);
      trs_in          : in  std_logic;
      lvl_b           : out std_logic;
      data_ch0_c_o    : out std_logic_vector(DATA_W-1 downto 0) := (others => '0');
      data_ch0_y_o    : out std_logic_vector(DATA_W-1 downto 0);
      data_ch1_c_o    : out std_logic_vector(DATA_W-1 downto 0) := (others => '0');
      data_ch1_y_o    : out std_logic_vector(DATA_W-1 downto 0);
      trs             : out std_logic;
      eav             : out std_logic;
      sav             : out std_logic;
      xyz             : out std_logic;
      data_rdy_gen_o  : out std_logic;
      line_num        : out std_logic_vector(10 downto 0) := (others => '0')
    );
  end demux_smpte;

architecture rtl of demux_smpte is

  signal data_ch0_c     : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal data_ch0_y     : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal data_ch1_c     : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal data_ch1_y     : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal trs_dly        : std_logic_vector(4 downto 0) := (others => '0');
  signal ln_ls          : std_logic_vector(6 downto 0) := (others => '0');
  signal trs_rise       : std_logic := '0';
  signal all_ones       : std_logic;
  signal all_zeros      : std_logic;
  signal zeros          : std_logic_vector(2 downto 0) := (others => '0');
  signal ones           : std_logic_vector(4 downto 0) := (others => '0');
  signal lvl_b_detect   : std_logic := '0';
  signal trs_rise_dly   : std_logic := '0';
  signal eav_dly        : std_logic_vector(1 downto 0) := (others => '0');
  signal xyz_int        : std_logic;
  signal eav_int        : std_logic;

begin

  trs_rise_detect_p: process(clk, rst)
  begin
    if (rst = '1') then
      trs_rise <= '0';
      trs_rise_dly <= '0';
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        trs_rise_dly <= trs_rise;
        if (trs_in = '1' and trs_dly(0) = '0') then
          trs_rise <= '1';
        else
          trs_rise <= '0';
        end if;
      end if;
    end if;
  end process;

  data_rdy_gen_o <= trs_rise and (not trs_rise_dly);

  process(clk)
  begin
    if (rst = '1') then
      data_ch0_c <= (others => '0');
      data_ch1_c <= (others => '0');
      data_ch0_y <= (others => '0');
      data_ch0_c_o <= (others => '0');
      data_ch1_y <= (others => '0');
      data_ch1_c_o <= (others => '0');
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        if (data_rdy_i = '0') then
          data_ch0_c <= data_y_i;
          data_ch1_c <= data_c_i;
          data_ch0_y <= data_y_i;
          data_ch1_y <= data_c_i;
          data_ch0_c_o <= data_ch0_c;
          data_ch1_c_o <= data_ch1_c;
        end if;
      end if;
    end if;
  end process;

  data_ch0_y_o <= data_ch0_y;
  data_ch1_y_o <= data_ch1_y;

  trs_timing_p: process(clk, rst)
  begin
    if (rst = '1') then
      trs_dly <= (others => '0');
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        if (data_rdy_i = '1') then
          trs_dly <= (trs_dly(3 downto 0) & trs_in);
        end if;
      end if;
    end if;
  end process;

  trs <= trs_dly(2) or trs_dly(1) or trs_dly(0) or (trs_dly(3) and trs_dly(2));
  xyz_int <= trs_dly(3) and not trs_dly(4);
  xyz <= xyz_int;
  eav_int <= xyz_int and data_ch0_y(6);
  eav <= eav_int;
  sav <= xyz_int and not data_ch0_y(6);

  line_n_capture_p: process(clk, rst)
  begin
    if (rst = '1') then
      eav_dly <= (others => '0');
      ln_ls <= (others => '0');
      line_num <= (others => '0');
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        if (data_rdy_i = '1') then
          eav_dly <= (eav_dly(0) & eav_int);
        end if;
        if (data_rdy_i = '1' and eav_dly(0) = '1') then
          ln_ls <= data_ch0_y(8 downto 2);
        end if;
        if (data_rdy_i = '1' and eav_dly(1) = '1') then
          line_num <= (data_ch0_y(5 downto 2) & ln_ls);
        end if;
      end if;
    end if;
  end process;

  all_ones  <= '1' when data_y_i = "1111111111" else '0';
  all_zeros <= '1' when data_y_i = "0000000000" else '0';

  lvl_b_detect_p: process(clk)
  begin
    if (rst = '1') then
      ones <= (others => '0');
      zeros <= (others => '0');
      lvl_b_detect <= '0';
      lvl_b <= '0';
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        ones <= (ones(3 downto 0) & all_ones);
        zeros <= (zeros(1 downto 0) & all_zeros);
        if (data_rdy_i = '1') then
          lvl_b_detect <= ones(4) and ones(3) and zeros(2) and zeros(1) and zeros(0) and all_zeros;
        end if;
        if (data_rdy_i = '1' and trs_dly(2) = '1' and trs_dly(1) = '1') then
          lvl_b <= lvl_b_detect;
        end if;
      end if;
    end if;
  end process;

end rtl;