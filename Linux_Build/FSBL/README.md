## Working

- Initialise system registers, CSRs, default interrupt Vectors, bss & data segments
  - Initialises UART,SPI,GPIO,DRAM

  - if BootMode set to 0010 then FSBL will copy Linux binary image from SD Card using SPI protocol to DRAM and Jump to DRAM.
  
  - if BootMode set to 0111 then FSBL will copy LINUX Binary from FPGA Flash memory to DRAM and Jump to DRAM.
  
    ## Supported Boot Modes
  
    - [0000] Info Mode
  
    - [0010] Boot from SD Card 
  
    - [0111]  Boot From Flash to DRAM
  
    - [0101] Boot From UART to Flash
  
    - [0110] Boot from UART to DRAM
  
      
  
    ## Error Codes
  
    Error Code is displayed on LEDs when bootloader hangs
  
    - [11111111] : Invalid Boot Mode
    - [11110000] : Bootloader Error, Reset Required
    - [0000xxxx] : Trap while executing, trap code given by xxxx

# FSBL Software Stacks for SD Card Interface 

<img src="..\..\Images\fsbl.PNG" alt="fsbl" style="zoom:90%;" />

- - 
  
    

**vc707.mcs and vc707.prm**

1. ```
   If all address space and features are same then this .mcs and .prm storing Linux binary image can be use directly to program Flash of VC707 FPGA board.
   ```

