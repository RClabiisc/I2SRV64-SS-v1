#ifndef __UTIL_H__
#define __UTIL_H__

#include <stdint.h>

//Macros for Bit Set, Clear & Check
#define sbit(sfr,bit)		(sfr |= (1<<bit))
#define cbit(sfr,bit)		(sfr &= ~(1<<bit))
#define check(sfr, bit)		((sfr & ( 1<<bit ) ) ? 1 : 0)


void delay_ms(unsigned int);
void delay_us(unsigned int);

//Raw IO read/write Access functions
static inline void __raw_write_b(uint8_t val, volatile void *addr)
{
	asm volatile("sb %0, 0(%1)" : : "r" (val), "r" (addr));
}

static inline void __raw_write_hw(uint16_t val, volatile void *addr)
{
	asm volatile("sh %0, 0(%1)" : : "r" (val), "r" (addr));
}

static inline void __raw_write_w(uint32_t val, volatile void *addr)
{
	asm volatile("sw %0, 0(%1)" : : "r" (val), "r" (addr));
}

static inline void __raw_write_dw(uint64_t val, volatile void *addr)
{
	asm volatile("sd %0, 0(%1)" : : "r" (val), "r" (addr));
}

static inline uint8_t __raw_read_b(volatile void *addr)
{
	uint8_t val;
	asm volatile("lb %0, 0(%1)" : "=r" (val) : "r" (addr));
	return val;
}

static inline uint16_t __raw_read_hw(volatile void *addr)
{
	uint16_t val;
	asm volatile("lh %0, 0(%1)" : "=r" (val) : "r" (addr));
	return val;
}

static inline uint32_t __raw_read_w(volatile void *addr)
{
	uint32_t val;
	asm volatile("lw %0, 0(%1)" : "=r" (val) : "r" (addr));
	return val;
}

static inline uint64_t __raw_read_dw(volatile void *addr)
{
	uint64_t val;
	asm volatile("ld %0, 0(%1)" : "=r" (val) : "r" (addr));
	return val;
}

//Macros for *Unordered* IO Access
#define readUIO_b(c)                    ({ uint8_t  __r = __raw_read_b(c);  __r; })
#define readUIO_hw(c)                   ({ uint16_t __r = __raw_read_hw(c); __r; })
#define readUIO_w(c)                    ({ uint32_t __r = __raw_read_w(c);  __r; })
#define readUIO_dw(c)                   ({ uint64_t __r = __raw_read_dw(c); __r; })

#define writeUIO_b(c, v)                ((void)__raw_write_b((v),(c)))
#define writeUIO_hw(c, v)               ((void)__raw_write_hw((v),(c)))
#define writeUIO_w(c, v)                ((void)__raw_write_w((v),(c)))
#define writeUIO_dw(c, v)               ((void)__raw_write_dw((v),(c)))


//Order Access barriers
#define __io_br()                       __asm__ __volatile__ ("fence io,i"  : : : "memory")
//#define __io_ar()                       __asm__ __volatile__ ("fence i,ior" : : : "memory")
#define __io_ar()                       do {} while(0) //Using relaxed after read barrier
#define __io_bw()                       __asm__ __volatile__ ("fence iow,o" : : : "memory")
//#define __io_aw()                       __asm__ __volatile__ ("fence o,io"  : : : "memory")
#define __io_aw()                       do {} while(0) //Using relaxed after write barrier

//Macros for *Ordered* IO Access
#define readIO_b(c)                     ({ uint8_t   __v; __io_br(); __v = readUIO_b(c);  __io_ar(); __v; })
#define readIO_hw(c)                    ({ uint16_t  __v; __io_br(); __v = readUIO_hw(c); __io_ar(); __v; })
#define readIO_w(c)                     ({ uint32_t  __v; __io_br(); __v = readUIO_w(c);  __io_ar(); __v; })
#define readIO_dw(c)                    ({ uint64_t  __v; __io_br(); __v = readUIO_dw(c); __io_ar(); __v; })

#define writeIO_b(c, v)                 ({ __io_bw(); writeUIO_b((c), (v));  __io_aw(); })
#define writeIO_hw(c, v)                ({ __io_bw(); writeUIO_hw((c), (v)); __io_aw(); })
#define writeIO_w(c, v)                 ({ __io_bw(); writeUIO_w((c), (v));  __io_aw(); })
#define writeIO_dw(c, v)                ({ __io_bw(); writeUIO_dw((c), (v)); __io_aw(); })


#endif

