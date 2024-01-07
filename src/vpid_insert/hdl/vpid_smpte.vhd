library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity vpid_smpte is
  generic(
    DATA_W      : positive := 10;
    VERT_POS_W  : positive := 11
  );
  port (
    clk       : in  std_logic;
    clk_en    : in  std_logic;
    rst       : in  std_logic;
    hd_sd     : in  std_logic;
    lvl_b     : in  std_logic;
    en        : in  std_logic;
    overwrite : in  std_logic;
    line      : in  std_logic_vector(VERT_POS_W - 1 downto 0);
    line_a    : in  std_logic_vector(VERT_POS_W - 1 downto 0);
    line_b    : in  std_logic_vector(VERT_POS_W - 1 downto 0);
    line_b_en : in  std_logic;
    byte1     : in  std_logic_vector(DATA_W - 1 downto 0);
    byte2     : in  std_logic_vector(DATA_W - 1 downto 0);
    byte3     : in  std_logic_vector(DATA_W - 1 downto 0);
    byte4     : in  std_logic_vector(DATA_W - 1 downto 0);
    y_i       : in  std_logic_vector(DATA_W - 1 downto 0);
    c_i       : in  std_logic_vector(DATA_W - 1 downto 0);
    y_o       : out std_logic_vector(DATA_W - 1 downto 0);
    c_o       : out std_logic_vector(DATA_W - 1 downto 0);
    eav_o     : out std_logic;
    sav_o     : out std_logic
);

end vpid_smpte;

