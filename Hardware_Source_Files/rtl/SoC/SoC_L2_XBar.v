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
module SoC_L2_XBar
(
    input  wire  clk,
    input  wire  rstn,

    //Master Bus 0 (DBUS)
    input  wire [3:0]                           M_AXI_DBUS_AWID,
    input  wire [`C_AXI_L2_ADDR_WIDTH-1:0]      M_AXI_DBUS_AWADDR,
    input  wire [7:0]                           M_AXI_DBUS_AWLEN,
    input  wire [2:0]                           M_AXI_DBUS_AWSIZE,
    input  wire [1:0]                           M_AXI_DBUS_AWBURST,
    input  wire                                 M_AXI_DBUS_AWLOCK,
    input  wire [3:0]                           M_AXI_DBUS_AWCACHE,
    input  wire [3:0]                           M_AXI_DBUS_AWREGION,
    input  wire [2:0]                           M_AXI_DBUS_AWPROT,
    input  wire [3:0]                           M_AXI_DBUS_AWQOS,
    input  wire                                 M_AXI_DBUS_AWVALID,
    output wire                                 M_AXI_DBUS_AWREADY,
    input  wire [`C_AXI_L2_DATA_WIDTH-1:0]      M_AXI_DBUS_WDATA,
    input  wire [`C_AXI_L2_DATA_WIDTH/8-1:0]    M_AXI_DBUS_WSTRB,
    input  wire                                 M_AXI_DBUS_WLAST,
    input  wire                                 M_AXI_DBUS_WVALID,
    output wire                                 M_AXI_DBUS_WREADY,
    output wire [3:0]                           M_AXI_DBUS_BID,
    output wire [1:0]                           M_AXI_DBUS_BRESP,
    output wire                                 M_AXI_DBUS_BVALID,
    input  wire                                 M_AXI_DBUS_BREADY,
    input  wire [3:0]                           M_AXI_DBUS_ARID,
    input  wire [`C_AXI_L2_ADDR_WIDTH-1:0]      M_AXI_DBUS_ARADDR,
    input  wire [7:0]                           M_AXI_DBUS_ARLEN,
    input  wire [2:0]                           M_AXI_DBUS_ARSIZE,
    input  wire [1:0]                           M_AXI_DBUS_ARBURST,
    input  wire                                 M_AXI_DBUS_ARLOCK,
    input  wire [3:0]                           M_AXI_DBUS_ARCACHE,
    input  wire [2:0]                           M_AXI_DBUS_ARPROT,
    input  wire [3:0]                           M_AXI_DBUS_ARREGION,
    input  wire [3:0]                           M_AXI_DBUS_ARQOS,
    input  wire                                 M_AXI_DBUS_ARVALID,
    output wire                                 M_AXI_DBUS_ARREADY,
    output wire [3:0]                           M_AXI_DBUS_RID,
    output wire [`C_AXI_L2_DATA_WIDTH-1:0]      M_AXI_DBUS_RDATA,
    output wire [1:0]                           M_AXI_DBUS_RRESP,
    output wire                                 M_AXI_DBUS_RLAST,
    output wire                                 M_AXI_DBUS_RVALID,
    input  wire                                 M_AXI_DBUS_RREADY,

    //Master Bus 1 (IBUS)
    input  wire [3:0]                           M_AXI_IBUS_AWID,
    input  wire [`C_AXI_L2_ADDR_WIDTH-1:0]      M_AXI_IBUS_AWADDR,
    input  wire [7:0]                           M_AXI_IBUS_AWLEN,
    input  wire [2:0]                           M_AXI_IBUS_AWSIZE,
    input  wire [1:0]                           M_AXI_IBUS_AWBURST,
    input  wire                                 M_AXI_IBUS_AWLOCK,
    input  wire [3:0]                           M_AXI_IBUS_AWCACHE,
    input  wire [2:0]                           M_AXI_IBUS_AWPROT,
    input  wire [3:0]                           M_AXI_IBUS_AWREGION,
    input  wire [3:0]                           M_AXI_IBUS_AWQOS,
    input  wire                                 M_AXI_IBUS_AWVALID,
    output wire                                 M_AXI_IBUS_AWREADY,
    input  wire [`C_AXI_L2_DATA_WIDTH-1:0]      M_AXI_IBUS_WDATA,
    input  wire [`C_AXI_L2_DATA_WIDTH/8-1:0]    M_AXI_IBUS_WSTRB,
    input  wire                                 M_AXI_IBUS_WLAST,
    input  wire                                 M_AXI_IBUS_WVALID,
    output wire                                 M_AXI_IBUS_WREADY,
    output wire [3:0]                           M_AXI_IBUS_BID,
    output wire [1:0]                           M_AXI_IBUS_BRESP,
    output wire                                 M_AXI_IBUS_BVALID,
    input  wire                                 M_AXI_IBUS_BREADY,
    input  wire [3:0]                           M_AXI_IBUS_ARID,
    input  wire [`C_AXI_L2_ADDR_WIDTH-1:0]      M_AXI_IBUS_ARADDR,
    input  wire [7:0]                           M_AXI_IBUS_ARLEN,
    input  wire [2:0]                           M_AXI_IBUS_ARSIZE,
    input  wire [1:0]                           M_AXI_IBUS_ARBURST,
    input  wire                                 M_AXI_IBUS_ARLOCK,
    input  wire [3:0]                           M_AXI_IBUS_ARCACHE,
    input  wire [2:0]                           M_AXI_IBUS_ARPROT,
    input  wire [3:0]                           M_AXI_IBUS_ARREGION,
    input  wire [3:0]                           M_AXI_IBUS_ARQOS,
    input  wire                                 M_AXI_IBUS_ARVALID,
    output wire                                 M_AXI_IBUS_ARREADY,
    output wire [3:0]                           M_AXI_IBUS_RID,
    output wire [`C_AXI_L2_DATA_WIDTH-1:0]      M_AXI_IBUS_RDATA,
    output wire [1:0]                           M_AXI_IBUS_RRESP,
    output wire                                 M_AXI_IBUS_RLAST,
    output wire                                 M_AXI_IBUS_RVALID,
    input  wire                                 M_AXI_IBUS_RREADY,

    //Master Bus 2 (JTAG Debug)
    input  wire [3:0]                           M_AXI_DEBUG_AWID,
    input  wire [`C_AXI_L2_ADDR_WIDTH-1:0]      M_AXI_DEBUG_AWADDR,
    input  wire [7:0]                           M_AXI_DEBUG_AWLEN,
    input  wire [2:0]                           M_AXI_DEBUG_AWSIZE,
    input  wire [1:0]                           M_AXI_DEBUG_AWBURST,
    input  wire                                 M_AXI_DEBUG_AWLOCK,
    input  wire [3:0]                           M_AXI_DEBUG_AWCACHE,
    input  wire [2:0]                           M_AXI_DEBUG_AWPROT,
    input  wire [3:0]                           M_AXI_DEBUG_AWREGION,
    input  wire [3:0]                           M_AXI_DEBUG_AWQOS,
    input  wire                                 M_AXI_DEBUG_AWVALID,
    output wire                                 M_AXI_DEBUG_AWREADY,
    input  wire [`C_AXI_L2_DATA_WIDTH-1:0]      M_AXI_DEBUG_WDATA,
    input  wire [`C_AXI_L2_DATA_WIDTH/8-1:0]    M_AXI_DEBUG_WSTRB,
    input  wire                                 M_AXI_DEBUG_WLAST,
    input  wire                                 M_AXI_DEBUG_WVALID,
    output wire                                 M_AXI_DEBUG_WREADY,
    output wire [3:0]                           M_AXI_DEBUG_BID,
    output wire [1:0]                           M_AXI_DEBUG_BRESP,
    output wire                                 M_AXI_DEBUG_BVALID,
    input  wire                                 M_AXI_DEBUG_BREADY,
    input  wire [3:0]                           M_AXI_DEBUG_ARID,
    input  wire [`C_AXI_L2_ADDR_WIDTH-1:0]      M_AXI_DEBUG_ARADDR,
    input  wire [7:0]                           M_AXI_DEBUG_ARLEN,
    input  wire [2:0]                           M_AXI_DEBUG_ARSIZE,
    input  wire [1:0]                           M_AXI_DEBUG_ARBURST,
    input  wire                                 M_AXI_DEBUG_ARLOCK,
    input  wire [3:0]                           M_AXI_DEBUG_ARCACHE,
    input  wire [2:0]                           M_AXI_DEBUG_ARPROT,
    input  wire [3:0]                           M_AXI_DEBUG_ARREGION,
    input  wire [3:0]                           M_AXI_DEBUG_ARQOS,
    input  wire                                 M_AXI_DEBUG_ARVALID,
    output wire                                 M_AXI_DEBUG_ARREADY,
    output wire [3:0]                           M_AXI_DEBUG_RID,
    output wire [`C_AXI_L2_DATA_WIDTH-1:0]      M_AXI_DEBUG_RDATA,
    output wire [1:0]                           M_AXI_DEBUG_RRESP,
    output wire                                 M_AXI_DEBUG_RLAST,
    output wire                                 M_AXI_DEBUG_RVALID,
    input  wire                                 M_AXI_DEBUG_RREADY,

    //Slave 0 (Boot ROM)
    output wire [3:0]                           S_AXI_BOOTROM_AWID,
    output wire [`C_AXI_L2_ADDR_WIDTH-1:0]      S_AXI_BOOTROM_AWADDR,
    output wire [7:0]                           S_AXI_BOOTROM_AWLEN,
    output wire [2:0]                           S_AXI_BOOTROM_AWSIZE,
    output wire [1:0]                           S_AXI_BOOTROM_AWBURST,
    output wire                                 S_AXI_BOOTROM_AWLOCK,
    output wire [3:0]                           S_AXI_BOOTROM_AWCACHE,
    output wire [2:0]                           S_AXI_BOOTROM_AWPROT,
    output wire [3:0]                           S_AXI_BOOTROM_AWREGION,
    output wire [3:0]                           S_AXI_BOOTROM_AWQOS,
    output wire                                 S_AXI_BOOTROM_AWVALID,
    input  wire                                 S_AXI_BOOTROM_AWREADY,
    output wire [`C_AXI_L2_DATA_WIDTH-1:0]      S_AXI_BOOTROM_WDATA,
    output wire [`C_AXI_L2_DATA_WIDTH/8-1:0]    S_AXI_BOOTROM_WSTRB,
    output wire                                 S_AXI_BOOTROM_WLAST,
    output wire                                 S_AXI_BOOTROM_WVALID,
    input  wire                                 S_AXI_BOOTROM_WREADY,
    input  wire [3:0]                           S_AXI_BOOTROM_BID,
    input  wire [1:0]                           S_AXI_BOOTROM_BRESP,
    input  wire                                 S_AXI_BOOTROM_BVALID,
    output wire                                 S_AXI_BOOTROM_BREADY,
    output wire [3:0]                           S_AXI_BOOTROM_ARID,
    output wire [`C_AXI_L2_ADDR_WIDTH-1:0]      S_AXI_BOOTROM_ARADDR,
    output wire [7:0]                           S_AXI_BOOTROM_ARLEN,
    output wire [2:0]                           S_AXI_BOOTROM_ARSIZE,
    output wire [1:0]                           S_AXI_BOOTROM_ARBURST,
    output wire                                 S_AXI_BOOTROM_ARLOCK,
    output wire [3:0]                           S_AXI_BOOTROM_ARCACHE,
    output wire [2:0]                           S_AXI_BOOTROM_ARPROT,
    output wire [3:0]                           S_AXI_BOOTROM_ARREGION,
    output wire [3:0]                           S_AXI_BOOTROM_ARQOS,
    output wire                                 S_AXI_BOOTROM_ARVALID,
    input  wire                                 S_AXI_BOOTROM_ARREADY,
    input  wire [3:0]                           S_AXI_BOOTROM_RID,
    input  wire [`C_AXI_L2_DATA_WIDTH-1:0]      S_AXI_BOOTROM_RDATA,
    input  wire [1:0]                           S_AXI_BOOTROM_RRESP,
    input  wire                                 S_AXI_BOOTROM_RLAST,
    input  wire                                 S_AXI_BOOTROM_RVALID,
    output wire                                 S_AXI_BOOTROM_RREADY,

    //Slave 1 (Internal SRAM)
    output wire [3:0]                           S_AXI_INTSRAM_AWID,
    output wire [`C_AXI_L2_ADDR_WIDTH-1:0]      S_AXI_INTSRAM_AWADDR,
    output wire [7:0]                           S_AXI_INTSRAM_AWLEN,
    output wire [2:0]                           S_AXI_INTSRAM_AWSIZE,
    output wire [1:0]                           S_AXI_INTSRAM_AWBURST,
    output wire                                 S_AXI_INTSRAM_AWLOCK,
    output wire [3:0]                           S_AXI_INTSRAM_AWCACHE,
    output wire [2:0]                           S_AXI_INTSRAM_AWPROT,
    output wire [3:0]                           S_AXI_INTSRAM_AWREGION,
    output wire [3:0]                           S_AXI_INTSRAM_AWQOS,
    output wire                                 S_AXI_INTSRAM_AWVALID,
    input  wire                                 S_AXI_INTSRAM_AWREADY,
    output wire [`C_AXI_L2_DATA_WIDTH-1:0]      S_AXI_INTSRAM_WDATA,
    output wire [`C_AXI_L2_DATA_WIDTH/8-1:0]    S_AXI_INTSRAM_WSTRB,
    output wire                                 S_AXI_INTSRAM_WLAST,
    output wire                                 S_AXI_INTSRAM_WVALID,
    input  wire                                 S_AXI_INTSRAM_WREADY,
    input  wire [3:0]                           S_AXI_INTSRAM_BID,
    input  wire [1:0]                           S_AXI_INTSRAM_BRESP,
    input  wire                                 S_AXI_INTSRAM_BVALID,
    output wire                                 S_AXI_INTSRAM_BREADY,
    output wire [3:0]                           S_AXI_INTSRAM_ARID,
    output wire [`C_AXI_L2_ADDR_WIDTH-1:0]      S_AXI_INTSRAM_ARADDR,
    output wire [7:0]                           S_AXI_INTSRAM_ARLEN,
    output wire [2:0]                           S_AXI_INTSRAM_ARSIZE,
    output wire [1:0]                           S_AXI_INTSRAM_ARBURST,
    output wire                                 S_AXI_INTSRAM_ARLOCK,
    output wire [3:0]                           S_AXI_INTSRAM_ARCACHE,
    output wire [2:0]                           S_AXI_INTSRAM_ARPROT,
    output wire [3:0]                           S_AXI_INTSRAM_ARREGION,
    output wire [3:0]                           S_AXI_INTSRAM_ARQOS,
    output wire                                 S_AXI_INTSRAM_ARVALID,
    input  wire                                 S_AXI_INTSRAM_ARREADY,
    input  wire [3:0]                           S_AXI_INTSRAM_RID,
    input  wire [`C_AXI_L2_DATA_WIDTH-1:0]      S_AXI_INTSRAM_RDATA,
    input  wire [1:0]                           S_AXI_INTSRAM_RRESP,
    input  wire                                 S_AXI_INTSRAM_RLAST,
    input  wire                                 S_AXI_INTSRAM_RVALID,
    output wire                                 S_AXI_INTSRAM_RREADY,

    //Slave 2 (L3 Peripheral XBar)
    output wire [3:0]                           S_AXI_L3PERI_AWID,
    output wire [`C_AXI_L2_ADDR_WIDTH-1:0]      S_AXI_L3PERI_AWADDR,
    output wire [7:0]                           S_AXI_L3PERI_AWLEN,
    output wire [2:0]                           S_AXI_L3PERI_AWSIZE,
    output wire [1:0]                           S_AXI_L3PERI_AWBURST,
    output wire                                 S_AXI_L3PERI_AWLOCK,
    output wire [3:0]                           S_AXI_L3PERI_AWCACHE,
    output wire [2:0]                           S_AXI_L3PERI_AWPROT,
    output wire [3:0]                           S_AXI_L3PERI_AWREGION,
    output wire [3:0]                           S_AXI_L3PERI_AWQOS,
    output wire                                 S_AXI_L3PERI_AWVALID,
    input  wire                                 S_AXI_L3PERI_AWREADY,
    output wire [`C_AXI_L2_DATA_WIDTH-1:0]      S_AXI_L3PERI_WDATA,
    output wire [`C_AXI_L2_DATA_WIDTH/8-1:0]    S_AXI_L3PERI_WSTRB,
    output wire                                 S_AXI_L3PERI_WLAST,
    output wire                                 S_AXI_L3PERI_WVALID,
    input  wire                                 S_AXI_L3PERI_WREADY,
    input  wire [3:0]                           S_AXI_L3PERI_BID,
    input  wire [1:0]                           S_AXI_L3PERI_BRESP,
    input  wire                                 S_AXI_L3PERI_BVALID,
    output wire                                 S_AXI_L3PERI_BREADY,
    output wire [3:0]                           S_AXI_L3PERI_ARID,
    output wire [`C_AXI_L2_ADDR_WIDTH-1:0]      S_AXI_L3PERI_ARADDR,
    output wire [7:0]                           S_AXI_L3PERI_ARLEN,
    output wire [2:0]                           S_AXI_L3PERI_ARSIZE,
    output wire [1:0]                           S_AXI_L3PERI_ARBURST,
    output wire                                 S_AXI_L3PERI_ARLOCK,
    output wire [3:0]                           S_AXI_L3PERI_ARCACHE,
    output wire [2:0]                           S_AXI_L3PERI_ARPROT,
    output wire [3:0]                           S_AXI_L3PERI_ARREGION,
    output wire [3:0]                           S_AXI_L3PERI_ARQOS,
    output wire                                 S_AXI_L3PERI_ARVALID,
    input  wire                                 S_AXI_L3PERI_ARREADY,
    input  wire [3:0]                           S_AXI_L3PERI_RID,
    input  wire [`C_AXI_L2_DATA_WIDTH-1:0]      S_AXI_L3PERI_RDATA,
    input  wire [1:0]                           S_AXI_L3PERI_RRESP,
    input  wire                                 S_AXI_L3PERI_RLAST,
    input  wire                                 S_AXI_L3PERI_RVALID,
    output wire                                 S_AXI_L3PERI_RREADY,

    //Slave 3 (Flash Controller)
    output wire [3:0]                           S_AXI_FLASH_AWID,
    output wire [`C_AXI_L2_ADDR_WIDTH-1:0]      S_AXI_FLASH_AWADDR,
    output wire [7:0]                           S_AXI_FLASH_AWLEN,
    output wire [2:0]                           S_AXI_FLASH_AWSIZE,
    output wire [1:0]                           S_AXI_FLASH_AWBURST,
    output wire                                 S_AXI_FLASH_AWLOCK,
    output wire [3:0]                           S_AXI_FLASH_AWCACHE,
    output wire [2:0]                           S_AXI_FLASH_AWPROT,
    output wire [3:0]                           S_AXI_FLASH_AWREGION,
    output wire [3:0]                           S_AXI_FLASH_AWQOS,
    output wire                                 S_AXI_FLASH_AWVALID,
    input  wire                                 S_AXI_FLASH_AWREADY,
    output wire [`C_AXI_L2_DATA_WIDTH-1:0]      S_AXI_FLASH_WDATA,
    output wire [`C_AXI_L2_DATA_WIDTH/8-1:0]    S_AXI_FLASH_WSTRB,
    output wire                                 S_AXI_FLASH_WLAST,
    output wire                                 S_AXI_FLASH_WVALID,
    input  wire                                 S_AXI_FLASH_WREADY,
    input  wire [3:0]                           S_AXI_FLASH_BID,
    input  wire [1:0]                           S_AXI_FLASH_BRESP,
    input  wire                                 S_AXI_FLASH_BVALID,
    output wire                                 S_AXI_FLASH_BREADY,
    output wire [3:0]                           S_AXI_FLASH_ARID,
    output wire [`C_AXI_L2_ADDR_WIDTH-1:0]      S_AXI_FLASH_ARADDR,
    output wire [7:0]                           S_AXI_FLASH_ARLEN,
    output wire [2:0]                           S_AXI_FLASH_ARSIZE,
    output wire [1:0]                           S_AXI_FLASH_ARBURST,
    output wire                                 S_AXI_FLASH_ARLOCK,
    output wire [3:0]                           S_AXI_FLASH_ARCACHE,
    output wire [2:0]                           S_AXI_FLASH_ARPROT,
    output wire [3:0]                           S_AXI_FLASH_ARREGION,
    output wire [3:0]                           S_AXI_FLASH_ARQOS,
    output wire                                 S_AXI_FLASH_ARVALID,
    input  wire                                 S_AXI_FLASH_ARREADY,
    input  wire [3:0]                           S_AXI_FLASH_RID,
    input  wire [`C_AXI_L2_DATA_WIDTH-1:0]      S_AXI_FLASH_RDATA,
    input  wire [1:0]                           S_AXI_FLASH_RRESP,
    input  wire                                 S_AXI_FLASH_RLAST,
    input  wire                                 S_AXI_FLASH_RVALID,
    output wire                                 S_AXI_FLASH_RREADY,

    //Slave 4 (DRAM Controller)
    output wire [3:0]                           S_AXI_DRAM_AWID,
    output wire [`C_AXI_L2_ADDR_WIDTH-1:0]      S_AXI_DRAM_AWADDR,
    output wire [7:0]                           S_AXI_DRAM_AWLEN,
    output wire [2:0]                           S_AXI_DRAM_AWSIZE,
    output wire [1:0]                           S_AXI_DRAM_AWBURST,
    output wire                                 S_AXI_DRAM_AWLOCK,
    output wire [3:0]                           S_AXI_DRAM_AWCACHE,
    output wire [2:0]                           S_AXI_DRAM_AWPROT,
    output wire [3:0]                           S_AXI_DRAM_AWREGION,
    output wire [3:0]                           S_AXI_DRAM_AWQOS,
    output wire                                 S_AXI_DRAM_AWVALID,
    input  wire                                 S_AXI_DRAM_AWREADY,
    output wire [`C_AXI_L2_DATA_WIDTH-1:0]      S_AXI_DRAM_WDATA,
    output wire [`C_AXI_L2_DATA_WIDTH/8-1:0]    S_AXI_DRAM_WSTRB,
    output wire                                 S_AXI_DRAM_WLAST,
    output wire                                 S_AXI_DRAM_WVALID,
    input  wire                                 S_AXI_DRAM_WREADY,
    input  wire [3:0]                           S_AXI_DRAM_BID,
    input  wire [1:0]                           S_AXI_DRAM_BRESP,
    input  wire                                 S_AXI_DRAM_BVALID,
    output wire                                 S_AXI_DRAM_BREADY,
    output wire [3:0]                           S_AXI_DRAM_ARID,
    output wire [`C_AXI_L2_ADDR_WIDTH-1:0]      S_AXI_DRAM_ARADDR,
    output wire [7:0]                           S_AXI_DRAM_ARLEN,
    output wire [2:0]                           S_AXI_DRAM_ARSIZE,
    output wire [1:0]                           S_AXI_DRAM_ARBURST,
    output wire                                 S_AXI_DRAM_ARLOCK,
    output wire [3:0]                           S_AXI_DRAM_ARCACHE,
    output wire [2:0]                           S_AXI_DRAM_ARPROT,
    output wire [3:0]                           S_AXI_DRAM_ARREGION,
    output wire [3:0]                           S_AXI_DRAM_ARQOS,
    output wire                                 S_AXI_DRAM_ARVALID,
    input  wire                                 S_AXI_DRAM_ARREADY,
    input  wire [3:0]                           S_AXI_DRAM_RID,
    input  wire [`C_AXI_L2_DATA_WIDTH-1:0]      S_AXI_DRAM_RDATA,
    input  wire [1:0]                           S_AXI_DRAM_RRESP,
    input  wire                                 S_AXI_DRAM_RLAST,
    input  wire                                 S_AXI_DRAM_RVALID,
    output wire                                 S_AXI_DRAM_RREADY
);


