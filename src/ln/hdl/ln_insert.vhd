library ieee;
  use ieee.std_logic_1164.all;

entity ln_insert is
  generic(
    DATA_W      : positive := 10;
    VERT_POS_W  : positive := 11
  );
  port (
    ln_ins_en     : in  std_logic;
    ln_word0      : in  std_logic;
    ln_word1      : in  std_logic;
    data_c_i      : in  std_logic_vector(DATA_W-1 downto 0);
    data_y_i      : in  std_logic_vector(DATA_W-1 downto 0);
    ln_i          : in  std_logic_vector(VERT_POS_W-1 downto 0);
    data_c_o      : out std_logic_vector(DATA_W-1 downto 0);
    data_y_o      : out std_logic_vector(DATA_W-1 downto 0)
  );
end ln_insert;

architecture rtl of ln_insert is

begin

  -- process(all)
  process(ln_ins_en, ln_word0, ln_word1, ln_i, data_c_i, data_y_i)
  begin
    if (ln_ins_en = '1') then 
      if(ln_word0 = '1') then
        data_c_o <= (not ln_i(6) & ln_i(6 downto 0) & "00");
        data_y_o <= (not ln_i(6) & ln_i(6 downto 0) & "00");
      elsif (ln_word1 = '1') then
        data_c_o <= ("1000" & ln_i(VERT_POS_W-1 downto 7) & "00");
        data_y_o <= ("1000" & ln_i(VERT_POS_W-1 downto 7) & "00");
      end if;
    else
      data_c_o <= data_c_i;
      data_y_o <= data_y_i;
    end if; 
  end process;

end rtl;
