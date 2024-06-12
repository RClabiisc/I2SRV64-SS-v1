//******************************************************************************
// Copyright (c) 2018 - 2023, Indian Institute of Science, Bangalore.
// All Rights Reserved. See LICENSE for license details.
//------------------------------------------------------------------------------

// Contributors // Manish Kumar(manishkumar5@iisc.ac.in), Shubham Yadav(shubhamyadav@iisc.ac.in)
// Sajin S (sajins@alum.iisc.ac.in), Shubham Sunil Garag (shubhamsunil@alum.iisc.ac.in)
// Anuj Phegade (anujphegade@alum.iisc.ac.in), Deepshikha Gusain (deepshikhag@alum.iisc.ac.in)
// Ronit Patel (ronitpatel@alum.iisc.ac.in), Vishal Kumar (vishalkumar@alum.iisc.ac.in)
// Kuruvilla Varghese (kuru@iisc.ac.in)
//******************************************************************************
`timescale 1ns/1ps
`include "soc_defines.vh"

(* keep_hierarchy = "yes" *)
module JTAG_to_AXI
(
    input  wire                                 clk,
    input  wire                                 rstn,

    output wire [3:0]                           M_AXI_AWID,
    output wire [`C_AXI_L2_ADDR_WIDTH-1:0]      M_AXI_AWADDR,
    output wire [7:0]                           M_AXI_AWLEN,
    output wire [2:0]                           M_AXI_AWSIZE,
    output wire [1:0]                           M_AXI_AWBURST,
    output wire                                 M_AXI_AWLOCK,
    output wire [3:0]                           M_AXI_AWCACHE,
    output wire [2:0]                           M_AXI_AWPROT,
    output wire [3:0]                           M_AXI_AWREGION,
    output wire [3:0]                           M_AXI_AWQOS,
    output wire                                 M_AXI_AWVALID,
    input  wire                                 M_AXI_AWREADY,
    output wire [`C_AXI_L2_DATA_WIDTH-1:0]      M_AXI_WDATA,
    output wire [`C_AXI_L2_DATA_WIDTH/8-1:0]    M_AXI_WSTRB,
    output wire                                 M_AXI_WLAST,
    output wire                                 M_AXI_WVALID,
    input  wire                                 M_AXI_WREADY,
    input  wire [3:0]                           M_AXI_BID,
    input  wire [1:0]                           M_AXI_BRESP,
    input  wire                                 M_AXI_BVALID,
    output wire                                 M_AXI_BREADY,
    output wire [3:0]                           M_AXI_ARID,
    output wire [`C_AXI_L2_ADDR_WIDTH-1:0]      M_AXI_ARADDR,
    output wire [7:0]                           M_AXI_ARLEN,
    output wire [2:0]                           M_AXI_ARSIZE,
    output wire [1:0]                           M_AXI_ARBURST,
    output wire                                 M_AXI_ARLOCK,
    output wire [3:0]                           M_AXI_ARCACHE,
    output wire [2:0]                           M_AXI_ARPROT,
    output wire [3:0]                           M_AXI_ARREGION,
    output wire [3:0]                           M_AXI_ARQOS,
    output wire                                 M_AXI_ARVALID,
    input  wire                                 M_AXI_ARREADY,
    input  wire [3:0]                           M_AXI_RID,
    input  wire [`C_AXI_L2_DATA_WIDTH-1:0]      M_AXI_RDATA,
    input  wire [1:0]                           M_AXI_RRESP,
    input  wire                                 M_AXI_RLAST,
    input  wire                                 M_AXI_RVALID,
    output wire                                 M_AXI_RREADY
);

/******************
*  JTAG to AXI4  *
******************/
//Protocol: AXI4
//Address Width: 64
//Data Width: 64
//ID Width: 4
//Burst Type: INCR Only
//TX Queue length: 1
//RX Queue length: 1
JTAG_to_AXI4 JTAG_to_AXI4
(
  .aclk                         (clk                        ), // input wire aclk
  .aresetn                      (rstn                       ), // input wire aresetn
  .m_axi_awid                   (M_AXI_AWID                 ), // output wire [3 : 0] m_axi_awid
  .m_axi_awaddr                 (M_AXI_AWADDR               ), // output wire [63 : 0] m_axi_awaddr
  .m_axi_awlen                  (M_AXI_AWLEN                ), // output wire [7 : 0] m_axi_awlen
  .m_axi_awsize                 (M_AXI_AWSIZE               ), // output wire [2 : 0] m_axi_awsize
  .m_axi_awburst                (M_AXI_AWBURST              ), // output wire [1 : 0] m_axi_awburst
  .m_axi_awlock                 (M_AXI_AWLOCK               ), // output wire m_axi_awlock
  .m_axi_awcache                (M_AXI_AWCACHE              ), // output wire [3 : 0] m_axi_awcache
  .m_axi_awprot                 (M_AXI_AWPROT               ), // output wire [2 : 0] m_axi_awprot
  .m_axi_awqos                  (M_AXI_AWQOS                ), // output wire [3 : 0] m_axi_awqos
  .m_axi_awvalid                (M_AXI_AWVALID              ), // output wire m_axi_awvalid
  .m_axi_awready                (M_AXI_AWREADY              ), // input wire m_axi_awready
  .m_axi_wdata                  (M_AXI_WDATA                ), // output wire [63 : 0] m_axi_wdata
  .m_axi_wstrb                  (M_AXI_WSTRB                ), // output wire [7 : 0] m_axi_wstrb
  .m_axi_wlast                  (M_AXI_WLAST                ), // output wire m_axi_wlast
  .m_axi_wvalid                 (M_AXI_WVALID               ), // output wire m_axi_wvalid
  .m_axi_wready                 (M_AXI_WREADY               ), // input wire m_axi_wready
  .m_axi_bid                    (M_AXI_BID                  ), // input wire [3 : 0] m_axi_bid
  .m_axi_bresp                  (M_AXI_BRESP                ), // input wire [1 : 0] m_axi_bresp
  .m_axi_bvalid                 (M_AXI_BVALID               ), // input wire m_axi_bvalid
  .m_axi_bready                 (M_AXI_BREADY               ), // output wire m_axi_bready
  .m_axi_arid                   (M_AXI_ARID                 ), // output wire [3 : 0] m_axi_arid
  .m_axi_araddr                 (M_AXI_ARADDR               ), // output wire [63 : 0] m_axi_araddr
  .m_axi_arlen                  (M_AXI_ARLEN                ), // output wire [7 : 0] m_axi_arlen
  .m_axi_arsize                 (M_AXI_ARSIZE               ), // output wire [2 : 0] m_axi_arsize
  .m_axi_arburst                (M_AXI_ARBURST              ), // output wire [1 : 0] m_axi_arburst
  .m_axi_arlock                 (M_AXI_ARLOCK               ), // output wire m_axi_arlock
  .m_axi_arcache                (M_AXI_ARCACHE              ), // output wire [3 : 0] m_axi_arcache
  .m_axi_arprot                 (M_AXI_ARPROT               ), // output wire [2 : 0] m_axi_arprot
  .m_axi_arqos                  (M_AXI_ARQOS                ), // output wire [3 : 0] m_axi_arqos
  .m_axi_arvalid                (M_AXI_ARVALID              ), // output wire m_axi_arvalid
  .m_axi_arready                (M_AXI_ARREADY              ), // input wire m_axi_arready
  .m_axi_rid                    (M_AXI_RID                  ), // input wire [3 : 0] m_axi_rid
  .m_axi_rdata                  (M_AXI_RDATA                ), // input wire [63 : 0] m_axi_rdata
  .m_axi_rresp                  (M_AXI_RRESP                ), // input wire [1 : 0] m_axi_rresp
  .m_axi_rlast                  (M_AXI_RLAST                ), // input wire m_axi_rlast
  .m_axi_rvalid                 (M_AXI_RVALID               ), // input wire m_axi_rvalid
  .m_axi_rready                 (M_AXI_RREADY               )  // output wire m_axi_rready
);

//Assign Unused Signals
assign M_AXI_AWREGION = 0;
assign M_AXI_ARREGION = 0;


endmodule

