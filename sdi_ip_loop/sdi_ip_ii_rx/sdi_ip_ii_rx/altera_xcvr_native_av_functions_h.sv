// (C) 2001-2015 Altera Corporation. All rights reserved.
// Your use of Altera Corporation's design tools, logic functions and other 
// software and tools, and its AMPP partner logic functions, and any output 
// files any of the foregoing (including device programming or simulation 
// files), and any associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License Subscription 
// Agreement, Altera MegaCore Function License Agreement, or other applicable 
// license agreement, including, without limitation, that your use is for the 
// sole purpose of programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the applicable 
// agreement for further details.


//
// Common functions for Stratix V Native PHY IP
//

import altera_xcvr_functions::*;

  
package altera_xcvr_native_av_functions_h;

    localparam integer MAX_CHAR = 32;
    localparam integer MAX_STR = 16;

    //-----------------------------
    // General purpose functions
    //-----------------------------
    function [MAX_CHAR*8-1:0] set_lp_true_false (
        input integer enable
    );
       set_lp_true_false =  (enable == 1) ? "true" : "false";
    endfunction

    function [MAX_CHAR*8-1:0] set_lp_enable_cond (
        input integer enable,
        input [8*MAX_CHAR:1] enable_string,
        input [8*MAX_CHAR:1] diable_string
    );
       set_lp_enable_cond =  (enable == 1) ? enable_string : diable_string;
    endfunction

    function [MAX_CHAR*8-1:0] set_lp_enable_2lvl (
        input integer cond_1,
        input integer cond_2
    );
       set_lp_enable_2lvl =  cond_1 ? (cond_2 ? "true" : "false") : "false";
    endfunction

    //-----------------------------
    // Misc. Parameters
    //-----------------------------
    function integer set_rx_enable (
        input [8*MAX_CHAR:1] mode
    );
      set_rx_enable = (mode == "Rx" || 
                       mode == "RX" ||
                       mode == "Duplex" || 
                       mode == "DUPLEX") ? 1 : 0;
    endfunction

    function integer set_tx_enable (
        input [8*MAX_CHAR:1] mode
    );
      set_tx_enable = (mode == "Tx" || 
                       mode == "TX" ||
                       mode == "Duplex" || 
                       mode == "DUPLEX") ? 1 : 0;
    endfunction


    //-----------------------------
    // PMA direct paramaters
    //-----------------------------

    function [MAX_CHAR*8-1:0] set_ppm_thresh (
        input [8*MAX_CHAR:1] user_ppm
    );
      set_ppm_thresh = (user_ppm == "1000") ? "ppmsel_1000" : 
                       (user_ppm == "500")  ? "ppmsel_500"  :
                       (user_ppm == "300")  ? "ppmsel_300"  :
                       (user_ppm == "250")  ? "ppmsel_250"  :                  
                       (user_ppm == "200")  ? "ppmsel_200"  :
                       (user_ppm == "125")  ? "ppmsel_125"  :
                       (user_ppm == "100")  ? "ppmsel_100"  :
                       (user_ppm == "62")   ? "ppmsel_62P5" : "ppmsel_default";
    endfunction

    function [MAX_CHAR*8-1:0] set_pma_clkslip (
        input [8*MAX_CHAR:1] prot_mode,
        input [8*MAX_CHAR:1] mode
    );
      set_pma_clkslip = (prot_mode == "cpri") ? (mode == "pma_direct")? "pld" : "slip_eight_g_pcs" 
                                                                              : "pld";
    endfunction


    //-----------------------------
    // Standard PCS parameter mapping
    //-----------------------------
    
    function [MAX_CHAR*8-1:0] set_std_prot_mode (
        input [8*MAX_CHAR:1] protocol_hint
    );
      set_std_prot_mode =   (protocol_hint == "basic")     ? "basic"    : 
                            (protocol_hint == "cpri")      ? "cpri"     :
                            (protocol_hint == "gige")      ? "gige"     :
                            (protocol_hint == "srio_2p1")  ? "srio_2p1" : "basic";
    endfunction

    function [MAX_CHAR*8-1:0] set_std_pcs_pma_dw (
        input integer width
    );
      set_std_pcs_pma_dw = (width == 8)  ? "eight_bit" :
                           (width == 10) ? "ten_bit" :
                           (width == 16) ? "sixteen_bit" :
                           (width == 20) ? "twenty_bit" : "invalid";
    endfunction

    function [MAX_CHAR*8-1:0] set_rx_byte_order_mode (
        input integer enable,
        input [8*MAX_CHAR:1] mode,
        input integer width
    );
       set_rx_byte_order_mode = (enable == 0) ? "dis_bo"
                         : (mode == "manual" && width == 8)  ? "en_pld_ctrl_eight_bit_bo"
                         : (mode == "manual" && width == 9)  ? "en_pld_ctrl_nine_bit_bo"
                         : (mode == "manual" && width == 10) ? "en_pld_ctrl_ten_bit_bo"
                         : (mode == "auto"   && width == 8)  ? "en_pcs_ctrl_eight_bit_bo"
                         : (mode == "auto"   && width == 9)  ? "en_pcs_ctrl_nine_bit_bo"
                         : (mode == "auto"   && width == 10) ? "en_pcs_ctrl_ten_bit_bo"
                         : "dis_bo";
    endfunction
    
    function [MAX_CHAR*8-1:0] set_std_runlength (
        input integer width
    );
        set_std_runlength = (width == 8 || width == 10) ? "en_runlength_sw" : "en_runlength_dw";
    endfunction 
    
    function [MAX_CHAR*8-1:0] set_std_rx_dw_1or2_syn_bo (
        input integer enable,
        input integer width, 
        input integer bo_width,
        input integer bo_symbol_count,
        input integer en_8b10b
    );
    
        set_std_rx_dw_1or2_syn_bo  = (enable == 1 && width == 16)                   ? bo_symbol_count == 1 ? "one_symbol_bo" : "two_symbol_bo_eight_bit"
                                            : (enable == 1 && width == 20 && bo_width == 9)  ? bo_symbol_count == 1 ? "one_symbol_bo" : "two_symbol_bo_nine_bit"
                                            : (enable == 1 && width == 20 && bo_width == 10) ? bo_symbol_count == 1 ? "one_symbol_bo" : "two_symbol_bo_ten_bit"
                                            : "donot_care_one_two_bo";
    endfunction
    
    function [MAX_CHAR*8-1:0] set_std_rmfifo_mode (
        input integer enable,
        input [8*MAX_CHAR:1] prot, 
        input integer width
    );
        set_std_rmfifo_mode = (enable == 1) ? ((prot == "gige") ? "gige_rm" :
                                              (prot == "srio_2p1")? "srio_v2p1_rm_0ppm" :
                                              (width == 20 || width == 16) ? "dw_basic_rm" : "sw_basic_rm") : "dis_rm";
    endfunction
    
    function [MAX_CHAR*8-1:0] set_wa_pat_len (
    input [8*MAX_CHAR:1]    mode,
    input integer 	    length,
    input integer 	    width,
    input [8*MAX_CHAR:1]    prot
	);
      set_wa_pat_len = (mode == "bit_slip") ? "<auto_single>" :
      		                                  (prot == "gige" || prot == "xaui" || prot == "srio_2p1") ? 
      		                                  ((length == 7) ? "wa_pd_fixed_7_k28p5" : 
      		                                  (length == 10) ? "wa_pd_fixed_10_k28p5" : "wa_pd_fixed_7_k28p5") : 
      		                                  (prot == "basic") ? 
      		                                  ((length == 7)   ? "wa_pd_7" : 
      		                                  (length == 8)   ? ((width == 8) ? "wa_pd_8_sw" : "wa_pd_8_dw") : 
      		                                  (length == 10)  ? "wa_pd_10" : 
      		                                  (length == 16)  ? ((width == 8) ? "wa_pd_16_sw" : "wa_pd_16_dw") : 
      		                                  (length == 20)  ? "wa_pd_20" : 
      		                                  (length == 32)  ? "wa_pd_32" : 
      		                                  (length == 40)  ? "wa_pd_40" : "wa_pd_7") : "wa_pd_fixed_10_k28p5";
    endfunction
    
    function [MAX_CHAR*8-1:0] set_wa_pld_ctrl (
        input [8*MAX_CHAR:1] mode,
        input integer width
    );
      set_wa_pld_ctrl =   (mode == "sync_sm" || mode == "deterministic_latency")     ? "dis_pld_ctrl"    : 
                          (width == 8 || width == 10)                                ? "pld_ctrl_sw"     :
                                                                                       "rising_edge_sensitive_dw";
                          
    endfunction
    
    function [MAX_CHAR*8-1:0] set_wa_cpri_auto (
        input [8*MAX_CHAR:1] prot
    );
      set_wa_cpri_auto =   (prot == "cpri") ? "<auto_any>" : "<auto_single>";
    endfunction
    
    function set_in_pld_sync_sm_en (
        input [8*MAX_CHAR:1] word_aligner_mode
    );
      set_in_pld_sync_sm_en =   (word_aligner_mode == "sync_sm") ? 1'b1 : 1'b0;
    endfunction
    
    function [MAX_CHAR*8-1:0] set_cpri_rx_clk_sel (
        input [8*MAX_CHAR:1] prot
    );
      //set_cpri_rx_clk_sel =   (prot == "cpri") ? "rx_clk" : "pld_rx_clk";
      set_cpri_rx_clk_sel =   (prot == "cpri") ? "rx_clk" : "pld_rx_clk";
    endfunction
    
    function [MAX_CHAR*8-1:0] set_std_rx_clk1_sel (
        input [8*MAX_CHAR:1] prot
    );
      set_std_rx_clk1_sel =   (prot == "srio_2p1") ? "<auto_any>" : "rcvd_clk_clk1";
    endfunction
    
    function [MAX_CHAR*8-1:0] set_std_wa_boundary_lock_ctrl (
        input [8*MAX_CHAR:1] prot, 
        input [8*MAX_CHAR:1] rx_word_aligner_mode
    );
        set_std_wa_boundary_lock_ctrl = (prot == "cpri" && rx_word_aligner_mode == "sync_sm") ? "deterministic_latency" 
                                        : (rx_word_aligner_mode == "manual") ? "auto_align_pld_ctrl" 
                                        : (rx_word_aligner_mode == "sync_sm") ? "sync_sm"
                                        : "bit_slip";
        
    endfunction
    
    function [MAX_CHAR*8-1:0] set_std_wa_ctrl (
        input [8*MAX_CHAR:1] ctrl
    );
      set_std_wa_ctrl =   (ctrl == "gige")     ? "gige_sync_sm"     : 
                          (ctrl == "srio_2p1") ? "srio2p1_sync_sm"  :
                          (ctrl == "basic_dw") ? "dw_basic_sync_sm" :  
                          (ctrl == "basic_sw") ? "sw_basic_sync_sm" :
                                                 "gige_sync_sm";
    endfunction
    
    function [MAX_CHAR*8-1:0] set_std_symbol_swap (
        input [8*MAX_CHAR:1] prot,
        input integer width
    );
      set_std_symbol_swap =   ((prot == "basic") && (width == 16 || width == 20)) ? "en_symbol_swap" : "dis_symbol_swap";
      
    endfunction
    

   ////////////////////////////////////////////////////////////////////
      // Get number of reconfig interfaces for native PHY
  //
  // @param device_family - Desired device family
  // @param operation_mode - "Duplex","Rx","Tx" or "duplex", "rx_only", "tx_only" in 10gbaser
  // @param lanes - Number of channels
  // @param plls - Number of TX plls (per channel)
  // @param data_path_type - Abuse of function by overloading for ATT support
  //                       - Carry on the abuse
  //
  // @return 0 if the device_family argument is invalid, otherwise
  //          it returns the width of the reconfig_from_xcvr port for that family
  function integer get_native_reconfig_interfaces(
    input [MAX_CHAR*8-1:0] device_family,
    //input [MAX_CHAR*8-1:0] operation_mode,
    input integer           rx_en,
    input integer           tx_en,
    input integer           lanes,
    input integer           plls,
    input [MAX_CHAR*8-1:0] data_path_type = "",
    input [MAX_CHAR*8-1:0] bonded_mode = "xN"
  );
     integer 		    reconfig_interfaces;
     integer 		    bonded_group_size;
     
     
     reconfig_interfaces = 0;
     if (altera_xcvr_functions::has_s5_style_hssi(device_family) || altera_xcvr_functions::has_a5_style_hssi(device_family) || altera_xcvr_functions::has_c5_style_hssi(device_family))
       begin
          // Custom PHY calculations
          if(rx_en == 1 && tx_en == 0)
            reconfig_interfaces = lanes;
          else 
	    begin
               bonded_group_size = (bonded_mode == "fb_compensation") ? 1 : 
				   (bonded_mode == "non_bonded") ? 1 :
				   (bonded_mode == "xN") ? lanes : 1;				  
               reconfig_interfaces = lanes+(plls*(lanes/bonded_group_size));
            end
       end // if (has_s5_style_hssi(device_family) || has_a5_style_hssi(device_family) || has_c5_style_hssi(device_family))
     get_native_reconfig_interfaces = reconfig_interfaces;
  endfunction // get_native_reconfig_interfaces
   
   
   ////////////////////////////////////////////////////////////////////
   // Get reconfig_to_xcvr total port width for Native PHY
   //
   // @param device_family - Desired device family
   // @param operation_mode - "Duplex","Rx","Tx" or "duplex", "rx_only", "tx_only" in 10gbaser
   // @param lanes - Number of transceiver channels
   // @param plls - Number of plls per bonded group
   // @param data_path_type - Abuse of function to support ATT
   //
   // @return - 0 if the device_family argument is invalid, otherwise
   // it returns the width of the reconfig_from_xcvr port for that family
   function integer get_native_reconfig_to_width(
    input [MAX_CHAR*8-1:0] device_family,
    //input [MAX_CHAR*8-1:0] operation_mode,
    input integer           rx_en,
    input integer           tx_en,
    input integer           lanes,
    input integer           plls,
    input [MAX_CHAR*8-1:0] data_path_type = "",
    input [MAX_CHAR*8-1:0] bonded_mode = "xN"
						 );
      integer 		    reconfig_interfaces;
      reconfig_interfaces = get_native_reconfig_interfaces(device_family,rx_en,tx_en,lanes,plls,data_path_type, bonded_mode );
      get_native_reconfig_to_width = altera_xcvr_functions::get_s5_reconfig_to_width(reconfig_interfaces);
   endfunction // get_native_reconfig_to_width
   
   
   ////////////////////////////////////////////////////////////////////
   // Get reconfig_from_xcvr total port width for Native PHY
   //
   // @param device_family - Desired device family
   // @param operation_mode - "Duplex","Rx","Tx" or "duplex", "rx_only", "tx_only" in 10gbaser
   // @param lanes - Number of transceiver channels
   // @param plls - Number of plls per bonded group
   // @param data_path_type - Abuse of function to support ATT
   //
   // @return - 0 if the device_family argument is invalid, otherwise
   // it returns the width of the reconfig_from_xcvr port for that family
   function integer get_native_reconfig_from_width(
    input [MAX_CHAR*8-1:0] device_family,
    //input [MAX_CHAR*8-1:0] operation_mode,
    input integer           rx_en,
    input integer           tx_en,
    input integer           lanes,
    input integer           plls,
    input [MAX_CHAR*8-1:0] data_path_type = "",
    input [MAX_CHAR*8-1:0] bonded_mode = "xN"
						   );
      integer 		    reconfig_interfaces;
      reconfig_interfaces = get_native_reconfig_interfaces(device_family,rx_en,tx_en,lanes,plls,data_path_type, bonded_mode);
      get_native_reconfig_from_width = altera_xcvr_functions::get_s5_reconfig_from_width(reconfig_interfaces);
   endfunction // get_native_reconfig_from_width
   
    function [MAX_CHAR*8-1:0] set_ser_word (
        input integer pld_interface_width,
        input integer ser_base_word
    );
       set_ser_word =  (pld_interface_width/ser_base_word);
    endfunction
   
    function [MAX_CHAR*8-1:0] set_base_word (
        input integer pld_interface_width
    );
       set_base_word =  ((pld_interface_width % 10) == 0) ? 10 : 8;
    endfunction

endpackage
