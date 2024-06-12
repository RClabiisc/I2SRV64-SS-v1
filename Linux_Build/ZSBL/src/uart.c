#include "uart.h"
#include "encoding.h"
#include "soc.h"


inline int uart_read(unsigned int timeout)
{
    unsigned long int end = rdtime() + timeout*1000;
    uint32_t status;
    do
    {
        status = readIO_w(UART_STAT);
        if(rdtime() > end)
            return -1;
    }
    while(!(status & UART_STAT_RX_VALID));
    return readIO_w(UART_RXD);
}

inline void uart_write(unsigned int ch)
{
    uint32_t status;
    do
    {
        status = readIO_w(UART_STAT);
    }
    while(status & UART_STAT_TX_FULL);
    writeIO_w(UART_TXD,ch);
}

void uart_string(const char *str)
{
     while(*str!='\0')
	{
	   if(*str=='\n')
	      {
 		uart_write('\n');
                uart_write('\r');
                str++;
	      }
	   else	
	      {	
	        uart_write(*str++);
	      }
	}
}

void uart_printhex32(unsigned int x)
{
    char str[9];
    int i;
    for (i = 0; i < 8; i++)
    {
        str[7-i] = (x & 0xF) + ((x & 0xF) < 10 ? '0' : 'a'-10);
        x >>= 4;
    }
    str[8] = 0;
    uart_string(str);
}

void uart_printhex64(unsigned long int x)
{
    char str[17];
    int i;
    for (i = 0; i < 16; i++)
    {
        str[15-i] = (x & 0xF) + ((x & 0xF) < 10 ? '0' : 'a'-10);
        x >>= 4;
    }
    str[16] = 0;
    uart_string(str);
}

