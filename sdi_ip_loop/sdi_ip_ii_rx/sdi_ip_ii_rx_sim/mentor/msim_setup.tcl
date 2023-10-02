
# (C) 2001-2023 Altera Corporation. All rights reserved.
# Your use of Altera Corporation's design tools, logic functions and 
# other software and tools, and its AMPP partner logic functions, and 
# any output files any of the foregoing (including device programming 
# or simulation files), and any associated documentation or information 
# are expressly subject to the terms and conditions of the Altera 
# Program License Subscription Agreement, Altera MegaCore Function 
# License Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by Altera 
# or its authorized distributors. Please refer to the applicable 
# agreement for further details.

# ACDS 15.0 145 win32 2023.10.02.11:43:06

# ----------------------------------------
# Auto-generated simulation script

# ----------------------------------------
# Initialize variables
if ![info exists SYSTEM_INSTANCE_NAME] { 
  set SYSTEM_INSTANCE_NAME ""
} elseif { ![ string match "" $SYSTEM_INSTANCE_NAME ] } { 
  set SYSTEM_INSTANCE_NAME "/$SYSTEM_INSTANCE_NAME"
}

if ![info exists TOP_LEVEL_NAME] { 
  set TOP_LEVEL_NAME "sdi_ip_ii_rx"
}

if ![info exists QSYS_SIMDIR] { 
  set QSYS_SIMDIR "./../"
}

if ![info exists QUARTUS_INSTALL_DIR] { 
  set QUARTUS_INSTALL_DIR "C:/altera_full/15.0/quartus/"
}

# ----------------------------------------
# Initialize simulation properties - DO NOT MODIFY!
set ELAB_OPTIONS ""
set SIM_OPTIONS ""
if ![ string match "*-64 vsim*" [ vsim -version ] ] {
} else {
}

# ----------------------------------------
# Copy ROM/RAM files to simulation directory
alias file_copy {
  echo "\[exec\] file_copy"
}

# ----------------------------------------
# Create compilation libraries
proc ensure_lib { lib } { if ![file isdirectory $lib] { vlib $lib } }
ensure_lib          ./libraries/     
ensure_lib          ./libraries/work/
vmap       work     ./libraries/work/
vmap       work_lib ./libraries/work/
if ![ string match "*ModelSim ALTERA*" [ vsim -version ] ] {
  ensure_lib                       ./libraries/altera_ver/           
  vmap       altera_ver            ./libraries/altera_ver/           
  ensure_lib                       ./libraries/lpm_ver/              
  vmap       lpm_ver               ./libraries/lpm_ver/              
  ensure_lib                       ./libraries/sgate_ver/            
  vmap       sgate_ver             ./libraries/sgate_ver/            
  ensure_lib                       ./libraries/altera_mf_ver/        
  vmap       altera_mf_ver         ./libraries/altera_mf_ver/        
  ensure_lib                       ./libraries/altera_lnsim_ver/     
  vmap       altera_lnsim_ver      ./libraries/altera_lnsim_ver/     
  ensure_lib                       ./libraries/cyclonev_ver/         
  vmap       cyclonev_ver          ./libraries/cyclonev_ver/         
  ensure_lib                       ./libraries/cyclonev_hssi_ver/    
  vmap       cyclonev_hssi_ver     ./libraries/cyclonev_hssi_ver/    
  ensure_lib                       ./libraries/cyclonev_pcie_hip_ver/
  vmap       cyclonev_pcie_hip_ver ./libraries/cyclonev_pcie_hip_ver/
  ensure_lib                       ./libraries/altera/               
  vmap       altera                ./libraries/altera/               
  ensure_lib                       ./libraries/lpm/                  
  vmap       lpm                   ./libraries/lpm/                  
  ensure_lib                       ./libraries/sgate/                
  vmap       sgate                 ./libraries/sgate/                
  ensure_lib                       ./libraries/altera_mf/            
  vmap       altera_mf             ./libraries/altera_mf/            
  ensure_lib                       ./libraries/altera_lnsim/         
  vmap       altera_lnsim          ./libraries/altera_lnsim/         
  ensure_lib                       ./libraries/cyclonev/             
  vmap       cyclonev              ./libraries/cyclonev/             
}
ensure_lib                     ./libraries/rx_rst_coreclk_sync/
vmap       rx_rst_coreclk_sync ./libraries/rx_rst_coreclk_sync/
ensure_lib                     ./libraries/u_rx_phy_mgmt/      
vmap       u_rx_phy_mgmt       ./libraries/u_rx_phy_mgmt/      
ensure_lib                     ./libraries/u_rx_protocol/      
vmap       u_rx_protocol       ./libraries/u_rx_protocol/      
ensure_lib                     ./libraries/u_rx_phy_rst_ctrl/  
vmap       u_rx_phy_rst_ctrl   ./libraries/u_rx_phy_rst_ctrl/  
ensure_lib                     ./libraries/u_phy/              
vmap       u_phy               ./libraries/u_phy/              
ensure_lib                     ./libraries/u_phy_adapter/      
vmap       u_phy_adapter       ./libraries/u_phy_adapter/      
ensure_lib                     ./libraries/sdi_ip_ii_rx/       
vmap       sdi_ip_ii_rx        ./libraries/sdi_ip_ii_rx/       

