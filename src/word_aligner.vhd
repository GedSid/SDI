--------------------------------------------------------------------------------
--                                  Word Aligner                              --
--------------------------------------------------------------------------------
-- Purpose        : Alinea un stream de bits en serie a palabras validas del
--                protocolo.
--
-- Author         : Joaquin Ulloa
--
-- Comments       : Se procesan los datos deserealizados: arma las palabras,
--                decodifica de 10b a 8b y se sincroniza.
--                
--------------------------------------------------------------------------------

library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;

entity word_aligner is
   generic (
      DATA_W            : positive := 20;
      INVALID_PERIOD    : positive -- Cantidad de clocks que reinicia la alineación
                                   -- de palabra, se cuenta mientras invalid_8b10b
                                   -- esté en '1'.
   );
   port (
      rst               : in  std_logic;
      clk               : in  std_logic;
      data_in           : in  std_logic_vector(DATA_W-1 downto 0);
      data_in_valid     : in  std_logic;
      pattern           : in  std_logic_vector(DATA_W-1 downto 0);
      invalid_8b10b     : in  std_logic;
      data_out          : out std_logic_vector(DATA_W-1 downto 0);
      data_out_valid    : out std_logic;
      locked            : out std_logic;
      -- Debug
      pattern_found     : out std_logic
   );
end entity;

architecture rtl of word_aligner is

   signal data_reg_a        : std_logic_vector(3*DATA_W-1 downto 0);
   signal data_reg_b        : std_logic_vector(2*DATA_W-1 downto 0);
   signal aligned_data      : std_logic_vector(2*DATA_W-1 downto 0);
   signal data_shift        : std_logic_vector(2*DATA_W-1 downto 0);
   signal data_shift_fixed  : std_logic_vector(2*DATA_W-1 downto 0);
   
   signal counter           : natural range 0 to INVALID_PERIOD-1;
   signal invalid_8b10b_1ms : std_logic;
   signal compare           : std_logic;
   signal locked_int        : std_logic;
   signal shift_reg         : unsigned(3 downto 0);
   signal shift_reg_fixed   : unsigned(3 downto 0);
   
begin

   process(clk, rst)
   begin
      if (rst = '1') then
         data_reg_a   <= (others => '0');
         data_reg_b   <= (others => '0');
         aligned_data <= (others => '0');
      elsif rising_edge(clk) then
         if (data_in_valid = '1') then
            data_reg_a(3*DATA_W-1 downto 2*DATA_W) <= data_in;
            data_reg_a(2*DATA_W-1 downto DATA_W)   <= data_reg_a(3*DATA_W-1 downto 2*DATA_W);
            data_reg_a(  DATA_W-1 downto  0)       <= data_reg_a(2*DATA_W-1 downto DATA_W);
         end if;
         data_reg_b   <= data_shift;
         aligned_data <= data_shift_fixed;
      end if;
   end process;
   
   data_shift       <= std_logic_vector(resize(shift_right(unsigned(data_reg_a), to_integer(shift_reg)), data_shift'length));
   data_shift_fixed <= std_logic_vector(resize(shift_right(unsigned(data_reg_a), to_integer(shift_reg_fixed)), data_shift'length));

   compare          <= '1' when (data_reg_b = (not pattern & pattern)) else '0';
-- compare          <= '1' when (data_reg_b(9 downto 0) = pattern) else '0';

   process(clk, rst)
   begin
      if (rst = '1') then
         shift_reg   <= (others => '0');
         pattern_found   <= '0';
      elsif rising_edge(clk) then
         pattern_found   <= compare;
         if (data_in_valid = '1') then
            if (compare = '0') then
               shift_reg <= shift_reg + 1;
            end if;
         end if;
      end if;
   end process;

   process(clk, rst)
   begin
      if (rst = '1') then
         data_out              <= (others => '0');
         data_out_valid        <= '0';
         locked_int            <= '0';
         shift_reg_fixed       <= (others => '0');
      elsif rising_edge(clk) then
         data_out              <= (others => '0');
         data_out_valid        <= '0';
         if (locked_int = '0') then
            if (compare = '1') then
               locked_int      <= '1';
               shift_reg_fixed <= shift_reg;
            end if;
         elsif (compare = '1' and shift_reg /= shift_reg_fixed) then
            -- Cambió la alineación
            locked_int         <= '0';
         elsif (invalid_8b10b_1ms = '1') then
            -- Hay algún problema, probar realinear las palabras
            locked_int         <= '0';
         else
            data_out           <= aligned_data(DATA_W-1 downto 0);
            data_out_valid     <= data_in_valid;
         end if;
      end if;
   end process;

   locked <= locked_int;

   counter_proc: process(clk, rst)
   begin
      if (rst = '1') then
         invalid_8b10b_1ms    <= '0';
         counter              <=  0;
      elsif (rising_edge(clk)) then
         if (locked_int = '1' and invalid_8b10b = '1') then
            counter           <= counter + 1;
         else
            counter           <=  0;
         end if;
         if (counter = INVALID_PERIOD) then
            invalid_8b10b_1ms <= '1';
         else
            invalid_8b10b_1ms <= '0';
         end if;
      end if;
   end process;

end architecture;
