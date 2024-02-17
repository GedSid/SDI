library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ln_detect is
  port (
    clk         : in  std_logic;
    rst         : in  std_logic;
    clk_en      : in  std_logic;
    data_i      : in  std_logic_vector(8 downto 7);
    eav         : in  std_logic;
    sav         : in  std_logic;
    req_format  : in  std_logic;
    mode_3ga    : in  std_logic;
    v_std_o     : out std_logic_vector(3 downto 0);
    locked      : out std_logic;
    ln_o        : out std_logic_vector(10 downto 0);
    ln_valid    : out std_logic
  );
end ln_detect;

architecture rtl of ln_detect is

  constant ST_ACQ0 : std_logic_vector(3 downto 0) := "0000";
  constant ST_ACQ1 : std_logic_vector(3 downto 0) := "0001";
  constant ST_ACQ2 : std_logic_vector(3 downto 0) := "0010";
  constant ST_ACQ3 : std_logic_vector(3 downto 0) := "0011";
  constant ST_ACQ4 : std_logic_vector(3 downto 0) := "0100";
  constant ST_ACQ5 : std_logic_vector(3 downto 0) := "0101";
  constant ST_ACQ6 : std_logic_vector(3 downto 0) := "0110";
  constant ST_ACQ7 : std_logic_vector(3 downto 0) := "0111";
  constant ST_LCK0 : std_logic_vector(3 downto 0) := "1000";
  constant ST_LCK1 : std_logic_vector(3 downto 0) := "1001";
  constant ST_LCK2 : std_logic_vector(3 downto 0) := "1010";
  constant ST_LCK3 : std_logic_vector(3 downto 0) := "1011";
  constant ST_LCK4 : std_logic_vector(3 downto 0) := "1100";
  constant ST_ERR  : std_logic_vector(3 downto 0) := "1101";

  constant HD_FMT_1035i_30  : std_logic_vector(3 downto 0) := "0000";
  constant HD_FMT_1080i_25b : std_logic_vector(3 downto 0) := "0001";
  constant HD_FMT_1080i_30  : std_logic_vector(3 downto 0) := "0010";
  constant HD_FMT_1080i_25  : std_logic_vector(3 downto 0) := "0011";
  constant HD_FMT_1080p_30  : std_logic_vector(3 downto 0) := "0100";
  constant HD_FMT_1080p_25  : std_logic_vector(3 downto 0) := "0101";
  constant HD_FMT_1080p_24  : std_logic_vector(3 downto 0) := "0110";
  constant HD_FMT_720p_60   : std_logic_vector(3 downto 0) := "0111";
  constant HD_FMT_1080sF_24 : std_logic_vector(3 downto 0) := "1000";
  constant HD_FMT_720p_50   : std_logic_vector(3 downto 0) := "1001";
  constant HD_FMT_720p_30   : std_logic_vector(3 downto 0) := "1010";
  constant HD_FMT_720p_25   : std_logic_vector(3 downto 0) := "1011";
  constant HD_FMT_720p_24   : std_logic_vector(3 downto 0) := "1100";
  constant HD_FMT_1080p_60  : std_logic_vector(3 downto 0) := "1101";
  constant HD_FMT_1080p_50  : std_logic_vector(3 downto 0) := "1110";
  constant HD_FMT_RSVD_15   : std_logic_vector(3 downto 0) := "1111";

  constant MAX_ERRCNT   : std_logic_vector(2 downto 0) := "010";
  constant LOOPS_MSB :    integer := 3;
  constant HCNT_MSB :     integer := 13;
  constant HD_VCNT_WIDTH :       integer := 11;
  constant LAST_VIDEO_FORMAT_CODE_NORMAL : std_logic_vector(3 downto 0) := HD_FMT_720p_24;
  constant LAST_VIDEO_FORMAT_CODE_3GA :    std_logic_vector(3 downto 0) := HD_FMT_1080p_50;

  signal v_std          : std_logic_vector(3 downto 0) := (others => '0');
  signal word_cnt       : std_logic_vector(HCNT_MSB downto 0) := (others => '0');
  signal trs_to_counter : std_logic_vector(HCNT_MSB downto 0) := (others => '0');
  signal trs_tc         : std_logic_vector(HCNT_MSB downto 0);
  signal ln_cnt         : std_logic_vector(10 downto 0) := (others => '0');
  signal line_tc        : std_logic_vector(10 downto 0);
  signal st_current     : std_logic_vector(3 downto 0) := ST_ACQ0;
  signal st_next        : std_logic_vector(3 downto 0);
  signal word_cnt_en    : std_logic;
  signal ln_cnt_en      : std_logic;
  signal word_cnt_clr   : std_logic;
  signal ln_cnt_clr     : std_logic;
  signal set_locked     : std_logic;
  signal clr_locked     : std_logic;
  signal clr_errcnt     : std_logic;
  signal inc_errcnt     : std_logic;
  signal loops          : std_logic_vector(LOOPS_MSB downto 0) := (others => '0');
  signal clr_loops      : std_logic;
  signal inc_loops      : std_logic;
  signal loops_tc       : std_logic;
  signal ld_std         : std_logic;
  signal errcnt         : std_logic_vector(2 downto 0) := (others => '0');
  signal maxerrs        : std_logic;
  signal match          : std_logic;
  signal match_words    : std_logic := '0';
  signal match_lines    : std_logic := '1';
  signal compare_sel    : std_logic;
  signal cmp_mux        : std_logic_vector(3 downto 0);
  signal cmp_word_cnt       : std_logic_vector(HCNT_MSB-1 downto 0);
  signal wpl            : std_logic_vector(HCNT_MSB-1 downto 0);
  signal cmp_ln_cnt       : std_logic_vector(10 downto 0);
  signal first_act      : std_logic := '0';
  signal last_v         : std_logic := '0';
  signal vertical       : std_logic;
  signal field          : std_logic;
  signal trs_timeout    : std_logic;
  signal first_timeout  : std_logic;
  signal timeout        : std_logic;
  signal locked_r       : std_logic := '0';
  signal ln_valid_r     : std_logic := '0';
  signal rst_delay      : std_logic_vector(7 downto 0) := (others => '0');
  signal reset          : std_logic;
  signal ln_counter     : std_logic_vector(10 downto 0) := (others => '0');
  signal ln_init        : std_logic_vector(10 downto 0);
  signal ln_max         : std_logic_vector(10 downto 0);
  signal ln_tc          : std_logic;
  signal ln_load        : std_logic;
  signal std_r          : std_logic_vector(3 downto 0) := (others => '0');
  signal reacquire_r    : std_logic := '0';
  signal req_format_r   : std_logic := '0';
  signal last_code      : std_logic_vector(3 downto 0);
  signal mode_3ga_r     : std_logic := '0';

