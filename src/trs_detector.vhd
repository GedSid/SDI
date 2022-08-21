
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity trs_detector is
    port (
        clk:            in  std_ulogic;                     -- clock input
        ce:             in  std_ulogic;                     -- clock enable
        rst:            in  std_ulogic;                     -- async reset input
        dv_i    : in std_logic;
        data_i  : in std_logic_vector(DATA_W - 1 downto 0);
        vid_out:        out std_ulogic_vector(9 downto 0);  -- delayed and clipped video output
        rx_trs:         out std_ulogic;                     -- asserted during first word of TRS symbol
        rx_eav:         out std_ulogic;                     -- asserted during first word of an EAV symbol
        rx_sav:         out std_ulogic;                     -- asserted during first word of an SAV symbol
        rx_f:           out std_ulogic;                     -- field bit from last received TRS symbol
        rx_v:           out std_ulogic;                     -- vertical blanking interval bit from last TRS symbol
        rx_h:           out std_ulogic;                     -- horizontal blanking interval bit from last TRS symbol
        rx_xyz:         out std_ulogic;                     -- asserted during TRS XYZ word
        rx_xyz_err:     out std_ulogic;                     -- XYZ error flag for non-4444 standards
        rx_xyz_err_4444:out std_ulogic;                     -- XYZ error flag for 4444 standards
        rx_anc:         out std_ulogic;                     -- asserted during first word of ADF
        rx_edh:         out std_ulogic                      -- asserted during first word of ADF if it is an EDH packet
    );
end trs_detector;

architecture rtl of trs_detector is


begin

sync_in_p: process(clk, rst)
begin
    if (rst = '1') then
        in_reg <= (others => '0');
    elsif (clk'event and clk = '1') then
        if (dv_i = '1') then
            in_reg <= data_i;
        end if;
    end if;
end process;

all_ones_in <=  in_reg(9) and in_reg(8) and in_reg(7) and in_reg(6) and
                in_reg(5) and in_reg(4) and in_reg(3) and in_reg(2);

all_zeros_in <= not(in_reg(9) or in_reg(8) or in_reg(7) or in_reg(6) or
                    in_reg(5) or in_reg(4) or in_reg(3) or in_reg(2));


end architecture;