# ----------------------------------------
# Compile device library files
alias dev_com {
  echo "\[exec\] dev_com"
  if ![ string match "*ModelSim ALTERA*" [ vsim -version ] ] {
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.v"                       -work altera_ver           
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.v"                                -work lpm_ver              
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.v"                                   -work sgate_ver            
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.v"                               -work altera_mf_ver        
    vlog -sv "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/altera_lnsim_for_vhdl.sv"           -work altera_lnsim_ver     
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/cyclonev_atoms_ncrypt.v"            -work cyclonev_ver         
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/cyclonev_hmi_atoms_ncrypt.v"        -work cyclonev_ver         
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/cyclonev_atoms_for_vhdl.v"          -work cyclonev_ver         
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/cyclonev_hssi_atoms_ncrypt.v"       -work cyclonev_hssi_ver    
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/cyclonev_hssi_atoms_for_vhdl.v"     -work cyclonev_hssi_ver    
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/cyclonev_pcie_hip_atoms_ncrypt.v"   -work cyclonev_pcie_hip_ver
    vlog     "$QUARTUS_INSTALL_DIR/eda/sim_lib/mentor/cyclonev_pcie_hip_atoms_for_vhdl.v" -work cyclonev_pcie_hip_ver
    vcom     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_syn_attributes.vhd"                 -work altera               
    vcom     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_standard_functions.vhd"             -work altera               
    vcom     "$QUARTUS_INSTALL_DIR/eda/sim_lib/alt_dspbuilder_package.vhd"                -work altera               
    vcom     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_europa_support_lib.vhd"             -work altera               
    vcom     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives_components.vhd"          -work altera               
    vcom     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_primitives.vhd"                     -work altera               
    vcom     "$QUARTUS_INSTALL_DIR/eda/sim_lib/220pack.vhd"                               -work lpm                  
    vcom     "$QUARTUS_INSTALL_DIR/eda/sim_lib/220model.vhd"                              -work lpm                  
    vcom     "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate_pack.vhd"                            -work sgate                
    vcom     "$QUARTUS_INSTALL_DIR/eda/sim_lib/sgate.vhd"                                 -work sgate                
    vcom     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf_components.vhd"                  -work altera_mf            
    vcom     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_mf.vhd"                             -work altera_mf            
    vcom     "$QUARTUS_INSTALL_DIR/eda/sim_lib/altera_lnsim_components.vhd"               -work altera_lnsim         
    vcom     "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_atoms.vhd"                        -work cyclonev             
    vcom     "$QUARTUS_INSTALL_DIR/eda/sim_lib/cyclonev_components.vhd"                   -work cyclonev             
  }
}