begin

  in_reg_p: process(clk, reset)
  begin
    if (reset = '1') then
      mode_3ga_r <= '0';
      req_format_r <= '0';
      reacquire_r <= '0';
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        mode_3ga_r <= mode_3ga;
        req_format_r <= req_format;
        reacquire_r <= req_format_r;
      end if;
    end if;
  end process;

  word_cnt_p: process(clk, reset)
  begin
    if (reset = '1') then
      word_cnt <= (others => '0');
      trs_to_counter <= (others => '0');
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        if (word_cnt_clr = '1') then
          word_cnt <= (others => '0');
        elsif (word_cnt_en = '1') then
          word_cnt <= std_logic_vector(unsigned(word_cnt) + 1);
        end if;
        if (eav = '1' or sav = '1') then
          trs_to_counter <= (others => '0');
        else
          trs_to_counter <= std_logic_vector(unsigned(trs_to_counter) + 1);
        end if;
        if (ln_cnt_clr = '1') then
          ln_cnt <= (others => '0');
        elsif (ln_cnt_en = '1' and eav = '1') then
            ln_cnt <= std_logic_vector(unsigned(ln_cnt) + 1);
        end if;
        if clr_errcnt = '1' then
          errcnt <= (others => '0');
        elsif inc_errcnt = '1' then
          errcnt <= std_logic_vector(unsigned(errcnt) + 1);
        end if;
        if clr_loops = '1' then
          loops <= (others => '0');
        elsif inc_loops = '1' then
          loops <= std_logic_vector(unsigned(loops) + 1);
        end if;
      end if;
    end if;
  end process;

  trs_tc <= (others => '1');
  trs_timeout <= '1' when trs_to_counter = trs_tc else '0';
  line_tc <= (others => '1');
  first_timeout <= '1' when ln_cnt = line_tc else '0';
  timeout <= trs_timeout or first_timeout;
  maxerrs <= '1' when errcnt = MAX_ERRCNT else '0';
  last_code <= LAST_VIDEO_FORMAT_CODE_3GA when mode_3ga_r = '1' else
                LAST_VIDEO_FORMAT_CODE_NORMAL;
  loops_tc <= '1' when loops = last_code else '0';

  v_std_r: process(clk, reset)
  begin
    if (reset = '1') then
      v_std <= (others => '0');
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        if ld_std = '1' then
          v_std <= loops;
        end if;
      end if;
    end if;
  end process;

  v_std_o <= v_std;
  vertical <= data_i(7);
  field <= data_i(8);

  v_timing_p: process(clk, reset)
  begin
    if (reset = '1') then
      last_v <= '0';
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        if eav = '1' then
          last_v <= vertical;
          first_act <= last_v and not vertical;
        end if;
      end if;
    end if;
  end process;

  locked_r_p: process(clk, reset)
  begin
    if (reset = '1') then
      locked_r <= '0';
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        if clr_locked = '1' then
          locked_r <= '0';
        elsif set_locked = '1' then
          locked_r <= '1';
        end if;
      end if;
    end if;
  end process;

  locked <= locked_r;

  comparison_p: process(cmp_mux)
  begin
    case cmp_mux is
      when HD_FMT_1035i_30    => cmp_word_cnt <= std_logic_vector(TO_UNSIGNED(2200, HCNT_MSB));
      when HD_FMT_1080i_25b   => cmp_word_cnt <= std_logic_vector(TO_UNSIGNED(2376, HCNT_MSB));
      when HD_FMT_1080i_30    => cmp_word_cnt <= std_logic_vector(TO_UNSIGNED(2200, HCNT_MSB));
      when HD_FMT_1080i_25    => cmp_word_cnt <= std_logic_vector(TO_UNSIGNED(2640, HCNT_MSB));
      when HD_FMT_1080p_30    => cmp_word_cnt <= std_logic_vector(TO_UNSIGNED(2200, HCNT_MSB));
      when HD_FMT_1080p_25    => cmp_word_cnt <= std_logic_vector(TO_UNSIGNED(2640, HCNT_MSB));
      when HD_FMT_1080p_24    => cmp_word_cnt <= std_logic_vector(TO_UNSIGNED(2750, HCNT_MSB));
      when HD_FMT_720p_60     => cmp_word_cnt <= std_logic_vector(TO_UNSIGNED(1650, HCNT_MSB));
      when HD_FMT_1080sF_24   => cmp_word_cnt <= std_logic_vector(TO_UNSIGNED(2750, HCNT_MSB));
      when HD_FMT_720p_50     => cmp_word_cnt <= std_logic_vector(TO_UNSIGNED(1980, HCNT_MSB));
      when HD_FMT_720p_30     => cmp_word_cnt <= std_logic_vector(TO_UNSIGNED(3300, HCNT_MSB));
      when HD_FMT_720p_25     => cmp_word_cnt <= std_logic_vector(TO_UNSIGNED(3960, HCNT_MSB));
      when HD_FMT_720p_24     => cmp_word_cnt <= std_logic_vector(TO_UNSIGNED(4125, HCNT_MSB));
      when HD_FMT_1080p_60    => cmp_word_cnt <= std_logic_vector(TO_UNSIGNED(1100, HCNT_MSB));
      when HD_FMT_1080p_50    => cmp_word_cnt <= std_logic_vector(TO_UNSIGNED(1320, HCNT_MSB));
      when others             => cmp_word_cnt <= std_logic_vector(TO_UNSIGNED(2200, HCNT_MSB));
    end case;
    case cmp_mux is
      when HD_FMT_1035i_30    => cmp_ln_cnt <= std_logic_vector(TO_UNSIGNED(517,  HD_VCNT_WIDTH));
      when HD_FMT_1080i_25b   => cmp_ln_cnt <= std_logic_vector(TO_UNSIGNED(540,  HD_VCNT_WIDTH));
      when HD_FMT_1080i_30    => cmp_ln_cnt <= std_logic_vector(TO_UNSIGNED(540,  HD_VCNT_WIDTH));
      when HD_FMT_1080i_25    => cmp_ln_cnt <= std_logic_vector(TO_UNSIGNED(540,  HD_VCNT_WIDTH));
      when HD_FMT_1080p_30    => cmp_ln_cnt <= std_logic_vector(TO_UNSIGNED(1080, HD_VCNT_WIDTH));
      when HD_FMT_1080p_25    => cmp_ln_cnt <= std_logic_vector(TO_UNSIGNED(1080, HD_VCNT_WIDTH));
      when HD_FMT_1080p_24    => cmp_ln_cnt <= std_logic_vector(TO_UNSIGNED(1080, HD_VCNT_WIDTH));
      when HD_FMT_720p_60     => cmp_ln_cnt <= std_logic_vector(TO_UNSIGNED(720,  HD_VCNT_WIDTH));
      when HD_FMT_1080sF_24   => cmp_ln_cnt <= std_logic_vector(TO_UNSIGNED(540,  HD_VCNT_WIDTH));
      when HD_FMT_720p_50     => cmp_ln_cnt <= std_logic_vector(TO_UNSIGNED(720,  HD_VCNT_WIDTH));
      when HD_FMT_720p_30     => cmp_ln_cnt <= std_logic_vector(TO_UNSIGNED(720,  HD_VCNT_WIDTH));
      when HD_FMT_720p_25     => cmp_ln_cnt <= std_logic_vector(TO_UNSIGNED(720,  HD_VCNT_WIDTH));
      when HD_FMT_720p_24     => cmp_ln_cnt <= std_logic_vector(TO_UNSIGNED(720,  HD_VCNT_WIDTH));
      when HD_FMT_1080p_60    => cmp_ln_cnt <= std_logic_vector(TO_UNSIGNED(1080, HD_VCNT_WIDTH));
      when HD_FMT_1080p_50    => cmp_ln_cnt <= std_logic_vector(TO_UNSIGNED(1080, HD_VCNT_WIDTH));
      when others             => cmp_ln_cnt <= std_logic_vector(TO_UNSIGNED(540,  HD_VCNT_WIDTH));
    end case;
  end process;

    cmp_mux <= v_std when compare_sel = '1' else loops;
    wpl <= word_cnt(HCNT_MSB downto 1) when mode_3ga_r = '1' else
           word_cnt(HCNT_MSB-1 downto 0);

  match_p: process(clk, reset)
  begin
    if (reset = '1') then
      match_words <= '0';
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        if wpl = cmp_word_cnt then
          match_words <= '1';
        else
          match_words <= '0';
        end if;
        if ln_cnt = cmp_ln_cnt then
          match_lines <= '1';
        else
          match_lines <= '0';
        end if;
      end if;
    end if;
  end process;

  match <= match_words and match_lines;

  fsm_st_p: process(clk, reset)
  begin
    if (reset = '1') then
      st_current <= ST_ACQ0;
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        if reacquire_r = '1' then
          st_current <= ST_ACQ0;
        else
          st_current <= st_next;
        end if;
      end if;
    end if;
  end process;

  fsm_p: process(st_current, sav, first_act, vertical, loops_tc, match, maxerrs, timeout, field)
  begin
    word_cnt_en     <= '0';
    ln_cnt_en       <= '0';
    word_cnt_clr    <= '0';
    ln_cnt_clr      <= '0';
    set_locked      <= '0';
    clr_locked      <= '0';
    clr_errcnt      <= '0';
    inc_errcnt      <= '0';
    clr_loops       <= '0';
    inc_loops       <= '0';
    ld_std          <= '0';
    compare_sel     <= '0';
    case st_current is
      when ST_ACQ0 =>
        clr_errcnt <= '1';
        clr_locked <= '1';
        word_cnt_clr <= '1';
        ln_cnt_clr <= '1';
        if sav = '1' and first_act = '1' then
          st_next <= ST_ACQ1;
        else
          st_next <= ST_ACQ0;
        end if;
      when ST_ACQ1 =>
        word_cnt_en <= '1';
        ln_cnt_en <= '1';
        if sav = '1' then
          st_next <= ST_ACQ2;
        else
          st_next <= ST_ACQ1;
        end if;
      when ST_ACQ2 =>
        ln_cnt_en <= '1';
        if sav = '1' and vertical = '1' then
          st_next <= ST_ACQ3;
        else
          st_next <= ST_ACQ2;
        end if;
      when ST_ACQ3 =>
        clr_loops <= '1'; 
        st_next <= ST_ACQ4;
      when ST_ACQ4 => 
        st_next <= ST_ACQ5;
      when ST_ACQ5 =>
        if match = '1' then
          st_next <= ST_ACQ7;
        else
          st_next <= ST_ACQ6;
        end if;
      when ST_ACQ6 =>
        inc_loops <= '1';
        if loops_tc = '1' then
          st_next <= ST_ACQ0;
        else
          st_next <= ST_ACQ4;
        end if;
      when ST_ACQ7 =>
        ld_std <= '1';
        word_cnt_clr <= '1';
        set_locked <= '1';
        st_next <= ST_LCK0;
      when ST_LCK0 =>
        word_cnt_en <= '1';
        ln_cnt_clr <= '1';
        compare_sel <= '1';
        if sav = '1' then
            word_cnt_clr <= '1';
        end if;
        if timeout = '1' then
          st_next <= ST_ERR;
        elsif sav = '1' and first_act = '1' and field = '0' then
          st_next <= ST_LCK1;
        else
          st_next <= ST_LCK0;
        end if;
      when ST_LCK1 =>
        word_cnt_en <= '1';
        ln_cnt_en <= '1';
        compare_sel <= '1';
        if timeout = '1' then
          st_next <= ST_ERR;
        elsif sav = '1' then
          st_next <= ST_LCK2;
        else
          st_next <= ST_LCK1;
        end if;
      when ST_LCK2 =>
        ln_cnt_en <= '1';
        compare_sel <= '1';
        if timeout = '1' then
          st_next <= ST_ERR;
        elsif sav = '1' and vertical = '1' then
          st_next <= ST_LCK3;
        else
          st_next <= ST_LCK2;
        end if;
      when ST_LCK3 =>
        compare_sel <= '1';
        st_next <= ST_LCK4;
      when ST_LCK4 =>
        compare_sel <= '1';
        word_cnt_clr <= '1';
        if match = '1' then
            clr_errcnt <= '1';
        end if;
        if match = '1' then
          st_next <= ST_LCK0;
        else
          st_next <= ST_ERR;
        end if;
      when ST_ERR =>
        inc_errcnt <= '1';
        word_cnt_clr <= '1';
        compare_sel <= '1';
        if maxerrs = '1' then
          st_next <= ST_ACQ0;
        else
          st_next <= ST_LCK0;
        end if;
      when others =>
        st_next <= ST_ACQ0;
    end case;
  end process;

  reset <= rst or not rst_delay(7);

  rst_p: process(clk, rst)
  begin
    if (rst = '1') then
      rst_delay <= (others => '0');
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        rst_delay <= (rst_delay(6 downto 0) & '1');
      end if;
    end if;
  end process;

  ln_out_gen_p: process(clk, rst)
  begin
    if (rst = '1') then
      std_r <= (others => '0');
      ln_valid_r <= '0';
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        if set_locked = '1' then
          std_r <= v_std;
        end if;
        if locked_r = '0' then
          ln_valid_r <= '0';
        elsif eav = '1' and ln_load = '1' then
          ln_valid_r <= '1';
        end if;
      end if;
    end if;
  end process;

  ln_load <= last_v and not vertical;

  ln_valid <= ln_valid_r;

  std_p: process(std_r, field)
  begin
    case std_r is
      when HD_FMT_1035i_30 =>
        ln_max <= std_logic_vector(TO_UNSIGNED(1125, HD_VCNT_WIDTH));
        if field = '0' then
          ln_init <= std_logic_vector(TO_UNSIGNED(41,  HD_VCNT_WIDTH));
        else
          ln_init <= std_logic_vector(TO_UNSIGNED(603,  HD_VCNT_WIDTH));
        end if;
      when HD_FMT_1080i_25b =>
        ln_max <= std_logic_vector(TO_UNSIGNED(1250, HD_VCNT_WIDTH));
        if field = '0' then
          ln_init <= std_logic_vector(TO_UNSIGNED(81,  HD_VCNT_WIDTH));
        else
          ln_init <= std_logic_vector(TO_UNSIGNED(706,  HD_VCNT_WIDTH));
        end if;
      when HD_FMT_1080i_30 =>
        ln_max <= std_logic_vector(TO_UNSIGNED(1125, HD_VCNT_WIDTH));
        if field = '0' then
          ln_init <= std_logic_vector(TO_UNSIGNED(21,  HD_VCNT_WIDTH));
        else
          ln_init <= std_logic_vector(TO_UNSIGNED(584,  HD_VCNT_WIDTH));
        end if;
      when HD_FMT_1080i_25 =>
        ln_max <= std_logic_vector(TO_UNSIGNED(1125, HD_VCNT_WIDTH));
        if field = '0' then
          ln_init <= std_logic_vector(TO_UNSIGNED(21,  HD_VCNT_WIDTH));
        else
          ln_init <= std_logic_vector(TO_UNSIGNED(584,  HD_VCNT_WIDTH));
        end if;
      when HD_FMT_1080p_30 =>
        ln_max <= std_logic_vector(TO_UNSIGNED(1125, HD_VCNT_WIDTH));
        ln_init <= std_logic_vector(TO_UNSIGNED(42,  HD_VCNT_WIDTH));
      when HD_FMT_1080p_25 =>
        ln_max <= std_logic_vector(TO_UNSIGNED(1125, HD_VCNT_WIDTH));
        ln_init <= std_logic_vector(TO_UNSIGNED(42,  HD_VCNT_WIDTH));
      when HD_FMT_1080p_24 =>
        ln_max <= std_logic_vector(TO_UNSIGNED(1125, HD_VCNT_WIDTH));
        ln_init <= std_logic_vector(TO_UNSIGNED(42,  HD_VCNT_WIDTH));
      when HD_FMT_720p_60 =>
        ln_max <= std_logic_vector(TO_UNSIGNED(750, HD_VCNT_WIDTH));
        ln_init <= std_logic_vector(TO_UNSIGNED(26,  HD_VCNT_WIDTH));
      when HD_FMT_720p_50 =>
        ln_max <= std_logic_vector(TO_UNSIGNED(750, HD_VCNT_WIDTH));
        ln_init <= std_logic_vector(TO_UNSIGNED(26,  HD_VCNT_WIDTH));
      when HD_FMT_720p_30 =>
        ln_max <= std_logic_vector(TO_UNSIGNED(750, HD_VCNT_WIDTH));
        ln_init <= std_logic_vector(TO_UNSIGNED(26,  HD_VCNT_WIDTH));
      when HD_FMT_720p_25 =>
        ln_max <= std_logic_vector(TO_UNSIGNED(750, HD_VCNT_WIDTH));
        ln_init <= std_logic_vector(TO_UNSIGNED(26,  HD_VCNT_WIDTH));
      when HD_FMT_720p_24 =>
        ln_max <= std_logic_vector(TO_UNSIGNED(750, HD_VCNT_WIDTH));
        ln_init <= std_logic_vector(TO_UNSIGNED(26,  HD_VCNT_WIDTH));
      when HD_FMT_1080sF_24 =>
        ln_max <= std_logic_vector(TO_UNSIGNED(1125, HD_VCNT_WIDTH));
        if field = '0' then
          ln_init <= std_logic_vector(TO_UNSIGNED(21,  HD_VCNT_WIDTH));
        else
          ln_init <= std_logic_vector(TO_UNSIGNED(584,  HD_VCNT_WIDTH));
        end if;
      when HD_FMT_1080p_60 =>
        ln_max <= std_logic_vector(TO_UNSIGNED(1125, HD_VCNT_WIDTH));
        ln_init <= std_logic_vector(TO_UNSIGNED(21,  HD_VCNT_WIDTH));
      when HD_FMT_1080p_50 => 
        ln_max <= std_logic_vector(TO_UNSIGNED(1125, HD_VCNT_WIDTH));
        ln_init <= std_logic_vector(TO_UNSIGNED(21,  HD_VCNT_WIDTH));
      when others =>
        ln_max <= std_logic_vector(TO_UNSIGNED(1125, HD_VCNT_WIDTH));
        ln_init <= std_logic_vector(TO_UNSIGNED(21,  HD_VCNT_WIDTH));
    end case;   
  end process;

  ln_tc <= '1' when ln_counter = ln_max else '0';

  ln_cnt_p: process(clk, reset)
  begin
    if (reset = '1') then
      ln_counter <= (0 => '1', others => '0');
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        if eav = '1' then
          if ln_load = '1' then
            ln_counter <= ln_init;
          elsif ln_tc = '1' then
            ln_counter <= (0 => '1', others => '0');
          else
            ln_counter <= std_logic_vector(unsigned(ln_counter) + 1);
          end if;
        end if;
      end if;
    end if;
  end process;

  ln_o <= ln_counter;

end rtl;
