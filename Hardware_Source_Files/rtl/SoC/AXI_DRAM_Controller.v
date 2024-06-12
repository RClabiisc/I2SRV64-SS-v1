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
module AXI_DRAM_Controller
(
    //Inputs from Board
    input  wire                                 clk_p,
    input  wire                                 clk_n,
    input  wire                                 reset,

    //Output clock & Reset to rest of the circuits
    output wire                                 sys_clk,
    output wire                                 sys_rst,
    output wire                                 interconnect_rstn,
    output wire                                 peripheral_rstn,

    output wire [13:0]                          ddr3_addr,
    output wire [2:0]                           ddr3_ba,
    output wire                                 ddr3_cas_n,
    output wire [0:0]                           ddr3_ck_n,
    output wire [0:0]                           ddr3_ck_p,
    output wire [0:0]                           ddr3_cke,
    output wire                                 ddr3_ras_n,
    output wire                                 ddr3_reset_n,
    output wire                                 ddr3_we_n,
    inout  wire [63:0]                          ddr3_dq,
    inout  wire [7:0]                           ddr3_dqs_n,
    inout  wire [7:0]                           ddr3_dqs_p,
    output wire [0:0]                           ddr3_cs_n,
    output wire [7:0]                           ddr3_dm,
    output wire [0:0]                           ddr3_odt,

    input  wire [3:0]                           S_AXI_AWID,
    input  wire [`C_AXI_L2_ADDR_WIDTH-1:0]      S_AXI_AWADDR,
    input  wire [7:0]                           S_AXI_AWLEN,
    input  wire [2:0]                           S_AXI_AWSIZE,
    input  wire [1:0]                           S_AXI_AWBURST,
    input  wire                                 S_AXI_AWLOCK,
    input  wire [3:0]                           S_AXI_AWCACHE,
    input  wire [2:0]                           S_AXI_AWPROT,
    input  wire [3:0]                           S_AXI_AWREGION,
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
    input  wire [3:0]                           S_AXI_ARREGION,
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
localparam ADDR_LEN             = 30;


/*****************
*  Local Wires  *
*****************/
wire                                ui_clk;
wire                                ui_clk_sync_rst;
wire                                ui_clk_locked;
wire                                ui_clk_rstn;

wire [3:0]                          M_AXI_AWID;
wire [`C_AXI_L2_ADDR_WIDTH-1:0]     M_AXI_AWADDR;
wire [7:0]                          M_AXI_AWLEN;
wire [2:0]                          M_AXI_AWSIZE;
wire [1:0]                          M_AXI_AWBURST;
wire                                M_AXI_AWLOCK;
wire [3:0]                          M_AXI_AWCACHE;
wire [2:0]                          M_AXI_AWPROT;
wire [3:0]                          M_AXI_AWREGION;
wire [3:0]                          M_AXI_AWQOS;
wire                                M_AXI_AWVALID;
wire                                M_AXI_AWREADY;
wire [`C_AXI_L2_DATA_WIDTH-1:0]     M_AXI_WDATA;
wire [`C_AXI_L2_DATA_WIDTH/8-1:0]   M_AXI_WSTRB;
wire                                M_AXI_WLAST;
wire                                M_AXI_WVALID;
wire                                M_AXI_WREADY;
wire [3:0]                          M_AXI_BID;
wire [1:0]                          M_AXI_BRESP;
wire                                M_AXI_BVALID;
wire                                M_AXI_BREADY;
wire [3:0]                          M_AXI_ARID;
wire [`C_AXI_L2_ADDR_WIDTH-1:0]     M_AXI_ARADDR;
wire [7:0]                          M_AXI_ARLEN;
wire [2:0]                          M_AXI_ARSIZE;
wire [1:0]                          M_AXI_ARBURST;
wire                                M_AXI_ARLOCK;
wire [3:0]                          M_AXI_ARCACHE;
wire [2:0]                          M_AXI_ARPROT;
wire [3:0]                          M_AXI_ARREGION;
wire [3:0]                          M_AXI_ARQOS;
wire                                M_AXI_ARVALID;
wire                                M_AXI_ARREADY;
wire [3:0]                          M_AXI_RID;
wire [`C_AXI_L2_DATA_WIDTH-1:0]     M_AXI_RDATA;
wire [1:0]                          M_AXI_RRESP;
wire                                M_AXI_RLAST;
wire                                M_AXI_RVALID;
wire                                M_AXI_RREADY;


/************************
*  Reset Sync for MIG  *
************************/
rst_ctrl rst_ctrl_mig
(
    .slowest_sync_clk           (ui_clk                     ), // input wire slowest_sync_clk
    .ext_reset_in               (ui_clk_sync_rst            ), // input wire ext_reset_in
    .aux_reset_in               (1'b0                       ), // input wire aux_reset_in
    .mb_debug_sys_rst           (1'b0                       ), // input wire mb_debug_sys_rst
    .dcm_locked                 (ui_clk_locked              ), // input wire dcm_locked
    .mb_reset                   (                           ), // output wire mb_reset
    .bus_struct_reset           (                           ), // output wire [0 : 0] bus_struct_reset
    .peripheral_reset           (                           ), // output wire [0 : 0] peripheral_reset
    .interconnect_aresetn       (                           ), // output wire [0 : 0] interconnect_aresetn
    .peripheral_aresetn         (ui_clk_rstn                )  // output wire [0 : 0] peripheral_aresetn
);


/****************************
*  AXI Clock Converter IP  *
****************************/
axi64_clkcnv_async axi64_clkcnv_mig
(
    .s_axi_aclk                 (sys_clk                    ), // input wire s_axi_aclk
    .s_axi_aresetn              (interconnect_rstn          ), // input wire s_axi_aresetn

    .s_axi_awid                 (S_AXI_AWID                 ), // input wire [3 : 0] s_axi_awid
    .s_axi_awaddr               (S_AXI_AWADDR               ), // input wire [63 : 0] s_axi_awaddr
    .s_axi_awlen                (S_AXI_AWLEN                ), // input wire [7 : 0] s_axi_awlen
    .s_axi_awsize               (S_AXI_AWSIZE               ), // input wire [2 : 0] s_axi_awsize
    .s_axi_awburst              (S_AXI_AWBURST              ), // input wire [1 : 0] s_axi_awburst
    .s_axi_awlock               (S_AXI_AWLOCK               ), // input wire [0 : 0] s_axi_awlock
    .s_axi_awcache              (S_AXI_AWCACHE              ), // input wire [3 : 0] s_axi_awcache
    .s_axi_awprot               (S_AXI_AWPROT               ), // input wire [2 : 0] s_axi_awprot
    .s_axi_awregion             (S_AXI_AWREGION             ), // input wire [3 : 0] s_axi_awregion
    .s_axi_awqos                (S_AXI_AWQOS                ), // input wire [3 : 0] s_axi_awqos
    .s_axi_awvalid              (S_AXI_AWVALID              ), // input wire s_axi_awvalid
    .s_axi_awready              (S_AXI_AWREADY              ), // output wire s_axi_awready
    .s_axi_wdata                (S_AXI_WDATA                ), // input wire [63 : 0] s_axi_wdata
    .s_axi_wstrb                (S_AXI_WSTRB                ), // input wire [7 : 0] s_axi_wstrb
    .s_axi_wlast                (S_AXI_WLAST                ), // input wire s_axi_wlast
    .s_axi_wvalid               (S_AXI_WVALID               ), // input wire s_axi_wvalid
    .s_axi_wready               (S_AXI_WREADY               ), // output wire s_axi_wready
    .s_axi_bid                  (S_AXI_BID                  ), // output wire [3 : 0] s_axi_bid
    .s_axi_bresp                (S_AXI_BRESP                ), // output wire [1 : 0] s_axi_bresp
    .s_axi_bvalid               (S_AXI_BVALID               ), // output wire s_axi_bvalid
    .s_axi_bready               (S_AXI_BREADY               ), // input wire s_axi_bready
    .s_axi_arid                 (S_AXI_ARID                 ), // input wire [3 : 0] s_axi_arid
    .s_axi_araddr               (S_AXI_ARADDR               ), // input wire [63 : 0] s_axi_araddr
    .s_axi_arlen                (S_AXI_ARLEN                ), // input wire [7 : 0] s_axi_arlen
    .s_axi_arsize               (S_AXI_ARSIZE               ), // input wire [2 : 0] s_axi_arsize
    .s_axi_arburst              (S_AXI_ARBURST              ), // input wire [1 : 0] s_axi_arburst
    .s_axi_arlock               (S_AXI_ARLOCK               ), // input wire [0 : 0] s_axi_arlock
    .s_axi_arcache              (S_AXI_ARCACHE              ), // input wire [3 : 0] s_axi_arcache
    .s_axi_arprot               (S_AXI_ARPROT               ), // input wire [2 : 0] s_axi_arprot
    .s_axi_arregion             (S_AXI_ARREGION             ), // input wire [3 : 0] s_axi_arregion
    .s_axi_arqos                (S_AXI_ARQOS                ), // input wire [3 : 0] s_axi_arqos
    .s_axi_arvalid              (S_AXI_ARVALID              ), // input wire s_axi_arvalid
    .s_axi_arready              (S_AXI_ARREADY              ), // output wire s_axi_arready
    .s_axi_rid                  (S_AXI_RID                  ), // output wire [3 : 0] s_axi_rid
    .s_axi_rdata                (S_AXI_RDATA                ), // output wire [63 : 0] s_axi_rdata
    .s_axi_rresp                (S_AXI_RRESP                ), // output wire [1 : 0] s_axi_rresp
    .s_axi_rlast                (S_AXI_RLAST                ), // output wire s_axi_rlast
    .s_axi_rvalid               (S_AXI_RVALID               ), // output wire s_axi_rvalid
    .s_axi_rready               (S_AXI_RREADY               ), // input wire s_axi_rready

    .m_axi_aclk                 (ui_clk                     ), // input wire m_axi_aclk
    .m_axi_aresetn              (ui_clk_rstn                ), // input wire m_axi_aresetn

    .m_axi_awid                 (M_AXI_AWID                 ), // output wire [3 : 0] m_axi_awid
    .m_axi_awaddr               (M_AXI_AWADDR               ), // output wire [63 : 0] m_axi_awaddr
    .m_axi_awlen                (M_AXI_AWLEN                ), // output wire [7 : 0] m_axi_awlen
    .m_axi_awsize               (M_AXI_AWSIZE               ), // output wire [2 : 0] m_axi_awsize
    .m_axi_awburst              (M_AXI_AWBURST              ), // output wire [1 : 0] m_axi_awburst
    .m_axi_awlock               (M_AXI_AWLOCK               ), // output wire [0 : 0] m_axi_awlock
    .m_axi_awcache              (M_AXI_AWCACHE              ), // output wire [3 : 0] m_axi_awcache
    .m_axi_awprot               (M_AXI_AWPROT               ), // output wire [2 : 0] m_axi_awprot
    .m_axi_awregion             (M_AXI_AWREGION             ), // output wire [3 : 0] m_axi_awregion
    .m_axi_awqos                (M_AXI_AWQOS                ), // output wire [3 : 0] m_axi_awqos
    .m_axi_awvalid              (M_AXI_AWVALID              ), // output wire m_axi_awvalid
    .m_axi_awready              (M_AXI_AWREADY              ), // input wire m_axi_awready
    .m_axi_wdata                (M_AXI_WDATA                ), // output wire [63 : 0] m_axi_wdata
    .m_axi_wstrb                (M_AXI_WSTRB                ), // output wire [7 : 0] m_axi_wstrb
    .m_axi_wlast                (M_AXI_WLAST                ), // output wire m_axi_wlast
    .m_axi_wvalid               (M_AXI_WVALID               ), // output wire m_axi_wvalid
    .m_axi_wready               (M_AXI_WREADY               ), // input wire m_axi_wready
    .m_axi_bid                  (M_AXI_BID                  ), // input wire [3 : 0] m_axi_bid
    .m_axi_bresp                (M_AXI_BRESP                ), // input wire [1 : 0] m_axi_bresp
    .m_axi_bvalid               (M_AXI_BVALID               ), // input wire m_axi_bvalid
    .m_axi_bready               (M_AXI_BREADY               ), // output wire m_axi_bready
    .m_axi_arid                 (M_AXI_ARID                 ), // output wire [3 : 0] m_axi_arid
    .m_axi_araddr               (M_AXI_ARADDR               ), // output wire [63 : 0] m_axi_araddr
    .m_axi_arlen                (M_AXI_ARLEN                ), // output wire [7 : 0] m_axi_arlen
    .m_axi_arsize               (M_AXI_ARSIZE               ), // output wire [2 : 0] m_axi_arsize
    .m_axi_arburst              (M_AXI_ARBURST              ), // output wire [1 : 0] m_axi_arburst
    .m_axi_arlock               (M_AXI_ARLOCK               ), // output wire [0 : 0] m_axi_arlock
    .m_axi_arcache              (M_AXI_ARCACHE              ), // output wire [3 : 0] m_axi_arcache
    .m_axi_arprot               (M_AXI_ARPROT               ), // output wire [2 : 0] m_axi_arprot
    .m_axi_arregion             (M_AXI_ARREGION             ), // output wire [3 : 0] m_axi_arregion
    .m_axi_arqos                (M_AXI_ARQOS                ), // output wire [3 : 0] m_axi_arqos
    .m_axi_arvalid              (M_AXI_ARVALID              ), // output wire m_axi_arvalid
    .m_axi_arready              (M_AXI_ARREADY              ), // input wire m_axi_arready
    .m_axi_rid                  (M_AXI_RID                  ), // input wire [3 : 0] m_axi_rid
    .m_axi_rdata                (M_AXI_RDATA                ), // input wire [63 : 0] m_axi_rdata
    .m_axi_rresp                (M_AXI_RRESP                ), // input wire [1 : 0] m_axi_rresp
    .m_axi_rlast                (M_AXI_RLAST                ), // input wire m_axi_rlast
    .m_axi_rvalid               (M_AXI_RVALID               ), // input wire m_axi_rvalid
    .m_axi_rready               (M_AXI_RREADY               )  // output wire m_axi_rready
);


/****************
*  AXI MIG IP  *
****************/
axi64_dramctrl_vc707 axi64_dramctrl_vc707
(
    // Memory interface ports
    .ddr3_addr                  (ddr3_addr                  ), // output [13:0]      ddr3_addr
    .ddr3_ba                    (ddr3_ba                    ), // output [2:0]     ddr3_ba
    .ddr3_cas_n                 (ddr3_cas_n                 ), // output            ddr3_cas_n
    .ddr3_ck_n                  (ddr3_ck_n                  ), // output [0:0]       ddr3_ck_n
    .ddr3_ck_p                  (ddr3_ck_p                  ), // output [0:0]       ddr3_ck_p
    .ddr3_cke                   (ddr3_cke                   ), // output [0:0]        ddr3_cke
    .ddr3_ras_n                 (ddr3_ras_n                 ), // output            ddr3_ras_n
    .ddr3_reset_n               (ddr3_reset_n               ), // output          ddr3_reset_n
    .ddr3_we_n                  (ddr3_we_n                  ), // output         ddr3_we_n
    .ddr3_dq                    (ddr3_dq                    ), // inout [63:0]     ddr3_dq
    .ddr3_dqs_n                 (ddr3_dqs_n                 ), // inout [7:0]       ddr3_dqs_n
    .ddr3_dqs_p                 (ddr3_dqs_p                 ), // inout [7:0]       ddr3_dqs_p
    .ddr3_cs_n                  (ddr3_cs_n                  ), // output [0:0]       ddr3_cs_n
    .ddr3_dm                    (ddr3_dm                    ), // output [7:0]     ddr3_dm
    .ddr3_odt                   (ddr3_odt                   ), // output [0:0]        ddr3_odt

    .init_calib_complete        (                           ), // output           init_calib_complete
    .device_temp                (                           ),

    // Application interface ports
    .ui_clk                     (ui_clk                     ), // output            ui_clk
    .ui_clk_sync_rst            (ui_clk_sync_rst            ), // output           ui_clk_sync_rst
    .mmcm_locked                (ui_clk_locked              ), // output           mmcm_locked
    .aresetn                    (ui_clk_rstn                ), // input            aresetn
    .app_sr_req                 (1'b0                       ), // input         app_sr_req
    .app_ref_req                (1'b0                       ), // input            app_ref_req
    .app_zq_req                 (1'b0                       ), // input         app_zq_req
    .app_sr_active              (                           ), // output         app_sr_active
    .app_ref_ack                (                           ), // output           app_ref_ack
    .app_zq_ack                 (                           ), // output            app_zq_ack

    // Slave Interface Write Address Ports
    .s_axi_awid                 (M_AXI_AWID                 ), // input [3:0]           s_axi_awid
    .s_axi_awaddr               (M_AXI_AWADDR[ADDR_LEN-1:0] ), // input [29:0]            s_axi_awaddr
    .s_axi_awlen                (M_AXI_AWLEN                ), // input [7:0]          s_axi_awlen
    .s_axi_awsize               (M_AXI_AWSIZE               ), // input [2:0]         s_axi_awsize
    .s_axi_awburst              (M_AXI_AWBURST              ), // input [1:0]            s_axi_awburst
    .s_axi_awlock               (M_AXI_AWLOCK               ), // input [0:0]         s_axi_awlock
    .s_axi_awcache              (M_AXI_AWCACHE              ), // input [3:0]            s_axi_awcache
    .s_axi_awprot               (M_AXI_AWPROT               ), // input [2:0]         s_axi_awprot
    .s_axi_awqos                (M_AXI_AWQOS                ), // input [3:0]          s_axi_awqos
    .s_axi_awvalid              (M_AXI_AWVALID              ), // input          s_axi_awvalid
    .s_axi_awready              (M_AXI_AWREADY              ), // output         s_axi_awready
    .s_axi_wdata                (M_AXI_WDATA                ), // input [63:0]         s_axi_wdata
    .s_axi_wstrb                (M_AXI_WSTRB                ), // input [7:0]          s_axi_wstrb
    .s_axi_wlast                (M_AXI_WLAST                ), // input            s_axi_wlast
    .s_axi_wvalid               (M_AXI_WVALID               ), // input           s_axi_wvalid
    .s_axi_wready               (M_AXI_WREADY               ), // output          s_axi_wready
    .s_axi_bid                  (M_AXI_BID                  ), // output [3:0]           s_axi_bid
    .s_axi_bresp                (M_AXI_BRESP                ), // output [1:0]         s_axi_bresp
    .s_axi_bvalid               (M_AXI_BVALID               ), // output          s_axi_bvalid
    .s_axi_bready               (M_AXI_BREADY               ), // input           s_axi_bready
    .s_axi_arid                 (M_AXI_ARID                 ), // input [3:0]           s_axi_arid
    .s_axi_araddr               (M_AXI_ARADDR[ADDR_LEN-1:0] ), // input [29:0]            s_axi_araddr
    .s_axi_arlen                (M_AXI_ARLEN                ), // input [7:0]          s_axi_arlen
    .s_axi_arsize               (M_AXI_ARSIZE               ), // input [2:0]         s_axi_arsize
    .s_axi_arburst              (M_AXI_ARBURST              ), // input [1:0]            s_axi_arburst
    .s_axi_arlock               (M_AXI_ARLOCK               ), // input [0:0]         s_axi_arlock
    .s_axi_arcache              (M_AXI_ARCACHE              ), // input [3:0]            s_axi_arcache
    .s_axi_arprot               (M_AXI_ARPROT               ), // input [2:0]         s_axi_arprot
    .s_axi_arqos                (M_AXI_ARQOS                ), // input [3:0]          s_axi_arqos
    .s_axi_arvalid              (M_AXI_ARVALID              ), // input          s_axi_arvalid
    .s_axi_arready              (M_AXI_ARREADY              ), // output         s_axi_arready
    .s_axi_rid                  (M_AXI_RID                  ), // output [3:0]           s_axi_rid
    .s_axi_rdata                (M_AXI_RDATA                ), // output [63:0]            s_axi_rdata
    .s_axi_rresp                (M_AXI_RRESP                ), // output [1:0]         s_axi_rresp
    .s_axi_rlast                (M_AXI_RLAST                ), // output           s_axi_rlast
    .s_axi_rvalid               (M_AXI_RVALID               ), // output          s_axi_rvalid
    .s_axi_rready               (M_AXI_RREADY               ), // input           s_axi_rready

     // System Clock Ports
    .sys_clk_p                  (clk_p                      ), // input              sys_clk_p
    .sys_clk_n                  (clk_n                      ), // input              sys_clk_n
    .sys_rst                    (reset                      )  // input              sys_rst
);


/********************************
*  Clk Wizard for Rest Circuits *
********************************/
//----------------------------------------------------------------------------
//  Output     Output      Phase    Duty Cycle   Pk-to-Pk     Phase
//   Clock     Freq (MHz)  (degrees)    (%)     Jitter (ps)  Error (ps)
//----------------------------------------------------------------------------
// _sys_clk__32.00000______0.000______50.0______141.539_____89.971
//
//----------------------------------------------------------------------------
// Input Clock   Freq (MHz)    Input Jitter (UI)
//----------------------------------------------------------------------------
// __primary_________200.000____________0.010

wire sys_clk_locked;
sys_clk_ctrl clk_ctrl
(
    .sys_clk                    (sys_clk                    ),  // output sys_clk
    .locked                     (sys_clk_locked             ),  // output locked
    .clk_in1                    (ui_clk                     )   // input clk_in1
);

/********************************
*  Reset Sync for Rest Circuits *
********************************/
rst_ctrl rst_ctrl
(
    .slowest_sync_clk           (sys_clk                    ), // input wire slowest_sync_clk
    .ext_reset_in               (reset                      ), // input wire ext_reset_in
    .aux_reset_in               (1'b0                       ), // input wire aux_reset_in
    .mb_debug_sys_rst           (1'b0                       ), // input wire mb_debug_sys_rst
    .dcm_locked                 (sys_clk_locked             ), // input wire dcm_locked
    .mb_reset                   (sys_rst                    ), // output wire mb_reset
    .bus_struct_reset           (                           ), // output wire [0 : 0] bus_struct_reset
    .peripheral_reset           (                           ), // output wire [0 : 0] peripheral_reset
    .interconnect_aresetn       (interconnect_rstn          ), // output wire [0 : 0] interconnect_aresetn
    .peripheral_aresetn         (peripheral_rstn            )  // output wire [0 : 0] peripheral_aresetn
);


endmodule
