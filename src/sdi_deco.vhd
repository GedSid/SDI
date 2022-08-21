-- Module Description:
--
-- This is a multi-rate SDI decoder module that supports both SD-SDI (SMPTE 
-- 259M)and HD-SDI (SMPTE 292M).
-- 
-- SDI specifies that the serial bit stream shall be encoded in two ways. First,
-- a generator polynomial of x^9 + x^4 + 1 is used to generate a scrambled data_nrzi 
-- bit sequence. Next, a generator polynomial of x + 1 is used to produce the 
-- final polarity free data_nrz sequence which is transmitted over the physical 
-- layer.
-- 
-- The decoder module described in this file sits at the receiving end of the
-- SDI link and reverses the two encoding steps to extract the original data. 
-- First, the x + 1 generator polynomial is used to convert the bit stream from 
-- data_nrz to data_nrzi. Next, the x^9 + x^4 + 1 generator polynomial is used to 
-- descramble the data.
-- 
-- When running in HD-SDI mode (sd_nohd = 0), 20 bits are decoded every clock 
-- cycle. When running in SD-SDI mode (sd_nohd = 1), the 10-bit SD-SDI data must 
-- be placed on the MS 10 bits of the d port. Ten bits are decoded every clock 
-- cycle and the decoded 10 bits are output on the 10 MS bits of the q port.
-- 
--------------------------------------------------------------------------------

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
    clk   : in  std_logic;    -- word rate clock (74.25 MHz)
    rst   : in  std_logic;    -- async reset
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