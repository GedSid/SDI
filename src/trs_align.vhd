-------------------------------------------------------------------------------
--                              SDI TRS aligner                              --
-------------------------------------------------------------------------------
-- Purpose  : Alinea el paquete SDI usando la secuencía TRS para detectar el inicio.
--
-- Author   : Joaquin Ulloa
--
-- Comments : Se enmarca los datos que salen del decoder para que el comienzo y
--            fin de los paquetes se ajuste a los originalmente trasmitidos.
--            Se busca el TRS y cuando se lo detecta se usa para agregr el offset
--            necesario a los datos. Para SD se usan los 10 MSB
--            primer caso se deben usar los 10 MSB.
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity trs_align is
  generic(
    DATA_W : positive := 20
  );
  port (
    clk       : in  std_logic;    -- word rate clock (74.25 MHz)
    rst       : in  std_logic;    -- async reset
    sd_nohd_i : in  std_logic;
    dv_i      : in  std_logic;
    data_i    : in  std_logic_vector(DATA_W-1 downto 0);
    frame_en  : in  std_logic;
    data_c_o  : out std_logic_vector(DATA_W-1 downto 0);
    data_y_o  : out std_logic_vector(DATA_W-1 downto 0);
    trs_o     : out std_logic := '0';
    xyz_o     : out std_logic;
    eav_o     : out std_logic;
    sav_o     : out std_logic;
    trs_err   : out std_logic;
    nsp       : out std_logic := '1'
  );
end trs_align;

architecture rtl of trs_align is

  signal data_reg       : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal data_d1        : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal data_d2        : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal offset_reg     : std_logic_vector(4 downto 0) := (others => '0');
  signal data_offset    : std_logic_vector(38 downto 0) := (others => '0');
  signal trs_out        : std_logic_vector(3 downto 0) := (others => '0');
  signal bs_1_2         : std_logic_vector(34 downto 0);
  signal bs_2_3         : std_logic_vector(22 downto 0);
  signal data_hd_h      : std_logic_vector(2*(DATA_W-1) downto 0);
  signal data_hd_l      : std_logic_vector(2*(DATA_W-1) downto 0);
  signal all_1s         : std_logic_vector(DATA_W-1 downto 0);
  signal all_0s         : std_logic_vector(DATA_W-1 downto 0);
  signal all_0s_d1      : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal trs_match      : std_logic_vector(DATA_W-1 downto 0);
  signal trs_detected_hd: std_logic;
  signal hd_trs_err     : std_logic;
  signal trs_offset_hd  : std_logic_vector(4 downto 0);
  signal bs_out         : std_logic_vector(DATA_W-1 downto 0);
  signal new_offset     : std_logic;
  signal bs_in          : std_logic_vector(50 downto 0);
  signal bs_sel1        : std_logic;
  signal bs_sel2        : std_logic_vector(1 downto 0);
  signal bs_sel3        : std_logic_vector(1 downto 0);
  signal c_int          : std_logic_vector(DATA_W-1 downto 0) := (others => '0');  
  signal y_int          : std_logic_vector(DATA_W-1 downto 0) := (others => '0');  
  signal xyz_int        : std_logic := '0';
  signal data_sd        : std_logic_vector(38 downto 0); 
  signal trs_sd_h       : std_logic_vector( 9 downto 0); -- 0x3ff
  signal trs_sd_m       : std_logic_vector( 9 downto 0);--  0x000
  signal trs_sd_l       : std_logic_vector( 9 downto 0); -- 0x000
  signal trs_match_sd   : std_logic_vector( 9 downto 0); 
  signal trs_1s_sd_h    : std_logic_vector(15 downto 0); 
  signal trs_0s_sd_m    : std_logic_vector(15 downto 0); 
  signal trs_0s_sd_l    : std_logic_vector(15 downto 0); 
  signal trs_detected_sd: std_logic;
  signal trs_offset_sd  : std_logic_vector(3 downto 0);
  signal trs_detected   : std_logic;
  signal trs_error_sd   : std_logic;
  signal trs_offset     : std_logic_vector(4 downto 0);

  attribute keep : string;
  attribute keep of trs_detected_sd : signal is "TRUE";
  attribute keep of trs_error_sd : signal is "TRUE";

