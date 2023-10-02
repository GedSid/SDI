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


`timescale 1 ps/1 ps

import altera_xcvr_functions::*;
import altera_xcvr_native_av_functions_h::*;

module altera_xcvr_native_av 
  #(
    //---------------------
    // Common parameters
    //---------------------
    parameter data_path_select = "pma_direct",      // legal values "6G" "pma_direct"
    parameter std_protocol_hint = "basic",              // basic|cpri|gige|srio_2p1|interlaken|teng_baser|teng_sdi     
    parameter rx_enable = 1,                        // 0,1  
    parameter tx_enable = 1,                        // 0,1
    parameter channels = 1,                         // legal values 1+
    parameter pma_width = 80,                       // 6G - 8|10|16|20|32|40, PMA_DIR-8|10|16|20|32|40|64|80
    parameter data_rate = "10000 Mbps",                  // user entered data rate always in mbps
    parameter pll_data_rate = "0",                  // (PLL Rate) - must be (data_rate * 1,2,4,or8) in mbps    
    parameter tx_pma_clk_div  = 1,                  // (1,2,4,8) CGB clock divider value

    // PLL specific parameters
	parameter pll_external_enable = 0,              // (0,1) 0-Disable external TX PLL, 1-Enable external TX PLL
    parameter pll_type = "AUTO",                    // PLL type for each PLL    
    parameter plls = 1,                             // no of plls, 1+   
    parameter pll_select = 0,                       // Selects the initial PLL
    parameter pll_refclk_freq = "125 MHz",          // PLL rerefence clock frequency, this will go to TX PLL and CDR PLL
    parameter pll_refclk_cnt = 1,                   // Number of reference clocks (per PLL)
    parameter pll_refclk_select = "0",              // Selects the initial reference clock for each TX PLL
    parameter pll_reconfig_enable = 0,              // (0,1) 0-Disable PLL reconfig, 1-Enable PLL reconfig
    parameter pll_feedback_path = "internal",       //internal, external
    parameter bonded_mode = "non_bonded",           // (non_bonded, xN)
    parameter pma_bonding_mode  = "x1",             // (x1, xN)
    
    // CDR specific parameters
    parameter cdr_reconfig_enable = 0,              // (0,1) 0-Disable CDR reconfig, 1-Enable CDR reconfig
    parameter cdr_refclk_cnt = 1,                   // Number of RX CDR reference clocks
    parameter cdr_refclk_select = 0,                // Selects the initial reference clock for all RX CDR PLLs
    parameter cdr_refclk_freq = "125 MHz",          // RX CDR reference clock frequency, this will go to TX PLL and CDR PLL

    //-------------------------------
    // PMA Direct specific parameters
    //-------------------------------
    parameter rx_clkslip_enable = 0,                // enables clkslip feature of the deserailizer
    parameter rx_signaldetect_threshold = 16,       //(0,1,2...16) Signal Detect Threshold. 0->DATA_PULSE_4, 1->DATA_PULSE_6,....,16->FORCE_SD_ON    
    parameter rx_ppm_detect_threshold = "1000",     //62,100,125,200,250,300,500,1000
    parameter ppm_lock_detector = "none",            // "hard", "manual", "none"
 
    //-----------------------------
    // Standard (6G) PCS parameters
    //-----------------------------
    //Common PCS parameters
    parameter enable_std                           = 0,        // legal values 0, 1
    parameter std_pcs_pma_width                    = 20,       // 6G - 8|10|16|20, PMA_DIR - N/A

    //8B/10B
    parameter std_tx_8b10b_enable                  = 0,        // 0,1 
    parameter std_rx_8b10b_enable              	   = 0,        // 0,1
    parameter std_tx_8b10b_disp_ctrl_enable        = 0,        // 0,1

    //Word aligner / Bit slip / Run Length
    parameter std_rx_word_aligner_mode             = "bit_slip", //bitslip|sync state machine|manual|deterministic_latency
    parameter std_rx_word_aligner_pattern_len      = 7,          //7,8,10,16,20,32
    parameter std_rx_word_aligner_pattern          = "0000000000",
    parameter std_rx_word_aligner_rknumber         = 3,          //0-256
    parameter std_rx_word_aligner_renumber         = 3,          //0-256
    parameter std_rx_word_aligner_rgnumber         = 3,          //0-256
    
    parameter std_tx_bitslip_enable                = 0,          // 0,1
    
    parameter std_rx_run_length_val                = 0,   
    
    // Low latency bypass
    parameter std_low_latency_bypass_enable        = 0,          // 0,1
           
    //Rate match FIFO
    parameter std_rx_rmfifo_enable                 = 0,          // 0,1
    parameter std_rx_rmfifo_pattern_p              = "000000000000000000000", 
    parameter std_rx_rmfifo_pattern_n              = "000000000000000000000",

//  parameter std_coreclk_0ppm_enable              = 1,          // 0,1

    // Phase Compensation FIFO
    parameter std_tx_pcfifo_mode                   = "low_latency",   //low_latency|register_fifo|normal_latency
    parameter std_rx_pcfifo_mode                   = "low_latency",   //low_latency|register_fifo|normal_latency

    // Byte Ordering
    parameter std_rx_byte_order_enable             = 0,
    parameter std_rx_byte_order_mode               = "manual", // auto|manual
    parameter std_rx_byte_order_width              = 0,        // 8|9|10
    parameter std_rx_byte_order_symbol_count       = 1,        // 1|2
    parameter std_rx_byte_order_pattern            = "0",      // Byte order search pattern (hex string)
    parameter std_rx_byte_order_pad                = "0",      // Byte order pad pattern (hex string)

    // Byte serializer
    parameter std_tx_byte_ser_enable               = 0, 
    parameter std_rx_byte_deser_enable             = 0, 

    // Bit reversal/Polarity inversion
    parameter std_tx_bitrev_enable              = 0,
    parameter std_rx_bitrev_enable              = 0,
    parameter std_tx_byterev_enable             = 0,
    parameter std_rx_byterev_enable             = 0,
    parameter std_tx_polinv_enable              = 0,
    parameter std_rx_polinv_enable              = 0

    ) ( 
    //------------------------
    // Common Ports
    //------------------------
    // Resets - PLL, RX and TX
    input wire [channels-1:0]          tx_analogreset, // for tx pma
    input wire [((bonded_mode == "xN") ? 1 : channels)*plls-1:0] pll_powerdown, 
    input wire [channels-1:0]          tx_digitalreset, // for TX PCS
    input wire [channels-1:0]          rx_analogreset, // for rx pma
    input wire [channels-1:0]          rx_digitalreset, //for rx pcs

    // Reconfig interface ports
    input   wire [get_native_reconfig_to_width  ("Arria V",rx_enable,tx_enable,channels,((pll_external_enable == 1)? 0 : plls),"",bonded_mode)-1:0] reconfig_to_xcvr,
    output  wire [get_native_reconfig_from_width("Arria V",rx_enable,tx_enable,channels,((pll_external_enable == 1)? 0 : plls),"",bonded_mode)-1:0] reconfig_from_xcvr, 
  
    output wire [channels-1:0]         tx_cal_busy,  
    output wire [channels-1:0]         rx_cal_busy,
    
    //clk signals
    input wire [pll_refclk_cnt - 1 : 0] tx_pll_refclk,
    input wire [cdr_refclk_cnt - 1 : 0] rx_cdr_refclk,
	input wire [(plls*channels)- 1 : 0] ext_pll_clk,      // clkout from external PLL

    // TX and RX serial ports
    input  wire [channels-1:0]         rx_serial_data,
    output wire [channels-1:0]         tx_serial_data,

    // control ports
    input  wire [channels-1:0]         rx_seriallpbken,
    input  wire [channels-1:0]         rx_set_locktodata,
    input  wire [channels-1:0]         rx_set_locktoref,

    //status
    output wire [channels-1:0]         rx_is_lockedtoref,
    output wire [channels-1:0]         rx_is_lockedtodata,
    output wire [channels-1:0]         rx_signaldetect,    // RX PMA signal detect
    output wire [((bonded_mode == "xN") ? 1 : channels)*plls-1:0] pll_locked,

    //PMA parallel data ports
    input  wire [(80 * channels) -1:0] tx_pma_parallel_data,
    output wire [(80 * channels) -1:0] rx_pma_parallel_data,
  
    //---------------------
    // PMA specific ports
    //---------------------
    output wire [channels-1:0]         tx_pma_clkout,   // TX Parallel clock output from PMA
    output wire [channels-1:0]         rx_pma_clkout,   // RX Parallel clock output from PMA

    input  wire [channels-1:0]         rx_clkslip,
    
    //PPM detector clocks
    output wire [channels-1:0]         rx_clklow,    // RX Low freq recovered clock, PPM detecror specific
    output wire [channels-1:0]         rx_fref,       // RX PFD reference clock, PPM detecror specific

    //-------------------------
    // Standard PCS ports
    //------------------------- 
    // Data ports
    input  wire [(44 * channels) -1:0] tx_parallel_data,
    output wire [(64 * channels) -1:0] rx_parallel_data,
    
    //electrical idle
    input  wire  [channels-1:0]        tx_std_elecidle,
    
	// clock ports
	input wire  [channels-1:0] 		tx_std_coreclkin,   // 10G PCS PLD Tx parallel clock input
    input wire  [channels-1:0] 		rx_std_coreclkin,   // 10G PCS PLD Tx parallel clock input
    output wire [channels-1:0] 		tx_std_clkout,      // TX Parallel clock output
    output wire [channels-1:0] 		rx_std_clkout,      // RX parallel clock output

    //Phase compensation FIFOs
    output wire [channels-1:0] 		tx_std_pcfifo_full,  //Phase comp. FIFO full   
    output wire [channels-1:0] 		tx_std_pcfifo_empty, //Phase comp. FIFO empty
    output wire [channels-1:0] 		rx_std_pcfifo_full,  //Phase comp. FIFO full
    output wire [channels-1:0] 		rx_std_pcfifo_empty, //Phase comp. FIFO empty

    // Byte Ordering
    input wire  [channels-1:0] 		rx_std_byteorder_ena,    
    output wire [channels-1:0] 		rx_std_byteorder_flag,

    // Bit reversal
    input wire  [channels-1:0] 		rx_std_bitrev_ena,

    // Byte (de)serializer 
    input wire  [channels-1:0] 		rx_std_byterev_ena,

    // Polarity inversion
    input wire  [channels-1:0] 		tx_std_polinv,
    input wire  [channels-1:0] 		rx_std_polinv,

    // Bit slip
    input  wire  [channels*5-1:0] 		tx_std_bitslipboundarysel,
    output wire  [channels*5-1:0] 		rx_std_bitslipboundarysel,
    input  wire  [channels-1:0] 		rx_std_bitslip,

    //Word align/Deterministic SM
    input   wire  [channels-1:0] 	     rx_std_wa_patternalign,
    input   wire  [channels-1:0] 	     rx_std_wa_a1a2size,

    //Rate Match FIFO
    output wire [channels-1:0] 		rx_std_rmfifo_full,  //Rate Match FIFO full
    output wire [channels-1:0] 		rx_std_rmfifo_empty, //Rate Match FIFO empty

    // Run length detector
    output  wire  [channels-1:0] 		 rx_std_runlength_err,    

    // PRBS
    //input  wire  [channels-1:0] 		rx_std_prbs_cid_en,

    //signal detect
    output wire [channels-1:0] 		rx_std_signaldetect,
    
    //PRBS Signals for the PCS
    output  wire  [channels-1:0]      rx_std_prbs_err,
    output  wire  [channels-1:0]      rx_std_prbs_done
   
    );


   // Define all local parameters for internal use
   
   // bonding size for bonded channel instantiations
   localparam bonded_group_size = (bonded_mode == "non_bonded") ? 1 : channels;
   
   // Reconfig parameters
   localparam w_bundle_to_xcvr     = W_A5_RECONFIG_BUNDLE_TO_XCVR;
   localparam w_bundle_from_xcvr   = W_A5_RECONFIG_BUNDLE_FROM_XCVR;
   localparam reconfig_interfaces  = altera_xcvr_native_av_functions_h::get_native_reconfig_interfaces("Arria V",rx_enable,tx_enable,channels,(pll_external_enable ? 0 : plls),"",bonded_mode);
   
   localparam int_enable_8g_rx = set_lp_enable_2lvl(rx_enable,enable_std);
   localparam int_enable_8g_tx = set_lp_enable_2lvl(tx_enable,enable_std);

   // Default base data rate to data rate if not specified
   localparam [MAX_STRS*MAX_CHARS*8-1:0] int_base_data_rate = (get_value_at_index(0,pll_data_rate) == "0 Mbps") ? data_rate : pll_data_rate;   
   localparam int_tx_clk_div = str2hz(get_value_at_index(pll_select, int_base_data_rate)) / str2hz(data_rate);   

   //-----------------------------
   // PMA direct paramaters
   //-----------------------------
   localparam enable_pmadirect                       = (data_path_select == "pma_direct") ? 1 : 0;
   localparam tx_pld_data_max_width                  = (enable_pmadirect) ? 80 : 44;
   localparam rx_pld_data_max_width                  = (enable_pmadirect) ? 80 : 64;
   localparam lp_ppm_thresh                          = set_ppm_thresh(rx_ppm_detect_threshold); 
   localparam int_rx_clkslip_enable                  = set_lp_true_false(rx_clkslip_enable);
   localparam int_rx_clkslip_select                  = set_pma_clkslip(std_protocol_hint,data_path_select); //legal value: pld|slip_eight_g_pcs
   localparam lp_enable_pma_direct_tx                = set_lp_enable_2lvl(tx_enable,enable_pmadirect); 
   localparam lp_enable_pma_direct_rx                = set_lp_enable_2lvl(rx_enable,enable_pmadirect);

   //-----------------------------
   // Standard PCS parameter mapping
   //-----------------------------
   //protocol mode, data width
   localparam lp_std_prot_mode         = set_std_prot_mode(std_protocol_hint);
   localparam lp_std_pcs_pma_dw        = set_std_pcs_pma_dw(std_pcs_pma_width); 
   
   //8B10B 
   localparam lp_std_tx_8b10b_enc      = set_lp_enable_cond(std_tx_8b10b_enable,"en_8b10b_ibm","dis_8b10b");
   localparam lp_std_rx_8b10b_dec      = set_lp_enable_cond(std_rx_8b10b_enable,"en_8b10b_ibm","dis_8b10b");
   localparam lp_std_tx_8b10b_disp_ctrl   = set_lp_enable_cond(std_tx_8b10b_disp_ctrl_enable,"en_disp_ctrl","dis_disp_ctrl"); 
   
   //Phase Comp FIFO
   localparam lp_std_rx_pcfifo_mode    = std_rx_pcfifo_mode; 
   localparam lp_std_tx_pcfifo_mode    = std_tx_pcfifo_mode;
   
   //Bit reversal & Polarity inversion
   localparam lp_std_tx_bitrev         = set_lp_enable_cond(std_tx_bitrev_enable,"en_bit_reversal","dis_bit_reversal"); 
   localparam lp_std_rx_bitrev         = set_lp_enable_cond(std_rx_bitrev_enable,"en_bit_reversal","dis_bit_reversal");
   localparam lp_std_tx_polinv         = set_lp_enable_cond(std_tx_polinv_enable,"enable_polinv","dis_polinv");
   localparam lp_std_rx_polinv         = set_lp_enable_cond(std_rx_polinv_enable,"en_pol_inv","dis_pol_inv");
   
   //Word aligner and bitslip
   localparam lp_std_tx_bitslip                      = set_lp_enable_cond(std_tx_bitslip_enable,"en_tx_bitslip","dis_tx_bitslip");
   localparam lp_std_wa_boundary_lock_ctrl           = set_std_wa_boundary_lock_ctrl(std_protocol_hint,std_rx_word_aligner_mode);
   localparam lp_std_rx_wa_clk_slip_spacing          = set_wa_cpri_auto(std_protocol_hint);
   localparam lp_std_rx_wa_det_latency_sync_status_beh = set_wa_cpri_auto(std_protocol_hint);
   localparam lp_std_rx_wa_disp_err_flag             = set_lp_enable_cond(std_rx_8b10b_enable,"en_disp_err_flag","dis_disp_err_flag");
   localparam lp_std_rx_wa_pd_data                   = m_hex_to_bin(std_rx_word_aligner_pattern);
   localparam lp_std_rx_wa_pd                        = set_wa_pat_len(std_rx_word_aligner_mode,std_rx_word_aligner_pattern_len,std_pcs_pma_width,std_protocol_hint);
   localparam lp_std_rx_wa_pld_controlled            = set_wa_pld_ctrl(std_rx_word_aligner_mode,std_pcs_pma_width);
   localparam [6:0] lp_std_rx_wa_renumber_data       = std_rx_word_aligner_renumber[6:0];     //number of error patterns to loose lock
   localparam [7:0] lp_std_rx_wa_rgnumber_data       = std_rx_word_aligner_rgnumber[7:0];     //number of good patterns needed to be upgraded back to sync aquired
   localparam [7:0] lp_std_rx_wa_rknumber_data       = std_rx_word_aligner_rknumber[7:0];     //number of pattern to aquire sync
   localparam lp_std_in_pld_sync_sm_en               = set_in_pld_sync_sm_en(std_rx_word_aligner_mode);

   //Byte serializer/de-serializer
   localparam lp_std_byte_serializer                 = set_lp_enable_cond(std_tx_byte_ser_enable,"en_bs_by_2","dis_bs");
   localparam lp_std_byte_deserializer               = set_lp_enable_cond(std_rx_byte_deser_enable,"en_bds_by_2","dis_bds"); 
   
   //Byte ordering
   localparam lp_std_rx_byte_order                   = set_rx_byte_order_mode(std_rx_byte_order_enable,std_rx_byte_order_mode,std_rx_byte_order_width);
   localparam lp_std_rx_bo_pattern                   = m_hex_to_bin(std_rx_byte_order_pattern);
   localparam lp_std_rx_bo_pad_pattern               = m_hex_to_bin(std_rx_byte_order_pad);
   localparam lp_std_rx_dw_one_or_two_symbol_bo      = set_std_rx_dw_1or2_syn_bo(std_rx_byte_order_enable,std_pcs_pma_width,std_rx_byte_order_width,std_rx_byte_order_symbol_count,std_rx_8b10b_enable); 
   localparam lp_std_rx_symbol_swap                  = set_lp_enable_cond(std_rx_byterev_enable,"en_symbol_swap","dis_symbol_swap");
   localparam lp_std_tx_symbol_swap                  = set_lp_enable_cond(std_tx_byterev_enable,"en_symbol_swap","dis_symbol_swap");
   
   //Rate match FIFO
   localparam lp_std_rx_rate_match                   = set_std_rmfifo_mode(std_rx_rmfifo_enable,std_protocol_hint,std_pcs_pma_width);
   localparam lp_std_rx_clkcmp_pattern_n             = m_hex_to_bin(std_rx_rmfifo_pattern_n);
   localparam lp_std_rx_clkcmp_pattern_p             = m_hex_to_bin(std_rx_rmfifo_pattern_p);
   
   //Run length detector
   localparam lp_std_rx_runlength_check              = set_std_runlength(std_pcs_pma_width);
   localparam lp_std_rx_runlength_val                = std_rx_run_length_val;
   
   //Rx clocking
   //localparam lp_std_rx_rx_rd_clk                    = set_cpri_rx_clk_sel(std_protocol_hint);
   //localparam lp_std_rx_rx_clk1                      = set_std_rx_clk1_sel(std_protocol_hint);
   //localparam lp_std_rx_rx_clk2                      = set_lp_enable_cond(std_rx_rmfifo_enable,"tx_pma_clock_clk2","rcvd_clk_clk2");
   
   //Number of PLL reconfig interface
   localparam plls_if                                = (pll_external_enable == 1)? 0 : plls;
    
   // Common PCS-PMA interface parameter as this interface expects protocol mode as cpri_8g instead of cpri
   localparam   lp_rx_pcs_pma_if_prot_mode           = (lp_std_prot_mode == "cpri") ? "cpri_8g": "other_protocols";
   
   //The Sync SM enable control port needs to be enabled when user's select
   //sync SM mode for ther word aligner
   wire rx_std_sync_sm_en =  1'b1; //This signal is used in PIPE mode to force the sync SM to the LOSS_OF_LOCK state. 
    
   //wires for TX
   //PLD-PCS wires
   wire [(plls*channels) -1 : 0] pll_out_clk;
   
   
   
   //wire for master CGB
   wire                 cpulse_master;
   wire                 hclk_master;
   wire                 lfclk_master;
   wire  [2 : 0]        pclk_master;

   wire  [channels*plls-1:0] cgb_master_rstn;
   
//   wire [plls  - 1 : 0] pll_locked_wire [channels-1:0];
//   wire [channels - 1 : 0] pll_locked_xpos [plls-1:0];
   
   // Declare local merged versions of reconfig buses 
   wire [(reconfig_interfaces*w_bundle_to_xcvr)  -1:0]  rcfg_to_xcvr;
   wire [(reconfig_interfaces*w_bundle_from_xcvr)-1:0]  rcfg_from_xcvr;

   genvar ig;  // Iterator for generated loops
   genvar jg;


   generate begin:gen_native_inst
  
      localparam num_bonded = bonded_group_size;
      
	  // Connect reset for xN non-bonded mode Master CGB
	  assign cgb_master_rstn = (num_bonded == 1)? pll_powerdown : {(plls*channels){1'b0}};
      
      for(ig=0; ig<channels; ig = ig + 1) begin: av_xcvr_native_insts     
       if((ig % bonded_group_size) == 0) 
       begin:gen_bonded_group_plls   
        if(tx_enable == 1) 
        begin:gen_tx_plls
           wire  [plls-1:0]  tx_fbclk;
           wire  pll_fb_clk;
           wire  [(plls*w_bundle_to_xcvr)-1:0]   pll_rcfg_to_xcvr;
           wire  [(plls*w_bundle_from_xcvr)-1:0] pll_rcfg_from_xcvr;
			 
           assign  tx_fbclk = (pll_feedback_path == "internal") ? pll_fb_clk : 
                              (enable_pmadirect) ? tx_pma_clkout[ig / bonded_group_size] : tx_std_clkout[ig / bonded_group_size];  
                              
           if(pll_external_enable) begin
            // Unused in external PLL mode (use pll_rcfg_from_xcvr for warning suppression)
            assign  pll_rcfg_to_xcvr  = {(plls*w_bundle_from_xcvr){&{1'b0,pll_rcfg_from_xcvr}}};
           end else begin
            // Connect rcfg_<to/from>_xcvr ports to PLL only when using internal PLL
            assign  pll_rcfg_to_xcvr  = rcfg_to_xcvr[(channels+(plls*ig))*w_bundle_to_xcvr+:plls*w_bundle_to_xcvr];
            assign  rcfg_from_xcvr[(channels+(plls*ig))*w_bundle_from_xcvr+:plls*w_bundle_from_xcvr] = pll_rcfg_from_xcvr;
           end
          
           av_xcvr_plls 
             #(
               .plls                     (plls                     ),
               .pll_type                 (pll_type                 ),
               .pll_reconfig             (pll_reconfig_enable      ),
               .pll_sel                  (pll_select               ),
               .refclks                  (pll_refclk_cnt           ),
               .reference_clock_frequency(pll_refclk_freq          ),
               .reference_clock_select   (pll_refclk_select        ),
               .output_clock_datarate    (int_base_data_rate       ),
               .feedback_clk             (pll_feedback_path        ),
	           .tx_clk_div               (tx_pma_clk_div           ),
	           .data_rate                (data_rate                ),
	           .mode                     (pma_width                ),
		       .pll_external_enable      (pll_external_enable      ),
	           .enable_master_cgb        ((num_bonded != 1)? 1 : 0 )
               ) tx_plls (
                  // When using external PLLS, the refclk port is repurposed to provide the external PLL clock inputs
                  .refclk     (pll_external_enable ? ext_pll_clk[ig*plls+:plls] : tx_pll_refclk ),
                  .rst        (pll_powerdown[ig*plls+:plls]   ),
                  .fbclk      ({plls{tx_fbclk}}               ),
                  .outclk     (pll_out_clk[ig*plls+:plls]     ),
                  .locked     (pll_locked[ig*plls+:plls]      ),
                  .fboutclk   (pll_fb_clk                     ),
                  
	              //ports for master CGB
	              .cpulse_master (cpulse_master               ),
	              .hclk_master   (hclk_master                 ),
	              .lfclk_master  (lfclk_master                ),
	              .pclk_master   (pclk_master                 ),
                  
                  // avalon MM native reconfiguration interfaces
                  .reconfig_to_xcvr   (pll_rcfg_to_xcvr      ),
                  .reconfig_from_xcvr (pll_rcfg_from_xcvr    )
                  );
        end // block: gen_tx_plls
        else 
        begin:gen_no_tx  // TX disabled
           assign pll_out_clk[ig*plls+:plls]   = {plls{1'b0}};
           assign pll_locked[ig*plls+:plls]   = {plls{1'b0}}; 	   
        end
       end // block: gen_bonded_group_plls
     else begin: gen_pll_fanout
        assign pll_out_clk[ig*plls+:plls] = pll_out_clk[0+:plls]; // fanout for pll_out_clk for xN bonding 
     end
     
     if ((ig % bonded_group_size) == 0) begin: gen_bonded_group_native
        // create native transceiver interface
        av_xcvr_native 
          #(
           // AV PMA Parameters
           .rx_enable                            (rx_enable                       ),
           .tx_enable                            (tx_enable                       ),
        
           // Bonding parameters
		   .pma_bonding_mode                     (pma_bonding_mode                ),
           .plls                                 (plls                            ),
           .pll_sel                              (pll_select                      ),
           .pma_prot_mode                        ((data_path_select == "pma_direct") ? "pma direct" : std_protocol_hint),
           .pma_data_rate                        (data_rate                       ),
		   .base_data_rate                       (pll_data_rate                   ),
		   .external_master_cgb                  ((num_bonded != 1)?  1:0         ),
        
           // RX PMA Parameters
           .cdr_reference_clock_frequency        (cdr_refclk_freq                 ),
           .cdr_refclk_sel                       (cdr_refclk_select               ),
           .cdr_refclk_cnt                       (cdr_refclk_cnt                  ), 
           .cdr_reconfig                         (cdr_reconfig_enable             ),
           .deser_enable_bit_slip                (int_rx_clkslip_enable           ),
           .tx_clk_div                           (tx_pma_clk_div                  ),
           .sd_on                                (rx_signaldetect_threshold       ),    
           .enable_pma_direct_tx                 (lp_enable_pma_direct_tx         ),
           .enable_pma_direct_rx                 (lp_enable_pma_direct_rx         ),   
                
           // Interface specific parameters  
           .pma_mode                             (pma_width                       ),
           .auto_negotiation                     ("false"                         ),
        
           // AV RX PCS Parameters
           .enable_8g_rx                         (int_enable_8g_rx                ),
           .enable_8g_tx                         (int_enable_8g_tx                ),
           .enable_dyn_reconfig                  ("false"                         ),
           .enable_gen12_pipe                    ("false"                         ),   
           .pcs8g_rx_auto_error_replacement      ("<auto_any>"                    ),     // dis_err_replace|en_err_replace
           .pcs8g_rx_bit_reversal                (lp_std_rx_bitrev                ),     // dis_bit_reversal|en_bit_reversal
           .pcs8g_rx_bo_pad                      (lp_std_rx_bo_pad_pattern[9:0]   ),
           .pcs8g_rx_bo_pattern                  (lp_std_rx_bo_pattern[19:0]      ),
           .pcs8g_rx_byte_deserializer           (lp_std_byte_deserializer        ),     // dis_bds|en_bds_by_2|en_bds_by_2_det
           .pcs8g_rx_byte_order                  (lp_std_rx_byte_order            ),     // dis_bo|en_pcs_ctrl_eight_bit_bo|en_pcs_ctrl_nine_bit_bo|en_pcs_ctrl_ten_bit_bo|en_pld_ctrl_eight_bit_bo|en_pld_ctrl_nine_bit_bo|en_pld_ctrl_ten_bit_bo
           .pcs8g_rx_clkcmp_pattern_n            (lp_std_rx_clkcmp_pattern_n[19:0]),
           .pcs8g_rx_clkcmp_pattern_p            (lp_std_rx_clkcmp_pattern_p[19:0]),        
           .pcs8g_rx_deskew_prog_pattern_only    ("dis_deskew_prog_pat_only"      ),   // dis_deskew_prog_pat_only|en_deskew_prog_pat_only
           .pcs8g_rx_dw_one_or_two_symbol_bo     (lp_std_rx_dw_one_or_two_symbol_bo),     // donot_care_one_two_bo|one_symbol_bo|two_symbol_bo_eight_bit|two_symbol_bo_nine_bit|two_symbol_bo_ten_bit
           .pcs8g_rx_eightb_tenb_decoder         (lp_std_rx_8b10b_dec             ),     // dis_8b10b|en_8b10b_ibm|en_8b10b_sgx
           .pcs8g_rx_mask_cnt                    (10'h320                         ),
           .pcs8g_rx_pcs_bypass                  ("dis_pcs_bypass"                ),     // dis_pcs_bypass|en_pcs_bypass
           .pcs8g_rx_phase_compensation_fifo     (lp_std_rx_pcfifo_mode           ),     // low_latency|normal_latency|register_fifo|pld_ctrl_low_latency|pld_ctrl_normal_latency
           .pcs8g_rx_pma_dw                      (lp_std_pcs_pma_dw               ),     // eight_bit|ten_bit|sixteen_bit|twenty_bit
           .pcs8g_rx_polarity_inversion          (lp_std_rx_polinv                ),     // dis_pol_inv|en_pol_inv
           .pcs8g_rx_prot_mode                   (std_protocol_hint               ),     // pipe_g1|pipe_g2|cpri|cpri_rx_tx|gige|xaui|srio_2p1|test|basic|disabled_prot_mode
           .pcs8g_rx_rate_match                  (lp_std_rx_rate_match            ),     // dis_rm|xaui_rm|gige_rm|pipe_rm|pipe_rm_0ppm|sw_basic_rm|srio_v2p1_rm|srio_v2p1_rm_0ppm|dw_basic_rm
           .pcs8g_rx_runlength_check             (lp_std_rx_runlength_check       ),     // dis_runlength|en_runlength_sw|en_runlength_dw
           .pcs8g_rx_runlength_val               (lp_std_rx_runlength_val[5:0]    ),
           //.pcs8g_rx_rx_clk1                     (lp_std_rx_rx_clk1               ),     // rcvd_clk_clk1|tx_pma_clock_clk1|rcvd_clk_agg_clk1|rcvd_clk_agg_top_or_bottom_clk1
           //.pcs8g_rx_rx_clk2                     (lp_std_rx_rx_clk2               ),     // rcvd_clk_clk2|tx_pma_clock_clk2|refclk_dig2_clk2
           .pcs8g_rx_rx_rcvd_clk                 ("rcvd_clk_rcvd_clk"             ),     // rcvd_clk_rcvd_clk|tx_pma_clock_rcvd_clk
           //.pcs8g_rx_rx_rd_clk                   (lp_std_rx_rx_rd_clk             ),     // pld_rx_clk|rx_clk
           .pcs8g_rx_sup_mode                    ("user_mode"                     ),     // user_mode|engineering_mode
           .pcs8g_rx_symbol_swap                 (lp_std_rx_symbol_swap           ),     // dis_symbol_swap|en_symbol_swap
           .pcs8g_rx_wa_boundary_lock_ctrl       (lp_std_wa_boundary_lock_ctrl    ),     // bit_slip|sync_sm|deterministic_latency|auto_align_pld_ctrl
           .pcs8g_rx_wa_clk_slip_spacing         (lp_std_rx_wa_clk_slip_spacing   ),     // min_clk_slip_spacing|user_programmable_clk_slip_spacing  
           .pcs8g_rx_wa_det_latency_sync_status_beh (lp_std_rx_wa_det_latency_sync_status_beh),// assert_sync_status_imm|assert_sync_status_non_imm|dont_care_assert_sync
           .pcs8g_rx_wa_disp_err_flag            (lp_std_rx_wa_disp_err_flag      ),     // dis_disp_err_flag|en_disp_err_flag      
           .pcs8g_rx_wa_pd                       (lp_std_rx_wa_pd                 ),     // dont_care_wa_pd_0|dont_care_wa_pd_1|wa_pd_7|wa_pd_10|wa_pd_20|wa_pd_40|wa_pd_8_sw|wa_pd_8_dw|wa_pd_16_sw|wa_pd_16_dw|wa_pd_32|wa_pd_fixed_7_k28p5|wa_pd_fixed_10_k28p5|wa_pd_fixed_16_a1a2_sw|wa_pd_fixed_16_a1a2_dw|wa_pd_fixed_32_a1a1a2a2|prbs15_fixed_wa_pd_16_sw|prbs15_fixed_wa_pd_16_dw|prbs15_fixed_wa_pd_20_dw|prbs31_fixed_wa_pd_16_sw|prbs31_fixed_wa_pd_16_dw|prbs31_fixed_wa_pd_10_sw|prbs31_fixed_wa_pd_40_dw|prbs8_fixed_wa|prbs10_fixed_wa|prbs7_fixed_wa_pd_16_sw|prbs7_fixed_wa_pd_16_dw|prbs7_fixed_wa_pd_20_dw|prbs23_fixed_wa_pd_16_sw|prbs23_fixed_wa_pd_32_dw|prbs23_fixed_wa_pd_40_dw
           .pcs8g_rx_wa_pd_data                  (lp_std_rx_wa_pd_data            ), 
//         .pcs8g_rx_wa_pld_controlled           (lp_std_rx_wa_pld_controlled     ),     // dis_pld_ctrl|pld_ctrl_sw|rising_edge_sensitive_dw|level_sensitive_dw
           .pcs8g_rx_wa_renumber_data            (lp_std_rx_wa_renumber_data      ),
           .pcs8g_rx_wa_rgnumber_data            (lp_std_rx_wa_rgnumber_data      ),
           .pcs8g_rx_wa_rknumber_data            (lp_std_rx_wa_rknumber_data      ),
//         .pcs8g_rx_wa_sync_sm_ctrl             (lp_std_rx_word_aligner_ctrl     ),     // gige_sync_sm|pipe_sync_sm|xaui_sync_sm|srio1p3_sync_sm|srio2p1_sync_sm|sw_basic_sync_sm|dw_basic_sync_sm|fibre_channel_sync_sm

           // Arria V TX PCS Parameters 
           .pcs8g_tx_bit_reversal                (lp_std_tx_bitrev                ),     // dis_bit_reversal|en_bit_reversal    
           .pcs8g_tx_byte_serializer             (lp_std_byte_serializer          ),     // dis_bs|en_bs_by_2
           .pcs8g_tx_eightb_tenb_disp_ctrl       (lp_std_tx_8b10b_disp_ctrl       ),     // dis_disp_ctrl|en_disp_ctrl|en_ib_disp_ctrl
           .pcs8g_tx_eightb_tenb_encoder         (lp_std_tx_8b10b_enc             ),     // dis_8b10b|en_8b10b_ibm|en_8b10b_sgx
           .pcs8g_tx_pcs_bypass                  ("dis_pcs_bypass"                ),     // dis_pcs_bypass|en_pcs_bypass
           .pcs8g_tx_phase_compensation_fifo     (lp_std_tx_pcfifo_mode           ),     // low_latency|normal_latency|register_fifo|pld_ctrl_low_latency|pld_ctrl_normal_latency 
           .pcs8g_tx_pma_dw                      (lp_std_pcs_pma_dw               ),     // eight_bit|ten_bit|sixteen_bit|twenty_bit
           .pcs8g_tx_polarity_inversion          (lp_std_tx_polinv                ),     // dis_polinv|enable_polinv      
           .pcs8g_tx_prot_mode                   (std_protocol_hint               ),     // pipe_g1|pipe_g2|cpri|cpri_rx_tx|gige|xaui|srio_2p1|test|basic|disabled_prot_mode
           .pcs8g_tx_sup_mode                    ("user_mode"                     ),     // user_mode|engineering_mode
           .pcs8g_tx_symbol_swap                 (lp_std_tx_symbol_swap           ),     // dis_symbol_swap|en_symbol_swap
           .pcs8g_tx_tx_bitslip                  (lp_std_tx_bitslip               ),     // dis_tx_bitslip|en_tx_bitslip
        
           // Arria V Common PCS PMA Interface Parameters
           .com_pcs_pma_if_auto_speed_ena        ("dis_auto_speed_ena"            ),     // dis_auto_speed_ena|en_auto_speed_ena
           .com_pcs_pma_if_force_freqdet         ("force_freqdet_dis"             ),     // force_freqdet_dis|force1_freqdet_en|force0_freqdet_en
           .com_pcs_pma_if_func_mode             (enable_pmadirect ? "pma_direct" : "eightg_only_pld"),     // disable|hrdrstctrl_cmu|eightg_only_pld|eightg_only_hip|pma_direct
           .com_pcs_pma_if_ppmsel                (lp_ppm_thresh                   ),     // ppmsel_default|ppmsel_1000|ppmsel_500|ppmsel_300|ppmsel_250|ppmsel_200|ppmsel_125|ppmsel_100|ppmsel_62p5|ppm_other
           .com_pcs_pma_if_prot_mode             ("other_protocols"               ),     // disabled_prot_mode|pipe_g1|pipe_g2|other_protocols
           .com_pcs_pma_if_selectpcs             ("eight_g_pcs"                   ),     // eight_g_pcs
           .com_pcs_pma_if_sup_mode              ("user_mode"                     ),     // user_mode|engineering_mode

           // Arria V RX PCS PMA Interface Parameters
           .rx_pcs_pma_if_clkslip_sel            (int_rx_clkslip_select           ),     // pld|slip_eight_g_pcs
           .rx_pcs_pma_if_prot_mode              (lp_rx_pcs_pma_if_prot_mode      ),     // other_protocols|cpri_8g
           .rx_pcs_pma_if_selectpcs              ("eight_g_pcs"                   ),     // eight_g_pcs|default
       
           // Arria V TX PCS PMA Interface Parameters
           .tx_pcs_pma_if_selectpcs              ("eight_g_pcs"                   ),     // eight_g_pcs|default

           // Arria V AVMM Parameters
           .bonded_lanes                         (num_bonded                      )     // Number of lanes
        ) 
        av_xcvr_native_inst 
          (      
           // TX/RX ports
           .seriallpbken                         (rx_seriallpbken      [ig +: num_bonded]  ),   // 1 = enable serial loopback                    
              
           // RX Ports                                                                 
           .rx_crurstn                           (~rx_analogreset      [ig +: num_bonded]  ),
           .rx_datain                            (rx_serial_data       [ig +: num_bonded]  ),   // RX serial data input                          
           .rx_cdr_ref_clk                       ({num_bonded{rx_cdr_refclk}}), // Reference clock for CDR                       
           .rx_ltd                               (rx_set_locktodata    [ig +: num_bonded]  ),   // Force lock-to-data stream
           .rx_clkdivrx                          (rx_pma_clkout        [ig +: num_bonded]  ),
           .rx_is_lockedtoref                    (rx_is_lockedtoref    [ig +: num_bonded]  ),   // Indicates lock to reference clock
           .rx_is_lockedtodata                   (rx_is_lockedtodata   [ig +: num_bonded]  ),           
           .rx_sd                                (rx_signaldetect      [ig +: num_bonded]  ),   // Signal detect output from PMA  
           .rx_dataout                           (rx_pma_parallel_data [80*ig +: num_bonded*80]),

           // TX Ports
           .tx_rxdetclk                          (1'b0),    // Clock for detection of downstream receiver
           .tx_dataout                           (tx_serial_data       [ig +: num_bonded]  ),   // TX serial data output
           .tx_rstn                              (~tx_analogreset      [ig +: num_bonded]  ),    
           .tx_rstn_cgb_master                   (~cgb_master_rstn     [ig*plls +: (num_bonded*plls)]),    
           .tx_clkdivtx                          (tx_pma_clkout        [ig +: num_bonded]  ), 
           .tx_ser_clk                           (pll_out_clk          [ig*plls +: (num_bonded*plls)]),     // High-speed serial clock from PLL              
           .tx_cal_busy                          (tx_cal_busy          [ig +: num_bonded]  ),
           .rx_cal_busy                   		 (rx_cal_busy          [ig +: num_bonded]  ),
           .tx_cpulsein                          ({num_bonded{cpulse_master}}              ),
           .tx_hclkin                            ({num_bonded{hclk_master  }}              ),
           .tx_lfclkin                           ({num_bonded{lfclk_master }}              ),
           .tx_pclkin                            ({num_bonded{pclk_master  }}              ),
                   
            //Standard/6G ports
           .in_pld_8g_a1a2_size                  (rx_std_wa_a1a2size   [ig +: num_bonded]  ),
           .in_pld_8g_bitloc_rev_en              (rx_std_bitrev_ena    [ig +: num_bonded]  ),
           .in_pld_8g_bitslip                    (rx_std_bitslip       [ig +: num_bonded]  ),
           .in_pld_8g_byte_rev_en                (rx_std_byterev_ena   [ig +: num_bonded]  ),
           .in_pld_8g_bytordpld                  (rx_std_byteorder_ena [ig +: num_bonded]  ),
           .in_pld_8g_encdt                      (rx_std_wa_patternalign [ig +: num_bonded]  ),
           .in_pld_8g_pld_rx_clk                 (rx_std_coreclkin     [ig +: num_bonded]  ),
           .in_pld_8g_pld_tx_clk                 (tx_std_coreclkin     [ig +: num_bonded]  ),
           .in_pld_8g_polinv_rx                  (rx_std_polinv        [ig +: num_bonded]  ),
           .in_pld_8g_polinv_tx                  (tx_std_polinv        [ig +: num_bonded]  ),
           .in_pld_8g_prbs_cid_en                ({num_bonded{1'b0}} ),
           .in_pld_8g_rddisable_tx               ({num_bonded{1'b0}} ),
           .in_pld_8g_rdenable_rmf               ({num_bonded{1'b0}} ),
           .in_pld_8g_rev_loopbk                 ({num_bonded{1'b0}} ),
           .in_pld_8g_rxurstpcs_n                (~rx_digitalreset     [ig +: num_bonded] ),
           .in_pld_8g_tx_boundary_sel            (tx_std_bitslipboundarysel [(ig*5) +: (num_bonded*5)]  ),
           .in_pld_8g_tx_data_valid              ({num_bonded{4'b0000}}                    ),
           .in_pld_8g_txelecidle                 (tx_std_elecidle      [ig +: num_bonded]  ),
           .in_pld_8g_txurstpcs_n                (~tx_digitalreset     [ig +: num_bonded]  ),
           .in_pld_8g_wrdisable_rx               ({num_bonded{1'b0}} ),
           .in_pld_8g_wrenable_rmf               ({num_bonded{1'b0}} ),
           .in_pld_8g_wrenable_tx                ({num_bonded{1'b0}} ),
           .in_pld_ltr                           (rx_set_locktoref     [ig +: num_bonded]  ),
           .in_pld_partial_reconfig_in           ({num_bonded{1'b1}} ),                         /// NOTE: active high
           .in_pld_rx_clk_slip_in                (rx_clkslip           [ig +: num_bonded]  ),
           .in_pld_rxpma_rstb_in                 (~rx_analogreset      [ig +: num_bonded]  ),
           .in_pld_scan_mode_n                   ({num_bonded{1'b1}} ),  
           .in_pld_scan_shift_n                  ({num_bonded{1'b1}} ),                       /// NOTE: active high
           .in_pld_sync_sm_en                    ({num_bonded{rx_std_sync_sm_en}}   ),
           .in_pld_tx_data                       (tx_parallel_data     [44*ig +: num_bonded*44]),
           .in_pld_tx_pma_data                   (tx_pma_parallel_data [80*ig +: num_bonded*80]),
           .in_pma_rx_freq_tx_cmu_pll_lock_in    ({num_bonded{1'b0}} ),
 
           .out_pld_8g_byteord_flag              (rx_std_byteorder_flag[ig +: num_bonded]  ),
           .out_pld_8g_empty_rmf                 (rx_std_rmfifo_empty  [ig +: num_bonded]  ),
           .out_pld_8g_empty_rx                  (rx_std_pcfifo_empty  [ig +: num_bonded]  ),
           .out_pld_8g_empty_tx                  (tx_std_pcfifo_empty  [ig +: num_bonded]  ),
           .out_pld_8g_full_rmf                  (rx_std_rmfifo_full   [ig +: num_bonded]  ),
           .out_pld_8g_full_rx                   (rx_std_pcfifo_full   [ig +: num_bonded]  ),
           .out_pld_8g_full_tx                   (tx_std_pcfifo_full   [ig +: num_bonded]  ),
           .out_pld_8g_rlv_lt                    (rx_std_runlength_err [ig +: num_bonded]  ),
           .out_pld_8g_rx_clk_out                (rx_std_clkout        [ig +: num_bonded]  ),
           .out_pld_8g_signal_detect_out         (rx_std_signaldetect  [ig +: num_bonded]  ),
           .out_pld_8g_tx_clk_out                (tx_std_clkout        [ig +: num_bonded]  ),
           .out_pld_8g_wa_boundary               (rx_std_bitslipboundarysel[5*ig +: 5*num_bonded]  ),
           .out_pld_8g_bistdone                  (rx_std_prbs_done     [ig +: num_bonded]  ),
           .out_pld_8g_bisterr                   (rx_std_prbs_err      [ig +: num_bonded]  ),

           .out_pld_clklow                       (rx_clklow            [ig +: num_bonded]  ),       
           .out_pld_fref                         (rx_fref              [ig +: num_bonded]  ),            // rx PFD ref clock (rx_cdr_refclk after divider)
           .out_pld_rx_data                      (rx_parallel_data     [64*ig +: num_bonded*64]),
    
          // avalon MM native reconfiguration interfaces
           .reconfig_to_xcvr                     (rcfg_to_xcvr   [ig*w_bundle_to_xcvr+:num_bonded*w_bundle_to_xcvr]    ),
           .reconfig_from_xcvr                   (rcfg_from_xcvr [ig*w_bundle_from_xcvr+:num_bonded*w_bundle_from_xcvr]),
           
           //unused ports
           .tx_fref                              ({num_bonded{1'b0}}                       ),  
		   .in_pma_reserved_in                   ({num_bonded{5'b0}}                       ),
           .in_pma_hclk                          ({num_bonded{1'b0}}                       ),
		   .in_pld_reserved_in		             ({num_bonded{12'b0}}                      ),
           .in_pld_rate                          ({num_bonded{1'b0}}                       ),
		   .in_pld_pcs_pma_if_refclk_dig         ({num_bonded{1'b0}}                       ),
		   .in_pld_eidleinfersel	             ({num_bonded{3'b0}}                       ),
		   .in_pld_8g_txswing                    ({num_bonded{1'b0}}                       ),
		   .in_pld_8g_txmargin                   ({num_bonded{3'b0}}                       ),
		   .in_pld_8g_txdetectrxloopback         ({num_bonded{1'b0}}                       ),
		   .in_pld_8g_txdeemph                   ({num_bonded{1'b0}}                       ),
		   .in_pld_8g_rxpolarity                 ({num_bonded{1'b0}}                       ),
		   .in_pld_8g_refclk_dig2                ({num_bonded{1'b0}}                       ),
		   .in_pld_8g_refclk_dig                 ({num_bonded{1'b0}}                       ),
		   .in_pld_8g_rdenable_rx                ({num_bonded{1'b0}}                       ),
		   .in_pld_8g_powerdown                  ({num_bonded{2'b0}}                       ),
		   .in_pld_8g_phfifourst_tx_n            ({num_bonded{1'b0}}                       ),
		   .in_pld_8g_phfifourst_rx_n            ({num_bonded{1'b0}}                       ),
		   .in_pld_8g_cmpfifourst_n              ({num_bonded{1'b0}}                       ),
		   .in_emsip_tx_special_in               ({num_bonded{13'b0}}                      ),
		   .in_emsip_tx_in	                     ({num_bonded{104'b0}}                     ),
		   .in_emsip_rx_special_in               ({num_bonded{13'b0}}                      ),
		   .in_emsip_com_in                      ({num_bonded{38'b0}}                      ),
		   .in_agg_tx_data_ts_top_or_bot         ({num_bonded{8'b0}}                       ),
		   .in_agg_tx_data_ts                    ({num_bonded{8'b0}}                       ),
		   .in_agg_tx_ctl_ts_top_or_bot          ({num_bonded{1'b0}}                       ),
		   .in_agg_tx_ctl_ts                     ({num_bonded{1'b0}}                       ),
		   .in_agg_testbus                       ({num_bonded{16'b0}}                      ),
		   .in_agg_test_so_to_pld_in             ({num_bonded{1'b0}}                       ),
		   .in_agg_rx_data_rs_top_or_bot         ({num_bonded{8'b0}}                       ),
		   .in_agg_rx_data_rs                    ({num_bonded{8'b0}}                       ),
		   .in_agg_rx_control_rs_top_or_bot      ({num_bonded{1'b0}}                       ),
		   .in_agg_rx_control_rs                 ({num_bonded{1'b0}}                       ),
		   .in_agg_rcvd_clk_agg_top_or_bot       ({num_bonded{1'b0}}                       ),
		   .in_agg_rcvd_clk_agg                  ({num_bonded{1'b0}}                       ),
		   .in_agg_latency_comp_0_top_or_bot     ({num_bonded{1'b0}}                       ),
		   .in_agg_insert_incomplete_0_top_or_bot({num_bonded{1'b0}}                       ),
		   .in_agg_insert_incomplete_0           ({num_bonded{1'b0}}                       ),
		   .in_agg_fifo_rst_rd_qd_top_or_bot     ({num_bonded{1'b0}}                       ),
		   .in_agg_fifo_rst_rd_qd                ({num_bonded{1'b0}}                       ),
		   .in_agg_fifo_rd_in_comp_0_top_or_bot  ({num_bonded{1'b0}}                       ),
		   .in_agg_fifo_rd_in_comp_0             ({num_bonded{1'b0}}                       ),
		   .in_agg_fifo_ovr_0_top_or_bot         ({num_bonded{1'b0}}                       ),
		   .in_agg_fifo_ovr_0                    ({num_bonded{1'b0}}                       ),
		   .in_agg_en_dskw_rd_ptrs_top_or_bot    ({num_bonded{1'b0}}                       ),
		   .in_agg_en_dskw_rd_ptrs               ({num_bonded{1'b0}}                       ),
		   .in_agg_en_dskw_qd_top_or_bot         ({num_bonded{1'b0}}                       ),
		   .in_agg_en_dskw_qd                    ({num_bonded{1'b0}}                       ),
		   .in_agg_del_cond_met_0_top_or_bot     ({num_bonded{1'b0}}                       ),
		   .in_agg_del_cond_met_0                ({num_bonded{1'b0}}                       ),
		   .in_agg_cg_comp_wr_all_top_or_bot     ({num_bonded{1'b0}}                       ),
		   .in_agg_cg_comp_wr_all                ({num_bonded{1'b0}}                       ),
		   .in_agg_cg_comp_rd_d_all_top_or_bot   ({num_bonded{1'b0}}                       ),
		   .in_agg_cg_comp_rd_d_all              ({num_bonded{1'b0}}                       ),
		   .in_agg_align_status_top_or_bot       ({num_bonded{1'b0}}                       ),
		   .in_agg_align_status_sync_0_top_or_bot({num_bonded{1'b0}}                       ),
		   .in_agg_align_status_sync_0           ({num_bonded{1'b0}}                       ),
		   .in_agg_align_status                  ({num_bonded{1'b0}}                       )
           );
     end // block: gen_bonded_group_native
      end // block: av_xcvr_native_insts
   end // block: gen_native_inst
   endgenerate
   
   // Merge critical reconfig signals
   sv_reconfig_bundle_merger 
     #(
       .reconfig_interfaces(reconfig_interfaces)
       ) av_reconfig_bundle_merger_inst 
       (
    // Reconfig buses to/from reconfig controller
    .rcfg_reconfig_to_xcvr  (reconfig_to_xcvr   ),
    .rcfg_reconfig_from_xcvr(reconfig_from_xcvr ),
    
    // Reconfig buses to/from native xcvr
    .xcvr_reconfig_to_xcvr  (rcfg_to_xcvr   ),
    .xcvr_reconfig_from_xcvr(rcfg_from_xcvr )
    );
  
endmodule // altera_xcvr_native_av






