# (C) 2001-2015 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and other 
# software and tools, and its AMPP partner logic functions, and any output 
# files any of the foregoing (including device programming or simulation 
# files), and any associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License Subscription 
# Agreement, Altera MegaCore Function License Agreement, or other applicable 
# license agreement, including, without limitation, that your use is for the 
# sole purpose of programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the applicable 
# agreement for further details.


#**************************************************************
# Time Information
#**************************************************************
set_time_format -unit ns -decimal_places 3

derive_pll_clocks -create_base_clocks

#**************************************************************
# Create clock
#**************************************************************
set rx_coreclk_collection [get_ports -nowarn *rx_coreclk]
foreach_in_collection port $rx_coreclk_collection {
  set rx_coreclk_name [get_port_info -name $port]
  create_clock -name $rx_coreclk_name -period 6.734 -waveform { 0.000 3.367 } [get_ports $rx_coreclk_name]
}

set rx_coreclk_hd_collection [get_ports -nowarn *rx_coreclk_hd]
foreach_in_collection port $rx_coreclk_hd_collection {
  set rx_coreclk_hd_name [get_port_info -name $port]
  create_clock -name $rx_coreclk_hd_name -period 13.468 -waveform { 0.000 6.734 } [get_ports $rx_coreclk_hd_name]
}

set phy_mgmtclk_collection [get_ports -nowarn *phy_mgmt_clk]
foreach_in_collection port $phy_mgmtclk_collection {
  set phy_mgmt_clk_name [get_port_info -name $port]
  create_clock -name $phy_mgmt_clk_name -period 10.000 -waveform { 0.000 5.000 } [get_ports $phy_mgmt_clk_name]
}
#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty

#**************************************************************
# Set False Path
#**************************************************************

# This path is not available in single rate as rx_clkout_cnt would be synthesized away
set rx_clkout_cnt_collection [get_keepers -nowarn {*u_xcvr_ctrl_*|rx_clkout_cnt*}]
foreach_in_collection keeper $rx_clkout_cnt_collection {
  set rx_clkout_cnt_keeper_name [get_object_info -name $keeper]
  set_false_path -from [get_keepers $rx_clkout_cnt_keeper_name] -to [get_keepers {*u_xcvr_ctrl_*|*}]
}

# This path is available for all standards except SD-SDI.
set rate_detect_collection [get_keepers -nowarn {*u_rate_detect|*}]
foreach_in_collection keeper $rate_detect_collection {
  set rate_detect_keeper_name [get_object_info -name $keeper]
  set_false_path -from [get_keepers {*u_rate_detect|rx_clkout_cnt*}] -to [get_keepers $rate_detect_keeper_name]
  set_false_path -from [get_keepers {*u_rate_detect|rx_clkout_is_ntsc_paln*}]
}
