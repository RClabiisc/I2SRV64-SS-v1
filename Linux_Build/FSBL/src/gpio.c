#include "gpio.h"

void gpio_init(void)
{
    writeUIO_w(GPIO0_DIR, 0x00);
    writeUIO_w(GPIO0_DIR2, 0xFF);
}

void led_write(uint32_t pattern)
{
    writeUIO_w(GPIO0_DATA, pattern & 0xFF);
}

unsigned int dipsw_read(void)
{
    return readIO_w(GPIO0_DATA2);
}

