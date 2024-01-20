library ieee;
  use ieee.std_logic_1164.all;

entity sdi_deco is
  generic(
    DATA_W : positive := 10
  );
  port (
    clk       : in  std_logic;      -- 74.25 MHz
    rst       : in  std_logic;      -- async
    clk_en    : in  std_logic;
    hd_notsd  : in  std_logic;
    data_i    : in  std_logic_vector(2*DATA_W-1 downto 0);
    data_o    : out std_logic_vector(2*DATA_W-1 downto 0)
  );
end sdi_deco;

architecture rtl of sdi_deco is

  signal prev_d_msb : std_logic := '0';
  signal prev_nrz   : std_logic_vector(DATA_W-2  downto 0) := (others => '0');
  signal out_reg    : std_logic_vector(2*DATA_W-1 downto 0) := (others => '0');
  signal desc_aux   : std_logic_vector(3*DATA_W-2 downto 0);
  signal nrz        : std_logic_vector(2*DATA_W-1 downto 0);
  signal nrz_in     : std_logic_vector(2*DATA_W-1 downto 0);

begin

  prev_d_msb_reg_p: process(clk, rst)
  begin
    if (rst = '1') then
      prev_d_msb <= '0';
    elsif (rising_edge(clk)) then
      if (clk_en = '1') then
        prev_d_msb <= data_i(2*DATA_W-1);
      end if;
    end if;
  end process;

  nrz_in(2*DATA_W-1 downto DATA_W+1)  <= data_i(2*DATA_W-2 downto DATA_W);
  nrz_in(DATA_W)                      <= prev_d_msb when hd_notsd = '1' else data_i(DATA_W-1);
  nrz_in(DATA_W-1 downto 1)           <= data_i(DATA_W-2 downto 0);
  nrz_in(0)                           <= prev_d_msb;

  nrz <= data_i xor nrz_in;

  prev_nrz_reg_p: process(clk, rst)
  begin
    if (rst = '1') then
      prev_nrz <= (others => '0');
    elsif (rising_edge(clk)) then
      if (clk_en = '1') then
        prev_nrz <= nrz(2*DATA_W-1 downto DATA_W+1);
      end if;
    end if;
  end process;

  desc_aux(3*DATA_W-2 downto 2*DATA_W-1) <= nrz(2*DATA_W-1 downto DATA_W);
  desc_aux(2*DATA_W-2 downto DATA_W) <= prev_nrz  when hd_notsd = '1' else nrz(DATA_W-1 downto 1);
  desc_aux(DATA_W-1)            <= nrz(0);
  desc_aux(DATA_W-2 downto 0)   <= prev_nrz;

  desc_z9_z4_1_p: process(clk, rst)
  begin
    if (rst = '1') then
      out_reg <= (others => '0');
    elsif (rising_edge(clk)) then
      if (clk_en = '1') then
        for i in 0 to 2*DATA_W-1 loop
          out_reg(i) <= (desc_aux(i) xor desc_aux(i + 4)) xor desc_aux(i + DATA_W-1);
        end loop;
      end if;
    end if;
  end process;

  data_o <= out_reg;

end rtl;