# ----------------------------------------
# Compile the design files in correct order
alias com {
  echo "\[exec\] com"
  vlog     "$QSYS_SIMDIR/altera_reset_controller/mentor/altera_reset_controller.v"             -work rx_rst_coreclk_sync
  vlog     "$QSYS_SIMDIR/altera_reset_controller/mentor/altera_reset_synchronizer.v"           -work rx_rst_coreclk_sync
  vlog     "$QSYS_SIMDIR/sdi_ii_rx_phy_mgmt/mentor/src_hdl/sdi_ii_rx_phy_mgmt.v"               -work u_rx_phy_mgmt      
  vlog     "$QSYS_SIMDIR/sdi_ii_rx_phy_mgmt/mentor/src_hdl/sdi_ii_rx_sample.v"                 -work u_rx_phy_mgmt      
  vlog     "$QSYS_SIMDIR/sdi_ii_rx_phy_mgmt/mentor/src_hdl/sdi_ii_rx_xcvr_ctrl_native.v"       -work u_rx_phy_mgmt      
  vlog     "$QSYS_SIMDIR/sdi_ii_rx_phy_mgmt/mentor/src_hdl/sdi_ii_rx_xcvr_interface.v"         -work u_rx_phy_mgmt      
  vlog     "$QSYS_SIMDIR/sdi_ii_rx_phy_mgmt/mentor/src_hdl/sdi_ii_rx_vid_std_detect.v"         -work u_rx_phy_mgmt      
  vlog     "$QSYS_SIMDIR/sdi_ii_rx_phy_mgmt/mentor/src_hdl/sdi_ii_rx_rate_detect.v"            -work u_rx_phy_mgmt      
  vlog     "$QSYS_SIMDIR/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_rx_protocol.v"               -work u_rx_protocol      
  vlog     "$QSYS_SIMDIR/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_hd_crc.v"                    -work u_rx_protocol      
  vlog     "$QSYS_SIMDIR/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_hd_extract_ln.v"             -work u_rx_protocol      
  vlog     "$QSYS_SIMDIR/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_3gb_demux.v"                 -work u_rx_protocol      
  vlog     "$QSYS_SIMDIR/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_trs_aligner.v"               -work u_rx_protocol      
  vlog     "$QSYS_SIMDIR/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_descrambler.v"               -work u_rx_protocol      
  vlog     "$QSYS_SIMDIR/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_format.v"                    -work u_rx_protocol      
  vlog     "$QSYS_SIMDIR/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_receive.v"                   -work u_rx_protocol      
  vlog     "$QSYS_SIMDIR/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_vpid_extract.v"              -work u_rx_protocol      
  vlog     "$QSYS_SIMDIR/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_trsmatch.v"                  -work u_rx_protocol      
  vlog     "$QSYS_SIMDIR/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_hd_dual_link.v"              -work u_rx_protocol      
  vlog     "$QSYS_SIMDIR/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_fifo_retime.v"               -work u_rx_protocol      
  vlog     "$QSYS_SIMDIR/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_rx_prealign.v"               -work u_rx_protocol      
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_reset_control/altera_xcvr_functions.sv"                   -work u_rx_phy_rst_ctrl  
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_reset_control/mentor/altera_xcvr_functions.sv"            -work u_rx_phy_rst_ctrl  
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_reset_control/alt_xcvr_resync.sv"                         -work u_rx_phy_rst_ctrl  
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_reset_control/mentor/alt_xcvr_resync.sv"                  -work u_rx_phy_rst_ctrl  
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_reset_control/altera_xcvr_reset_control.sv"               -work u_rx_phy_rst_ctrl  
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_reset_control/alt_xcvr_reset_counter.sv"                  -work u_rx_phy_rst_ctrl  
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_reset_control/mentor/altera_xcvr_reset_control.sv"        -work u_rx_phy_rst_ctrl  
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_reset_control/mentor/alt_xcvr_reset_counter.sv"           -work u_rx_phy_rst_ctrl  
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/altera_xcvr_functions.sv"                       -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/altera_xcvr_functions.sv"                -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/sv_reconfig_bundle_to_xcvr.sv"                  -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/sv_reconfig_bundle_to_ip.sv"                    -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/sv_reconfig_bundle_merger.sv"                   -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/sv_reconfig_bundle_to_xcvr.sv"           -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/sv_reconfig_bundle_to_ip.sv"             -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/sv_reconfig_bundle_merger.sv"            -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/av_xcvr_h.sv"                                   -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/av_xcvr_avmm_csr.sv"                            -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/av_tx_pma_ch.sv"                                -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/av_tx_pma.sv"                                   -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/av_rx_pma.sv"                                   -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/av_pma.sv"                                      -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/av_pcs_ch.sv"                                   -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/av_pcs.sv"                                      -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/av_xcvr_avmm.sv"                                -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/av_xcvr_native.sv"                              -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/av_xcvr_plls.sv"                                -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/av_xcvr_data_adapter.sv"                        -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/av_reconfig_bundle_to_basic.sv"                 -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/av_reconfig_bundle_to_xcvr.sv"                  -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/av_xcvr_h.sv"                            -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/av_xcvr_avmm_csr.sv"                     -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/av_tx_pma_ch.sv"                         -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/av_tx_pma.sv"                            -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/av_rx_pma.sv"                            -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/av_pma.sv"                               -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/av_pcs_ch.sv"                            -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/av_pcs.sv"                               -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/av_xcvr_avmm.sv"                         -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/av_xcvr_native.sv"                       -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/av_xcvr_plls.sv"                         -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/av_xcvr_data_adapter.sv"                 -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/av_reconfig_bundle_to_basic.sv"          -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/av_reconfig_bundle_to_xcvr.sv"           -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/av_hssi_8g_rx_pcs_rbc.sv"                       -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/av_hssi_8g_tx_pcs_rbc.sv"                       -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/av_hssi_common_pcs_pma_interface_rbc.sv"        -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/av_hssi_common_pld_pcs_interface_rbc.sv"        -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/av_hssi_pipe_gen1_2_rbc.sv"                     -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/av_hssi_rx_pcs_pma_interface_rbc.sv"            -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/av_hssi_rx_pld_pcs_interface_rbc.sv"            -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/av_hssi_tx_pcs_pma_interface_rbc.sv"            -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/av_hssi_tx_pld_pcs_interface_rbc.sv"            -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/av_hssi_8g_rx_pcs_rbc.sv"                -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/av_hssi_8g_tx_pcs_rbc.sv"                -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/av_hssi_common_pcs_pma_interface_rbc.sv" -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/av_hssi_common_pld_pcs_interface_rbc.sv" -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/av_hssi_pipe_gen1_2_rbc.sv"              -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/av_hssi_rx_pcs_pma_interface_rbc.sv"     -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/av_hssi_rx_pld_pcs_interface_rbc.sv"     -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/av_hssi_tx_pcs_pma_interface_rbc.sv"     -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/av_hssi_tx_pld_pcs_interface_rbc.sv"     -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/alt_reset_ctrl_lego.sv"                         -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/alt_reset_ctrl_tgx_cdrauto.sv"                  -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/alt_xcvr_resync.sv"                             -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/alt_reset_ctrl_lego.sv"                  -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/alt_reset_ctrl_tgx_cdrauto.sv"           -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/alt_xcvr_resync.sv"                      -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/alt_xcvr_csr_common_h.sv"                       -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/alt_xcvr_csr_common.sv"                         -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/alt_xcvr_csr_pcs8g_h.sv"                        -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/alt_xcvr_csr_pcs8g.sv"                          -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/alt_xcvr_csr_selector.sv"                       -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/alt_xcvr_mgmt2dec.sv"                           -work u_phy              
  vlog     "$QSYS_SIMDIR/altera_xcvr_native_cv/altera_wait_generate.v"                         -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/alt_xcvr_csr_common_h.sv"                -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/alt_xcvr_csr_common.sv"                  -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/alt_xcvr_csr_pcs8g_h.sv"                 -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/alt_xcvr_csr_pcs8g.sv"                   -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/alt_xcvr_csr_selector.sv"                -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/alt_xcvr_mgmt2dec.sv"                    -work u_phy              
  vlog     "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/altera_wait_generate.v"                  -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/altera_xcvr_native_av_functions_h.sv"           -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/altera_xcvr_native_av.sv"                       -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/altera_xcvr_data_adapter_av.sv"                 -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/altera_xcvr_native_av_functions_h.sv"    -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/altera_xcvr_native_av.sv"                -work u_phy              
  vlog -sv "$QSYS_SIMDIR/altera_xcvr_native_cv/mentor/altera_xcvr_data_adapter_av.sv"          -work u_phy              
  vlog     "$QSYS_SIMDIR/sdi_ii_phy_adapter/sdi_ii_phy_adapter.v"                              -work u_phy_adapter      
  vcom     "$QSYS_SIMDIR/sdi_ii/sdi_ii_0001.vhd"                                               -work sdi_ip_ii_rx       
  vcom     "$QSYS_SIMDIR/sdi_ip_ii_rx.vhd"                                                                              
}

