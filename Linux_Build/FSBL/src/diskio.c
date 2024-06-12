
#include "diskio.h"
#include "spi.h"
#include "myprintf.h"
/*--------------------------------------------------------------------------

  Module Private Functions

  ---------------------------------------------------------------------------*/

/* Definitions for MMC/SDC command */
#define CMD0    (0)         /* GO_IDLE_STATE */
#define CMD1    (1)         /* SEND_OP_COND (MMC) */
#define ACMD41  (0x80+41)   /* SEND_OP_COND (SDC) */
#define CMD8    (8)         /* SEND_IF_COND */
#define CMD9    (9)         /* SEND_CSD */
#define CMD10   (10)        /* SEND_CID */
#define CMD12   (12)        /* STOP_TRANSMISSION */
#define ACMD13  (0x80+13)   /* SD_STATUS (SDC) */
#define CMD16   (16)        /* SET_BLOCKLEN */
#define CMD17   (17)        /* READ_SINGLE_BLOCK */
#define CMD18   (18)        /* READ_MULTIPLE_BLOCK */
#define CMD23   (23)        /* SET_BLOCK_COUNT (MMC) */
#define ACMD23  (0x80+23)   /* SET_WR_BLK_ERASE_COUNT (SDC) */
#define CMD24   (24)        /* WRITE_BLOCK */
#define CMD25   (25)        /* WRITE_MULTIPLE_BLOCK */
#define CMD32   (32)        /* ERASE_ER_BLK_START */
#define CMD33   (33)        /* ERASE_ER_BLK_END */
#define CMD38   (38)        /* ERASE */
#define CMD55   (55)        /* APP_CMD */
#define CMD58   (58)        /* READ_OCR */


static volatile
DSTATUS Stat = STA_NOINIT;  /* Disk status */

static
uint8_t CardType;          /* Card type flags */


/*-----------------------------------------------------------------------*/
/* Power Control  (Platform dependent)                                   */
/*-----------------------------------------------------------------------*/
/* When the target system does not support socket power control, there   */
/* is nothing to do in these functions and chk_power always returns 1.   */

static
void power_on (void)
{
  uint32_t timeout = 100*1000;
  spi_init();
  while(timeout--);
}

static
void power_off (void)
{
  spi_disable();
}



/*-----------------------------------------------------------------------*/
/* Transmit/Receive data from/to MMC via SPI  (Platform dependent)       */
/*-----------------------------------------------------------------------*/

/* Exchange a byte */
static
uint8_t xchg_spi (                /* Returns received data */
                  uint8_t dat     /* Data to be sent */
                                  )
{
  return spi_send(dat);
}

/* Send a data block fast */
static
void xmit_spi_multi (
                     const uint8_t *p,  /* Data block to be sent */
                     uint32_t cnt       /* Size of data block (must be multiple of 2) */
                     )
{
  int i = 0;
  for(i=0; i<cnt; i=i+SPI_buffer_size) {
    if(cnt >= i+SPI_buffer_size)
      spi_send_multi(p+i, SPI_buffer_size);
    else
      spi_send_multi(p+i, cnt-i);
  }
}

/* Receive a data block fast */
static
void rcvr_spi_multi (
                     uint8_t *p,    /* Data buffer */
                     uint32_t cnt   /* Size of data block (must be multiple of 2) */
                     )
{
  int i = 0;
  for(i=0; i<cnt; i=i+SPI_buffer_size) {
    if(cnt >= i+SPI_buffer_size)
      spi_recv_multi(p+i, SPI_buffer_size);
    else
      spi_recv_multi(p+i, cnt-i);
  }
}

/*-----------------------------------------------------------------------*/
/* Wait for card ready                                                   */
/*-----------------------------------------------------------------------*/

static
int wait_ready (                /* 1:Ready, 0:Timeout */
                uint32_t wt     /* Timeout [ms] */
                                )
{
  uint8_t d;
  uint32_t timeout = wt*5000;

  do {
    d = xchg_spi(0xFF);

    timeout--;
  } while (d != 0xFF && timeout);
  return (d == 0xFF) ? 1 : 0;
}



/*-----------------------------------------------------------------------*/
/* Deselect the card and release SPI bus                                 */
/*-----------------------------------------------------------------------*/

static
void deselect (void)
{
  spi_deselect_slave(0);
}

