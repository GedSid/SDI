
library ieee;
  use ieee.std_logic_1164.all;

entity framer is
  generic(
    DATA_W : positive := 10
  );
  port (
    clk      : in  std_logic;
    rst      : in  std_logic;
    clk_en   : in  std_logic;
    hd_notsd : in  std_logic;
    data_i   : in  std_logic_vector(2*DATA_W-1 downto 0);
    frame_en : in  std_logic;
    data_c_o : out std_logic_vector(DATA_W-1 downto 0);
    data_y_o : out std_logic_vector(DATA_W-1 downto 0);
    trs      : out std_logic := '0';
    xyz      : out std_logic;
    eav      : out std_logic;
    sav      : out std_logic;
    trs_err  : out std_logic;
    nsp      : out std_logic := '1'
  );
end framer;

architecture rtl of framer is

  signal data_r           : std_logic_vector(2*DATA_W-1 downto 0) := (others => '0');
  signal data_dly         : std_logic_vector(2*DATA_W-1 downto 0) := (others => '0');
  signal data_dly2        : std_logic_vector(2*DATA_W-1 downto 0) := (others => '0');
  signal offset_reg       : std_logic_vector(4 downto 0) := (others => '0');
  signal barrel_in        : std_logic_vector(38 downto 0) := (others => '0');
  signal trs_out          : std_logic_vector(3 downto 0) := (others => '0');
  signal bs_1_out         : std_logic_vector(34 downto 0);
  signal bs_2_out         : std_logic_vector(22 downto 0);
  signal hd_in_0          : std_logic_vector(38 downto 0);
  signal hd_in_1          : std_logic_vector(38 downto 0);
  signal hd_ones_in       : std_logic_vector(2*DATA_W-1 downto 0);
  signal hd_zeros_in      : std_logic_vector(2*DATA_W-1 downto 0);
  signal hd_zeros_dly     : std_logic_vector(2*DATA_W-1 downto 0) := (others => '0');
  signal hd_is_trs     : std_logic_vector(2*DATA_W-1 downto 0);
  signal hd_trs_detected  : std_logic;
  signal hd_trs_err       : std_logic;
  signal hd_bin_offset    : std_logic_vector(4 downto 0);
  signal barrel_out       : std_logic_vector(2*DATA_W-1 downto 0);
  signal new_offset       : std_logic;
  signal bs_in            : std_logic_vector(50 downto 0);
  signal bs_sel_1         : std_logic;
  signal bs_sel_2         : std_logic_vector(1 downto 0);
  signal bs_sel_3         : std_logic_vector(1 downto 0);
  signal data_c           : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal data_y           : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal xyz_int          : std_logic := '0';
  signal zeros            : std_logic_vector(2*DATA_W-1 downto 0);
  signal sd_in_vector     : std_logic_vector(38 downto 0);
  signal sd_trs_match1    : std_logic_vector(9 downto 0);
  signal sd_trs_match2    : std_logic_vector(9 downto 0);
  signal sd_trs_match3    : std_logic_vector(9 downto 0);
  signal sd_trs_match_all : std_logic_vector(9 downto 0);
  signal sd_trs_match1_l1 : std_logic_vector(2*DATA_W-5 downto 0);
  signal sd_trs_match2_l1 : std_logic_vector(2*DATA_W-5 downto 0);
  signal sd_trs_match3_l1 : std_logic_vector(2*DATA_W-5 downto 0);
  signal sd_trs_detected  : std_logic;
  signal sd_offset_bin    : std_logic_vector(3 downto 0);
  signal trs_detected     : std_logic;
  signal sd_trs_err       : std_logic;
  signal offset_val       : std_logic_vector(4 downto 0);

  attribute keep : string;
  attribute keep of sd_trs_detected : signal is "TRUE";
  attribute keep of sd_trs_err : signal is "TRUE";

