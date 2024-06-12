#include "soc.h"
#include "gpio.h"
#include "uart.h"
#include "xmodem.h"
#include "encoding.h"
#include "myprintf.h"
#include "diskio.h"
#include "ff.h"
#include "spi.h"


void delay(unsigned int ms);
int scanf_terminal(char *);
extern const char logo[];
void __attribute__ ((noreturn)) fw_jump(unsigned long int);

#define SYNC __asm("fence.i")

#define DRAM_COPY_SIZE	0xD00000

FATFS FatFs; 



#define DDR_SIZE 0x40000000

// 4K size read burst
#define SD_READ_SIZE 4096



void info(void)
{
    unsigned long ticks;
    int ch;
    unsigned char pattern = 0;


    //display Boot modes
    uart_string("Available Boot Modes : \n");
    uart_string("\t0000 : Info Mode (Current Mode)\n");
    uart_string("\t0010 : Boot from SD card\n");
    uart_string("\t0101 : xmodem loader for Flash\n");
    uart_string("\t0110 : xmodem loader for DRAM\n");
    uart_string("\t0111 : Boot from board Flash \n");
    uart_string("\nPlease set DIP switches to select appropriate mode during reset..\n");

    //enter test mode
    uart_string("\nEntering Test Mode now..\n");
    ticks = rdtime();
    while(1) {
        if((ch = uart_read(100)) > 0)
            uart_write(ch);

        if(rdtime() > ticks+1000) {
            if(++pattern == 8)
                pattern = 0;
            led_write(1<<pattern);
            ticks = rdtime();
        }
    }
}

void sd_copy(char *file_name)
{
                  FIL fil; 
                FRESULT fr;
                uint8_t *boot_file_buf = (uint8_t *)(DRAM_BASE); 


               printf("=============== FSBL ===============\n\r", 0);

  
               if(f_mount(&FatFs, "", 1)) {
                  printf("Fail to mount SD driver!\n\r", 0);
                  return ;
                  }

                printf("Loading file into memory...\n\r", 0);
                fr = f_open(&fil, file_name, FA_READ);
                if (fr) {
                printf("Failed to open file!\n\r", 0);
                 return ;
                 }
  
                 printf("Reading binary file...\n\r", 0);

                uint8_t *buf = boot_file_buf;
                uint32_t fsize = 0;          
                 uint32_t br;                  
                do {
               fr = f_read(&fil, buf, SD_READ_SIZE, &br);  // Read a chunk of source file
                buf += br;
                fsize += br;
               if(fsize%(1024*1024)==0)
               {
                printf("Till now %d MB data read done\n\r", (fsize/(1024*1024)));
               }
               } while(!(fr || br == 0));

               printf("Load %d bytes to memory address ", fsize);
               printf("%h from file \n\r", (uint64_t)boot_file_buf);
               spi_disable();     
}

int xmodem_loader(unsigned char *base_addr, unsigned int size)
{
    int image_size;



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
/*
int scanf_terminal(char *p)
{
   int count=0;
   int input;
    while(1)
    {
       input =xlnx_uartlite_getc();
        if(input!=-1 && input!=10){
           p[count]=(char)input;
             count++;
             uart_write((char)input);
               }
         else if(input==10){
                 p[count]='\0';
                 uart_write((char)input);
                 return 1;
                 }
         
             
         }

    return 0;
    
}
*/
void main(int bootmode)
{
    uint32_t dip;
    uintptr_t target;
     char terminal_input[100]="boot.bin";
 
    volatile unsigned long int *src  = FLASH_BASE;
    volatile unsigned long int *dest = DRAM_BASE;
    volatile unsigned long int *end  = DRAM_BASE+DRAM_COPY_SIZE;

    //Inits
    gpio_init();
    led_write(0);
    

    switch(bootmode) {
        case BOOTMODE_INFO: //Info Mode
            info();
            break;
            
         case BOOTMODE_SD:
		
		uart_string("Welcome to RCLAB OoO Processor Linux Boot\n\n");

		uart_string("Linux Image Copying from SD Card to DRAM.....\n");
		uart_string("Enter binary file name:: ");
		//scanf_terminal(terminal_input);
		uart_string("\n");
		
		
		
		sd_copy(terminal_input);
		
               printf("=========== Jump to DDR ============\n\r", 0);

		asm volatile (" li a0, 0x80000000 ");
		asm volatile (" fence.i ");
		asm volatile ("jr a0 ");
				
		break;


        case BOOTMODE_UART_FLASH: //Boot XMODEM to Flash
            dip = (dipsw_read() & 0x000000f0)>>4;
            target = FLASH_BASE + dip*(FLASH_BASE/16);

            //Enable writing to Flash by disabling PMA Checks
            clear_csr(0xBC1,0x4);
            if(!xmodem_loader((unsigned char *) target, FLASH_SIZE)) {
                delay(1000);
                led_write(0);
                //Enable PMA checks before jumping
                set_csr(0xBC1,0x4);
                SYNC;
                fw_jump(target);
            }
            else {
                led_write(0xf0);
                set_csr(0xBC1,0x4);
            }
            break;

        case BOOTMODE_UART_DRAM: //Boot XMODEM to DRAM
            if(!xmodem_loader((unsigned char *) DRAM_BASE, DRAM_SIZE)) {
                delay(1000);
                led_write(0);
                SYNC;
                fw_jump(DRAM_BASE);
            }
            else
                led_write(0xf0);
            break;
            
        case BOOTMODE_LINUX:
		
		uart_string("Welcome to RCLAB OoO Processor Linux Boot\n\n");

		uart_string("Linux Image Copying from FLASH to DRAM.....\n");
		
		while(dest < end)
		{
			*dest =*src;
			src++;
			dest++;
		}
		asm volatile (" li a0, 0x80000000 ");
		asm volatile (" fence.i ");
		asm volatile ("jr a0 ");
				
		break;
        default: //Invalid Boot Mode
            info();
            led_write(0xFF);
            uart_string("wrong BOOTMODE selected\n");
    }

    while(1);
}

