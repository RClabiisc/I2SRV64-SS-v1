// See LICENSE for license details.

#include "spi.h"
#include "myprintf.h"



volatile uint32_t *spi_base_ptr = (uint32_t *)(SPI_BASE);

void spi_init() {
  uint32_t ControlReg;

  // software reset?
  (*(volatile uint32_t *)(SPI_BASE + SPI_SRR)) = 0xa;



                ControlReg=*(volatile uint32_t *)(SPI_BASE + SPI_CR);
                    uart_string("ControlReg reset   ");
                uart_printhex32(ControlReg);
               uart_string("\n");
		ControlReg |= XSP_CR_TXFIFO_RESET_MASK | XSP_CR_RXFIFO_RESET_MASK |
			XSP_CR_ENABLE_MASK |XSP_CR_MANUAL_SS_MASK| XSP_CR_MASTER_MODE_MASK;
		ControlReg &= ~XSP_CR_TRANS_INHIBIT_MASK;
		
	       
		
		  (*(volatile uint32_t *)(SPI_BASE + SPI_CR) = ControlReg);
		  
		   ControlReg=*(volatile uint32_t *)(SPI_BASE + SPI_CR);
                    uart_string("ControlReg final   ");
                uart_printhex32(ControlReg);
               uart_string("\n");

}


void spi_disable() {

  uint32_t ControlReg;
  ControlReg= (*(volatile uint32_t *)(SPI_BASE + SPI_CR));
  ControlReg &=~XSP_CR_ENABLE_MASK;
  (*(volatile uint32_t *)(SPI_BASE + SPI_CR) = ControlReg);
}

uint8_t spi_rx()
{
   uint8_t data;
      
          uint32_t StatusReg = (*(volatile uint32_t *)(SPI_BASE+SPI_SR));
   
             while ((StatusReg & XSP_SR_RX_EMPTY_MASK) == 0){
             
             data= (uint8_t)(*(volatile uint32_t *)(SPI_BASE+SPI_DRR));
             StatusReg = (*(volatile uint32_t *)(SPI_BASE+SPI_SR));
             
             }
            
       spi_deselect_slave(1);
      uint32_t ControlReg;
     ControlReg= (*(volatile uint32_t *)(SPI_BASE + SPI_CR));
     ControlReg=ControlReg | XSP_CR_TRANS_INHIBIT_MASK;
     (*(volatile uint32_t *)(SPI_BASE + SPI_CR))=ControlReg;

	return data;
}


uint8_t spi_send(uint8_t dat) {

     uint32_t ControlReg;
     ControlReg= (*(volatile uint32_t *)(SPI_BASE + SPI_CR));
     ControlReg=ControlReg | XSP_CR_TRANS_INHIBIT_MASK;
     (*(volatile uint32_t *)(SPI_BASE + SPI_CR))=ControlReg;
     
     
     (*(volatile uint32_t *)(SPI_BASE + SPI_DTR)) = dat;
     
     spi_select_slave(0);
     
     ControlReg= (*(volatile uint32_t *)(SPI_BASE + SPI_CR));
     ControlReg &=~XSP_CR_TRANS_INHIBIT_MASK;
     (*(volatile uint32_t *)(SPI_BASE + SPI_CR))=ControlReg;
     
     
     uint32_t StatusReg;
     
     do {
	  StatusReg = (*(volatile uint32_t *)(SPI_BASE+XSP_IISR_OFFSET));
       } while ((StatusReg & XSP_INTR_TX_EMPTY_MASK) == 0);
       
       StatusReg = (*(volatile uint32_t *)(SPI_BASE+XSP_IISR_OFFSET));
       
       (*(volatile uint32_t *)(SPI_BASE+XSP_IISR_OFFSET))=StatusReg | XSP_INTR_TX_EMPTY_MASK;
     
  

    
  return spi_rx();
}





