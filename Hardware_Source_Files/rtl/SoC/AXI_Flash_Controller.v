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
module AXI_Flash_Controller
(
    input  wire                                 clk,
    input  wire                                 rstn,

    input  wire                                 emc_clk,

    input  wire [15:0]                          linear_flash_dq_i,
    output wire [15:0]                          linear_flash_dq_o,
    output wire [15:0]                          linear_flash_dq_t,
    output wire [25:0]                          linear_flash_addr,
    output wire                                 linear_flash_ce_n,
    output wire                                 linear_flash_oen,
    output wire                                 linear_flash_wen,
    output wire                                 linear_flash_adv_ldn,

    input  wire [3:0]                           S_AXI_AWID,
    input  wire [`C_AXI_L2_ADDR_WIDTH-1:0]      S_AXI_AWADDR,
    input  wire [7:0]                           S_AXI_AWLEN,
    input  wire [2:0]                           S_AXI_AWSIZE,
    input  wire [1:0]                           S_AXI_AWBURST,
    input  wire                                 S_AXI_AWLOCK,
    input  wire [3:0]                           S_AXI_AWCACHE,
    input  wire [2:0]                           S_AXI_AWPROT,
    input  wire [3:0]                           S_AXI_AWQOS,
    input  wire                                 S_AXI_AWVALID,
    output wire                                 S_AXI_AWREADY,
    input  wire [`C_AXI_L2_DATA_WIDTH-1:0]      S_AXI_WDATA,
    input  wire [`C_AXI_L2_DATA_WIDTH/8-1:0]    S_AXI_WSTRB,
    input  wire                                 S_AXI_WLAST,
    input  wire                                 S_AXI_WVALID,
    output wire                                 S_AXI_WREADY,
    output wire [3:0]                           S_AXI_BID,
    output wire [1:0]                           S_AXI_BRESP,
    output wire                                 S_AXI_BVALID,
    input  wire                                 S_AXI_BREADY,
    input  wire [3:0]                           S_AXI_ARID,
    input  wire [`C_AXI_L2_ADDR_WIDTH-1:0]      S_AXI_ARADDR,
    input  wire [7:0]                           S_AXI_ARLEN,
    input  wire [2:0]                           S_AXI_ARSIZE,
    input  wire [1:0]                           S_AXI_ARBURST,
    input  wire                                 S_AXI_ARLOCK,
    input  wire [3:0]                           S_AXI_ARCACHE,
    input  wire [2:0]                           S_AXI_ARPROT,
    input  wire [3:0]                           S_AXI_ARQOS,
    input  wire                                 S_AXI_ARVALID,
    output wire                                 S_AXI_ARREADY,
    output wire [3:0]                           S_AXI_RID,
    output wire [`C_AXI_L2_DATA_WIDTH-1:0]      S_AXI_RDATA,
    output wire [1:0]                           S_AXI_RRESP,
    output wire                                 S_AXI_RLAST,
    output wire                                 S_AXI_RVALID,
    input  wire                                 S_AXI_RREADY
);

/********************
*  Configurations  *
********************/
localparam ADDR_LEN             = 32;

wire [4:0]  unconnected_5;
wire        unconnected_0;

/*****************************************
*  AXI Flash EMC Controller IP (VC707)  *
*****************************************/
axi64_flashemc_vc707 axi64_flashemc_vc707
(
    .s_axi_aclk                 (clk                        ), // input wire s_axi_aclk
    .s_axi_aresetn              (rstn                       ), // input wire s_axi_aresetn

    .rdclk                      (emc_clk                    ), // input wire rdclk

    .s_axi_mem_awid             (S_AXI_AWID                 ), // input wire [3 : 0] s_axi_mem_awid
    .s_axi_mem_awaddr           (S_AXI_AWADDR[ADDR_LEN-1:0] ), // input wire [31 : 0] s_axi_mem_awaddr
    .s_axi_mem_awlen            (S_AXI_AWLEN                ), // input wire [7 : 0] s_axi_mem_awlen
    .s_axi_mem_awsize           (S_AXI_AWSIZE               ), // input wire [2 : 0] s_axi_mem_awsize
    .s_axi_mem_awburst          (S_AXI_AWBURST              ), // input wire [1 : 0] s_axi_mem_awburst
    .s_axi_mem_awlock           (S_AXI_AWLOCK               ), // input wire s_axi_mem_awlock
    .s_axi_mem_awcache          (S_AXI_AWCACHE              ), // input wire [3 : 0] s_axi_mem_awcache
    .s_axi_mem_awprot           (S_AXI_AWPROT               ), // input wire [2 : 0] s_axi_mem_awprot
    .s_axi_mem_awvalid          (S_AXI_AWVALID              ), // input wire s_axi_mem_awvalid
    .s_axi_mem_awready          (S_AXI_AWREADY              ), // output wire s_axi_mem_awready
    .s_axi_mem_wdata            (S_AXI_WDATA                ), // input wire [63 : 0] s_axi_mem_wdata
    .s_axi_mem_wstrb            (S_AXI_WSTRB                ), // input wire [7 : 0] s_axi_mem_wstrb
    .s_axi_mem_wlast            (S_AXI_WLAST                ), // input wire s_axi_mem_wlast
    .s_axi_mem_wvalid           (S_AXI_WVALID               ), // input wire s_axi_mem_wvalid
    .s_axi_mem_wready           (S_AXI_WREADY               ), // output wire s_axi_mem_wready
    .s_axi_mem_bid              (S_AXI_BID                  ), // output wire [3 : 0] s_axi_mem_bid
    .s_axi_mem_bresp            (S_AXI_BRESP                ), // output wire [1 : 0] s_axi_mem_bresp
    .s_axi_mem_bvalid           (S_AXI_BVALID               ), // output wire s_axi_mem_bvalid
    .s_axi_mem_bready           (S_AXI_BREADY               ), // input wire s_axi_mem_bready
    .s_axi_mem_arid             (S_AXI_ARID                 ), // input wire [3 : 0] s_axi_mem_arid
    .s_axi_mem_araddr           (S_AXI_ARADDR[ADDR_LEN-1:0] ), // input wire [31 : 0] s_axi_mem_araddr
    .s_axi_mem_arlen            (S_AXI_ARLEN                ), // input wire [7 : 0] s_axi_mem_arlen
    .s_axi_mem_arsize           (S_AXI_ARSIZE               ), // input wire [2 : 0] s_axi_mem_arsize
    .s_axi_mem_arburst          (S_AXI_ARBURST              ), // input wire [1 : 0] s_axi_mem_arburst
    .s_axi_mem_arlock           (S_AXI_ARLOCK               ), // input wire s_axi_mem_arlock
    .s_axi_mem_arcache          (S_AXI_ARCACHE              ), // input wire [3 : 0] s_axi_mem_arcache
    .s_axi_mem_arprot           (S_AXI_ARPROT               ), // input wire [2 : 0] s_axi_mem_arprot
    .s_axi_mem_arvalid          (S_AXI_ARVALID              ), // input wire s_axi_mem_arvalid
    .s_axi_mem_arready          (S_AXI_ARREADY              ), // output wire s_axi_mem_arready
    .s_axi_mem_rid              (S_AXI_RID                  ), // output wire [3 : 0] s_axi_mem_rid
    .s_axi_mem_rdata            (S_AXI_RDATA                ), // output wire [63 : 0] s_axi_mem_rdata
    .s_axi_mem_rresp            (S_AXI_RRESP                ), // output wire [1 : 0] s_axi_mem_rresp
    .s_axi_mem_rlast            (S_AXI_RLAST                ), // output wire s_axi_mem_rlast
    .s_axi_mem_rvalid           (S_AXI_RVALID               ), // output wire s_axi_mem_rvalid
    .s_axi_mem_rready           (S_AXI_RREADY               ), // input wire s_axi_mem_rready

    .mem_dq_i                   (linear_flash_dq_i          ), // input wire [15 : 0] mem_dq_i
    .mem_dq_o                   (linear_flash_dq_o          ), // output wire [15 : 0] mem_dq_o
    .mem_dq_t                   (linear_flash_dq_t          ), // output wire [15 : 0] mem_dq_t
    .mem_a                      ({unconnected_5,linear_flash_addr,unconnected_0}), // output wire [31 : 0] mem_a
    .mem_ce                     (                           ), // output wire [0 : 0] mem_ce
    .mem_cen                    (linear_flash_ce_n          ), // output wire [0 : 0] mem_cen
    .mem_oen                    (linear_flash_oen           ), // output wire [0 : 0] mem_oen
    .mem_wen                    (linear_flash_wen           ), // output wire mem_wen
    .mem_ben                    (                           ), // output wire [1 : 0] mem_ben
    .mem_qwen                   (                           ), // output wire [1 : 0] mem_qwen
    .mem_rpn                    (                           ), // output wire mem_rpn
    .mem_adv_ldn                (linear_flash_adv_ldn       ), // output wire mem_adv_ldn
    .mem_lbon                   (                           ), // output wire mem_lbon
    .mem_cken                   (                           ), // output wire mem_cken
    .mem_rnw                    (                           ), // output wire mem_rnw
    .mem_cre                    (                           ), // output wire mem_cre
    .mem_wait                   (1'b0                       )  // input wire [0 : 0] mem_wait
);


endmodule

