transcript on
if ![file isdirectory sdi_ip_loop_iputf_libs] {
	file mkdir sdi_ip_loop_iputf_libs
}

if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

###### Libraries for IPUTF cores 
vlib sdi_ip_loop_iputf_libs/rx_rst_coreclk_sync
vmap rx_rst_coreclk_sync ./sdi_ip_loop_iputf_libs/rx_rst_coreclk_sync
vlib sdi_ip_loop_iputf_libs/u_rx_phy_mgmt
vmap u_rx_phy_mgmt ./sdi_ip_loop_iputf_libs/u_rx_phy_mgmt
vlib sdi_ip_loop_iputf_libs/u_rx_protocol
vmap u_rx_protocol ./sdi_ip_loop_iputf_libs/u_rx_protocol
vlib sdi_ip_loop_iputf_libs/u_rx_phy_rst_ctrl
vmap u_rx_phy_rst_ctrl ./sdi_ip_loop_iputf_libs/u_rx_phy_rst_ctrl
vlib sdi_ip_loop_iputf_libs/u_tx_phy
vmap u_tx_phy ./sdi_ip_loop_iputf_libs/u_tx_phy
vlib sdi_ip_loop_iputf_libs/u_tx_phy_adapter
vmap u_tx_phy_adapter ./sdi_ip_loop_iputf_libs/u_tx_phy_adapter
vlib sdi_ip_loop_iputf_libs/u_rx_phy
vmap u_rx_phy ./sdi_ip_loop_iputf_libs/u_rx_phy
vlib sdi_ip_loop_iputf_libs/u_rx_phy_adapter
vmap u_rx_phy_adapter ./sdi_ip_loop_iputf_libs/u_rx_phy_adapter
vlib sdi_ip_loop_iputf_libs/sdi_ip_ii_rx
vmap sdi_ip_ii_rx ./sdi_ip_loop_iputf_libs/sdi_ip_ii_rx
vlib sdi_ip_loop_iputf_libs/tx_rst_coreclk_sync
vmap tx_rst_coreclk_sync ./sdi_ip_loop_iputf_libs/tx_rst_coreclk_sync
vlib sdi_ip_loop_iputf_libs/u_tx_phy_mgmt
vmap u_tx_phy_mgmt ./sdi_ip_loop_iputf_libs/u_tx_phy_mgmt
vlib sdi_ip_loop_iputf_libs/u_tx_protocol
vmap u_tx_protocol ./sdi_ip_loop_iputf_libs/u_tx_protocol
vlib sdi_ip_loop_iputf_libs/u_tx_phy_rst_ctrl
vmap u_tx_phy_rst_ctrl ./sdi_ip_loop_iputf_libs/u_tx_phy_rst_ctrl
vlib sdi_ip_loop_iputf_libs/sdi_ip_ii_tx
vmap sdi_ip_ii_tx ./sdi_ip_loop_iputf_libs/sdi_ip_ii_tx
###### End libraries for IPUTF cores 
###### MIF file copy and HDL compilation commands for IPUTF cores 


vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_reset_controller/mentor/altera_reset_controller.v"             -work rx_rst_coreclk_sync
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_reset_controller/mentor/altera_reset_synchronizer.v"           -work rx_rst_coreclk_sync
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/sdi_ii_rx_phy_mgmt/mentor/src_hdl/sdi_ii_rx_phy_mgmt.v"               -work u_rx_phy_mgmt      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/sdi_ii_rx_phy_mgmt/mentor/src_hdl/sdi_ii_rx_sample.v"                 -work u_rx_phy_mgmt      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/sdi_ii_rx_phy_mgmt/mentor/src_hdl/sdi_ii_rx_xcvr_ctrl_native.v"       -work u_rx_phy_mgmt      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/sdi_ii_rx_phy_mgmt/mentor/src_hdl/sdi_ii_rx_xcvr_interface.v"         -work u_rx_phy_mgmt      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/sdi_ii_rx_phy_mgmt/mentor/src_hdl/sdi_ii_rx_vid_std_detect.v"         -work u_rx_phy_mgmt      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/sdi_ii_rx_phy_mgmt/mentor/src_hdl/sdi_ii_rx_rate_detect.v"            -work u_rx_phy_mgmt      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_rx_protocol.v"               -work u_rx_protocol      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_hd_crc.v"                    -work u_rx_protocol      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_hd_extract_ln.v"             -work u_rx_protocol      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_3gb_demux.v"                 -work u_rx_protocol      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_trs_aligner.v"               -work u_rx_protocol      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_descrambler.v"               -work u_rx_protocol      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_format.v"                    -work u_rx_protocol      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_receive.v"                   -work u_rx_protocol      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_vpid_extract.v"              -work u_rx_protocol      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_trsmatch.v"                  -work u_rx_protocol      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_hd_dual_link.v"              -work u_rx_protocol      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_fifo_retime.v"               -work u_rx_protocol      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/sdi_ii_rx_protocol/mentor/src_hdl/sdi_ii_rx_prealign.v"               -work u_rx_protocol      
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_reset_control/altera_xcvr_functions.sv"                   -work u_rx_phy_rst_ctrl  
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_reset_control/mentor/altera_xcvr_functions.sv"            -work u_rx_phy_rst_ctrl  
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_reset_control/alt_xcvr_resync.sv"                         -work u_rx_phy_rst_ctrl  
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_reset_control/mentor/alt_xcvr_resync.sv"                  -work u_rx_phy_rst_ctrl  
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_reset_control/altera_xcvr_reset_control.sv"               -work u_rx_phy_rst_ctrl  
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_reset_control/alt_xcvr_reset_counter.sv"                  -work u_rx_phy_rst_ctrl  
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_reset_control/mentor/altera_xcvr_reset_control.sv"        -work u_rx_phy_rst_ctrl  
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_reset_control/mentor/alt_xcvr_reset_counter.sv"           -work u_rx_phy_rst_ctrl  
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/altera_xcvr_functions.sv"                       -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/altera_xcvr_functions.sv"                -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/sv_reconfig_bundle_to_xcvr.sv"                  -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/sv_reconfig_bundle_to_ip.sv"                    -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/sv_reconfig_bundle_merger.sv"                   -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/sv_reconfig_bundle_to_xcvr.sv"           -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/sv_reconfig_bundle_to_ip.sv"             -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/sv_reconfig_bundle_merger.sv"            -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/av_xcvr_h.sv"                                   -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/av_xcvr_avmm_csr.sv"                            -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/av_tx_pma_ch.sv"                                -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/av_tx_pma.sv"                                   -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/av_rx_pma.sv"                                   -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/av_pma.sv"                                      -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/av_pcs_ch.sv"                                   -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/av_pcs.sv"                                      -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/av_xcvr_avmm.sv"                                -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/av_xcvr_native.sv"                              -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/av_xcvr_plls.sv"                                -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/av_xcvr_data_adapter.sv"                        -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/av_reconfig_bundle_to_basic.sv"                 -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/av_reconfig_bundle_to_xcvr.sv"                  -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/av_xcvr_h.sv"                            -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/av_xcvr_avmm_csr.sv"                     -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/av_tx_pma_ch.sv"                         -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/av_tx_pma.sv"                            -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/av_rx_pma.sv"                            -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/av_pma.sv"                               -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/av_pcs_ch.sv"                            -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/av_pcs.sv"                               -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/av_xcvr_avmm.sv"                         -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/av_xcvr_native.sv"                       -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/av_xcvr_plls.sv"                         -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/av_xcvr_data_adapter.sv"                 -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/av_reconfig_bundle_to_basic.sv"          -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/av_reconfig_bundle_to_xcvr.sv"           -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/av_hssi_8g_rx_pcs_rbc.sv"                       -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/av_hssi_8g_tx_pcs_rbc.sv"                       -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/av_hssi_common_pcs_pma_interface_rbc.sv"        -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/av_hssi_common_pld_pcs_interface_rbc.sv"        -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/av_hssi_pipe_gen1_2_rbc.sv"                     -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/av_hssi_rx_pcs_pma_interface_rbc.sv"            -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/av_hssi_rx_pld_pcs_interface_rbc.sv"            -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/av_hssi_tx_pcs_pma_interface_rbc.sv"            -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/av_hssi_tx_pld_pcs_interface_rbc.sv"            -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/av_hssi_8g_rx_pcs_rbc.sv"                -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/av_hssi_8g_tx_pcs_rbc.sv"                -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/av_hssi_common_pcs_pma_interface_rbc.sv" -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/av_hssi_common_pld_pcs_interface_rbc.sv" -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/av_hssi_pipe_gen1_2_rbc.sv"              -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/av_hssi_rx_pcs_pma_interface_rbc.sv"     -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/av_hssi_rx_pld_pcs_interface_rbc.sv"     -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/av_hssi_tx_pcs_pma_interface_rbc.sv"     -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/av_hssi_tx_pld_pcs_interface_rbc.sv"     -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/alt_reset_ctrl_lego.sv"                         -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/alt_reset_ctrl_tgx_cdrauto.sv"                  -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/alt_xcvr_resync.sv"                             -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/alt_reset_ctrl_lego.sv"                  -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/alt_reset_ctrl_tgx_cdrauto.sv"           -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/alt_xcvr_resync.sv"                      -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/alt_xcvr_csr_common_h.sv"                       -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/alt_xcvr_csr_common.sv"                         -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/alt_xcvr_csr_pcs8g_h.sv"                        -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/alt_xcvr_csr_pcs8g.sv"                          -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/alt_xcvr_csr_selector.sv"                       -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/alt_xcvr_mgmt2dec.sv"                           -work u_rx_phy              
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/altera_wait_generate.v"                         -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/alt_xcvr_csr_common_h.sv"                -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/alt_xcvr_csr_common.sv"                  -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/alt_xcvr_csr_pcs8g_h.sv"                 -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/alt_xcvr_csr_pcs8g.sv"                   -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/alt_xcvr_csr_selector.sv"                -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/alt_xcvr_mgmt2dec.sv"                    -work u_rx_phy              
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/altera_wait_generate.v"                  -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/altera_xcvr_native_av_functions_h.sv"           -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/altera_xcvr_native_av.sv"                       -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/altera_xcvr_data_adapter_av.sv"                 -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/altera_xcvr_native_av_functions_h.sv"    -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/altera_xcvr_native_av.sv"                -work u_rx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/altera_xcvr_native_cv/mentor/altera_xcvr_data_adapter_av.sv"          -work u_rx_phy              
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/sdi_ii_phy_adapter/sdi_ii_phy_adapter.v"                              -work u_rx_phy_adapter      
vcom     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/sdi_ii/sdi_ii_0001_rx.vhd"                                            -work sdi_ip_ii_rx       
vcom     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_rx/sdi_ip_ii_rx_sim/sdi_ip_ii_rx.vhd"                                                                              
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_reset_controller/mentor/altera_reset_controller.v"             -work tx_rst_coreclk_sync
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_reset_controller/mentor/altera_reset_synchronizer.v"           -work tx_rst_coreclk_sync
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/sdi_ii_tx_phy_mgmt/mentor/src_hdl/sdi_ii_tx_phy_mgmt.v"               -work u_tx_phy_mgmt      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/sdi_ii_tx_phy_mgmt/mentor/src_hdl/sdi_ii_tx_sample.v"                 -work u_tx_phy_mgmt      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/sdi_ii_tx_phy_mgmt/mentor/src_hdl/sdi_ii_tx_xcvr_interface.v"         -work u_tx_phy_mgmt      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/sdi_ii_tx_phy_mgmt/mentor/src_hdl/sdi_ii_tx_ce_gen.v"                 -work u_tx_phy_mgmt      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/sdi_ii_tx_protocol/mentor/src_hdl/sdi_ii_tx_protocol.v"               -work u_tx_protocol      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/sdi_ii_tx_protocol/mentor/src_hdl/sdi_ii_hd_crc.v"                    -work u_tx_protocol      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/sdi_ii_tx_protocol/mentor/src_hdl/sdi_ii_hd_insert_ln.v"              -work u_tx_protocol      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/sdi_ii_tx_protocol/mentor/src_hdl/sdi_ii_scrambler.v"                 -work u_tx_protocol      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/sdi_ii_tx_protocol/mentor/src_hdl/sdi_ii_transmit.v"                  -work u_tx_protocol      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/sdi_ii_tx_protocol/mentor/src_hdl/sdi_ii_vpid_insert.v"               -work u_tx_protocol      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/sdi_ii_tx_protocol/mentor/src_hdl/sdi_ii_trsmatch.v"                  -work u_tx_protocol      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/sdi_ii_tx_protocol/mentor/src_hdl/sdi_ii_sd_bits_conv.v"              -work u_tx_protocol      
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/sdi_ii_tx_protocol/mentor/src_hdl/sdi_ii_sync_bit_ins.v"              -work u_tx_protocol      
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_reset_control/altera_xcvr_functions.sv"                   -work u_tx_phy_rst_ctrl  
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_reset_control/mentor/altera_xcvr_functions.sv"            -work u_tx_phy_rst_ctrl  
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_reset_control/alt_xcvr_resync.sv"                         -work u_tx_phy_rst_ctrl  
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_reset_control/mentor/alt_xcvr_resync.sv"                  -work u_tx_phy_rst_ctrl  
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_reset_control/altera_xcvr_reset_control.sv"               -work u_tx_phy_rst_ctrl  
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_reset_control/alt_xcvr_reset_counter.sv"                  -work u_tx_phy_rst_ctrl  
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_reset_control/mentor/altera_xcvr_reset_control.sv"        -work u_tx_phy_rst_ctrl  
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_reset_control/mentor/alt_xcvr_reset_counter.sv"           -work u_tx_phy_rst_ctrl  
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/altera_xcvr_functions.sv"                       -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/altera_xcvr_functions.sv"                -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/sv_reconfig_bundle_to_xcvr.sv"                  -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/sv_reconfig_bundle_to_ip.sv"                    -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/sv_reconfig_bundle_merger.sv"                   -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/sv_reconfig_bundle_to_xcvr.sv"           -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/sv_reconfig_bundle_to_ip.sv"             -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/sv_reconfig_bundle_merger.sv"            -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/av_xcvr_h.sv"                                   -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/av_xcvr_avmm_csr.sv"                            -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/av_tx_pma_ch.sv"                                -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/av_tx_pma.sv"                                   -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/av_rx_pma.sv"                                   -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/av_pma.sv"                                      -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/av_pcs_ch.sv"                                   -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/av_pcs.sv"                                      -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/av_xcvr_avmm.sv"                                -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/av_xcvr_native.sv"                              -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/av_xcvr_plls.sv"                                -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/av_xcvr_data_adapter.sv"                        -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/av_reconfig_bundle_to_basic.sv"                 -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/av_reconfig_bundle_to_xcvr.sv"                  -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/av_xcvr_h.sv"                            -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/av_xcvr_avmm_csr.sv"                     -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/av_tx_pma_ch.sv"                         -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/av_tx_pma.sv"                            -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/av_rx_pma.sv"                            -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/av_pma.sv"                               -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/av_pcs_ch.sv"                            -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/av_pcs.sv"                               -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/av_xcvr_avmm.sv"                         -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/av_xcvr_native.sv"                       -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/av_xcvr_plls.sv"                         -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/av_xcvr_data_adapter.sv"                 -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/av_reconfig_bundle_to_basic.sv"          -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/av_reconfig_bundle_to_xcvr.sv"           -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/av_hssi_8g_rx_pcs_rbc.sv"                       -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/av_hssi_8g_tx_pcs_rbc.sv"                       -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/av_hssi_common_pcs_pma_interface_rbc.sv"        -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/av_hssi_common_pld_pcs_interface_rbc.sv"        -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/av_hssi_pipe_gen1_2_rbc.sv"                     -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/av_hssi_rx_pcs_pma_interface_rbc.sv"            -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/av_hssi_rx_pld_pcs_interface_rbc.sv"            -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/av_hssi_tx_pcs_pma_interface_rbc.sv"            -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/av_hssi_tx_pld_pcs_interface_rbc.sv"            -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/av_hssi_8g_rx_pcs_rbc.sv"                -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/av_hssi_8g_tx_pcs_rbc.sv"                -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/av_hssi_common_pcs_pma_interface_rbc.sv" -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/av_hssi_common_pld_pcs_interface_rbc.sv" -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/av_hssi_pipe_gen1_2_rbc.sv"              -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/av_hssi_rx_pcs_pma_interface_rbc.sv"     -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/av_hssi_rx_pld_pcs_interface_rbc.sv"     -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/av_hssi_tx_pcs_pma_interface_rbc.sv"     -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/av_hssi_tx_pld_pcs_interface_rbc.sv"     -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/alt_reset_ctrl_lego.sv"                         -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/alt_reset_ctrl_tgx_cdrauto.sv"                  -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/alt_xcvr_resync.sv"                             -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/alt_reset_ctrl_lego.sv"                  -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/alt_reset_ctrl_tgx_cdrauto.sv"           -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/alt_xcvr_resync.sv"                      -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/alt_xcvr_csr_common_h.sv"                       -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/alt_xcvr_csr_common.sv"                         -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/alt_xcvr_csr_pcs8g_h.sv"                        -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/alt_xcvr_csr_pcs8g.sv"                          -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/alt_xcvr_csr_selector.sv"                       -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/alt_xcvr_mgmt2dec.sv"                           -work u_tx_phy              
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/altera_wait_generate.v"                         -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/alt_xcvr_csr_common_h.sv"                -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/alt_xcvr_csr_common.sv"                  -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/alt_xcvr_csr_pcs8g_h.sv"                 -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/alt_xcvr_csr_pcs8g.sv"                   -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/alt_xcvr_csr_selector.sv"                -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/alt_xcvr_mgmt2dec.sv"                    -work u_tx_phy              
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/altera_wait_generate.v"                  -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/altera_xcvr_native_av_functions_h.sv"           -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/altera_xcvr_native_av.sv"                       -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/altera_xcvr_data_adapter_av.sv"                 -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/altera_xcvr_native_av_functions_h.sv"    -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/altera_xcvr_native_av.sv"                -work u_tx_phy              
vlog -sv "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/altera_xcvr_native_cv/mentor/altera_xcvr_data_adapter_av.sv"          -work u_tx_phy              
vlog     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/sdi_ii_phy_adapter/sdi_ii_phy_adapter.v"                              -work u_tx_phy_adapter      
vcom     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/sdi_ii/sdi_ii_0001.vhd"                                               -work sdi_ip_ii_tx       
vcom     "G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_ii_tx/sdi_ip_ii_tx_sim/sdi_ip_ii_tx.vhd"                                                                              

vcom -2008 -work work {G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_loop.vhd}

vcom -2008 -work work {G:/sdi_ip_loop/sdi_ip_loop/sdi_ip_loop_tb.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cyclonev -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -L rx_rst_coreclk_sync -L u_rx_phy_mgmt -L u_rx_protocol -L u_rx_phy_rst_ctrl -L u_rx_phy -L u_tx_phy -L u_rx_phy_adapter -L u_tx_phy_adapter -L sdi_ip_ii_rx -L tx_rst_coreclk_sync -L u_tx_phy_mgmt -L u_tx_protocol -L u_tx_phy_rst_ctrl -L sdi_ip_ii_tx -voptargs="+acc"  sdi_ip_loop_tb

add wave *
view structure
view signals
run 100 us
