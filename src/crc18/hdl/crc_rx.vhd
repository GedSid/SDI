library ieee;
  use ieee.std_logic_1164.all;


entity crc_rx is
  generic(
    DATA_W      : positive := 10;
    POLY_ORDER  : positive := 18
  );
  port (
    clk:        in  std_logic;
    rst:        in  std_logic;
    clk_en:     in  std_logic;
    data_c_i:   in  std_logic_vector(DATA_W-1 downto 0);
    data_y_i:   in  std_logic_vector(DATA_W-1 downto 0);
    trs:        in  std_logic;
    c_crc_err:  out std_logic;
    y_crc_err:  out std_logic;
    c_line_num: out std_logic_vector(10 downto 0);
    y_line_num: out std_logic_vector(10 downto 0)
  );
end crc_rx;

architecture rtl of crc_rx is

signal c_crc_err_reg  : std_logic := '0';
signal y_crc_err_reg  : std_logic := '0';
signal c_line_num_reg : std_logic_vector(10 downto 0) := (others => '0');
signal y_line_num_reg : std_logic_vector(10 downto 0) := (others => '0');
signal c_rx_crc       : std_logic_vector(POLY_ORDER-1 downto 0) := (others => '0');
signal y_rx_crc       : std_logic_vector(POLY_ORDER-1 downto 0) := (others => '0');
signal crc_c_in       : std_logic_vector(POLY_ORDER-1 downto 0);
signal crc_y_in       : std_logic_vector(POLY_ORDER-1 downto 0);
signal trslncrc       : std_logic_vector(7 downto 0) := (others => '0');
signal crc_clr        : std_logic := '0';
signal crc_en         : std_logic := '0';
signal c_line_num_int : std_logic_vector(6 downto 0) := (others => '0');
signal y_line_num_int : std_logic_vector(6 downto 0) := (others => '0');

begin

  crc_c_u: entity work.crc18
  generic map(
    DATA_W      => DATA_W,
    POLY_ORDER  => POLY_ORDER
  )
  port map (
    clk     => clk,
    rst     => rst,
    clk_en  => clk_en,
    crc_en  => crc_en,
    crc_clr => crc_clr,
    data_i  => data_c_i,
    crc_o   => crc_c_in
  );

  crc_y_u: entity work.crc18
  generic map(
    DATA_W      => DATA_W,
    POLY_ORDER  => POLY_ORDER
  )
  port map (
    clk     => clk,
    rst     => rst,
    clk_en  => clk_en,
    crc_en  => crc_en,
    crc_clr => crc_clr,
    data_i  => data_y_i,
    crc_o   => crc_y_in
  );

  crc_ln_location_p: process(clk, rst)
  begin
    if (rst = '1') then
      trslncrc <= (others => '0');
    elsif (rising_edge(clk)) then
      if (clk_en = '1') then
        if trs = '1' and trslncrc(2 downto 0) = "000" then
          trslncrc(0) <= '1';
        else
          trslncrc(0) <= '0';
        trslncrc(7 downto 1) <= (trslncrc(6 downto 3) & (trslncrc(2) and data_y_i(6)) & trslncrc(1 downto 0));
        end if;
      end if;
    end if;
  end process;

  crc_clr_en_p: process(clk, rst)
  begin
    if (rst = '1') then
      crc_clr <= '0';
      crc_en <= '0';
    elsif (rising_edge(clk)) then
      if (clk_en = '1') then
        if trslncrc(2) = '1' and data_y_i(6) = '0' then
          crc_clr <= '1';
        else
          crc_clr <= '0';
        end if;
        if trslncrc(2) = '1' and data_y_i(6) = '0' then
          crc_en <= '1';
        elsif trslncrc(4) = '1' then
          crc_en <= '0';
        end if;
      end if;
    end if;
  end process;

  crc_reg_comp: process(clk, rst)
  begin
    if (rst = '1') then
      c_rx_crc <= (others => '0');
      y_rx_crc <= (others => '0');
      c_crc_err_reg <= '0';
      y_crc_err_reg <= '0';
    elsif (rising_edge(clk)) then
      if (clk_en = '1') then
        if trslncrc(5) = '1' then
          c_rx_crc(8 downto 0) <= data_c_i(8 downto 0);
          y_rx_crc(8 downto 0) <= data_y_i(8 downto 0);
        elsif trslncrc(6) = '1' then
          c_rx_crc(17 downto 9) <= data_c_i(8 downto 0);
          y_rx_crc(17 downto 9) <= data_y_i(8 downto 0);
        end if;
        if trslncrc(7) = '1' then
          if c_rx_crc = crc_c_in then
              c_crc_err_reg <= '0';
          else
              c_crc_err_reg <= '1';
          end if;
          if y_rx_crc = crc_y_in then
              y_crc_err_reg <= '0';
          else
              y_crc_err_reg <= '1';
          end if;
      end if;
      end if;
    end if;
  end process;

  c_crc_err <= c_crc_err_reg;
  y_crc_err <= y_crc_err_reg;

  ln_reg_p: process(clk, rst)
  begin
    if (rst = '1') then
      c_line_num_int <= (others => '0');
      y_line_num_int <= (others => '0');
      c_line_num_reg <= (others => '0');
      y_line_num_reg <= (others => '0');
    elsif (rising_edge(clk)) then
      if (clk_en = '1') then
        if trslncrc(3) = '1' then
          c_line_num_int <= data_c_i(8 downto 2);
          y_line_num_int <= data_y_i(8 downto 2);
        elsif trslncrc(4) = '1' then
          c_line_num_reg <= (data_c_i(5 downto 2) & c_line_num_int);
          y_line_num_reg <= (data_y_i(5 downto 2) & y_line_num_int);
        end if;
      end if;
    end if;
  end process;

  c_line_num <= c_line_num_reg;
  y_line_num <= y_line_num_reg;

end rtl;