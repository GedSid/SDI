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


module sdi_ii_phy_adapter(

//--------------Common ports used for all families  ----------------
  xcvr_refclk,              // input refclk from top level
  reconfig_to_xcvr,         // to top level
  reconfig_from_xcvr,       // to top level
  xcvr_reconfig_to_xcvr,    // from phy
  xcvr_reconfig_from_xcvr,  // from phy
  
  // Tx - Input
  tx_clkout_from_xcvr,      // tx_clkout from phy 
  sdi_tx_from_xcvr,         // serial data from phy
  xcvr_tx_datain,           // parallel data from tx_phy_mgmt
  //tx_pll_locked_from_xcvr,   // pll_locked from phy
  xcvr_tx_ready,            // tx_ready from phy
  
  // Tx - Output
  tx_clkout,                // tx_clkout to tx_phy_mgmt 
  sdi_tx,                   // serial data to top level
  tx_datain_to_xcvr,        // parallel data to tx_phy_mgmt
  tx_pll_locked,            // pll_locked to top level

  // Rx- Input
  rxclk_from_xcvr,          // to rx_phy_mgmt
  sdi_rx,                   // serial data from top level
  rx_dataout_from_xcvr,     // parallel data from phy
  xcvr_rx_is_lockedtoref,   // lockedtoref from phy  
  rx_ready_from_xcvr,       // rx_ready from phy 

  // Rx - Output
  xcvr_rxclk,               // to rx_phy_mgmt
  sdi_rx_to_xcvr,           // serial data to phy
  xcvr_rx_dataout,          // parallel data to rx_phy_mgmt
  rx_pll_locked,            // lockedtoref to rx_phy_mgmt
  xcvr_rx_ready,            // rx_ready to rx_phy_mgmt 
   
  
  // Dual-link
  reconfig_to_xcvr_b,            // to top level
  reconfig_from_xcvr_b,          // to top level
  xcvr_reconfig_to_xcvr_b,       // from phy
  xcvr_reconfig_from_xcvr_b,     // from phy
  
  // Tx - Input (DL)
  tx_clkout_from_xcvr_b,         // tx_clkout from phy 
  sdi_tx_from_xcvr_b,            // serial data from phy
  xcvr_tx_datain_b,              // parallel data from tx_phy_mgmt
  //tx_pll_locked_from_xcvr_b,      // pll_locked from phy             //should not expecting this as txpll should be merged in DL mode
  xcvr_tx_ready_b,               // tx_ready from phy
  
  // Tx - Output (DL)
  //tx_clkout_b,                 // tx_clkout to tx_phy_mgmt 
  sdi_tx_b,                      // serial data to top level
  tx_datain_to_xcvr_b,           // parallel data to tx_phy_mgmt
  //tx_pll_locked_b,             // pll_locked to top level
  
  // Rx- Input (DL)
  rxclk_from_xcvr_b,             // to rx_phy_mgmt
  sdi_rx_b,                      // serial data from top level
  rx_dataout_from_xcvr_b,        // parallel data from phy
  xcvr_rx_is_lockedtoref_b,      // lockedtoref from phy  
  rx_ready_from_xcvr_b,          // rx_ready from phy 


  // Rx - Output (DL)
  xcvr_rxclk_b,                  // to rx_phy_mgmt
  sdi_rx_to_xcvr_b,              // serial data to phy
  xcvr_rx_dataout_b,             // parallel data to rx_phy_mgmt
  rx_pll_locked_b,               // lockedtoref to rx_phy_mgmt
  xcvr_rx_ready_b,               // rx_ready to rx_phy_mgmt 
  xcvr_rx_is_lockedtodata,
  xcvr_rx_is_lockedtodata_b,
  
  // Tx PLL select - when using external reset controller
  xcvr_refclk_alt,  
  xcvr_refclk_sel,  
  tx_pll_locked_alt,  
  tx_pll_locked_from_xcvr,

//-------------------Ports for Native PHY -----------------------------------
  // Tx
  tx_pll_refclk,                       // xcvr refclk to phy
  tx_serial_clk_in,
  tx_serial_clk_out,
  tx_serial_clk_alt_in,
  tx_serial_clk_alt_out,
  // tx_std_clkout,                       // tx_clkout from phy PCS
  tx_std_coreclkin,                    // input clock to send to phy PCS
  tx_pll_select_to_xcvr_rst,           // pll_select to xcvr_reset_control
  tx_pll_refclk_b,                       // xcvr refclk to phy
  // tx_std_clkout_b,                       // tx_clkout from phy PCS
  tx_std_coreclkin_b,                    // input clock to send to phy PCS
  tx_pll_select_to_xcvr_rst_b,           // pll_select to xcvr_reset_control
  tx_pclk,
  
  // Rx
  trig_rst_ctrl,
  trig_rst_ctrl_b,
  reset_to_xcvr_rst_ctrl,
  reset_to_xcvr_rst_ctrl_b,
  rx_cdr_refclk,
  rx_std_coreclkin,
  rx_pma_clkout,
  rx_set_locktodata,
  rx_set_locktoref,
  rx_set_locktodata_to_xcvr,
  rx_set_locktoref_to_xcvr,
  rx_locked_to_xcvr_ctrl,
  rx_manual,
  rx_cdr_refclk_b,
  rx_std_coreclkin_b,
  rx_pma_clkout_b,
  rx_set_locktodata_b,
  rx_set_locktoref_b,
  rx_set_locktodata_to_xcvr_b,
  rx_set_locktoref_to_xcvr_b,
  rx_locked_to_xcvr_ctrl_b,
  rx_manual_b,
  
  tx_analogreset_in,
  tx_analogreset_out,
  tx_analogreset_out_b,
  tx_digitalreset_in,
  tx_digitalreset_out,
  tx_digitalreset_out_b,
  tx_cal_busy_in,
  tx_cal_busy_in_b,
  pll_cal_busy_in,
  pll_cal_busy_in_alt,
  tx_cal_busy_out,
  pll_powerdown_in,
  pll_powerdown_out,
  pll_powerdown_out_b,
  pll_locked_in,
  pll_locked_in_b,
  pll_locked_out,

  rx_analogreset_in,
  rx_analogreset_out,
  rx_analogreset_out_b,
  rx_digitalreset_in,
  rx_digitalreset_out,
  rx_digitalreset_out_b,
  rx_cal_busy_in,
  rx_cal_busy_in_b,
  rx_cal_busy_out,
  
  reconfig_clk_in,
  reconfig_clk_out,
  reconfig_rst_in,
  reconfig_rst_out

);

   parameter FAMILY             = "Stratix V";   
   parameter VIDEO_STANDARD     = "tr";
   parameter DIRECTION          = "du";
   parameter XCVR_TX_PLL_SEL    = 0;       // Tx PLL select - when using external reset controller
   parameter XCVR_RST_CTRL_CHS  = 1;       // Number of channels set in xcvr reset controller (Used in Arria 10 device only)
   //parameter ED_TXPLL_TYPE      = "CMU";   // TX PLL Type selection in example design (Used in Arria 10 device only)
   parameter ED_TXPLL_SWITCH    = 0;       // TX PLL Type selection in example design (Used in Arria 10 device only)

   localparam TX_CON_GEN        = (DIRECTION == "tx" || DIRECTION == "du"); 
   localparam RX_CON_GEN        = (DIRECTION == "rx" || DIRECTION == "du"); 
   localparam RC_TO_SIZE        = (DIRECTION == "rx") ? 70 : (XCVR_TX_PLL_SEL == 1) ? 210 : 140;
   localparam RC_FR_SIZE        = (DIRECTION == "rx") ? 46 : (XCVR_TX_PLL_SEL == 1) ? 138 : 92;
   localparam TXDATA_WIDTH      = (FAMILY == "Cyclone V" || FAMILY == "Arria V") ? 44 : (FAMILY == "Stratix V" || FAMILY == "Arria V GZ") ? 64 : 128;
   localparam RXDATA_WIDTH      = (FAMILY == "Cyclone V" || FAMILY == "Arria V" || FAMILY == "Stratix V" || FAMILY == "Arria V GZ") ? 64 : 128;
   localparam TX_CAL_BUSY_WIDTH = (FAMILY == "Arria 10" && VIDEO_STANDARD == "dl") ? 2 : 1;
   localparam TX_REFCLK_CNT     = (XCVR_TX_PLL_SEL != 0)   ? 2 : 1;
   localparam TX_PLL_CNT        = (XCVR_TX_PLL_SEL == 1)   ? 2 : 1;

   input                           xcvr_refclk;   // xcvr_refclk is only applicable for RX in Arria 10
   input  [RC_TO_SIZE-1:0]         reconfig_to_xcvr;
   output [RC_FR_SIZE-1:0]         reconfig_from_xcvr;
   input  [RC_TO_SIZE-1:0]         reconfig_to_xcvr_b;
   output [RC_FR_SIZE-1:0]         reconfig_from_xcvr_b;
  
   output [RC_TO_SIZE-1:0]         xcvr_reconfig_to_xcvr;
   input  [RC_FR_SIZE-1:0]         xcvr_reconfig_from_xcvr;
   output [RC_TO_SIZE-1:0]         xcvr_reconfig_to_xcvr_b;
   input  [RC_FR_SIZE-1:0]         xcvr_reconfig_from_xcvr_b;   

   input  [19:0]                   xcvr_tx_datain;
   input  [19:0]                   xcvr_tx_datain_b;
   output [TXDATA_WIDTH - 1:0]     tx_datain_to_xcvr;
   output [TXDATA_WIDTH - 1:0]     tx_datain_to_xcvr_b;

   // Tx PLL select - when using external reset controller
   input                           xcvr_refclk_alt;
   output [TX_REFCLK_CNT - 1:0]      tx_pll_refclk;
   output [TX_REFCLK_CNT - 1:0]      tx_pll_refclk_b;
   input                           tx_serial_clk_in;
   output                          tx_serial_clk_out;
   input                           tx_serial_clk_alt_in;
   output                          tx_serial_clk_alt_out;

   input                           xcvr_refclk_sel; 
   output                          tx_pll_select_to_xcvr_rst;
   output                          tx_pll_select_to_xcvr_rst_b;

   input                           sdi_tx_from_xcvr;
   input                           sdi_tx_from_xcvr_b;
   output                          sdi_tx;
   output                          sdi_tx_b;

   input  [TX_PLL_CNT - 1:0]       tx_pll_locked_from_xcvr;
   output                          tx_pll_locked;
   output                          tx_pll_locked_alt;  // not expecting _b for DL as txpll should merge between both links
   //output                        tx_pll_locked_b;

   // input                           tx_std_clkout;
   // input                           tx_std_clkout_b;

   input                           tx_pclk;
   input                           tx_clkout_from_xcvr;
   input                           tx_clkout_from_xcvr_b;
   output                          tx_clkout;
   //output                        tx_clkout_b;
   output                          tx_std_coreclkin;
   output                          tx_std_coreclkin_b;

   input [XCVR_RST_CTRL_CHS-1:0]   xcvr_tx_ready;
   input                           xcvr_tx_ready_b;

   input [1:0]                     tx_analogreset_in;
   output                          tx_analogreset_out;
   output                          tx_analogreset_out_b;

   input [1:0]                     tx_digitalreset_in;
   output                          tx_digitalreset_out;
   output                          tx_digitalreset_out_b;

   input                           tx_cal_busy_in;
   input                           tx_cal_busy_in_b;
   input                           pll_cal_busy_in;
   input                           pll_cal_busy_in_alt;
   output [TX_CAL_BUSY_WIDTH-1:0]  tx_cal_busy_out;
   
   input  [1:0]                    pll_powerdown_in;
   output                          pll_powerdown_out;
   output                          pll_powerdown_out_b;
   input                           pll_locked_in;
   input                           pll_locked_in_b;
   output [1:0]                    pll_locked_out;

   output                          rx_cdr_refclk;
   output                          rx_cdr_refclk_b;
   input                           rx_pma_clkout;
   input                           rx_pma_clkout_b;

   input                           sdi_rx;
   input                           sdi_rx_b;
   output                          sdi_rx_to_xcvr;
   output                          sdi_rx_to_xcvr_b;

   input                           rxclk_from_xcvr;
   input                           rxclk_from_xcvr_b;
   output                          xcvr_rxclk;
   output                          xcvr_rxclk_b;
   output                          rx_std_coreclkin;
   output                          rx_std_coreclkin_b;

   input  [RXDATA_WIDTH - 1:0]     rx_dataout_from_xcvr;
   input  [RXDATA_WIDTH - 1:0]     rx_dataout_from_xcvr_b;
   output [19:0]                   xcvr_rx_dataout;
   output [19:0]                   xcvr_rx_dataout_b;

   input  [XCVR_RST_CTRL_CHS-1:0]  rx_ready_from_xcvr;
   input                           rx_ready_from_xcvr_b;
   output                          xcvr_rx_ready;
   output                          xcvr_rx_ready_b;

   input                           xcvr_rx_is_lockedtoref;
   input                           xcvr_rx_is_lockedtoref_b;
   output                          rx_pll_locked;
   output                          rx_pll_locked_b;

   input                           xcvr_rx_is_lockedtodata;
   input                           xcvr_rx_is_lockedtodata_b;
   output [XCVR_RST_CTRL_CHS-1:0]  rx_locked_to_xcvr_ctrl;
   output                          rx_locked_to_xcvr_ctrl_b;

   input  [1:0]                    rx_analogreset_in;
   output                          rx_analogreset_out;
   output                          rx_analogreset_out_b;

   input  [1:0]                    rx_digitalreset_in;
   output                          rx_digitalreset_out;
   output                          rx_digitalreset_out_b;

   input                           trig_rst_ctrl;
   input                           trig_rst_ctrl_b;
   output                          reset_to_xcvr_rst_ctrl;
   output                          reset_to_xcvr_rst_ctrl_b;

   input                           rx_cal_busy_in;
   input                           rx_cal_busy_in_b;
   output [1:0]                    rx_cal_busy_out;

   input                           rx_set_locktoref;
   input                           rx_set_locktoref_b;
   output                          rx_set_locktoref_to_xcvr;
   output                          rx_set_locktoref_to_xcvr_b;

   input                           rx_set_locktodata;
   input                           rx_set_locktodata_b;
   output                          rx_set_locktodata_to_xcvr;
   output                          rx_set_locktodata_to_xcvr_b;

   output [XCVR_RST_CTRL_CHS-1:0]  rx_manual;
   output                          rx_manual_b;

   input                           reconfig_clk_in;
   output                          reconfig_clk_out;
   input                           reconfig_rst_in;
   output                          reconfig_rst_out;

  //------------------------------------------------------------
  // Interface to Native PHY
  //------------------------------------------------------------

  assign reconfig_from_xcvr             = xcvr_reconfig_from_xcvr;
  assign xcvr_reconfig_to_xcvr          = reconfig_to_xcvr;
  assign reconfig_clk_out               = reconfig_clk_in;
  assign reconfig_rst_out               = reconfig_rst_in;

  generate if (VIDEO_STANDARD == "dl")
  begin : common_gen_linkb
     assign xcvr_reconfig_to_xcvr_b     = reconfig_to_xcvr_b;
     assign reconfig_from_xcvr_b        = xcvr_reconfig_from_xcvr_b;
  end else begin
     assign xcvr_reconfig_to_xcvr_b     = {RC_TO_SIZE{1'b0}};
     assign reconfig_from_xcvr_b        = {RC_FR_SIZE{1'b0}};
  end
  endgenerate

  //-------------------------------------------------------------------
  // Interface with core
  //-------------------------------------------------------------------
  generate if (TX_CON_GEN)
  begin : tx_gen
     assign tx_datain_to_xcvr           = {12'd0, xcvr_tx_datain[19:10], 12'd0, xcvr_tx_datain[9:0]};
     assign tx_pll_refclk[0]            = xcvr_refclk;
     assign tx_std_coreclkin            = tx_pclk;
     assign tx_pll_locked               = tx_pll_locked_from_xcvr[0];
     assign tx_clkout                   = tx_clkout_from_xcvr;
     assign sdi_tx                      = sdi_tx_from_xcvr;
     assign tx_pll_select_to_xcvr_rst   = XCVR_TX_PLL_SEL == 1 ? xcvr_refclk_sel : 1'b0;
     assign tx_serial_clk_out           = tx_serial_clk_in;
  
     if (XCVR_TX_PLL_SEL == 1)                           
     begin 
        assign tx_pll_locked_alt            = tx_pll_locked_from_xcvr[1];
     end else begin
        assign tx_pll_locked_alt            = 1'b0;
     end

     if (XCVR_TX_PLL_SEL != 0)
     begin 
        assign tx_pll_refclk[1]             = xcvr_refclk_alt;
     end

    if (XCVR_RST_CTRL_CHS == 1)
    begin
       if (ED_TXPLL_SWITCH == 1) begin
          assign tx_cal_busy_out[0]         = (tx_cal_busy_in | pll_cal_busy_in | pll_cal_busy_in_alt);
       end else begin
          assign tx_cal_busy_out[0]         = (tx_cal_busy_in | pll_cal_busy_in);
       end
    end

    if (ED_TXPLL_SWITCH == 1)
    begin
       assign tx_serial_clk_alt_out   = tx_serial_clk_alt_in;
       assign pll_powerdown_out   = pll_powerdown_in[0];
       assign pll_powerdown_out_b = pll_powerdown_in[1];
       assign pll_locked_out      = {pll_locked_in_b, pll_locked_in};
    end else begin
       assign tx_serial_clk_alt_out   = 1'b0;
       assign pll_powerdown_out       = 1'b0;
       assign pll_powerdown_out_b     = 1'b0;
       assign pll_locked_out          = 2'b00;
    end
  end else begin
     assign tx_datain_to_xcvr           = {TXDATA_WIDTH{1'b0}};
     assign tx_pll_refclk               = 1'b0;
     assign tx_std_coreclkin            = 1'b0;
     assign tx_pll_locked               = 1'b0;
     assign tx_clkout                   = 1'b0;
     assign sdi_tx                      = 1'b0;
     assign tx_pll_select_to_xcvr_rst   = 1'b0;
     assign tx_serial_clk_out           = 1'b0;
     assign tx_pll_locked_alt           = 1'b0;
     assign tx_cal_busy_out             = {TX_CAL_BUSY_WIDTH{1'b0}};
     assign tx_serial_clk_alt_out       = 1'b0;
     assign pll_powerdown_out           = 1'b0;
     assign pll_powerdown_out_b         = 1'b0;
     assign pll_locked_out              = 2'b00;
  end
  endgenerate
  
  generate if (RX_CON_GEN)
  begin : rx_gen
     assign sdi_rx_to_xcvr              = sdi_rx;
     assign xcvr_rx_ready               = rx_ready_from_xcvr[0];
     assign xcvr_rxclk                  = rxclk_from_xcvr;
     // Rxdata assignment is done in this way as the active data bits for Native PHY is [41:32] & [9:0]
     assign xcvr_rx_dataout             = {rx_dataout_from_xcvr[41:32], rx_dataout_from_xcvr[9:0]};
     assign rx_pll_locked               = xcvr_rx_is_lockedtoref;
     assign reset_to_xcvr_rst_ctrl      = trig_rst_ctrl;
     assign rx_cdr_refclk               = xcvr_refclk;        // xcvr_refclk is only applicable for RX in Arria 10
     assign rx_std_coreclkin            = rxclk_from_xcvr;
     assign rx_set_locktodata_to_xcvr   = rx_set_locktodata;
     assign rx_set_locktoref_to_xcvr    = rx_set_locktoref;
     assign rx_manual                   = (XCVR_RST_CTRL_CHS == 2) ? rx_ready_from_xcvr : rx_ready_from_xcvr[0];

     if (XCVR_RST_CTRL_CHS == 2) begin
        assign rx_locked_to_xcvr_ctrl = rx_set_locktoref ? {xcvr_rx_is_lockedtoref_b, xcvr_rx_is_lockedtoref} : {xcvr_rx_is_lockedtodata_b, xcvr_rx_is_lockedtodata};
     end else begin
        assign rx_locked_to_xcvr_ctrl = rx_set_locktoref ? xcvr_rx_is_lockedtoref : xcvr_rx_is_lockedtodata;
     end
  end else begin
     assign sdi_rx_to_xcvr              = 1'b0;
     assign xcvr_rx_ready               = 1'b0;
     assign xcvr_rxclk                  = 1'b0;
     assign xcvr_rx_dataout             = 20'd0;
     assign rx_pll_locked               = 1'b0;
     assign reset_to_xcvr_rst_ctrl      = 1'b0;
     assign rx_cdr_refclk               = 1'b0;
     assign rx_std_coreclkin            = 1'b0;
     assign rx_set_locktodata_to_xcvr   = 1'b0;
     assign rx_set_locktoref_to_xcvr    = 1'b0;
     assign rx_locked_to_xcvr_ctrl      = {XCVR_RST_CTRL_CHS{1'b0}};
     assign rx_manual                   = {XCVR_RST_CTRL_CHS{1'b0}};
  end
  endgenerate

  //-------------------------------------------------------------------
  // When Video Stanard = HD Dual Link
  //-------------------------------------------------------------------
  generate if (TX_CON_GEN && VIDEO_STANDARD == "dl")
  begin : tx_gen_linkb
     assign tx_datain_to_xcvr_b         = {12'd0, xcvr_tx_datain_b[19:10], 12'd0, xcvr_tx_datain_b[9:0]};
     assign tx_pll_refclk_b[0]          = xcvr_refclk;
     assign tx_std_coreclkin_b          = tx_pclk;
     assign tx_pll_select_to_xcvr_rst_b = XCVR_TX_PLL_SEL == 1 ? xcvr_refclk_sel : 1'b0;
     assign sdi_tx_b                    = sdi_tx_from_xcvr_b;

     if (XCVR_TX_PLL_SEL != 0)
     begin 
        assign tx_pll_refclk_b[1]      = xcvr_refclk_alt;
     end
  end else begin
     assign tx_datain_to_xcvr_b         = {TXDATA_WIDTH{1'b0}};
     assign tx_pll_refclk_b             = 1'b0;
     assign tx_std_coreclkin_b          = 1'b0;
     assign tx_pll_select_to_xcvr_rst_b = 1'b0;
     assign sdi_tx_b                    = 1'b0;
  end
  endgenerate

  generate if (RX_CON_GEN && VIDEO_STANDARD == "dl")
  begin : rx_gen_linkb
     assign sdi_rx_to_xcvr_b            = sdi_rx_b;
     assign xcvr_rx_ready_b             = (XCVR_RST_CTRL_CHS == 2) ? rx_ready_from_xcvr[1] : rx_ready_from_xcvr_b;
     assign xcvr_rxclk_b                = rxclk_from_xcvr_b;
     assign xcvr_rx_dataout_b           = {rx_dataout_from_xcvr_b[41:32], rx_dataout_from_xcvr_b[9:0]};
     assign rx_pll_locked_b             = xcvr_rx_is_lockedtoref_b;
     assign reset_to_xcvr_rst_ctrl_b    = trig_rst_ctrl_b;
     assign rx_cdr_refclk_b             = xcvr_refclk;
     assign rx_std_coreclkin_b          = rxclk_from_xcvr_b;
     assign rx_set_locktodata_to_xcvr_b = rx_set_locktodata_b;
     assign rx_set_locktoref_to_xcvr_b  = rx_set_locktoref_b;
     assign rx_locked_to_xcvr_ctrl_b    = rx_set_locktoref_b ? xcvr_rx_is_lockedtoref_b : xcvr_rx_is_lockedtodata_b;
     assign rx_manual_b                 = (XCVR_RST_CTRL_CHS == 2) ? rx_ready_from_xcvr[1] : rx_ready_from_xcvr_b;
  end else begin
     assign sdi_rx_to_xcvr_b            = 1'b0;
     assign xcvr_rx_ready_b             = 1'b0;
     assign xcvr_rxclk_b                = 1'b0;
     assign xcvr_rx_dataout_b           = 20'd0;
     assign rx_pll_locked_b             = 1'b0;
     assign reset_to_xcvr_rst_ctrl_b    = 1'b0;
     assign rx_cdr_refclk_b             = 1'b0;
     assign rx_std_coreclkin_b          = 1'b0;
     assign rx_set_locktodata_to_xcvr_b = 1'b0;
     assign rx_set_locktoref_to_xcvr_b  = 1'b0;
     assign rx_locked_to_xcvr_ctrl_b    = 1'b0;
     assign rx_manual_b                 = 1'b0;
  end
  endgenerate

  //-------------------------------------------------------------------
  // When XCVR Reset Controller Channel = 2
  //-------------------------------------------------------------------
  generate if (TX_CON_GEN && XCVR_RST_CTRL_CHS == 2)
  begin : tx_xcvr_rst_control_signals_split
     assign tx_analogreset_out      = tx_analogreset_in[0];
     assign tx_analogreset_out_b    = tx_analogreset_in[1];
     assign tx_digitalreset_out     = tx_digitalreset_in[0];
     assign tx_digitalreset_out_b   = tx_digitalreset_in[1];

     if (ED_TXPLL_SWITCH == 1) begin
        assign tx_cal_busy_out         = {(tx_cal_busy_in_b | pll_cal_busy_in | pll_cal_busy_in_alt), (tx_cal_busy_in | pll_cal_busy_in | pll_cal_busy_in_alt)};
     end else begin
        assign tx_cal_busy_out         = {(tx_cal_busy_in_b | pll_cal_busy_in), (tx_cal_busy_in | pll_cal_busy_in)};
     end
  end else begin
     assign tx_analogreset_out      = 1'b0;
     assign tx_analogreset_out_b    = 1'b0;
     assign tx_digitalreset_out     = 1'b0;
     assign tx_digitalreset_out_b   = 1'b0;
  end
  endgenerate

  generate if (RX_CON_GEN && XCVR_RST_CTRL_CHS == 2)
  begin : rx_xcvr_rst_control_signals_split
     assign rx_analogreset_out      = rx_analogreset_in[0];
     assign rx_analogreset_out_b    = rx_analogreset_in[1];
     assign rx_digitalreset_out     = rx_digitalreset_in[0];
     assign rx_digitalreset_out_b   = rx_digitalreset_in[1];
     assign rx_cal_busy_out         = {rx_cal_busy_in_b, rx_cal_busy_in};
  end else begin
     assign rx_analogreset_out      = 1'b0;
     assign rx_analogreset_out_b    = 1'b0;
     assign rx_digitalreset_out     = 1'b0;
     assign rx_digitalreset_out_b   = 1'b0;
     assign rx_cal_busy_out         = 2'b00;
  end
  endgenerate
endmodule
