#include "soc.h"
#include "gpio.h"
#include "uart.h"
#include "xmodem.h"
#include "encoding.h"

void delay(unsigned int ms);
extern const char logo[];
void __attribute__ ((noreturn)) fw_jump(unsigned long int);

#define SYNC __asm("fence.i")

#define DRAM_COPY_SIZE	0xD00000

static inline void print_logo(void)
{
    uart_write('\n');
    uart_string(logo);
    uart_string("\n\n");
}


int xmodem_loader(unsigned char *base_addr, unsigned int size)
{
    int image_size;

    //Display Logo
    print_logo();

    //display welcome screen
    uart_string("Welcome to OoO RISC-V UART XModem Bootloader...!!\n");

    //ask for file transfer through XMODEM
    led_write(0xA0);
    uart_string("Image will be loaded to address : ");
    uart_printhex64((uint64_t) base_addr);
    uart_string("\nPlease Transfer Binary Image using XMODEM..\n");
    image_size = xmodemReceive(base_addr,size);
    delay(1000);

    if(image_size > 0) {
        uart_string("\nReceived Image of size : ");
        uart_printhex32(image_size);
        uart_string("\nJumping to target address : ");
        uart_printhex64((unsigned long int) base_addr);
        uart_write('\n');
        return 0;
    }
    else {
        uart_string("\nError in receiving File. Please try again by resetting device\n");
        return 1;
    }
}

void main(int bootmode)
{
    uint32_t dip;
    uintptr_t target;
 
    volatile unsigned long int *src  = FLASH_BASE;
    volatile unsigned long int *dest = SRAM_BASE;
    volatile unsigned long int *end  = SRAM_BASE+SRAM_SIZE;

    //Inits
    gpio_init();
    led_write(0);
    


		print_logo();
		uart_string("Welcome to RCLAB OoO Processor Linux Boot\n\n");

		uart_string("FSBL file Copying from FLASH to SRAM.....\n");
		
		while(dest < end)
		{
			*dest =*src;
			src++;
			dest++;
		}
		asm volatile (" li a0, 0x10000000 ");
		asm volatile (" fence.i ");
		asm volatile ("jr a0 ");
			
    

    while(1);
}

