library ieee;
  use ieee.std_logic_1164.all;

entity scram_smpte is
  generic(
    DATA_HD_W  : positive := 10;
    POLY_ORDER : positive := 9
  );
  port(
    clk       : in  std_logic; -- 74.25 MHz
    rst       : in  std_logic; -- async
    scram_en  : in  std_logic;
    data_i    : in  std_logic_vector(DATA_HD_W-1 downto 0);
    p_scram   : in  std_logic_vector(POLY_ORDER-1 downto 0);  -- previously scrambled data input
    data_o    : out std_logic_vector(DATA_HD_W-1 downto 0);
    i_scram   : out std_logic_vector(POLY_ORDER-1 downto 0)   -- intermediate scrambled data output
  );
end scram_smpte;

architecture rtl of scram_smpte is

  signal data_in   : std_logic_vector(POLY_ORDER+4 downto 0);
  signal data_temp : std_logic_vector(DATA_HD_W-1 downto 0);
  signal data_reg  : std_logic_vector(DATA_HD_W-1 downto 0) := (others => '0');

begin

  data_in <= (data_temp(4 downto 0) & p_scram(POLY_ORDER - 1 downto 0));

  scram_poly_9_4_p:
  process (all)
  begin
    for i in 0 to POLY_ORDER loop
      data_temp(i) <= (data_i(i) xor data_in(i)) xor data_in(i + 4);
    end loop;
  end process;

  scram_mux_reg_p:
  process (clk, rst)
  begin
    if (rst = '1') then
      data_reg <= (others => '0');
    elsif (rising_edge(clk)) then
      data_reg <= data_temp when scram_en = '1' else
        data_i;
    end if;
  end process;

  data_o <= data_reg;
  i_scram <= data_temp(DATA_HD_W-1 downto 1);

end rtl;