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

module PBUS_XBar
(
    input  wire     sys_clk,
    input  wire     sys_rst,

    //Input Master PBUS From Core0
    input  wire [`C_AXI_PBUS_ADDR_WIDTH-1:0]        M_AXI_PBUS_CORE0_AWADDR,
    input  wire [2:0]                               M_AXI_PBUS_CORE0_AWPROT,
    input  wire                                     M_AXI_PBUS_CORE0_AWVALID,
    output wire                                     M_AXI_PBUS_CORE0_AWREADY,
    input  wire [`C_AXI_PBUS_DATA_WIDTH-1:0]        M_AXI_PBUS_CORE0_WDATA,
    input  wire [(`C_AXI_PBUS_DATA_WIDTH/8)-1:0]    M_AXI_PBUS_CORE0_WSTRB,
    input  wire                                     M_AXI_PBUS_CORE0_WVALID,
    output wire                                     M_AXI_PBUS_CORE0_WREADY,
    output wire [1:0]                               M_AXI_PBUS_CORE0_BRESP,
    output wire                                     M_AXI_PBUS_CORE0_BVALID,
    input  wire                                     M_AXI_PBUS_CORE0_BREADY,
    input  wire [`C_AXI_PBUS_ADDR_WIDTH-1:0]        M_AXI_PBUS_CORE0_ARADDR,
    input  wire [2:0]                               M_AXI_PBUS_CORE0_ARPROT,
    input  wire                                     M_AXI_PBUS_CORE0_ARVALID,
    output wire                                     M_AXI_PBUS_CORE0_ARREADY,
    output wire [`C_AXI_PBUS_DATA_WIDTH-1:0]        M_AXI_PBUS_CORE0_RDATA,
    output wire [1:0]                               M_AXI_PBUS_CORE0_RRESP,
    output wire                                     M_AXI_PBUS_CORE0_RVALID,
    input  wire                                     M_AXI_PBUS_CORE0_RREADY,

    //input  Slave PBUS to PLIC
    output wire [`C_AXI_PBUS_ADDR_WIDTH-1:0]        S_AXI_PBUS_PLIC_AWADDR,
    output wire [2:0]                               S_AXI_PBUS_PLIC_AWPROT,
    output wire                                     S_AXI_PBUS_PLIC_AWVALID,
    input  wire                                     S_AXI_PBUS_PLIC_AWREADY,
    output wire [`C_AXI_PBUS_DATA_WIDTH-1:0]        S_AXI_PBUS_PLIC_WDATA,
    output wire [(`C_AXI_PBUS_DATA_WIDTH/8)-1:0]    S_AXI_PBUS_PLIC_WSTRB,
    output wire                                     S_AXI_PBUS_PLIC_WVALID,
    input  wire                                     S_AXI_PBUS_PLIC_WREADY,
    input  wire [1:0]                               S_AXI_PBUS_PLIC_BRESP,
    input  wire                                     S_AXI_PBUS_PLIC_BVALID,
    output wire                                     S_AXI_PBUS_PLIC_BREADY,
    output wire [`C_AXI_PBUS_ADDR_WIDTH-1:0]        S_AXI_PBUS_PLIC_ARADDR,
    output wire [2:0]                               S_AXI_PBUS_PLIC_ARPROT,
    output wire                                     S_AXI_PBUS_PLIC_ARVALID,
    input  wire                                     S_AXI_PBUS_PLIC_ARREADY,
    input  wire [`C_AXI_PBUS_DATA_WIDTH-1:0]        S_AXI_PBUS_PLIC_RDATA,
    input  wire [1:0]                               S_AXI_PBUS_PLIC_RRESP,
    input  wire                                     S_AXI_PBUS_PLIC_RVALID,
    output wire                                     S_AXI_PBUS_PLIC_RREADY,

    //input  Slave PBUS to CLINT
    output wire [`C_AXI_PBUS_ADDR_WIDTH-1:0]        S_AXI_PBUS_CLINT_AWADDR,
    output wire [2:0]                               S_AXI_PBUS_CLINT_AWPROT,
    output wire                                     S_AXI_PBUS_CLINT_AWVALID,
    input  wire                                     S_AXI_PBUS_CLINT_AWREADY,
    output wire [`C_AXI_PBUS_DATA_WIDTH-1:0]        S_AXI_PBUS_CLINT_WDATA,
    output wire [(`C_AXI_PBUS_DATA_WIDTH/8)-1:0]    S_AXI_PBUS_CLINT_WSTRB,
    output wire                                     S_AXI_PBUS_CLINT_WVALID,
    input  wire                                     S_AXI_PBUS_CLINT_WREADY,
    input  wire [1:0]                               S_AXI_PBUS_CLINT_BRESP,
    input  wire                                     S_AXI_PBUS_CLINT_BVALID,
    output wire                                     S_AXI_PBUS_CLINT_BREADY,
    output wire [`C_AXI_PBUS_ADDR_WIDTH-1:0]        S_AXI_PBUS_CLINT_ARADDR,
    output wire [2:0]                               S_AXI_PBUS_CLINT_ARPROT,
    output wire                                     S_AXI_PBUS_CLINT_ARVALID,
    input  wire                                     S_AXI_PBUS_CLINT_ARREADY,
    input  wire [`C_AXI_PBUS_DATA_WIDTH-1:0]        S_AXI_PBUS_CLINT_RDATA,
    input  wire [1:0]                               S_AXI_PBUS_CLINT_RRESP,
    input  wire                                     S_AXI_PBUS_CLINT_RVALID,
    output wire                                     S_AXI_PBUS_CLINT_RREADY,

    //input  Slave PBUS to CoreCFG
    output wire [`C_AXI_PBUS_ADDR_WIDTH-1:0]        S_AXI_PBUS_CCFG_AWADDR,
    output wire [2:0]                               S_AXI_PBUS_CCFG_AWPROT,
    output wire                                     S_AXI_PBUS_CCFG_AWVALID,
    input  wire                                     S_AXI_PBUS_CCFG_AWREADY,
    output wire [`C_AXI_PBUS_DATA_WIDTH-1:0]        S_AXI_PBUS_CCFG_WDATA,
    output wire [(`C_AXI_PBUS_DATA_WIDTH/8)-1:0]    S_AXI_PBUS_CCFG_WSTRB,
    output wire                                     S_AXI_PBUS_CCFG_WVALID,
    input  wire                                     S_AXI_PBUS_CCFG_WREADY,
    input  wire [1:0]                               S_AXI_PBUS_CCFG_BRESP,
    input  wire                                     S_AXI_PBUS_CCFG_BVALID,
    output wire                                     S_AXI_PBUS_CCFG_BREADY,
    output wire [`C_AXI_PBUS_ADDR_WIDTH-1:0]        S_AXI_PBUS_CCFG_ARADDR,
    output wire [2:0]                               S_AXI_PBUS_CCFG_ARPROT,
    output wire                                     S_AXI_PBUS_CCFG_ARVALID,
    input  wire                                     S_AXI_PBUS_CCFG_ARREADY,
    input  wire [`C_AXI_PBUS_DATA_WIDTH-1:0]        S_AXI_PBUS_CCFG_RDATA,
    input  wire [1:0]                               S_AXI_PBUS_CCFG_RRESP,
    input  wire                                     S_AXI_PBUS_CCFG_RVALID,
    output wire                                     S_AXI_PBUS_CCFG_RREADY
);

