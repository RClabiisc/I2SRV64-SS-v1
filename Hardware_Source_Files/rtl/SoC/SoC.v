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

module SoC
(
    //system differential clock
    input  wire             clk_p,
    input  wire             clk_n,

    //on-board Reset Button
    input  wire             reset,

    //BOOT Mode Input IOs
    input  wire [3:0]       BOOT_MODE,

    //UART IOs
    input  wire             rs232_uart_rxd,
    output wire             rs232_uart_txd,

    //I2C IOs
    input  wire             i2c_sda_i,
    input  wire             i2c_scl_i,
    output wire             i2c_sda_t,
    output wire             i2c_scl_t,
    output wire             i2c_sda_o,
    output wire             i2c_scl_o,

    //GPIO IOs
    output wire [7:0]       gpio0_A_o,
    input  wire [7:0]       gpio0_B_i,
    output wire [7:0]       gpio1_A_o,
    input  wire [7:0]       gpio1_B_i,

    //Timer IOs
    input  wire             timer_capture0,
    input  wire             timer_capture1,
    output wire             timer_out0,
    output wire             timer_out1,
    output wire             timer_pwm0,

    //SPI IOs
    output wire             spi_mosi_o,
    input  wire             spi_miso_i,
    output wire             spi_sck_o,
    output wire             spi_ss_o

    //BPI Flash IOs
`ifdef SOC_ENABLE_FLASH
    ,
    input  wire [15:0]      linear_flash_dq_i,
    output wire [15:0]      linear_flash_dq_o,
    output wire [15:0]      linear_flash_dq_t,
    output wire [25:0]      linear_flash_addr,
    output wire             linear_flash_ce_n,
    output wire             linear_flash_oen,
    output wire             linear_flash_wen,
    output wire             linear_flash_adv_ldn
`endif
`ifdef SOC_ENABLE_DRAM
    ,
    output wire [13:0]      ddr3_addr,
    output wire [2:0]       ddr3_ba,
    output wire             ddr3_cas_n,
    output wire [0:0]       ddr3_ck_n,
    output wire [0:0]       ddr3_ck_p,
    output wire [0:0]       ddr3_cke,
    output wire             ddr3_ras_n,
    output wire             ddr3_reset_n,
    output wire             ddr3_we_n,
    inout  wire [63:0]      ddr3_dq,
    inout  wire [7:0]       ddr3_dqs_n,
    inout  wire [7:0]       ddr3_dqs_p,
    output wire [0:0]       ddr3_cs_n,
    output wire [7:0]       ddr3_dm,
    output wire [0:0]       ddr3_odt
`endif
);

/*************************
*  Local Configuration  *
*************************/
localparam C_PLATFORM_GLOBAL_IRQS = 6;
localparam C_PLATFORM_LOCAL_IRQS  = 1;


/*****************
*  Local Wires  *
*****************/
//Clock and Reset Wires
wire                                dcm_locked;
wire                                sys_clk;
wire                                sys_rst;
wire                                peripheral_rstn;
wire                                interconnect_rstn;
wire                                slowest_sync_clk;
wire                                aux_reset;

//Misc Processor Wires
wire [63:0] RetirePC;
wire                                NMI_irq;
wire [C_PLATFORM_GLOBAL_IRQS-1:0]   global_irqs;
wire [C_PLATFORM_LOCAL_IRQS-1:0]    local_irqs;
wire                                uart_irq, gpio0_irq, gpio1_irq, i2c_irq, spi_irq, timer_irq;

//L2 Interconnect Master Wires
wire [3:0]                          M_AXI_IBUS_AWID     , M_AXI_DBUS_AWID     , M_AXI_DEBUG_AWID;
wire [`C_AXI_L2_ADDR_WIDTH-1:0]     M_AXI_IBUS_AWADDR   , M_AXI_DBUS_AWADDR   , M_AXI_DEBUG_AWADDR;
wire [7:0]                          M_AXI_IBUS_AWLEN    , M_AXI_DBUS_AWLEN    , M_AXI_DEBUG_AWLEN;
wire [2:0]                          M_AXI_IBUS_AWSIZE   , M_AXI_DBUS_AWSIZE   , M_AXI_DEBUG_AWSIZE;
wire [1:0]                          M_AXI_IBUS_AWBURST  , M_AXI_DBUS_AWBURST  , M_AXI_DEBUG_AWBURST;
wire                                M_AXI_IBUS_AWLOCK   , M_AXI_DBUS_AWLOCK   , M_AXI_DEBUG_AWLOCK;
wire [3:0]                          M_AXI_IBUS_AWCACHE  , M_AXI_DBUS_AWCACHE  , M_AXI_DEBUG_AWCACHE;
wire [2:0]                          M_AXI_IBUS_AWPROT   , M_AXI_DBUS_AWPROT   , M_AXI_DEBUG_AWPROT;
wire [3:0]                          M_AXI_IBUS_AWREGION , M_AXI_DBUS_AWQOS    , M_AXI_DEBUG_AWREGION;
wire [3:0]                          M_AXI_IBUS_AWQOS    , M_AXI_DBUS_AWREGION , M_AXI_DEBUG_AWQOS;
wire                                M_AXI_IBUS_AWVALID  , M_AXI_DBUS_AWVALID  , M_AXI_DEBUG_AWVALID;
wire                                M_AXI_IBUS_AWREADY  , M_AXI_DBUS_AWREADY  , M_AXI_DEBUG_AWREADY;
wire [`C_AXI_L2_DATA_WIDTH-1:0]     M_AXI_IBUS_WDATA    , M_AXI_DBUS_WDATA    , M_AXI_DEBUG_WDATA;
wire [`C_AXI_L2_DATA_WIDTH/8-1:0]   M_AXI_IBUS_WSTRB    , M_AXI_DBUS_WSTRB    , M_AXI_DEBUG_WSTRB;
wire                                M_AXI_IBUS_WLAST    , M_AXI_DBUS_WLAST    , M_AXI_DEBUG_WLAST;
wire                                M_AXI_IBUS_WVALID   , M_AXI_DBUS_WVALID   , M_AXI_DEBUG_WVALID;
wire                                M_AXI_IBUS_WREADY   , M_AXI_DBUS_WREADY   , M_AXI_DEBUG_WREADY;
wire [3:0]                          M_AXI_IBUS_BID      , M_AXI_DBUS_BID      , M_AXI_DEBUG_BID;
wire [1:0]                          M_AXI_IBUS_BRESP    , M_AXI_DBUS_BRESP    , M_AXI_DEBUG_BRESP;
wire                                M_AXI_IBUS_BVALID   , M_AXI_DBUS_BVALID   , M_AXI_DEBUG_BVALID;
wire                                M_AXI_IBUS_BREADY   , M_AXI_DBUS_BREADY   , M_AXI_DEBUG_BREADY;
wire [3:0]                          M_AXI_IBUS_ARID     , M_AXI_DBUS_ARID     , M_AXI_DEBUG_ARID;
wire [`C_AXI_L2_ADDR_WIDTH-1:0]     M_AXI_IBUS_ARADDR   , M_AXI_DBUS_ARADDR   , M_AXI_DEBUG_ARADDR;
wire [7:0]                          M_AXI_IBUS_ARLEN    , M_AXI_DBUS_ARLEN    , M_AXI_DEBUG_ARLEN;
wire [2:0]                          M_AXI_IBUS_ARSIZE   , M_AXI_DBUS_ARSIZE   , M_AXI_DEBUG_ARSIZE;
wire [1:0]                          M_AXI_IBUS_ARBURST  , M_AXI_DBUS_ARBURST  , M_AXI_DEBUG_ARBURST;
wire                                M_AXI_IBUS_ARLOCK   , M_AXI_DBUS_ARLOCK   , M_AXI_DEBUG_ARLOCK;
wire [3:0]                          M_AXI_IBUS_ARCACHE  , M_AXI_DBUS_ARCACHE  , M_AXI_DEBUG_ARCACHE;
wire [2:0]                          M_AXI_IBUS_ARPROT   , M_AXI_DBUS_ARPROT   , M_AXI_DEBUG_ARPROT;
wire [3:0]                          M_AXI_IBUS_ARREGION , M_AXI_DBUS_ARREGION , M_AXI_DEBUG_ARREGION;
wire [3:0]                          M_AXI_IBUS_ARQOS    , M_AXI_DBUS_ARQOS    , M_AXI_DEBUG_ARQOS;
wire                                M_AXI_IBUS_ARVALID  , M_AXI_DBUS_ARVALID  , M_AXI_DEBUG_ARVALID;
wire                                M_AXI_IBUS_ARREADY  , M_AXI_DBUS_ARREADY  , M_AXI_DEBUG_ARREADY;
wire [3:0]                          M_AXI_IBUS_RID      , M_AXI_DBUS_RID      , M_AXI_DEBUG_RID;
wire [`C_AXI_L2_DATA_WIDTH-1:0]     M_AXI_IBUS_RDATA    , M_AXI_DBUS_RDATA    , M_AXI_DEBUG_RDATA;
wire [1:0]                          M_AXI_IBUS_RRESP    , M_AXI_DBUS_RRESP    , M_AXI_DEBUG_RRESP;
wire                                M_AXI_IBUS_RLAST    , M_AXI_DBUS_RLAST    , M_AXI_DEBUG_RLAST;
wire                                M_AXI_IBUS_RVALID   , M_AXI_DBUS_RVALID   , M_AXI_DEBUG_RVALID;
wire                                M_AXI_IBUS_RREADY   , M_AXI_DBUS_RREADY   , M_AXI_DEBUG_RREADY;


//L2 Interconnect Slave Wires
wire [3:0]                          S_AXI_BOOTROM_AWID     , S_AXI_INTSRAM_AWID     , S_AXI_L3PERI_AWID     , S_AXI_FLASH_AWID     , S_AXI_DRAM_AWID;
wire [`C_AXI_L2_ADDR_WIDTH-1:0]     S_AXI_BOOTROM_AWADDR   , S_AXI_INTSRAM_AWADDR   , S_AXI_L3PERI_AWADDR   , S_AXI_FLASH_AWADDR   , S_AXI_DRAM_AWADDR;
wire [7:0]                          S_AXI_BOOTROM_AWLEN    , S_AXI_INTSRAM_AWLEN    , S_AXI_L3PERI_AWLEN    , S_AXI_FLASH_AWLEN    , S_AXI_DRAM_AWLEN;
wire [2:0]                          S_AXI_BOOTROM_AWSIZE   , S_AXI_INTSRAM_AWSIZE   , S_AXI_L3PERI_AWSIZE   , S_AXI_FLASH_AWSIZE   , S_AXI_DRAM_AWSIZE;
wire [1:0]                          S_AXI_BOOTROM_AWBURST  , S_AXI_INTSRAM_AWBURST  , S_AXI_L3PERI_AWBURST  , S_AXI_FLASH_AWBURST  , S_AXI_DRAM_AWBURST;
wire                                S_AXI_BOOTROM_AWLOCK   , S_AXI_INTSRAM_AWLOCK   , S_AXI_L3PERI_AWLOCK   , S_AXI_FLASH_AWLOCK   , S_AXI_DRAM_AWLOCK;
wire [3:0]                          S_AXI_BOOTROM_AWCACHE  , S_AXI_INTSRAM_AWCACHE  , S_AXI_L3PERI_AWCACHE  , S_AXI_FLASH_AWCACHE  , S_AXI_DRAM_AWCACHE;
wire [2:0]                          S_AXI_BOOTROM_AWPROT   , S_AXI_INTSRAM_AWPROT   , S_AXI_L3PERI_AWPROT   , S_AXI_FLASH_AWPROT   , S_AXI_DRAM_AWPROT;
wire [3:0]                          S_AXI_BOOTROM_AWREGION , S_AXI_INTSRAM_AWREGION , S_AXI_L3PERI_AWREGION , S_AXI_FLASH_AWREGION , S_AXI_DRAM_AWREGION;
wire [3:0]                          S_AXI_BOOTROM_AWQOS    , S_AXI_INTSRAM_AWQOS    , S_AXI_L3PERI_AWQOS    , S_AXI_FLASH_AWQOS    , S_AXI_DRAM_AWQOS;
wire                                S_AXI_BOOTROM_AWVALID  , S_AXI_INTSRAM_AWVALID  , S_AXI_L3PERI_AWVALID  , S_AXI_FLASH_AWVALID  , S_AXI_DRAM_AWVALID;
wire                                S_AXI_BOOTROM_AWREADY  , S_AXI_INTSRAM_AWREADY  , S_AXI_L3PERI_AWREADY  , S_AXI_FLASH_AWREADY  , S_AXI_DRAM_AWREADY;
wire [`C_AXI_L2_DATA_WIDTH-1:0]     S_AXI_BOOTROM_WDATA    , S_AXI_INTSRAM_WDATA    , S_AXI_L3PERI_WDATA    , S_AXI_FLASH_WDATA    , S_AXI_DRAM_WDATA;
wire [`C_AXI_L2_DATA_WIDTH/8-1:0]   S_AXI_BOOTROM_WSTRB    , S_AXI_INTSRAM_WSTRB    , S_AXI_L3PERI_WSTRB    , S_AXI_FLASH_WSTRB    , S_AXI_DRAM_WSTRB;
wire                                S_AXI_BOOTROM_WLAST    , S_AXI_INTSRAM_WLAST    , S_AXI_L3PERI_WLAST    , S_AXI_FLASH_WLAST    , S_AXI_DRAM_WLAST;
wire                                S_AXI_BOOTROM_WVALID   , S_AXI_INTSRAM_WVALID   , S_AXI_L3PERI_WVALID   , S_AXI_FLASH_WVALID   , S_AXI_DRAM_WVALID;
wire                                S_AXI_BOOTROM_WREADY   , S_AXI_INTSRAM_WREADY   , S_AXI_L3PERI_WREADY   , S_AXI_FLASH_WREADY   , S_AXI_DRAM_WREADY;
wire [3:0]                          S_AXI_BOOTROM_BID      , S_AXI_INTSRAM_BID      , S_AXI_L3PERI_BID      , S_AXI_FLASH_BID      , S_AXI_DRAM_BID;
wire [1:0]                          S_AXI_BOOTROM_BRESP    , S_AXI_INTSRAM_BRESP    , S_AXI_L3PERI_BRESP    , S_AXI_FLASH_BRESP    , S_AXI_DRAM_BRESP;
wire                                S_AXI_BOOTROM_BVALID   , S_AXI_INTSRAM_BVALID   , S_AXI_L3PERI_BVALID   , S_AXI_FLASH_BVALID   , S_AXI_DRAM_BVALID;
wire                                S_AXI_BOOTROM_BREADY   , S_AXI_INTSRAM_BREADY   , S_AXI_L3PERI_BREADY   , S_AXI_FLASH_BREADY   , S_AXI_DRAM_BREADY;
wire [3:0]                          S_AXI_BOOTROM_ARID     , S_AXI_INTSRAM_ARID     , S_AXI_L3PERI_ARID     , S_AXI_FLASH_ARID     , S_AXI_DRAM_ARID;
wire [`C_AXI_L2_ADDR_WIDTH-1:0]     S_AXI_BOOTROM_ARADDR   , S_AXI_INTSRAM_ARADDR   , S_AXI_L3PERI_ARADDR   , S_AXI_FLASH_ARADDR   , S_AXI_DRAM_ARADDR;
wire [7:0]                          S_AXI_BOOTROM_ARLEN    , S_AXI_INTSRAM_ARLEN    , S_AXI_L3PERI_ARLEN    , S_AXI_FLASH_ARLEN    , S_AXI_DRAM_ARLEN;
wire [2:0]                          S_AXI_BOOTROM_ARSIZE   , S_AXI_INTSRAM_ARSIZE   , S_AXI_L3PERI_ARSIZE   , S_AXI_FLASH_ARSIZE   , S_AXI_DRAM_ARSIZE;
wire [1:0]                          S_AXI_BOOTROM_ARBURST  , S_AXI_INTSRAM_ARBURST  , S_AXI_L3PERI_ARBURST  , S_AXI_FLASH_ARBURST  , S_AXI_DRAM_ARBURST;
wire                                S_AXI_BOOTROM_ARLOCK   , S_AXI_INTSRAM_ARLOCK   , S_AXI_L3PERI_ARLOCK   , S_AXI_FLASH_ARLOCK   , S_AXI_DRAM_ARLOCK;
wire [3:0]                          S_AXI_BOOTROM_ARCACHE  , S_AXI_INTSRAM_ARCACHE  , S_AXI_L3PERI_ARCACHE  , S_AXI_FLASH_ARCACHE  , S_AXI_DRAM_ARCACHE;
wire [2:0]                          S_AXI_BOOTROM_ARPROT   , S_AXI_INTSRAM_ARPROT   , S_AXI_L3PERI_ARPROT   , S_AXI_FLASH_ARPROT   , S_AXI_DRAM_ARPROT;
wire [3:0]                          S_AXI_BOOTROM_ARREGION , S_AXI_INTSRAM_ARREGION , S_AXI_L3PERI_ARREGION , S_AXI_FLASH_ARREGION , S_AXI_DRAM_ARREGION;
wire [3:0]                          S_AXI_BOOTROM_ARQOS    , S_AXI_INTSRAM_ARQOS    , S_AXI_L3PERI_ARQOS    , S_AXI_FLASH_ARQOS    , S_AXI_DRAM_ARQOS;
wire                                S_AXI_BOOTROM_ARVALID  , S_AXI_INTSRAM_ARVALID  , S_AXI_L3PERI_ARVALID  , S_AXI_FLASH_ARVALID  , S_AXI_DRAM_ARVALID;
wire                                S_AXI_BOOTROM_ARREADY  , S_AXI_INTSRAM_ARREADY  , S_AXI_L3PERI_ARREADY  , S_AXI_FLASH_ARREADY  , S_AXI_DRAM_ARREADY;
wire [3:0]                          S_AXI_BOOTROM_RID      , S_AXI_INTSRAM_RID      , S_AXI_L3PERI_RID      , S_AXI_FLASH_RID      , S_AXI_DRAM_RID;
wire [`C_AXI_L2_DATA_WIDTH-1:0]     S_AXI_BOOTROM_RDATA    , S_AXI_INTSRAM_RDATA    , S_AXI_L3PERI_RDATA    , S_AXI_FLASH_RDATA    , S_AXI_DRAM_RDATA;
wire [1:0]                          S_AXI_BOOTROM_RRESP    , S_AXI_INTSRAM_RRESP    , S_AXI_L3PERI_RRESP    , S_AXI_FLASH_RRESP    , S_AXI_DRAM_RRESP;
wire                                S_AXI_BOOTROM_RLAST    , S_AXI_INTSRAM_RLAST    , S_AXI_L3PERI_RLAST    , S_AXI_FLASH_RLAST    , S_AXI_DRAM_RLAST;
wire                                S_AXI_BOOTROM_RVALID   , S_AXI_INTSRAM_RVALID   , S_AXI_L3PERI_RVALID   , S_AXI_FLASH_RVALID   , S_AXI_DRAM_RVALID;
wire                                S_AXI_BOOTROM_RREADY   , S_AXI_INTSRAM_RREADY   , S_AXI_L3PERI_RREADY   , S_AXI_FLASH_RREADY   , S_AXI_DRAM_RREADY;