architecture rtl of vpid_smpte is

  subtype  ST_TYPE is std_logic_vector(5 downto 0);
  subtype  SEL_MUX_TYPE is std_logic_vector(3 downto 0);

  constant ST_WAIT        : ST_TYPE := "000000";
  constant ST_ADF0        : ST_TYPE := "000001";
  constant ST_ADF1        : ST_TYPE := "000010";
  constant ST_ADF2        : ST_TYPE := "000011";
  constant ST_DID         : ST_TYPE := "000100";
  constant ST_SDID        : ST_TYPE := "000101";
  constant ST_DC          : ST_TYPE := "000110";
  constant ST_B0          : ST_TYPE := "000111";
  constant ST_B1          : ST_TYPE := "001000";
  constant ST_B2          : ST_TYPE := "001001";
  constant ST_B3          : ST_TYPE := "001010";
  constant ST_CS          : ST_TYPE := "001011";
  constant ST_DID2        : ST_TYPE := "001100";
  constant ST_SDID2       : ST_TYPE := "001101";
  constant ST_DC2         : ST_TYPE := "001110";
  constant ST_UDW         : ST_TYPE := "001111";
  constant ST_CS2         : ST_TYPE := "010000";
  constant ST_INS_ADF0    : ST_TYPE := "010001";
  constant ST_INS_ADF1    : ST_TYPE := "010010";
  constant ST_INS_ADF2    : ST_TYPE := "010011";
  constant ST_INS_DID     : ST_TYPE := "010100";
  constant ST_INS_SDID    : ST_TYPE := "010101";
  constant ST_INS_DC      : ST_TYPE := "010110";
  constant ST_INS_B0      : ST_TYPE := "010111";
  constant ST_INS_B1      : ST_TYPE := "011000";
  constant ST_INS_B2      : ST_TYPE := "011001";
  constant ST_INS_B3      : ST_TYPE := "011010";
  constant ST_ADF0_X      : ST_TYPE := "011011";
  constant ST_ADF1_X      : ST_TYPE := "011100";
  constant ST_ADF2_X      : ST_TYPE := "011101";
  constant ST_DID_X       : ST_TYPE := "011110";
  constant ST_SDID_X      : ST_TYPE := "011111";
  constant ST_DC_X        : ST_TYPE := "100000";
  constant ST_UDW_X       : ST_TYPE := "100001";
  constant ST_CS_X        : ST_TYPE := "100010";

  constant SEL_MUX_000    : SEL_MUX_TYPE := "0000";
  constant SEL_MUX_3FF    : SEL_MUX_TYPE := "0001";
  constant SEL_MUX_DID    : SEL_MUX_TYPE := "0010";
  constant SEL_MUX_SDID   : SEL_MUX_TYPE := "0011";
  constant SEL_MUX_DC     : SEL_MUX_TYPE := "0100";
  constant SEL_MUX_UDW    : SEL_MUX_TYPE := "0101";
  constant SEL_MUX_CS     : SEL_MUX_TYPE := "0110";
  constant SEL_MUX_DEL    : SEL_MUX_TYPE := "0111";
  constant SEL_MUX_VID    : SEL_MUX_TYPE := "1000";

  signal vid0_r         : std_logic_vector(DATA_W - 1 downto 0) := (others => '0');
  signal vid1_r         : std_logic_vector(DATA_W - 1 downto 0) := (others => '0');
  signal vid2_r         : std_logic_vector(DATA_W - 1 downto 0) := (others => '0');
  signal vid_dly        : std_logic_vector(DATA_W - 1 downto 0) := (others => '0');
  signal all_ones_i     : std_logic;
  signal all_zeros_i    : std_logic;
  signal all_zeros_pipe : std_logic_vector(2 downto 0) := (others => '0');
  signal all_ones_pipe  : std_logic_vector(2 downto 0) := (others => '0');
  signal xyz            : std_logic;
  signal eav_n          : std_logic;
  signal sav_n          : std_logic;
  signal anc_n          : std_logic;
  signal hanc_start_n   : std_logic;
  signal hanc_dly       : std_logic_vector(3 downto 0);
  signal in_r           : std_logic_vector(DATA_W - 1 downto 0) := (others => '0');
  signal vid_o          : std_logic_vector(DATA_W - 1 downto 0) := (others => '0');
  signal line_match_a   : std_logic;
  signal line_match_b   : std_logic;
  signal vpid_line      : std_logic := '0';
  signal vpid_pkt       : std_logic;
  signal del_pkt_ok     : std_logic;
  signal udw_cntr       : std_logic_vector(7 downto 0) := (others => '0');
  signal udw_cntr_mux   : std_logic_vector(7 downto 0) := (others => '0');
  signal ld_udw_cntr    : std_logic;
  signal udw_cntr_tc    : std_logic;
  signal cs_r           : std_logic_vector(8 downto 0) := (others => '0');
  signal clr_cs_r       : std_logic;
  signal vpid_mux       : std_logic_vector(7 downto 0);
  signal vpid_mux_sel   : std_logic_vector(1 downto 0);
  signal out_mux_sel    : SEL_MUX_TYPE;
  signal parity         : std_logic;
  signal sav_timing     : std_logic_vector(3 downto 0) := (others => '0');
  signal eav_timing     : std_logic_vector(3 downto 0) := (others => '0');
  signal current_st     : ST_TYPE := ST_WAIT;
  signal next_st        : ST_TYPE;
  signal y_o_r          : std_logic_vector(DATA_W - 1 downto 0) := (others => '0');
  signal eav_o_r        : std_logic := '0';
  signal sav_o_r        : std_logic := '0';
  signal byte1_r        : std_logic_vector(7 downto 0) := (others => '0');
  signal byte2_r        : std_logic_vector(7 downto 0) := (others => '0');
  signal byte3_r        : std_logic_vector(7 downto 0) := (others => '0');
  signal byte4_r        : std_logic_vector(7 downto 0) := (others => '0');
  signal shift_r0       : std_logic_vector(DATA_W - 1 downto 0) := (others => '0');
  signal shift_r1       : std_logic_vector(DATA_W - 1 downto 0) := (others => '0');

 