begin

  sync_delay_p: process(clk, rst)
  begin
    if (rst = '1') then
      data_reg <= (others => '0');
      all_1s <= '0';
      all_0s <= '0';
    elsif (rising_edge(clk)) then
      if (dv_i = '1') then
        data_reg <= data_i;
        --
        data_d1   <= data_reg;
        data_d2   <= data_d1;
        all_0s_d1 <= all_0s;
        end if;
    end if;
  end process;

  data_hd_h <= (data_i(18 downto 0) & data_reg); -- REMPLAZAR ESTO Y LOS DELAY POR UN SOLO REG
  data_hd_l <= (data_d1(18 downto 0) & data_d2);

  hd_zeros_detector_p: process(data_hd_h)
  begin
    for i in 0 to DATA_W-1 loop
      all_0s(i) <= not (data_hd_h(i+19) or data_hd_h(i+18) or data_hd_h(i+17) or
                        data_hd_h(i+16) or data_hd_h(i+15) or data_hd_h(i+14) or
                        data_hd_h(i+13) or data_hd_h(i+12) or data_hd_h(i+11) or
                        data_hd_h(i+10) or data_hd_h(i+ 9) or data_hd_h(i+ 8) or
                        data_hd_h(i+ 7) or data_hd_h(i+ 6) or data_hd_h(i+ 5) or
                        data_hd_h(i+ 4) or data_hd_h(i+ 3) or data_hd_h(i+ 2) or
                        data_hd_h(i+ 1) or data_hd_h(i+ 0));
      end loop;
  end process;

  hd_ones_detector_p: process(data_hd_l)
  begin
    for m in 0 to DATA_W-1 loop
      all_1s(m) <=  data_hd_l(m+19) and data_hd_l(m+18) and data_hd_l(m+17) and
                    data_hd_l(m+16) and data_hd_l(m+15) and data_hd_l(m+14) and
                    data_hd_l(m+13) and data_hd_l(m+12) and data_hd_l(m+11) and
                    data_hd_l(m+10) and data_hd_l(m+ 9) and data_hd_l(m+ 8) and
                    data_hd_l(m+ 7) and data_hd_l(m+ 6) and data_hd_l(m+ 5) and
                    data_hd_l(m+ 4) and data_hd_l(m+ 3) and data_hd_l(m+ 2) and
                    data_hd_l(m+ 1) and data_hd_l(m+ 0);
    end loop;
  end process;

  trs_match    <= all_0s and all_0s_d1 and all_1s;
  trs_detected_hd <= '0' when trs_match = (others => '0') else '1';

  trs_offset_hd(0) <= trs_match(1)  or trs_match(3)  or trs_match(5)  or
                      trs_match(7)  or trs_match(9)  or trs_match(11) or
                      trs_match(13) or trs_match(15) or trs_match(17) or
                      trs_match(19);
  trs_offset_hd(1) <= trs_match(2)  or trs_match(3)  or trs_match(6)  or
                      trs_match(7)  or trs_match(10) or trs_match(11) or
                      trs_match(14) or trs_match(15) or trs_match(18) or
                      trs_match(19);
  trs_offset_hd(2) <= trs_match(4)  or trs_match(5)  or trs_match(6)  or
                      trs_match(7)  or trs_match(12) or trs_match(13) or
                      trs_match(14) or trs_match(15);
  trs_offset_hd(3) <= trs_match(8)  or trs_match(9)  or trs_match(10) or
                      trs_match(11) or trs_match(12) or trs_match(13) or
                      trs_match(14) or trs_match(15);
  trs_offset_hd(4) <= trs_match(16) or trs_match(17) or trs_match(18) or
                      trs_match(19);

  -----------------------------------------------------------------------------
  -- SD
  data_sd <= data_i(18 downto 10) & data_reg(19 downto 10) & 
             data_d1(19 downto 10) & data_d2(19 downto 10);

  sd_1s_0s_detector_p: process(data_sd)
  begin
    for m in 0 to 15 loop
      trs_1s_sd_h(m) <= data_sd(m+3) and data_sd(m+2) and data_sd(m+1) and data_sd(m);
      trs_0s_sd_m(m) <= not(data_sd(m+13) or data_sd(m+12) or data_sd(m+11) or data_sd(m+10));
      trs_0s_sd_l(m) <= not(data_sd(m+23) or data_sd(m+22) or data_sd(m+21) or data_sd(m+20));
    end loop;
  end process;

  sd_ones_detector_p: process(trs_1s_sd_h) -- PROBAR COMBINAR TODOS ESTOS PROCESOS
  begin
    for m in 0 to 9 loop
      trs_sd_h(m) <= trs_1s_sd_h(m) and trs_1s_sd_h(m+4) and trs_1s_sd_h(m+6);
    end loop;
  end process;

  sd_zeros_detector_m_p: process(trs_0s_sd_m)
  begin
    for m in 0 to 9 loop
      trs_sd_m(m) <= trs_0s_sd_m(m) and trs_0s_sd_m(m+4) and trs_0s_sd_m(m+6);
    end loop;
  end process;

  sd_zeros_detector_h_p: process(trs_0s_sd_l)
  begin
    for m in 0 to 9 loop
      trs_sd_l(m) <= trs_0s_sd_l(m) and trs_0s_sd_l(m+4) and trs_0s_sd_l(m+6);
    end loop;
  end process;

  trs_match_sd    <= trs_sd_h and trs_sd_m and trs_sd_l;
  trs_detected_sd <= '0' when (trs_match_sd = (trs_match_sd'range => '0')) else '1';


  trs_error_p: process(trs_match_sd)
  begin
    case trs_match_sd is
      when "0000000000" => trs_error_sd  <= '0';
      when "0000000001" => trs_error_sd  <= '0';
      when "0000000010" => trs_error_sd  <= '0';
      when "0000000100" => trs_error_sd  <= '0';
      when "0000001000" => trs_error_sd  <= '0';
      when "0000010000" => trs_error_sd  <= '0';
      when "0000100000" => trs_error_sd  <= '0';
      when "0001000000" => trs_error_sd  <= '0';
      when "0010000000" => trs_error_sd  <= '0';
      when "0100000000" => trs_error_sd  <= '0';
      when "1000000000" => trs_error_sd  <= '0';
      when others       => trs_error_sd  <= '1';
    end case;   
  end process;

  trs_offset_sd(0) <= trs_match_sd(1) or trs_match_sd(3) or
                      trs_match_sd(5) or trs_match_sd(7) or
                      trs_match_sd(9);
  trs_offset_sd(1) <= trs_match_sd(2) or trs_match_sd(3) or 
                      trs_match_sd(6) or trs_match_sd(7);
  trs_offset_sd(2) <= trs_match_sd(4) or trs_match_sd(5) or 
                      trs_match_sd(6) or trs_match_sd(7);
  trs_offset_sd(3) <= trs_match_sd(8) or trs_match_sd(9);

  ---------------------------------------------------------------------------
  -- HD/SD muxes
  --
  trs_detected  <= trs_detected_sd when sd_nohd_i = '1' else trs_detected_hd;
  trs_offset    <= ('0' & trs_offset_sd) when sd_nohd_i = '1' else trs_offset_hd;
  new_offset    <= '1' when trs_offset /= offset_reg else '0';

  offset_p: process(clk, rst)
  begin
    if (rst = '1') then
      offset_reg  <= (others => '0');
      nsp         <= '1';
      data_offset <= (others => '0');
    elsif (rising_edge(clk)) then
      if (trs_detected = '1') then
        if (frame_en = '1') then
          offset_reg <= trs_offset;
        end if;
        nsp <= not frame_en and new_offset;
      end if;
      if (sd_nohd_i = '1') then
        data_offset <= data_d1(18 downto 0) & '0' & data_d1(18 downto 10) & data_d2(19 downto 10);
      else
        data_offset <= data_d1(18 downto 0) & data_d2;
      end if;
    end if;
  end process;

    bs_in <= ("000000000000" & data_offset);
    bs_sel1 <= offset_reg(4);
    bs_sel2 <= offset_reg(3 downto 2);
    bs_sel3 <= offset_reg(1 downto 0);

    bs_1_p: process(bs_in, bs_sel1)
    begin
        for i in bs_1_2'range loop -- 0 to 34
            if (bs_sel1 = '1') then
                bs_1_2(i) <= bs_in(i+16);
            else
                bs_1_2(i) <= bs_in(i);
            end if;
        end loop;
    end process;

    bs_2_p: process(bs_1_2, bs_sel2)
    begin
        for j in bs_2_3'range loop -- 0 to 22
            case bs_sel2 is
                when "00"   => bs_2_3(j) <= bs_1_2(j);
                when "01"   => bs_2_3(j) <= bs_1_2(j+4);
                when "10"   => bs_2_3(j) <= bs_1_2(j+8);
                when others => bs_2_3(j) <= bs_1_2(j+12);
            end case;
        end loop;
    end process;

    bs_3_p: process(bs_2_3, bs_sel3)
    begin
        for k in bs_out'range loop -- 0 to 19
            case bs_sel3 is
                when "00"   => bs_out(k) <= bs_2_3(k);
                when "01"   => bs_out(k) <= bs_2_3(k+1);
                when "10"   => bs_out(k) <= bs_2_3(k+2);
                when others => bs_out(k) <= bs_2_3(k+3);
            end case;
        end loop;
    end process;

  c_y_reg_p: process(clk, rst)
  begin
    if (rst = '1') then
      c_int <= (others => '0');
      y_int <= (others => '0');
    elsif (rising_edge(clk)) then
      c_int <= bs_out(9 downto 0);
      if (sd_nohd_i = '1') then
        y_int <= bs_out(9 downto 0);
      else
        y_int <= bs_out(19 downto 10);
      end if;
    end if;
  end process;

  data_c_o <= c_int;
  data_y_o <= y_int;

  out_p: process(clk, rst)
  begin
    if (rst = '1') then
      trs_out <= (others => '0');
      trs_o   <= '0';
      xyz_int <= '0';
    elsif rising_edge(clk) then
      trs_out <= (trs_detected & trs_out(3 downto 1));
      trs_o   <= trs_out(3) or trs_out(2) or trs_out(1) or trs_out(0);
      xyz_int <= trs_out(0);
    end if;
  end process;

  xyz_o <= xyz_int;
  eav_o <= xyz_int and y_int(6);
  sav_o <= xyz_int and not y_int(6);

  hd_trs_err <= xyz_int and (
                (y_int(5) xor y_int(6) xor y_int(7)) or
                (y_int(4) xor y_int(8) xor y_int(6)) or
                (y_int(3) xor y_int(8) xor y_int(7)) or
                (y_int(2) xor y_int(8) xor y_int(7) xor y_int(6)) or
                not y_int(9) or y_int(1) or y_int(0));

  trs_err <= trs_error_sd when sd_nohd_i = '1' else hd_trs_err;

end architecture;