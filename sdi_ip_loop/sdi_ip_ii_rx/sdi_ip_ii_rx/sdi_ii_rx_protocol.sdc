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
# Set False Path
#**************************************************************

#------------------------------------------------------------------------------------------------------
# Set false path for rx_std as this signal is used in other blocks and involved clock domain crossing, 
# however this signal would not change for long period of time.
#------------------------------------------------------------------------------------------------------
set rx_std_collection [get_keepers -nowarn {*u_format|rx_std*}]
foreach_in_collection keeper $rx_std_collection {
   set rx_std_keeper_name [get_object_info -name $keeper]
   set_false_path -from [get_keepers $rx_std_keeper_name]
}


#------------------------------------------------------------------------------------------------------
# Set false path for FIFO in hd_dual_link & 3gb demux blocks to clear the asynchronous reset violation
#------------------------------------------------------------------------------------------------------
set fifo_clrn_collection [get_pins -nowarn -nocase -compatibility_mode *|*fifo_*:auto_generated|*|clrn] 
foreach_in_collection pins $fifo_clrn_collection {
   set_false_path -to [get_pins -nocase -compatibility_mode *|*fifo_*:auto_generated|*|clrn] 
}

set fifo_clr1_collection [get_pins -nowarn -nocase -compatibility_mode *|*fifo_*:auto_generated|*|clr1]
foreach_in_collection pins $fifo_clr1_collection {
   set_false_path -to [get_pins -nocase -compatibility_mode *|*fifo_*:auto_generated|*|clr1]
}

set fifo_rdemp_collection [get_keepers -nowarn {*fifo_retime*|rdemp_eq_comp_*sb_aeb}]
foreach_in_collection keeper $fifo_rdemp_collection {
   set_false_path -from [get_keepers -nocase {*fifo_retime*|*wrptr*}] -to [get_keepers -nocase {*fifo_retime*|rdemp_eq_comp_*sb_aeb}]
}

set fifo_wrfull_collection [get_keepers -nowarn {*fifo_retime*|wrfull_eq_comp_*sb_mux_reg}]
foreach_in_collection keeper $fifo_wrfull_collection {
   set_false_path -from [get_keepers -nocase {*fifo_retime*|*rd*}] -to [get_keepers -nocase {*fifo_retime*|wrfull_eq_comp_*sb_mux_reg}]
}

#----------------------------------------------------------------------------------------------
# Set false path for FIFO in hd_dual_link block
#----------------------------------------------------------------------------------------------
# Set false path for FIFO in hd_dual_link block as there is clock domain crossing between *_fifo_wrfull_reg and wrclk of FIFO B
set fifo_wrreq_collection [get_keepers -nowarn -nocase {*u_dual_link_sync|*_fifo_wrfull_reg[*]}]
foreach_in_collection pins $fifo_wrreq_collection {
   set_false_path -from [get_keepers -nocase {*u_dual_link_sync|*_fifo_wrfull_reg[*]}] -to [get_keepers -nocase {*u_dual_link_sync|*stream_b_*_fifo|*}]
   set_false_path -from [get_keepers -nocase {*u_dual_link_sync|*stream_b_*_fifo|*|wrfull_eq_comp_*sb_mux_reg}] -to [get_keepers -nocase {*u_dual_link_sync|b_fifo_wrfull_reg[*]}]
}

# Set false path for FIFO B in hd_dual_link block as there is clock domain crossing between wrfull from FIFO B to state machine which is in clk A domain,
# read request is generated from state machine as well.
set fifo_wrfull_reg_collection [get_keepers -nowarn -nocase *u_dual_link_sync|*stream_b_*_fifo|*fifo_*:auto_generated|wrfull_eq_comp_*sb_mux_reg]
foreach_in_collection keeper $fifo_wrfull_reg_collection {
   set fifo_wrfull_keeper_name [get_object_info -name $keeper]
   set_false_path -from [get_keepers $fifo_wrfull_keeper_name] -to [get_keepers -nocase {*u_dual_link_sync|current_state*}]
   set_false_path -from [get_keepers $fifo_wrfull_keeper_name] -through [get_pins -nocase -compatibility_mode {*u_dual_link_sync|*stream_*_fifo|*rd*}]
}

#-----------------------------------------------------------------------------------------------------------------------------
# Set false path for hd_dual_link_sync block as clock domain inside the block is different when A to B conversion is enabled.
#------------------------------------------------------------------------------------------------------------------------------
set locked_reg_collection [get_keepers -nowarn -nocase *u_dual_link_sync|vpid_fifo_a2b.vpid_line_f*_sync[*]]
foreach_in_collection keeper $locked_reg_collection {
   set locked_reg_keeper_name [get_object_info -name $keeper]
   set_false_path -to   [get_keepers -nocase $locked_reg_keeper_name]
   set_false_path -from [get_keepers -nocase {*u_receive|*u_format|trs_locked}] -to [get_keepers -nocase {*u_dual_link_sync|current_state*}]
   set_false_path -from [get_keepers -nocase {*u_rx_prealign|*u_align|align_locked}] -to [get_keepers -nocase {*u_dual_link_sync|current_state*}]
   set_false_path -from [get_keepers -nocase {*u_dual_link_sync|*stream_a_*_fifo|*|wrfull_eq_comp_*sb_mux_reg}] -to [get_keepers -nocase {*u_dual_link_sync|current_state*}]
   set_false_path -from [get_keepers -nocase {*u_receive|*u_format|trs_locked}] -through [get_pins -nocase -compatibility_mode {*u_dual_link_sync|*stream_*_fifo|*rd*}]
   set_false_path -from [get_keepers -nocase {*u_rx_prealign|*u_align|align_locked}] -through [get_pins -nocase -compatibility_mode {*u_dual_link_sync|*stream_*_fifo|*rd*}]
   set_false_path -from [get_keepers -nocase {*u_receive|*u_format|trs_locked}] -to [get_keepers -nocase {*u_dual_link_sync|err_count*}]
   set_false_path -from [get_keepers -nocase {*u_rx_prealign|*u_align|align_locked}] -to [get_keepers -nocase {*u_dual_link_sync|err_count*}]
   set_false_path -from [get_keepers -nocase {*u_dual_link_sync|*stream_a_*_fifo|*|wrfull_eq_comp_*sb_mux_reg}] -through [get_pins -nocase -compatibility_mode {*u_dual_link_sync|*stream_*_fifo|*rd*}]
   set_false_path -from [get_keepers -nocase {*u_dual_link_sync|*stream_a_*_fifo|*|wrfull_eq_comp_*sb_mux_reg}] -to [get_keepers -nocase {*u_dual_link_sync|a_fifo_wrfull_reg[*]}]
   set_false_path -from [get_keepers -nocase {*u_dual_link_sync|*_fifo_wrfull_reg[*]}] -to [get_keepers -nocase {*u_dual_link_sync|*stream_a_*_fifo|*}]
}