begin

  in_reg_pipe_p: process(clk)
  begin
    if (rst = '1') then
      in_r    <= (others => '0');
      vid0_r  <= (others => '0');
      vid1_r  <= (others => '0');
      vid2_r  <= (others => '0');
      vid_dly <= (others => '0');
      byte1_r <= (others => '0');
      byte2_r <= (others => '0');
      byte3_r <= (others => '0');
      byte4_r <= (others => '0');
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        in_r    <= y_i;
        vid0_r  <= in_r;
        vid1_r  <= vid0_r;
        vid2_r  <= vid1_r;
        vid_dly   <= vid2_r;
        byte1_r <= byte1;
        byte2_r <= byte2;
        byte3_r <= byte3;
        byte4_r <= byte4;
      end if;
    end if;
  end process;

  all_ones_i  <= '1' when in_r = "1111111111" else '0';
  all_zeros_i <= '1' when in_r = "0000000000" else '0';

  zeros_ones_p: process(clk, rst)
  begin
      if (rst = '1') then
          all_zeros_pipe <= (others => '0');
          all_ones_pipe <= (others => '0');
      elsif rising_edge(clk) then
          if (clk_en = '1') then
              all_zeros_pipe <= (all_zeros_pipe(1 downto 0) & all_zeros_i);
              all_ones_pipe <= (all_ones_pipe(1 downto 0) & all_ones_i);
          end if;
      end if;
  end process;

  xyz <= all_ones_pipe(2) and all_zeros_pipe(1) and all_zeros_pipe(0);

  eav_n <= xyz and in_r(6);
  sav_n <= xyz and not in_r(6);
  anc_n <= (all_zeros_pipe(2) and all_ones_pipe(1) and all_ones_pipe(0));

  eav_6dly_p: process(clk, rst)
  begin
    if (rst = '1') then
      shift_r0 <= (others => '0');
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        if (hd_sd = '1') then
          for i in 0 to 15 loop
            if (i < 3) then
              shift_r0(i) <= eav_n;
            else
              shift_r0(i) <= shift_r0(i - 3);
            end if;
          end loop;
        else
          for i in 0 to 15 loop
            if (i < 7) then
              shift_r0(i) <= eav_n;
            else
              shift_r0(i) <= shift_r0(i - 7);
            end if;
          end loop;
        end if;
      end if;
    end if;
  end process;

  hanc_start_n <=  shift_r0(DATA_W - 1);

  line_match_a <= '1' when line = line_a else '0';
  line_match_b <= '1' when line = line_b else '0';

  line_match_p: process(clk, rst)
  begin
    if (rst = '1') then
      vpid_line <= '0';
    elsif rising_edge(clk) then
        if (clk_en = '1') then
          vpid_line <= line_match_a or (line_match_b and line_b_en);
        end if;
      end if;
  end process;

  vpid_pkt  <=  '1' when  (vid2_r(7 downto 0) = "01000001") and (vid1_r(7 downto 0) = "00000001") 
                else '0';

  del_pkt_ok <= '1' when  (vid2_r(7 downto 0) = "10000000") and (vid0_r(7 downto 0) = "00000100") 
                else '0';

    udw_cntr_mux <= vid_dly(7 downto 0) when ld_udw_cntr = '1' else udw_cntr;
    udw_cntr_tc  <= '1' when udw_cntr_mux = "00000000" else '0';

    udw_cntl_p: process(clk, rst)
    begin
      if (rst = '1') then
        udw_cntr <= (others => '0');
      elsif rising_edge(clk) then
        if (clk_en = '1') then
          udw_cntr <= std_logic_vector(unsigned(udw_cntr_mux) - 1);
        end if;
      end if;
    end process;

  checksum_gen_p: process(clk, rst)
  begin
    if (rst = '1') then
      cs_r <= (others => '0');
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        if (clr_cs_r = '1') then
          cs_r <= (others => '0');
        else
          cs_r <= std_logic_vector(unsigned(cs_r) + unsigned(vid_o(8 downto 0)));
        end if;
      end if;
    end if;
  end process;

  with  vpid_mux_sel select
        vpid_mux <= byte1_r when "00",
                    byte2_r when "01",
                    byte3_r when "10",
                    byte4_r when others;

  parity <= vpid_mux(7) xor vpid_mux(6) xor vpid_mux(5) xor vpid_mux(4) xor
            vpid_mux(3) xor vpid_mux(2) xor vpid_mux(1) xor vpid_mux(0);

  with out_mux_sel select
      vid_o <=  "0000000000"                      when SEL_MUX_000,
                "1111111111"                      when SEL_MUX_3FF,
                "1001000001"                      when SEL_MUX_DID,
                "0100000001"                      when SEL_MUX_SDID,
                "0100000100"                      when SEL_MUX_DC,
                (not parity & parity & vpid_mux)  when SEL_MUX_UDW,
                (not cs_r(8) & cs_r)              when SEL_MUX_CS,
                "0110000000"                      when SEL_MUX_DEL,
                vid_dly                           when others;

  process(clk, rst)
  begin
    if (rst = '1') then
      cs_r <= (others => '0');
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        y_o_r <= vid_o;
      end if;
    end if;
  end process;

  y_o <= y_o_r;

  c_ch_6dly_p: process(clk, rst)
  begin
    if (rst = '1') then
      shift_r1 <= (others => '0');
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        for i in 0 to 15 loop
          if (i < 10) then
            shift_r1(i) <= c_i(i);
          else
            shift_r1(i) <= shift_r1(i - 10);
          end if;
        end loop;
      end if;
    end if;
  end process;

  c_o <= shift_r1 when clk_en = '1' else (others => '0');

  eav_sav_o_gen_p: process(clk, rst)
  begin
    if (rst = '1') then
      eav_timing <= (others => '0');
      eav_o_r <= '0';
      sav_timing <= (others => '0');
      sav_o_r <= '0';
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        eav_timing <= (eav_timing(2 downto 0) & eav_n);
        eav_o_r <= eav_timing(3);
        sav_timing <= (sav_timing(2 downto 0) & sav_n);
        sav_o_r <= sav_timing(3);
      end if;
    end if;
  end process;

  eav_o <= eav_o_r;
  sav_o <= sav_o_r;

  fsm_current_st_r_p: process(clk, rst)
  begin
    if (rst = '1') then
      current_st <= ST_WAIT;
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        if (sav_n = '1') then
          current_st <= ST_WAIT;
        else
          current_st <= next_st;
        end if;
      end if;
    end if;
  end process;

  fsm_next_st_p: process(current_st, en, vpid_line, hanc_start_n, anc_n,
                          overwrite, vpid_pkt, del_pkt_ok, udw_cntr_tc)
  begin
    case current_st is
      when ST_WAIT => 
        if en = '1' and vpid_line = '1' and hanc_start_n = '1' then
          if anc_n = '1' then
            next_st <= ST_ADF0;
          else
            next_st <= ST_INS_ADF0;
          end if;
        elsif en = '1' and vpid_line = '0' and anc_n = '1' and overwrite = '1' then
          next_st <= ST_ADF0_X;
        else
          next_st <= ST_WAIT;
        end if;
      when ST_ADF0 => 
        next_st <= ST_ADF1;
      when ST_ADF1 => 
        next_st <= ST_ADF2;
      when ST_ADF2 => 
        if vpid_pkt = '1' then
          next_st <= ST_DID;
        elsif del_pkt_ok = '1' then
          next_st <= ST_INS_DID;
        else
          next_st <= ST_DID2;
        end if; 
      when ST_DID => 
        next_st <= ST_SDID;
      when ST_SDID =>
        if overwrite = '1' then
          next_st <= ST_INS_DC;
        else
          next_st <= ST_DC;
        end if;
      when ST_DC => 
        next_st <= ST_B0;
      when ST_B0 => 
        next_st <= ST_B1;
      when ST_B1 => 
        next_st <= ST_B2;
      when ST_B2 => 
        next_st <= ST_B3;
      when ST_B3 => 
        next_st <= ST_CS;
      when ST_CS => 
        next_st <= ST_WAIT;
      when ST_DID2 => 
        next_st <= ST_SDID2;
      when ST_SDID2 => 
        next_st <= ST_DC2;
      when ST_DC2 => 
        if udw_cntr_tc = '1' then
          next_st <= ST_CS2;
        else
          next_st <= ST_UDW;
        end if;
      when ST_UDW => 
        if udw_cntr_tc = '1' then
          next_st <= ST_CS2;
        else
          next_st <= ST_UDW;
        end if;
      when ST_CS2 => 
        if anc_n = '1' then
          next_st <= ST_ADF0;
        else
          next_st <= ST_INS_ADF0;
        end if;
      when ST_INS_ADF0 => 
        next_st <= ST_INS_ADF1;
      when ST_INS_ADF1 => 
        next_st <= ST_INS_ADF2;
      when ST_INS_ADF2 => 
        next_st <= ST_INS_DID;
      when ST_INS_DID => 
        next_st <= ST_INS_SDID;
      when ST_INS_SDID => 
        next_st <= ST_INS_DC;
      when ST_INS_DC => 
        next_st <= ST_INS_B0;
      when ST_INS_B0 => 
        next_st <= ST_INS_B1;
      when ST_INS_B1 => 
        next_st <= ST_INS_B2;
      when ST_INS_B2 => 
        next_st <= ST_INS_B3;
      when ST_INS_B3 => 
        next_st <= ST_CS;
      when ST_ADF0_X => 
        next_st <= ST_ADF1_X;
      when ST_ADF1_X => 
        next_st <= ST_ADF2_X;
      when ST_ADF2_X => 
        if vpid_pkt = '1' then
          next_st <= ST_DID_X;
        else
          next_st <= ST_WAIT;
        end if;
      when ST_DID_X => 
        next_st <= ST_SDID_X;
      when ST_SDID_X => 
        next_st <= ST_DC_X;
      when ST_DC_X => 
        if udw_cntr_tc = '1' then
          next_st <= ST_CS_X;
        else
          next_st <= ST_UDW_X;
        end if;     
      when ST_UDW_X => 
        if udw_cntr_tc = '1' then
          next_st <= ST_CS_X;
        else
          next_st <= ST_UDW_X;
        end if; 
      when ST_CS_X => 
        if anc_n = '1' then
          next_st <= ST_ADF0_X;
        else
          next_st <= ST_WAIT;
        end if;
      when others => 
        next_st <= ST_WAIT;
    end case;
  end process;

  fsm_out_p: process(current_st, lvl_b)
  begin
    out_mux_sel     <= SEL_MUX_VID;
    ld_udw_cntr     <= '0';
    clr_cs_r        <= '0';
    vpid_mux_sel    <= "00";
    case current_st is
      when ST_ADF2 =>
        clr_cs_r <= '1';
      when ST_B0 =>
        if lvl_b = '1' then
          out_mux_sel <= SEL_MUX_UDW;
        else
          out_mux_sel <= SEL_MUX_VID;
        end if;
        vpid_mux_sel <= "00";
      when ST_CS =>
        out_mux_sel <= SEL_MUX_CS;
      when ST_DC2 => 
        ld_udw_cntr <= '1';
      when ST_INS_ADF0 =>
        out_mux_sel <= SEL_MUX_000;
      when ST_INS_ADF1 =>
        out_mux_sel <= SEL_MUX_3FF;
      when ST_INS_ADF2 =>
        out_mux_sel <= SEL_MUX_3FF;
        clr_cs_r <= '1';
      when ST_INS_DID =>
        out_mux_sel <= SEL_MUX_DID;
      when ST_INS_SDID =>
        out_mux_sel <= SEL_MUX_SDID;
      when ST_INS_DC =>
        out_mux_sel <= SEL_MUX_DC;
      when ST_INS_B0 =>
        out_mux_sel <= SEL_MUX_UDW;
        vpid_mux_sel <= "00";
      when ST_INS_B1 =>
        out_mux_sel <= SEL_MUX_UDW;
        vpid_mux_sel <= "01";
      when ST_INS_B2 =>
        out_mux_sel <= SEL_MUX_UDW;
        vpid_mux_sel <= "10";
      when ST_INS_B3 =>
        out_mux_sel <= SEL_MUX_UDW;
        vpid_mux_sel <= "11";
      when ST_ADF2_X =>
        clr_cs_r <= '1';
      when ST_DID_X =>
        out_mux_sel <= SEL_MUX_DEL;
      when ST_DC_X =>
        ld_udw_cntr <= '1';
      when ST_CS_X =>
        out_mux_sel <= SEL_MUX_CS;
      when others =>
        out_mux_sel <= SEL_MUX_VID;
        ld_udw_cntr <= '0';
        vpid_mux_sel <= "00";
        clr_cs_r  <= '0';
    end case;
  end process;

end rtl;