//M00 => CoreCFG (base=0x0000_1000, size=0x0000_03FF [ 9:0])
//M01 => CLINT   (base=0x0200_0000, size=0x0000_FFFF [15:0])
//M02 => PLIC    (base=0x0C00_0000, size=0x00FF_F3FF [23:0])
//Consolidated Bus => {M02,M01,M00}
AXI4lite_PBUS_XBar AXI4lite_PBUS_XBar
(
  .aclk                         (sys_clk                    ),
  .aresetn                      (~sys_rst                   ),

  .s_axi_awaddr                 ( M_AXI_PBUS_CORE0_AWADDR         ), // input wire [31 : 0] s_axi_awaddr
  .s_axi_awprot                 ( M_AXI_PBUS_CORE0_AWPROT         ), // input wire [2 : 0] s_axi_awprot
  .s_axi_awvalid                ( M_AXI_PBUS_CORE0_AWVALID        ), // input wire [0 : 0] s_axi_awvalid
  .s_axi_awready                ( M_AXI_PBUS_CORE0_AWREADY        ), // output wire [0 : 0] s_axi_awready
  .s_axi_wdata                  ( M_AXI_PBUS_CORE0_WDATA          ), // input wire [31 : 0] s_axi_wdata
  .s_axi_wstrb                  ( M_AXI_PBUS_CORE0_WSTRB          ), // input wire [3 : 0] s_axi_wstrb
  .s_axi_wvalid                 ( M_AXI_PBUS_CORE0_WVALID         ), // input wire [0 : 0] s_axi_wvalid
  .s_axi_wready                 ( M_AXI_PBUS_CORE0_WREADY         ), // output wire [0 : 0] s_axi_wready
  .s_axi_bresp                  ( M_AXI_PBUS_CORE0_BRESP          ), // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid                 ( M_AXI_PBUS_CORE0_BVALID         ), // output wire [0 : 0] s_axi_bvalid
  .s_axi_bready                 ( M_AXI_PBUS_CORE0_BREADY         ), // input wire [0 : 0] s_axi_bready
  .s_axi_araddr                 ( M_AXI_PBUS_CORE0_ARADDR         ), // input wire [31 : 0] s_axi_araddr
  .s_axi_arprot                 ( M_AXI_PBUS_CORE0_ARPROT         ), // input wire [2 : 0] s_axi_arprot
  .s_axi_arvalid                ( M_AXI_PBUS_CORE0_ARVALID        ), // input wire [0 : 0] s_axi_arvalid
  .s_axi_arready                ( M_AXI_PBUS_CORE0_ARREADY        ), // output wire [0 : 0] s_axi_arready
  .s_axi_rdata                  ( M_AXI_PBUS_CORE0_RDATA          ), // output wire [31 : 0] s_axi_rdata
  .s_axi_rresp                  ( M_AXI_PBUS_CORE0_RRESP          ), // output wire [1 : 0] s_axi_rresp
  .s_axi_rvalid                 ( M_AXI_PBUS_CORE0_RVALID         ), // output wire [0 : 0] s_axi_rvalid
  .s_axi_rready                 ( M_AXI_PBUS_CORE0_RREADY         ), // input wire [0 : 0] s_axi_rready

  .m_axi_awaddr                 ({S_AXI_PBUS_PLIC_AWADDR ,S_AXI_PBUS_CLINT_AWADDR ,S_AXI_PBUS_CCFG_AWADDR }), // output wire [95 : 0] m_axi_awaddr
  .m_axi_awprot                 ({S_AXI_PBUS_PLIC_AWPROT ,S_AXI_PBUS_CLINT_AWPROT ,S_AXI_PBUS_CCFG_AWPROT }), // output wire [8 : 0] m_axi_awprot
  .m_axi_awvalid                ({S_AXI_PBUS_PLIC_AWVALID,S_AXI_PBUS_CLINT_AWVALID,S_AXI_PBUS_CCFG_AWVALID}), // output wire [2 : 0] m_axi_awvalid
  .m_axi_awready                ({S_AXI_PBUS_PLIC_AWREADY,S_AXI_PBUS_CLINT_AWREADY,S_AXI_PBUS_CCFG_AWREADY}), // input wire [2 : 0] m_axi_awready
  .m_axi_wdata                  ({S_AXI_PBUS_PLIC_WDATA  ,S_AXI_PBUS_CLINT_WDATA  ,S_AXI_PBUS_CCFG_WDATA  }), // output wire [95 : 0] m_axi_wdata
  .m_axi_wstrb                  ({S_AXI_PBUS_PLIC_WSTRB  ,S_AXI_PBUS_CLINT_WSTRB  ,S_AXI_PBUS_CCFG_WSTRB  }), // output wire [11 : 0] m_axi_wstrb
  .m_axi_wvalid                 ({S_AXI_PBUS_PLIC_WVALID ,S_AXI_PBUS_CLINT_WVALID ,S_AXI_PBUS_CCFG_WVALID }), // output wire [2 : 0] m_axi_wvalid
  .m_axi_wready                 ({S_AXI_PBUS_PLIC_WREADY ,S_AXI_PBUS_CLINT_WREADY ,S_AXI_PBUS_CCFG_WREADY }), // input wire [2 : 0] m_axi_wready
  .m_axi_bresp                  ({S_AXI_PBUS_PLIC_BRESP  ,S_AXI_PBUS_CLINT_BRESP  ,S_AXI_PBUS_CCFG_BRESP  }), // input wire [5 : 0] m_axi_bresp
  .m_axi_bvalid                 ({S_AXI_PBUS_PLIC_BVALID ,S_AXI_PBUS_CLINT_BVALID ,S_AXI_PBUS_CCFG_BVALID }), // input wire [2 : 0] m_axi_bvalid
  .m_axi_bready                 ({S_AXI_PBUS_PLIC_BREADY ,S_AXI_PBUS_CLINT_BREADY ,S_AXI_PBUS_CCFG_BREADY }), // output wire [2 : 0] m_axi_bready
  .m_axi_araddr                 ({S_AXI_PBUS_PLIC_ARADDR ,S_AXI_PBUS_CLINT_ARADDR ,S_AXI_PBUS_CCFG_ARADDR }), // output wire [95 : 0] m_axi_araddr
  .m_axi_arprot                 ({S_AXI_PBUS_PLIC_ARPROT ,S_AXI_PBUS_CLINT_ARPROT ,S_AXI_PBUS_CCFG_ARPROT }), // output wire [8 : 0] m_axi_arprot
  .m_axi_arvalid                ({S_AXI_PBUS_PLIC_ARVALID,S_AXI_PBUS_CLINT_ARVALID,S_AXI_PBUS_CCFG_ARVALID}), // output wire [2 : 0] m_axi_arvalid
  .m_axi_arready                ({S_AXI_PBUS_PLIC_ARREADY,S_AXI_PBUS_CLINT_ARREADY,S_AXI_PBUS_CCFG_ARREADY}), // input wire [2 : 0] m_axi_arready
  .m_axi_rdata                  ({S_AXI_PBUS_PLIC_RDATA  ,S_AXI_PBUS_CLINT_RDATA  ,S_AXI_PBUS_CCFG_RDATA  }), // input wire [95 : 0] m_axi_rdata
  .m_axi_rresp                  ({S_AXI_PBUS_PLIC_RRESP  ,S_AXI_PBUS_CLINT_RRESP  ,S_AXI_PBUS_CCFG_RRESP  }), // input wire [5 : 0] m_axi_rresp
  .m_axi_rvalid                 ({S_AXI_PBUS_PLIC_RVALID ,S_AXI_PBUS_CLINT_RVALID ,S_AXI_PBUS_CCFG_RVALID }), // input wire [2 : 0] m_axi_rvalid
  .m_axi_rready                 ({S_AXI_PBUS_PLIC_RREADY ,S_AXI_PBUS_CLINT_RREADY ,S_AXI_PBUS_CCFG_RREADY })  // output wire [2 : 0] m_axi_rready
);


endmodule
