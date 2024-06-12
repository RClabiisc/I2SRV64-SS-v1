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
module SoC_L3_XBar
(
    input  wire  clk,
    input  wire  rstn,

    //Master Bus AXI (64A, 64D) Peripheral Bus
    input  wire [3:0]                           M_AXI_L3PERI_AWID,
    input  wire [`C_AXI_L2_ADDR_WIDTH-1:0]      M_AXI_L3PERI_AWADDR,
    input  wire [7:0]                           M_AXI_L3PERI_AWLEN,
    input  wire [2:0]                           M_AXI_L3PERI_AWSIZE,
    input  wire [1:0]                           M_AXI_L3PERI_AWBURST,
    input  wire                                 M_AXI_L3PERI_AWLOCK,
    input  wire [3:0]                           M_AXI_L3PERI_AWCACHE,
    input  wire [2:0]                           M_AXI_L3PERI_AWPROT,
    input  wire [3:0]                           M_AXI_L3PERI_AWREGION,
    input  wire [3:0]                           M_AXI_L3PERI_AWQOS,
    input  wire                                 M_AXI_L3PERI_AWVALID,
    output wire                                 M_AXI_L3PERI_AWREADY,
    input  wire [`C_AXI_L2_DATA_WIDTH-1:0]      M_AXI_L3PERI_WDATA,
    input  wire [`C_AXI_L2_DATA_WIDTH/8-1:0]    M_AXI_L3PERI_WSTRB,
    input  wire                                 M_AXI_L3PERI_WLAST,
    input  wire                                 M_AXI_L3PERI_WVALID,
    output wire                                 M_AXI_L3PERI_WREADY,
    output wire [3:0]                           M_AXI_L3PERI_BID,
    output wire [1:0]                           M_AXI_L3PERI_BRESP,
    output wire                                 M_AXI_L3PERI_BVALID,
    input  wire                                 M_AXI_L3PERI_BREADY,
    input  wire [3:0]                           M_AXI_L3PERI_ARID,
    input  wire [`C_AXI_L2_ADDR_WIDTH-1:0]      M_AXI_L3PERI_ARADDR,
    input  wire [7:0]                           M_AXI_L3PERI_ARLEN,
    input  wire [2:0]                           M_AXI_L3PERI_ARSIZE,
    input  wire [1:0]                           M_AXI_L3PERI_ARBURST,
    input  wire                                 M_AXI_L3PERI_ARLOCK,
    input  wire [3:0]                           M_AXI_L3PERI_ARCACHE,
    input  wire [2:0]                           M_AXI_L3PERI_ARPROT,
    input  wire [3:0]                           M_AXI_L3PERI_ARREGION,
    input  wire [3:0]                           M_AXI_L3PERI_ARQOS,
    input  wire                                 M_AXI_L3PERI_ARVALID,
    output wire                                 M_AXI_L3PERI_ARREADY,
    output wire [3:0]                           M_AXI_L3PERI_RID,
    output wire [`C_AXI_L2_DATA_WIDTH-1:0]      M_AXI_L3PERI_RDATA,
    output wire [1:0]                           M_AXI_L3PERI_RRESP,
    output wire                                 M_AXI_L3PERI_RLAST,
    output wire                                 M_AXI_L3PERI_RVALID,
    input  wire                                 M_AXI_L3PERI_RREADY,

    //Slave 0 (Uart)
    output wire [`C_AXI_L3_ADDR_WIDTH-1:0]      S_AXI_UART_AWADDR,
    output wire [2:0]                           S_AXI_UART_AWPROT,
    output wire                                 S_AXI_UART_AWVALID,
    input  wire                                 S_AXI_UART_AWREADY,
    output wire [`C_AXI_L3_DATA_WIDTH-1:0]      S_AXI_UART_WDATA,
    output wire [(`C_AXI_L3_DATA_WIDTH/8)-1:0]  S_AXI_UART_WSTRB,
    output wire                                 S_AXI_UART_WVALID,
    input  wire                                 S_AXI_UART_WREADY,
    input  wire [1:0]                           S_AXI_UART_BRESP,
    input  wire                                 S_AXI_UART_BVALID,
    output wire                                 S_AXI_UART_BREADY,
    output wire [`C_AXI_L3_ADDR_WIDTH-1:0]      S_AXI_UART_ARADDR,
    output wire [2:0]                           S_AXI_UART_ARPROT,
    output wire                                 S_AXI_UART_ARVALID,
    input  wire                                 S_AXI_UART_ARREADY,
    input  wire [`C_AXI_L3_DATA_WIDTH-1:0]      S_AXI_UART_RDATA,
    input  wire [1:0]                           S_AXI_UART_RRESP,
    input  wire                                 S_AXI_UART_RVALID,
    output wire                                 S_AXI_UART_RREADY,

    //Slave 1 (GPIO0)
    output wire [`C_AXI_L3_ADDR_WIDTH-1:0]      S_AXI_GPIO0_AWADDR,
    output wire [2:0]                           S_AXI_GPIO0_AWPROT,
    output wire                                 S_AXI_GPIO0_AWVALID,
    input  wire                                 S_AXI_GPIO0_AWREADY,
    output wire [`C_AXI_L3_DATA_WIDTH-1:0]      S_AXI_GPIO0_WDATA,
    output wire [(`C_AXI_L3_DATA_WIDTH/8)-1:0]  S_AXI_GPIO0_WSTRB,
    output wire                                 S_AXI_GPIO0_WVALID,
    input  wire                                 S_AXI_GPIO0_WREADY,
    input  wire [1:0]                           S_AXI_GPIO0_BRESP,
    input  wire                                 S_AXI_GPIO0_BVALID,
    output wire                                 S_AXI_GPIO0_BREADY,
    output wire [`C_AXI_L3_ADDR_WIDTH-1:0]      S_AXI_GPIO0_ARADDR,
    output wire [2:0]                           S_AXI_GPIO0_ARPROT,
    output wire                                 S_AXI_GPIO0_ARVALID,
    input  wire                                 S_AXI_GPIO0_ARREADY,
    input  wire [`C_AXI_L3_DATA_WIDTH-1:0]      S_AXI_GPIO0_RDATA,
    input  wire [1:0]                           S_AXI_GPIO0_RRESP,
    input  wire                                 S_AXI_GPIO0_RVALID,
    output wire                                 S_AXI_GPIO0_RREADY,

    //Slave 2 (I2C)
    output wire [`C_AXI_L3_ADDR_WIDTH-1:0]      S_AXI_I2C_AWADDR,
    output wire [2:0]                           S_AXI_I2C_AWPROT,
    output wire                                 S_AXI_I2C_AWVALID,
    input  wire                                 S_AXI_I2C_AWREADY,
    output wire [`C_AXI_L3_DATA_WIDTH-1:0]      S_AXI_I2C_WDATA,
    output wire [(`C_AXI_L3_DATA_WIDTH/8)-1:0]  S_AXI_I2C_WSTRB,
    output wire                                 S_AXI_I2C_WVALID,
    input  wire                                 S_AXI_I2C_WREADY,
    input  wire [1:0]                           S_AXI_I2C_BRESP,
    input  wire                                 S_AXI_I2C_BVALID,
    output wire                                 S_AXI_I2C_BREADY,
    output wire [`C_AXI_L3_ADDR_WIDTH-1:0]      S_AXI_I2C_ARADDR,
    output wire [2:0]                           S_AXI_I2C_ARPROT,
    output wire                                 S_AXI_I2C_ARVALID,
    input  wire                                 S_AXI_I2C_ARREADY,
    input  wire [`C_AXI_L3_DATA_WIDTH-1:0]      S_AXI_I2C_RDATA,
    input  wire [1:0]                           S_AXI_I2C_RRESP,
    input  wire                                 S_AXI_I2C_RVALID,
    output wire                                 S_AXI_I2C_RREADY,

    //Slave 3 (Timer)
    output wire [`C_AXI_L3_ADDR_WIDTH-1:0]      S_AXI_TIMER_AWADDR,
    output wire [2:0]                           S_AXI_TIMER_AWPROT,
    output wire                                 S_AXI_TIMER_AWVALID,
    input  wire                                 S_AXI_TIMER_AWREADY,
    output wire [`C_AXI_L3_DATA_WIDTH-1:0]      S_AXI_TIMER_WDATA,
    output wire [(`C_AXI_L3_DATA_WIDTH/8)-1:0]  S_AXI_TIMER_WSTRB,
    output wire                                 S_AXI_TIMER_WVALID,
    input  wire                                 S_AXI_TIMER_WREADY,
    input  wire [1:0]                           S_AXI_TIMER_BRESP,
    input  wire                                 S_AXI_TIMER_BVALID,
    output wire                                 S_AXI_TIMER_BREADY,
    output wire [`C_AXI_L3_ADDR_WIDTH-1:0]      S_AXI_TIMER_ARADDR,
    output wire [2:0]                           S_AXI_TIMER_ARPROT,
    output wire                                 S_AXI_TIMER_ARVALID,
    input  wire                                 S_AXI_TIMER_ARREADY,
    input  wire [`C_AXI_L3_DATA_WIDTH-1:0]      S_AXI_TIMER_RDATA,
    input  wire [1:0]                           S_AXI_TIMER_RRESP,
    input  wire                                 S_AXI_TIMER_RVALID,
    output wire                                 S_AXI_TIMER_RREADY,

    //Slave 4 (SPI)
    output wire [`C_AXI_L3_ADDR_WIDTH-1:0]      S_AXI_SPI_AWADDR,
    output wire [2:0]                           S_AXI_SPI_AWPROT,
    output wire                                 S_AXI_SPI_AWVALID,
    input  wire                                 S_AXI_SPI_AWREADY,
    output wire [`C_AXI_L3_DATA_WIDTH-1:0]      S_AXI_SPI_WDATA,
    output wire [(`C_AXI_L3_DATA_WIDTH/8)-1:0]  S_AXI_SPI_WSTRB,
    output wire                                 S_AXI_SPI_WVALID,
    input  wire                                 S_AXI_SPI_WREADY,
    input  wire [1:0]                           S_AXI_SPI_BRESP,
    input  wire                                 S_AXI_SPI_BVALID,
    output wire                                 S_AXI_SPI_BREADY,
    output wire [`C_AXI_L3_ADDR_WIDTH-1:0]      S_AXI_SPI_ARADDR,
    output wire [2:0]                           S_AXI_SPI_ARPROT,
    output wire                                 S_AXI_SPI_ARVALID,
    input  wire                                 S_AXI_SPI_ARREADY,
    input  wire [`C_AXI_L3_DATA_WIDTH-1:0]      S_AXI_SPI_RDATA,
    input  wire [1:0]                           S_AXI_SPI_RRESP,
    input  wire                                 S_AXI_SPI_RVALID,
    output wire                                 S_AXI_SPI_RREADY,

    //Slave 5 (GPIO1)
    output wire [`C_AXI_L3_ADDR_WIDTH-1:0]      S_AXI_GPIO1_AWADDR,
    output wire [2:0]                           S_AXI_GPIO1_AWPROT,
    output wire                                 S_AXI_GPIO1_AWVALID,
    input  wire                                 S_AXI_GPIO1_AWREADY,
    output wire [`C_AXI_L3_DATA_WIDTH-1:0]      S_AXI_GPIO1_WDATA,
    output wire [(`C_AXI_L3_DATA_WIDTH/8)-1:0]  S_AXI_GPIO1_WSTRB,
    output wire                                 S_AXI_GPIO1_WVALID,
    input  wire                                 S_AXI_GPIO1_WREADY,
    input  wire [1:0]                           S_AXI_GPIO1_BRESP,
    input  wire                                 S_AXI_GPIO1_BVALID,
    output wire                                 S_AXI_GPIO1_BREADY,
    output wire [`C_AXI_L3_ADDR_WIDTH-1:0]      S_AXI_GPIO1_ARADDR,
    output wire [2:0]                           S_AXI_GPIO1_ARPROT,
    output wire                                 S_AXI_GPIO1_ARVALID,
    input  wire                                 S_AXI_GPIO1_ARREADY,
    input  wire [`C_AXI_L3_DATA_WIDTH-1:0]      S_AXI_GPIO1_RDATA,
    input  wire [1:0]                           S_AXI_GPIO1_RRESP,
    input  wire                                 S_AXI_GPIO1_RVALID,
    output wire                                 S_AXI_GPIO1_RREADY
);

/*****************
*  Local Wires  *
*****************/
//Wires for AXI32
wire [3:0]                          M_AXI_L3PERI_AXI32_AWID = 0;
wire [`C_AXI_L3_ADDR_WIDTH-1:0]     M_AXI_L3PERI_AXI32_AWADDR;
wire [7:0]                          M_AXI_L3PERI_AXI32_AWLEN;
wire [2:0]                          M_AXI_L3PERI_AXI32_AWSIZE;
wire [1:0]                          M_AXI_L3PERI_AXI32_AWBURST;
wire                                M_AXI_L3PERI_AXI32_AWLOCK;
wire [3:0]                          M_AXI_L3PERI_AXI32_AWCACHE;
wire [2:0]                          M_AXI_L3PERI_AXI32_AWPROT;
wire [3:0]                          M_AXI_L3PERI_AXI32_AWREGION;
wire [3:0]                          M_AXI_L3PERI_AXI32_AWQOS;
wire                                M_AXI_L3PERI_AXI32_AWVALID;
wire                                M_AXI_L3PERI_AXI32_AWREADY;
wire [`C_AXI_L3_DATA_WIDTH-1:0]     M_AXI_L3PERI_AXI32_WDATA;
wire [`C_AXI_L3_DATA_WIDTH/8-1:0]   M_AXI_L3PERI_AXI32_WSTRB;
wire                                M_AXI_L3PERI_AXI32_WLAST;
wire                                M_AXI_L3PERI_AXI32_WVALID;
wire                                M_AXI_L3PERI_AXI32_WREADY;
wire [3:0]                          M_AXI_L3PERI_AXI32_BID;
wire [1:0]                          M_AXI_L3PERI_AXI32_BRESP;
wire                                M_AXI_L3PERI_AXI32_BVALID;
wire                                M_AXI_L3PERI_AXI32_BREADY;
wire [3:0]                          M_AXI_L3PERI_AXI32_ARID = 0;
wire [`C_AXI_L3_ADDR_WIDTH-1:0]     M_AXI_L3PERI_AXI32_ARADDR;
wire [7:0]                          M_AXI_L3PERI_AXI32_ARLEN;
wire [2:0]                          M_AXI_L3PERI_AXI32_ARSIZE;
wire [1:0]                          M_AXI_L3PERI_AXI32_ARBURST;
wire                                M_AXI_L3PERI_AXI32_ARLOCK;
wire [3:0]                          M_AXI_L3PERI_AXI32_ARCACHE;
wire [2:0]                          M_AXI_L3PERI_AXI32_ARPROT;
wire [3:0]                          M_AXI_L3PERI_AXI32_ARREGION;
wire [3:0]                          M_AXI_L3PERI_AXI32_ARQOS;
wire                                M_AXI_L3PERI_AXI32_ARVALID;
wire                                M_AXI_L3PERI_AXI32_ARREADY;
wire [3:0]                          M_AXI_L3PERI_AXI32_RID;
wire [`C_AXI_L3_DATA_WIDTH-1:0]     M_AXI_L3PERI_AXI32_RDATA;
wire [1:0]                          M_AXI_L3PERI_AXI32_RRESP;
wire                                M_AXI_L3PERI_AXI32_RLAST;
wire                                M_AXI_L3PERI_AXI32_RVALID;
wire                                M_AXI_L3PERI_AXI32_RREADY;

//Wires for AXIlite32
wire [`C_AXI_L3_ADDR_WIDTH-1:0]     M_AXI_L3PERI_AXILITE32_AWADDR;
wire [2:0]                          M_AXI_L3PERI_AXILITE32_AWPROT;
wire                                M_AXI_L3PERI_AXILITE32_AWVALID;
wire                                M_AXI_L3PERI_AXILITE32_AWREADY;
wire [`C_AXI_L3_DATA_WIDTH-1:0]     M_AXI_L3PERI_AXILITE32_WDATA;
wire [(`C_AXI_L3_DATA_WIDTH/8)-1:0] M_AXI_L3PERI_AXILITE32_WSTRB;
wire                                M_AXI_L3PERI_AXILITE32_WVALID;
wire                                M_AXI_L3PERI_AXILITE32_WREADY;
wire [1:0]                          M_AXI_L3PERI_AXILITE32_BRESP;
wire                                M_AXI_L3PERI_AXILITE32_BVALID;
wire                                M_AXI_L3PERI_AXILITE32_BREADY;
wire [`C_AXI_L3_ADDR_WIDTH-1:0]     M_AXI_L3PERI_AXILITE32_ARADDR;
wire [2:0]                          M_AXI_L3PERI_AXILITE32_ARPROT;
wire                                M_AXI_L3PERI_AXILITE32_ARVALID;
wire                                M_AXI_L3PERI_AXILITE32_ARREADY;
wire [`C_AXI_L3_DATA_WIDTH-1:0]     M_AXI_L3PERI_AXILITE32_RDATA;
wire [1:0]                          M_AXI_L3PERI_AXILITE32_RRESP;
wire                                M_AXI_L3PERI_AXILITE32_RVALID;
wire                                M_AXI_L3PERI_AXILITE32_RREADY;


/**************************************
*  AXI64 to AXI32 Data Converter IP  *
**************************************/
axi64_to_axi32 axi64_to_axi32_L3XBar
(
    .s_axi_aclk     (clk                            ), // input wire s_axi_aclk
    .s_axi_aresetn  (rstn                           ), // input wire s_axi_aresetn

    .s_axi_awid     (M_AXI_L3PERI_AWID              ), // input wire [3 : 0] s_axi_awid
    .s_axi_awaddr   (M_AXI_L3PERI_AWADDR            ), // input wire [63 : 0] s_axi_awaddr
    .s_axi_awlen    (M_AXI_L3PERI_AWLEN             ), // input wire [7 : 0] s_axi_awlen
    .s_axi_awsize   (M_AXI_L3PERI_AWSIZE            ), // input wire [2 : 0] s_axi_awsize
    .s_axi_awburst  (M_AXI_L3PERI_AWBURST           ), // input wire [1 : 0] s_axi_awburst
    .s_axi_awlock   (M_AXI_L3PERI_AWLOCK            ), // input wire [0 : 0] s_axi_awlock
    .s_axi_awcache  (M_AXI_L3PERI_AWCACHE           ), // input wire [3 : 0] s_axi_awcache
    .s_axi_awprot   (M_AXI_L3PERI_AWPROT            ), // input wire [2 : 0] s_axi_awprot
    .s_axi_awregion (M_AXI_L3PERI_AWREGION          ), // input wire [3 : 0] s_axi_awregion
    .s_axi_awqos    (M_AXI_L3PERI_AWQOS             ), // input wire [3 : 0] s_axi_awqos
    .s_axi_awvalid  (M_AXI_L3PERI_AWVALID           ), // input wire s_axi_awvalid
    .s_axi_awready  (M_AXI_L3PERI_AWREADY           ), // output wire s_axi_awready
    .s_axi_wdata    (M_AXI_L3PERI_WDATA             ), // input wire [63 : 0] s_axi_wdata
    .s_axi_wstrb    (M_AXI_L3PERI_WSTRB             ), // input wire [7 : 0] s_axi_wstrb
    .s_axi_wlast    (M_AXI_L3PERI_WLAST             ), // input wire s_axi_wlast
    .s_axi_wvalid   (M_AXI_L3PERI_WVALID            ), // input wire s_axi_wvalid
    .s_axi_wready   (M_AXI_L3PERI_WREADY            ), // output wire s_axi_wready
    .s_axi_bid      (M_AXI_L3PERI_BID               ), // output wire [3 : 0] s_axi_bid
    .s_axi_bresp    (M_AXI_L3PERI_BRESP             ), // output wire [1 : 0] s_axi_bresp
    .s_axi_bvalid   (M_AXI_L3PERI_BVALID            ), // output wire s_axi_bvalid
    .s_axi_bready   (M_AXI_L3PERI_BREADY            ), // input wire s_axi_bready
    .s_axi_arid     (M_AXI_L3PERI_ARID              ), // input wire [3 : 0] s_axi_arid
    .s_axi_araddr   (M_AXI_L3PERI_ARADDR            ), // input wire [63 : 0] s_axi_araddr
    .s_axi_arlen    (M_AXI_L3PERI_ARLEN             ), // input wire [7 : 0] s_axi_arlen
    .s_axi_arsize   (M_AXI_L3PERI_ARSIZE            ), // input wire [2 : 0] s_axi_arsize
    .s_axi_arburst  (M_AXI_L3PERI_ARBURST           ), // input wire [1 : 0] s_axi_arburst
    .s_axi_arlock   (M_AXI_L3PERI_ARLOCK            ), // input wire [0 : 0] s_axi_arlock
    .s_axi_arcache  (M_AXI_L3PERI_ARCACHE           ), // input wire [3 : 0] s_axi_arcache
    .s_axi_arprot   (M_AXI_L3PERI_ARPROT            ), // input wire [2 : 0] s_axi_arprot
    .s_axi_arregion (M_AXI_L3PERI_ARREGION          ), // input wire [3 : 0] s_axi_arregion
    .s_axi_arqos    (M_AXI_L3PERI_ARQOS             ), // input wire [3 : 0] s_axi_arqos
    .s_axi_arvalid  (M_AXI_L3PERI_ARVALID           ), // input wire s_axi_arvalid
    .s_axi_arready  (M_AXI_L3PERI_ARREADY           ), // output wire s_axi_arready
    .s_axi_rid      (M_AXI_L3PERI_RID               ), // output wire [3 : 0] s_axi_rid
    .s_axi_rdata    (M_AXI_L3PERI_RDATA             ), // output wire [63 : 0] s_axi_rdata
    .s_axi_rresp    (M_AXI_L3PERI_RRESP             ), // output wire [1 : 0] s_axi_rresp
    .s_axi_rlast    (M_AXI_L3PERI_RLAST             ), // output wire s_axi_rlast
    .s_axi_rvalid   (M_AXI_L3PERI_RVALID            ), // output wire s_axi_rvalid
    .s_axi_rready   (M_AXI_L3PERI_RREADY            ), // input wire s_axi_rready

    .m_axi_awaddr   (M_AXI_L3PERI_AXI32_AWADDR      ), // output wire [63 : 0] m_axi_awaddr
    .m_axi_awlen    (M_AXI_L3PERI_AXI32_AWLEN       ), // output wire [7 : 0] m_axi_awlen
    .m_axi_awsize   (M_AXI_L3PERI_AXI32_AWSIZE      ), // output wire [2 : 0] m_axi_awsize
    .m_axi_awburst  (M_AXI_L3PERI_AXI32_AWBURST     ), // output wire [1 : 0] m_axi_awburst
    .m_axi_awlock   (M_AXI_L3PERI_AXI32_AWLOCK      ), // output wire [0 : 0] m_axi_awlock
    .m_axi_awcache  (M_AXI_L3PERI_AXI32_AWCACHE     ), // output wire [3 : 0] m_axi_awcache
    .m_axi_awprot   (M_AXI_L3PERI_AXI32_AWPROT      ), // output wire [2 : 0] m_axi_awprot
    .m_axi_awregion (M_AXI_L3PERI_AXI32_AWREGION    ), // output wire [3 : 0] m_axi_awregion
    .m_axi_awqos    (M_AXI_L3PERI_AXI32_AWQOS       ), // output wire [3 : 0] m_axi_awqos
    .m_axi_awvalid  (M_AXI_L3PERI_AXI32_AWVALID     ), // output wire m_axi_awvalid
    .m_axi_awready  (M_AXI_L3PERI_AXI32_AWREADY     ), // input wire m_axi_awready
    .m_axi_wdata    (M_AXI_L3PERI_AXI32_WDATA       ), // output wire [31 : 0] m_axi_wdata
    .m_axi_wstrb    (M_AXI_L3PERI_AXI32_WSTRB       ), // output wire [3 : 0] m_axi_wstrb
    .m_axi_wlast    (M_AXI_L3PERI_AXI32_WLAST       ), // output wire m_axi_wlast
    .m_axi_wvalid   (M_AXI_L3PERI_AXI32_WVALID      ), // output wire m_axi_wvalid
    .m_axi_wready   (M_AXI_L3PERI_AXI32_WREADY      ), // input wire m_axi_wready
    .m_axi_bresp    (M_AXI_L3PERI_AXI32_BRESP       ), // input wire [1 : 0] m_axi_bresp
    .m_axi_bvalid   (M_AXI_L3PERI_AXI32_BVALID      ), // input wire m_axi_bvalid
    .m_axi_bready   (M_AXI_L3PERI_AXI32_BREADY      ), // output wire m_axi_bready
    .m_axi_araddr   (M_AXI_L3PERI_AXI32_ARADDR      ), // output wire [63 : 0] m_axi_araddr
    .m_axi_arlen    (M_AXI_L3PERI_AXI32_ARLEN       ), // output wire [7 : 0] m_axi_arlen
    .m_axi_arsize   (M_AXI_L3PERI_AXI32_ARSIZE      ), // output wire [2 : 0] m_axi_arsize
    .m_axi_arburst  (M_AXI_L3PERI_AXI32_ARBURST     ), // output wire [1 : 0] m_axi_arburst
    .m_axi_arlock   (M_AXI_L3PERI_AXI32_ARLOCK      ), // output wire [0 : 0] m_axi_arlock
    .m_axi_arcache  (M_AXI_L3PERI_AXI32_ARCACHE     ), // output wire [3 : 0] m_axi_arcache
    .m_axi_arprot   (M_AXI_L3PERI_AXI32_ARPROT      ), // output wire [2 : 0] m_axi_arprot
    .m_axi_arregion (M_AXI_L3PERI_AXI32_ARREGION    ), // output wire [3 : 0] m_axi_arregion
    .m_axi_arqos    (M_AXI_L3PERI_AXI32_ARQOS       ), // output wire [3 : 0] m_axi_arqos
    .m_axi_arvalid  (M_AXI_L3PERI_AXI32_ARVALID     ), // output wire m_axi_arvalid
    .m_axi_arready  (M_AXI_L3PERI_AXI32_ARREADY     ), // input wire m_axi_arready
    .m_axi_rdata    (M_AXI_L3PERI_AXI32_RDATA       ), // input wire [31 : 0] m_axi_rdata
    .m_axi_rresp    (M_AXI_L3PERI_AXI32_RRESP       ), // input wire [1 : 0] m_axi_rresp
    .m_axi_rlast    (M_AXI_L3PERI_AXI32_RLAST       ), // input wire m_axi_rlast
    .m_axi_rvalid   (M_AXI_L3PERI_AXI32_RVALID      ), // input wire m_axi_rvalid
    .m_axi_rready   (M_AXI_L3PERI_AXI32_RREADY      )  // output wire m_axi_rready
);

/**********************************************
*  AXI32 to AXIlite32 Protocol Converter IP  *
**********************************************/
axi32_to_axilite32 axi32_to_axilite32_L3XBar
(
    .aclk           (clk                            ), // input wire aclk
    .aresetn        (rstn                           ), // input wire aresetn

    .s_axi_awid     (M_AXI_L3PERI_AXI32_AWID        ), // input wire [3 : 0] s_axi_awid
    .s_axi_awaddr   (M_AXI_L3PERI_AXI32_AWADDR      ), // input wire [63 : 0] s_axi_awaddr
    .s_axi_awlen    (M_AXI_L3PERI_AXI32_AWLEN       ), // input wire [7 : 0] s_axi_awlen
    .s_axi_awsize   (M_AXI_L3PERI_AXI32_AWSIZE      ), // input wire [2 : 0] s_axi_awsize
    .s_axi_awburst  (M_AXI_L3PERI_AXI32_AWBURST     ), // input wire [1 : 0] s_axi_awburst
    .s_axi_awlock   (M_AXI_L3PERI_AXI32_AWLOCK      ), // input wire [0 : 0] s_axi_awlock
    .s_axi_awcache  (M_AXI_L3PERI_AXI32_AWCACHE     ), // input wire [3 : 0] s_axi_awcache
    .s_axi_awprot   (M_AXI_L3PERI_AXI32_AWPROT      ), // input wire [2 : 0] s_axi_awprot
    .s_axi_awregion (M_AXI_L3PERI_AXI32_AWREGION    ), // input wire [3 : 0] s_axi_awregion
    .s_axi_awqos    (M_AXI_L3PERI_AXI32_AWQOS       ), // input wire [3 : 0] s_axi_awqos
    .s_axi_awvalid  (M_AXI_L3PERI_AXI32_AWVALID     ), // input wire s_axi_awvalid
    .s_axi_awready  (M_AXI_L3PERI_AXI32_AWREADY     ), // output wire s_axi_awready
    .s_axi_wdata    (M_AXI_L3PERI_AXI32_WDATA       ), // input wire [31 : 0] s_axi_wdata
    .s_axi_wstrb    (M_AXI_L3PERI_AXI32_WSTRB       ), // input wire [3 : 0] s_axi_wstrb
    .s_axi_wlast    (M_AXI_L3PERI_AXI32_WLAST       ), // input wire s_axi_wlast
    .s_axi_wvalid   (M_AXI_L3PERI_AXI32_WVALID      ), // input wire s_axi_wvalid
    .s_axi_wready   (M_AXI_L3PERI_AXI32_WREADY      ), // output wire s_axi_wready
    .s_axi_bid      (M_AXI_L3PERI_AXI32_BID         ), // output wire [3 : 0] s_axi_bid
    .s_axi_bresp    (M_AXI_L3PERI_AXI32_BRESP       ), // output wire [1 : 0] s_axi_bresp
    .s_axi_bvalid   (M_AXI_L3PERI_AXI32_BVALID      ), // output wire s_axi_bvalid
    .s_axi_bready   (M_AXI_L3PERI_AXI32_BREADY      ), // input wire s_axi_bready
    .s_axi_arid     (M_AXI_L3PERI_AXI32_ARID        ), // input wire [3 : 0] s_axi_arid
    .s_axi_araddr   (M_AXI_L3PERI_AXI32_ARADDR      ), // input wire [63 : 0] s_axi_araddr
    .s_axi_arlen    (M_AXI_L3PERI_AXI32_ARLEN       ), // input wire [7 : 0] s_axi_arlen
    .s_axi_arsize   (M_AXI_L3PERI_AXI32_ARSIZE      ), // input wire [2 : 0] s_axi_arsize
    .s_axi_arburst  (M_AXI_L3PERI_AXI32_ARBURST     ), // input wire [1 : 0] s_axi_arburst
    .s_axi_arlock   (M_AXI_L3PERI_AXI32_ARLOCK      ), // input wire [0 : 0] s_axi_arlock
    .s_axi_arcache  (M_AXI_L3PERI_AXI32_ARCACHE     ), // input wire [3 : 0] s_axi_arcache
    .s_axi_arprot   (M_AXI_L3PERI_AXI32_ARPROT      ), // input wire [2 : 0] s_axi_arprot
    .s_axi_arregion (M_AXI_L3PERI_AXI32_ARREGION    ), // input wire [3 : 0] s_axi_arregion
    .s_axi_arqos    (M_AXI_L3PERI_AXI32_ARQOS       ), // input wire [3 : 0] s_axi_arqos
    .s_axi_arvalid  (M_AXI_L3PERI_AXI32_ARVALID     ), // input wire s_axi_arvalid
    .s_axi_arready  (M_AXI_L3PERI_AXI32_ARREADY     ), // output wire s_axi_arready
    .s_axi_rid      (M_AXI_L3PERI_AXI32_RID         ), // output wire [3 : 0] s_axi_rid
    .s_axi_rdata    (M_AXI_L3PERI_AXI32_RDATA       ), // output wire [31 : 0] s_axi_rdata
    .s_axi_rresp    (M_AXI_L3PERI_AXI32_RRESP       ), // output wire [1 : 0] s_axi_rresp
    .s_axi_rlast    (M_AXI_L3PERI_AXI32_RLAST       ), // output wire s_axi_rlast
    .s_axi_rvalid   (M_AXI_L3PERI_AXI32_RVALID      ), // output wire s_axi_rvalid
    .s_axi_rready   (M_AXI_L3PERI_AXI32_RREADY      ), // input wire s_axi_rready

    .m_axi_awaddr   (M_AXI_L3PERI_AXILITE32_AWADDR  ), // output wire [63 : 0] m_axi_awaddr
    .m_axi_awprot   (M_AXI_L3PERI_AXILITE32_AWPROT  ), // output wire [2 : 0] m_axi_awprot
    .m_axi_awvalid  (M_AXI_L3PERI_AXILITE32_AWVALID ), // output wire m_axi_awvalid
    .m_axi_awready  (M_AXI_L3PERI_AXILITE32_AWREADY ), // input wire m_axi_awready
    .m_axi_wdata    (M_AXI_L3PERI_AXILITE32_WDATA   ), // output wire [31 : 0] m_axi_wdata
    .m_axi_wstrb    (M_AXI_L3PERI_AXILITE32_WSTRB   ), // output wire [3 : 0] m_axi_wstrb
    .m_axi_wvalid   (M_AXI_L3PERI_AXILITE32_WVALID  ), // output wire m_axi_wvalid
    .m_axi_wready   (M_AXI_L3PERI_AXILITE32_WREADY  ), // input wire m_axi_wready
    .m_axi_bresp    (M_AXI_L3PERI_AXILITE32_BRESP   ), // input wire [1 : 0] m_axi_bresp
    .m_axi_bvalid   (M_AXI_L3PERI_AXILITE32_BVALID  ), // input wire m_axi_bvalid
    .m_axi_bready   (M_AXI_L3PERI_AXILITE32_BREADY  ), // output wire m_axi_bready
    .m_axi_araddr   (M_AXI_L3PERI_AXILITE32_ARADDR  ), // output wire [63 : 0] m_axi_araddr
    .m_axi_arprot   (M_AXI_L3PERI_AXILITE32_ARPROT  ), // output wire [2 : 0] m_axi_arprot
    .m_axi_arvalid  (M_AXI_L3PERI_AXILITE32_ARVALID ), // output wire m_axi_arvalid
    .m_axi_arready  (M_AXI_L3PERI_AXILITE32_ARREADY ), // input wire m_axi_arready
    .m_axi_rdata    (M_AXI_L3PERI_AXILITE32_RDATA   ), // input wire [31 : 0] m_axi_rdata
    .m_axi_rresp    (M_AXI_L3PERI_AXILITE32_RRESP   ), // input wire [1 : 0] m_axi_rresp
    .m_axi_rvalid   (M_AXI_L3PERI_AXILITE32_RVALID  ), // input wire m_axi_rvalid
    .m_axi_rready   (M_AXI_L3PERI_AXILITE32_RREADY  )  // output wire m_axi_rready
);

/******************************
*  AXIlite32 L3 CrossBar IP  *
******************************/
//M00 = DBUS (As AXIlite 64A 32D)
//S00 = UART            (0x2000_0000 to 0x2000_0FFF)
//S01 = GPIO0           (0x2001_0000 to 0x2001_0FFF)
//S02 = I2C             (0x2002_0000 to 0x2002_0FFF)
//S03 = Timer           (0x2003_0000 to 0x2003_0FFF)
//S04 = SPI             (0x2004_0000 to 0x2004_0FFF)
//S05 = GPIO1           (0x2005_0000 to 0x2005_0FFF)
AXIlite32_L3_XBar AXIlite32_L3_XBar
(
    .aclk           (clk                            ), // input wire aclk
    .aresetn        (rstn                           ), // input wire aresetn

    .s_axi_awaddr   (M_AXI_L3PERI_AXILITE32_AWADDR  ), // input wire [63 : 0] s_axi_awaddr
    .s_axi_awprot   (M_AXI_L3PERI_AXILITE32_AWPROT  ), // input wire [2 : 0] s_axi_awprot
    .s_axi_awvalid  (M_AXI_L3PERI_AXILITE32_AWVALID ), // input wire [0 : 0] s_axi_awvalid
    .s_axi_awready  (M_AXI_L3PERI_AXILITE32_AWREADY ), // output wire [0 : 0] s_axi_awready
    .s_axi_wdata    (M_AXI_L3PERI_AXILITE32_WDATA   ), // input wire [31 : 0] s_axi_wdata
    .s_axi_wstrb    (M_AXI_L3PERI_AXILITE32_WSTRB   ), // input wire [3 : 0] s_axi_wstrb
    .s_axi_wvalid   (M_AXI_L3PERI_AXILITE32_WVALID  ), // input wire [0 : 0] s_axi_wvalid
    .s_axi_wready   (M_AXI_L3PERI_AXILITE32_WREADY  ), // output wire [0 : 0] s_axi_wready
    .s_axi_bresp    (M_AXI_L3PERI_AXILITE32_BRESP   ), // output wire [1 : 0] s_axi_bresp
    .s_axi_bvalid   (M_AXI_L3PERI_AXILITE32_BVALID  ), // output wire [0 : 0] s_axi_bvalid
    .s_axi_bready   (M_AXI_L3PERI_AXILITE32_BREADY  ), // input wire [0 : 0] s_axi_bready
    .s_axi_araddr   (M_AXI_L3PERI_AXILITE32_ARADDR  ), // input wire [63 : 0] s_axi_araddr
    .s_axi_arprot   (M_AXI_L3PERI_AXILITE32_ARPROT  ), // input wire [2 : 0] s_axi_arprot
    .s_axi_arvalid  (M_AXI_L3PERI_AXILITE32_ARVALID ), // input wire [0 : 0] s_axi_arvalid
    .s_axi_arready  (M_AXI_L3PERI_AXILITE32_ARREADY ), // output wire [0 : 0] s_axi_arready
    .s_axi_rdata    (M_AXI_L3PERI_AXILITE32_RDATA   ), // output wire [31 : 0] s_axi_rdata
    .s_axi_rresp    (M_AXI_L3PERI_AXILITE32_RRESP   ), // output wire [1 : 0] s_axi_rresp
    .s_axi_rvalid   (M_AXI_L3PERI_AXILITE32_RVALID  ), // output wire [0 : 0] s_axi_rvalid
    .s_axi_rready   (M_AXI_L3PERI_AXILITE32_RREADY  ), // input wire [0 : 0] s_axi_rready

    .m_axi_awaddr   ({S_AXI_GPIO1_AWADDR  , S_AXI_SPI_AWADDR  , S_AXI_TIMER_AWADDR  , S_AXI_I2C_AWADDR  , S_AXI_GPIO0_AWADDR  , S_AXI_UART_AWADDR  }), // output wire [383:0] m_axi_awaddr
    .m_axi_awprot   ({S_AXI_GPIO1_AWPROT  , S_AXI_SPI_AWPROT  , S_AXI_TIMER_AWPROT  , S_AXI_I2C_AWPROT  , S_AXI_GPIO0_AWPROT  , S_AXI_UART_AWPROT  }), // output wire [17:0] m_axi_awprot
    .m_axi_awvalid  ({S_AXI_GPIO1_AWVALID , S_AXI_SPI_AWVALID , S_AXI_TIMER_AWVALID , S_AXI_I2C_AWVALID , S_AXI_GPIO0_AWVALID , S_AXI_UART_AWVALID }), // output wire [5:0] m_axi_awvalid
    .m_axi_awready  ({S_AXI_GPIO1_AWREADY , S_AXI_SPI_AWREADY , S_AXI_TIMER_AWREADY , S_AXI_I2C_AWREADY , S_AXI_GPIO0_AWREADY , S_AXI_UART_AWREADY }), // input  wire [5:0] m_axi_awready
    .m_axi_wdata    ({S_AXI_GPIO1_WDATA   , S_AXI_SPI_WDATA   , S_AXI_TIMER_WDATA   , S_AXI_I2C_WDATA   , S_AXI_GPIO0_WDATA   , S_AXI_UART_WDATA   }), // output wire [191:0] m_axi_wdata
    .m_axi_wstrb    ({S_AXI_GPIO1_WSTRB   , S_AXI_SPI_WSTRB   , S_AXI_TIMER_WSTRB   , S_AXI_I2C_WSTRB   , S_AXI_GPIO0_WSTRB   , S_AXI_UART_WSTRB   }), // output wire [23:0] m_axi_wstrb
    .m_axi_wvalid   ({S_AXI_GPIO1_WVALID  , S_AXI_SPI_WVALID  , S_AXI_TIMER_WVALID  , S_AXI_I2C_WVALID  , S_AXI_GPIO0_WVALID  , S_AXI_UART_WVALID  }), // output wire [5:0] m_axi_wvalid
    .m_axi_wready   ({S_AXI_GPIO1_WREADY  , S_AXI_SPI_WREADY  , S_AXI_TIMER_WREADY  , S_AXI_I2C_WREADY  , S_AXI_GPIO0_WREADY  , S_AXI_UART_WREADY  }), // input  wire [5:0] m_axi_wready
    .m_axi_bresp    ({S_AXI_GPIO1_BRESP   , S_AXI_SPI_BRESP   , S_AXI_TIMER_BRESP   , S_AXI_I2C_BRESP   , S_AXI_GPIO0_BRESP   , S_AXI_UART_BRESP   }), // input  wire [11:0] m_axi_bresp
    .m_axi_bvalid   ({S_AXI_GPIO1_BVALID  , S_AXI_SPI_BVALID  , S_AXI_TIMER_BVALID  , S_AXI_I2C_BVALID  , S_AXI_GPIO0_BVALID  , S_AXI_UART_BVALID  }), // input  wire [5:0] m_axi_bvalid
    .m_axi_bready   ({S_AXI_GPIO1_BREADY  , S_AXI_SPI_BREADY  , S_AXI_TIMER_BREADY  , S_AXI_I2C_BREADY  , S_AXI_GPIO0_BREADY  , S_AXI_UART_BREADY  }), // output wire [5:0] m_axi_bready
    .m_axi_araddr   ({S_AXI_GPIO1_ARADDR  , S_AXI_SPI_ARADDR  , S_AXI_TIMER_ARADDR  , S_AXI_I2C_ARADDR  , S_AXI_GPIO0_ARADDR  , S_AXI_UART_ARADDR  }), // output wire [383:0] m_axi_araddr
    .m_axi_arprot   ({S_AXI_GPIO1_ARPROT  , S_AXI_SPI_ARPROT  , S_AXI_TIMER_ARPROT  , S_AXI_I2C_ARPROT  , S_AXI_GPIO0_ARPROT  , S_AXI_UART_ARPROT  }), // output wire [17:0] m_axi_arprot
    .m_axi_arvalid  ({S_AXI_GPIO1_ARVALID , S_AXI_SPI_ARVALID , S_AXI_TIMER_ARVALID , S_AXI_I2C_ARVALID , S_AXI_GPIO0_ARVALID , S_AXI_UART_ARVALID }), // output wire [5:0] m_axi_arvalid
    .m_axi_arready  ({S_AXI_GPIO1_ARREADY , S_AXI_SPI_ARREADY , S_AXI_TIMER_ARREADY , S_AXI_I2C_ARREADY , S_AXI_GPIO0_ARREADY , S_AXI_UART_ARREADY }), // input  wire [5:0] m_axi_arready
    .m_axi_rdata    ({S_AXI_GPIO1_RDATA   , S_AXI_SPI_RDATA   , S_AXI_TIMER_RDATA   , S_AXI_I2C_RDATA   , S_AXI_GPIO0_RDATA   , S_AXI_UART_RDATA   }), // input  wire [191:0] m_axi_rdata
    .m_axi_rresp    ({S_AXI_GPIO1_RRESP   , S_AXI_SPI_RRESP   , S_AXI_TIMER_RRESP   , S_AXI_I2C_RRESP   , S_AXI_GPIO0_RRESP   , S_AXI_UART_RRESP   }), // input  wire [11:0] m_axi_rresp
    .m_axi_rvalid   ({S_AXI_GPIO1_RVALID  , S_AXI_SPI_RVALID  , S_AXI_TIMER_RVALID  , S_AXI_I2C_RVALID  , S_AXI_GPIO0_RVALID  , S_AXI_UART_RVALID  }), // input  wire [5:0] m_axi_rvalid
    .m_axi_rready   ({S_AXI_GPIO1_RREADY  , S_AXI_SPI_RREADY  , S_AXI_TIMER_RREADY  , S_AXI_I2C_RREADY  , S_AXI_GPIO0_RREADY  , S_AXI_UART_RREADY  })  // output wire [5:0] m_axi_rready
);


`ifdef DEBUG_L3_DBUS
    axilite32_ILA l3_dbus_ILA
    (
        .clk        (clk                                ), // input wire clk
        .probe0     (M_AXI_L3PERI_AXILITE32_WREADY      ), // input wire [0:0] probe0      WREADY
        .probe1     (M_AXI_L3PERI_AXILITE32_AWADDR[31:0]), // input wire [31:0]  probe1    AWADDR
        .probe2     (M_AXI_L3PERI_AXILITE32_BRESP       ), // input wire [1:0]  probe2     BRESP
        .probe3     (M_AXI_L3PERI_AXILITE32_BVALID      ), // input wire [0:0]  probe3     BVALID
        .probe4     (M_AXI_L3PERI_AXILITE32_BREADY      ), // input wire [0:0]  probe4     BREADY
        .probe5     (M_AXI_L3PERI_AXILITE32_ARADDR[31:0]), // input wire [31:0]  probe5    ARADDR
        .probe6     (M_AXI_L3PERI_AXILITE32_RREADY      ), // input wire [0:0]  probe6     RREADY
        .probe7     (M_AXI_L3PERI_AXILITE32_WVALID      ), // input wire [0:0]  probe7     WVALID
        .probe8     (M_AXI_L3PERI_AXILITE32_ARVALID     ), // input wire [0:0]  probe8     ARVALID
        .probe9     (M_AXI_L3PERI_AXILITE32_ARREADY     ), // input wire [0:0]  probe9     ARREADY
        .probe10    (M_AXI_L3PERI_AXILITE32_RDATA       ), // input wire [31:0]  probe10   RDATA
        .probe11    (M_AXI_L3PERI_AXILITE32_AWVALID     ), // input wire [0:0]  probe11    AWVALID
        .probe12    (M_AXI_L3PERI_AXILITE32_AWREADY     ), // input wire [0:0]  probe12    AWREADY
        .probe13    (M_AXI_L3PERI_AXILITE32_RRESP       ), // input wire [1:0]  probe13    RRESP
        .probe14    (M_AXI_L3PERI_AXILITE32_WDATA       ), // input wire [31:0]  probe14   WDATA
        .probe15    (M_AXI_L3PERI_AXILITE32_WSTRB       ), // input wire [3:0]  probe15    WSTRB
        .probe16    (M_AXI_L3PERI_AXILITE32_RVALID      ), // input wire [0:0]  probe16    RVALID
        .probe17    (M_AXI_L3PERI_AXILITE32_ARPROT      ), // input wire [2:0]  probe17    ARPROT
        .probe18    (M_AXI_L3PERI_AXILITE32_AWPROT      )  // input wire [2:0]  probe18    AWPROT
    );
`endif

endmodule

