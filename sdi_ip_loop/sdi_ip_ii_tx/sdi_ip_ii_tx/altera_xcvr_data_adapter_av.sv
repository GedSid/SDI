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


// (C) 2001-2012 Altera Corporation. All rights reserved.
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


`timescale 1ps/1ps


module altera_xcvr_data_adapter_av #(

     parameter lanes           = 1,           //Number of lanes chosen by user. legal value: 1+
     parameter pld_interface_width = 80,      //(8,10,16,20,64,80)
     parameter tx_pld_data_max_width = 80,    //(44,80)
     parameter rx_pld_data_max_width = 80,    //(64,80)
     parameter ser_base_word     = 8,
     parameter ser_word          = 1

) ( 

     input   wire    [(pld_interface_width*lanes)-1:0]   tx_parallel_data,
     input   wire    [(rx_pld_data_max_width*lanes)-1:0] rx_dataout_to_pld,
     
     output  wire    [(tx_pld_data_max_width*lanes)-1:0] tx_datain_from_pld,
     output  wire    [(pld_interface_width*lanes)-1:0]   rx_parallel_data
);

localparam tx_data_bundle_size = 10; 
localparam rx_data_bundle_size = 10; 

 
 generate begin			
    genvar num_ch;
    genvar num_word;

    for (num_ch=0; num_ch < lanes; num_ch = num_ch + 1) begin:channel
        for (num_word=0; num_word < ser_word; num_word=num_word+1) begin:word
          
          //***************************************************************
          //*********************** TX assignments ************************
          assign tx_datain_from_pld[tx_pld_data_max_width*num_ch+num_word*tx_data_bundle_size +: ser_base_word] = tx_parallel_data[ser_base_word*ser_word*num_ch+num_word*ser_base_word +: ser_base_word];
          
          //***************************************************************
          //*********************** RX assignments ************************
	        assign rx_parallel_data[ser_base_word*ser_word*num_ch+num_word*ser_base_word +: ser_base_word] = rx_dataout_to_pld[rx_pld_data_max_width*num_ch+num_word*rx_data_bundle_size +: ser_base_word];
        end //for word
    end
  end
 endgenerate

endmodule






     

