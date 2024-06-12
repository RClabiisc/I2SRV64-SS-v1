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
`include "core_defines.vh"

(* keep_hierarchy = "yes" *)
module Processor
#(
    parameter         RESET_PC                  = 64'h0000_0000_0001_0000, //By Default Boot From BOOT ROM
    parameter integer C_PLATFORM_LOCAL_IRQS     = 1,    //No. of Platform Local IRQs
    parameter integer C_PLATFORM_GLOBAL_IRQS    = 8,    //No. of Platform GLobal IRQs to PLIC
    parameter integer C_CLINT_CLK_DIVIDE_BY     = 8     //CLINT rtclk = sys_clk/C_CLINT_CLK_DIVIDE_BY
)
(
    //System Clock Input
    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 sys_clk CLK" *)
    (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF M_AXI_IBUS:M_AXI_DBUS, ASSOCIATED_RESET sys_rst" *)
    input  wire                                 sys_clk,

    //System Global Reset Input
    (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 sys_rst RST" *)
    (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_HIGH" *)
    input  wire                                 sys_rst,

    //Non Maskable Interrupt Input
    (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 NMI_irq INTERRUPT" *)
    (* X_INTERFACE_PARAMETER = "SENSITIVITY LEVEL_HIGH" *)
    input  wire                                 NMI_irq,

    //Global Interrupt Inputs
    (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 global_irqs INTERRUPT" *)
    (* X_INTERFACE_PARAMETER = "SENSITIVITY LEVEL_HIGH" *)
    input  wire [C_PLATFORM_GLOBAL_IRQS-1:0]    global_irqs,

    //Local Interrupt Inputs
    (* X_INTERFACE_INFO = "xilinx.com:signal:interrupt:1.0 local_irqs INTERRUPT" *)
    (* X_INTERFACE_PARAMETER = "SENSITIVITY LEVEL_HIGH" *)
    input  wire [C_PLATFORM_LOCAL_IRQS-1:0]     local_irqs,

    //I-BUS AXI4 MM Interface
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS AWID" *)
    output wire [3:0]                           M_AXI_IBUS_AWID,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS AWADDR" *)
    output wire [`C_AXI_IBUS_ADDR_WIDTH-1:0]    M_AXI_IBUS_AWADDR,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS AWLEN" *)
    output wire [7:0]                           M_AXI_IBUS_AWLEN,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS AWSIZE" *)
    output wire [2:0]                           M_AXI_IBUS_AWSIZE,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS AWBURST" *)
    output wire [1:0]                           M_AXI_IBUS_AWBURST,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS AWLOCK" *)
    output wire                                 M_AXI_IBUS_AWLOCK,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS AWCACHE" *)
    output wire [3:0]                           M_AXI_IBUS_AWCACHE,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS AWPROT" *)
    output wire [2:0]                           M_AXI_IBUS_AWPROT,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS AWREGION" *)
    output wire [3:0]                           M_AXI_IBUS_AWREGION,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS AWQOS" *)
    output wire [3:0]                           M_AXI_IBUS_AWQOS,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS AWVALID" *)
    output wire                                 M_AXI_IBUS_AWVALID,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS AWREADY" *)
    input  wire                                 M_AXI_IBUS_AWREADY,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS WDATA" *)
    output wire [`C_AXI_IBUS_DATA_WIDTH-1:0]    M_AXI_IBUS_WDATA,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS WSTRB" *)
    output wire [`C_AXI_IBUS_DATA_WIDTH/8-1:0]  M_AXI_IBUS_WSTRB,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS WLAST" *)
    output wire                                 M_AXI_IBUS_WLAST,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS WVALID" *)
    output wire                                 M_AXI_IBUS_WVALID,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS WREADY" *)
    input  wire                                 M_AXI_IBUS_WREADY,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS BID" *)
    input  wire [3:0]                           M_AXI_IBUS_BID,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS BRESP" *)
    input  wire [1:0]                           M_AXI_IBUS_BRESP,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS BVALID" *)
    input  wire                                 M_AXI_IBUS_BVALID,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS BREADY" *)
    output wire                                 M_AXI_IBUS_BREADY,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS ARID" *)
    output wire [3:0]                           M_AXI_IBUS_ARID,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS ARADDR" *)
    output wire [`C_AXI_IBUS_ADDR_WIDTH-1:0]    M_AXI_IBUS_ARADDR,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS ARLEN" *)
    output wire [7:0]                           M_AXI_IBUS_ARLEN,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS ARSIZE" *)
    output wire [2:0]                           M_AXI_IBUS_ARSIZE,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS ARBURST" *)
    output wire [1:0]                           M_AXI_IBUS_ARBURST,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS ARLOCK" *)
    output wire                                 M_AXI_IBUS_ARLOCK,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS ARCACHE" *)
    output wire [3:0]                           M_AXI_IBUS_ARCACHE,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS ARPROT" *)
    output wire [2:0]                           M_AXI_IBUS_ARPROT,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS ARREGION" *)
    output wire [3:0]                           M_AXI_IBUS_ARREGION,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS ARQOS" *)
    output wire [3:0]                           M_AXI_IBUS_ARQOS,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS ARVALID" *)
    output wire                                 M_AXI_IBUS_ARVALID,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS ARREADY" *)
    input  wire                                 M_AXI_IBUS_ARREADY,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS RID" *)
    input  wire [3:0]                           M_AXI_IBUS_RID,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS RDATA" *)
    input  wire [`C_AXI_IBUS_DATA_WIDTH-1:0]    M_AXI_IBUS_RDATA,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS RRESP" *)
    input  wire [1:0]                           M_AXI_IBUS_RRESP,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS RLAST" *)
    input  wire                                 M_AXI_IBUS_RLAST,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS RVALID" *)
    input  wire                                 M_AXI_IBUS_RVALID,
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXI_IBUS" *)
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_IBUS RREADY" *)
    output wire                                 M_AXI_IBUS_RREADY,

    //D-BUS AXI4 MM Interface
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS AWID" *)
    output wire [3:0]                           M_AXI_DBUS_AWID,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS AWADDR" *)
    output wire [`C_AXI_DBUS_ADDR_WIDTH-1:0]    M_AXI_DBUS_AWADDR,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS AWLEN" *)
    output wire [7:0]                           M_AXI_DBUS_AWLEN,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS AWSIZE" *)
    output wire [2:0]                           M_AXI_DBUS_AWSIZE,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS AWBURST" *)
    output wire [1:0]                           M_AXI_DBUS_AWBURST,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS AWLOCK" *)
    output wire                                 M_AXI_DBUS_AWLOCK,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS AWCACHE" *)
    output wire [3:0]                           M_AXI_DBUS_AWCACHE,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS AWPROT" *)
    output wire [2:0]                           M_AXI_DBUS_AWPROT,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS AWQOS" *)
    output wire [3:0]                           M_AXI_DBUS_AWQOS,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS AWREGION" *)
    output wire [3:0]                           M_AXI_DBUS_AWREGION,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS AWVALID" *)
    output wire                                 M_AXI_DBUS_AWVALID,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS AWREADY" *)
    input  wire                                 M_AXI_DBUS_AWREADY,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS WDATA" *)
    output wire [`C_AXI_DBUS_DATA_WIDTH-1:0]    M_AXI_DBUS_WDATA,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS WSTRB" *)
    output wire [`C_AXI_DBUS_DATA_WIDTH/8-1:0]  M_AXI_DBUS_WSTRB,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS WLAST" *)
    output wire                                 M_AXI_DBUS_WLAST,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS WVALID" *)
    output wire                                 M_AXI_DBUS_WVALID,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS WREADY" *)
    input  wire                                 M_AXI_DBUS_WREADY,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS BID" *)
    input  wire [3:0]                           M_AXI_DBUS_BID,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS BRESP" *)
    input  wire [1:0]                           M_AXI_DBUS_BRESP,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS BVALID" *)
    input  wire                                 M_AXI_DBUS_BVALID,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS BREADY" *)
    output wire                                 M_AXI_DBUS_BREADY,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS ARID" *)
    output wire [3:0]                           M_AXI_DBUS_ARID,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS ARADDR" *)
    output wire [`C_AXI_DBUS_ADDR_WIDTH-1:0]    M_AXI_DBUS_ARADDR,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS ARLEN" *)
    output wire [7:0]                           M_AXI_DBUS_ARLEN,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS ARSIZE" *)
    output wire [2:0]                           M_AXI_DBUS_ARSIZE,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS ARBURST" *)
    output wire [1:0]                           M_AXI_DBUS_ARBURST,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS ARLOCK" *)
    output wire                                 M_AXI_DBUS_ARLOCK,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS ARCACHE" *)
    output wire [3:0]                           M_AXI_DBUS_ARCACHE,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS ARPROT" *)
    output wire [2:0]                           M_AXI_DBUS_ARPROT,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS ARREGION" *)
    output wire [3:0]                           M_AXI_DBUS_ARREGION,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS ARQOS" *)
    output wire [3:0]                           M_AXI_DBUS_ARQOS,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS ARVALID" *)
    output wire                                 M_AXI_DBUS_ARVALID,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS ARREADY" *)
    input  wire                                 M_AXI_DBUS_ARREADY,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS RID" *)
    input  wire [3:0]                           M_AXI_DBUS_RID,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS RDATA" *)
    input  wire [`C_AXI_DBUS_DATA_WIDTH-1:0]    M_AXI_DBUS_RDATA,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS RRESP" *)
    input  wire [1:0]                           M_AXI_DBUS_RRESP,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS RLAST" *)
    input  wire                                 M_AXI_DBUS_RLAST,
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS RVALID" *)
    input  wire                                 M_AXI_DBUS_RVALID,
    (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME M_AXI_DBUS" *)
    (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 M_AXI_DBUS RREADY" *)
    output wire                                 M_AXI_DBUS_RREADY,

    //Boot Config Input
    input  wire [3:0]                           BOOT_MODE,

    //Temporary signals
    output wire [`XLEN-1:0]                     RetirePC
);

