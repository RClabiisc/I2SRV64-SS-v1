// See LICENSE for license details.

#ifndef SPI_HEADER_H
#define SPI_HEADER_H

#include <stdint.h>


// Xilinx AXI_QUAD_SPI

  #define SPI_BASE 0x20040000
  #define SPI_buffer_size 256


// Global interrupt enable register [Write]
#define SPI_GIER 0x1C

// IP interrupt status register [Read/Toggle to write]
#define SPI_ISR 0x20

// IP interrupt enable register [Read/Write]
#define SPI_IER 0x28

// Software reset register [Write]
#define SPI_SRR 0x40

// SPI control register [Read/Write]
#define SPI_CR 0x60

// SPI status register [Read]
#define SPI_SR 0x64

// SPI data transmit register, FIFO-16 [Write]
#define SPI_DTR 0x68

// SPI data receive register, FIFO-16 [Read]
#define SPI_DRR 0x6C

// SPI Slave select register, [Read/Write]
#define SPI_SSR 0x70

// Transmit FIFO occupancy register [Read]
#define SPI_TFOR 0x74

// Receive FIFO occupancy register [Read]
#define SPI_RFROR 0x78


#define XSP_SR_TX_EMPTY_MASK	   0x00000004 // Transmit Reg/FIFO is
#define XSP_SR_RX_EMPTY_MASK	   0x00000001

#define XSP_CR_LOOPBACK_MASK	   0x00000001 /**< Local loopback mode */
#define XSP_CR_ENABLE_MASK	   0x00000002 /**< System enable */
#define XSP_CR_MASTER_MODE_MASK	   0x00000004 /**< Enable master mode */
#define XSP_CR_CLK_POLARITY_MASK   0x00000008 /**< Clock polarity high
								or low */
#define XSP_CR_CLK_PHASE_MASK	   0x00000010 /**< Clock phase 0 or 1 */
#define XSP_CR_TXFIFO_RESET_MASK   0x00000020 /**< Reset transmit FIFO */
#define XSP_CR_RXFIFO_RESET_MASK   0x00000040 /**< Reset receive FIFO */
#define XSP_CR_MANUAL_SS_MASK	   0x00000080 /**< Manual slave select
								assert */
#define XSP_CR_TRANS_INHIBIT_MASK  0x00000100 /**< Master transaction
								inhibit */
								
#define XSP_INTR_TX_EMPTY_MASK		0x00000004 /**< DTR/TxFIFO is empty */
#define XSP_CR_LSB_MSB_FIRST_MASK	0x00000200


#define XSP_CR_XIP_CLK_PHASE_MASK	0x00000001 /**< Clock phase 0 or 1 */
#define XSP_CR_XIP_CLK_POLARITY_MASK	0x00000002 /**< Clock polarity
								high or low */



#define XSP_SR_RX_EMPTY_MASK	   0x00000001 /**< Receive Reg/FIFO is empty */
#define XSP_SR_RX_FULL_MASK	   0x00000002 /**< Receive Reg/FIFO is full */
#define XSP_SR_TX_EMPTY_MASK	   0x00000004 /**< Transmit Reg/FIFO is
								empty */
#define XSP_SR_TX_FULL_MASK	   0x00000008 /**< Transmit Reg/FIFO is full */
#define XSP_SR_MODE_FAULT_MASK	   0x00000010 /**< Mode fault error */
#define XSP_SR_SLAVE_MODE_MASK	   0x00000020 /**< Slave mode select */

#define XSP_DGIER_OFFSET	0x1C	/**< Global Intr Enable Reg */
#define XSP_IISR_OFFSET	0x20	/**< Interrupt status Reg */
#define XSP_IIER_OFFSET	0x28	/**< Interrupt Enable Reg */
#define XSP_SRR_OFFSET	 	0x40	/**< Software Reset register */
#define XSP_CR_OFFSET		0x60	/**< Control register */
#define XSP_SR_OFFSET		0x64	/**< Status Register */
#define XSP_DTR_OFFSET		0x68	/**< Data transmit */
#define XSP_DRR_OFFSET		0x6C	/**< Data receive */
#define XSP_SSR_OFFSET		0x70	/**< 32-bit slave select */
#define XSP_TFO_OFFSET		0x74	/**< Tx FIFO occupancy */
#define XSP_RFO_OFFSET		0x78	/**< Rx FIFO occupancy */

/*
 * The following bits are available only in axi_qspi Status register.
 */
#define XSP_SR_CPOL_CPHA_ERR_MASK  0x00000040 /**< CPOL/CPHA error */
#define XSP_SR_SLAVE_MODE_ERR_MASK 0x00000080 /**< Slave mode error */
#define XSP_SR_MSB_ERR_MASK	   0x00000100 /**< MSB Error */
#define XSP_SR_LOOP_BACK_ERR_MASK  0x00000200 /**< Loop back error */
#define XSP_SR_CMD_ERR_MASK	   0x00000400 /**< 'Invalid cmd' error */


#define XSP_SR_XIP_RX_EMPTY_MASK	0x00000001 /**< Receive Reg/FIFO
								is empty */
#define XSP_SR_XIP_RX_FULL_MASK		0x00000002 /**< Receive Reg/FIFO
								is full */
#define XSP_SR_XIP_MASTER_MODF_MASK	0x00000004 /**< Receive Reg/FIFO
								is full */
#define XSP_SR_XIP_CPHPL_ERROR_MASK	0x00000008 /**< Clock Phase,Clock
							 Polarity Error */
#define XSP_SR_XIP_AXI_ERROR_MASK	0x00000010 /**< AXI Transaction
								Error */
								
								
/////////////////////////////
// SPI APIs

// start spi
void spi_init();

// disable spi
void spi_disable();

// send a byte
uint8_t spi_send(uint8_t dat);

// send multiple byte, n<=16
void spi_send_multi(const uint8_t* dat, uint16_t n);

// recv multiple byte, n<=16
void spi_recv_multi(uint8_t* dat, uint16_t n);

// select slave device
void spi_select_slave(uint8_t id);

// deselect slave device
void spi_deselect_slave(uint8_t id);

#endif
