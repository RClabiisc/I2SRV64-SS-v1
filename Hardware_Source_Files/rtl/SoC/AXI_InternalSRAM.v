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
module AXI_InternalSRAM
(
    input wire                                  clk,
    input wire                                  rstn,

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
localparam INTSRAM_WIDTH        = 64;
localparam INTSRAM_DEPTH        = 8192;
localparam INTSRAM_SIZE         = 64*1024;
localparam INTSRAM_SIZE_BITS    = (INTSRAM_WIDTH*INTSRAM_DEPTH);
localparam ADDR_LEN             = $clog2(INTSRAM_SIZE);


/*****************
*  Local Wires  *
*****************/
wire        IntSRAM_bram_clk_a;
wire        IntSRAM_bram_rst_a;
wire        IntSRAM_bram_en_a;
wire [7:0]  IntSRAM_bram_we_a;
wire [31:0] IntSRAM_bram_addr_a;
wire [63:0] IntSRAM_bram_wrdata_a;
wire [63:0] IntSRAM_bram_rddata_a;
wire        IntSRAM_bram_clk_b;
wire        IntSRAM_bram_rst_b;
wire        IntSRAM_bram_en_b;
wire [7:0]  IntSRAM_bram_we_b;
wire [31:0] IntSRAM_bram_addr_b;
wire [63:0] IntSRAM_bram_wrdata_b;
wire [63:0] IntSRAM_bram_rddata_b;

assign IntSRAM_bram_addr_a[31:ADDR_LEN] = 0;
assign IntSRAM_bram_addr_b[31:ADDR_LEN] = 0;


/*************************
*  AXI BRAM Controller  *
*************************/
axi64_bram_ctrl_64KiB axi64_bram_ctrl_64KiB
(
    .s_axi_aclk                 (clk                                ), // input wire s_axi_aclk
    .s_axi_aresetn              (rstn                               ), // input wire s_axi_aresetn

    .s_axi_awid                 (S_AXI_AWID                         ), // input wire [3 : 0] s_axi_awid
    .s_axi_awaddr               (S_AXI_AWADDR[ADDR_LEN-1:0]         ), // input wire [15 : 0] s_axi_awaddr
    .s_axi_awlen                (S_AXI_AWLEN                        ), // input wire [7 : 0] s_axi_awlen
    .s_axi_awsize               (S_AXI_AWSIZE                       ), // input wire [2 : 0] s_axi_awsize
    .s_axi_awburst              (S_AXI_AWBURST                      ), // input wire [1 : 0] s_axi_awburst
    .s_axi_awlock               (S_AXI_AWLOCK                       ), // input wire s_axi_awlock
    .s_axi_awcache              (S_AXI_AWCACHE                      ), // input wire [3 : 0] s_axi_awcache
    .s_axi_awprot               (S_AXI_AWPROT                       ), // input wire [2 : 0] s_axi_awprot
    .s_axi_awvalid              (S_AXI_AWVALID                      ), // input wire s_axi_awvalid
    .s_axi_awready              (S_AXI_AWREADY                      ), // output wire s_axi_awready
    .s_axi_wdata                (S_AXI_WDATA                        ), // input wire [63 : 0] s_axi_wdata
    .s_axi_wstrb                (S_AXI_WSTRB                        ), // input wire [7 : 0] s_axi_wstrb
    .s_axi_wlast                (S_AXI_WLAST                        ), // input wire s_axi_wlast
    .s_axi_wvalid               (S_AXI_WVALID                       ), // input wire s_axi_wvalid
    .s_axi_wready               (S_AXI_WREADY                       ), // output wire s_axi_wready
    .s_axi_bid                  (S_AXI_BID                          ), // output wire [3 : 0] s_axi_bid
    .s_axi_bresp                (S_AXI_BRESP                        ), // output wire [1 : 0] s_axi_bresp
    .s_axi_bvalid               (S_AXI_BVALID                       ), // output wire s_axi_bvalid
    .s_axi_bready               (S_AXI_BREADY                       ), // input wire s_axi_bready
    .s_axi_arid                 (S_AXI_ARID                         ), // input wire [3 : 0] s_axi_arid
    .s_axi_araddr               (S_AXI_ARADDR[ADDR_LEN-1:0]         ), // input wire [15 : 0] s_axi_araddr
    .s_axi_arlen                (S_AXI_ARLEN                        ), // input wire [7 : 0] s_axi_arlen
    .s_axi_arsize               (S_AXI_ARSIZE                       ), // input wire [2 : 0] s_axi_arsize
    .s_axi_arburst              (S_AXI_ARBURST                      ), // input wire [1 : 0] s_axi_arburst
    .s_axi_arlock               (S_AXI_ARLOCK                       ), // input wire s_axi_arlock
    .s_axi_arcache              (S_AXI_ARCACHE                      ), // input wire [3 : 0] s_axi_arcache
    .s_axi_arprot               (S_AXI_ARPROT                       ), // input wire [2 : 0] s_axi_arprot
    .s_axi_arvalid              (S_AXI_ARVALID                      ), // input wire s_axi_arvalid
    .s_axi_arready              (S_AXI_ARREADY                      ), // output wire s_axi_arready
    .s_axi_rid                  (S_AXI_RID                          ), // output wire [3 : 0] s_axi_rid
    .s_axi_rdata                (S_AXI_RDATA                        ), // output wire [63 : 0] s_axi_rdata
    .s_axi_rresp                (S_AXI_RRESP                        ), // output wire [1 : 0] s_axi_rresp
    .s_axi_rlast                (S_AXI_RLAST                        ), // output wire s_axi_rlast
    .s_axi_rvalid               (S_AXI_RVALID                       ), // output wire s_axi_rvalid
    .s_axi_rready               (S_AXI_RREADY                       ), // input wire s_axi_rready

    .bram_rst_a                 (IntSRAM_bram_rst_a                 ), // output wire bram_rst_a
    .bram_clk_a                 (IntSRAM_bram_clk_a                 ), // output wire bram_clk_a
    .bram_en_a                  (IntSRAM_bram_en_a                  ), // output wire bram_en_a
    .bram_we_a                  (IntSRAM_bram_we_a                  ), // output wire [7 : 0] bram_we_a
    .bram_addr_a                (IntSRAM_bram_addr_a[ADDR_LEN-1:0]  ), // output wire [15 : 0] bram_addr_a
    .bram_wrdata_a              (IntSRAM_bram_wrdata_a              ), // output wire [63 : 0] bram_wrdata_a
    .bram_rddata_a              (IntSRAM_bram_rddata_a              ), // input wire [63 : 0] bram_rddata_a
    .bram_rst_b                 (IntSRAM_bram_rst_b                 ), // output wire bram_rst_b
    .bram_clk_b                 (IntSRAM_bram_clk_b                 ), // output wire bram_clk_b
    .bram_en_b                  (IntSRAM_bram_en_b                  ), // output wire bram_en_b
    .bram_we_b                  (IntSRAM_bram_we_b                  ), // output wire [7 : 0] bram_we_b
    .bram_addr_b                (IntSRAM_bram_addr_b[ADDR_LEN-1:0]  ), // output wire [15 : 0] bram_addr_b
    .bram_wrdata_b              (IntSRAM_bram_wrdata_b              ), // output wire [63 : 0] bram_wrdata_b
    .bram_rddata_b              (IntSRAM_bram_rddata_b              )  // input wire [63 : 0] bram_rddata_b
);


/*********************************
*  Block Memory DPROM 2048x64b  *
*********************************/
InternalSRAM_8192x64b InternalSRAM_8192x64b
(
    .clka                       (IntSRAM_bram_clk_a                 ), // input wire clka
    .rsta                       (IntSRAM_bram_rst_a                 ), // input wire rsta
    .ena                        (IntSRAM_bram_en_a                  ), // input wire ena
    .wea                        (IntSRAM_bram_we_a                  ), // input wire [7 : 0] wea
    .addra                      (IntSRAM_bram_addr_a                ), // input wire [31 : 0] addra
    .dina                       (IntSRAM_bram_wrdata_a              ), // input wire [63 : 0] dina
    .douta                      (IntSRAM_bram_rddata_a              ), // output wire [63 : 0] douta
    .clkb                       (IntSRAM_bram_clk_b                 ), // input wire clkb
    .rstb                       (IntSRAM_bram_rst_b                 ), // input wire rstb
    .enb                        (IntSRAM_bram_en_b                  ), // input wire enb
    .web                        (IntSRAM_bram_we_b                  ), // input wire [7 : 0] web
    .addrb                      (IntSRAM_bram_addr_b                ), // input wire [31 : 0] addrb
    .dinb                       (IntSRAM_bram_wrdata_b              ), // input wire [63 : 0] dinb
    .doutb                      (IntSRAM_bram_rddata_b              ), // output wire [63 : 0] doutb
    .rsta_busy                  (                                   ), // output wire rsta_busy
    .rstb_busy                  (                                   )  // output wire rstb_busy
);


endmodule