/*-----------------------------------------------------------------------*/
/* Select the card and wait for ready                                    */
/*-----------------------------------------------------------------------*/

static
int select (void)   /* 1:Successful, 0:Timeout */
{
 // spi_select_slave(0);
  if (wait_ready(500))
  { 
  //printf("wait_ready Successful \n\r", 0);
    return 1;
  }  /* Wait for card ready */

   // printf("wait_ready Timeout \n\r", 0);
  deselect();
  return 0;   /* Timeout */
}

/*-----------------------------------------------------------------------*/
/* Receive a data packet from MMC                                        */
/*-----------------------------------------------------------------------*/

static
int rcvr_datablock (
                    uint8_t *buff,         /* Data buffer to store received data */
                    uint32_t btr            /* Byte count (must be multiple of 4) */
                    )
{
  uint8_t token;

  uint32_t timeout=200*5000;
  do {                            /* Wait for data packet in timeout of 200ms */
    token = xchg_spi(0xFF);
  //  printf("searching for DATA token %d \n\r", token);
    timeout--;
  } while ((token == 0xFF) && timeout);
  if (token != 0xFE) return 0;    /* If not valid data token, retutn with error */
 // printf("DATA TOKEN FOUND \n\r", 0);
  rcvr_spi_multi(buff, btr);      /* Receive the data block into buffer */
  xchg_spi(0xFF);                 /* Discard CRC */
  xchg_spi(0xFF);
 //  printf("DATA block read success \n\r", 0);
  return 1;                       /* Return with success */
}


/*-----------------------------------------------------------------------*/
/* Send a command packet to MMC                                          */
/*-----------------------------------------------------------------------*/

static
uint8_t send_cmd (     /* Returns R1 resp (bit7==1:Send failed) */
                  uint8_t cmd,       /* Command index */
                  uint32_t arg       /* Argument */
                       )
{
  uint8_t n, res;
  uint32_t timeout = 100*1000;

  if (cmd & 0x80) {   /* ACMD<n> is the command sequense of CMD55-CMD<n> */
    cmd &= 0x7F;
    res = send_cmd(CMD55, 0);
    if (res > 1) return res;
  }

  // enforce a wait between CMD55 and CMD41
  if(cmd == ACMD41 & 0x7F)
    while(timeout--);

  /* Select the card and wait for ready except to stop multiple block read */
  if (cmd != CMD12) {
    deselect();
    if (!select()){ 
   // printf("Card not selected ... \n\r", 0);
     return 0xFF;}
  }

  /* Send command packet */
    // printf("    - cmd %d is sending ... ", cmd);
  // printf("Argument is %d ... ", arg );
  xchg_spi(0x40 | cmd);               /* Start + Command index */
  xchg_spi((uint8_t)(arg >> 24));     /* Argument[31..24] */
  xchg_spi((uint8_t)(arg >> 16));     /* Argument[23..16] */
  xchg_spi((uint8_t)(arg >> 8));      /* Argument[15..8] */
  xchg_spi((uint8_t)arg);             /* Argument[7..0] */
  n = 0x01;                           /* Dummy CRC + Stop */
  if (cmd == CMD0) n = 0x95;          /* Valid CRC for CMD0(0) + Stop */
  if (cmd == CMD8) n = 0x87;          /* Valid CRC for CMD8(0x1AA) Stop */
  xchg_spi(n);

  /* Receive command response */
  if (cmd == CMD12) xchg_spi(0xFF);   /* Skip a stuff byte when stop reading */
  n = 10;                             /* Wait for a valid response in timeout of 10 attempts */
  do
    res = xchg_spi(0xFF);
  while ((res & 0x80) && --n);
  
 
  // printf("Finished, res is : %d \n\r", res);

  return res;         /* Return with the response value */
}




/*-----------------------------------------------------------------------*/
/* Initialize Disk Drive                                                 */
/*-----------------------------------------------------------------------*/