//L3 Interconnect Slave Wires
wire [`C_AXI_L3_ADDR_WIDTH-1:0]     S_AXI_UART_AWADDR  , S_AXI_GPIO0_AWADDR  , S_AXI_I2C_AWADDR  , S_AXI_TIMER_AWADDR  , S_AXI_SPI_AWADDR   , S_AXI_GPIO1_AWADDR  ;
wire [2:0]                          S_AXI_UART_AWPROT  , S_AXI_GPIO0_AWPROT  , S_AXI_I2C_AWPROT  , S_AXI_TIMER_AWPROT  , S_AXI_SPI_AWPROT   , S_AXI_GPIO1_AWPROT  ;
wire                                S_AXI_UART_AWVALID , S_AXI_GPIO0_AWVALID , S_AXI_I2C_AWVALID , S_AXI_TIMER_AWVALID , S_AXI_SPI_AWVALID  , S_AXI_GPIO1_AWVALID ;
wire                                S_AXI_UART_AWREADY , S_AXI_GPIO0_AWREADY , S_AXI_I2C_AWREADY , S_AXI_TIMER_AWREADY , S_AXI_SPI_AWREADY  , S_AXI_GPIO1_AWREADY ;
wire [`C_AXI_L3_DATA_WIDTH-1:0]     S_AXI_UART_WDATA   , S_AXI_GPIO0_WDATA   , S_AXI_I2C_WDATA   , S_AXI_TIMER_WDATA   , S_AXI_SPI_WDATA    , S_AXI_GPIO1_WDATA   ;
wire [(`C_AXI_L3_DATA_WIDTH/8)-1:0] S_AXI_UART_WSTRB   , S_AXI_GPIO0_WSTRB   , S_AXI_I2C_WSTRB   , S_AXI_TIMER_WSTRB   , S_AXI_SPI_WSTRB    , S_AXI_GPIO1_WSTRB   ;
wire                                S_AXI_UART_WVALID  , S_AXI_GPIO0_WVALID  , S_AXI_I2C_WVALID  , S_AXI_TIMER_WVALID  , S_AXI_SPI_WVALID   , S_AXI_GPIO1_WVALID  ;
wire                                S_AXI_UART_WREADY  , S_AXI_GPIO0_WREADY  , S_AXI_I2C_WREADY  , S_AXI_TIMER_WREADY  , S_AXI_SPI_WREADY   , S_AXI_GPIO1_WREADY  ;
wire [1:0]                          S_AXI_UART_BRESP   , S_AXI_GPIO0_BRESP   , S_AXI_I2C_BRESP   , S_AXI_TIMER_BRESP   , S_AXI_SPI_BRESP    , S_AXI_GPIO1_BRESP   ;
wire                                S_AXI_UART_BVALID  , S_AXI_GPIO0_BVALID  , S_AXI_I2C_BVALID  , S_AXI_TIMER_BVALID  , S_AXI_SPI_BVALID   , S_AXI_GPIO1_BVALID  ;
wire                                S_AXI_UART_BREADY  , S_AXI_GPIO0_BREADY  , S_AXI_I2C_BREADY  , S_AXI_TIMER_BREADY  , S_AXI_SPI_BREADY   , S_AXI_GPIO1_BREADY  ;
wire [`C_AXI_L3_ADDR_WIDTH-1:0]     S_AXI_UART_ARADDR  , S_AXI_GPIO0_ARADDR  , S_AXI_I2C_ARADDR  , S_AXI_TIMER_ARADDR  , S_AXI_SPI_ARADDR   , S_AXI_GPIO1_ARADDR  ;
wire [2:0]                          S_AXI_UART_ARPROT  , S_AXI_GPIO0_ARPROT  , S_AXI_I2C_ARPROT  , S_AXI_TIMER_ARPROT  , S_AXI_SPI_ARPROT   , S_AXI_GPIO1_ARPROT  ;
wire                                S_AXI_UART_ARVALID , S_AXI_GPIO0_ARVALID , S_AXI_I2C_ARVALID , S_AXI_TIMER_ARVALID , S_AXI_SPI_ARVALID  , S_AXI_GPIO1_ARVALID ;
wire                                S_AXI_UART_ARREADY , S_AXI_GPIO0_ARREADY , S_AXI_I2C_ARREADY , S_AXI_TIMER_ARREADY , S_AXI_SPI_ARREADY  , S_AXI_GPIO1_ARREADY ;
wire [`C_AXI_L3_DATA_WIDTH-1:0]     S_AXI_UART_RDATA   , S_AXI_GPIO0_RDATA   , S_AXI_I2C_RDATA   , S_AXI_TIMER_RDATA   , S_AXI_SPI_RDATA    , S_AXI_GPIO1_RDATA   ;
wire [1:0]                          S_AXI_UART_RRESP   , S_AXI_GPIO0_RRESP   , S_AXI_I2C_RRESP   , S_AXI_TIMER_RRESP   , S_AXI_SPI_RRESP    , S_AXI_GPIO1_RRESP   ;
wire                                S_AXI_UART_RVALID  , S_AXI_GPIO0_RVALID  , S_AXI_I2C_RVALID  , S_AXI_TIMER_RVALID  , S_AXI_SPI_RVALID   , S_AXI_GPIO1_RVALID  ;
wire                                S_AXI_UART_RREADY  , S_AXI_GPIO0_RREADY  , S_AXI_I2C_RREADY  , S_AXI_TIMER_RREADY  , S_AXI_SPI_RREADY   , S_AXI_GPIO1_RREADY  ;


/*****************************************************************************
*                               Configuration                               *
*****************************************************************************/
//Set Slowest clock as sys_clk (rtclk is internal to processor)
assign slowest_sync_clk = sys_clk;

//Auxiliary Reset is not in used.
assign aux_reset = 1'b0;

//NMI Interrupt is NOT Used
assign NMI_irq = 1'b0;

//Platform Local Interrupts are NOT Used
assign local_irqs = 0;

//Platform Global Irqs are mapped as
//0 -> Uart     Interrupt
//1 -> GPIO0    Interrupt
//2 -> I2C      Interrupt
//3 -> Timer    Interrupt
//4 -> SPI      Interrupt
assign global_irqs[0] = uart_irq;
assign global_irqs[1] = gpio0_irq;
assign global_irqs[2] = i2c_irq;
assign global_irqs[3] = timer_irq;
assign global_irqs[4] = spi_irq;
assign global_irqs[5] = gpio1_irq;


//set CLINT rtclk = sys_clk/8 = 32/32 = 1MHz
localparam C_CLINT_CLK_DIVIDE_BY  = 16;


/*****************************************************************************
*                              Instantiations                               *
*****************************************************************************/
`ifndef SOC_ENABLE_DRAM
/***************************
*  Clock & Reset Control  *
***************************/
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

clk_ctrl clk_ctrl
(
    .sys_clk                (sys_clk                        ),

    .locked                 (dcm_locked                     ),

    .clk_in1_p              (clk_p                          ),
    .clk_in1_n              (clk_n                          )
);

rst_ctrl rst_ctrl
(
    .slowest_sync_clk       (slowest_sync_clk               ), // input wire slowest_sync_clk
    .ext_reset_in           (reset                          ), // input wire ext_reset_in
    .aux_reset_in           (aux_reset                      ), // input wire aux_reset_in
    .mb_debug_sys_rst       (1'b0                           ), // input wire mb_debug_sys_rst
    .dcm_locked             (dcm_locked                     ), // input wire dcm_locked
    .mb_reset               (sys_rst                        ), // output wire mb_reset
    .bus_struct_reset       (                               ), // output wire [0 : 0] bus_struct_reset
    .peripheral_reset       (                               ), // output wire [0 : 0] peripheral_reset
    .interconnect_aresetn   (interconnect_rstn              ), // output wire [0 : 0] interconnect_aresetn
    .peripheral_aresetn     (peripheral_rstn                )  // output wire [0 : 0] peripheral_aresetn
);
`endif


/***************
*  Processor  *
***************/
Processor
#(
    .C_PLATFORM_LOCAL_IRQS  (C_PLATFORM_LOCAL_IRQS          ),
    .C_PLATFORM_GLOBAL_IRQS (C_PLATFORM_GLOBAL_IRQS         ),
    .C_CLINT_CLK_DIVIDE_BY  (C_CLINT_CLK_DIVIDE_BY          )
)
Processor
(
    .sys_clk                (sys_clk                        ),
    .sys_rst                (sys_rst                        ),

    .NMI_irq                (NMI_irq                        ),
    .global_irqs            (global_irqs                    ),
    .local_irqs             (local_irqs                     ),

    .M_AXI_IBUS_AWID        (M_AXI_IBUS_AWID                ),
    .M_AXI_IBUS_AWADDR      (M_AXI_IBUS_AWADDR              ),
    .M_AXI_IBUS_AWLEN       (M_AXI_IBUS_AWLEN               ),
    .M_AXI_IBUS_AWSIZE      (M_AXI_IBUS_AWSIZE              ),
    .M_AXI_IBUS_AWBURST     (M_AXI_IBUS_AWBURST             ),
    .M_AXI_IBUS_AWLOCK      (M_AXI_IBUS_AWLOCK              ),
    .M_AXI_IBUS_AWCACHE     (M_AXI_IBUS_AWCACHE             ),
    .M_AXI_IBUS_AWPROT      (M_AXI_IBUS_AWPROT              ),
    .M_AXI_IBUS_AWREGION    (M_AXI_IBUS_AWREGION            ),
    .M_AXI_IBUS_AWQOS       (M_AXI_IBUS_AWQOS               ),
    .M_AXI_IBUS_AWVALID     (M_AXI_IBUS_AWVALID             ),
    .M_AXI_IBUS_AWREADY     (M_AXI_IBUS_AWREADY             ),
    .M_AXI_IBUS_WDATA       (M_AXI_IBUS_WDATA               ),
    .M_AXI_IBUS_WSTRB       (M_AXI_IBUS_WSTRB               ),
    .M_AXI_IBUS_WLAST       (M_AXI_IBUS_WLAST               ),
    .M_AXI_IBUS_WVALID      (M_AXI_IBUS_WVALID              ),
    .M_AXI_IBUS_WREADY      (M_AXI_IBUS_WREADY              ),
    .M_AXI_IBUS_BID         (M_AXI_IBUS_BID                 ),
    .M_AXI_IBUS_BRESP       (M_AXI_IBUS_BRESP               ),
    .M_AXI_IBUS_BVALID      (M_AXI_IBUS_BVALID              ),
    .M_AXI_IBUS_BREADY      (M_AXI_IBUS_BREADY              ),
    .M_AXI_IBUS_ARID        (M_AXI_IBUS_ARID                ),
    .M_AXI_IBUS_ARADDR      (M_AXI_IBUS_ARADDR              ),
    .M_AXI_IBUS_ARLEN       (M_AXI_IBUS_ARLEN               ),
    .M_AXI_IBUS_ARSIZE      (M_AXI_IBUS_ARSIZE              ),
    .M_AXI_IBUS_ARBURST     (M_AXI_IBUS_ARBURST             ),
    .M_AXI_IBUS_ARLOCK      (M_AXI_IBUS_ARLOCK              ),
    .M_AXI_IBUS_ARCACHE     (M_AXI_IBUS_ARCACHE             ),
    .M_AXI_IBUS_ARPROT      (M_AXI_IBUS_ARPROT              ),
    .M_AXI_IBUS_ARREGION    (M_AXI_IBUS_ARREGION            ),
    .M_AXI_IBUS_ARQOS       (M_AXI_IBUS_ARQOS               ),
    .M_AXI_IBUS_ARVALID     (M_AXI_IBUS_ARVALID             ),
    .M_AXI_IBUS_ARREADY     (M_AXI_IBUS_ARREADY             ),
    .M_AXI_IBUS_RID         (M_AXI_IBUS_RID                 ),
    .M_AXI_IBUS_RDATA       (M_AXI_IBUS_RDATA               ),
    .M_AXI_IBUS_RRESP       (M_AXI_IBUS_RRESP               ),
    .M_AXI_IBUS_RLAST       (M_AXI_IBUS_RLAST               ),
    .M_AXI_IBUS_RVALID      (M_AXI_IBUS_RVALID              ),
    .M_AXI_IBUS_RREADY      (M_AXI_IBUS_RREADY              ),

    .M_AXI_DBUS_AWID        (M_AXI_DBUS_AWID                ),
    .M_AXI_DBUS_AWADDR      (M_AXI_DBUS_AWADDR              ),
    .M_AXI_DBUS_AWLEN       (M_AXI_DBUS_AWLEN               ),
    .M_AXI_DBUS_AWSIZE      (M_AXI_DBUS_AWSIZE              ),
    .M_AXI_DBUS_AWBURST     (M_AXI_DBUS_AWBURST             ),
    .M_AXI_DBUS_AWLOCK      (M_AXI_DBUS_AWLOCK              ),
    .M_AXI_DBUS_AWCACHE     (M_AXI_DBUS_AWCACHE             ),
    .M_AXI_DBUS_AWPROT      (M_AXI_DBUS_AWPROT              ),
    .M_AXI_DBUS_AWQOS       (M_AXI_DBUS_AWQOS               ),
    .M_AXI_DBUS_AWREGION    (M_AXI_DBUS_AWREGION            ),
    .M_AXI_DBUS_AWVALID     (M_AXI_DBUS_AWVALID             ),
    .M_AXI_DBUS_AWREADY     (M_AXI_DBUS_AWREADY             ),
    .M_AXI_DBUS_WDATA       (M_AXI_DBUS_WDATA               ),
    .M_AXI_DBUS_WSTRB       (M_AXI_DBUS_WSTRB               ),
    .M_AXI_DBUS_WLAST       (M_AXI_DBUS_WLAST               ),
    .M_AXI_DBUS_WVALID      (M_AXI_DBUS_WVALID              ),
    .M_AXI_DBUS_WREADY      (M_AXI_DBUS_WREADY              ),
    .M_AXI_DBUS_BID         (M_AXI_DBUS_BID                 ),
    .M_AXI_DBUS_BRESP       (M_AXI_DBUS_BRESP               ),
    .M_AXI_DBUS_BVALID      (M_AXI_DBUS_BVALID              ),
    .M_AXI_DBUS_BREADY      (M_AXI_DBUS_BREADY              ),
    .M_AXI_DBUS_ARID        (M_AXI_DBUS_ARID                ),
    .M_AXI_DBUS_ARADDR      (M_AXI_DBUS_ARADDR              ),
    .M_AXI_DBUS_ARLEN       (M_AXI_DBUS_ARLEN               ),
    .M_AXI_DBUS_ARSIZE      (M_AXI_DBUS_ARSIZE              ),
    .M_AXI_DBUS_ARBURST     (M_AXI_DBUS_ARBURST             ),
    .M_AXI_DBUS_ARLOCK      (M_AXI_DBUS_ARLOCK              ),
    .M_AXI_DBUS_ARCACHE     (M_AXI_DBUS_ARCACHE             ),
    .M_AXI_DBUS_ARPROT      (M_AXI_DBUS_ARPROT              ),
    .M_AXI_DBUS_ARREGION    (M_AXI_DBUS_ARREGION            ),
    .M_AXI_DBUS_ARQOS       (M_AXI_DBUS_ARQOS               ),
    .M_AXI_DBUS_ARVALID     (M_AXI_DBUS_ARVALID             ),
    .M_AXI_DBUS_ARREADY     (M_AXI_DBUS_ARREADY             ),
    .M_AXI_DBUS_RID         (M_AXI_DBUS_RID                 ),
    .M_AXI_DBUS_RDATA       (M_AXI_DBUS_RDATA               ),
    .M_AXI_DBUS_RRESP       (M_AXI_DBUS_RRESP               ),
    .M_AXI_DBUS_RLAST       (M_AXI_DBUS_RLAST               ),
    .M_AXI_DBUS_RVALID      (M_AXI_DBUS_RVALID              ),
    .M_AXI_DBUS_RREADY      (M_AXI_DBUS_RREADY              ),

    .BOOT_MODE              (BOOT_MODE                      ),
    .RetirePC               (RetirePC                       )
);

/***********************
*  JTAG to AXI Debug  *
***********************/
JTAG_to_AXI JTAG_to_AXI
(
    .clk                    (sys_clk                        ),
    .rstn                   (peripheral_rstn                ),

    .M_AXI_AWID             (M_AXI_DEBUG_AWID               ),
    .M_AXI_AWADDR           (M_AXI_DEBUG_AWADDR             ),
    .M_AXI_AWLEN            (M_AXI_DEBUG_AWLEN              ),
    .M_AXI_AWSIZE           (M_AXI_DEBUG_AWSIZE             ),
    .M_AXI_AWBURST          (M_AXI_DEBUG_AWBURST            ),
    .M_AXI_AWLOCK           (M_AXI_DEBUG_AWLOCK             ),
    .M_AXI_AWCACHE          (M_AXI_DEBUG_AWCACHE            ),
    .M_AXI_AWPROT           (M_AXI_DEBUG_AWPROT             ),
    .M_AXI_AWREGION         (M_AXI_DEBUG_AWREGION           ),
    .M_AXI_AWQOS            (M_AXI_DEBUG_AWQOS              ),
    .M_AXI_AWVALID          (M_AXI_DEBUG_AWVALID            ),
    .M_AXI_AWREADY          (M_AXI_DEBUG_AWREADY            ),
    .M_AXI_WDATA            (M_AXI_DEBUG_WDATA              ),
    .M_AXI_WSTRB            (M_AXI_DEBUG_WSTRB              ),
    .M_AXI_WLAST            (M_AXI_DEBUG_WLAST              ),
    .M_AXI_WVALID           (M_AXI_DEBUG_WVALID             ),
    .M_AXI_WREADY           (M_AXI_DEBUG_WREADY             ),
    .M_AXI_BID              (M_AXI_DEBUG_BID                ),
    .M_AXI_BRESP            (M_AXI_DEBUG_BRESP              ),
    .M_AXI_BVALID           (M_AXI_DEBUG_BVALID             ),
    .M_AXI_BREADY           (M_AXI_DEBUG_BREADY             ),
    .M_AXI_ARID             (M_AXI_DEBUG_ARID               ),
    .M_AXI_ARADDR           (M_AXI_DEBUG_ARADDR             ),
    .M_AXI_ARLEN            (M_AXI_DEBUG_ARLEN              ),
    .M_AXI_ARSIZE           (M_AXI_DEBUG_ARSIZE             ),
    .M_AXI_ARBURST          (M_AXI_DEBUG_ARBURST            ),
    .M_AXI_ARLOCK           (M_AXI_DEBUG_ARLOCK             ),
    .M_AXI_ARCACHE          (M_AXI_DEBUG_ARCACHE            ),
    .M_AXI_ARPROT           (M_AXI_DEBUG_ARPROT             ),
    .M_AXI_ARREGION         (M_AXI_DEBUG_ARREGION           ),
    .M_AXI_ARQOS            (M_AXI_DEBUG_ARQOS              ),
    .M_AXI_ARVALID          (M_AXI_DEBUG_ARVALID            ),
    .M_AXI_ARREADY          (M_AXI_DEBUG_ARREADY            ),
    .M_AXI_RID              (M_AXI_DEBUG_RID                ),
    .M_AXI_RDATA            (M_AXI_DEBUG_RDATA              ),
    .M_AXI_RRESP            (M_AXI_DEBUG_RRESP              ),
    .M_AXI_RLAST            (M_AXI_DEBUG_RLAST              ),
    .M_AXI_RVALID           (M_AXI_DEBUG_RVALID             ),
    .M_AXI_RREADY           (M_AXI_DEBUG_RREADY             )
);


/*********************
*  L2 Interconnect  *
*********************/
SoC_L2_XBar SoC_L2_XBar
(
    .clk                    (sys_clk                        ),
    .rstn                   (interconnect_rstn              ),

    .M_AXI_DBUS_AWID        (M_AXI_DBUS_AWID                ),
    .M_AXI_DBUS_AWADDR      (M_AXI_DBUS_AWADDR              ),
    .M_AXI_DBUS_AWLEN       (M_AXI_DBUS_AWLEN               ),
    .M_AXI_DBUS_AWSIZE      (M_AXI_DBUS_AWSIZE              ),
    .M_AXI_DBUS_AWBURST     (M_AXI_DBUS_AWBURST             ),
    .M_AXI_DBUS_AWLOCK      (M_AXI_DBUS_AWLOCK              ),
    .M_AXI_DBUS_AWCACHE     (M_AXI_DBUS_AWCACHE             ),
    .M_AXI_DBUS_AWREGION    (M_AXI_DBUS_AWREGION            ),
    .M_AXI_DBUS_AWPROT      (M_AXI_DBUS_AWPROT              ),
    .M_AXI_DBUS_AWQOS       (M_AXI_DBUS_AWQOS               ),
    .M_AXI_DBUS_AWVALID     (M_AXI_DBUS_AWVALID             ),
    .M_AXI_DBUS_AWREADY     (M_AXI_DBUS_AWREADY             ),
    .M_AXI_DBUS_WDATA       (M_AXI_DBUS_WDATA               ),
    .M_AXI_DBUS_WSTRB       (M_AXI_DBUS_WSTRB               ),
    .M_AXI_DBUS_WLAST       (M_AXI_DBUS_WLAST               ),
    .M_AXI_DBUS_WVALID      (M_AXI_DBUS_WVALID              ),
    .M_AXI_DBUS_WREADY      (M_AXI_DBUS_WREADY              ),
    .M_AXI_DBUS_BID         (M_AXI_DBUS_BID                 ),
    .M_AXI_DBUS_BRESP       (M_AXI_DBUS_BRESP               ),
    .M_AXI_DBUS_BVALID      (M_AXI_DBUS_BVALID              ),
    .M_AXI_DBUS_BREADY      (M_AXI_DBUS_BREADY              ),
    .M_AXI_DBUS_ARID        (M_AXI_DBUS_ARID                ),
    .M_AXI_DBUS_ARADDR      (M_AXI_DBUS_ARADDR              ),
    .M_AXI_DBUS_ARLEN       (M_AXI_DBUS_ARLEN               ),
    .M_AXI_DBUS_ARSIZE      (M_AXI_DBUS_ARSIZE              ),
    .M_AXI_DBUS_ARBURST     (M_AXI_DBUS_ARBURST             ),
    .M_AXI_DBUS_ARLOCK      (M_AXI_DBUS_ARLOCK              ),
    .M_AXI_DBUS_ARCACHE     (M_AXI_DBUS_ARCACHE             ),
    .M_AXI_DBUS_ARPROT      (M_AXI_DBUS_ARPROT              ),
    .M_AXI_DBUS_ARREGION    (M_AXI_DBUS_ARREGION            ),
    .M_AXI_DBUS_ARQOS       (M_AXI_DBUS_ARQOS               ),
    .M_AXI_DBUS_ARVALID     (M_AXI_DBUS_ARVALID             ),
    .M_AXI_DBUS_ARREADY     (M_AXI_DBUS_ARREADY             ),
    .M_AXI_DBUS_RID         (M_AXI_DBUS_RID                 ),
    .M_AXI_DBUS_RDATA       (M_AXI_DBUS_RDATA               ),
    .M_AXI_DBUS_RRESP       (M_AXI_DBUS_RRESP               ),
    .M_AXI_DBUS_RLAST       (M_AXI_DBUS_RLAST               ),
    .M_AXI_DBUS_RVALID      (M_AXI_DBUS_RVALID              ),
    .M_AXI_DBUS_RREADY      (M_AXI_DBUS_RREADY              ),

    .M_AXI_IBUS_AWID        (M_AXI_IBUS_AWID                ),
    .M_AXI_IBUS_AWADDR      (M_AXI_IBUS_AWADDR              ),
    .M_AXI_IBUS_AWLEN       (M_AXI_IBUS_AWLEN               ),
    .M_AXI_IBUS_AWSIZE      (M_AXI_IBUS_AWSIZE              ),
    .M_AXI_IBUS_AWBURST     (M_AXI_IBUS_AWBURST             ),
    .M_AXI_IBUS_AWLOCK      (M_AXI_IBUS_AWLOCK              ),
    .M_AXI_IBUS_AWCACHE     (M_AXI_IBUS_AWCACHE             ),
    .M_AXI_IBUS_AWPROT      (M_AXI_IBUS_AWPROT              ),
    .M_AXI_IBUS_AWREGION    (M_AXI_IBUS_AWREGION            ),
    .M_AXI_IBUS_AWQOS       (M_AXI_IBUS_AWQOS               ),
    .M_AXI_IBUS_AWVALID     (M_AXI_IBUS_AWVALID             ),
    .M_AXI_IBUS_AWREADY     (M_AXI_IBUS_AWREADY             ),
    .M_AXI_IBUS_WDATA       (M_AXI_IBUS_WDATA               ),
    .M_AXI_IBUS_WSTRB       (M_AXI_IBUS_WSTRB               ),
    .M_AXI_IBUS_WLAST       (M_AXI_IBUS_WLAST               ),
    .M_AXI_IBUS_WVALID      (M_AXI_IBUS_WVALID              ),
    .M_AXI_IBUS_WREADY      (M_AXI_IBUS_WREADY              ),
    .M_AXI_IBUS_BID         (M_AXI_IBUS_BID                 ),
    .M_AXI_IBUS_BRESP       (M_AXI_IBUS_BRESP               ),
    .M_AXI_IBUS_BVALID      (M_AXI_IBUS_BVALID              ),
    .M_AXI_IBUS_BREADY      (M_AXI_IBUS_BREADY              ),
    .M_AXI_IBUS_ARID        (M_AXI_IBUS_ARID                ),
    .M_AXI_IBUS_ARADDR      (M_AXI_IBUS_ARADDR              ),
    .M_AXI_IBUS_ARLEN       (M_AXI_IBUS_ARLEN               ),
    .M_AXI_IBUS_ARSIZE      (M_AXI_IBUS_ARSIZE              ),
    .M_AXI_IBUS_ARBURST     (M_AXI_IBUS_ARBURST             ),
    .M_AXI_IBUS_ARLOCK      (M_AXI_IBUS_ARLOCK              ),
    .M_AXI_IBUS_ARCACHE     (M_AXI_IBUS_ARCACHE             ),
    .M_AXI_IBUS_ARPROT      (M_AXI_IBUS_ARPROT              ),
    .M_AXI_IBUS_ARREGION    (M_AXI_IBUS_ARREGION            ),
    .M_AXI_IBUS_ARQOS       (M_AXI_IBUS_ARQOS               ),
    .M_AXI_IBUS_ARVALID     (M_AXI_IBUS_ARVALID             ),
    .M_AXI_IBUS_ARREADY     (M_AXI_IBUS_ARREADY             ),
    .M_AXI_IBUS_RID         (M_AXI_IBUS_RID                 ),
    .M_AXI_IBUS_RDATA       (M_AXI_IBUS_RDATA               ),
    .M_AXI_IBUS_RRESP       (M_AXI_IBUS_RRESP               ),
    .M_AXI_IBUS_RLAST       (M_AXI_IBUS_RLAST               ),
    .M_AXI_IBUS_RVALID      (M_AXI_IBUS_RVALID              ),
    .M_AXI_IBUS_RREADY      (M_AXI_IBUS_RREADY              ),

    .M_AXI_DEBUG_AWID       (M_AXI_DEBUG_AWID               ),
    .M_AXI_DEBUG_AWADDR     (M_AXI_DEBUG_AWADDR             ),
    .M_AXI_DEBUG_AWLEN      (M_AXI_DEBUG_AWLEN              ),
    .M_AXI_DEBUG_AWSIZE     (M_AXI_DEBUG_AWSIZE             ),
    .M_AXI_DEBUG_AWBURST    (M_AXI_DEBUG_AWBURST            ),
    .M_AXI_DEBUG_AWLOCK     (M_AXI_DEBUG_AWLOCK             ),
    .M_AXI_DEBUG_AWCACHE    (M_AXI_DEBUG_AWCACHE            ),
    .M_AXI_DEBUG_AWPROT     (M_AXI_DEBUG_AWPROT             ),
    .M_AXI_DEBUG_AWREGION   (M_AXI_DEBUG_AWREGION           ),
    .M_AXI_DEBUG_AWQOS      (M_AXI_DEBUG_AWQOS              ),
    .M_AXI_DEBUG_AWVALID    (M_AXI_DEBUG_AWVALID            ),
    .M_AXI_DEBUG_AWREADY    (M_AXI_DEBUG_AWREADY            ),
    .M_AXI_DEBUG_WDATA      (M_AXI_DEBUG_WDATA              ),
    .M_AXI_DEBUG_WSTRB      (M_AXI_DEBUG_WSTRB              ),
    .M_AXI_DEBUG_WLAST      (M_AXI_DEBUG_WLAST              ),
    .M_AXI_DEBUG_WVALID     (M_AXI_DEBUG_WVALID             ),
    .M_AXI_DEBUG_WREADY     (M_AXI_DEBUG_WREADY             ),
    .M_AXI_DEBUG_BID        (M_AXI_DEBUG_BID                ),
    .M_AXI_DEBUG_BRESP      (M_AXI_DEBUG_BRESP              ),
    .M_AXI_DEBUG_BVALID     (M_AXI_DEBUG_BVALID             ),
    .M_AXI_DEBUG_BREADY     (M_AXI_DEBUG_BREADY             ),
    .M_AXI_DEBUG_ARID       (M_AXI_DEBUG_ARID               ),
    .M_AXI_DEBUG_ARADDR     (M_AXI_DEBUG_ARADDR             ),
    .M_AXI_DEBUG_ARLEN      (M_AXI_DEBUG_ARLEN              ),
    .M_AXI_DEBUG_ARSIZE     (M_AXI_DEBUG_ARSIZE             ),
    .M_AXI_DEBUG_ARBURST    (M_AXI_DEBUG_ARBURST            ),
    .M_AXI_DEBUG_ARLOCK     (M_AXI_DEBUG_ARLOCK             ),
    .M_AXI_DEBUG_ARCACHE    (M_AXI_DEBUG_ARCACHE            ),
    .M_AXI_DEBUG_ARPROT     (M_AXI_DEBUG_ARPROT             ),
    .M_AXI_DEBUG_ARREGION   (M_AXI_DEBUG_ARREGION           ),
    .M_AXI_DEBUG_ARQOS      (M_AXI_DEBUG_ARQOS              ),
    .M_AXI_DEBUG_ARVALID    (M_AXI_DEBUG_ARVALID            ),
    .M_AXI_DEBUG_ARREADY    (M_AXI_DEBUG_ARREADY            ),
    .M_AXI_DEBUG_RID        (M_AXI_DEBUG_RID                ),
    .M_AXI_DEBUG_RDATA      (M_AXI_DEBUG_RDATA              ),
    .M_AXI_DEBUG_RRESP      (M_AXI_DEBUG_RRESP              ),
    .M_AXI_DEBUG_RLAST      (M_AXI_DEBUG_RLAST              ),
    .M_AXI_DEBUG_RVALID     (M_AXI_DEBUG_RVALID             ),
    .M_AXI_DEBUG_RREADY     (M_AXI_DEBUG_RREADY             ),

    .S_AXI_BOOTROM_AWID     (S_AXI_BOOTROM_AWID             ),
    .S_AXI_BOOTROM_AWADDR   (S_AXI_BOOTROM_AWADDR           ),
    .S_AXI_BOOTROM_AWLEN    (S_AXI_BOOTROM_AWLEN            ),
    .S_AXI_BOOTROM_AWSIZE   (S_AXI_BOOTROM_AWSIZE           ),
    .S_AXI_BOOTROM_AWBURST  (S_AXI_BOOTROM_AWBURST          ),
    .S_AXI_BOOTROM_AWLOCK   (S_AXI_BOOTROM_AWLOCK           ),
    .S_AXI_BOOTROM_AWCACHE  (S_AXI_BOOTROM_AWCACHE          ),
    .S_AXI_BOOTROM_AWPROT   (S_AXI_BOOTROM_AWPROT           ),
    .S_AXI_BOOTROM_AWREGION (S_AXI_BOOTROM_AWREGION         ),
    .S_AXI_BOOTROM_AWQOS    (S_AXI_BOOTROM_AWQOS            ),
    .S_AXI_BOOTROM_AWVALID  (S_AXI_BOOTROM_AWVALID          ),
    .S_AXI_BOOTROM_AWREADY  (S_AXI_BOOTROM_AWREADY          ),
    .S_AXI_BOOTROM_WDATA    (S_AXI_BOOTROM_WDATA            ),
    .S_AXI_BOOTROM_WSTRB    (S_AXI_BOOTROM_WSTRB            ),
    .S_AXI_BOOTROM_WLAST    (S_AXI_BOOTROM_WLAST            ),
    .S_AXI_BOOTROM_WVALID   (S_AXI_BOOTROM_WVALID           ),
    .S_AXI_BOOTROM_WREADY   (S_AXI_BOOTROM_WREADY           ),
    .S_AXI_BOOTROM_BID      (S_AXI_BOOTROM_BID              ),
    .S_AXI_BOOTROM_BRESP    (S_AXI_BOOTROM_BRESP            ),
    .S_AXI_BOOTROM_BVALID   (S_AXI_BOOTROM_BVALID           ),
    .S_AXI_BOOTROM_BREADY   (S_AXI_BOOTROM_BREADY           ),
    .S_AXI_BOOTROM_ARID     (S_AXI_BOOTROM_ARID             ),
    .S_AXI_BOOTROM_ARADDR   (S_AXI_BOOTROM_ARADDR           ),
    .S_AXI_BOOTROM_ARLEN    (S_AXI_BOOTROM_ARLEN            ),
    .S_AXI_BOOTROM_ARSIZE   (S_AXI_BOOTROM_ARSIZE           ),
    .S_AXI_BOOTROM_ARBURST  (S_AXI_BOOTROM_ARBURST          ),
    .S_AXI_BOOTROM_ARLOCK   (S_AXI_BOOTROM_ARLOCK           ),
    .S_AXI_BOOTROM_ARCACHE  (S_AXI_BOOTROM_ARCACHE          ),
    .S_AXI_BOOTROM_ARPROT   (S_AXI_BOOTROM_ARPROT           ),
    .S_AXI_BOOTROM_ARREGION (S_AXI_BOOTROM_ARREGION         ),
    .S_AXI_BOOTROM_ARQOS    (S_AXI_BOOTROM_ARQOS            ),
    .S_AXI_BOOTROM_ARVALID  (S_AXI_BOOTROM_ARVALID          ),
    .S_AXI_BOOTROM_ARREADY  (S_AXI_BOOTROM_ARREADY          ),
    .S_AXI_BOOTROM_RID      (S_AXI_BOOTROM_RID              ),
    .S_AXI_BOOTROM_RDATA    (S_AXI_BOOTROM_RDATA            ),
    .S_AXI_BOOTROM_RRESP    (S_AXI_BOOTROM_RRESP            ),
    .S_AXI_BOOTROM_RLAST    (S_AXI_BOOTROM_RLAST            ),
    .S_AXI_BOOTROM_RVALID   (S_AXI_BOOTROM_RVALID           ),
    .S_AXI_BOOTROM_RREADY   (S_AXI_BOOTROM_RREADY           ),

    .S_AXI_INTSRAM_AWID     (S_AXI_INTSRAM_AWID             ),
    .S_AXI_INTSRAM_AWADDR   (S_AXI_INTSRAM_AWADDR           ),
    .S_AXI_INTSRAM_AWLEN    (S_AXI_INTSRAM_AWLEN            ),
    .S_AXI_INTSRAM_AWSIZE   (S_AXI_INTSRAM_AWSIZE           ),
    .S_AXI_INTSRAM_AWBURST  (S_AXI_INTSRAM_AWBURST          ),
    .S_AXI_INTSRAM_AWLOCK   (S_AXI_INTSRAM_AWLOCK           ),
    .S_AXI_INTSRAM_AWCACHE  (S_AXI_INTSRAM_AWCACHE          ),
    .S_AXI_INTSRAM_AWPROT   (S_AXI_INTSRAM_AWPROT           ),
    .S_AXI_INTSRAM_AWREGION (S_AXI_INTSRAM_AWREGION         ),
    .S_AXI_INTSRAM_AWQOS    (S_AXI_INTSRAM_AWQOS            ),
    .S_AXI_INTSRAM_AWVALID  (S_AXI_INTSRAM_AWVALID          ),
    .S_AXI_INTSRAM_AWREADY  (S_AXI_INTSRAM_AWREADY          ),
    .S_AXI_INTSRAM_WDATA    (S_AXI_INTSRAM_WDATA            ),
    .S_AXI_INTSRAM_WSTRB    (S_AXI_INTSRAM_WSTRB            ),
    .S_AXI_INTSRAM_WLAST    (S_AXI_INTSRAM_WLAST            ),
    .S_AXI_INTSRAM_WVALID   (S_AXI_INTSRAM_WVALID           ),
    .S_AXI_INTSRAM_WREADY   (S_AXI_INTSRAM_WREADY           ),
    .S_AXI_INTSRAM_BID      (S_AXI_INTSRAM_BID              ),
    .S_AXI_INTSRAM_BRESP    (S_AXI_INTSRAM_BRESP            ),
    .S_AXI_INTSRAM_BVALID   (S_AXI_INTSRAM_BVALID           ),
    .S_AXI_INTSRAM_BREADY   (S_AXI_INTSRAM_BREADY           ),
    .S_AXI_INTSRAM_ARID     (S_AXI_INTSRAM_ARID             ),
    .S_AXI_INTSRAM_ARADDR   (S_AXI_INTSRAM_ARADDR           ),
    .S_AXI_INTSRAM_ARLEN    (S_AXI_INTSRAM_ARLEN            ),
    .S_AXI_INTSRAM_ARSIZE   (S_AXI_INTSRAM_ARSIZE           ),
    .S_AXI_INTSRAM_ARBURST  (S_AXI_INTSRAM_ARBURST          ),
    .S_AXI_INTSRAM_ARLOCK   (S_AXI_INTSRAM_ARLOCK           ),
    .S_AXI_INTSRAM_ARCACHE  (S_AXI_INTSRAM_ARCACHE          ),
    .S_AXI_INTSRAM_ARPROT   (S_AXI_INTSRAM_ARPROT           ),
    .S_AXI_INTSRAM_ARREGION (S_AXI_INTSRAM_ARREGION         ),
    .S_AXI_INTSRAM_ARQOS    (S_AXI_INTSRAM_ARQOS            ),
    .S_AXI_INTSRAM_ARVALID  (S_AXI_INTSRAM_ARVALID          ),
    .S_AXI_INTSRAM_ARREADY  (S_AXI_INTSRAM_ARREADY          ),
    .S_AXI_INTSRAM_RID      (S_AXI_INTSRAM_RID              ),
    .S_AXI_INTSRAM_RDATA    (S_AXI_INTSRAM_RDATA            ),
    .S_AXI_INTSRAM_RRESP    (S_AXI_INTSRAM_RRESP            ),
    .S_AXI_INTSRAM_RLAST    (S_AXI_INTSRAM_RLAST            ),
    .S_AXI_INTSRAM_RVALID   (S_AXI_INTSRAM_RVALID           ),
    .S_AXI_INTSRAM_RREADY   (S_AXI_INTSRAM_RREADY           ),

    .S_AXI_L3PERI_AWID      (S_AXI_L3PERI_AWID              ),
    .S_AXI_L3PERI_AWADDR    (S_AXI_L3PERI_AWADDR            ),
    .S_AXI_L3PERI_AWLEN     (S_AXI_L3PERI_AWLEN             ),
    .S_AXI_L3PERI_AWSIZE    (S_AXI_L3PERI_AWSIZE            ),
    .S_AXI_L3PERI_AWBURST   (S_AXI_L3PERI_AWBURST           ),
    .S_AXI_L3PERI_AWLOCK    (S_AXI_L3PERI_AWLOCK            ),
    .S_AXI_L3PERI_AWCACHE   (S_AXI_L3PERI_AWCACHE           ),
    .S_AXI_L3PERI_AWPROT    (S_AXI_L3PERI_AWPROT            ),
    .S_AXI_L3PERI_AWREGION  (S_AXI_L3PERI_AWREGION          ),
    .S_AXI_L3PERI_AWQOS     (S_AXI_L3PERI_AWQOS             ),
    .S_AXI_L3PERI_AWVALID   (S_AXI_L3PERI_AWVALID           ),
    .S_AXI_L3PERI_AWREADY   (S_AXI_L3PERI_AWREADY           ),
    .S_AXI_L3PERI_WDATA     (S_AXI_L3PERI_WDATA             ),
    .S_AXI_L3PERI_WSTRB     (S_AXI_L3PERI_WSTRB             ),
    .S_AXI_L3PERI_WLAST     (S_AXI_L3PERI_WLAST             ),
    .S_AXI_L3PERI_WVALID    (S_AXI_L3PERI_WVALID            ),
    .S_AXI_L3PERI_WREADY    (S_AXI_L3PERI_WREADY            ),
    .S_AXI_L3PERI_BID       (S_AXI_L3PERI_BID               ),
    .S_AXI_L3PERI_BRESP     (S_AXI_L3PERI_BRESP             ),
    .S_AXI_L3PERI_BVALID    (S_AXI_L3PERI_BVALID            ),
    .S_AXI_L3PERI_BREADY    (S_AXI_L3PERI_BREADY            ),
    .S_AXI_L3PERI_ARID      (S_AXI_L3PERI_ARID              ),
    .S_AXI_L3PERI_ARADDR    (S_AXI_L3PERI_ARADDR            ),
    .S_AXI_L3PERI_ARLEN     (S_AXI_L3PERI_ARLEN             ),
    .S_AXI_L3PERI_ARSIZE    (S_AXI_L3PERI_ARSIZE            ),
    .S_AXI_L3PERI_ARBURST   (S_AXI_L3PERI_ARBURST           ),
    .S_AXI_L3PERI_ARLOCK    (S_AXI_L3PERI_ARLOCK            ),
    .S_AXI_L3PERI_ARCACHE   (S_AXI_L3PERI_ARCACHE           ),
    .S_AXI_L3PERI_ARPROT    (S_AXI_L3PERI_ARPROT            ),
    .S_AXI_L3PERI_ARREGION  (S_AXI_L3PERI_ARREGION          ),
    .S_AXI_L3PERI_ARQOS     (S_AXI_L3PERI_ARQOS             ),
    .S_AXI_L3PERI_ARVALID   (S_AXI_L3PERI_ARVALID           ),
    .S_AXI_L3PERI_ARREADY   (S_AXI_L3PERI_ARREADY           ),
    .S_AXI_L3PERI_RID       (S_AXI_L3PERI_RID               ),
    .S_AXI_L3PERI_RDATA     (S_AXI_L3PERI_RDATA             ),
    .S_AXI_L3PERI_RRESP     (S_AXI_L3PERI_RRESP             ),
    .S_AXI_L3PERI_RLAST     (S_AXI_L3PERI_RLAST             ),
    .S_AXI_L3PERI_RVALID    (S_AXI_L3PERI_RVALID            ),
    .S_AXI_L3PERI_RREADY    (S_AXI_L3PERI_RREADY            ),

    .S_AXI_FLASH_AWID       (S_AXI_FLASH_AWID               ),
    .S_AXI_FLASH_AWADDR     (S_AXI_FLASH_AWADDR             ),
    .S_AXI_FLASH_AWLEN      (S_AXI_FLASH_AWLEN              ),
    .S_AXI_FLASH_AWSIZE     (S_AXI_FLASH_AWSIZE             ),
    .S_AXI_FLASH_AWBURST    (S_AXI_FLASH_AWBURST            ),
    .S_AXI_FLASH_AWLOCK     (S_AXI_FLASH_AWLOCK             ),
    .S_AXI_FLASH_AWCACHE    (S_AXI_FLASH_AWCACHE            ),
    .S_AXI_FLASH_AWPROT     (S_AXI_FLASH_AWPROT             ),
    .S_AXI_FLASH_AWREGION   (S_AXI_FLASH_AWREGION           ),
    .S_AXI_FLASH_AWQOS      (S_AXI_FLASH_AWQOS              ),
    .S_AXI_FLASH_AWVALID    (S_AXI_FLASH_AWVALID            ),
    .S_AXI_FLASH_AWREADY    (S_AXI_FLASH_AWREADY            ),
    .S_AXI_FLASH_WDATA      (S_AXI_FLASH_WDATA              ),
    .S_AXI_FLASH_WSTRB      (S_AXI_FLASH_WSTRB              ),
    .S_AXI_FLASH_WLAST      (S_AXI_FLASH_WLAST              ),
    .S_AXI_FLASH_WVALID     (S_AXI_FLASH_WVALID             ),
    .S_AXI_FLASH_WREADY     (S_AXI_FLASH_WREADY             ),
    .S_AXI_FLASH_BID        (S_AXI_FLASH_BID                ),
    .S_AXI_FLASH_BRESP      (S_AXI_FLASH_BRESP              ),
    .S_AXI_FLASH_BVALID     (S_AXI_FLASH_BVALID             ),
    .S_AXI_FLASH_BREADY     (S_AXI_FLASH_BREADY             ),
    .S_AXI_FLASH_ARID       (S_AXI_FLASH_ARID               ),
    .S_AXI_FLASH_ARADDR     (S_AXI_FLASH_ARADDR             ),
    .S_AXI_FLASH_ARLEN      (S_AXI_FLASH_ARLEN              ),
    .S_AXI_FLASH_ARSIZE     (S_AXI_FLASH_ARSIZE             ),
    .S_AXI_FLASH_ARBURST    (S_AXI_FLASH_ARBURST            ),
    .S_AXI_FLASH_ARLOCK     (S_AXI_FLASH_ARLOCK             ),
    .S_AXI_FLASH_ARCACHE    (S_AXI_FLASH_ARCACHE            ),
    .S_AXI_FLASH_ARPROT     (S_AXI_FLASH_ARPROT             ),
    .S_AXI_FLASH_ARREGION   (S_AXI_FLASH_ARREGION           ),
    .S_AXI_FLASH_ARQOS      (S_AXI_FLASH_ARQOS              ),
    .S_AXI_FLASH_ARVALID    (S_AXI_FLASH_ARVALID            ),
    .S_AXI_FLASH_ARREADY    (S_AXI_FLASH_ARREADY            ),
    .S_AXI_FLASH_RID        (S_AXI_FLASH_RID                ),
    .S_AXI_FLASH_RDATA      (S_AXI_FLASH_RDATA              ),
    .S_AXI_FLASH_RRESP      (S_AXI_FLASH_RRESP              ),
    .S_AXI_FLASH_RLAST      (S_AXI_FLASH_RLAST              ),
    .S_AXI_FLASH_RVALID     (S_AXI_FLASH_RVALID             ),
    .S_AXI_FLASH_RREADY     (S_AXI_FLASH_RREADY             ),

    .S_AXI_DRAM_AWID        (S_AXI_DRAM_AWID                ),
    .S_AXI_DRAM_AWADDR      (S_AXI_DRAM_AWADDR              ),
    .S_AXI_DRAM_AWLEN       (S_AXI_DRAM_AWLEN               ),
    .S_AXI_DRAM_AWSIZE      (S_AXI_DRAM_AWSIZE              ),
    .S_AXI_DRAM_AWBURST     (S_AXI_DRAM_AWBURST             ),
    .S_AXI_DRAM_AWLOCK      (S_AXI_DRAM_AWLOCK              ),
    .S_AXI_DRAM_AWCACHE     (S_AXI_DRAM_AWCACHE             ),
    .S_AXI_DRAM_AWPROT      (S_AXI_DRAM_AWPROT              ),
    .S_AXI_DRAM_AWREGION    (S_AXI_DRAM_AWREGION            ),
    .S_AXI_DRAM_AWQOS       (S_AXI_DRAM_AWQOS               ),
    .S_AXI_DRAM_AWVALID     (S_AXI_DRAM_AWVALID             ),
    .S_AXI_DRAM_AWREADY     (S_AXI_DRAM_AWREADY             ),
    .S_AXI_DRAM_WDATA       (S_AXI_DRAM_WDATA               ),
    .S_AXI_DRAM_WSTRB       (S_AXI_DRAM_WSTRB               ),
    .S_AXI_DRAM_WLAST       (S_AXI_DRAM_WLAST               ),
    .S_AXI_DRAM_WVALID      (S_AXI_DRAM_WVALID              ),
    .S_AXI_DRAM_WREADY      (S_AXI_DRAM_WREADY              ),
    .S_AXI_DRAM_BID         (S_AXI_DRAM_BID                 ),
    .S_AXI_DRAM_BRESP       (S_AXI_DRAM_BRESP               ),
    .S_AXI_DRAM_BVALID      (S_AXI_DRAM_BVALID              ),
    .S_AXI_DRAM_BREADY      (S_AXI_DRAM_BREADY              ),
    .S_AXI_DRAM_ARID        (S_AXI_DRAM_ARID                ),
    .S_AXI_DRAM_ARADDR      (S_AXI_DRAM_ARADDR              ),
    .S_AXI_DRAM_ARLEN       (S_AXI_DRAM_ARLEN               ),
    .S_AXI_DRAM_ARSIZE      (S_AXI_DRAM_ARSIZE              ),
    .S_AXI_DRAM_ARBURST     (S_AXI_DRAM_ARBURST             ),
    .S_AXI_DRAM_ARLOCK      (S_AXI_DRAM_ARLOCK              ),
    .S_AXI_DRAM_ARCACHE     (S_AXI_DRAM_ARCACHE             ),
    .S_AXI_DRAM_ARPROT      (S_AXI_DRAM_ARPROT              ),
    .S_AXI_DRAM_ARREGION    (S_AXI_DRAM_ARREGION            ),
    .S_AXI_DRAM_ARQOS       (S_AXI_DRAM_ARQOS               ),
    .S_AXI_DRAM_ARVALID     (S_AXI_DRAM_ARVALID             ),
    .S_AXI_DRAM_ARREADY     (S_AXI_DRAM_ARREADY             ),
    .S_AXI_DRAM_RID         (S_AXI_DRAM_RID                 ),
    .S_AXI_DRAM_RDATA       (S_AXI_DRAM_RDATA               ),
    .S_AXI_DRAM_RRESP       (S_AXI_DRAM_RRESP               ),
    .S_AXI_DRAM_RLAST       (S_AXI_DRAM_RLAST               ),
    .S_AXI_DRAM_RVALID      (S_AXI_DRAM_RVALID              ),
    .S_AXI_DRAM_RREADY      (S_AXI_DRAM_RREADY              )
);


/*************
*  BootROM  *
*************/
AXI_BootROM AXI_BootROM
(
    .clk                    (sys_clk                        ),
    .rstn                   (peripheral_rstn                ),
    .S_AXI_AWID             (S_AXI_BOOTROM_AWID             ),
    .S_AXI_AWADDR           (S_AXI_BOOTROM_AWADDR           ),
    .S_AXI_AWLEN            (S_AXI_BOOTROM_AWLEN            ),
    .S_AXI_AWSIZE           (S_AXI_BOOTROM_AWSIZE           ),
    .S_AXI_AWBURST          (S_AXI_BOOTROM_AWBURST          ),
    .S_AXI_AWLOCK           (S_AXI_BOOTROM_AWLOCK           ),
    .S_AXI_AWCACHE          (S_AXI_BOOTROM_AWCACHE          ),
    .S_AXI_AWPROT           (S_AXI_BOOTROM_AWPROT           ),
    .S_AXI_AWQOS            (S_AXI_BOOTROM_AWQOS            ),
    .S_AXI_AWVALID          (S_AXI_BOOTROM_AWVALID          ),
    .S_AXI_AWREADY          (S_AXI_BOOTROM_AWREADY          ),
    .S_AXI_WDATA            (S_AXI_BOOTROM_WDATA            ),
    .S_AXI_WSTRB            (S_AXI_BOOTROM_WSTRB            ),
    .S_AXI_WLAST            (S_AXI_BOOTROM_WLAST            ),
    .S_AXI_WVALID           (S_AXI_BOOTROM_WVALID           ),
    .S_AXI_WREADY           (S_AXI_BOOTROM_WREADY           ),
    .S_AXI_BID              (S_AXI_BOOTROM_BID              ),
    .S_AXI_BRESP            (S_AXI_BOOTROM_BRESP            ),
    .S_AXI_BVALID           (S_AXI_BOOTROM_BVALID           ),
    .S_AXI_BREADY           (S_AXI_BOOTROM_BREADY           ),
    .S_AXI_ARID             (S_AXI_BOOTROM_ARID             ),
    .S_AXI_ARADDR           (S_AXI_BOOTROM_ARADDR           ),
    .S_AXI_ARLEN            (S_AXI_BOOTROM_ARLEN            ),
    .S_AXI_ARSIZE           (S_AXI_BOOTROM_ARSIZE           ),
    .S_AXI_ARBURST          (S_AXI_BOOTROM_ARBURST          ),
    .S_AXI_ARLOCK           (S_AXI_BOOTROM_ARLOCK           ),
    .S_AXI_ARCACHE          (S_AXI_BOOTROM_ARCACHE          ),
    .S_AXI_ARPROT           (S_AXI_BOOTROM_ARPROT           ),
    .S_AXI_ARQOS            (S_AXI_BOOTROM_ARQOS            ),
    .S_AXI_ARVALID          (S_AXI_BOOTROM_ARVALID          ),
    .S_AXI_ARREADY          (S_AXI_BOOTROM_ARREADY          ),
    .S_AXI_RID              (S_AXI_BOOTROM_RID              ),
    .S_AXI_RDATA            (S_AXI_BOOTROM_RDATA            ),
    .S_AXI_RRESP            (S_AXI_BOOTROM_RRESP            ),
    .S_AXI_RLAST            (S_AXI_BOOTROM_RLAST            ),
    .S_AXI_RVALID           (S_AXI_BOOTROM_RVALID           ),
    .S_AXI_RREADY           (S_AXI_BOOTROM_RREADY           )
);

/*******************
*  Internal SRAM  *
*******************/
AXI_InternalSRAM AXI_InternalSRAM
(
    .clk                    (sys_clk                        ),
    .rstn                   (peripheral_rstn                ),
    .S_AXI_AWID             (S_AXI_INTSRAM_AWID             ),
    .S_AXI_AWADDR           (S_AXI_INTSRAM_AWADDR           ),
    .S_AXI_AWLEN            (S_AXI_INTSRAM_AWLEN            ),
    .S_AXI_AWSIZE           (S_AXI_INTSRAM_AWSIZE           ),
    .S_AXI_AWBURST          (S_AXI_INTSRAM_AWBURST          ),
    .S_AXI_AWLOCK           (S_AXI_INTSRAM_AWLOCK           ),
    .S_AXI_AWCACHE          (S_AXI_INTSRAM_AWCACHE          ),
    .S_AXI_AWPROT           (S_AXI_INTSRAM_AWPROT           ),
    .S_AXI_AWQOS            (S_AXI_INTSRAM_AWQOS            ),
    .S_AXI_AWVALID          (S_AXI_INTSRAM_AWVALID          ),
    .S_AXI_AWREADY          (S_AXI_INTSRAM_AWREADY          ),
    .S_AXI_WDATA            (S_AXI_INTSRAM_WDATA            ),
    .S_AXI_WSTRB            (S_AXI_INTSRAM_WSTRB            ),
    .S_AXI_WLAST            (S_AXI_INTSRAM_WLAST            ),
    .S_AXI_WVALID           (S_AXI_INTSRAM_WVALID           ),
    .S_AXI_WREADY           (S_AXI_INTSRAM_WREADY           ),
    .S_AXI_BID              (S_AXI_INTSRAM_BID              ),
    .S_AXI_BRESP            (S_AXI_INTSRAM_BRESP            ),
    .S_AXI_BVALID           (S_AXI_INTSRAM_BVALID           ),
    .S_AXI_BREADY           (S_AXI_INTSRAM_BREADY           ),
    .S_AXI_ARID             (S_AXI_INTSRAM_ARID             ),
    .S_AXI_ARADDR           (S_AXI_INTSRAM_ARADDR           ),
    .S_AXI_ARLEN            (S_AXI_INTSRAM_ARLEN            ),
    .S_AXI_ARSIZE           (S_AXI_INTSRAM_ARSIZE           ),
    .S_AXI_ARBURST          (S_AXI_INTSRAM_ARBURST          ),
    .S_AXI_ARLOCK           (S_AXI_INTSRAM_ARLOCK           ),
    .S_AXI_ARCACHE          (S_AXI_INTSRAM_ARCACHE          ),
    .S_AXI_ARPROT           (S_AXI_INTSRAM_ARPROT           ),
    .S_AXI_ARQOS            (S_AXI_INTSRAM_ARQOS            ),
    .S_AXI_ARVALID          (S_AXI_INTSRAM_ARVALID          ),
    .S_AXI_ARREADY          (S_AXI_INTSRAM_ARREADY          ),
    .S_AXI_RID              (S_AXI_INTSRAM_RID              ),
    .S_AXI_RDATA            (S_AXI_INTSRAM_RDATA            ),
    .S_AXI_RRESP            (S_AXI_INTSRAM_RRESP            ),
    .S_AXI_RLAST            (S_AXI_INTSRAM_RLAST            ),
    .S_AXI_RVALID           (S_AXI_INTSRAM_RVALID           ),
    .S_AXI_RREADY           (S_AXI_INTSRAM_RREADY           )
);

/**********************
*  Flash Controller  *
**********************/
`ifdef SOC_ENABLE_FLASH
    AXI_Flash_Controller AXI_Flash_Controller
    (
        .clk                    (sys_clk                        ),
        .rstn                   (peripheral_rstn                ),
        .emc_clk                (sys_clk                        ),

        .linear_flash_dq_i      (linear_flash_dq_i              ),
        .linear_flash_dq_o      (linear_flash_dq_o              ),
        .linear_flash_dq_t      (linear_flash_dq_t              ),
        .linear_flash_addr      (linear_flash_addr              ),
        .linear_flash_ce_n      (linear_flash_ce_n              ),
        .linear_flash_oen       (linear_flash_oen               ),
        .linear_flash_wen       (linear_flash_wen               ),
        .linear_flash_adv_ldn   (linear_flash_adv_ldn           ),

        .S_AXI_AWID             (S_AXI_FLASH_AWID               ),
        .S_AXI_AWADDR           (S_AXI_FLASH_AWADDR             ),
        .S_AXI_AWLEN            (S_AXI_FLASH_AWLEN              ),
        .S_AXI_AWSIZE           (S_AXI_FLASH_AWSIZE             ),
        .S_AXI_AWBURST          (S_AXI_FLASH_AWBURST            ),
        .S_AXI_AWLOCK           (S_AXI_FLASH_AWLOCK             ),
        .S_AXI_AWCACHE          (S_AXI_FLASH_AWCACHE            ),
        .S_AXI_AWPROT           (S_AXI_FLASH_AWPROT             ),
        .S_AXI_AWQOS            (S_AXI_FLASH_AWQOS              ),
        .S_AXI_AWVALID          (S_AXI_FLASH_AWVALID            ),
        .S_AXI_AWREADY          (S_AXI_FLASH_AWREADY            ),
        .S_AXI_WDATA            (S_AXI_FLASH_WDATA              ),
        .S_AXI_WSTRB            (S_AXI_FLASH_WSTRB              ),
        .S_AXI_WLAST            (S_AXI_FLASH_WLAST              ),
        .S_AXI_WVALID           (S_AXI_FLASH_WVALID             ),
        .S_AXI_WREADY           (S_AXI_FLASH_WREADY             ),
        .S_AXI_BID              (S_AXI_FLASH_BID                ),
        .S_AXI_BRESP            (S_AXI_FLASH_BRESP              ),
        .S_AXI_BVALID           (S_AXI_FLASH_BVALID             ),
        .S_AXI_BREADY           (S_AXI_FLASH_BREADY             ),
        .S_AXI_ARID             (S_AXI_FLASH_ARID               ),
        .S_AXI_ARADDR           (S_AXI_FLASH_ARADDR             ),
        .S_AXI_ARLEN            (S_AXI_FLASH_ARLEN              ),
        .S_AXI_ARSIZE           (S_AXI_FLASH_ARSIZE             ),
        .S_AXI_ARBURST          (S_AXI_FLASH_ARBURST            ),
        .S_AXI_ARLOCK           (S_AXI_FLASH_ARLOCK             ),
        .S_AXI_ARCACHE          (S_AXI_FLASH_ARCACHE            ),
        .S_AXI_ARPROT           (S_AXI_FLASH_ARPROT             ),
        .S_AXI_ARQOS            (S_AXI_FLASH_ARQOS              ),
        .S_AXI_ARVALID          (S_AXI_FLASH_ARVALID            ),
        .S_AXI_ARREADY          (S_AXI_FLASH_ARREADY            ),
        .S_AXI_RID              (S_AXI_FLASH_RID                ),
        .S_AXI_RDATA            (S_AXI_FLASH_RDATA              ),
        .S_AXI_RRESP            (S_AXI_FLASH_RRESP              ),
        .S_AXI_RLAST            (S_AXI_FLASH_RLAST              ),
        .S_AXI_RVALID           (S_AXI_FLASH_RVALID             ),
        .S_AXI_RREADY           (S_AXI_FLASH_RREADY             )
    );
`else
    assign S_AXI_FLASH_AWREADY = 0;
    assign S_AXI_FLASH_WREADY  = 0;
    assign S_AXI_FLASH_BID     = 0;
    assign S_AXI_FLASH_BRESP   = 0;
    assign S_AXI_FLASH_BVALID  = 0;
    assign S_AXI_FLASH_ARREADY = 0;
    assign S_AXI_FLASH_RID     = 0;
    assign S_AXI_FLASH_RDATA   = 0;
    assign S_AXI_FLASH_RRESP   = 0;
    assign S_AXI_FLASH_RLAST   = 0;
    assign S_AXI_FLASH_RVALID  = 0;
`endif


/*********************
*  DRAM Controller  *
*********************/
`ifdef SOC_ENABLE_DRAM
    AXI_DRAM_Controller AXI_DRAM_Controller
    (
        .clk_p              (clk_p                          ),
        .clk_n              (clk_n                          ),
        .reset              (reset                          ),

        .sys_clk            (sys_clk                        ),
        .sys_rst            (sys_rst                        ),
        .interconnect_rstn  (interconnect_rstn              ),
        .peripheral_rstn    (peripheral_rstn                ),

        .ddr3_addr          (ddr3_addr                      ),
        .ddr3_ba            (ddr3_ba                        ),
        .ddr3_cas_n         (ddr3_cas_n                     ),
        .ddr3_ck_n          (ddr3_ck_n                      ),
        .ddr3_ck_p          (ddr3_ck_p                      ),
        .ddr3_cke           (ddr3_cke                       ),
        .ddr3_ras_n         (ddr3_ras_n                     ),
        .ddr3_reset_n       (ddr3_reset_n                   ),
        .ddr3_we_n          (ddr3_we_n                      ),
        .ddr3_dq            (ddr3_dq                        ),
        .ddr3_dqs_n         (ddr3_dqs_n                     ),
        .ddr3_dqs_p         (ddr3_dqs_p                     ),
        .ddr3_cs_n          (ddr3_cs_n                      ),
        .ddr3_dm            (ddr3_dm                        ),
        .ddr3_odt           (ddr3_odt                       ),

        .S_AXI_AWID         (S_AXI_DRAM_AWID                ),
        .S_AXI_AWADDR       (S_AXI_DRAM_AWADDR              ),
        .S_AXI_AWLEN        (S_AXI_DRAM_AWLEN               ),
        .S_AXI_AWSIZE       (S_AXI_DRAM_AWSIZE              ),
        .S_AXI_AWBURST      (S_AXI_DRAM_AWBURST             ),
        .S_AXI_AWLOCK       (S_AXI_DRAM_AWLOCK              ),
        .S_AXI_AWCACHE      (S_AXI_DRAM_AWCACHE             ),
        .S_AXI_AWPROT       (S_AXI_DRAM_AWPROT              ),
        .S_AXI_AWREGION     (S_AXI_DRAM_AWREGION            ),
        .S_AXI_AWQOS        (S_AXI_DRAM_AWQOS               ),
        .S_AXI_AWVALID      (S_AXI_DRAM_AWVALID             ),
        .S_AXI_AWREADY      (S_AXI_DRAM_AWREADY             ),
        .S_AXI_WDATA        (S_AXI_DRAM_WDATA               ),
        .S_AXI_WSTRB        (S_AXI_DRAM_WSTRB               ),
        .S_AXI_WLAST        (S_AXI_DRAM_WLAST               ),
        .S_AXI_WVALID       (S_AXI_DRAM_WVALID              ),
        .S_AXI_WREADY       (S_AXI_DRAM_WREADY              ),
        .S_AXI_BID          (S_AXI_DRAM_BID                 ),
        .S_AXI_BRESP        (S_AXI_DRAM_BRESP               ),
        .S_AXI_BVALID       (S_AXI_DRAM_BVALID              ),
        .S_AXI_BREADY       (S_AXI_DRAM_BREADY              ),
        .S_AXI_ARID         (S_AXI_DRAM_ARID                ),
        .S_AXI_ARADDR       (S_AXI_DRAM_ARADDR              ),
        .S_AXI_ARLEN        (S_AXI_DRAM_ARLEN               ),
        .S_AXI_ARSIZE       (S_AXI_DRAM_ARSIZE              ),
        .S_AXI_ARBURST      (S_AXI_DRAM_ARBURST             ),
        .S_AXI_ARLOCK       (S_AXI_DRAM_ARLOCK              ),
        .S_AXI_ARCACHE      (S_AXI_DRAM_ARCACHE             ),
        .S_AXI_ARPROT       (S_AXI_DRAM_ARPROT              ),
        .S_AXI_ARREGION     (S_AXI_DRAM_ARREGION            ),
        .S_AXI_ARQOS        (S_AXI_DRAM_ARQOS               ),
        .S_AXI_ARVALID      (S_AXI_DRAM_ARVALID             ),
        .S_AXI_ARREADY      (S_AXI_DRAM_ARREADY             ),
        .S_AXI_RID          (S_AXI_DRAM_RID                 ),
        .S_AXI_RDATA        (S_AXI_DRAM_RDATA               ),
        .S_AXI_RRESP        (S_AXI_DRAM_RRESP               ),
        .S_AXI_RLAST        (S_AXI_DRAM_RLAST               ),
        .S_AXI_RVALID       (S_AXI_DRAM_RVALID              ),
        .S_AXI_RREADY       (S_AXI_DRAM_RREADY              )
    );
`else
    assign S_AXI_DRAM_AWREADY = 0;
    assign S_AXI_DRAM_WREADY  = 0;
    assign S_AXI_DRAM_BID     = 0;
    assign S_AXI_DRAM_BRESP   = 0;
    assign S_AXI_DRAM_BVALID  = 0;
    assign S_AXI_DRAM_ARREADY = 0;
    assign S_AXI_DRAM_RID     = 0;
    assign S_AXI_DRAM_RDATA   = 0;
    assign S_AXI_DRAM_RRESP   = 0;
    assign S_AXI_DRAM_RLAST   = 0;
    assign S_AXI_DRAM_RVALID  = 0;
`endif


/*********************
*  L3 Interconnect  *
*********************/
SoC_L3_XBar SoC_L3_XBar
(
    .clk                    (sys_clk                        ),
    .rstn                   (interconnect_rstn              ),

    .M_AXI_L3PERI_AWID      (S_AXI_L3PERI_AWID              ),
    .M_AXI_L3PERI_AWADDR    (S_AXI_L3PERI_AWADDR            ),
    .M_AXI_L3PERI_AWLEN     (S_AXI_L3PERI_AWLEN             ),
    .M_AXI_L3PERI_AWSIZE    (S_AXI_L3PERI_AWSIZE            ),
    .M_AXI_L3PERI_AWBURST   (S_AXI_L3PERI_AWBURST           ),
    .M_AXI_L3PERI_AWLOCK    (S_AXI_L3PERI_AWLOCK            ),
    .M_AXI_L3PERI_AWCACHE   (S_AXI_L3PERI_AWCACHE           ),
    .M_AXI_L3PERI_AWPROT    (S_AXI_L3PERI_AWPROT            ),
    .M_AXI_L3PERI_AWREGION  (S_AXI_L3PERI_AWREGION          ),
    .M_AXI_L3PERI_AWQOS     (S_AXI_L3PERI_AWQOS             ),
    .M_AXI_L3PERI_AWVALID   (S_AXI_L3PERI_AWVALID           ),
    .M_AXI_L3PERI_AWREADY   (S_AXI_L3PERI_AWREADY           ),
    .M_AXI_L3PERI_WDATA     (S_AXI_L3PERI_WDATA             ),
    .M_AXI_L3PERI_WSTRB     (S_AXI_L3PERI_WSTRB             ),
    .M_AXI_L3PERI_WLAST     (S_AXI_L3PERI_WLAST             ),
    .M_AXI_L3PERI_WVALID    (S_AXI_L3PERI_WVALID            ),
    .M_AXI_L3PERI_WREADY    (S_AXI_L3PERI_WREADY            ),
    .M_AXI_L3PERI_BID       (S_AXI_L3PERI_BID               ),
    .M_AXI_L3PERI_BRESP     (S_AXI_L3PERI_BRESP             ),
    .M_AXI_L3PERI_BVALID    (S_AXI_L3PERI_BVALID            ),
    .M_AXI_L3PERI_BREADY    (S_AXI_L3PERI_BREADY            ),
    .M_AXI_L3PERI_ARID      (S_AXI_L3PERI_ARID              ),
    .M_AXI_L3PERI_ARADDR    (S_AXI_L3PERI_ARADDR            ),
    .M_AXI_L3PERI_ARLEN     (S_AXI_L3PERI_ARLEN             ),
    .M_AXI_L3PERI_ARSIZE    (S_AXI_L3PERI_ARSIZE            ),
    .M_AXI_L3PERI_ARBURST   (S_AXI_L3PERI_ARBURST           ),
    .M_AXI_L3PERI_ARLOCK    (S_AXI_L3PERI_ARLOCK            ),
    .M_AXI_L3PERI_ARCACHE   (S_AXI_L3PERI_ARCACHE           ),
    .M_AXI_L3PERI_ARPROT    (S_AXI_L3PERI_ARPROT            ),
    .M_AXI_L3PERI_ARREGION  (S_AXI_L3PERI_ARREGION          ),
    .M_AXI_L3PERI_ARQOS     (S_AXI_L3PERI_ARQOS             ),
    .M_AXI_L3PERI_ARVALID   (S_AXI_L3PERI_ARVALID           ),
    .M_AXI_L3PERI_ARREADY   (S_AXI_L3PERI_ARREADY           ),
    .M_AXI_L3PERI_RID       (S_AXI_L3PERI_RID               ),
    .M_AXI_L3PERI_RDATA     (S_AXI_L3PERI_RDATA             ),
    .M_AXI_L3PERI_RRESP     (S_AXI_L3PERI_RRESP             ),
    .M_AXI_L3PERI_RLAST     (S_AXI_L3PERI_RLAST             ),
    .M_AXI_L3PERI_RVALID    (S_AXI_L3PERI_RVALID            ),
    .M_AXI_L3PERI_RREADY    (S_AXI_L3PERI_RREADY            ),

    .S_AXI_UART_AWADDR      (S_AXI_UART_AWADDR              ),
    .S_AXI_UART_AWPROT      (S_AXI_UART_AWPROT              ),
    .S_AXI_UART_AWVALID     (S_AXI_UART_AWVALID             ),
    .S_AXI_UART_AWREADY     (S_AXI_UART_AWREADY             ),
    .S_AXI_UART_WDATA       (S_AXI_UART_WDATA               ),
    .S_AXI_UART_WSTRB       (S_AXI_UART_WSTRB               ),
    .S_AXI_UART_WVALID      (S_AXI_UART_WVALID              ),
    .S_AXI_UART_WREADY      (S_AXI_UART_WREADY              ),
    .S_AXI_UART_BRESP       (S_AXI_UART_BRESP               ),
    .S_AXI_UART_BVALID      (S_AXI_UART_BVALID              ),
    .S_AXI_UART_BREADY      (S_AXI_UART_BREADY              ),
    .S_AXI_UART_ARADDR      (S_AXI_UART_ARADDR              ),
    .S_AXI_UART_ARPROT      (S_AXI_UART_ARPROT              ),
    .S_AXI_UART_ARVALID     (S_AXI_UART_ARVALID             ),
    .S_AXI_UART_ARREADY     (S_AXI_UART_ARREADY             ),
    .S_AXI_UART_RDATA       (S_AXI_UART_RDATA               ),
    .S_AXI_UART_RRESP       (S_AXI_UART_RRESP               ),
    .S_AXI_UART_RVALID      (S_AXI_UART_RVALID              ),
    .S_AXI_UART_RREADY      (S_AXI_UART_RREADY              ),

    .S_AXI_GPIO0_AWADDR     (S_AXI_GPIO0_AWADDR             ),
    .S_AXI_GPIO0_AWPROT     (S_AXI_GPIO0_AWPROT             ),
    .S_AXI_GPIO0_AWVALID    (S_AXI_GPIO0_AWVALID            ),
    .S_AXI_GPIO0_AWREADY    (S_AXI_GPIO0_AWREADY            ),
    .S_AXI_GPIO0_WDATA      (S_AXI_GPIO0_WDATA              ),
    .S_AXI_GPIO0_WSTRB      (S_AXI_GPIO0_WSTRB              ),
    .S_AXI_GPIO0_WVALID     (S_AXI_GPIO0_WVALID             ),
    .S_AXI_GPIO0_WREADY     (S_AXI_GPIO0_WREADY             ),
    .S_AXI_GPIO0_BRESP      (S_AXI_GPIO0_BRESP              ),
    .S_AXI_GPIO0_BVALID     (S_AXI_GPIO0_BVALID             ),
    .S_AXI_GPIO0_BREADY     (S_AXI_GPIO0_BREADY             ),
    .S_AXI_GPIO0_ARADDR     (S_AXI_GPIO0_ARADDR             ),
    .S_AXI_GPIO0_ARPROT     (S_AXI_GPIO0_ARPROT             ),
    .S_AXI_GPIO0_ARVALID    (S_AXI_GPIO0_ARVALID            ),
    .S_AXI_GPIO0_ARREADY    (S_AXI_GPIO0_ARREADY            ),
    .S_AXI_GPIO0_RDATA      (S_AXI_GPIO0_RDATA              ),
    .S_AXI_GPIO0_RRESP      (S_AXI_GPIO0_RRESP              ),
    .S_AXI_GPIO0_RVALID     (S_AXI_GPIO0_RVALID             ),
    .S_AXI_GPIO0_RREADY     (S_AXI_GPIO0_RREADY             ),

    .S_AXI_I2C_AWADDR       (S_AXI_I2C_AWADDR               ),
    .S_AXI_I2C_AWPROT       (S_AXI_I2C_AWPROT               ),
    .S_AXI_I2C_AWVALID      (S_AXI_I2C_AWVALID              ),
    .S_AXI_I2C_AWREADY      (S_AXI_I2C_AWREADY              ),
    .S_AXI_I2C_WDATA        (S_AXI_I2C_WDATA                ),
    .S_AXI_I2C_WSTRB        (S_AXI_I2C_WSTRB                ),
    .S_AXI_I2C_WVALID       (S_AXI_I2C_WVALID               ),
    .S_AXI_I2C_WREADY       (S_AXI_I2C_WREADY               ),
    .S_AXI_I2C_BRESP        (S_AXI_I2C_BRESP                ),
    .S_AXI_I2C_BVALID       (S_AXI_I2C_BVALID               ),
    .S_AXI_I2C_BREADY       (S_AXI_I2C_BREADY               ),
    .S_AXI_I2C_ARADDR       (S_AXI_I2C_ARADDR               ),
    .S_AXI_I2C_ARPROT       (S_AXI_I2C_ARPROT               ),
    .S_AXI_I2C_ARVALID      (S_AXI_I2C_ARVALID              ),
    .S_AXI_I2C_ARREADY      (S_AXI_I2C_ARREADY              ),
    .S_AXI_I2C_RDATA        (S_AXI_I2C_RDATA                ),
    .S_AXI_I2C_RRESP        (S_AXI_I2C_RRESP                ),
    .S_AXI_I2C_RVALID       (S_AXI_I2C_RVALID               ),
    .S_AXI_I2C_RREADY       (S_AXI_I2C_RREADY               ),

    .S_AXI_TIMER_AWADDR     (S_AXI_TIMER_AWADDR             ),
    .S_AXI_TIMER_AWPROT     (S_AXI_TIMER_AWPROT             ),
    .S_AXI_TIMER_AWVALID    (S_AXI_TIMER_AWVALID            ),
    .S_AXI_TIMER_AWREADY    (S_AXI_TIMER_AWREADY            ),
    .S_AXI_TIMER_WDATA      (S_AXI_TIMER_WDATA              ),
    .S_AXI_TIMER_WSTRB      (S_AXI_TIMER_WSTRB              ),
    .S_AXI_TIMER_WVALID     (S_AXI_TIMER_WVALID             ),
    .S_AXI_TIMER_WREADY     (S_AXI_TIMER_WREADY             ),
    .S_AXI_TIMER_BRESP      (S_AXI_TIMER_BRESP              ),
    .S_AXI_TIMER_BVALID     (S_AXI_TIMER_BVALID             ),
    .S_AXI_TIMER_BREADY     (S_AXI_TIMER_BREADY             ),
    .S_AXI_TIMER_ARADDR     (S_AXI_TIMER_ARADDR             ),
    .S_AXI_TIMER_ARPROT     (S_AXI_TIMER_ARPROT             ),
    .S_AXI_TIMER_ARVALID    (S_AXI_TIMER_ARVALID            ),
    .S_AXI_TIMER_ARREADY    (S_AXI_TIMER_ARREADY            ),
    .S_AXI_TIMER_RDATA      (S_AXI_TIMER_RDATA              ),
    .S_AXI_TIMER_RRESP      (S_AXI_TIMER_RRESP              ),
    .S_AXI_TIMER_RVALID     (S_AXI_TIMER_RVALID             ),
    .S_AXI_TIMER_RREADY     (S_AXI_TIMER_RREADY             ),

    .S_AXI_SPI_AWADDR       (S_AXI_SPI_AWADDR               ),
    .S_AXI_SPI_AWPROT       (S_AXI_SPI_AWPROT               ),
    .S_AXI_SPI_AWVALID      (S_AXI_SPI_AWVALID              ),
    .S_AXI_SPI_AWREADY      (S_AXI_SPI_AWREADY              ),
    .S_AXI_SPI_WDATA        (S_AXI_SPI_WDATA                ),
    .S_AXI_SPI_WSTRB        (S_AXI_SPI_WSTRB                ),
    .S_AXI_SPI_WVALID       (S_AXI_SPI_WVALID               ),
    .S_AXI_SPI_WREADY       (S_AXI_SPI_WREADY               ),
    .S_AXI_SPI_BRESP        (S_AXI_SPI_BRESP                ),
    .S_AXI_SPI_BVALID       (S_AXI_SPI_BVALID               ),
    .S_AXI_SPI_BREADY       (S_AXI_SPI_BREADY               ),
    .S_AXI_SPI_ARADDR       (S_AXI_SPI_ARADDR               ),
    .S_AXI_SPI_ARPROT       (S_AXI_SPI_ARPROT               ),
    .S_AXI_SPI_ARVALID      (S_AXI_SPI_ARVALID              ),
    .S_AXI_SPI_ARREADY      (S_AXI_SPI_ARREADY              ),
    .S_AXI_SPI_RDATA        (S_AXI_SPI_RDATA                ),
    .S_AXI_SPI_RRESP        (S_AXI_SPI_RRESP                ),
    .S_AXI_SPI_RVALID       (S_AXI_SPI_RVALID               ),
    .S_AXI_SPI_RREADY       (S_AXI_SPI_RREADY               ),

    .S_AXI_GPIO1_AWADDR     (S_AXI_GPIO1_AWADDR             ),
    .S_AXI_GPIO1_AWPROT     (S_AXI_GPIO1_AWPROT             ),
    .S_AXI_GPIO1_AWVALID    (S_AXI_GPIO1_AWVALID            ),
    .S_AXI_GPIO1_AWREADY    (S_AXI_GPIO1_AWREADY            ),
    .S_AXI_GPIO1_WDATA      (S_AXI_GPIO1_WDATA              ),
    .S_AXI_GPIO1_WSTRB      (S_AXI_GPIO1_WSTRB              ),
    .S_AXI_GPIO1_WVALID     (S_AXI_GPIO1_WVALID             ),
    .S_AXI_GPIO1_WREADY     (S_AXI_GPIO1_WREADY             ),
    .S_AXI_GPIO1_BRESP      (S_AXI_GPIO1_BRESP              ),
    .S_AXI_GPIO1_BVALID     (S_AXI_GPIO1_BVALID             ),
    .S_AXI_GPIO1_BREADY     (S_AXI_GPIO1_BREADY             ),
    .S_AXI_GPIO1_ARADDR     (S_AXI_GPIO1_ARADDR             ),
    .S_AXI_GPIO1_ARPROT     (S_AXI_GPIO1_ARPROT             ),
    .S_AXI_GPIO1_ARVALID    (S_AXI_GPIO1_ARVALID            ),
    .S_AXI_GPIO1_ARREADY    (S_AXI_GPIO1_ARREADY            ),
    .S_AXI_GPIO1_RDATA      (S_AXI_GPIO1_RDATA              ),
    .S_AXI_GPIO1_RRESP      (S_AXI_GPIO1_RRESP              ),
    .S_AXI_GPIO1_RVALID     (S_AXI_GPIO1_RVALID             ),
    .S_AXI_GPIO1_RREADY     (S_AXI_GPIO1_RREADY             )
);


/**********
*  UART  *
**********/
AXIlite_UART AXIlite_UART
(
    .clk                    (sys_clk                        ),
    .rstn                   (peripheral_rstn                ),
    .rx                     (rs232_uart_rxd                 ),
    .tx                     (rs232_uart_txd                 ),
    .interrupt              (uart_irq                       ),

    .S_AXI_AWADDR           (S_AXI_UART_AWADDR              ),
    .S_AXI_AWPROT           (S_AXI_UART_AWPROT              ),
    .S_AXI_AWVALID          (S_AXI_UART_AWVALID             ),
    .S_AXI_AWREADY          (S_AXI_UART_AWREADY             ),
    .S_AXI_WDATA            (S_AXI_UART_WDATA               ),
    .S_AXI_WSTRB            (S_AXI_UART_WSTRB               ),
    .S_AXI_WVALID           (S_AXI_UART_WVALID              ),
    .S_AXI_WREADY           (S_AXI_UART_WREADY              ),
    .S_AXI_BRESP            (S_AXI_UART_BRESP               ),
    .S_AXI_BVALID           (S_AXI_UART_BVALID              ),
    .S_AXI_BREADY           (S_AXI_UART_BREADY              ),
    .S_AXI_ARADDR           (S_AXI_UART_ARADDR              ),
    .S_AXI_ARPROT           (S_AXI_UART_ARPROT              ),
    .S_AXI_ARVALID          (S_AXI_UART_ARVALID             ),
    .S_AXI_ARREADY          (S_AXI_UART_ARREADY             ),
    .S_AXI_RDATA            (S_AXI_UART_RDATA               ),
    .S_AXI_RRESP            (S_AXI_UART_RRESP               ),
    .S_AXI_RVALID           (S_AXI_UART_RVALID              ),
    .S_AXI_RREADY           (S_AXI_UART_RREADY              )
);

/***********
*  GPIO0  *
***********/
AXIlite_GPIO AXIlite_GPIO0
(
    .clk                    (sys_clk                        ),
    .rstn                   (peripheral_rstn                ),

    .gpio_A_o               (gpio0_A_o                      ),
    .gpio_B_i               (gpio0_B_i                      ),

    .interrupt              (gpio0_irq                      ),

    .S_AXI_AWADDR           (S_AXI_GPIO0_AWADDR             ),
    .S_AXI_AWPROT           (S_AXI_GPIO0_AWPROT             ),
    .S_AXI_AWVALID          (S_AXI_GPIO0_AWVALID            ),
    .S_AXI_AWREADY          (S_AXI_GPIO0_AWREADY            ),
    .S_AXI_WDATA            (S_AXI_GPIO0_WDATA              ),
    .S_AXI_WSTRB            (S_AXI_GPIO0_WSTRB              ),
    .S_AXI_WVALID           (S_AXI_GPIO0_WVALID             ),
    .S_AXI_WREADY           (S_AXI_GPIO0_WREADY             ),
    .S_AXI_BRESP            (S_AXI_GPIO0_BRESP              ),
    .S_AXI_BVALID           (S_AXI_GPIO0_BVALID             ),
    .S_AXI_BREADY           (S_AXI_GPIO0_BREADY             ),
    .S_AXI_ARADDR           (S_AXI_GPIO0_ARADDR             ),
    .S_AXI_ARPROT           (S_AXI_GPIO0_ARPROT             ),
    .S_AXI_ARVALID          (S_AXI_GPIO0_ARVALID            ),
    .S_AXI_ARREADY          (S_AXI_GPIO0_ARREADY            ),
    .S_AXI_RDATA            (S_AXI_GPIO0_RDATA              ),
    .S_AXI_RRESP            (S_AXI_GPIO0_RRESP              ),
    .S_AXI_RVALID           (S_AXI_GPIO0_RVALID             ),
    .S_AXI_RREADY           (S_AXI_GPIO0_RREADY             )
);

/***************
*  I2C or XADC *
***************/
`ifndef SOC_ENABLE_XADC
    AXIlite_I2C AXIlite_I2C
    (
        .clk                    (sys_clk                        ),
        .rstn                   (peripheral_rstn                ),

        .sda_i                  (i2c_sda_i                      ),
        .sda_o                  (i2c_sda_o                      ),
        .sda_t                  (i2c_sda_t                      ),
        .scl_i                  (i2c_scl_i                      ),
        .scl_o                  (i2c_scl_o                      ),
        .scl_t                  (i2c_scl_t                      ),
        .interrupt              (i2c_irq                        ),

        .S_AXI_AWADDR           (S_AXI_I2C_AWADDR               ),
        .S_AXI_AWPROT           (S_AXI_I2C_AWPROT               ),
        .S_AXI_AWVALID          (S_AXI_I2C_AWVALID              ),
        .S_AXI_AWREADY          (S_AXI_I2C_AWREADY              ),
        .S_AXI_WDATA            (S_AXI_I2C_WDATA                ),
        .S_AXI_WSTRB            (S_AXI_I2C_WSTRB                ),
        .S_AXI_WVALID           (S_AXI_I2C_WVALID               ),
        .S_AXI_WREADY           (S_AXI_I2C_WREADY               ),
        .S_AXI_BRESP            (S_AXI_I2C_BRESP                ),
        .S_AXI_BVALID           (S_AXI_I2C_BVALID               ),
        .S_AXI_BREADY           (S_AXI_I2C_BREADY               ),
        .S_AXI_ARADDR           (S_AXI_I2C_ARADDR               ),
        .S_AXI_ARPROT           (S_AXI_I2C_ARPROT               ),
        .S_AXI_ARVALID          (S_AXI_I2C_ARVALID              ),
        .S_AXI_ARREADY          (S_AXI_I2C_ARREADY              ),
        .S_AXI_RDATA            (S_AXI_I2C_RDATA                ),
        .S_AXI_RRESP            (S_AXI_I2C_RRESP                ),
        .S_AXI_RVALID           (S_AXI_I2C_RVALID               ),
        .S_AXI_RREADY           (S_AXI_I2C_RREADY               )
    );
`else
    AXIlite_XADC AXIlite_XADC
    (
        .clk                    (sys_clk                        ),
        .rstn                   (peripheral_rstn                ),

        .S_AXI_AWADDR           (S_AXI_I2C_AWADDR               ),
        .S_AXI_AWPROT           (S_AXI_I2C_AWPROT               ),
        .S_AXI_AWVALID          (S_AXI_I2C_AWVALID              ),
        .S_AXI_AWREADY          (S_AXI_I2C_AWREADY              ),
        .S_AXI_WDATA            (S_AXI_I2C_WDATA                ),
        .S_AXI_WSTRB            (S_AXI_I2C_WSTRB                ),
        .S_AXI_WVALID           (S_AXI_I2C_WVALID               ),
        .S_AXI_WREADY           (S_AXI_I2C_WREADY               ),
        .S_AXI_BRESP            (S_AXI_I2C_BRESP                ),
        .S_AXI_BVALID           (S_AXI_I2C_BVALID               ),
        .S_AXI_BREADY           (S_AXI_I2C_BREADY               ),
        .S_AXI_ARADDR           (S_AXI_I2C_ARADDR               ),
        .S_AXI_ARPROT           (S_AXI_I2C_ARPROT               ),
        .S_AXI_ARVALID          (S_AXI_I2C_ARVALID              ),
        .S_AXI_ARREADY          (S_AXI_I2C_ARREADY              ),
        .S_AXI_RDATA            (S_AXI_I2C_RDATA                ),
        .S_AXI_RRESP            (S_AXI_I2C_RRESP                ),
        .S_AXI_RVALID           (S_AXI_I2C_RVALID               ),
        .S_AXI_RREADY           (S_AXI_I2C_RREADY               )
    );
    assign i2c_sda_o = 0;
    assign i2c_scl_o = 0;
    assign i2c_sda_t = 1; //tristate I2C SDA
    assign i2c_scl_t = 1; //tristate I2C SCL
`endif


/***********
*  Timer  *
***********/
AXIlite_Timer AXIlite_Timer
(
    .clk                    (sys_clk                        ),
    .rstn                   (peripheral_rstn                ),
    .capturetrig0           (timer_capture0                 ),
    .capturetrig1           (timer_capture1                 ),
    .generateout0           (timer_out0                     ),
    .generateout1           (timer_out1                     ),
    .pwm0                   (timer_pwm0                     ),
    .interrupt              (timer_irq                      ),

    .S_AXI_AWADDR           (S_AXI_TIMER_AWADDR             ),
    .S_AXI_AWPROT           (S_AXI_TIMER_AWPROT             ),
    .S_AXI_AWVALID          (S_AXI_TIMER_AWVALID            ),
    .S_AXI_AWREADY          (S_AXI_TIMER_AWREADY            ),
    .S_AXI_WDATA            (S_AXI_TIMER_WDATA              ),
    .S_AXI_WSTRB            (S_AXI_TIMER_WSTRB              ),
    .S_AXI_WVALID           (S_AXI_TIMER_WVALID             ),
    .S_AXI_WREADY           (S_AXI_TIMER_WREADY             ),
    .S_AXI_BRESP            (S_AXI_TIMER_BRESP              ),
    .S_AXI_BVALID           (S_AXI_TIMER_BVALID             ),
    .S_AXI_BREADY           (S_AXI_TIMER_BREADY             ),
    .S_AXI_ARADDR           (S_AXI_TIMER_ARADDR             ),
    .S_AXI_ARPROT           (S_AXI_TIMER_ARPROT             ),
    .S_AXI_ARVALID          (S_AXI_TIMER_ARVALID            ),
    .S_AXI_ARREADY          (S_AXI_TIMER_ARREADY            ),
    .S_AXI_RDATA            (S_AXI_TIMER_RDATA              ),
    .S_AXI_RRESP            (S_AXI_TIMER_RRESP              ),
    .S_AXI_RVALID           (S_AXI_TIMER_RVALID             ),
    .S_AXI_RREADY           (S_AXI_TIMER_RREADY             )
);

/*********
*  SPI  *
*********/
AXIlite_SPI AXIlite_SPI
(
    .clk                    (sys_clk                        ),
    .rstn                   (peripheral_rstn                ),
    .spi_clk                (sys_clk                        ),

    .spi_mosi_o             (spi_mosi_o                     ),
    .spi_miso_i             (spi_miso_i                     ),
    .spi_sck_o              (spi_sck_o                      ),
    .spi_ss_o               (spi_ss_o                       ),

    .interrupt              (spi_irq                        ),

    .S_AXI_AWADDR           (S_AXI_SPI_AWADDR               ),
    .S_AXI_AWPROT           (S_AXI_SPI_AWPROT               ),
    .S_AXI_AWVALID          (S_AXI_SPI_AWVALID              ),
    .S_AXI_AWREADY          (S_AXI_SPI_AWREADY              ),
    .S_AXI_WDATA            (S_AXI_SPI_WDATA                ),
    .S_AXI_WSTRB            (S_AXI_SPI_WSTRB                ),
    .S_AXI_WVALID           (S_AXI_SPI_WVALID               ),
    .S_AXI_WREADY           (S_AXI_SPI_WREADY               ),
    .S_AXI_BRESP            (S_AXI_SPI_BRESP                ),
    .S_AXI_BVALID           (S_AXI_SPI_BVALID               ),
    .S_AXI_BREADY           (S_AXI_SPI_BREADY               ),
    .S_AXI_ARADDR           (S_AXI_SPI_ARADDR               ),
    .S_AXI_ARPROT           (S_AXI_SPI_ARPROT               ),
    .S_AXI_ARVALID          (S_AXI_SPI_ARVALID              ),
    .S_AXI_ARREADY          (S_AXI_SPI_ARREADY              ),
    .S_AXI_RDATA            (S_AXI_SPI_RDATA                ),
    .S_AXI_RRESP            (S_AXI_SPI_RRESP                ),
    .S_AXI_RVALID           (S_AXI_SPI_RVALID               ),
    .S_AXI_RREADY           (S_AXI_SPI_RREADY               )
);

/***********
*  GPIO0  *
***********/
AXIlite_GPIO AXIlite_GPIO1
(
    .clk                    (sys_clk                        ),
    .rstn                   (peripheral_rstn                ),

    .gpio_A_o               (gpio1_A_o                      ),
    .gpio_B_i               (gpio1_B_i                      ),

    .interrupt              (gpio1_irq                      ),

    .S_AXI_AWADDR           (S_AXI_GPIO1_AWADDR             ),
    .S_AXI_AWPROT           (S_AXI_GPIO1_AWPROT             ),
    .S_AXI_AWVALID          (S_AXI_GPIO1_AWVALID            ),
    .S_AXI_AWREADY          (S_AXI_GPIO1_AWREADY            ),
    .S_AXI_WDATA            (S_AXI_GPIO1_WDATA              ),
    .S_AXI_WSTRB            (S_AXI_GPIO1_WSTRB              ),
    .S_AXI_WVALID           (S_AXI_GPIO1_WVALID             ),
    .S_AXI_WREADY           (S_AXI_GPIO1_WREADY             ),
    .S_AXI_BRESP            (S_AXI_GPIO1_BRESP              ),
    .S_AXI_BVALID           (S_AXI_GPIO1_BVALID             ),
    .S_AXI_BREADY           (S_AXI_GPIO1_BREADY             ),
    .S_AXI_ARADDR           (S_AXI_GPIO1_ARADDR             ),
    .S_AXI_ARPROT           (S_AXI_GPIO1_ARPROT             ),
    .S_AXI_ARVALID          (S_AXI_GPIO1_ARVALID            ),
    .S_AXI_ARREADY          (S_AXI_GPIO1_ARREADY            ),
    .S_AXI_RDATA            (S_AXI_GPIO1_RDATA              ),
    .S_AXI_RRESP            (S_AXI_GPIO1_RRESP              ),
    .S_AXI_RVALID           (S_AXI_GPIO1_RVALID             ),
    .S_AXI_RREADY           (S_AXI_GPIO1_RREADY             )
);


endmodule

