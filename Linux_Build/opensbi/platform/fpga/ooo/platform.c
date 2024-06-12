/*
 * SPDX-License-Identifier: BSD-2-Clause
 *
 * Copyright (c) 2019 Western Digital Corporation or its affiliates.
 */

#include <sbi/riscv_asm.h>
#include <sbi/riscv_encoding.h>
#include <sbi/sbi_const.h>
#include <sbi/sbi_platform.h>
#include <sbi/sbi_console.h>
#include <sbi/riscv_io.h>
#include <sbi/sbi_string.h>

/*
 * Include these files as needed.
 * See config.mk PLATFORM_xxx configuration parameters.
 */
#include <sbi_utils/fdt/fdt_helper.h>
#include <sbi_utils/fdt/fdt_fixup.h>
#include <sbi_utils/ipi/aclint_mswi.h>
#include <sbi_utils/irqchip/plic.h>
#include <sbi_utils/timer/aclint_mtimer.h>
#include <sbi_utils/serial/xlnx_uartlite.h>

#define PLATFORM_PLIC_ADDR		0xc000000
#define PLATFORM_PLIC_NUM_SOURCES	6
#define PLATFORM_HART_COUNT		1
#define PLATFORM_CLINT_ADDR		0x2000000

#define PLATFORM_ACLINT_MTIMER_FREQ	1000000
#define PLATFORM_ACLINT_MSWI_ADDR	(PLATFORM_CLINT_ADDR + \
					 CLINT_MSWI_OFFSET)
#define PLATFORM_ACLINT_MTIMER_ADDR	(PLATFORM_CLINT_ADDR + \
					 CLINT_MTIMER_OFFSET)



//UART SPECIFIC Functionality 


#define UART_BASE                           0x20000000
#define UART_RX_FIFO_OFFSET		            0x0	/* receive FIFO, read only */
#define UART_TX_FIFO_OFFSET		            0x4	/* transmit FIFO, write only */
#define UART_STATUS_REG_OFFSET		        0x8	/* status register, read only */
#define UART_CONTROL_REG_OFFSET		        0xC	/* control reg, write only */
#define UART_RXD                            ((volatile void *)(UART_BASE+UART_RX_FIFO_OFFSET))
#define UART_TXD                            ((volatile void *)(UART_BASE+UART_TX_FIFO_OFFSET))
#define UART_STAT                           ((volatile void *)(UART_BASE+UART_STATUS_REG_OFFSET))
#define UART_CTRL                           ((volatile void *)(UART_BASE+UART_CONTROL_REG_OFFSET))
#define UART_ENABLE_INTR		            0x10	/* enable interrupt */
#define UART_FIFO_RX_RESET		            0x02	/* reset receive FIFO */
#define UART_FIFO_TX_RESET		            0x01	/* reset transmit FIFO */
#define UART_PARITY_ERROR		            0x80
#define UART_FRAMING_ERROR		            0x40
#define UART_OVERRUN_ERROR		            0x20
#define UART_INTR_ENABLED		            0x10	/* interrupt enabled */
#define UART_TX_FIFO_FULL		            0x08	/* transmit FIFO full */
#define UART_TX_FIFO_EMPTY		            0x04	/* transmit FIFO empty */
#define UART_RX_FIFO_FULL		            0x02	/* receive FIFO full */
#define UART_RX_FIFO_VALID_DATA		        0x01	/* data in receive FIFO */



#define PLATFORM_UART_INPUT_FREQ	10000000
#define PLATFORM_UART_BAUDRATE		57600	 // In the latest one with 16MHz we are using 57600 as baudrate


static struct plic_data plic = {
	.addr = PLATFORM_PLIC_ADDR,
	.num_src = PLATFORM_PLIC_NUM_SOURCES,
};

static struct aclint_mswi_data mswi = {
	.addr = PLATFORM_ACLINT_MSWI_ADDR,
	.size = ACLINT_MSWI_SIZE,
	.first_hartid = 0,
	.hart_count = PLATFORM_HART_COUNT,
};

static struct aclint_mtimer_data mtimer = {
	.mtime_freq = PLATFORM_ACLINT_MTIMER_FREQ,
	.mtime_addr = PLATFORM_ACLINT_MTIMER_ADDR +
		      ACLINT_DEFAULT_MTIME_OFFSET,
	.mtime_size = ACLINT_DEFAULT_MTIME_SIZE,
	.mtimecmp_addr = PLATFORM_ACLINT_MTIMER_ADDR +
			 ACLINT_DEFAULT_MTIMECMP_OFFSET,
	.mtimecmp_size = ACLINT_DEFAULT_MTIMECMP_SIZE,
	.first_hartid = 0,
	.hart_count = PLATFORM_HART_COUNT,
	.has_64bit_mmio = TRUE,
};






/*
 * Platform early initialization.
 */
static int ooo_early_init(bool cold_boot)
{
	return 0;
}

/*
 * Platform final initialization.
 */
static int ooo_final_init(bool cold_boot)
{
	void *fdt;
	if (! cold_boot)
		return 0;

	fdt=sbi_scratch_thishart_arg1_ptr();
	fdt_fixups(fdt)	;
	return 0;
}

/*
 * Initialize the platform console.
 */
static int ooo_console_init(void)
{

	
	return xlnx_uartlite_init(UART_BASE);	
}


/*
 * Initialize the platform interrupt controller for current HART.
 */
static int ooo_irqchip_init(bool cold_boot)
{
	u32 hartid = current_hartid();
	int ret;

	/* Example if the generic PLIC driver is used */
	if (cold_boot) {
		ret = plic_cold_irqchip_init(&plic);
		if (ret)
			return ret;
	}

	return plic_warm_irqchip_init(&plic, 2 * hartid, 2 * hartid + 1);
}

/*
 * Initialize IPI for current HART.
 */
static int ooo_ipi_init(bool cold_boot)
{
	int ret;

	/* Example if the generic ACLINT driver is used */
	if (cold_boot) {
		ret = aclint_mswi_cold_init(&mswi);
		if (ret)
			return ret;
	}

	return aclint_mswi_warm_init();
}

/*
 * Initialize platform timer for current HART.
 */
static int ooo_timer_init(bool cold_boot)
{
	int ret;

	/* Example if the generic ACLINT driver is used */
	if (cold_boot) {
		ret = aclint_mtimer_cold_init(&mtimer, NULL);
		if (ret)
			return ret;
	}

	return aclint_mtimer_warm_init();
}

/*
 * Platform descriptor.
 */
const struct sbi_platform_operations platform_ops = {
	.early_init		= ooo_early_init,
	.final_init		= ooo_final_init,
	.console_init		= ooo_console_init,
	.irqchip_init		= ooo_irqchip_init,
	.ipi_init		= ooo_ipi_init,
	.timer_init		= ooo_timer_init
};
const struct sbi_platform platform = {
	.opensbi_version	= OPENSBI_VERSION,
	.platform_version	= SBI_PLATFORM_VERSION(0x0, 0x00),
	.name			= "IISc DESE-RCLAB OoO",
	.features		= SBI_PLATFORM_DEFAULT_FEATURES,
	.hart_count		= 1,
	.hart_stack_size	= SBI_PLATFORM_DEFAULT_HART_STACK_SIZE,
	.platform_ops_addr	= (unsigned long)&platform_ops
};
