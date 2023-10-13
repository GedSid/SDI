-------------------------------------------------------------------------------
--                              SDI RX Parser                              --
-------------------------------------------------------------------------------
-- Purpose  : Extraer información del TRS y line number.
--
-- Author   : Joaquin Ulloa
--
-- Comments : Receptor SDI 3G para nivel B, recibe dos entradas de 10 bits a
--            148.5 MHz y los entrega a 74.25 MHz. También extrae las señales
--            de taming y el line number y regenera el data valid.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity rx_parser is
  generic(
    DATA_W : positive := 10
  );
  port (
    clk           : in  std_logic;      -- 148.5 MHz or integer multiple
    rst           : in  std_logic;      -- async reset
    dv_i          : in  std_logic;
    -- Form trs_align
    data1_i       : in  std_logic_vector(DATA_W-1 downto 0);
    data2_i       : in  std_logic_vector(DATA_W-1 downto 0);
    trs_i         : in  std_logic;
  
    lvlb_noa_o    : out std_logic;
    data_c0_o     : out std_logic_vector(DATA_W-1 downto 0);
    data_y0_o     : out std_logic_vector(DATA_W-1 downto 0);
    data_c1_o     : out std_logic_vector(DATA_W-1 downto 0);
    data_y1_o     : out std_logic_vector(DATA_W-1 downto 0);
    trs_o         : out std_logic;
    eav_o         : out std_logic;
    sav_o         : out std_logic;
    xyz_o         : out std_logic;
    dv_o          : out std_logic;
    line_num_o    : out std_logic_vector(10 downto 0)
  );
end rx_parser;

architecture rtl of rx_parser is

  signal data_c0_reg    : std_logic_vector(DATA_W-1 downto 0);
  signal data_y0_reg    : std_logic_vector(DATA_W-1 downto 0);
  signal data_c1_reg    : std_logic_vector(DATA_W-1 downto 0);
  signal data_y1_reg    : std_logic_vector(DATA_W-1 downto 0);
  signal trs_reg        : std_logic_vector(4 downto 0);
  signal ln_ls          : std_logic_vector(6 downto 0);
  signal trs_rise       : std_logic;
  signal all_ones       : std_logic;
  signal all_zeros      : std_logic;
  signal zeros          : std_logic_vector(2 downto 0);
  signal ones           : std_logic_vector(4 downto 0);
  signal lvl_b          : std_logic;
  signal trs_rise_d     : std_logic;
  signal eav_reg        : std_logic_vector(1 downto 0);
  signal xyz            : std_logic;
  signal eav            : std_logic;

begin

  -----------------------------------------------------------------------------
  sync_p: process(rst, clk)
  begin
    if (rst = '1') then
        data_c0_reg <= (others => '0');
        data_y0_reg <= (others => '0');
        data_c1_reg <= (others => '0');
        data_y1_reg <= (others => '0');
        data_c0_o   <= (others => '0');
        data_c1_o   <= (others => '0');
    elsif (rising_edge(clk)) then
      if (dv_i = '0') then
        data_c0_reg <= data1_i;
        data_c1_reg <= data2_i;
        data_y0_reg <= data1_i;
        data_y1_reg <= data2_i;
        data_c0_o   <= data_c0_reg;
        data_c1_o   <= data_c1_reg;
      end if;
    end if;
  end process;

  data_y0_o <= data_y0_reg;
  data_y1_o <= data_y1_reg;

  -----------------------------------------------------------------------------
  edge_detector_p: process(rst, clk)
  begin
    if (rst = '1') then
      trs_rise    <= '0';
      trs_rise_d  <= '0';
    elsif (rising_edge(clk)) then
      if (trs_i = '1' and trs_reg(0) = '0') then
        trs_rise <= '1';
      else
        trs_rise <= '0';
      end if;
      trs_rise_d <= trs_rise;
    end if;
  end process;

dv_o <= trs_rise and not trs_rise_d;

  -----------------------------------------------------------------------------
  trs_sr: process(rst, clk)
  begin
    if (rst = '1') then
      trs_reg <= (others => '0');
    elsif (rising_edge(clk)) then
      if (dv_i = '1') then
          trs_reg <= (trs_reg(3 downto 0) & trs_i);
      end if;
    end if;
  end process;

  trs_o   <= trs_reg(2) or trs_reg(1) or trs_reg(0) or (trs_reg(3) and trs_reg(2));
  xyz     <= trs_reg(3) and not trs_reg(4);
  xyz_o   <= xyz;
  eav     <= xyz and data_y0_reg(6);
  eav_o   <= eav;
  sav_o   <= xyz and not data_y0_reg(6);

  -----------------------------------------------------------------------------
  line_num_parser_p: process(rst, clk)
  begin
    if (rst = '1') then
      eav_reg     <= (others => '0');
      ln_ls       <= (others => '0');
      line_num_o  <= (others => '0');
    elsif (rising_edge(clk)) then
      if (dv_i = '1') then
        eav_reg <= (eav_reg(0) & eav);
      end if;
      if (dv_i = '1' and eav_reg(0) = '1') then
        ln_ls   <= data_y0_reg(8 downto 2);
      end if;
      if (dv_i = '1' and eav_reg(1) = '1') then
        line_num_o <= (data_y0_reg(5 downto 2) & ln_ls);
      end if;
    end if;
  end process;

  -----------------------------------------------------------------------------
  all_ones  <= '1' when data1_i = "1111111111" else '0';
  all_zeros <= '1' when data1_i = "0000000000" else '0';

  level_parser_p: process(rst, clk)
  begin
    if (rst = '1') then
      ones        <= (others => '0');
      zeros       <= (others => '0');
      lvl_b       <= '0';
      lvlb_noa_o  <= '0';
    elsif (rising_edge(clk)) then
      ones  <= (ones(3 downto 0) & all_ones);
      zeros <= (zeros(1 downto 0) & all_zeros);
      if (dv_i = '1') then
        lvl_b  <= ones(4) and ones(3) and zeros(2) and zeros(1) and zeros(0) and all_zeros;
      end if;
      if (dv_i = '1' and trs_reg(2) = '1' and trs_reg(1) = '1') then
        lvlb_noa_o <= lvl_b;
      end if;
    end if;
  end process;

end architecture;
