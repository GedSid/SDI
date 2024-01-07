
library ieee;
  use ieee.std_logic_1164.all;

entity sdi_vpid_insert is
  generic(
    DATA_W      : positive := 10;
    VERT_POS_W  : positive := 11
  );
  port (
    clk         : in  std_logic;
    clk_en      : in  std_logic;
    din_rdy     : in  std_logic;
    rst         : in  std_logic;
    sdi_mode    : in  std_logic_vector(1 downto 0);
    lvl         : in  std_logic;
    en          : in  std_logic;
    overwrite   : in  std_logic;
    byte1       : in  std_logic_vector(7 downto 0);
    byte2       : in  std_logic_vector(7 downto 0);
    byte3       : in  std_logic_vector(7 downto 0);
    byte4a      : in  std_logic_vector(7 downto 0);
    byte4b      : in  std_logic_vector(7 downto 0);
    ln_a        : in  std_logic_vector(VERT_POS_W - 1 downto 0);
    ln_b        : in  std_logic_vector(VERT_POS_W - 1 downto 0);
    line_f1     : in  std_logic_vector(VERT_POS_W - 1 downto 0);
    line_f2     : in  std_logic_vector(VERT_POS_W - 1 downto 0);
    line_f2_en  : in  std_logic;
    a_y_i       : in  std_logic_vector(DATA_W - 1 downto 0);
    a_c_i       : in  std_logic_vector(DATA_W - 1 downto 0);
    b_y_i       : in  std_logic_vector(DATA_W - 1 downto 0);
    b_c_i       : in  std_logic_vector(DATA_W - 1 downto 0);
    ds1a_o      : out std_logic_vector(DATA_W - 1 downto 0);
    ds2a_o      : out std_logic_vector(DATA_W - 1 downto 0);
    ds1b_o      : out std_logic_vector(DATA_W - 1 downto 0);
    ds2b_o      : out std_logic_vector(DATA_W - 1 downto 0);
    eav_o       : out std_logic;
    sav_o       : out std_logic;
    out_mode    : out std_logic_vector(1 downto 0)
  );
end sdi_vpid_insert;

architecture rtl of sdi_vpid_insert is

  signal ds2_i        : std_logic_vector(DATA_W - 1 downto 0);
  signal ds1_c        : std_logic_vector(DATA_W - 1 downto 0);
  signal ds2_y        : std_logic_vector(DATA_W - 1 downto 0);
  signal ds2_ln       : std_logic_vector(VERT_POS_W - 1 downto 0);
  signal sdi_mode_r   : std_logic_vector(1 downto 0) := "00";
  signal mode_SD      : std_logic;
  signal mode_3G_A    : std_logic;
  signal mode_3G_B    : std_logic;
  signal lvl_r        : std_logic := '0';
  signal vpid_ins_ce  : std_logic;

begin

  in_reg_p: process(clk, rst)
  begin
    if (rst = '1') then
      sdi_mode_r <= (others => '0');
      lvl_r <= '0';
    elsif rising_edge(clk) then
      if (clk_en = '1') then
        sdi_mode_r <= sdi_mode;
        lvl_r <= lvl;
      end if;
    end if;
  end process;

  mode_SD   <= '1' when sdi_mode_r = "01" else '0';
  mode_3G_A <= '1' when sdi_mode_r = "10" and lvl_r = '0' else '0';
  mode_3G_B <= '1' when sdi_mode_r = "10" and lvl_r = '1' else '0';

  vpid_ins_ce <= clk_en and din_rdy;

  vpid1_u : entity work.vpid_smpte
  port map (
    clk       => clk,
    clk_en    => vpid_ins_ce,
    rst       => rst,
    hd_sd     => mode_SD,
    lvl_b     => lvl_r,
    en        => en,
    overwrite => overwrite,
    line      => ln_a,
    line_a    => line_f1,
    line_b    => line_f2,
    line_b_en => line_f2_en,
    byte1     => byte1,
    byte2     => byte2,
    byte3     => byte3,
    byte4     => byte4a,
    y_i       => a_y_i,
    c_i       => a_c_i,
    y_o       => ds1a_o,
    c_o       => ds1_c,
    eav_o     => eav_o,
    sav_o     => sav_o
  );

  ds2_i <= a_c_i when mode_3G_A = '1' else b_y_i;
  ds2_ln <= ln_b when mode_3G_B = '1' else ln_a;

  vpid2_u : entity work.vpid_smpte
  port map (
    clk       => clk,
    clk_en    => vpid_ins_ce,
    rst       => rst,
    hd_sd     => mode_SD,
    lvl_b     => lvl_r,
    en        => en,
    overwrite => overwrite,
    line      => ds2_ln,
    line_a    => line_f1,
    line_b    => line_f2,
    line_b_en => line_f2_en,
    byte1     => byte1,
    byte2     => byte2,
    byte3     => byte3,
    byte4     => byte4b,
    y_i       => ds2_i,
    c_i       => b_c_i,
    y_o       => ds2_y,
    c_o       => ds2b_o,
    eav_o     => open,
    sav_o     => open
  );

  ds2a_o <= ds2_y when mode_3G_A = '1' else ds1_c;
  ds1b_o <= ds2_y;

  out_mode <= "01" when mode_SD = '1' else
              "10" when mode_3G_B = '1' else
              "00";

end rtl;