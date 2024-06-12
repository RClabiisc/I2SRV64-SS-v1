/*****************************************************************************
*                            PMA Configuration File                         *
*****************************************************************************/
`define PMA_ENTRIES 8

reg [63:0]                  PMA_Base[0:`PMA_ENTRIES-1];
reg [63:0]                  PMA_Size[0:`PMA_ENTRIES-1];
reg [`PMA_ATTR__LEN-1:0]    PMA_Attr[0:`PMA_ENTRIES-1];

integer cfg;
initial begin
    cfg=-1;

    //0x0000_1000   Core CFG (1 KiB)   R W    AXI PBUS
    cfg=cfg+1;
    PMA_Base[cfg] = 64'h0000_0000_0000_1000;
    PMA_Size[cfg] = 64'h0000_0000_0000_03FF;
        PMA_Attr[cfg][`PMA_ATTR_READ]      = `PMA_ATTR_READ__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_WRITE]     = `PMA_ATTR_WRITE__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_EXECUTE]   = `PMA_ATTR_EXECUTE__DENY;
        PMA_Attr[cfg][`PMA_ATTR_RESERVED3] = `PMA_ATTR_RESERVED3__DEFAULT;
        PMA_Attr[cfg][`PMA_ATTR_CACHEABLE] = `PMA_ATTR_CACHEABLE__FALSE;
        PMA_Attr[cfg][`PMA_ATTR_ATOMIC]    = `PMA_ATTR_ATOMIC__DENY;
        PMA_Attr[cfg][`PMA_ATTR_TYPE]      = `PMA_ATTR_TYPE__MMIO;
        PMA_Attr[cfg][`PMA_ATTR_RESERVED7] = `PMA_ATTR_RESERVED7__DEFAULT;
        PMA_Attr[cfg][`PMA_ATTR_BUS]       = `PMA_ATTR_BUS__PRIVATE;

    //0x0001_0000   Boot ROM (16 KiB)   R X C AXI L2
    cfg=cfg+1;
    PMA_Base[cfg] = 64'h0000_0000_0001_0000;
    PMA_Size[cfg] = 64'h0000_0000_0000_3FFF;
        PMA_Attr[cfg][`PMA_ATTR_READ]      = `PMA_ATTR_READ__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_WRITE]     = `PMA_ATTR_WRITE__DENY;
        PMA_Attr[cfg][`PMA_ATTR_EXECUTE]   = `PMA_ATTR_EXECUTE__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_RESERVED3] = `PMA_ATTR_RESERVED3__DEFAULT;
        PMA_Attr[cfg][`PMA_ATTR_CACHEABLE] = `PMA_ATTR_CACHEABLE__TRUE;
        PMA_Attr[cfg][`PMA_ATTR_ATOMIC]    = `PMA_ATTR_ATOMIC__DENY;
        PMA_Attr[cfg][`PMA_ATTR_TYPE]      = `PMA_ATTR_TYPE__MEM;
        PMA_Attr[cfg][`PMA_ATTR_RESERVED7] = `PMA_ATTR_RESERVED7__DEFAULT;
        PMA_Attr[cfg][`PMA_ATTR_BUS]       = `PMA_ATTR_BUS__AXI_L2;

    //0x0101_0000   CLINT  (64 KiB)  RW A    Private Bus
    cfg=cfg+1;
    PMA_Base[cfg] = 64'h0000_0000_0200_0000;
    PMA_Size[cfg] = 64'h0000_0000_0000_FFFF;
        PMA_Attr[cfg][`PMA_ATTR_READ]      = `PMA_ATTR_READ__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_WRITE]     = `PMA_ATTR_WRITE__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_EXECUTE]   = `PMA_ATTR_EXECUTE__DENY;
        PMA_Attr[cfg][`PMA_ATTR_RESERVED3] = `PMA_ATTR_RESERVED3__DEFAULT;
        PMA_Attr[cfg][`PMA_ATTR_CACHEABLE] = `PMA_ATTR_CACHEABLE__FALSE;
        PMA_Attr[cfg][`PMA_ATTR_ATOMIC]    = `PMA_ATTR_ATOMIC__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_TYPE]      = `PMA_ATTR_TYPE__MMIO;
        PMA_Attr[cfg][`PMA_ATTR_RESERVED7] = `PMA_ATTR_RESERVED7__DEFAULT;
        PMA_Attr[cfg][`PMA_ATTR_BUS]       = `PMA_ATTR_BUS__PRIVATE;

    //0x0100_0000   PLIC  (16 MiB)   RW A    Private Bus
    cfg=cfg+1;
    PMA_Base[cfg] = 64'h0000_0000_0C00_0000;
    PMA_Size[cfg] = 64'h0000_0000_00FF_FFFF;
        PMA_Attr[cfg][`PMA_ATTR_READ]      = `PMA_ATTR_READ__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_WRITE]     = `PMA_ATTR_WRITE__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_EXECUTE]   = `PMA_ATTR_EXECUTE__DENY;
        PMA_Attr[cfg][`PMA_ATTR_RESERVED3] = `PMA_ATTR_RESERVED3__DEFAULT;
        PMA_Attr[cfg][`PMA_ATTR_CACHEABLE] = `PMA_ATTR_CACHEABLE__FALSE;
        PMA_Attr[cfg][`PMA_ATTR_ATOMIC]    = `PMA_ATTR_ATOMIC__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_TYPE]      = `PMA_ATTR_TYPE__MMIO;
        PMA_Attr[cfg][`PMA_ATTR_RESERVED7] = `PMA_ATTR_RESERVED7__DEFAULT;
        PMA_Attr[cfg][`PMA_ATTR_BUS]       = `PMA_ATTR_BUS__PRIVATE;


    //0x1000_0000   Internal SRAM (64 KiB) RWX CA  AXI L2
    cfg=cfg+1;
    PMA_Base[cfg] = 64'h0000_0000_1000_0000;
    PMA_Size[cfg] = 64'h0000_0000_0000_FFFF;
        PMA_Attr[cfg][`PMA_ATTR_READ]      = `PMA_ATTR_READ__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_WRITE]     = `PMA_ATTR_WRITE__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_EXECUTE]   = `PMA_ATTR_EXECUTE__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_RESERVED3] = `PMA_ATTR_RESERVED3__DEFAULT;
        PMA_Attr[cfg][`PMA_ATTR_CACHEABLE] = `PMA_ATTR_CACHEABLE__TRUE;
        PMA_Attr[cfg][`PMA_ATTR_ATOMIC]    = `PMA_ATTR_ATOMIC__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_TYPE]      = `PMA_ATTR_TYPE__MEM;
        PMA_Attr[cfg][`PMA_ATTR_RESERVED7] = `PMA_ATTR_RESERVED7__DEFAULT;
        PMA_Attr[cfg][`PMA_ATTR_BUS]       = `PMA_ATTR_BUS__AXI_L2;

    //0x2000_0000   Peripherals (6 x 64KiB)   RW      AXI L3
    cfg=cfg+1;
    PMA_Base[cfg] = 64'h0000_0000_2000_0000;
    PMA_Size[cfg] = 64'h0000_0000_0007_FFFF;
        PMA_Attr[cfg][`PMA_ATTR_READ]      = `PMA_ATTR_READ__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_WRITE]     = `PMA_ATTR_WRITE__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_EXECUTE]   = `PMA_ATTR_EXECUTE__DENY;
        PMA_Attr[cfg][`PMA_ATTR_RESERVED3] = `PMA_ATTR_RESERVED3__DEFAULT;
        PMA_Attr[cfg][`PMA_ATTR_CACHEABLE] = `PMA_ATTR_CACHEABLE__FALSE;
        PMA_Attr[cfg][`PMA_ATTR_ATOMIC]    = `PMA_ATTR_ATOMIC__DENY;
        PMA_Attr[cfg][`PMA_ATTR_TYPE]      = `PMA_ATTR_TYPE__MMIO;
        PMA_Attr[cfg][`PMA_ATTR_RESERVED7] = `PMA_ATTR_RESERVED7__DEFAULT;
        PMA_Attr[cfg][`PMA_ATTR_BUS]       = `PMA_ATTR_BUS__AXI_L3;

    //0x4000_0000   Flash Memory (128 MiB) R X C   AXI L2
    cfg=cfg+1;
    PMA_Base[cfg] = 64'h0000_0000_4000_0000;
    PMA_Size[cfg] = 64'h0000_0000_07FF_FFFF;
        PMA_Attr[cfg][`PMA_ATTR_READ]      = `PMA_ATTR_READ__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_WRITE]     = `PMA_ATTR_WRITE__DENY;
        PMA_Attr[cfg][`PMA_ATTR_EXECUTE]   = `PMA_ATTR_EXECUTE__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_RESERVED3] = `PMA_ATTR_RESERVED3__DEFAULT;
        PMA_Attr[cfg][`PMA_ATTR_CACHEABLE] = `PMA_ATTR_CACHEABLE__TRUE;
        PMA_Attr[cfg][`PMA_ATTR_ATOMIC]    = `PMA_ATTR_ATOMIC__DENY;
        PMA_Attr[cfg][`PMA_ATTR_TYPE]      = `PMA_ATTR_TYPE__MEM;
        PMA_Attr[cfg][`PMA_ATTR_RESERVED7] = `PMA_ATTR_RESERVED7__DEFAULT;
        PMA_Attr[cfg][`PMA_ATTR_BUS]       = `PMA_ATTR_BUS__AXI_L2;

    //0x8000_0000   DDR Memory (1 GiB)  RWX CA  AXI L2
    cfg=cfg+1;
    PMA_Base[cfg] = 64'h0000_0000_8000_0000;
    PMA_Size[cfg] = 64'h0000_0000_3FFF_FFFF;
        PMA_Attr[cfg][`PMA_ATTR_READ]      = `PMA_ATTR_READ__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_WRITE]     = `PMA_ATTR_WRITE__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_EXECUTE]   = `PMA_ATTR_EXECUTE__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_RESERVED3] = `PMA_ATTR_RESERVED3__DEFAULT;
        PMA_Attr[cfg][`PMA_ATTR_CACHEABLE] = `PMA_ATTR_CACHEABLE__TRUE;
        PMA_Attr[cfg][`PMA_ATTR_ATOMIC]    = `PMA_ATTR_ATOMIC__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_TYPE]      = `PMA_ATTR_TYPE__MEM;
        PMA_Attr[cfg][`PMA_ATTR_RESERVED7] = `PMA_ATTR_RESERVED7__DEFAULT;
        PMA_Attr[cfg][`PMA_ATTR_BUS]       = `PMA_ATTR_BUS__AXI_L2;
end