# ----------------------------------------
# Elaborate top level design
alias elab {
  echo "\[exec\] elab"
  eval vsim -t ps $ELAB_OPTIONS -L work -L work_lib -L rx_rst_coreclk_sync -L u_rx_phy_mgmt -L u_rx_protocol -L u_rx_phy_rst_ctrl -L u_phy -L u_phy_adapter -L sdi_ip_ii_rx -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev $TOP_LEVEL_NAME
}

# ----------------------------------------
# Elaborate the top level design with novopt option
alias elab_debug {
  echo "\[exec\] elab_debug"
  eval vsim -novopt -t ps $ELAB_OPTIONS -L work -L work_lib -L rx_rst_coreclk_sync -L u_rx_phy_mgmt -L u_rx_protocol -L u_rx_phy_rst_ctrl -L u_phy -L u_phy_adapter -L sdi_ip_ii_rx -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev $TOP_LEVEL_NAME
}

# ----------------------------------------
# Compile all the design files and elaborate the top level design
alias ld "
  dev_com
  com
  elab
"

# ----------------------------------------
# Compile all the design files and elaborate the top level design with -novopt
alias ld_debug "
  dev_com
  com
  elab_debug
"

# ----------------------------------------
# Print out user commmand line aliases
alias h {
  echo "List Of Command Line Aliases"
  echo
  echo "file_copy                     -- Copy ROM/RAM files to simulation directory"
  echo
  echo "dev_com                       -- Compile device library files"
  echo
  echo "com                           -- Compile the design files in correct order"
  echo
  echo "elab                          -- Elaborate top level design"
  echo
  echo "elab_debug                    -- Elaborate the top level design with novopt option"
  echo
  echo "ld                            -- Compile all the design files and elaborate the top level design"
  echo
  echo "ld_debug                      -- Compile all the design files and elaborate the top level design with -novopt"
  echo
  echo 
  echo
  echo "List Of Variables"
  echo
  echo "TOP_LEVEL_NAME                -- Top level module name."
  echo
  echo "SYSTEM_INSTANCE_NAME          -- Instantiated system module name inside top level module."
  echo
  echo "QSYS_SIMDIR                   -- Qsys base simulation directory."
  echo
  echo "QUARTUS_INSTALL_DIR           -- Quartus installation directory."
}
file_copy
h
