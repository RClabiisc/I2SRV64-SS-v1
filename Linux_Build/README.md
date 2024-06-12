# Step-by-step Guide of Booting linux on a 

# 64-bit out-of-order Superscalar RISC - V Processor 

### 

- ***To generate Linux image using buildroot Required configuration file***
  
  
  
  - ooo_linux_defconfig
  
  - ooo_riscv.dts (dts file)
  
    *Above two file keep in any file outside buildroot*
  
    
  
  - busybox-minimal.config  at ***buildroot/package/busybox*** directory
  
  - *ooo_buildroot_defconfig*  put this configuration file inside  ***buildroot/configs*** directory
  
    ***Note**: All above file is available in **ooo_config** file*. 
  
    
  
    Once you have the cross-compiler and above configuration files are available, the easiest way to build linux using buildroot is:
  
    ~~~bash
    1. make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- ooo_buildroot_defconfig
    2. make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu-
    ~~~
  
    - Generated Linux image and dtb file, you will get at **buildroot/output/image**
  
    
  
    <img src="..\Images\buildroot.PNG" alt="buildroot" style="zoom:80%;" />
  
    - ***ooo*** is platform dependent file, keep it inside ***OpenSBI/platform/fpga*** directory
  
    - Pass linux ***image*** and ***dtb*** file to openSBI with command 
  
      ~~~bash
      make PLATFORM=fpga/ooo CROSS_COMPILE=riscv64-unknown-linux-gnu-      FW_PAYLOAD_PATH=../buildroot/output/images/Image FW_FDT_PATH=../buildroot/output/images/ooo_riscv.dtb 
      
      ~~~
  
  <img src="..\Images\opensbi.PNG" alt="opensbi" style="zoom:80%;" />
  
    - OpenSBI generate Single binary ***fw_playload.bin*** at ***Opensbi/build/platform/fpga/ooo/firmware***
  
    - Put this binary file in SD card that supports fat32 filesystem with ***boot.bin*** name
  
- Program *VC 707 128MB BPI flash* with ***FSBL***
- Set ***DIP*** ***switch*** position of FPGA board ***0010***
- program FPGA with design ***bitstream.bin***



#### **Bootflow working**





<img src="..\Images\bootflow.PNG" alt="bootflow" style="zoom:90%;" />

## Complete Setup



<img src="..\Images\setup.PNG" alt="setup" style="zoom:90%;" />

