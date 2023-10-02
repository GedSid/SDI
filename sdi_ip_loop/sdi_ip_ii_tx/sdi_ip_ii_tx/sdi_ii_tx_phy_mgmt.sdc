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
set phy_mgmtclk_collection [get_ports -nowarn *phy_mgmt_clk]
foreach_in_collection port $phy_mgmtclk_collection {
  set phy_mgmt_clk_name [get_port_info -name $port]
  create_clock -name $phy_mgmt_clk_name -period 10.000 -waveform { 0.000 5.000 } [get_ports $phy_mgmt_clk_name]
}

set tx_coreclk_collection [get_ports -nowarn *tx_coreclk]
foreach_in_collection port $tx_coreclk_collection {
  set tx_coreclk_name [get_port_info -name $port]
  create_clock -name $tx_coreclk_name -period 6.734 -waveform { 0.000 3.367 } [get_ports $tx_coreclk_name]
}

set tx_coreclk_hd_collection [get_ports -nowarn *tx_coreclk_hd]
foreach_in_collection port $tx_coreclk_hd_collection {
  set tx_coreclk_hd_name [get_port_info -name $port]
  create_clock -name $tx_coreclk_hd_name -period 13.468 -waveform { 0.000 6.734 } [get_ports $tx_coreclk_hd_name]
}

#**************************************************************
# Set Clock Uncertainty
#**************************************************************
derive_clock_uncertainty

#**************************************************************
# Set False Path
#**************************************************************
# Set false path for link_b transmit data as in usual case, txpll on both xcvr will be merged and hence no clock crossing will be encountered.
# However, in some cases which fitter detects that there are still space available and therefore these 2 tx plls will not be merged.
set phy_b_data_collection [get_keepers -nowarn {*u_phy_b|*|syncdatain}]
foreach_in_collection keeper $phy_b_data_collection {
  set phy_b_data_keeper_name [get_object_info -name $keeper]
  set_false_path -from [get_keepers {*u_tx_protocol|*u_scr|dout[*]}] -to [get_keepers $phy_b_data_keeper_name]
}