/*****************************************************************************
*                         Local Interconnect Wires                          *
*****************************************************************************/
//Interrupt Request Wires
wire                                    irq_machine_ext;            //From PLIC
wire                                    irq_machine_timer;          //From CLINT
wire                                    irq_machine_soft;           //From CLINT
wire                                    irq_supervisor_ext;         //From PLIC

//Time From CLINT
wire [`XLEN-1:0]                        CLINT_time;
wire                                    rt_clk;

//Local Wires for 32-bit AXI Lite Private Bus
wire [`C_AXI_PBUS_ADDR_WIDTH-1:0]       M_AXI_PBUS_CORE0_AWADDR  , S_AXI_PBUS_PLIC_AWADDR  , S_AXI_PBUS_CLINT_AWADDR  , S_AXI_PBUS_CCFG_AWADDR  ;
wire [2:0]                              M_AXI_PBUS_CORE0_AWPROT  , S_AXI_PBUS_PLIC_AWPROT  , S_AXI_PBUS_CLINT_AWPROT  , S_AXI_PBUS_CCFG_AWPROT  ;
wire                                    M_AXI_PBUS_CORE0_AWVALID , S_AXI_PBUS_PLIC_AWVALID , S_AXI_PBUS_CLINT_AWVALID , S_AXI_PBUS_CCFG_AWVALID ;
wire                                    M_AXI_PBUS_CORE0_AWREADY , S_AXI_PBUS_PLIC_AWREADY , S_AXI_PBUS_CLINT_AWREADY , S_AXI_PBUS_CCFG_AWREADY ;
wire [`C_AXI_PBUS_DATA_WIDTH-1:0]       M_AXI_PBUS_CORE0_WDATA   , S_AXI_PBUS_PLIC_WDATA   , S_AXI_PBUS_CLINT_WDATA   , S_AXI_PBUS_CCFG_WDATA   ;
wire [`C_AXI_PBUS_DATA_WIDTH/8-1:0]     M_AXI_PBUS_CORE0_WSTRB   , S_AXI_PBUS_PLIC_WSTRB   , S_AXI_PBUS_CLINT_WSTRB   , S_AXI_PBUS_CCFG_WSTRB   ;
wire                                    M_AXI_PBUS_CORE0_WVALID  , S_AXI_PBUS_PLIC_WVALID  , S_AXI_PBUS_CLINT_WVALID  , S_AXI_PBUS_CCFG_WVALID  ;
wire                                    M_AXI_PBUS_CORE0_WREADY  , S_AXI_PBUS_PLIC_WREADY  , S_AXI_PBUS_CLINT_WREADY  , S_AXI_PBUS_CCFG_WREADY  ;
wire [1:0]                              M_AXI_PBUS_CORE0_BRESP   , S_AXI_PBUS_PLIC_BRESP   , S_AXI_PBUS_CLINT_BRESP   , S_AXI_PBUS_CCFG_BRESP   ;
wire                                    M_AXI_PBUS_CORE0_BVALID  , S_AXI_PBUS_PLIC_BVALID  , S_AXI_PBUS_CLINT_BVALID  , S_AXI_PBUS_CCFG_BVALID  ;
wire                                    M_AXI_PBUS_CORE0_BREADY  , S_AXI_PBUS_PLIC_BREADY  , S_AXI_PBUS_CLINT_BREADY  , S_AXI_PBUS_CCFG_BREADY  ;
wire [`C_AXI_PBUS_ADDR_WIDTH-1:0]       M_AXI_PBUS_CORE0_ARADDR  , S_AXI_PBUS_PLIC_ARADDR  , S_AXI_PBUS_CLINT_ARADDR  , S_AXI_PBUS_CCFG_ARADDR  ;
wire [2:0]                              M_AXI_PBUS_CORE0_ARPROT  , S_AXI_PBUS_PLIC_ARPROT  , S_AXI_PBUS_CLINT_ARPROT  , S_AXI_PBUS_CCFG_ARPROT  ;
wire                                    M_AXI_PBUS_CORE0_ARVALID , S_AXI_PBUS_PLIC_ARVALID , S_AXI_PBUS_CLINT_ARVALID , S_AXI_PBUS_CCFG_ARVALID ;
wire                                    M_AXI_PBUS_CORE0_ARREADY , S_AXI_PBUS_PLIC_ARREADY , S_AXI_PBUS_CLINT_ARREADY , S_AXI_PBUS_CCFG_ARREADY ;
wire [`C_AXI_PBUS_DATA_WIDTH-1:0]       M_AXI_PBUS_CORE0_RDATA   , S_AXI_PBUS_PLIC_RDATA   , S_AXI_PBUS_CLINT_RDATA   , S_AXI_PBUS_CCFG_RDATA   ;
wire [1:0]                              M_AXI_PBUS_CORE0_RRESP   , S_AXI_PBUS_PLIC_RRESP   , S_AXI_PBUS_CLINT_RRESP   , S_AXI_PBUS_CCFG_RRESP   ;
wire                                    M_AXI_PBUS_CORE0_RVALID  , S_AXI_PBUS_PLIC_RVALID  , S_AXI_PBUS_CLINT_RVALID  , S_AXI_PBUS_CCFG_RVALID  ;
wire                                    M_AXI_PBUS_CORE0_RREADY  , S_AXI_PBUS_PLIC_RREADY  , S_AXI_PBUS_CLINT_RREADY  , S_AXI_PBUS_CCFG_RREADY  ;


