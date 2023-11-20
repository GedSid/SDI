library ieee;
  use ieee.std_logic_1164.all;

entity sdi_bit_rep is
  generic(
    DATA_W      : positive := 10
  );
  port (
    clk       : in  std_logic;
    rst       : in  std_logic;
    clk_en    : in  std_logic;
    data_i    : in  std_logic_vector(DATA_W-1 downto 0);
    data_o    : out std_logic_vector(2*DATA_W-1 downto 0);
    align_err : out std_logic := '0' 
  );
end sdi_bit_rep;

architecture rtl of sdi_bit_rep is

  function repeat (n: natural; v: std_logic) return std_logic_vector is
      variable result: std_logic_vector(0 to n-1);
  begin
      for i in 0 to n-1 loop
          result(i) := v;
      end loop;
      return result;
  end;

  attribute fsm_encoding : string;
  
  subtype state is std_logic_vector(3 downto 0);

  signal d0       : std_logic_vector(DATA_W-1 downto 0);
  signal d1       : std_logic_vector(DATA_W-1 downto 0);
  signal d2       : std_logic_vector(DATA_W-1 downto 0);
  signal d3       : std_logic_vector(DATA_W-1 downto 0);
  signal d4       : std_logic_vector(DATA_W-1 downto 0);
  signal d5       : std_logic_vector(DATA_W-1 downto 0);
  signal d6       : std_logic_vector(DATA_W-1 downto 0);
  signal d7       : std_logic_vector(DATA_W-1 downto 0);
  signal d8       : std_logic_vector(DATA_W-1 downto 0);
  signal d9       : std_logic_vector(DATA_W-1 downto 0);
  signal d10      : std_logic_vector(DATA_W-1 downto 0);
  signal d11      : std_logic_vector(DATA_W-1 downto 0);

  signal current_state  : std_logic_vector(3 downto 0) := X"F";
  attribute fsm_encoding of current_state : signal is "USER";

  signal next_state   : std_logic_vector(3 downto 0);
  signal data_r       : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal data_dly     : std_logic_vector(DATA_W-1 downto 0) := (others => '0');
  signal b9_save      : std_logic := '0';
  signal clk_en_dly   : std_logic := '0';
  signal data_mux     : std_logic_vector(2*DATA_W-1 downto 0);

begin

  in_and_dly_reg_p: process(clk, rst)
  begin
    if (rst = '1') then
      data_r <= (others => '0');
      clk_en_dly <= '0';
    elsif (rising_edge(clk)) then
      clk_en_dly <= clk_en;
      if (clk_en = '1') then
          data_r <= data_i;
          data_dly <= data_r;
      end if;
      if (clk_en_dly = '1') then
        b9_save <= data_dly(2*DATA_W-1);
      end if;
    end if;
  end process;

  fsm_cs_p: process(current_state, clk_en_dly)
  begin
    case current_state is
      when X"F" =>
        if clk_en_dly = '1' then
          next_state <= X"0";
        else
          next_state <= X"F";
        end if;
      when X"0" =>
        next_state <= X"1";
      when X"1" =>
        next_state <= X"2";
      when X"2" =>
        next_state <= X"3";
      when X"3" =>
        next_state <= X"4";
      when X"4" =>
        if clk_en_dly = '1' then
            next_state <= X"5";
        else
            next_state <= X"B";
        end if;
      when X"5" =>
        next_state <= X"6";
      when X"B" =>
        next_state <= X"6";
      when X"6" =>
        next_state <= X"7";
      when X"7" =>
        next_state <= X"8";
      when X"8" =>
        next_state <= X"9";
      when X"9" =>
        next_state <= X"A";
      when X"A" =>
        if clk_en_dly = '1' then
            next_state <= X"0";
        else
            next_state <= X"F";
        end if;
      when others =>
        next_state <= X"F";
    end case;
  end process;

  d0  <= (repeat(9, data_dly(1))  & repeat(11, data_dly(0)));
  d1  <= (repeat(7, data_dly(3))  & repeat(11, data_dly(2)) & repeat(2, data_dly(1)));
  d2  <= (repeat(5, data_dly(5))  & repeat(11, data_dly(4)) & repeat(4, data_dly(3)));
  d3  <= (repeat(3, data_dly(7))  & repeat(11, data_dly(6)) & repeat(6, data_dly(5)));
  d4  <= (          data_dly(9)   & repeat(11, data_dly(8)) & repeat(8, data_dly(7)));
  d5  <= (repeat(10,data_dly(0))  & repeat(10, b9_save));
  d6  <= (repeat(8, data_dly(2))  & repeat(11, data_dly(1)) &           data_dly(0));
  d7  <= (repeat(6, data_dly(4))  & repeat(11, data_dly(3)) & repeat(3, data_dly(2)));
  d8  <= (repeat(4, data_dly(6))  & repeat(11, data_dly(5)) & repeat(5, data_dly(4)));
  d9  <= (repeat(2, data_dly(8))  & repeat(11, data_dly(7)) & repeat(7, data_dly(6)));
  d10 <= (repeat(11,data_dly(9))  & repeat(9,  data_dly(8)));
  d11 <= (repeat(10,data_r(0))    & repeat(10, data_dly(9)));

  process (all)
  begin
    case current_state is
      when "0000" =>
        data_mux <= d0;
      when "0001" =>
        data_mux <= d1;
      when "0010" =>
        data_mux <= d2;
      when "0011" =>
        data_mux <= d3;
      when "0100" =>
        data_mux <= d4;
      when "0101" =>
        data_mux <= d5;
      when "0110" =>
        data_mux <= d6;
      when "0111" =>
        data_mux <= d7;
      when "1000" =>
        data_mux <= d8;
      when "1001" =>
        data_mux <= d9;
      when "1010" =>
        data_mux <= d10;
      when "1011" =>
        data_mux <= d11;
      when others =>
        data_mux <= (others => '0');
      end case;
  end process;

  process(clk, rst)
  begin
    if (rst = '1') then
      data_o <= (others => '0');
      align_err <= '0';
    elsif (rising_edge(clk)) then
      data_o <= data_mux;
      if ((current_state = X"A" or current_state = X"B") and (clk_en_dly = '0')) then
        align_err <= '1';
      else
        align_err <= '0';
      end if;
    end if;
  end process;

end rtl;