library ieee;
  use ieee.std_logic_1164.all;

entity crc_insert is
  generic(
    DATA_W      : positive := 10;
    POLY_ORDER  : positive := 18
  );
  port(
    clk         : in  std_logic;
    rst         : in  std_logic;
    din_rdy     : in  std_logic;
    sav         : in  std_logic;
    eav_dly     : in  std_logic;
    data_c_i    : in  std_logic_vector(DATA_W-1 downto 0);
    data_y_i    : in  std_logic_vector(DATA_W-1 downto 0);
    crc_ins_en  : in  std_logic;
    crc_word0   : in  std_logic;      -- asserte during first CRC word in EAV
    crc_word1   : in  std_logic;      -- asserte during second CRC word in EAV
    data_c_o    : out std_logic_vector(DATA_W-1 downto 0);
    data_y_o    : out std_logic_vector(DATA_W-1 downto 0)
  );
end crc_insert;

architecture rtl of crc_insert is

  signal crc_en       : std_logic;
  signal crc_clr      : std_logic;
  signal crc_en_rdy   : std_logic;
  signal crc_c_in     : std_logic_vector(POLY_ORDER-1 downto 0);
  signal crc_y_in     : std_logic_vector(POLY_ORDER-1 downto 0);

begin

  crc_timing_ctrl_u: process(clk, rst)
  begin
    if (rst = '1') then
      crc_en <= '0';
      crc_clr <= '0';
    elsif (rising_edge(clk)) then
      if (din_rdy = '1') then
        crc_clr <= sav;
        if (sav = '1') then
          crc_en <= '1';
        elsif (eav_dly = '1') then
          crc_en <= '0';
        end if;
      end if;
    end if;
  end process;

  -- Instantiate the CRC generators
  crc_en_rdy <= din_rdy and crc_en;

  crc_y_u: entity work.crc18_smpte
  generic map(
    DATA_W      => DATA_W,
    POLY_ORDER  => POLY_ORDER
  )
  port map (
    clk     => clk,
    rst     => rst,
    crc_en  => crc_en_rdy,
    crc_clr => crc_clr,
    data_i  => data_y_i,
    crc_o   => crc_y_in
  );

  crc_c_u: entity work.crc18_smpte
  generic map(
    DATA_W      => DATA_W,
    POLY_ORDER  => POLY_ORDER
  )
  port map (
    clk     => clk,
    rst     => rst,
    crc_en  => crc_en_rdy,
    crc_clr => crc_clr,
    data_i  => data_c_i,
    crc_o   => crc_c_in
  );

  crc_insertion_p: process(all)
  begin
    if (crc_ins_en = '1') then
      if (crc_word0 = '1') then
        data_c_o <= (not crc_c_in(DATA_W-2) & crc_c_in(DATA_W-2 downto 0));
        data_y_o <= (not crc_y_in(DATA_W-2) & crc_y_in(DATA_W-2 downto 0));
      elsif (crc_word1 = '1') then
        data_c_o <= (not crc_c_in(POLY_ORDER-1) & crc_c_in(POLY_ORDER-1 downto DATA_W-1));
        data_y_o <= (not crc_y_in(POLY_ORDER-1) & crc_y_in(POLY_ORDER-1 downto DATA_W-1));
      end if;
    else
      data_c_o <= data_c_i;
      data_y_o <= data_y_i;
    end if;
  end process;

end rtl;