/********************************
*  RISC-V Core Instantiation    *
********************************/
Core
#(
    .RESET_PC                   (RESET_PC                   ),
    .platform_irqs              (C_PLATFORM_LOCAL_IRQS      ),
    .HART_ID                    (0                          ),
    .MEM_TYPE                   ("xpm"                      )
)
Core0
(
    .clk                        (sys_clk                    ),
    .rst                        (sys_rst                    ),

    .irq_NMI                    (NMI_irq                    ),
    .irq_machine_ext            (irq_machine_ext            ),
    .irq_machine_timer          (irq_machine_timer          ),
    .irq_machine_soft           (irq_machine_soft           ),
    .irq_supervisor_ext         (irq_supervisor_ext         ),

    .irq_local                  (local_irqs                 ),

    .CLINT_time                 (CLINT_time                 ),

    .M_AXI_IBUS_AWID            (M_AXI_IBUS_AWID            ),
    .M_AXI_IBUS_AWADDR          (M_AXI_IBUS_AWADDR          ),
    .M_AXI_IBUS_AWLEN           (M_AXI_IBUS_AWLEN           ),
    .M_AXI_IBUS_AWSIZE          (M_AXI_IBUS_AWSIZE          ),
    .M_AXI_IBUS_AWBURST         (M_AXI_IBUS_AWBURST         ),
    .M_AXI_IBUS_AWLOCK          (M_AXI_IBUS_AWLOCK          ),
    .M_AXI_IBUS_AWCACHE         (M_AXI_IBUS_AWCACHE         ),
    .M_AXI_IBUS_AWPROT          (M_AXI_IBUS_AWPROT          ),
    .M_AXI_IBUS_AWQOS           (M_AXI_IBUS_AWQOS           ),
    .M_AXI_IBUS_AWVALID         (M_AXI_IBUS_AWVALID         ),
    .M_AXI_IBUS_AWREADY         (M_AXI_IBUS_AWREADY         ),
    .M_AXI_IBUS_WDATA           (M_AXI_IBUS_WDATA           ),
    .M_AXI_IBUS_WSTRB           (M_AXI_IBUS_WSTRB           ),
    .M_AXI_IBUS_WLAST           (M_AXI_IBUS_WLAST           ),
    .M_AXI_IBUS_WVALID          (M_AXI_IBUS_WVALID          ),
    .M_AXI_IBUS_WREADY          (M_AXI_IBUS_WREADY          ),
    .M_AXI_IBUS_BID             (M_AXI_IBUS_BID             ),
    .M_AXI_IBUS_BRESP           (M_AXI_IBUS_BRESP           ),
    .M_AXI_IBUS_BVALID          (M_AXI_IBUS_BVALID          ),
    .M_AXI_IBUS_BREADY          (M_AXI_IBUS_BREADY          ),
    .M_AXI_IBUS_ARID            (M_AXI_IBUS_ARID            ),
    .M_AXI_IBUS_ARADDR          (M_AXI_IBUS_ARADDR          ),
    .M_AXI_IBUS_ARLEN           (M_AXI_IBUS_ARLEN           ),
    .M_AXI_IBUS_ARSIZE          (M_AXI_IBUS_ARSIZE          ),
    .M_AXI_IBUS_ARBURST         (M_AXI_IBUS_ARBURST         ),
    .M_AXI_IBUS_ARLOCK          (M_AXI_IBUS_ARLOCK          ),
    .M_AXI_IBUS_ARCACHE         (M_AXI_IBUS_ARCACHE         ),
    .M_AXI_IBUS_ARPROT          (M_AXI_IBUS_ARPROT          ),
    .M_AXI_IBUS_ARQOS           (M_AXI_IBUS_ARQOS           ),
    .M_AXI_IBUS_ARVALID         (M_AXI_IBUS_ARVALID         ),
    .M_AXI_IBUS_ARREADY         (M_AXI_IBUS_ARREADY         ),
    .M_AXI_IBUS_RID             (M_AXI_IBUS_RID             ),
    .M_AXI_IBUS_RDATA           (M_AXI_IBUS_RDATA           ),
    .M_AXI_IBUS_RRESP           (M_AXI_IBUS_RRESP           ),
    .M_AXI_IBUS_RLAST           (M_AXI_IBUS_RLAST           ),
    .M_AXI_IBUS_RVALID          (M_AXI_IBUS_RVALID          ),
    .M_AXI_IBUS_RREADY          (M_AXI_IBUS_RREADY          ),

    //D-Bus (64-Bit AXI4 Full Bus)
    .M_AXI_DBUS_AWID            (M_AXI_DBUS_AWID            ),
    .M_AXI_DBUS_AWADDR          (M_AXI_DBUS_AWADDR          ),
    .M_AXI_DBUS_AWLEN           (M_AXI_DBUS_AWLEN           ),
    .M_AXI_DBUS_AWSIZE          (M_AXI_DBUS_AWSIZE          ),
    .M_AXI_DBUS_AWBURST         (M_AXI_DBUS_AWBURST         ),
    .M_AXI_DBUS_AWLOCK          (M_AXI_DBUS_AWLOCK          ),
    .M_AXI_DBUS_AWCACHE         (M_AXI_DBUS_AWCACHE         ),
    .M_AXI_DBUS_AWPROT          (M_AXI_DBUS_AWPROT          ),
    .M_AXI_DBUS_AWQOS           (M_AXI_DBUS_AWQOS           ),
    .M_AXI_DBUS_AWVALID         (M_AXI_DBUS_AWVALID         ),
    .M_AXI_DBUS_AWREADY         (M_AXI_DBUS_AWREADY         ),
    .M_AXI_DBUS_WDATA           (M_AXI_DBUS_WDATA           ),
    .M_AXI_DBUS_WSTRB           (M_AXI_DBUS_WSTRB           ),
    .M_AXI_DBUS_WLAST           (M_AXI_DBUS_WLAST           ),
    .M_AXI_DBUS_WVALID          (M_AXI_DBUS_WVALID          ),
    .M_AXI_DBUS_WREADY          (M_AXI_DBUS_WREADY          ),
    .M_AXI_DBUS_BID             (M_AXI_DBUS_BID             ),
    .M_AXI_DBUS_BRESP           (M_AXI_DBUS_BRESP           ),
    .M_AXI_DBUS_BVALID          (M_AXI_DBUS_BVALID          ),
    .M_AXI_DBUS_BREADY          (M_AXI_DBUS_BREADY          ),
    .M_AXI_DBUS_ARID            (M_AXI_DBUS_ARID            ),
    .M_AXI_DBUS_ARADDR          (M_AXI_DBUS_ARADDR          ),
    .M_AXI_DBUS_ARLEN           (M_AXI_DBUS_ARLEN           ),
    .M_AXI_DBUS_ARSIZE          (M_AXI_DBUS_ARSIZE          ),
    .M_AXI_DBUS_ARBURST         (M_AXI_DBUS_ARBURST         ),
    .M_AXI_DBUS_ARLOCK          (M_AXI_DBUS_ARLOCK          ),
    .M_AXI_DBUS_ARCACHE         (M_AXI_DBUS_ARCACHE         ),
    .M_AXI_DBUS_ARPROT          (M_AXI_DBUS_ARPROT          ),
    .M_AXI_DBUS_ARQOS           (M_AXI_DBUS_ARQOS           ),
    .M_AXI_DBUS_ARVALID         (M_AXI_DBUS_ARVALID         ),
    .M_AXI_DBUS_ARREADY         (M_AXI_DBUS_ARREADY         ),
    .M_AXI_DBUS_RID             (M_AXI_DBUS_RID             ),
    .M_AXI_DBUS_RDATA           (M_AXI_DBUS_RDATA           ),
    .M_AXI_DBUS_RRESP           (M_AXI_DBUS_RRESP           ),
    .M_AXI_DBUS_RLAST           (M_AXI_DBUS_RLAST           ),
    .M_AXI_DBUS_RVALID          (M_AXI_DBUS_RVALID          ),
    .M_AXI_DBUS_RREADY          (M_AXI_DBUS_RREADY          ),

    //Private Bus (32-bit AXI4 lite Bus)
    .M_AXI_PBUS_AWADDR          (M_AXI_PBUS_CORE0_AWADDR    ),
    .M_AXI_PBUS_AWPROT          (M_AXI_PBUS_CORE0_AWPROT    ),
    .M_AXI_PBUS_AWVALID         (M_AXI_PBUS_CORE0_AWVALID   ),
    .M_AXI_PBUS_AWREADY         (M_AXI_PBUS_CORE0_AWREADY   ),
    .M_AXI_PBUS_WDATA           (M_AXI_PBUS_CORE0_WDATA     ),
    .M_AXI_PBUS_WSTRB           (M_AXI_PBUS_CORE0_WSTRB     ),
    .M_AXI_PBUS_WVALID          (M_AXI_PBUS_CORE0_WVALID    ),
    .M_AXI_PBUS_WREADY          (M_AXI_PBUS_CORE0_WREADY    ),
    .M_AXI_PBUS_BRESP           (M_AXI_PBUS_CORE0_BRESP     ),
    .M_AXI_PBUS_BVALID          (M_AXI_PBUS_CORE0_BVALID    ),
    .M_AXI_PBUS_BREADY          (M_AXI_PBUS_CORE0_BREADY    ),
    .M_AXI_PBUS_ARADDR          (M_AXI_PBUS_CORE0_ARADDR    ),
    .M_AXI_PBUS_ARPROT          (M_AXI_PBUS_CORE0_ARPROT    ),
    .M_AXI_PBUS_ARVALID         (M_AXI_PBUS_CORE0_ARVALID   ),
    .M_AXI_PBUS_ARREADY         (M_AXI_PBUS_CORE0_ARREADY   ),
    .M_AXI_PBUS_RDATA           (M_AXI_PBUS_CORE0_RDATA     ),
    .M_AXI_PBUS_RRESP           (M_AXI_PBUS_CORE0_RRESP     ),
    .M_AXI_PBUS_RVALID          (M_AXI_PBUS_CORE0_RVALID    ),
    .M_AXI_PBUS_RREADY          (M_AXI_PBUS_CORE0_RREADY    ),

    //Temporary signals
    .RetirePC                   (RetirePC                   )

);

