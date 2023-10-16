library ieee;
  use ieee.std_logic_1164.all;

entity nrz_2_nrzi is
  generic(
    DATA_HD_W : positive := 10
  );
  port (
    clk       : in  std_logic;                      -- 74.25 MHz
    rst       : in  std_logic;                      -- async
    nrzi_en   : in  std_logic;
    data_i    : in  std_logic_vector(DATA_HD_W-1 downto 0);
    d_p_nrzi  : in  std_logic;                      -- MSB of previously converted NRZI word
    data_o    : out std_logic_vector(DATA_HD_W-1 downto 0);
    d_i_nrzi  : out std_logic                       -- intermediate nrzi data output
  );
end nrz_2_nrzi;

architecture rtl of nrz_2_nrzi is

  signal data_temp  : std_logic_vector(DATA_HD_W-1 downto 0);
  signal data_nrzi   : std_logic_vector(DATA_HD_W-1 downto 0);
  signal nrzi_reg   : std_logic_vector(DATA_HD_W-1 downto 0) := (others => '0');

begin

  data_nrzi <= data_temp when (nrzi_en = '1') else data_i;

  enc_nrz_nrzi_p:
  process(data_i, d_p_nrzi, data_nrzi)
  begin
      data_temp(0) <= d_p_nrzi xor data_i(0);
      for j in 1 to DATA_HD_W-1 loop
          data_temp(j) <= data_nrzi(j-1) xor data_i(j);
      end loop;
  end process;

  out_reg_p:
  process(clk, rst)
  begin
      if (rst = '1') then
          nrzi_reg <= (others => '0');
      elsif (rising_edge(clk)) then
              nrzi_reg <= data_nrzi;
      end if;
  end process;

  data_o <= nrzi_reg;
  d_i_nrzi <= data_temp(DATA_HD_W-1);

end rtl;