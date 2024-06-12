# Repository Structure

```
I2SRV64-SS					=> Project Repository

├──README.md      => Read me file for building the project in Xilinx Vivado 								Toolset (this file)
├── Hardware_Source_Files	=> Contain RTL, Constraints, verilog header files etc		
		├── BootROM_Coe  	=>  .coe file for BootRom
		├── IP              => IP Sources
    	├── rtl             => RTL Source Code      
        	├── Core    	=> Processor Core RTL files
            ├── generic  	=> Generic Components
            ├── Processor   => Processor Level(includes PLIC, CLINT,CoreCFG andPBUS_XBAR)
            ├── SoC   		=> SoC Level RTL
            ├── Wrapper     => VC707 Toplevel wrapper
        ├──include     	=> Verilog Header Files
        ├──Constraints  => Constraint file I/O mapping and Timing
├── Linux_Build		=> Resources for building Linux for I2SRV64-SS 
```



## Creating a new Vivado Project for I2SRV64-SS

* To instantiate this core, use Xilinx vivado [2020.1](https://www.xilinx.com/support/download/index.html/content/xilinx/en/downloadNav/vivado-design-tools/archive.html) or higher 

* Create project with **Virtex-7 VC707 Evaluation board** as the target device

* Upon creation of project, go to **tools > Settings **

  * in **General->Verilog options :**

    * provide the path to the verilog header files (include folder inside Hardware_Source_Files)

    * Add **SOC_ENABLE_DRAM** without any **value** in the defines section

  * **Simulation->Verilog options**

    * provide the path to the verilog header files (include folder inside Hardware_Source_Files)

* go to **File--> Add Source**

  * add all source files in rtl folder to project (add directory option can be used)
  * add constraints to the project
  * add IP Sources to project from IP folder (add directory option can be used) 

* go to**Window > sources** 

  * Under *hierarchy* expand the modules and double click on **BootROM_2048x64b**.
    * Go to other options and add the **BootROM.coe** file path correctly (Given in )

*  Once bitstream is generated after synthesis and implementation, FPGA can be programmed and tested using the sample codes given in Test_Application.

* Processor support loading binary file of application via XModem protocol over UART based on the bootmode pin configuration. Moserial/minicom can be used to transfer the data.

* This project is configured for working at frequency of 16MHz but can work upto 32MHz without any hardware modifications. UART is configured for 57600 baudrate with one stop bit and no parity bit.

## Code Structure

* SOC_VC707_Wrapper

  * SOC
    * Processor
      * Core
        * IFU
        * EX
        * MMU
        * I-Cache
        * D-Cache
        * Load Store Unit
        * System Control
      * CLINT
      * PLIC
      * CoreCFG
      * PBUS_XBAR
    * JTAG_to_AXI
    * SoC_L2_XBar
    * AXI_BootROM
    * AXI_InternalSRAM
    * AXI_Flash_Controller
    * AXI_DRAM_Controller
    * SoC_L3_XBar
    * AXIlite_UART
    * AXIlite_GPIO
    * AXIlite_I2C
    * AXIlite_Timer
    * AXIlite_SPI
    * AXIlite_GPIO

  



## FPGA tool/ IP version

* The SoC has been synthesized and implemented in Xilinx vivado 2020.1 version. 

* The following table contains the IP's and their respective versions.

  |             IP              |                  IP Name                  |    Version    |
  | :-------------------------: | :---------------------------------------: | :-----------: |
  |     AXI4lite_PBUS_XBar      |               AXI Crossbar                | 2.1 (Rev. 22) |
  |        AXI64_L2_XBar        |               AXI Crossbar                | 2.1 (Rev. 22) |
  |      AXIlite32_L3_XBar      |               AXI Crossbar                | 2.1 (Rev. 22) |
  |      BTB_bmem_256x127b      |          Block Memory Generator           | 8.4 (Rev. 4)  |
  |      BootROM_2048x64b       |          Block Memory Generator           | 8.4 (Rev. 4)  |
  |       IB_bmem_4x186b        |          Block Memory Generator           | 8.4 (Rev. 4)  |
  |    InternalSRAM_8192x64b    |          Block Memory Generator           | 8.4 (Rev. 4)  |
  |        JTAG_to_AXI4         |            JTAG to AXI Master             | 1.2 (Rev. 11) |
  |      PHT_bmem_4096x16b      |          Block Memory Generator           | 8.4 (Rev. 4)  |
  |       RAS_dmem_32x64b       |       Distributed Memory Generator        | 8.0 (Rev. 13) |
  |     axi32_to_axilite32      |          AXI Protocol Converter           | 2.1 (Rev. 21) |
  |    axi64_bram_ctrl_16KiB    |            AXI BRAM Controller            | 4.1 (Rev. 3)  |
  |    axi64_bram_ctrl_64KiB    |            AXI BRAM Controller            | 4.1 (Rev. 3)  |
  |     axi64_clkcnv_async      |            AXI Clock Converter            | 2.1 (Rev. 20) |
  |    axi64_dramctrl_vc707     | Memory Interface Generator (MIG 7 Series) | 4.2 (Rev. 1)  |
  |    axi64_flashemc_vc707     |                  AXI EMC                  | 3.0 (Rev. 21) |
  |       axi64_to_axi32        |         AXI Data Width Converter          | 2.1 (Rev. 21) |
  |       axilite32_gpio        |                 AXI GPIO                  | 2.0 (Rev. 23) |
  |        axilite32_i2c        |                  AXI IIC                  | 2.0 (Rev. 24) |
  |        axilite32_spi        |               AXI Quad SPI                | 3.2 (Rev. 20) |
  |       axilite32_timer       |                 AXI Timer                 | 2.0 (Rev. 23) |
  | axilite32_uartlite_115200n8 |               AXI Uartlite                | 2.0 (Rev. 25) |
  |          rst_ctrl           |          Processor System Reset           | 5.0 (Rev. 13) |
  |        sys_clk_ctrl         |              Clocking Wizard              | 6.0 (Rev. 5)  |

  

  
  
  
  
  
  
  
  
   
  
  