/*********************************************
*  Core Local Interrupt Controller (CLINT)  *
*********************************************/
//Clint Clock Divider
clkdiv #(.DIVIDE_BY(C_CLINT_CLK_DIVIDE_BY)) CLINT_clkdiv
(
    .clk_in                     (sys_clk                    ),
    .rst_in                     (sys_rst                    ),
    .clk_out                    (rt_clk                     )
);

CLINT_v1_0 #
(
    // Users to add parameters here
    .C_CLINT_HARTS              (1                          ),
    .C_S_AXI_DATA_WIDTH         (`C_AXI_PBUS_DATA_WIDTH     ),
    .C_S_AXI_ADDR_WIDTH         (`C_AXI_PBUS_ADDR_WIDTH     )
)
CLINT
(
    // Users to add ports here
    .clk                        (sys_clk                    ),
    .rst                        (sys_rst                    ),
    .rt_clk                     (rt_clk                     ),

    .CLINT_time                 (CLINT_time                 ),

    .machine_software_irq_req   (irq_machine_soft           ),
    .machine_timer_irq_req      (irq_machine_timer          ),

    .S_AXI_AWADDR               (S_AXI_PBUS_CLINT_AWADDR    ),
    .S_AXI_AWPROT               (S_AXI_PBUS_CLINT_AWPROT    ),
    .S_AXI_AWVALID              (S_AXI_PBUS_CLINT_AWVALID   ),
    .S_AXI_AWREADY              (S_AXI_PBUS_CLINT_AWREADY   ),
    .S_AXI_WDATA                (S_AXI_PBUS_CLINT_WDATA     ),
    .S_AXI_WSTRB                (S_AXI_PBUS_CLINT_WSTRB     ),
    .S_AXI_WVALID               (S_AXI_PBUS_CLINT_WVALID    ),
    .S_AXI_WREADY               (S_AXI_PBUS_CLINT_WREADY    ),
    .S_AXI_BRESP                (S_AXI_PBUS_CLINT_BRESP     ),
    .S_AXI_BVALID               (S_AXI_PBUS_CLINT_BVALID    ),
    .S_AXI_BREADY               (S_AXI_PBUS_CLINT_BREADY    ),
    .S_AXI_ARADDR               (S_AXI_PBUS_CLINT_ARADDR    ),
    .S_AXI_ARPROT               (S_AXI_PBUS_CLINT_ARPROT    ),
    .S_AXI_ARVALID              (S_AXI_PBUS_CLINT_ARVALID   ),
    .S_AXI_ARREADY              (S_AXI_PBUS_CLINT_ARREADY   ),
    .S_AXI_RDATA                (S_AXI_PBUS_CLINT_RDATA     ),
    .S_AXI_RRESP                (S_AXI_PBUS_CLINT_RRESP     ),
    .S_AXI_RVALID               (S_AXI_PBUS_CLINT_RVALID    ),
    .S_AXI_RREADY               (S_AXI_PBUS_CLINT_RREADY    )
);

