/**
 * @author      : Anuj Phegade (anujf95@gmail.com)
 * @file        : entry.S
 * @created     : Monday May 03, 2021 11:48:18 IST
 * @description : Custom Startup File For BootROM
 */

#include "soc.h"
#include "encoding.h"


.section .text.init
.option norvc
.global _start
_start:
    j reset_vector

.align 4
trap_entry:
    csrr t0, mcause
    andi a0, t0, 0x0F

    //set led as output
    lui	a4,0x20010
    lw	a5,4(a4)
    sext.w	a5,a5
    andi	a5,a5,-256
    sw	a5,4(a4)

    //set pattern
    lui	a4,0x20010
    lw	a5,0(a4)
    andi	a0,a0,255
    sext.w	a5,a5
    andi	a5,a5,-256
    or	a5,a5,a0
    sw	a5,0(a4)
1:  j 1b


.section .text
.align 2
.global reset_vector
reset_vector:
    li x1, 0
    li x2, 0
    li x3, 0
    li x4, 0
    li x5, 0
    li x6, 0
    li x7, 0
    li x8, 0
    li x9, 0
    li x10, 0
    li x11, 0
    li x12, 0
    li x13, 0
    li x14, 0
    li x15, 0
    li x16, 0
    li x17, 0
    li x18, 0
    li x19, 0
    li x20, 0
    li x21, 0
    li x22, 0
    li x23, 0
    li x24, 0
    li x25, 0
    li x26, 0
    li x27, 0
    li x28, 0
    li x29, 0
    li x30, 0
    li x31, 0
    csrw mscratch, x0

    //Set up a PMP to permit all accesses
    li t0, (1 << (31 + (53 - 31))) - 1;
    csrw pmpaddr0, t0;
    li t0, PMP_NAPOT | PMP_R | PMP_W | PMP_X;
    csrw pmpcfg0, t0;
    .align 2;

    //disable Virtual Memory
    csrwi sptbr, 0;
    .align 2;

    //write mtvec and make sure it sticks
    la t0, trap_entry
    csrw mtvec, t0
    csrr t1, mtvec
    1:bne t0, t1, 1b

    //Initialize SP
    li sp, SRAM_END

    //get the BOOT MODE
    li  a0, CORECFG_BOOTMODE
    lw  a0, 0(a0)
    andi a0, a0, 0xF

    //go to  Main
    j main

.global fw_jump
fw_jump:
    jr a0

.section .rodata
.global logo
logo:
    .incbin "logo.txt"
    .byte 0
.end
