OUTPUT_ARCH( "riscv" )
ENTRY(_start)

/*----------------------------------------------------------------------*/
/* Sections                                                             */
/*----------------------------------------------------------------------*/

SECTIONS
{

    /* text: test code section */
    . = 0x00010000;
    .text.init : { *(.text.init) }

    . = ALIGN(4);
    .text : { *(.text) }

    .rodata : {
        *(.rodata)
        *(.srodata.cst16) *(.srodata.cst8) *(.srodata.cst4) *(.srodata.cst2) *(.srodata*)
    }

    /* data segment */
    .data : {
        *(.data)
        *(.sdata .sdata.* .gnu.linkonce.s.*)
        ASSERT(SIZEOF(.data)==0,"Error: Size of .data should be 0. This is BootROM. Use stack for variables");
    }

    /* bss segment */
    .bss : {
        *(.sbss .sbss.* .gnu.linkonce.sb.*)
        *(.scommon)
        *(.bss)
        ASSERT(SIZEOF(.bss)==0,"Error: Size of .bss should be 0. This is BootROM. Use stack for variables");
    }
    /* End of uninitalized data segement */
    _end = .;

}