- ***Connect Host PC through UART with 57600 baud rate with 1 stop bit and none parity***

  

  ~~~bash
  
    ___         ___    ____  ___ ____   ____   __     __
   / _ \  ___  / _ \  |  _ \|_ _/ ___| / ___|  \ \   / /
  | | | |/ _ \| | | | | |_) || |\___ \| |   ____\ \ / /
  | |_| | (_) | |_| | |  _ < | | ___) | |__|_____\ V /
   \___/ \___/ \___/  |_| \_\___|____/ \____|     \_/
  
  
  
  Welcome to RCLAB OoO Processor Linux Boot
  
  FSBL file Copying from FLASH to SRAM.....
  Welcome to RCLAB OoO Processor Linux Boot
  
  Linux Image Copying from SD Card to DRAM.....
  Enter binary file name::
  =============== FSBL ===============
  ControlReg reset   00000180
  ControlReg final   000000e6
      - disk_initialization try
      - disk_initialization done
      - FR_WRITE_PROTECTED
      - FAT volume found
  Loading file into memory...
  Reading binary file...
  Till now 1 MB data read done
  Till now 2 MB data read done
  Till now 3 MB data read done
  Till now 4 MB data read done
  Till now 5 MB data read done
  Till now 6 MB data read done
  Till now 7 MB data read done
  Till now 8 MB data read done
  Till now 9 MB data read done
  Till now 10 MB data read done
  Till now 11 MB data read done
  Till now 12 MB data read done
  Load 13201928 bytes to memory address 0x80000000 from file
  =========== Jump to DDR ============
  
  OpenSBI v0.9-71-gf60c84a
     ____                    _____ ____ _____
    / __ \                  / ____|  _ \_   _|
   | |  | |_ __   ___ _ __ | (___ | |_) || |
   | |  | | '_ \ / _ \ '_ \ \___ \|  _ < | |
   | |__| | |_) |  __/ | | |____) | |_) || |_
    \____/| .__/ \___|_| |_|_____/|____/_____|
          | |
          |_|
  
  Platform Name             : IISc DESE OoO Processor
  Platform Features         : mfdeleg
  Platform HART Count       : 1
  Platform IPI Device       : clint
  Platform Timer Device     : clint
  Platform Console Device   : ooo_uartlite
  Platform HSM Device       : ---
  Platform SysReset Device  : ---
  Firmware Base             : 0x80000000
  Firmware Size             : 92 KB
  Runtime SBI Version       : 0.3
  
  Domain0 Name              : root
  Domain0 Boot HART         : 0
  Domain0 HARTs             : 0*
  Domain0 Region00          : 0x0000000002000000-0x000000000200ffff (I)
  Domain0 Region01          : 0x0000000080000000-0x000000008001ffff ()
  Domain0 Region02          : 0x0000000000000000-0xffffffffffffffff (R,W,X)
  Domain0 Next Address      : 0x0000000080200000
  Domain0 Next Arg1         : 0x0000000082200000
  Domain0 Next Mode         : S-mode
  Domain0 SysReset          : yes
  
  Boot HART ID              : 0
  Boot HART Domain          : root
  Boot HART ISA             : rv64imafdcsu
  Boot HART Features        : scounteren,mcounteren,time
  Boot HART PMP Count       : 16
  Boot HART PMP Granularity : 4
  Boot HART PMP Address Bits: 54
  Boot HART MHPM Count      : 0
  Boot HART MHPM Count      : 0
  Boot HART MIDELEG         : 0x0000000000000222
  Boot HART MEDELEG         : 0x000000000000b109
  [    0.000000] Linux version 5.15.6 (anuj@rclab-H410M-H) (riscv-buildroot-linux-gnu-gcc.br_real (Buildroot 2021.11) 10.3.0, GNU ld (GNU Binutils) 2.36.1) #3 Thu Jun 2 17:52:25 IST 2022
  [    0.000000] OF: fdt: Ignoring memory range 0x80000000 - 0x80200000
  [    0.000000] Machine model: IISc OoO RISC-V
  [    0.000000] earlycon: sbi0 at I/O port 0x0 (options '')
  [    0.000000] printk: bootconsole [sbi0] enabled
  [    0.000000] efi: UEFI not found.
  [    0.000000] Zone ranges:
  [    0.000000]   DMA32    [mem 0x0000000080200000-0x00000000bfffffff]
  [    0.000000]   Normal   empty
  [    0.000000] Movable zone start for each node
  [    0.000000] Early memory node ranges
  [    0.000000]   node   0: [mem 0x0000000080200000-0x00000000bfffffff]
  [    0.000000] Initmem setup node 0 [mem 0x0000000080200000-0x00000000bfffffff]
  [    0.000000] SBI specification v0.3 detected
  [    0.000000] SBI implementation ID=0x1 Version=0x9
  [    0.000000] SBI TIME extension detected
  [    0.000000] SBI IPI extension detected
  [    0.000000] SBI RFENCE extension detected
  [    0.000000] riscv: ISA extensions acdfim
  [    0.000000] riscv: ELF capabilities acdfim
  [    0.000000] pcpu-alloc: s0 r0 d32768 u32768 alloc=1*32768
  [    0.000000] pcpu-alloc: [0] 0
  [    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 258055
  [    0.000000] Kernel command line: earlycon=sbi console=hvc debug single
  [    0.000000] Unknown kernel command line parameters "single", will be passed to user space.
  [    0.000000] Dentry cache hash table entries: 131072 (order: 8, 1048576 bytes, linear)
  [    0.000000] Inode-cache hash table entries: 65536 (order: 7, 524288 bytes, linear)
  [    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
  [    0.000000] Memory: 1018296K/1046528K available (1796K kernel code, 2908K rwdata, 2048K rodata, 3840K init, 224K bss, 28232K reserved, 0K cma-reserved)
  [    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=1, Nodes=1
  [    0.000000] NR_IRQS: 64, nr_irqs: 64, preallocated irqs: 0
  [    0.000000] riscv-intc: 64 local interrupts mapped
  [    0.000000] plic: interrupt-controller@c000000: mapped 6 interrupts with 1 handlers for 2 contexts.
  [    0.000000] random: get_random_bytes called from start_kernel+0x326/0x520 with crng_init=0
  [    0.000000] riscv_timer_init_dt: Registering clocksource cpuid [0] hartid [0]
  [    0.000000] clocksource: riscv_clocksource: mask: 0xffffffffffffffff max_cycles: 0x1d854df40, max_idle_ns: 3526361616960 ns
  [    0.000046] sched_clock: 64 bits at 1000kHz, resolution 1000ns, wraps every 2199023255500ns
  [    0.021241] Console: colour dummy device 80x25
  [    0.029441] printk: console [hvc0] enabled
  [    0.029441] printk: console [hvc0] enabled
  [    0.045274] printk: bootconsole [sbi0] disabled
  [    0.045274] printk: bootconsole [sbi0] disabled
  [    0.064514] Calibrating delay loop (skipped), value calculated using timer frequency.. 2.00 BogoMIPS (lpj=10000)
  [    0.083784] pid_max: default: 32768 minimum: 301
  [    0.102854] Mount-cache hash table entries: 2048 (order: 2, 16384 bytes, linear)
  [    0.118974] Mountpoint-cache hash table entries: 2048 (order: 2, 16384 bytes, linear)
  [    0.215689] ASID allocator using 16 bits (65536 entries)
  [    0.232919] EFI services will not be available.
  [    0.257870] devtmpfs: initialized
  [    0.330437] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604462750000 ns
  [    0.349440] futex hash table entries: 256 (order: 0, 6144 bytes, linear)
  [    0.711364] clocksource: Switched to clocksource riscv_clocksource
  [    1.288872] workingset: timestamp_bits=62 max_order=18 bucket_order=0
  [    1.656217] io scheduler mq-deadline registered
  [    1.664394] io scheduler kyber registered
  [    2.274808] xilinx_spi 20040000.spi: at [mem 0x20040000-0x20040fff], irq=2
  [   10.670853] Freeing unused kernel image (initmem) memory: 3840K
  [   10.686014] Run /init as init process
  [   10.692217]   with arguments:
  [   10.697551]     /init
  [   10.702613]     single
  [   10.706899]   with environment:
  [   10.713660]     HOME=/
  [   10.717948]     TERM=linux
    ____    ____        _      _   __    _   _    _   _    _
   |  _ \  /  __|      | |    | | |  \  | | | |  | | \ \  / /
   | |_) | | |    ____ | |    | | | \ \ | | | |  | |  \ \/ /
   |  _  | | |__ |____|| |__  | | | |\ \| | | \__/ |  / /\ \
   |_| \_\ \____|      |____| |_| |_| \ __|  \____/  /_/  \_\
  RCLINUX:Successfully Booted into Userspace
  printing content of RootFile system
  Helloworld  init        media       root        tmp
  bin         lib         mnt         run         usr
  dev         lib64       opt         sbin        var
  etc         linuxrc     proc        sys
  / # 
  ~~~
