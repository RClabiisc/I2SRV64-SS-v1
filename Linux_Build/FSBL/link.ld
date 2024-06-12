
SECTIONS
{
    . = 0x10000000;
    .text : { *(.text) }
    
  	. = ALIGN(0x1000);
    .rodata : { *(.rodata) }
    .bss : { *(.bss) }
    .sbss : { *(.sbss) }
    
    . = 0x1000f000;
    .stack : { *(.stack) }

    . = 0x1000ff00;
    .sdata : { *(.sdata) }
}
