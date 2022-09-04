
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity trs_detector is
  generic (
    DATA_W  : integer := 20
  );
  port (
    clk       : in  std_logic;                     -- clock input
    rst       : in  std_logic;                     -- async reset input
    dv_i      : in  std_logic;
    data_i    : in  std_logic_vector(DATA_W-1 downto 0);
    data_o    : out std_logic_vector(DATA_W-1 downto 0);  -- delayed and clipped video output
    trs_o     : out std_logic;                     -- asserted during first word of TRS symbol
    eav_o     : out std_logic;                     -- asserted during first word of an EAV symbol
    sav_o     : out std_logic;                     -- asserted during first word of an SAV symbol
    f_flag_o  : out std_logic;                     -- field bit from last received TRS symbol
    v_flag_o  : out std_logic;                     -- vertical blanking interval bit from last TRS symbol
    h_flag_o  : out std_logic;                     -- horizontal blanking interval bit from last TRS symbol
    xyz_o     : out std_logic;                     -- asserted during TRS XYZ word
    xyz_err_o : out std_logic;                     -- XYZ error flag
    anc_o     : out std_logic;                     -- asserted during first word of ADF
    edh_o     : out std_logic                      -- asserted during first word of ADF if it is an EDH packet
  );
end trs_detector;

architecture rtl of trs_detector is

  signal data_reg   : std_logic_vector(DATA_W-1 downto 0);
  signal data_d1    : std_logic_vector(DATA_W-1 downto 0);
  signal data_d2    : std_logic_vector(DATA_W-1 downto 0);

  signal all_1s     : std_logic;
  signal all_0s     : std_logic;
  signal all_1s_d1  : std_logic;
  signal all_0s_d1  : std_logic;
  signal all_1s_d2  : std_logic;
  signal all_0s_d2  : std_logic;

  signal edh        : std_logic;
  signal trs        : std_logic;
  signal trs_reg    : std_logic;
  signal trs_d      : std_logic_vector(1 downto 0);
  signal anc        : std_logic;
  signal eav        : std_logic;
  signal sav        : std_logic;
  signal f_flag     : std_logic;
  signal v_flag     : std_logic;
  signal h_flag     : std_logic;
  signal f_flag_reg : std_logic;
  signal v_flag_reg : std_logic;
  signal h_flag_reg : std_logic;
  signal xyz        : std_logic;
  signal xyz_err    : std_logic;

begin

  -- Sincronización y retraso de señales para parsear los datos del protocolo
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
        all_1s_d1 <= all_1s;
        all_1s_d2 <= all_1s_d1;
        all_0s_d1 <= all_0s;
        all_0s_d2 <= all_0s_d1;
        end if;
    end if;
  end process;

  -- Parseo de información propia del protocolo
  all_1s <= data_reg(9) and data_reg(8) and data_reg(7) and data_reg(6) and
            data_reg(5) and data_reg(4) and data_reg(3) and data_reg(2);

  all_0s <= not(data_reg(9) or data_reg(8) or data_reg(7) or data_reg(6) or
                data_reg(5) or data_reg(4) or data_reg(3) or data_reg(2));

  edh     <= '1' when (data_i = x"1f4") else '0';
  -- Packet Sequences
  trs     <= all_1s_d2 and all_0s_d1 and all_0s; -- 3ff.000.000
  anc     <= all_0s_d2 and all_1s_d1 and all_1s; -- 000.3ff.3ff
  -- Protocol flags
  eav     <= trs and data_i(6);
  sav     <= trs and not data_i(6);
  f_flag  <= data_i(8) when (trs = '1') else f_flag_reg;
  v_flag  <= data_i(7) when (trs = '1') else v_flag_reg;
  h_flag  <= data_i(6) when (trs = '1') else h_flag_reg;

  xyz <= trs_d(1);

  xyz_err <= xyz and ((data_d2(5) xor data_d2(7) xor data_d2(6)) or
                      (data_d2(4) xor data_d2(8) xor data_d2(6)) or
                      (data_d2(3) xor data_d2(8) xor data_d2(7)) or
                      (data_d2(2) xor data_d2(8) xor data_d2(7) xor data_d2(6))
                      or not data_d2(9));

  -- Proceso para registrar las salidas
  reg_out_p: process(rst, clk)
  begin
    if (rst = '1') then
      trs_reg     <= '0';
      trs_d       <= (others => '0');
      data_o      <= (others => '0');
      eav_o       <= '0';
      sav_o       <= '0';
      anc_o       <= '0';
      edh_o       <= '0';
      xyz_o       <= '0';
      xyz_err_o   <= '0';
      f_flag_reg  <= '0';
      v_flag_reg  <= '0';
      h_flag_reg  <= '0';
    elsif (rising_edge(clk)) then
      trs_reg <= trs;
      trs_d <= (trs_d(0) & trs_reg);
      data_o      <= data_d2;
      eav_o       <= eav;
      sav_o       <= sav;
      anc_o       <= anc;
      edh_o       <= anc and edh;
      xyz_o       <= xyz;
      xyz_err_o   <= xyz_err;
      f_flag_reg  <= f_flag;
      v_flag_reg  <= v_flag;
      h_flag_reg  <= h_flag;
    end if; 
  end process;

  trs_o     <= trs_reg;
  f_flag_o  <= f_flag_reg;
  v_flag_o  <= v_flag_reg;
  h_flag_o  <= h_flag_reg;

end architecture;