void spi_send_multi(const uint8_t* dat, uint16_t n) {
  uint16_t i;
  for(i=0; i<n; i++){
     (*(volatile uint32_t *)(SPI_BASE + SPI_DTR)) = *(dat++);
     }
     
     uint32_t StatusReg = (*(volatile uint32_t *)(SPI_BASE+SPI_SR));
    while (!(StatusReg & XSP_SR_TX_EMPTY_MASK))
    {
      StatusReg = (*(volatile uint32_t *)(SPI_BASE+SPI_SR));
    }
  
  // reset recv FIFO
  uint32_t ControlReg=*(volatile uint32_t *)(SPI_BASE + SPI_CR);
  ControlReg &=~XSP_CR_RXFIFO_RESET_MASK;
  (*(volatile uint32_t *)(SPI_BASE + SPI_CR) = ControlReg);
}





void spi_recv_multi(uint8_t* dat, uint16_t n) {
  uint16_t i;
  uint16_t tx_count=n;
  uint16_t rx_count=n;
  uint16_t DataLen;
  
      uint32_t ControlReg;
     ControlReg= (*(volatile uint32_t *)(SPI_BASE + SPI_CR));
     ControlReg=ControlReg | XSP_CR_TRANS_INHIBIT_MASK;
     (*(volatile uint32_t *)(SPI_BASE + SPI_CR))=ControlReg;
     
    uint32_t StatusReg = (*(volatile uint32_t *)(SPI_BASE+SPI_SR));
    
    while (((StatusReg & XSP_SR_TX_FULL_MASK) == 0) && tx_count>0) {
    
        (*(volatile uint32_t *)(SPI_BASE + SPI_DTR)) = 0xff;
        
         StatusReg = (*(volatile uint32_t *)(SPI_BASE+SPI_SR));
        tx_count--;
    }
    
      spi_select_slave(0);
     
     ControlReg= (*(volatile uint32_t *)(SPI_BASE + SPI_CR));
     ControlReg &=~XSP_CR_TRANS_INHIBIT_MASK;
     (*(volatile uint32_t *)(SPI_BASE + SPI_CR))=ControlReg;
     

     
     while(rx_count>0){
     
     
     do {
	  StatusReg = (*(volatile uint32_t *)(SPI_BASE+XSP_IISR_OFFSET));
       } while ((StatusReg & XSP_INTR_TX_EMPTY_MASK) == 0);
       StatusReg = (*(volatile uint32_t *)(SPI_BASE+XSP_IISR_OFFSET));
       (*(volatile uint32_t *)(SPI_BASE+XSP_IISR_OFFSET))=StatusReg | XSP_INTR_TX_EMPTY_MASK;
       
       
       
       
             StatusReg = (*(volatile uint32_t *)(SPI_BASE+SPI_SR));
             while ((StatusReg & XSP_SR_RX_EMPTY_MASK) == 0){
             *(dat++)= (uint8_t)(*(volatile uint32_t *)(SPI_BASE+SPI_DRR));
             StatusReg = (*(volatile uint32_t *)(SPI_BASE+SPI_SR));
             rx_count--;
             }
             
        if(tx_count>0)
        {
             		    if (tx_count > SPI_buffer_size) {
					DataLen = SPI_buffer_size;
				} else {
					DataLen =tx_count;
				}
				
		for(i=0;i<DataLen;i++){
		
		(*(volatile uint32_t *)(SPI_BASE + SPI_DTR)) = 0xff;
		  }
		  tx_count=tx_count-DataLen;
        
        }
        
        
        }
             
             
          spi_deselect_slave(1);
          
     ControlReg;
     ControlReg= (*(volatile uint32_t *)(SPI_BASE + SPI_CR));
     ControlReg=ControlReg | XSP_CR_TRANS_INHIBIT_MASK;
     (*(volatile uint32_t *)(SPI_BASE + SPI_CR))=ControlReg;    
}




void spi_select_slave(uint8_t id) {
  (*(volatile uint32_t *)(SPI_BASE + SPI_SSR)) = 0;
}

void spi_deselect_slave(uint8_t id) {
  (*(volatile uint32_t *)(SPI_BASE + SPI_SSR)) = 0xFFFFFFFF;
}

