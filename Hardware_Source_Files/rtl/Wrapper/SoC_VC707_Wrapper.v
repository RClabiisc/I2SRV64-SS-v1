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

module SoC_VC707_Wrapper
(
    //on-board system differential clock (200 MHz)
    input  wire             clk_p,
    input  wire             clk_n,

    //on-board Reset Button
    input  wire             reset,

    //on-board UART
    input  wire             rs232_uart_rxd,
    output wire             rs232_uart_txd,

    //on-board I2C
    inout  wire             i2c_sda,
    inout  wire             i2c_scl,

    //On-Board LEDs
    output wire [7:0]       led_io,

    //on-board Push Buttons
    input  wire [4:0]       push_button_io,

    //On-Board DIP Switches
    input  wire [7:0]       dip_sw_io,

    //On-Board LCD Interface
    output wire [6:0]       lcd_io,

    //On-Board SDCard Interface (using SPI)
    output wire             sdio_clk,
    output wire             sdio_cd_dat3,
    input  wire             sdio_dat0,
    output wire             sdio_cmd,

    //On-Board BPI Flash Interface
    inout  wire [15:0]      linear_flash_dq_io,
    output wire [25:0]      linear_flash_addr,
    output wire             linear_flash_ce_n,
    output wire             linear_flash_oen,
    output wire             linear_flash_wen,
    output wire             linear_flash_adv_ldn,

    //On-Board FAN Interface
    output wire             fan_pwm

    //On-Baord SODIMM DDR3 Interface
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

//Local Wires
wire [3:0]  BOOT_MODE;
wire [7:0]  gpio0_A_o,  gpio0_B_i,  gpio1_A_o, gpio1_B_i;
wire        i2c_sda_i,  i2c_sda_t,  i2c_sda_o;
wire        i2c_scl_i,  i2c_scl_t,  i2c_scl_o;
wire        spi_mosi_o, spi_miso_i, spi_sck_o, spi_ss_o;
wire [15:0] linear_flash_dq_i, linear_flash_dq_o, linear_flash_dq_t;
wire        timer_pwm;

//Instantiate SoC
SoC SoC
(
    .clk_p                  (clk_p                      ),   //SoC Clock Mapped to On-Board System Diff Clock
    .clk_n                  (clk_n                      ),

    .reset                  (reset                      ),   //reset mapped to CPU_RESET Push Button

    .BOOT_MODE              (BOOT_MODE                  ),   //BOOT_MODE Mapped to DIP Switches[3:0]

    .rs232_uart_rxd         (rs232_uart_rxd             ),   //UART mapped to On-Board USB-to-Serial Uart
    .rs232_uart_txd         (rs232_uart_txd             ),

    .i2c_sda_i              (i2c_sda_i                  ),
    .i2c_scl_i              (i2c_scl_i                  ),
    .i2c_sda_t              (i2c_sda_t                  ),
    .i2c_scl_t              (i2c_scl_t                  ),
    .i2c_sda_o              (i2c_sda_o                  ),
    .i2c_scl_o              (i2c_scl_o                  ),

    .gpio0_A_o              (gpio0_A_o                  ),
    .gpio0_B_i              (gpio0_B_i                  ),
    .gpio1_A_o              (gpio1_A_o                  ),
    .gpio1_B_i              (gpio1_B_i                  ),

    .timer_capture0         (1'b0                       ),   //Not Mapped Yet (input driven as zero)
    .timer_capture1         (1'b0                       ),   //Not Mapped Yet (input driven as zero)
    .timer_out0             (                           ),   //Not Mapped (unconnected)
    .timer_out1             (                           ),   //Not Mapped (unconnected)
    .timer_pwm0             (timer_pwm                  ),   //Mapped to Fan PWM

    .spi_mosi_o             (spi_mosi_o                 ),
    .spi_miso_i             (spi_miso_i                 ),
    .spi_sck_o              (spi_sck_o                  ),
    .spi_ss_o               (spi_ss_o                   )

`ifdef SOC_ENABLE_FLASH
    ,
    .linear_flash_dq_i      (linear_flash_dq_i          ),
    .linear_flash_dq_o      (linear_flash_dq_o          ),
    .linear_flash_dq_t      (linear_flash_dq_t          ),
    .linear_flash_addr      (linear_flash_addr          ),
    .linear_flash_ce_n      (linear_flash_ce_n          ),
    .linear_flash_oen       (linear_flash_oen           ),
    .linear_flash_wen       (linear_flash_wen           ),
    .linear_flash_adv_ldn   (linear_flash_adv_ldn       )
`endif

`ifdef SOC_ENABLE_DRAM
    ,
    .ddr3_addr              (ddr3_addr                  ),
    .ddr3_ba                (ddr3_ba                    ),
    .ddr3_cas_n             (ddr3_cas_n                 ),
    .ddr3_ck_n              (ddr3_ck_n                  ),
    .ddr3_ck_p              (ddr3_ck_p                  ),
    .ddr3_cke               (ddr3_cke                   ),
    .ddr3_ras_n             (ddr3_ras_n                 ),
    .ddr3_reset_n           (ddr3_reset_n               ),
    .ddr3_we_n              (ddr3_we_n                  ),
    .ddr3_dq                (ddr3_dq                    ),
    .ddr3_dqs_n             (ddr3_dqs_n                 ),
    .ddr3_dqs_p             (ddr3_dqs_p                 ),
    .ddr3_cs_n              (ddr3_cs_n                  ),
    .ddr3_dm                (ddr3_dm                    ),
    .ddr3_odt               (ddr3_odt                   )
`endif
);


/********************
*  BOOT MODE Map   *
********************/
//BOOT_MODE can be set by DIP Switches [3:0]
//NOTE: BOOT_MODE is captured at reset only
assign BOOT_MODE = {dip_sw_io[3], dip_sw_io[2], dip_sw_io[1], dip_sw_io[0]};


/********************
*  I2C IO Mapping  *
********************/
IOBUF i2c_scl_iobuf (.I (i2c_scl_o), .IO(i2c_scl), .O (i2c_scl_i), .T (i2c_scl_t));
IOBUF i2c_sda_iobuf (.I (i2c_sda_o), .IO(i2c_sda), .O (i2c_sda_i), .T (i2c_sda_t));


/*******************
*  GPIO Mapping  *
*******************/
//GPIO0 Port A Output [7:0] : LED[7:0]
assign led_io[0]    = gpio0_A_o[ 0];
assign led_io[1]    = gpio0_A_o[ 1];
assign led_io[2]    = gpio0_A_o[ 2];
assign led_io[3]    = gpio0_A_o[ 3];
assign led_io[4]    = gpio0_A_o[ 4];
assign led_io[5]    = gpio0_A_o[ 5];
assign led_io[6]    = gpio0_A_o[ 6];
assign led_io[7]    = gpio0_A_o[ 7];

//GPIO0 Port B Input [7:0] : DIP Switches [7:0]
assign gpio0_B_i[0] = dip_sw_io[0];
assign gpio0_B_i[1] = dip_sw_io[1];
assign gpio0_B_i[2] = dip_sw_io[2];
assign gpio0_B_i[3] = dip_sw_io[3];
assign gpio0_B_i[4] = dip_sw_io[4];
assign gpio0_B_i[5] = dip_sw_io[5];
assign gpio0_B_i[6] = dip_sw_io[6];
assign gpio0_B_i[7] = dip_sw_io[7];

//GPIO1 Port A Output [6:0] : LCD [6:0]
assign lcd_io[6]    = gpio1_A_o[0]; //D4
assign lcd_io[5]    = gpio1_A_o[1]; //D5
assign lcd_io[4]    = gpio1_A_o[2]; //D6
assign lcd_io[3]    = gpio1_A_o[3]; //D7
assign lcd_io[2]    = gpio1_A_o[4]; //RW
assign lcd_io[1]    = gpio1_A_o[5]; //RS
assign lcd_io[0]    = gpio1_A_o[6]; //EN

//GPIO1 Port B Input [4:0] : Push Buttons [4:0]
//0=C 1=W 2=S 3=E 4=N
assign gpio1_B_i[0] = push_button_io[0];  //C
assign gpio1_B_i[1] = push_button_io[1];  //W
assign gpio1_B_i[2] = push_button_io[2];  //S
assign gpio1_B_i[3] = push_button_io[3];  //E
assign gpio1_B_i[4] = push_button_io[4];  //N

//Unconnected
assign gpio1_B_i[5] = 1'b0;
assign gpio1_B_i[6] = 1'b0;
assign gpio1_B_i[7] = 1'b0;


/****************************
*  SD Card Mapping to SPI  *
****************************/
assign sdio_clk     = spi_sck_o;
assign sdio_cmd     = spi_mosi_o;
assign sdio_cd_dat3 = spi_ss_o;
assign spi_miso_i   = sdio_dat0;


/***********************
*  BPI Flash Mapping  *
***********************/
`ifdef SOC_ENABLE_FLASH
    genvar f;
    generate
        for(f=0; f<16; f=f+1) begin:flash_dq
            IOBUF iobuf (.I (linear_flash_dq_o[f]), .IO(linear_flash_dq_io[f]), .O (linear_flash_dq_i[f]), .T (linear_flash_dq_t[f]));
        end
    endgenerate
`else
    assign linear_flash_addr    = 0;
    assign linear_flash_ce_n    = 1'b1;
    assign linear_flash_oen     = 1'b1;
    assign linear_flash_wen     = 1'b1;
    assign linear_flash_adv_ldn = 1'b1;
`endif


/********************
*  Fan PWM Mapping  *
********************/
`ifdef SOC_ENABLE_FANCTRL
    assign fan_pwm = timer_pwm;
`else
    assign fan_pwm = 1'b1;
`endif


endmodule