/************************
*  AXI L2 CrossBar IP  *
************************/
//M00 = DBUS            (round-robin)
//M01 = IBUS            (round-robin)
//M02 = JTAG-DEBUG      (round-robin)
//S00 = Boot ROM        (0x0001_0000 to 0x0001_FFFF)
//S01 = Internal SRAM   (0x1000_0000 to 0x1FFF_FFFF)
//S02 = Peripheral L3   (0x2000_0000 to 0x2FFF_FFFF)
//S03 = Flash Ctrl      (0x4000_0000 to 0x4FFF_FFFF)
//S04 = DRAM Ctrl MIG   (0x8000_0000 to 0xFFFF_FFFF)
AXI64_L2_XBar AXI64_L2_XBar
(
    .aclk           (clk    ),  // input wire aclk
    .aresetn        (rstn   ),  // input wire aresetn

    .s_axi_awid     ({M_AXI_DEBUG_AWID    , M_AXI_IBUS_AWID    , M_AXI_DBUS_AWID     }), // input wire [11 : 0] s_axi_awid
    .s_axi_awaddr   ({M_AXI_DEBUG_AWADDR  , M_AXI_IBUS_AWADDR  , M_AXI_DBUS_AWADDR   }), // input wire [191 : 0] s_axi_awaddr
    .s_axi_awlen    ({M_AXI_DEBUG_AWLEN   , M_AXI_IBUS_AWLEN   , M_AXI_DBUS_AWLEN    }), // input wire [23 : 0] s_axi_awlen
    .s_axi_awsize   ({M_AXI_DEBUG_AWSIZE  , M_AXI_IBUS_AWSIZE  , M_AXI_DBUS_AWSIZE   }), // input wire [8 : 0] s_axi_awsize
    .s_axi_awburst  ({M_AXI_DEBUG_AWBURST , M_AXI_IBUS_AWBURST , M_AXI_DBUS_AWBURST  }), // input wire [5 : 0] s_axi_awburst
    .s_axi_awlock   ({M_AXI_DEBUG_AWLOCK  , M_AXI_IBUS_AWLOCK  , M_AXI_DBUS_AWLOCK   }), // input wire [2 : 0] s_axi_awlock
    .s_axi_awcache  ({M_AXI_DEBUG_AWCACHE , M_AXI_IBUS_AWCACHE , M_AXI_DBUS_AWCACHE  }), // input wire [11 : 0] s_axi_awcache
    .s_axi_awprot   ({M_AXI_DEBUG_AWPROT  , M_AXI_IBUS_AWPROT  , M_AXI_DBUS_AWPROT   }), // input wire [8 : 0] s_axi_awprot
    .s_axi_awqos    ({M_AXI_DEBUG_AWQOS   , M_AXI_IBUS_AWQOS   , M_AXI_DBUS_AWQOS    }), // input wire [11 : 0] s_axi_awqos
    .s_axi_awvalid  ({M_AXI_DEBUG_AWVALID , M_AXI_IBUS_AWVALID , M_AXI_DBUS_AWVALID  }), // input wire [2 : 0] s_axi_awvalid
    .s_axi_awready  ({M_AXI_DEBUG_AWREADY , M_AXI_IBUS_AWREADY , M_AXI_DBUS_AWREADY  }), // output wire [2 : 0] s_axi_awready
    .s_axi_wdata    ({M_AXI_DEBUG_WDATA   , M_AXI_IBUS_WDATA   , M_AXI_DBUS_WDATA    }), // input wire [191 : 0] s_axi_wdata
    .s_axi_wstrb    ({M_AXI_DEBUG_WSTRB   , M_AXI_IBUS_WSTRB   , M_AXI_DBUS_WSTRB    }), // input wire [23 : 0] s_axi_wstrb
    .s_axi_wlast    ({M_AXI_DEBUG_WLAST   , M_AXI_IBUS_WLAST   , M_AXI_DBUS_WLAST    }), // input wire [2 : 0] s_axi_wlast
    .s_axi_wvalid   ({M_AXI_DEBUG_WVALID  , M_AXI_IBUS_WVALID  , M_AXI_DBUS_WVALID   }), // input wire [2 : 0] s_axi_wvalid
    .s_axi_wready   ({M_AXI_DEBUG_WREADY  , M_AXI_IBUS_WREADY  , M_AXI_DBUS_WREADY   }), // output wire [2 : 0] s_axi_wready
    .s_axi_bid      ({M_AXI_DEBUG_BID     , M_AXI_IBUS_BID     , M_AXI_DBUS_BID      }), // output wire [11 : 0] s_axi_bid
    .s_axi_bresp    ({M_AXI_DEBUG_BRESP   , M_AXI_IBUS_BRESP   , M_AXI_DBUS_BRESP    }), // output wire [5 : 0] s_axi_bresp
    .s_axi_bvalid   ({M_AXI_DEBUG_BVALID  , M_AXI_IBUS_BVALID  , M_AXI_DBUS_BVALID   }), // output wire [2 : 0] s_axi_bvalid
    .s_axi_bready   ({M_AXI_DEBUG_BREADY  , M_AXI_IBUS_BREADY  , M_AXI_DBUS_BREADY   }), // input wire [2 : 0] s_axi_bready
    .s_axi_arid     ({M_AXI_DEBUG_ARID    , M_AXI_IBUS_ARID    , M_AXI_DBUS_ARID     }), // input wire [11 : 0] s_axi_arid
    .s_axi_araddr   ({M_AXI_DEBUG_ARADDR  , M_AXI_IBUS_ARADDR  , M_AXI_DBUS_ARADDR   }), // input wire [191 : 0] s_axi_araddr
    .s_axi_arlen    ({M_AXI_DEBUG_ARLEN   , M_AXI_IBUS_ARLEN   , M_AXI_DBUS_ARLEN    }), // input wire [23 : 0] s_axi_arlen
    .s_axi_arsize   ({M_AXI_DEBUG_ARSIZE  , M_AXI_IBUS_ARSIZE  , M_AXI_DBUS_ARSIZE   }), // input wire [8 : 0] s_axi_arsize
    .s_axi_arburst  ({M_AXI_DEBUG_ARBURST , M_AXI_IBUS_ARBURST , M_AXI_DBUS_ARBURST  }), // input wire [5 : 0] s_axi_arburst
    .s_axi_arlock   ({M_AXI_DEBUG_ARLOCK  , M_AXI_IBUS_ARLOCK  , M_AXI_DBUS_ARLOCK   }), // input wire [2 : 0] s_axi_arlock
    .s_axi_arcache  ({M_AXI_DEBUG_ARCACHE , M_AXI_IBUS_ARCACHE , M_AXI_DBUS_ARCACHE  }), // input wire [11 : 0] s_axi_arcache
    .s_axi_arprot   ({M_AXI_DEBUG_ARPROT  , M_AXI_IBUS_ARPROT  , M_AXI_DBUS_ARPROT   }), // input wire [8 : 0] s_axi_arprot
    .s_axi_arqos    ({M_AXI_DEBUG_ARQOS   , M_AXI_IBUS_ARQOS   , M_AXI_DBUS_ARQOS    }), // input wire [11 : 0] s_axi_arqos
    .s_axi_arvalid  ({M_AXI_DEBUG_ARVALID , M_AXI_IBUS_ARVALID , M_AXI_DBUS_ARVALID  }), // input wire [2 : 0] s_axi_arvalid
    .s_axi_arready  ({M_AXI_DEBUG_ARREADY , M_AXI_IBUS_ARREADY , M_AXI_DBUS_ARREADY  }), // output wire [2 : 0] s_axi_arready
    .s_axi_rid      ({M_AXI_DEBUG_RID     , M_AXI_IBUS_RID     , M_AXI_DBUS_RID      }), // output wire [11 : 0] s_axi_rid
    .s_axi_rdata    ({M_AXI_DEBUG_RDATA   , M_AXI_IBUS_RDATA   , M_AXI_DBUS_RDATA    }), // output wire [191 : 0] s_axi_rdata
    .s_axi_rresp    ({M_AXI_DEBUG_RRESP   , M_AXI_IBUS_RRESP   , M_AXI_DBUS_RRESP    }), // output wire [5 : 0] s_axi_rresp
    .s_axi_rlast    ({M_AXI_DEBUG_RLAST   , M_AXI_IBUS_RLAST   , M_AXI_DBUS_RLAST    }), // output wire [2 : 0] s_axi_rlast
    .s_axi_rvalid   ({M_AXI_DEBUG_RVALID  , M_AXI_IBUS_RVALID  , M_AXI_DBUS_RVALID   }), // output wire [2 : 0] s_axi_rvalid
    .s_axi_rready   ({M_AXI_DEBUG_RREADY  , M_AXI_IBUS_RREADY  , M_AXI_DBUS_RREADY   }), // input wire [2 : 0] s_axi_rready

    .m_axi_awaddr   ({S_AXI_DRAM_AWADDR   , S_AXI_FLASH_AWADDR   , S_AXI_L3PERI_AWADDR   , S_AXI_INTSRAM_AWADDR   , S_AXI_BOOTROM_AWADDR    }), // output wire [319 : 0] m_axi_awaddr
    .m_axi_awlen    ({S_AXI_DRAM_AWLEN    , S_AXI_FLASH_AWLEN    , S_AXI_L3PERI_AWLEN    , S_AXI_INTSRAM_AWLEN    , S_AXI_BOOTROM_AWLEN     }), // output wire [39 : 0] m_axi_awlen
    .m_axi_awsize   ({S_AXI_DRAM_AWSIZE   , S_AXI_FLASH_AWSIZE   , S_AXI_L3PERI_AWSIZE   , S_AXI_INTSRAM_AWSIZE   , S_AXI_BOOTROM_AWSIZE    }), // output wire [14 : 0] m_axi_awsize
    .m_axi_awburst  ({S_AXI_DRAM_AWBURST  , S_AXI_FLASH_AWBURST  , S_AXI_L3PERI_AWBURST  , S_AXI_INTSRAM_AWBURST  , S_AXI_BOOTROM_AWBURST   }), // output wire [9 : 0] m_axi_awburst
    .m_axi_awlock   ({S_AXI_DRAM_AWLOCK   , S_AXI_FLASH_AWLOCK   , S_AXI_L3PERI_AWLOCK   , S_AXI_INTSRAM_AWLOCK   , S_AXI_BOOTROM_AWLOCK    }), // output wire [4 : 0] m_axi_awlock
    .m_axi_awcache  ({S_AXI_DRAM_AWCACHE  , S_AXI_FLASH_AWCACHE  , S_AXI_L3PERI_AWCACHE  , S_AXI_INTSRAM_AWCACHE  , S_AXI_BOOTROM_AWCACHE   }), // output wire [19 : 0] m_axi_awcache
    .m_axi_awprot   ({S_AXI_DRAM_AWPROT   , S_AXI_FLASH_AWPROT   , S_AXI_L3PERI_AWPROT   , S_AXI_INTSRAM_AWPROT   , S_AXI_BOOTROM_AWPROT    }), // output wire [14 : 0] m_axi_awprot
    .m_axi_awregion ({S_AXI_DRAM_AWREGION , S_AXI_FLASH_AWREGION , S_AXI_L3PERI_AWREGION , S_AXI_INTSRAM_AWREGION , S_AXI_BOOTROM_AWREGION  }), // output wire [19 : 0] m_axi_awregion
    .m_axi_awqos    ({S_AXI_DRAM_AWQOS    , S_AXI_FLASH_AWQOS    , S_AXI_L3PERI_AWQOS    , S_AXI_INTSRAM_AWQOS    , S_AXI_BOOTROM_AWQOS     }), // output wire [19 : 0] m_axi_awqos
    .m_axi_awvalid  ({S_AXI_DRAM_AWVALID  , S_AXI_FLASH_AWVALID  , S_AXI_L3PERI_AWVALID  , S_AXI_INTSRAM_AWVALID  , S_AXI_BOOTROM_AWVALID   }), // output wire [4 : 0] m_axi_awvalid
    .m_axi_awready  ({S_AXI_DRAM_AWREADY  , S_AXI_FLASH_AWREADY  , S_AXI_L3PERI_AWREADY  , S_AXI_INTSRAM_AWREADY  , S_AXI_BOOTROM_AWREADY   }), // input wire [4 : 0] m_axi_awready
    .m_axi_wdata    ({S_AXI_DRAM_WDATA    , S_AXI_FLASH_WDATA    , S_AXI_L3PERI_WDATA    , S_AXI_INTSRAM_WDATA    , S_AXI_BOOTROM_WDATA     }), // output wire [319 : 0] m_axi_wdata
    .m_axi_wstrb    ({S_AXI_DRAM_WSTRB    , S_AXI_FLASH_WSTRB    , S_AXI_L3PERI_WSTRB    , S_AXI_INTSRAM_WSTRB    , S_AXI_BOOTROM_WSTRB     }), // output wire [39 : 0] m_axi_wstrb
    .m_axi_wlast    ({S_AXI_DRAM_WLAST    , S_AXI_FLASH_WLAST    , S_AXI_L3PERI_WLAST    , S_AXI_INTSRAM_WLAST    , S_AXI_BOOTROM_WLAST     }), // output wire [4 : 0] m_axi_wlast
    .m_axi_wvalid   ({S_AXI_DRAM_WVALID   , S_AXI_FLASH_WVALID   , S_AXI_L3PERI_WVALID   , S_AXI_INTSRAM_WVALID   , S_AXI_BOOTROM_WVALID    }), // output wire [4 : 0] m_axi_wvalid
    .m_axi_wready   ({S_AXI_DRAM_WREADY   , S_AXI_FLASH_WREADY   , S_AXI_L3PERI_WREADY   , S_AXI_INTSRAM_WREADY   , S_AXI_BOOTROM_WREADY    }), // input wire [4 : 0] m_axi_wready
    .m_axi_bresp    ({S_AXI_DRAM_BRESP    , S_AXI_FLASH_BRESP    , S_AXI_L3PERI_BRESP    , S_AXI_INTSRAM_BRESP    , S_AXI_BOOTROM_BRESP     }), // input wire [9 : 0] m_axi_bresp
    .m_axi_bvalid   ({S_AXI_DRAM_BVALID   , S_AXI_FLASH_BVALID   , S_AXI_L3PERI_BVALID   , S_AXI_INTSRAM_BVALID   , S_AXI_BOOTROM_BVALID    }), // input wire [4 : 0] m_axi_bvalid
    .m_axi_bready   ({S_AXI_DRAM_BREADY   , S_AXI_FLASH_BREADY   , S_AXI_L3PERI_BREADY   , S_AXI_INTSRAM_BREADY   , S_AXI_BOOTROM_BREADY    }), // output wire [4 : 0] m_axi_bready
    .m_axi_araddr   ({S_AXI_DRAM_ARADDR   , S_AXI_FLASH_ARADDR   , S_AXI_L3PERI_ARADDR   , S_AXI_INTSRAM_ARADDR   , S_AXI_BOOTROM_ARADDR    }), // output wire [319 : 0] m_axi_araddr
    .m_axi_arlen    ({S_AXI_DRAM_ARLEN    , S_AXI_FLASH_ARLEN    , S_AXI_L3PERI_ARLEN    , S_AXI_INTSRAM_ARLEN    , S_AXI_BOOTROM_ARLEN     }), // output wire [39 : 0] m_axi_arlen
    .m_axi_arsize   ({S_AXI_DRAM_ARSIZE   , S_AXI_FLASH_ARSIZE   , S_AXI_L3PERI_ARSIZE   , S_AXI_INTSRAM_ARSIZE   , S_AXI_BOOTROM_ARSIZE    }), // output wire [14 : 0] m_axi_arsize
    .m_axi_arburst  ({S_AXI_DRAM_ARBURST  , S_AXI_FLASH_ARBURST  , S_AXI_L3PERI_ARBURST  , S_AXI_INTSRAM_ARBURST  , S_AXI_BOOTROM_ARBURST   }), // output wire [9 : 0] m_axi_arburst
    .m_axi_arlock   ({S_AXI_DRAM_ARLOCK   , S_AXI_FLASH_ARLOCK   , S_AXI_L3PERI_ARLOCK   , S_AXI_INTSRAM_ARLOCK   , S_AXI_BOOTROM_ARLOCK    }), // output wire [4 : 0] m_axi_arlock
    .m_axi_arcache  ({S_AXI_DRAM_ARCACHE  , S_AXI_FLASH_ARCACHE  , S_AXI_L3PERI_ARCACHE  , S_AXI_INTSRAM_ARCACHE  , S_AXI_BOOTROM_ARCACHE   }), // output wire [19 : 0] m_axi_arcache
    .m_axi_arprot   ({S_AXI_DRAM_ARPROT   , S_AXI_FLASH_ARPROT   , S_AXI_L3PERI_ARPROT   , S_AXI_INTSRAM_ARPROT   , S_AXI_BOOTROM_ARPROT    }), // output wire [14 : 0] m_axi_arprot
    .m_axi_arregion ({S_AXI_DRAM_ARREGION , S_AXI_FLASH_ARREGION , S_AXI_L3PERI_ARREGION , S_AXI_INTSRAM_ARREGION , S_AXI_BOOTROM_ARREGION  }), // output wire [19 : 0] m_axi_arregion
    .m_axi_arqos    ({S_AXI_DRAM_ARQOS    , S_AXI_FLASH_ARQOS    , S_AXI_L3PERI_ARQOS    , S_AXI_INTSRAM_ARQOS    , S_AXI_BOOTROM_ARQOS     }), // output wire [19 : 0] m_axi_arqos
    .m_axi_arvalid  ({S_AXI_DRAM_ARVALID  , S_AXI_FLASH_ARVALID  , S_AXI_L3PERI_ARVALID  , S_AXI_INTSRAM_ARVALID  , S_AXI_BOOTROM_ARVALID   }), // output wire [4 : 0] m_axi_arvalid
    .m_axi_arready  ({S_AXI_DRAM_ARREADY  , S_AXI_FLASH_ARREADY  , S_AXI_L3PERI_ARREADY  , S_AXI_INTSRAM_ARREADY  , S_AXI_BOOTROM_ARREADY   }), // input wire [4 : 0] m_axi_arready
    .m_axi_rdata    ({S_AXI_DRAM_RDATA    , S_AXI_FLASH_RDATA    , S_AXI_L3PERI_RDATA    , S_AXI_INTSRAM_RDATA    , S_AXI_BOOTROM_RDATA     }), // input wire [319 : 0] m_axi_rdata
    .m_axi_rresp    ({S_AXI_DRAM_RRESP    , S_AXI_FLASH_RRESP    , S_AXI_L3PERI_RRESP    , S_AXI_INTSRAM_RRESP    , S_AXI_BOOTROM_RRESP     }), // input wire [9 : 0] m_axi_rresp
    .m_axi_rlast    ({S_AXI_DRAM_RLAST    , S_AXI_FLASH_RLAST    , S_AXI_L3PERI_RLAST    , S_AXI_INTSRAM_RLAST    , S_AXI_BOOTROM_RLAST     }), // input wire [4 : 0] m_axi_rlast
    .m_axi_rvalid   ({S_AXI_DRAM_RVALID   , S_AXI_FLASH_RVALID   , S_AXI_L3PERI_RVALID   , S_AXI_INTSRAM_RVALID   , S_AXI_BOOTROM_RVALID    }), // input wire [4 : 0] m_axi_rvalid
    .m_axi_rready   ({S_AXI_DRAM_RREADY   , S_AXI_FLASH_RREADY   , S_AXI_L3PERI_RREADY   , S_AXI_INTSRAM_RREADY   , S_AXI_BOOTROM_RREADY    })  // output wire [4 : 0] m_axi_rready
`ifdef L2_XBAR_SAMD
    ,
    .m_axi_awid     ({S_AXI_DRAM_AWID     , S_AXI_FLASH_AWID     , S_AXI_L3PERI_AWID     , S_AXI_INTSRAM_AWID     , S_AXI_BOOTROM_AWID      }), // output wire [19 : 0] m_axi_awid
    .m_axi_bid      ({S_AXI_DRAM_BID      , S_AXI_FLASH_BID      , S_AXI_L3PERI_BID      , S_AXI_INTSRAM_BID      , S_AXI_BOOTROM_BID       }), // input wire [19 : 0] m_axi_bid
    .m_axi_arid     ({S_AXI_DRAM_ARID     , S_AXI_FLASH_ARID     , S_AXI_L3PERI_ARID     , S_AXI_INTSRAM_ARID     , S_AXI_BOOTROM_ARID      }), // output wire [19 : 0] m_axi_arid
    .m_axi_rid      ({S_AXI_DRAM_RID      , S_AXI_FLASH_RID      , S_AXI_L3PERI_RID      , S_AXI_INTSRAM_RID      , S_AXI_BOOTROM_RID       })  // input wire [19 : 0] m_axi_rdata
`endif
);

`ifndef L2_XBAR_SAMD
//NOTE: XBar is SASD So Output Master Interfaces do not have IDs. Hence assign
//them manually to 0.
assign S_AXI_BOOTROM_AWID = 0;
assign S_AXI_BOOTROM_ARID = 0;
assign S_AXI_INTSRAM_AWID = 0;
assign S_AXI_INTSRAM_ARID = 0;
assign S_AXI_L3PERI_AWID  = 0;
assign S_AXI_L3PERI_ARID  = 0;
assign S_AXI_FLASH_AWID   = 0;
assign S_AXI_FLASH_ARID   = 0;
assign S_AXI_DRAM_AWID    = 0;
assign S_AXI_DRAM_ARID    = 0;

`endif

endmodule

