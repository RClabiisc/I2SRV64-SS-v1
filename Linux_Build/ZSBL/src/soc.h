#ifndef __SOC_H__
#define __SOC_H__

#include "encoding.h"
#ifndef __ASSEMBLER__
#include <stdint.h>
#include "util.h"
#endif

/********************
*  SoC Memory Map  *
********************/
#define CORECFG_BASE                                0x00001000ULL
#define BOOTROM_BASE                                0x00010000ULL
#define CLINT_BASE                                  0x02000000ULL
#define PLIC_BASE                                   0x0C000000ULL
#define SRAM_BASE                                   0x10000000ULL
#define UART_BASE                                   0x20000000ULL
#define GPIO0_BASE                                  0x20010000ULL
#define I2C_BASE                                    0x20020000ULL
#define TIMER_BASE                                  0x20030000ULL
#define SPI_BASE                                    0x20040000ULL
#define GPIO1_BASE                                  0x20050000ULL
#define FLASH_BASE                                  0x40000000ULL
#define DRAM_BASE                                   0x80000000ULL

//CoreCFG Defines
#define CORECFG_BOOTMODE                            CORECFG_BASE

//BOOTRAM Defines
#define BOOTROM_SIZE                                0x4000  //16KiB
#define BOOTROM_END                                 (BOOTROM_BASE+BOOTROM_SIZE)

//SRAM Defines
#define SRAM_SIZE                                   0x10000 //64KiB
#define SRAM_END                                    (SRAM_BASE+SRAM_SIZE)

//Flash Defines
#define FLASH_SIZE                                  0x8000000
#define FLASH_END                                   (FLASH_BASE+FLASH_SIZE)

//DRAM Defines
#define DRAM_SIZE                                   (1024*1024*1024) //1 GiB
#define DRAM_END                                    DRAM_BASE+DRAM_SIZE

/****************
*  Boot Modes  *
****************/
#define BOOTMODE_INFO                               0
#define BOOTMODE_SRAM                               2
#define BOOTMODE_FLASH                              3
#define BOOTMODE_UART_SRAM                          4
#define BOOTMODE_UART_FLASH                         5
#define BOOTMODE_UART_DRAM                          6
#define BOOTMODE_LINUX			            7

/**********
*  IRQs  *
**********/
//Global IRQ Mapping
#define SOC_GLOBAL_IRQS                             6
#define SOC_PLIC_PRIORITY_LEVELS                    32

#define IRQ_UART                                    1
#define IRQ_GPIO0                                   2
#define IRQ_I2C                                     3
#define IRQ_TIMER                                   4
#define IRQ_SPI                                     5
#define IRQ_GPIO1                                   6

#define SOC_IRQ_CONTEXT_CORE0_M                     0
#define SOC_IRQ_CONTEXT_CORE0_S                     1


/*****************
*  Peripherals  *
*****************/
//Push Buttons Mapping
#define PUSHSW_GPIO_BASE                            GPIO1_BASE
#define PUSHSW_N_BIT                                4
#define PUSHSW_S_BIT                                2
#define PUSHSW_E_BIT                                3
#define PUSHSW_W_BIT                                1
#define PUSHSW_C_BIT                                0

//LED Mapping
#define LED_GPIO_BASE                               GPIO0_BASE

//DIP Switches Mapping
#define DIPSW_GPIO_BASE                             GPIO0_BASE

//LCD Mapping
#define LCD_GPIO_BASE                               GPIO1_BASE
#define LCD_RS_PIN                                  5
#define LCD_RW_PIN                                  4
#define LCD_EN_PIN                                  6


#endif

