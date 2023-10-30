library ieee;
  use ieee.std_logic_1164.all;

entity crc18_smpte is
  generic(
    DATA_W      : positive := 10;
    POLY_ORDER  : positive := 18
  );
  port(
    clk     : in  std_logic;
    rst     : in  std_logic;
    crc_clr : in  std_logic;
    crc_en  : in  std_logic;
    data_i  : in  std_logic_vector(DATA_W-1 downto 0);
    crc_o   : out std_logic_vector(POLY_ORDER-1 downto 0)
  );
end crc18_smpte;

architecture rtl of crc18_smpte is

  signal temp     : std_logic_vector(DATA_W-1 downto 0);
  signal crc_new  : std_logic_vector(POLY_ORDER-1 downto 0);
  signal crc_old  : std_logic_vector(POLY_ORDER-1 downto 0);
  signal crc_reg  : std_logic_vector(POLY_ORDER-1 downto 0) := (others => '0');

begin

  crc_old <= (others => '0') when crc_clr = '1' else crc_reg;

  in_xor_p: process(data_i, crc_old)
  begin
    for i in 0 to DATA_W-1 loop
        temp(i) <= data_i(i) xor crc_old(i);
    end loop;
  end process;

  crc_p: process (crc_old, temp)
  begin
    for i in 0 to 2 loop
      crc_new(i) <= crc_old(i + 10);
    end loop;
    crc_new(3) <= temp(0) xor crc_old(13);
    for i in 4 to 7 loop
      crc_new(i) <= (temp(i - 3) xor temp(i - 4)) xor crc_old(i + 10);
    end loop;
    for i in 8 to 12 loop
      crc_new(i) <= (temp(i - 3) xor temp(i - 4)) xor temp(i - 8);
    end loop;
    crc_new(13) <= temp(9) xor temp(5);
    for i in 14 to POLY_ORDER loop
      crc_new(i) <= temp(i - 8);
    end loop;
  end process;

  out_reg_p: process(clk, rst)
  begin
    if (rst = '1') then
      crc_reg <= (others => '0');
    elsif (rising_edge(clk)) then
      if (crc_en = '1') then
        crc_reg <= crc_new;
      end if;
    end if;
  end process;

  crc_o <= crc_reg;

end rtl;