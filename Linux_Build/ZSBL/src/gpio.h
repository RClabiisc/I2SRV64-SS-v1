#ifndef __GPIO_H__
#define __GPIO_H__

#include <stdint.h>
#include "soc.h"


/*********************
*  AXI GPIO Macros  *
*********************/
//GPIO Registers
#define GPIO0_DATA                      ((volatile void *)(GPIO0_BASE+0x0))
#define GPIO0_DIR                       ((volatile void *)(GPIO0_BASE+0x4))
#define GPIO0_DATA2                     ((volatile void *)(GPIO0_BASE+0x8))
#define GPIO0_DIR2                      ((volatile void *)(GPIO0_BASE+0xc))


/***************************
*  Function Declarations  *
***************************/
void gpio_init(void);
void led_write(uint32_t pattern);
unsigned int dipsw_read(void);

#endif

