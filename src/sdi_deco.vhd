-------------------------------------------------------------------------------
--                                  Decoder SDI                              --
-------------------------------------------------------------------------------
-- Purpose  : Decoder de NRZ a NRZI y descrambler del receptor SDI.
--
-- Author   : Joaquin Ulloa
--
-- Comments : Se decodifican los datos de entrada: primero transforma los datos
--            de formato NZR a NZRI, con el polinomio X+1 y luego los descramblea
--            con el polinomio x^9+x^4+1. El encoder hacer el proceso opuesto.
--            Funciona tanto para datos SD, como HD y 3G en tiempo real, en el
--            primer caso se deben usar los 10 MSB.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity multi_sdi_decoder is
  generic(
    DATA_W : positive := 20
  );
  port (
    clk     : in  std_logic;    -- word rate clock (74.25 MHz)
    rst     : in  std_logic;    -- async reset
    sd_nohd : in  std_logic;    -- 0 = HD, 1 = SD
    data_i  : in  std_logic_vector(DATA_W-1 downto 0);
    data_o  : out std_logic_vector(DATA_W-1 downto 0)
  );
end;

architecture rtl of multi_sdi_decoder is

constant POLY_ORDER : positive := 9;
--
signal data_reg_msb   : std_logic := '0';                 -- previous d[19] bit
signal data_reg_9b  : std_logic_vector(POLY_ORDER-1 downto 0) := (others => '0');-- holds 9 MSB from data_nrz-to-data_nrzi for use in next clock cycle
signal data_2_descram    : std_logic_vector(DATA_W+POLY_ORDER-1 downto 0);          -- concat of two input words used by descrambler
signal data_nrzi     : std_logic_vector(DATA_W-1 downto 0);                  -- output of data_nrz-to-data_nrzi converter
signal data_nrz    : std_logic_vector(DATA_W-1 downto 0);                  -- input to data_nrz-to-data_nrzi converter

begin

  -----------------------------------------------------------------------------
  -- NRZI 2 NRZ
  -----------------------------------------------------------------------------
  -- Se guarda el bit más significativo del paquete de datos anterior para
  -- para comparar con menos significativo de paquete actual.
  -- Se usa una compuerta XOR para compara los bits con el que los presede y
  -- convertir NRZ en NRZI.
  -- Si el paquete es SD e compara 10 bits, sino 20 (HD o 3G).
  hold_msb_p: process(rst, clk)
  begin
    if (rst = '1') then
      data_reg_msb <= '0';
    elsif (rising_edge(clk)) then
      data_reg_msb <= data_i(DATA_W-1);
    end if;
  end process;

  data_nrz(DATA_W-1 downto (DATA_W/2)+1)  <= data_i(DATA_W-2 downto DATA_W/2);
  data_nrz(DATA_W/2)                      <= data_reg_msb when sd_nohd = '1' else data_i((DATA_W/2)-1);
  data_nrz((DATA_W/2)-1 downto 1)         <= data_i((DATA_W/2)-2 downto 0);
  data_nrz(0)                             <= data_reg_msb;

  data_nrzi <= data_i xor data_nrz;

  -----------------------------------------------------------------------------
  -- Descrambler
  -----------------------------------------------------------------------------
  -- Se guarda los 9 bits más significativo del paquete de datos anterior para
  -- poder armar una palabra de 29 bits en el descrambler para HD.
  -- La entrada del descrambler será distinta para SD y HD, el largo está dado
  -- por el tamaño del paquete y el orden del polinomio.
  -- Descrambler para el polinomio x^9+x^4+1, para poder aplicar el polinomio a
  -- tdos los bits de la palabra de 20 bits al mismo tiempo es necesario,
  -- agregarle 9 bits.
  hold_9b_p: process(rst, clk)
  begin
    if (rst = '1') then
      data_reg_9b <= (others => '0');
    elsif (rising_edge(clk)) then
      data_reg_9b <= data_nrzi(DATA_W-1 downto DATA_W-POLY_ORDER);
    end if;
  end process;
  
  data_2_descram(DATA_W+POLY_ORDER-1 downto DATA_W-1)  <= data_nrzi(DATA_W-1 downto DATA_W-POLY_ORDER-1);
  data_2_descram(DATA_W-2 downto DATA_W-POLY_ORDER-1)  <= data_reg_9b  when sd_nohd = '1' else data_nrzi(POLY_ORDER downto 1);
  data_2_descram(POLY_ORDER)                           <= data_nrzi(0);
  data_2_descram(POLY_ORDER-1 downto 0)                <= data_reg_9b;

  Descram_9_4_1_p: process(rst, clk)
  begin
    if (rst = '1') then
        data_o <= (others => '0');
    elsif (rising_edge(clk)) then
      for i in 0 to 19 loop
        data_o(i) <= (data_2_descram(i) xor data_2_descram(i + 4)) xor data_2_descram(i + 9);
      end loop;
    end if;
  end process;

end architecture;