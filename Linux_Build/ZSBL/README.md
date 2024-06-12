# BootROM

## Working

- Initialise system registers, CSRs, default interrupt Vectors, bss & data segments
  - Initialises UART, Displays Welcome Screen and waits for binary image file transfer from FLASH to SRAM
  
  - Jumps to target program SRAM
  
    

**zsbl_flash2sram.coe**

1. ```
   If all address space and features are same then this COE file can be used directly.
   ```

## Special Instructions

1. BootROM is ROM, hence the code is read only. But code inits stack in Internal SRAM. This allows local variables to be used as SRAM is r/w.
2. While Modifying BootROM code, avoid using global variables, which will be placed in .data or .bss section. The linker script will capture this error .data & .bss is not empty.