DSTATUS disk_initialize (
                         uint8_t pdrv       /* Physical drive nmuber (0) */
                         )
{
  uint8_t n, cmd, ty, ocr[4];
  uint32_t timeout;
  uint32_t acmd_delay = 100*1000;
  
 //  printf("[DISK_INIT]disk init starts ... \n\r", 0);

  if (pdrv) return STA_NOINIT;        /* Supports only single drive */
  //power_off();                        /* Turn off the socket power to reset the card */
 // printf("power off done ... \n\r", 0);
  //if (Stat & STA_NODISK) return Stat; /* No card in the socket */
  
//  printf("power on call ... \n\r", 0);
  power_on();                         /* Turn on the socket power */
//  printf("power on done ... \n\r", 0);
  for (n = 10; n; n--) xchg_spi(0xFF); /* 80 dummy clocks */

 // printf("dummy for 80 cycle sent done ... \n\r", 0);
  ty = 0;
  if (send_cmd(CMD0, 0) == 1) {      /* Enter Idle state */
    timeout = 1000*1000;             /* Initialization timeout of 1000 msec */
    
 //   printf("CMD0 success\n\r", 0);
    
    if (timeout-- && send_cmd(CMD8, 0x1AA) == 1) {   /* SDv2? */
      for (n = 0; n < 4; n++) ocr[n] = xchg_spi(0xFF);  /* Get trailing return value of R7 resp */
      if (ocr[2] == 0x01 && ocr[3] == 0xAA) {           /* The card can work at vdd range of 2.7-3.6V */
        while (timeout-- && send_cmd(ACMD41, 1UL << 30)) { /* Wait for leaving idle state (ACMD41 with HCS bit) */
          while(acmd_delay--);
          acmd_delay = 100*1000;
        }
        if (timeout-- && send_cmd(CMD58, 0) == 0) {     /* Check CCS bit in the OCR */
          for (n = 0; n < 4; n++) ocr[n] = xchg_spi(0xFF);
          ty = (ocr[0] & 0x40) ? CT_SD2 | CT_BLOCK : CT_SD2; /* SDv2 */
        }
      }
    } else {                        /* SDv1 or MMCv3 */
      if (timeout-- && send_cmd(ACMD41, 0) <= 1)   {
        ty = CT_SD1; cmd = ACMD41;  /* SDv1 */
      } else {
        ty = CT_MMC; cmd = CMD1;    /* MMCv3 */
      }
      while (timeout-- && send_cmd(cmd, 0));      /* Wait for leaving idle state */
      if (timeout-- || send_cmd(CMD16, 512) != 0)   /* Set R/W block length to 512 */
        ty = 0;
    }
  }
  CardType = ty;
  deselect();

  if (ty) {              /* Initialization succeded */
    Stat &= ~STA_NOINIT; /* Clear STA_NOINIT */

   //  printf("[DISK_INIT]disk init successes!\n\r", 0);

  } else {               /* Initialization failed */
     printf("[DISK_INIT]disk init failed ...\n\r", 0);
  }

  return Stat;
}



/*-----------------------------------------------------------------------*/
/* Get Disk Status                                                       */
/*-----------------------------------------------------------------------*/

DSTATUS disk_status (
                     uint8_t pdrv       /* Physical drive nmuber (0) */
                     )
{
  if (pdrv) return STA_NOINIT;    /* Supports only single drive */
  return Stat;
}



/*-----------------------------------------------------------------------*/
/* Read Sector(s)                                                        */
/*-----------------------------------------------------------------------*/

DRESULT disk_read (
                   uint8_t pdrv,          /* Physical drive nmuber (0) */
                   uint8_t *buff,         /* Pointer to the data buffer to store read data */
                   uint32_t sector,       /* Start sector number (LBA) */
                   uint32_t count          /* Sector count (1..128) */
                   )
{
  uint8_t cmd;


  if (pdrv || !count) return RES_PARERR;
  if (Stat & STA_NOINIT) return RES_NOTRDY;

  if (!(CardType & CT_BLOCK)) sector *= 512;  /* Convert to byte address if needed */
 
  // printf("[DISK_READ]reading starts at sector %d \n\r", sector);
  // printf("[DISK_READ]totally %d sectors to be read\n\r", count);

  cmd = count > 1 ? CMD18 : CMD17;            /*  READ_MULTIPLE_BLOCK : READ_SINGLE_BLOCK */
  if (send_cmd(cmd, sector) == 0) {
    do {
      if (!rcvr_datablock(buff, 512)) break;
      buff += 512;
       //  printf("    - %d sectors left to be read\n\r", count-1);

    } while (--count);
    if (cmd == CMD18) send_cmd(CMD12, 0);   /* STOP_TRANSMISSION */
  }
  deselect();
   

  return count ? RES_ERROR : RES_OK;
}







