#ifndef __UART_H__
#define __UART_H__

#include <stdint.h>
#include "soc.h"

/*************************
*  AXI Uartlite Macros  *
*************************/
//UART Register Defines
#define UART_RXD                        ((volatile void *)(UART_BASE+0x0))
#define UART_TXD                        ((volatile void *)(UART_BASE+0x4))
#define UART_STAT                       ((volatile void *)(UART_BASE+0x8))
#define UART_CTRL                       ((volatile void *)(UART_BASE+0xC))

//UART Register field/Masks
#define UART_CTRL_INTR_ENABLE           0x00000010
#define UART_CTRL_INTR_DISABLE          0xffffffef
#define UART_CTRL_TXFIFO_RESET          0x00000002
#define UART_CTRL_RXFIFO_RESET          0x00000001

#define UART_STAT_RX_VALID              0x00000001
#define UART_STAT_RX_FULL               0x00000002
#define UART_STAT_TX_EMPTY              0x00000004
#define UART_STAT_TX_FULL               0x00000008
#define UART_STAT_INTR_EN               0x00000010
#define UART_STAT_OVERRUN_ERR           0x00000020
#define UART_STAT_FRAME_ERR             0x00000040
#define UART_STAT_PARITY_ERR            0x00000080


/***************************
*  Function Declarations  *
***************************/
int uart_read(unsigned int);
void uart_write(unsigned int);
void uart_string(const char *);
void uart_printhex32(unsigned int);
void uart_printhex64(unsigned long int);

#endif