begin

  zeros <= (others => '0');

  in_and_dly_reg_p: process(clk, rst)
  begin
    if (rst = '1') then
      data_r <= (others => '0');
      data_dly <= (others => '0');
      data_dly2 <= (others => '0');
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        data_r <= data_i;
        data_dly <= data_r;
        data_dly2 <= data_dly;
      end if;
    end if;
  end process;


  hd_in_0 <= (data_i(2*DATA_W-2 downto 0) & data_r);
  hd_in_1 <= (data_dly(2*DATA_W-2 downto 0) & data_dly2);

  detect_0_p: process(hd_in_0)
  begin
    for l in 0 to 2*DATA_W-1 loop
      hd_zeros_in(l) <= not ( hd_in_0(l+2*DATA_W-1) or hd_in_0(l+2*DATA_W-2) or
                              hd_in_0(l+2*DATA_W-3) or hd_in_0(l+2*DATA_W-4) or
                              hd_in_0(l+2*DATA_W-5) or hd_in_0(l+2*DATA_W-6) or 
                              hd_in_0(l+2*DATA_W-7) or hd_in_0(l+2*DATA_W-8) or
                              hd_in_0(l+  DATA_W+1) or hd_in_0(l+  DATA_W  ) or
                              hd_in_0(l+  DATA_W-1) or hd_in_0(l+  DATA_W-2) or
                              hd_in_0(l+  DATA_W-3) or hd_in_0(l+  DATA_W-4) or
                              hd_in_0(l+  DATA_W-5) or hd_in_0(l+  DATA_W-6) or
                              hd_in_0(l+  DATA_W-7) or hd_in_0(l+  DATA_W-8) or 
                              hd_in_0(l+  1) or hd_in_0(l+ 0));
    end loop;
  end process;

  detect_1_p: process(hd_in_1)
  begin
    for m in 0 to 2*DATA_W-1 loop
      hd_ones_in(m) <= not ( hd_in_1(m+2*DATA_W-1) or hd_in_1(m+2*DATA_W-2) or
                              hd_in_1(m+2*DATA_W-3) or hd_in_1(m+2*DATA_W-4) or
                              hd_in_1(m+2*DATA_W-5) or hd_in_1(m+2*DATA_W-6) or 
                              hd_in_1(m+2*DATA_W-7) or hd_in_1(m+2*DATA_W-8) or
                              hd_in_1(m+  DATA_W+1) or hd_in_1(m+  DATA_W  ) or
                              hd_in_1(m+  DATA_W-1) or hd_in_1(m+  DATA_W-2) or
                              hd_in_1(m+  DATA_W-3) or hd_in_1(m+  DATA_W-4) or
                              hd_in_1(m+  DATA_W-5) or hd_in_1(m+  DATA_W-6) or
                              hd_in_1(m+  DATA_W-7) or hd_in_1(m+  DATA_W-8) or 
                              hd_in_1(m+  1) or hd_in_1(m+ 0));
    end loop;
  end process;

  dly_0s_p: process(clk, rst)
  begin
    if (rst = '1') then
      hd_zeros_dly <= (others => '0');
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        hd_zeros_dly <= hd_zeros_in;
      end if;
    end if;
  end process;

  hd_is_trs <= hd_zeros_in and hd_zeros_dly and hd_ones_in;
  hd_trs_detected <= '0' when hd_is_trs = zeros else '1';

  hd_bin_offset(0) <= hd_is_trs(1)  or hd_is_trs(3)  or hd_is_trs(5)  or
                      hd_is_trs(7)  or hd_is_trs(9)  or hd_is_trs(DATA_W+1) or
                      hd_is_trs(2*DATA_W-7) or hd_is_trs(2*DATA_W-5) or
                      hd_is_trs(2*DATA_W-3) or hd_is_trs(2*DATA_W-1);
  hd_bin_offset(1) <= hd_is_trs(2)  or hd_is_trs(3)  or hd_is_trs(6)  or
                      hd_is_trs(7)  or hd_is_trs(DATA_W) or hd_is_trs(DATA_W+1) or
                      hd_is_trs(2*DATA_W-6) or hd_is_trs(2*DATA_W-5) or
                      hd_is_trs(2*DATA_W-2) or hd_is_trs(2*DATA_W-1);
  hd_bin_offset(2) <= hd_is_trs(4)  or hd_is_trs(5)  or hd_is_trs(6)  or
                      hd_is_trs(7)  or hd_is_trs(2*DATA_W-8) or hd_is_trs(2*DATA_W-7) or
                      hd_is_trs(2*DATA_W-6) or hd_is_trs(2*DATA_W-5);
  hd_bin_offset(3) <= hd_is_trs(8)  or hd_is_trs(9)  or hd_is_trs(DATA_W) or
                      hd_is_trs(DATA_W+1) or hd_is_trs(2*DATA_W-8) or
                      hd_is_trs(2*DATA_W-7) or hd_is_trs(2*DATA_W-6) or
                      hd_is_trs(2*DATA_W-5);
  hd_bin_offset(4) <= hd_is_trs(2*DATA_W-4) or hd_is_trs(2*DATA_W-3) or
                      hd_is_trs(2*DATA_W-2) or hd_is_trs(2*DATA_W-1);


  sd_in_vector <= data_i(2*DATA_W-2 downto DATA_W) & data_r(2*DATA_W-1 downto DATA_W) & 
                  data_dly(2*DATA_W-1 downto DATA_W) & data_dly2(2*DATA_W-1 downto DATA_W);

    -- first level of gates

  trs_preamble_bit_location_p: process(sd_in_vector)
  begin
    for i in 0 to 15 loop
      sd_trs_match1_l1(i) <= sd_in_vector(i + 3) and sd_in_vector(i + 2) and
                              sd_in_vector(i + 1) and sd_in_vector(i);
      sd_trs_match2_l1(i) <= not (sd_in_vector(i+13) or sd_in_vector(i+12) or 
                                  sd_in_vector(i+11) or sd_in_vector(i+10));
      sd_trs_match3_l1(i) <= not (sd_in_vector(i+23) or sd_in_vector(i+22) or 
                                  sd_in_vector(i+21) or sd_in_vector(i+20));
    end loop;
  end process;

  trs_preamble_offset_1_p: process(sd_trs_match1_l1)
  begin
    for i in 0 to 15 loop
      sd_trs_match1(i) <= sd_trs_match1_l1(i) and sd_trs_match1_l1(i+4) and 
                            sd_trs_match1_l1(i+6);
    end loop;
  end process;

  trs_preamble_offset_2_p: process(sd_trs_match2_l1)
  begin
    for i in 0 to 15 loop
      sd_trs_match2(i) <= sd_trs_match2_l1(i) and sd_trs_match2_l1(i+4) and 
                            sd_trs_match2_l1(i+6);
    end loop;
  end process;

  trs_preamble_offset_3_p: process(sd_trs_match3_l1)
  begin
    for i in 0 to 15 loop
      sd_trs_match3(i) <= sd_trs_match3_l1(i) and sd_trs_match3_l1(i+4) and 
                            sd_trs_match3_l1(i+6);
    end loop;
  end process;

  sd_trs_match_all <= sd_trs_match1 and sd_trs_match2 and sd_trs_match3;

  sd_trs_detected <= '0' when (sd_trs_match_all = (sd_trs_match_all'range => '0')) 
                      else '1';

  trs_errors_p: process(sd_trs_match_all)
  begin
    case sd_trs_match_all is
      when "0000000000" => sd_trs_err  <= '0';
      when "0000000001" => sd_trs_err  <= '0';
      when "0000000010" => sd_trs_err  <= '0';
      when "0000000100" => sd_trs_err  <= '0';
      when "0000001000" => sd_trs_err  <= '0';
      when "0000010000" => sd_trs_err  <= '0';
      when "0000100000" => sd_trs_err  <= '0';
      when "0001000000" => sd_trs_err  <= '0';
      when "0010000000" => sd_trs_err  <= '0';
      when "0100000000" => sd_trs_err  <= '0';
      when "1000000000" => sd_trs_err  <= '0';
      when others       => sd_trs_err  <= '1';
    end case;   
  end process;

  sd_offset_bin(0) <= sd_trs_match_all(1) or sd_trs_match_all(3) or 
                      sd_trs_match_all(5) or sd_trs_match_all(7) or 
                      sd_trs_match_all(9);
  sd_offset_bin(1) <= sd_trs_match_all(2) or sd_trs_match_all(3) or 
                      sd_trs_match_all(6) or sd_trs_match_all(7);
  sd_offset_bin(2) <= sd_trs_match_all(4) or sd_trs_match_all(5) or 
                      sd_trs_match_all(6) or sd_trs_match_all(7);
  sd_offset_bin(3) <= sd_trs_match_all(8) or sd_trs_match_all(9);

  trs_detected <= sd_trs_detected when hd_notsd = '1' else hd_trs_detected;
  offset_val <= ('0' & sd_offset_bin) when hd_notsd = '1' else hd_bin_offset;

  barrel_shifter_offset_p: process(clk, rst)
  begin
    if (rst = '1') then
      offset_reg <= (others => '0');
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        if (trs_detected = '1' and frame_en = '1') then
          offset_reg <= offset_val;
        end if;
      end if;
    end if;
  end process;

  new_offset <= '1' when offset_val /= offset_reg else '0';

  new_start_pos_p: process(clk, rst)
  begin
    if (rst = '1') then
      nsp <= '1';
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        if (trs_detected = '1') then
          nsp <= not frame_en and new_offset;
        end if;
      end if;
    end if;
  end process;

  barrel_shifter_in_p: process(clk, rst)
  begin
    if (rst = '1') then
      barrel_in <= (others => '0');
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        if (hd_notsd = '1') then
          barrel_in <=  data_dly(2*DATA_W-2 downto 0) & '0' & 
                        data_dly(2*DATA_W-2 downto DATA_W) & data_dly2(2*DATA_W-1 downto DATA_W);
        else
          barrel_in <= data_dly(2*DATA_W-2 downto 0) & data_dly2;
        end if;
      end if;
    end if;
  end process;

  bs_in <= ("000000000000" & barrel_in);
  bs_sel_1 <= offset_reg(4);
  bs_sel_2 <= offset_reg(3 downto 2);
  bs_sel_3 <= offset_reg(1 downto 0);

  barrel_shifter_sel_p: process(bs_in, bs_sel_1)
  begin
    for i in bs_1_out'range loop
      if (bs_sel_1 = '1') then
        bs_1_out(i) <= bs_in(i + 2*DATA_W-4);
      else
        bs_1_out(i) <= bs_in(i);
      end if;
    end loop;
  end process;

  barrel_shifter_out1_p: process(bs_1_out, bs_sel_2)
  begin
    for j in bs_2_out'range loop
      case bs_sel_2 is
        when "00"   => bs_2_out(j) <= bs_1_out(j);
        when "01"   => bs_2_out(j) <= bs_1_out(j + 4);
        when "10"   => bs_2_out(j) <= bs_1_out(j + 8);
        when others => bs_2_out(j) <= bs_1_out(j+ 2*DATA_W-8);
      end case;
    end loop;
  end process;

  barrel_shifter_out2_p: process(bs_2_out, bs_sel_3)
  begin
    for k in barrel_out'range loop
      case bs_sel_3 is
        when "00"   => barrel_out(k) <= bs_2_out(k);
        when "01"   => barrel_out(k) <= bs_2_out(k + 1);
        when "10"   => barrel_out(k) <= bs_2_out(k + 2);
        when others => barrel_out(k) <= bs_2_out(k + 3);
      end case;
    end loop;
  end process;

  out_reg_p: process(clk, rst)
  begin
    if (rst = '1') then
      data_c <= (others => '0');
      data_y <= (others => '0');
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        data_c <= barrel_out(9 downto 0);
        if (hd_notsd = '1') then
          data_y <= barrel_out(9 downto 0);
        else
          data_y <= barrel_out(2*DATA_W-1 downto DATA_W);
        end if;
      end if;
    end if;
  end process;

  data_c_o <= data_c;
  data_y_o <= data_y;

  trs_out_p: process(clk, rst)
  begin
    if (rst = '1') then
      trs_out <= (others => '0');
      trs <= '0';
      xyz_int <= '0';
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        trs_out <= (trs_detected & trs_out(3 downto 1));
        trs <= trs_out(3) or trs_out(2) or trs_out(1) or trs_out(0);
        xyz_int <= trs_out(0);
      end if;
    end if;
  end process;

  xyz <= xyz_int;
  eav <= xyz_int and data_y(6);
  sav <= xyz_int and not data_y(6);

  hd_trs_err <= xyz_int and ((data_y(5) xor data_y(6) xor data_y(7)) or
                             (data_y(4) xor data_y(8) xor data_y(6)) or
                             (data_y(3) xor data_y(8) xor data_y(7)) or
                             (data_y(2) xor data_y(8) xor data_y(7) xor data_y(6)) or
                        not   data_y(9) or data_y(1) or data_y(0));

  trs_err <= sd_trs_err when hd_notsd = '1' else hd_trs_err;

end rtl;