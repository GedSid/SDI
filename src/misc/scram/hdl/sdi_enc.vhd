library ieee;
  use ieee.std_logic_1164.all;

entity sdi_enc is
  generic(
    DATA_W : positive := 10
  );
  port (
    clk       : in  std_logic;      -- 74.25 MHz
    rst       : in  std_logic;      -- async
    clk_en    : in  std_logic;
    hd_notsd  : in  std_logic;
    nrzi_en   : in  std_logic;
    scram_en  : in  std_logic;
    data_c_i  : in  std_logic_vector(DATA_W-1 downto 0);
    data_y_i  : in  std_logic_vector(DATA_W-1 downto 0);
    data_o    : out std_logic_vector(2*DATA_W-1 downto 0)
  );
end sdi_enc;

architecture rtl of sdi_enc is

  signal c_in_reg       : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal y_in_reg       : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal c_d_i_scram    : std_logic_vector(8 downto 0); -- C channel intermediate scrambled data
  signal y_d_i_scram    : std_logic_vector(8 downto 0); -- Y channel intermediate scrambled data
  signal c_d_i_nrzi     : std_logic;  -- C channel intermediate nrzi data
  signal c_out          : std_logic_vector(DATA_W-1 downto 0);  -- output of C scrambler
  signal y_out          : std_logic_vector(DATA_W-1 downto 0);  -- output of Y scrambler
  signal y_d_p_scram_mux  : std_logic_vector(8 downto 0); -- p_scram input MUX for Y encoder
  signal y_d_p_nrzi_mux   : std_logic;  -- p_nrzi input MUX for Y encoder
  signal c_scram_2_nrz  : std_logic_vector(DATA_W-1 downto 0);
  signal clk_en_hd      : std_logic;

begin

  clk_en_hd <= not hd_notsd and clk_en;

  input_reg_p: process(clk, rst)
  begin
    if (rst = '1') then
      y_in_reg <= (others => '0');
      c_in_reg <= (others => '0');
    elsif (rising_edge(clk)) then
      if (clk_en = '1') then
        y_in_reg <= data_y_i;
        if (hd_notsd = '0') then
          c_in_reg <= data_c_i;
        end if;
      end if;
    end if;
  end process;

  c_scram_u: entity work.scram_smpte
  generic map(
    DATA_W  => DATA_W,
    POLY_ORDER => 9
  )
  port map (
    clk         => clk,
    rst         => rst,
    clk_en      => clk_en_hd,
    scram_en    => scram_en and (not hd_notsd),
    data_i      => c_in_reg,
    d_p_scram   => y_d_i_scram,
    data_o      => c_scram_2_nrz,
    d_i_scram   => c_d_i_scram
  );

  c_nrzi_u: entity work.nrz_2_nrzi
  generic map(
    DATA_W  => DATA_W
  )
  port map (
    clk         => clk,
    rst         => rst,
    clk_en      => clk_en_hd,
    nrzi_en     => nrzi_en and (not hd_notsd),
    data_i      => c_scram_2_nrz,
    d_p_nrzi    => y_out(DATA_W-1),
    data_o      => c_out,
    d_i_nrzi    => c_d_i_nrzi
  );

  y_scram_u: entity work.scram_smpte
  generic map(
    DATA_W  => DATA_W,
    POLY_ORDER => 9
  )
  port map (
    clk         => clk,
    rst         => rst,
    clk_en      => clk_en,
    scram_en    => scram_en,
    data_i      => y_in_reg,
    d_p_scram   => y_d_p_scram_mux,
    data_o      => y_d_i_scram,
    d_i_scram   => open
  );

  y_nrzi: entity work.nrz_2_nrzi
  generic map(
    DATA_W  => DATA_W
  )
  port map (
    clk         => clk,
    rst         => rst,
    clk_en      => clk_en,
    nrzi_en     => nrzi_en,
    data_i      => y_d_i_scram,
    d_p_nrzi    => y_d_p_nrzi_mux,
    data_o      => y_out,
    d_i_nrzi    => open
  );

    y_d_p_scram_mux <= y_d_i_scram when (hd_notsd = '1') else c_d_i_scram;
    y_d_p_nrzi_mux <= y_out(9) when (hd_notsd = '1') else c_d_i_nrzi;

   data_o <= (y_out & c_out);

end rtl;