/************************************************
*  Platform Level Interrupt Controller (PLIC)  *
************************************************/
wire nc_1;
wire [(31-C_PLATFORM_GLOBAL_IRQS):0]    unused_irqs = 0;
PLIC
#(
    .C_S_AXI_DATA_WIDTH         (`C_AXI_PBUS_DATA_WIDTH     ),
    .C_S_AXI_ADDR_WIDTH         (`C_AXI_PBUS_ADDR_WIDTH     ),
    .INTERRUPTS                 (C_PLATFORM_GLOBAL_IRQS     ),
    .PRIORITY_LEVELS            (`PLIC_PRIORITY_LEVELS      )
)
PLIC
(
    .clk                        (sys_clk                    ),
    .rst                        (sys_rst                    ),

    .global_interrupts          ({unused_irqs,global_irqs}  ),
    .interrupt_notification     ({nc_1,irq_supervisor_ext,irq_machine_ext}),

    .S_AXI_AWADDR               (S_AXI_PBUS_PLIC_AWADDR     ),
    .S_AXI_AWPROT               (S_AXI_PBUS_PLIC_AWPROT     ),
    .S_AXI_AWVALID              (S_AXI_PBUS_PLIC_AWVALID    ),
    .S_AXI_AWREADY              (S_AXI_PBUS_PLIC_AWREADY    ),
    .S_AXI_WDATA                (S_AXI_PBUS_PLIC_WDATA      ),
    .S_AXI_WSTRB                (S_AXI_PBUS_PLIC_WSTRB      ),
    .S_AXI_WVALID               (S_AXI_PBUS_PLIC_WVALID     ),
    .S_AXI_WREADY               (S_AXI_PBUS_PLIC_WREADY     ),
    .S_AXI_BRESP                (S_AXI_PBUS_PLIC_BRESP      ),
    .S_AXI_BVALID               (S_AXI_PBUS_PLIC_BVALID     ),
    .S_AXI_BREADY               (S_AXI_PBUS_PLIC_BREADY     ),
    .S_AXI_ARADDR               (S_AXI_PBUS_PLIC_ARADDR     ),
    .S_AXI_ARPROT               (S_AXI_PBUS_PLIC_ARPROT     ),
    .S_AXI_ARVALID              (S_AXI_PBUS_PLIC_ARVALID    ),
    .S_AXI_ARREADY              (S_AXI_PBUS_PLIC_ARREADY    ),
    .S_AXI_RDATA                (S_AXI_PBUS_PLIC_RDATA      ),
    .S_AXI_RRESP                (S_AXI_PBUS_PLIC_RRESP      ),
    .S_AXI_RVALID               (S_AXI_PBUS_PLIC_RVALID     ),
    .S_AXI_RREADY               (S_AXI_PBUS_PLIC_RREADY     )
);


/**********************************
*  Core Congiguration (CoreCFG)  *
**********************************/
CoreCFG_v1_0
#(
    .C_S_AXI_DATA_WIDTH         (`C_AXI_PBUS_DATA_WIDTH     ),
    .C_S_AXI_ADDR_WIDTH         (`C_AXI_PBUS_ADDR_WIDTH     )
)
CoreCFG
(
    .BOOT_MODE                  (BOOT_MODE                  ),

    .clk                        (sys_clk                    ),
    .rst                        (sys_rst                    ),

    .S_AXI_AWADDR               (S_AXI_PBUS_CCFG_AWADDR     ),
    .S_AXI_AWPROT               (S_AXI_PBUS_CCFG_AWPROT     ),
    .S_AXI_AWVALID              (S_AXI_PBUS_CCFG_AWVALID    ),
    .S_AXI_AWREADY              (S_AXI_PBUS_CCFG_AWREADY    ),
    .S_AXI_WDATA                (S_AXI_PBUS_CCFG_WDATA      ),
    .S_AXI_WSTRB                (S_AXI_PBUS_CCFG_WSTRB      ),
    .S_AXI_WVALID               (S_AXI_PBUS_CCFG_WVALID     ),
    .S_AXI_WREADY               (S_AXI_PBUS_CCFG_WREADY     ),
    .S_AXI_BRESP                (S_AXI_PBUS_CCFG_BRESP      ),
    .S_AXI_BVALID               (S_AXI_PBUS_CCFG_BVALID     ),
    .S_AXI_BREADY               (S_AXI_PBUS_CCFG_BREADY     ),
    .S_AXI_ARADDR               (S_AXI_PBUS_CCFG_ARADDR     ),
    .S_AXI_ARPROT               (S_AXI_PBUS_CCFG_ARPROT     ),
    .S_AXI_ARVALID              (S_AXI_PBUS_CCFG_ARVALID    ),
    .S_AXI_ARREADY              (S_AXI_PBUS_CCFG_ARREADY    ),
    .S_AXI_RDATA                (S_AXI_PBUS_CCFG_RDATA      ),
    .S_AXI_RRESP                (S_AXI_PBUS_CCFG_RRESP      ),
    .S_AXI_RVALID               (S_AXI_PBUS_CCFG_RVALID     ),
    .S_AXI_RREADY               (S_AXI_PBUS_CCFG_RREADY     )
);

/*********************************
*  Private Bus (PBUS) CrossBar  *
*********************************/
PBUS_XBar PBUS_XBar
(
    .sys_clk                    (sys_clk                    ),
    .sys_rst                    (sys_rst                    ),

    .M_AXI_PBUS_CORE0_AWADDR    (M_AXI_PBUS_CORE0_AWADDR    ),
    .M_AXI_PBUS_CORE0_AWPROT    (M_AXI_PBUS_CORE0_AWPROT    ),
    .M_AXI_PBUS_CORE0_AWVALID   (M_AXI_PBUS_CORE0_AWVALID   ),
    .M_AXI_PBUS_CORE0_AWREADY   (M_AXI_PBUS_CORE0_AWREADY   ),
    .M_AXI_PBUS_CORE0_WDATA     (M_AXI_PBUS_CORE0_WDATA     ),
    .M_AXI_PBUS_CORE0_WSTRB     (M_AXI_PBUS_CORE0_WSTRB     ),
    .M_AXI_PBUS_CORE0_WVALID    (M_AXI_PBUS_CORE0_WVALID    ),
    .M_AXI_PBUS_CORE0_WREADY    (M_AXI_PBUS_CORE0_WREADY    ),
    .M_AXI_PBUS_CORE0_BRESP     (M_AXI_PBUS_CORE0_BRESP     ),
    .M_AXI_PBUS_CORE0_BVALID    (M_AXI_PBUS_CORE0_BVALID    ),
    .M_AXI_PBUS_CORE0_BREADY    (M_AXI_PBUS_CORE0_BREADY    ),
    .M_AXI_PBUS_CORE0_ARADDR    (M_AXI_PBUS_CORE0_ARADDR    ),
    .M_AXI_PBUS_CORE0_ARPROT    (M_AXI_PBUS_CORE0_ARPROT    ),
    .M_AXI_PBUS_CORE0_ARVALID   (M_AXI_PBUS_CORE0_ARVALID   ),
    .M_AXI_PBUS_CORE0_ARREADY   (M_AXI_PBUS_CORE0_ARREADY   ),
    .M_AXI_PBUS_CORE0_RDATA     (M_AXI_PBUS_CORE0_RDATA     ),
    .M_AXI_PBUS_CORE0_RRESP     (M_AXI_PBUS_CORE0_RRESP     ),
    .M_AXI_PBUS_CORE0_RVALID    (M_AXI_PBUS_CORE0_RVALID    ),
    .M_AXI_PBUS_CORE0_RREADY    (M_AXI_PBUS_CORE0_RREADY    ),

    .S_AXI_PBUS_PLIC_AWADDR     (S_AXI_PBUS_PLIC_AWADDR     ),
    .S_AXI_PBUS_PLIC_AWPROT     (S_AXI_PBUS_PLIC_AWPROT     ),
    .S_AXI_PBUS_PLIC_AWVALID    (S_AXI_PBUS_PLIC_AWVALID    ),
    .S_AXI_PBUS_PLIC_AWREADY    (S_AXI_PBUS_PLIC_AWREADY    ),
    .S_AXI_PBUS_PLIC_WDATA      (S_AXI_PBUS_PLIC_WDATA      ),
    .S_AXI_PBUS_PLIC_WSTRB      (S_AXI_PBUS_PLIC_WSTRB      ),
    .S_AXI_PBUS_PLIC_WVALID     (S_AXI_PBUS_PLIC_WVALID     ),
    .S_AXI_PBUS_PLIC_WREADY     (S_AXI_PBUS_PLIC_WREADY     ),
    .S_AXI_PBUS_PLIC_BRESP      (S_AXI_PBUS_PLIC_BRESP      ),
    .S_AXI_PBUS_PLIC_BVALID     (S_AXI_PBUS_PLIC_BVALID     ),
    .S_AXI_PBUS_PLIC_BREADY     (S_AXI_PBUS_PLIC_BREADY     ),
    .S_AXI_PBUS_PLIC_ARADDR     (S_AXI_PBUS_PLIC_ARADDR     ),
    .S_AXI_PBUS_PLIC_ARPROT     (S_AXI_PBUS_PLIC_ARPROT     ),
    .S_AXI_PBUS_PLIC_ARVALID    (S_AXI_PBUS_PLIC_ARVALID    ),
    .S_AXI_PBUS_PLIC_ARREADY    (S_AXI_PBUS_PLIC_ARREADY    ),
    .S_AXI_PBUS_PLIC_RDATA      (S_AXI_PBUS_PLIC_RDATA      ),
    .S_AXI_PBUS_PLIC_RRESP      (S_AXI_PBUS_PLIC_RRESP      ),
    .S_AXI_PBUS_PLIC_RVALID     (S_AXI_PBUS_PLIC_RVALID     ),
    .S_AXI_PBUS_PLIC_RREADY     (S_AXI_PBUS_PLIC_RREADY     ),

    .S_AXI_PBUS_CLINT_AWADDR    (S_AXI_PBUS_CLINT_AWADDR    ),
    .S_AXI_PBUS_CLINT_AWPROT    (S_AXI_PBUS_CLINT_AWPROT    ),
    .S_AXI_PBUS_CLINT_AWVALID   (S_AXI_PBUS_CLINT_AWVALID   ),
    .S_AXI_PBUS_CLINT_AWREADY   (S_AXI_PBUS_CLINT_AWREADY   ),
    .S_AXI_PBUS_CLINT_WDATA     (S_AXI_PBUS_CLINT_WDATA     ),
    .S_AXI_PBUS_CLINT_WSTRB     (S_AXI_PBUS_CLINT_WSTRB     ),
    .S_AXI_PBUS_CLINT_WVALID    (S_AXI_PBUS_CLINT_WVALID    ),
    .S_AXI_PBUS_CLINT_WREADY    (S_AXI_PBUS_CLINT_WREADY    ),
    .S_AXI_PBUS_CLINT_BRESP     (S_AXI_PBUS_CLINT_BRESP     ),
    .S_AXI_PBUS_CLINT_BVALID    (S_AXI_PBUS_CLINT_BVALID    ),
    .S_AXI_PBUS_CLINT_BREADY    (S_AXI_PBUS_CLINT_BREADY    ),
    .S_AXI_PBUS_CLINT_ARADDR    (S_AXI_PBUS_CLINT_ARADDR    ),
    .S_AXI_PBUS_CLINT_ARPROT    (S_AXI_PBUS_CLINT_ARPROT    ),
    .S_AXI_PBUS_CLINT_ARVALID   (S_AXI_PBUS_CLINT_ARVALID   ),
    .S_AXI_PBUS_CLINT_ARREADY   (S_AXI_PBUS_CLINT_ARREADY   ),
    .S_AXI_PBUS_CLINT_RDATA     (S_AXI_PBUS_CLINT_RDATA     ),
    .S_AXI_PBUS_CLINT_RRESP     (S_AXI_PBUS_CLINT_RRESP     ),
    .S_AXI_PBUS_CLINT_RVALID    (S_AXI_PBUS_CLINT_RVALID    ),
    .S_AXI_PBUS_CLINT_RREADY    (S_AXI_PBUS_CLINT_RREADY    ),

    .S_AXI_PBUS_CCFG_AWADDR     (S_AXI_PBUS_CCFG_AWADDR     ),
    .S_AXI_PBUS_CCFG_AWPROT     (S_AXI_PBUS_CCFG_AWPROT     ),
    .S_AXI_PBUS_CCFG_AWVALID    (S_AXI_PBUS_CCFG_AWVALID    ),
    .S_AXI_PBUS_CCFG_AWREADY    (S_AXI_PBUS_CCFG_AWREADY    ),
    .S_AXI_PBUS_CCFG_WDATA      (S_AXI_PBUS_CCFG_WDATA      ),
    .S_AXI_PBUS_CCFG_WSTRB      (S_AXI_PBUS_CCFG_WSTRB      ),
    .S_AXI_PBUS_CCFG_WVALID     (S_AXI_PBUS_CCFG_WVALID     ),
    .S_AXI_PBUS_CCFG_WREADY     (S_AXI_PBUS_CCFG_WREADY     ),
    .S_AXI_PBUS_CCFG_BRESP      (S_AXI_PBUS_CCFG_BRESP      ),
    .S_AXI_PBUS_CCFG_BVALID     (S_AXI_PBUS_CCFG_BVALID     ),
    .S_AXI_PBUS_CCFG_BREADY     (S_AXI_PBUS_CCFG_BREADY     ),
    .S_AXI_PBUS_CCFG_ARADDR     (S_AXI_PBUS_CCFG_ARADDR     ),
    .S_AXI_PBUS_CCFG_ARPROT     (S_AXI_PBUS_CCFG_ARPROT     ),
    .S_AXI_PBUS_CCFG_ARVALID    (S_AXI_PBUS_CCFG_ARVALID    ),
    .S_AXI_PBUS_CCFG_ARREADY    (S_AXI_PBUS_CCFG_ARREADY    ),
    .S_AXI_PBUS_CCFG_RDATA      (S_AXI_PBUS_CCFG_RDATA      ),
    .S_AXI_PBUS_CCFG_RRESP      (S_AXI_PBUS_CCFG_RRESP      ),
    .S_AXI_PBUS_CCFG_RVALID     (S_AXI_PBUS_CCFG_RVALID     ),
    .S_AXI_PBUS_CCFG_RREADY     (S_AXI_PBUS_CCFG_RREADY     )
);


//assign Static Values
assign M_AXI_IBUS_AWREGION = 0;
assign M_AXI_IBUS_ARREGION = 0;
assign M_AXI_DBUS_AWREGION = 0;
assign M_AXI_DBUS_ARREGION = 0;

`ifdef DEBUG_DBUS
    axi64_ILA dbus_ILA
    (
        .clk                    ( sys_clk                   ), // input wire clk
        .probe0                 ( M_AXI_DBUS_WREADY         ), // input wire [0:0] probe0    WREADY
        .probe1                 ( M_AXI_DBUS_AWADDR         ), // input wire [63:0]  probe1  AWADDR
        .probe2                 ( M_AXI_DBUS_BRESP          ), // input wire [1:0]  probe2   BRESP
        .probe3                 ( M_AXI_DBUS_BVALID         ), // input wire [0:0]  probe3   BVALID
        .probe4                 ( M_AXI_DBUS_BREADY         ), // input wire [0:0]  probe4   BREADY
        .probe5                 ( M_AXI_DBUS_ARADDR         ), // input wire [63:0]  probe5  ARADDR
        .probe6                 ( M_AXI_DBUS_RREADY         ), // input wire [0:0]  probe6   RREADY
        .probe7                 ( M_AXI_DBUS_WVALID         ), // input wire [0:0]  probe7   WVALID
        .probe8                 ( M_AXI_DBUS_ARVALID        ), // input wire [0:0]  probe8   ARVALID
        .probe9                 ( M_AXI_DBUS_ARREADY        ), // input wire [0:0]  probe9   ARREADY
        .probe10                ( M_AXI_DBUS_RDATA          ), // input wire [63:0]  probe10 RDATA
        .probe11                ( M_AXI_DBUS_AWVALID        ), // input wire [0:0]  probe11  AWVALID
        .probe12                ( M_AXI_DBUS_AWREADY        ), // input wire [0:0]  probe12  AWREADY
        .probe13                ( M_AXI_DBUS_RRESP          ), // input wire [1:0]  probe13  RRESP
        .probe14                ( M_AXI_DBUS_WDATA          ), // input wire [63:0]  probe14 WDATA
        .probe15                ( M_AXI_DBUS_WSTRB          ), // input wire [7:0]  probe15  WSTRB
        .probe16                ( M_AXI_DBUS_RVALID         ), // input wire [0:0]  probe16  RVALID
        .probe17                ( M_AXI_DBUS_ARPROT         ), // input wire [2:0]  probe17  ARPROT
        .probe18                ( M_AXI_DBUS_AWPROT         ), // input wire [2:0]  probe18  AWPROT
        .probe19                ( M_AXI_DBUS_AWID           ), // input wire [3:0]  probe19  AWID
        .probe20                ( M_AXI_DBUS_BID            ), // input wire [3:0]  probe20  BID
        .probe21                ( M_AXI_DBUS_AWLEN          ), // input wire [7:0]  probe21  AWLEN
        .probe22                ( 1'b0                      ), // input wire [0:0]  probe22  BUSER
        .probe23                ( M_AXI_DBUS_AWSIZE         ), // input wire [2:0]  probe23  AWSIZE
        .probe24                ( M_AXI_DBUS_AWBURST        ), // input wire [1:0]  probe24  AWBURST
        .probe25                ( M_AXI_DBUS_ARID           ), // input wire [3:0]  probe25  ARID
        .probe26                ( M_AXI_DBUS_AWLOCK         ), // input wire [0:0]  probe26  AWLOCK
        .probe27                ( M_AXI_DBUS_ARLEN          ), // input wire [7:0]  probe27  ARLEN
        .probe28                ( M_AXI_DBUS_ARSIZE         ), // input wire [2:0]  probe28  ARSIZE
        .probe29                ( M_AXI_DBUS_ARBURST        ), // input wire [1:0]  probe29  ARBUSRT
        .probe30                ( M_AXI_DBUS_ARLOCK         ), // input wire [0:0]  probe30  ARLOCK
        .probe31                ( M_AXI_DBUS_ARCACHE        ), // input wire [3:0]  probe31  ARCACHE
        .probe32                ( M_AXI_DBUS_AWCACHE        ), // input wire [3:0]  probe32  AWCACHE
        .probe33                ( M_AXI_DBUS_ARREGION       ), // input wire [3:0]  probe33  ARREGION
        .probe34                ( M_AXI_DBUS_ARQOS          ), // input wire [3:0]  probe34  ARQOS
        .probe35                ( 1'b0                      ), // input wire [0:0]  probe35  ARUSER
        .probe36                ( M_AXI_DBUS_AWREGION       ), // input wire [3:0]  probe36  AWREGION
        .probe37                ( M_AXI_DBUS_AWQOS          ), // input wire [3:0]  probe37  AWQOS
        .probe38                ( M_AXI_DBUS_RID            ), // input wire [3:0]  probe38  RID
        .probe39                ( 1'b0                      ), // input wire [0:0]  probe39  AWUSER
        .probe40                ( 1'b0                      ), // input wire [0:0]  probe40  WID
        .probe41                ( M_AXI_DBUS_RLAST          ), // input wire [0:0]  probe41  RLAST
        .probe42                ( 1'b0                      ), // input wire [0:0]  probe42  RUSER
        .probe43                ( M_AXI_DBUS_WLAST          )  // input wire [0:0]  probe43  WLAST
    );
`endif

`ifdef DEBUG_PBUS
    axilite32_ILA pbus_ILA
    (
        .clk                    ( sys_clk                   ), // input wire clk
        .probe0                 ( M_AXI_PBUS_CORE0_WREADY   ), // input wire [0:0] probe0      WREADY
        .probe1                 ( M_AXI_PBUS_CORE0_AWADDR   ), // input wire [31:0]  probe1    AWADDR
        .probe2                 ( M_AXI_PBUS_CORE0_BRESP    ), // input wire [1:0]  probe2     BRESP
        .probe3                 ( M_AXI_PBUS_CORE0_BVALID   ), // input wire [0:0]  probe3     BVALID
        .probe4                 ( M_AXI_PBUS_CORE0_BREADY   ), // input wire [0:0]  probe4     BREADY
        .probe5                 ( M_AXI_PBUS_CORE0_ARADDR   ), // input wire [31:0]  probe5    ARADDR
        .probe6                 ( M_AXI_PBUS_CORE0_RREADY   ), // input wire [0:0]  probe6     RREADY
        .probe7                 ( M_AXI_PBUS_CORE0_WVALID   ), // input wire [0:0]  probe7     WVALID
        .probe8                 ( M_AXI_PBUS_CORE0_ARVALID  ), // input wire [0:0]  probe8     ARVALID
        .probe9                 ( M_AXI_PBUS_CORE0_ARREADY  ), // input wire [0:0]  probe9     ARREADY
        .probe10                ( M_AXI_PBUS_CORE0_RDATA    ), // input wire [31:0]  probe10   RDATA
        .probe11                ( M_AXI_PBUS_CORE0_AWVALID  ), // input wire [0:0]  probe11    AWVALID
        .probe12                ( M_AXI_PBUS_CORE0_AWREADY  ), // input wire [0:0]  probe12    AWREADY
        .probe13                ( M_AXI_PBUS_CORE0_RRESP    ), // input wire [1:0]  probe13    RRESP
        .probe14                ( M_AXI_PBUS_CORE0_WDATA    ), // input wire [31:0]  probe14   WDATA
        .probe15                ( M_AXI_PBUS_CORE0_WSTRB    ), // input wire [3:0]  probe15    WSTRB
        .probe16                ( M_AXI_PBUS_CORE0_RVALID   ), // input wire [0:0]  probe16    RVALID
        .probe17                ( M_AXI_PBUS_CORE0_ARPROT   ), // input wire [2:0]  probe17    ARPROT
        .probe18                ( M_AXI_PBUS_CORE0_AWPROT   )  // input wire [2:0]  probe18    AWPROT
    );
`endif


endmodule

