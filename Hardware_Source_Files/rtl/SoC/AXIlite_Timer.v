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
module AXIlite_Timer
(
    input  wire                                 clk,
    input  wire                                 rstn,

    input  wire                                 capturetrig0,
    input  wire                                 capturetrig1,
    output wire                                 generateout0,
    output wire                                 generateout1,
    output wire                                 pwm0,

    output wire                                 interrupt,

    input  wire [`C_AXI_L3_ADDR_WIDTH-1:0]      S_AXI_AWADDR,
    input  wire [2:0]                           S_AXI_AWPROT,
    input  wire                                 S_AXI_AWVALID,
    output wire                                 S_AXI_AWREADY,
    input  wire [`C_AXI_L3_DATA_WIDTH-1:0]      S_AXI_WDATA,
    input  wire [(`C_AXI_L3_DATA_WIDTH/8)-1:0]  S_AXI_WSTRB,
    input  wire                                 S_AXI_WVALID,
    output wire                                 S_AXI_WREADY,
    output wire [1:0]                           S_AXI_BRESP,
    output wire                                 S_AXI_BVALID,
    input  wire                                 S_AXI_BREADY,
    input  wire [`C_AXI_L3_ADDR_WIDTH-1:0]      S_AXI_ARADDR,
    input  wire [2:0]                           S_AXI_ARPROT,
    input  wire                                 S_AXI_ARVALID,
    output wire                                 S_AXI_ARREADY,
    output wire [`C_AXI_L3_DATA_WIDTH-1:0]      S_AXI_RDATA,
    output wire [1:0]                           S_AXI_RRESP,
    output wire                                 S_AXI_RVALID,
    input  wire                                 S_AXI_RREADY
);

/*******************
*  configuration  *
*******************/
localparam ADDR_LEN = 5;


/******************
*  AXI Timer IP  *
******************/
axilite32_timer axilite32_timer
(
    .capturetrig0               (capturetrig0               ), // input wire capturetrig0
    .capturetrig1               (capturetrig1               ), // input wire capturetrig1
    .generateout0               (generateout0               ), // output wire generateout0
    .generateout1               (generateout1               ), // output wire generateout1
    .pwm0                       (pwm0                       ), // output wire pwm0
    .interrupt                  (interrupt                  ), // output wire interrupt
    .freeze                     (1'b0                       ), // input wire freeze

    .s_axi_aclk                 (clk                        ), // input wire s_axi_aclk
    .s_axi_aresetn              (rstn                       ), // input wire s_axi_aresetn

    .s_axi_awaddr               (S_AXI_AWADDR[ADDR_LEN-1:0] ), // input wire [4 : 0] s_axi_awaddr
    .s_axi_awvalid              (S_AXI_AWVALID              ), // input wire s_axi_awvalid
    .s_axi_awready              (S_AXI_AWREADY              ), // output wire s_axi_awready
    .s_axi_wdata                (S_AXI_WDATA                ), // input wire [31 : 0] s_axi_wdata
    .s_axi_wstrb                (S_AXI_WSTRB                ), // input wire [3 : 0] s_axi_wstrb
    .s_axi_wvalid               (S_AXI_WVALID               ), // input wire s_axi_wvalid
    .s_axi_wready               (S_AXI_WREADY               ), // output wire s_axi_wready
    .s_axi_bresp                (S_AXI_BRESP                ), // output wire [1 : 0] s_axi_bresp
    .s_axi_bvalid               (S_AXI_BVALID               ), // output wire s_axi_bvalid
    .s_axi_bready               (S_AXI_BREADY               ), // input wire s_axi_bready
    .s_axi_araddr               (S_AXI_ARADDR[ADDR_LEN-1:0] ), // input wire [4 : 0] s_axi_araddr
    .s_axi_arvalid              (S_AXI_ARVALID              ), // input wire s_axi_arvalid
    .s_axi_arready              (S_AXI_ARREADY              ), // output wire s_axi_arready
    .s_axi_rdata                (S_AXI_RDATA                ), // output wire [31 : 0] s_axi_rdata
    .s_axi_rresp                (S_AXI_RRESP                ), // output wire [1 : 0] s_axi_rresp
    .s_axi_rvalid               (S_AXI_RVALID               ), // output wire s_axi_rvalid
    .s_axi_rready               (S_AXI_RREADY               )  // input wire s_axi_rready
);


endmodule

