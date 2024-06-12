
#include "soc.h"
#include "encoding.h"


#define DDR_BASE 0x80000000

  .text
  .globl _start
_start:

  li  x1, 0
  li  x2, 0
  li  x3, 0
  li  x4, 0
  li  x5, 0
  li  x6, 0
  li  x7, 0
  li  x8, 0
  li  x9, 0
  li  x10,0
  li  x11,0
  li  x12,0
  li  x13,0
  li  x14,0
  li  x15,0
  li  x16,0
  li  x17,0
  li  x18,0
  li  x19,0
  li  x20,0
  li  x21,0
  li  x22,0
  li  x23,0
  li  x24,0
  li  x25,0
  li  x26,0
  li  x27,0
  li  x28,0
  li  x29,0
  li  x30,0
  li  x31,0
  
    //Set up a PMP to permit all accesses
    li t0, (1 << (31 + (53 - 31))) - 1;
    csrw pmpaddr0, t0;
    li t0, PMP_NAPOT | PMP_R | PMP_W | PMP_X;
    csrw pmpcfg0, t0;
    .align 2;

  la sp, _stack
  //get the BOOT MODE
  li  a0, CORECFG_BOOTMODE
  lw  a0, 0(a0)
  andi a0, a0, 0xF

  jal main
  
.global fw_jump
fw_jump:
    jr a0


.section ".stack", "awx"
.globl _stack
_stack:

