/*****************************************************************************
*                            PMA Configuration File                         *
*****************************************************************************/
`define PMA_ENTRIES 6

reg [63:0]                  PMA_Base[0:`PMA_ENTRIES-1];
reg [63:0]                  PMA_Size[0:`PMA_ENTRIES-1];
reg [`PMA_ATTR__LEN-1:0]    PMA_Attr[0:`PMA_ENTRIES-1];

integer cfg;
initial begin
    cfg=-1;

    //0x0001_0000   User Memory (Lowest Preference (Following checks
    //can override this)
    cfg=cfg+1;
    PMA_Base[cfg] = 64'h0000_0000_0000_0000;
    PMA_Size[cfg] = 64'h0000_0000_FFFF_FFFF;
        PMA_Attr[cfg][`PMA_ATTR_READ]      = `PMA_ATTR_READ__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_WRITE]     = `PMA_ATTR_WRITE__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_EXECUTE]   = `PMA_ATTR_EXECUTE__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_RESERVED3] = `PMA_ATTR_RESERVED3__DEFAULT;
        PMA_Attr[cfg][`PMA_ATTR_CACHEABLE] = `PMA_ATTR_CACHEABLE__TRUE;
        PMA_Attr[cfg][`PMA_ATTR_ATOMIC]    = `PMA_ATTR_ATOMIC__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_TYPE]      = `PMA_ATTR_TYPE__MEM;
        PMA_Attr[cfg][`PMA_ATTR_RESERVED7] = `PMA_ATTR_RESERVED7__DEFAULT;
        PMA_Attr[cfg][`PMA_ATTR_BUS]       = `PMA_ATTR_BUS__AXI_L2;

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


    //0x10000_8000   HTIF
    cfg=cfg+1;
    PMA_Base[cfg] = 64'h0000_0001_0000_8000;
    PMA_Size[cfg] = 64'h0000_0000_0000_0FFF;
        PMA_Attr[cfg][`PMA_ATTR_READ]      = `PMA_ATTR_READ__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_WRITE]     = `PMA_ATTR_WRITE__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_EXECUTE]   = `PMA_ATTR_EXECUTE__DENY;
        PMA_Attr[cfg][`PMA_ATTR_RESERVED3] = `PMA_ATTR_RESERVED3__DEFAULT;
        PMA_Attr[cfg][`PMA_ATTR_CACHEABLE] = `PMA_ATTR_CACHEABLE__FALSE;
        PMA_Attr[cfg][`PMA_ATTR_ATOMIC]    = `PMA_ATTR_ATOMIC__ALLOW;
        PMA_Attr[cfg][`PMA_ATTR_TYPE]      = `PMA_ATTR_TYPE__MMIO;
        PMA_Attr[cfg][`PMA_ATTR_RESERVED7] = `PMA_ATTR_RESERVED7__DEFAULT;
        PMA_Attr[cfg][`PMA_ATTR_BUS]       = `PMA_ATTR_BUS__AXI_L2;

    //0x18000_0000   BarePK
    cfg=cfg+1;
    PMA_Base[cfg] = 64'h0000_0001_8000_0000;
    PMA_Size[cfg] = 64'h0000_0000_0FFF_FFFF;
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

