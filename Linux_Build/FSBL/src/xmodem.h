#ifndef __XMODEM_H_
#define __XMODEM_H_

#include <string.h>

// Function prototypes
int xmodemReceive(unsigned char *dest, int destsz);
int xmodemTransmit(unsigned char *src, int srcsz);

#endif

