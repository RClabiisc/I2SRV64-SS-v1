`ifndef INC_ISA_PRIV_DEFINES
`define INC_ISA_PRIV_DEFINES

/*****************************************************************************
*                            Privileged Defines                             *
*****************************************************************************/
//Privilege Levels
`define PRIV_LVL_M                      2'b11
`define PRIV_LVL_H                      2'b10
`define PRIV_LVL_S                      2'b01
`define PRIV_LVL_U                      2'b00
`define PRIV_LVL__LEN                   (2)


/*****************************************************************************
*                                CSR Defines                                *
*****************************************************************************/
//General Defines
`define CSR_ADDR_LEN                    (12)
`define CSR_ACCESS_RANGE                11:10
`define CSR_PRIV_RANGE                  9:8


//User Trap Setup (For N Extention Only)
`define CSR_USTATUS                     12'h000
`define CSR_UIE                         12'h004
`define CSR_UTVEC                       12'h005

//User Trap Handling (For N Extension Only)
`define CSR_USCRATCH                    12'h040
`define CSR_UEPC                        12'h041
`define CSR_UCAUSE                      12'h042
`define CSR_UTVAL                       12'h043
`define CSR_UIP                         12'h044

//User Floating Point CSRs
`define CSR_FFLAGS                      12'h001
`define CSR_FRM                         12'h002
`define CSR_FCSR                        12'h003

//User Counter/Timers
`define CSR_CYCLE                       12'hC00
`define CSR_TIME                        12'hC01
`define CSR_INSTRET                     12'hC02
`define CSR_HPMCOUNTER3                 12'hC03
`define CSR_HPMCOUNTER4                 12'hC04
`define CSR_HPMCOUNTER5                 12'hC05
`define CSR_HPMCOUNTER6                 12'hC06
`define CSR_HPMCOUNTER7                 12'hC07
`define CSR_HPMCOUNTER8                 12'hC08
`define CSR_HPMCOUNTER9                 12'hC09
`define CSR_HPMCOUNTER10                12'hC0A
`define CSR_HPMCOUNTER11                12'hC0B
`define CSR_HPMCOUNTER12                12'hC0C
`define CSR_HPMCOUNTER13                12'hC0D
`define CSR_HPMCOUNTER14                12'hC0E
`define CSR_HPMCOUNTER15                12'hC0F
`define CSR_HPMCOUNTER16                12'hC10
`define CSR_HPMCOUNTER17                12'hC11
`define CSR_HPMCOUNTER18                12'hC12
`define CSR_HPMCOUNTER19                12'hC13
`define CSR_HPMCOUNTER20                12'hC14
`define CSR_HPMCOUNTER21                12'hC15
`define CSR_HPMCOUNTER22                12'hC16
`define CSR_HPMCOUNTER23                12'hC17
`define CSR_HPMCOUNTER24                12'hC18
`define CSR_HPMCOUNTER25                12'hC19
`define CSR_HPMCOUNTER26                12'hC1A
`define CSR_HPMCOUNTER27                12'hC1B
`define CSR_HPMCOUNTER28                12'hC1C
`define CSR_HPMCOUNTER29                12'hC1D
`define CSR_HPMCOUNTER30                12'hC1E
`define CSR_HPMCOUNTER31                12'hC1F

//Supervisor Trap Setup
`define CSR_SSTATUS                     12'h100
`define CSR_SEDELEG                     12'h102
`define CSR_SIDELEG                     12'h103
`define CSR_SIE                         12'h104
`define CSR_STVEC                       12'h105
`define CSR_SCOUNTEREN                  12'h106

//Supervisor Trap Handling
`define CSR_SSCRATCH                    12'h140
`define CSR_SEPC                        12'h141
`define CSR_SCAUSE                      12'h142
`define CSR_STVAL                       12'h143
`define CSR_SIP                         12'h144

//Supervisor Protection and Translation
`define CSR_SATP                        12'h180

//Machine Information Registers
`define CSR_MVENDORID                   12'hF11
`define CSR_MARCHID                     12'hF12
`define CSR_MIMPID                      12'hF13
`define CSR_MHARTID                     12'hF14

//Machine Trap Setup
`define CSR_MSTATUS                     12'h300
`define CSR_MISA                        12'h301
`define CSR_MEDELEG                     12'h302
`define CSR_MIDELEG                     12'h303
`define CSR_MIE                         12'h304
`define CSR_MTVEC                       12'h305
`define CSR_MCOUNTEREN                  12'h306

//Machine Trap Handling
`define CSR_MSCRATCH                    12'h340
`define CSR_MEPC                        12'h341
`define CSR_MCAUSE                      12'h342
`define CSR_MTVAL                       12'h343
`define CSR_MIP                         12'h344

//Machine Memory Protection
`define CSR_PMPCFG0                     12'h3A0
`define CSR_PMPCFG2                     12'h3A2
`define CSR_PMPADDR0                    12'h3B0
`define CSR_PMPADDR1                    12'h3B1
`define CSR_PMPADDR2                    12'h3B2
`define CSR_PMPADDR3                    12'h3B3
`define CSR_PMPADDR4                    12'h3B4
`define CSR_PMPADDR5                    12'h3B5
`define CSR_PMPADDR6                    12'h3B6
`define CSR_PMPADDR7                    12'h3B7
`define CSR_PMPADDR8                    12'h3B8
`define CSR_PMPADDR9                    12'h3B9
`define CSR_PMPADDR10                   12'h3BA
`define CSR_PMPADDR11                   12'h3BB
`define CSR_PMPADDR12                   12'h3BC
`define CSR_PMPADDR13                   12'h3BD
`define CSR_PMPADDR14                   12'h3BE
`define CSR_PMPADDR15                   12'h3BF

//Machine Counter/Timers
`define CSR_MCYCLE                      12'hB00
`define CSR_MINSTRET                    12'hB01
`define CSR_MHPMCOUNTER3                12'hB03
`define CSR_MHPMCOUNTER4                12'hB04
`define CSR_MHPMCOUNTER5                12'hB05
`define CSR_MHPMCOUNTER6                12'hB06
`define CSR_MHPMCOUNTER7                12'hB07
`define CSR_MHPMCOUNTER8                12'hB08
`define CSR_MHPMCOUNTER9                12'hB09
`define CSR_MHPMCOUNTER10               12'hB0A
`define CSR_MHPMCOUNTER11               12'hB0B
`define CSR_MHPMCOUNTER12               12'hB0C
`define CSR_MHPMCOUNTER13               12'hB0D
`define CSR_MHPMCOUNTER14               12'hB0E
`define CSR_MHPMCOUNTER15               12'hB0F
`define CSR_MHPMCOUNTER16               12'hB10
`define CSR_MHPMCOUNTER17               12'hB11
`define CSR_MHPMCOUNTER18               12'hB12
`define CSR_MHPMCOUNTER19               12'hB13
`define CSR_MHPMCOUNTER20               12'hB14
`define CSR_MHPMCOUNTER21               12'hB15
`define CSR_MHPMCOUNTER22               12'hB16
`define CSR_MHPMCOUNTER23               12'hB17
`define CSR_MHPMCOUNTER24               12'hB18
`define CSR_MHPMCOUNTER25               12'hB19
`define CSR_MHPMCOUNTER26               12'hB1A
`define CSR_MHPMCOUNTER27               12'hB1B
`define CSR_MHPMCOUNTER28               12'hB1C
`define CSR_MHPMCOUNTER29               12'hB1D
`define CSR_MHPMCOUNTER30               12'hB1E
`define CSR_MHPMCOUNTER31               12'hB1F

//Machine Counter Setup
`define CSR_MCOUNTINHIBIT               12'h320
`define CSR_MHPMEVENT3                  12'h323
`define CSR_MHPMEVENT4                  12'h324
`define CSR_MHPMEVENT5                  12'h325
`define CSR_MHPMEVENT6                  12'h326
`define CSR_MHPMEVENT7                  12'h327
`define CSR_MHPMEVENT8                  12'h328
`define CSR_MHPMEVENT9                  12'h329
`define CSR_MHPMEVENT10                 12'h32A
`define CSR_MHPMEVENT11                 12'h32B
`define CSR_MHPMEVENT12                 12'h32C
`define CSR_MHPMEVENT13                 12'h32D
`define CSR_MHPMEVENT14                 12'h32E
`define CSR_MHPMEVENT15                 12'h32F
`define CSR_MHPMEVENT16                 12'h330
`define CSR_MHPMEVENT17                 12'h331
`define CSR_MHPMEVENT18                 12'h332
`define CSR_MHPMEVENT19                 12'h333
`define CSR_MHPMEVENT20                 12'h334
`define CSR_MHPMEVENT21                 12'h335
`define CSR_MHPMEVENT22                 12'h336
`define CSR_MHPMEVENT23                 12'h337
`define CSR_MHPMEVENT24                 12'h338
`define CSR_MHPMEVENT25                 12'h339
`define CSR_MHPMEVENT26                 12'h33A
`define CSR_MHPMEVENT27                 12'h33B
`define CSR_MHPMEVENT28                 12'h33C
`define CSR_MHPMEVENT29                 12'h33D
`define CSR_MHPMEVENT30                 12'h33E
`define CSR_MHPMEVENT31                 12'h33F

//Debug/Trace Registers (shared with Debug Mode)
`define CSR_TSELECT                     12'h7A0
`define CSR_TDATA1                      12'h7A1
`define CSR_TDATA2                      12'h7A2
`define CSR_TDATA3                      12'h7A3

//Debug Mode Registers
`define CSR_DCSR                        12'h7B0
`define CSR_DPC                         12'h7B1
`define CSR_DSCRATCH0                   12'h7B2
`define CSR_DSCRATCH1                   12'h7B3


/*****************************************************************************
*                          CSR Field Type Defines                           *
*****************************************************************************/
//NOTE: Define Format : <csr Name>_<Field Name>_<Bit/Enum Name>
// xstatus Typedefs
`define XSTATUS_UIE                     0
`define XSTATUS_SIE                     1
`define XSTATUS_MIE                     3
`define XSTATUS_UPIE                    4
`define XSTATUS_SPIE                    5
`define XSTATUS_MPIE                    7
`define XSTATUS_SPP                     8
`define XSTATUS_MPP                     11+:2
`define XSTATUS_FS                      13+:2
`define XSTATUS_XS                      15+:2
`define XSTATUS_MPRV                    17
`define XSTATUS_SUM                     18
`define XSTATUS_MXR                     19
`define XSTATUS_TVM                     20
`define XSTATUS_TW                      21
`define XSTATUS_TSR                     22
`define XSTATUS_UXL                     32+:2
`define XSTATUS_SXL                     34+:2
`define XSTATUS_SD                      63

`define XSTATUS_FS__OFF                 2'b00
`define XSTATUS_FS__INITIAL             2'b01
`define XSTATUS_FS__CLEAN               2'b10
`define XSTATUS_FS__DIRTY               2'b11
`define XSTATUS_FS_LEN                  (2)
`define XSTATUS_XS__OFF                 2'b00
`define XSTATUS_XS__INITIAL             2'b01
`define XSTATUS_XS__CLEAN               2'b10
`define XSTATUS_XS__DIRTY               2'b11
`define XSTATUS_XS_LEN                  (2)
`define XSTATUS_XLEN__64                2'b10

// xtvec Typedefs
`define XTVEC_MODE_RANGE                0+:2
`define XTVEC_MODE__DIRECT              2'b00
`define XTVEC_MODE__VECTORED            2'b01
`define XTVEC_MODE__RESETVED2           2'b10
`define XTVEC_MODE__RESETVED3           2'b11
`define XTVEC_MODE_LEN                  (2)

`define XTVEC_BASE_RANGE                2+:62
`define XTVEC_BASE_LEN                  (62)

// Interrupt Typedefs
`define ISA_IRQ_U_SOFT                  4'd0
`define ISA_IRQ_S_SOFT                  4'd1
`define ISA_IRQ_M_SOFT                  4'd3
`define ISA_IRQ_U_TIMER                 4'd4
`define ISA_IRQ_S_TIMER                 4'd5
`define ISA_IRQ_M_TIMER                 4'd7
`define ISA_IRQ_U_EXT                   4'd8
`define ISA_IRQ_S_EXT                   4'd9
`define ISA_IRQ_M_EXT                   4'd11

// Exception Typedefs
`define ISA_EXC_IADDR_MISALIGN          4'd0
`define ISA_EXC_IACCESS_FAULT           4'd1
`define ISA_EXC_ILLEGAL_INSTR           4'd2
`define ISA_EXC_BREAKPOINT              4'd3
`define ISA_EXC_LADDR_MISALIGN          4'd4
`define ISA_EXC_LACCESS_FAULT           4'd5
`define ISA_EXC_SADDR_MISALIGN          4'd6
`define ISA_EXC_SACCESS_FAULT           4'd7
`define ISA_EXC_ECALL_UMODE             4'd8
`define ISA_EXC_ECALL_SMODE             4'd9
`define ISA_EXC_RESERVED                4'd10
`define ISA_EXC_ECALL_MMODE             4'd11
`define ISA_EXC_IPAGE_FAULT             4'd12
`define ISA_EXC_LPAGE_FAULT             4'd13
`define ISA_EXC_RESERVED_STD            4'd14
`define ISA_EXC_SPAGE_FAULT             4'd15

// pmpcfg Typedefs
`define PMPCFG_READ                     0
`define PMPCFG_WRITE                    1
`define PMPCFG_EXECUTE                  2
`define PMPCFG_ACCESS                   0+:3
`define PMPCFG_ADDRMODE                 3+:2
`define PMPCFG_RESERVED                 5+:2
`define PMPCFG_LOCK                     7
`define PMPCFG__LEN                     (8)

`define PMPCFG_ADDRMODE__OFF            2'b00
`define PMPCFG_ADDRMODE__TOR            2'b01
`define PMPCFG_ADDRMODE__NA4            2'b10
`define PMPCFG_ADDRMODE__NAPOT          2'b11
`define PMPCFG_ADDRMODE_LEN             (2)

// pmpaddr Typedefs
`define PMPADDR__LEN                    (54)
`define PMPADDR_ADDR_RANGE              55:2

// satp Typedefs
`define SATP_MODE_RANGE                 60+:4
`define SATP_MODE__BARE                 4'd0
`define SATP_MODE__SV39                 4'd8
`define SATP_MODE__SV48                 4'd9
`define SATP_MODE_LEN                   (4)

`define SATP_ASID_RANGE                 44+:16
`define SATP_ASID_LEN                   16

`define SATP_PPN_RANGE                  0+:44
`define SATP_PPN_LEN                    (44)

// fcsr Typedefs
`define FCSR_FFLAGS_RANGE               0+:5
`define FCSR_FRM_RANGE                  5+:3
`define FCSR_LEN                        (8)

`define FCSR_FFLAGS_NX                  0
`define FCSR_FFLAGS_UF                  1
`define FCSR_FFLAGS_OF                  2
`define FCSR_FFLAGS_DZ                  3
`define FCSR_FFLAGS_NV                  4
`define FCSR_FFLAGS_LEN                 (5)

`define FCSR_FRM_RNE                    3'b000
`define FCSR_FRM_RTZ                    3'b001
`define FCSR_FRM_RDN                    3'b010
`define FCSR_FRM_RUP                    3'b011
`define FCSR_FRM_RMM                    3'b100
`define FCSR_FRM_INVALID5               3'b101
`define FCSR_FRM_INVALID6               3'b110
`define FCSR_FRM_DYN                    3'b111
`define FCSR_FRM_LEN                    (3)

// hpm counter Typedefs
`define HPM_CYCLE                       0
`define HPM_TIME                        1
`define HPM_INSTRET                     2

/*****************************************************************************
*                         CSR ISA Level Masks                                *
*****************************************************************************/
// [xstatus] ISA Level Masks (As Per Priv Spec, Implementation might override)
//M Rd: SD, SXL, UXL, TSR, TW, TVM, MXR, SUM, MPRV, XS, FS, MPP, SPP, MPIE, SPIE, UPIE, MIE, SIE, UIE
`define ISA_XSTATUS_M_RD_MASK           64'h8000000F007FF9BB

//S Rd: SD,      UXL,               MXR, SUM,       XS, FS,      SPP,       SPIE, UPIE,      SIE, UIE
`define ISA_XSTATUS_S_RD_MASK           64'h80000003000DE133

//U Rd:                                                                           UPIE,           UIE
`define ISA_XSTATUS_U_RD_MASK           64'h0000000000000011

//M Wr:     SXL, UXL, TSR, TW, TVM, MXR, SUM, MPRV,     FS, MPP, SPP, MPIE, SPIE, UPIE, MIE, SIE, UIE
`define ISA_XSTATUS_M_WR_MASK           64'h0000000F007E79BB

//S Wr:          UXL,               MXR, SUM,           FS,      SPP,       SPIE, UPIE,      SIE, UIE
`define ISA_XSTATUS_S_WR_MASK           64'h00000003000C6133

//U Rd:                                                                           UPIE,           UIE
`define ISA_XSTATUS_U_WR_MASK           64'h0000000000000011

// [xie] ISA Level Masks (As per Priv Spec, Implementation may override)
//M Rd: MEIE, SEIE, UEIE, MTIE, STIE, UTIE, MSIE, SSIE, USIE
`define ISA_XIE_M_RD_MASK               64'h0000000000000BBB

//S Rd:       SEIE, UEIE,       STIE, UTIE,       SSIE, USIE
`define ISA_XIE_S_RD_MASK               64'h0000000000000333

//U Rd:             UEIE,             UTIE,             USIE
`define ISA_XIE_U_RD_MASK               64'h0000000000000111

//M Wr: MEIE, SEIE, UEIE, MTIE, STIE, UTIE, MSIE, SSIE, USIE
`define ISA_XIE_M_WR_MASK               64'h0000000000000BBB

//S Wr:       SEIE, UEIE,       STIE, UTIE,       SSIE, USIE
`define ISA_XIE_S_WR_MASK               64'h0000000000000333

//U Wr:             UEIE,             UTIE,             USIE
`define ISA_XIE_U_WR_MASK               64'h0000000000000111


// [xip] ISA Level Masks (As per Priv Spec, Implementation may override)
//M Rd: MEIP, SEIP, UEIP, MTIP, STIP, UTIP, MSIP, SSIP, USIP
`define ISA_XIP_M_RD_MASK               64'h0000000000000BBB

//S Rd:       SEIP, UEIP,       STIP, UTIP,       SSIP, USIP
`define ISA_XIP_S_RD_MASK               64'h0000000000000333

//U Rd:             UEIP,             UTIP,             USIP
`define ISA_XIP_U_RD_MASK               64'h0000000000000111

//M Wr:       SEIP, UEIP,       STIP, UTIP,       SSIP, USIP
`define ISA_XIP_M_WR_MASK               64'h0000000000000333

//S Wr:             UEIP,                         SSIP, USIP
`define ISA_XIP_S_WR_MASK               64'h0000000000000103

//U Wr:                                                 USIP
`define ISA_XIP_U_WR_MASK               64'h0000000000000001


// [medeleg] ISA Level Masks (As per Priv Spec, Implementation may override)
// Exception 11 can not be delegated
`define ISA_MEDELEG_MASK                64'h000000000000B3FF

// [mideleg] ISA Level Masks (As per Priv Spec, Implementation may override)
`define ISA_MIDELEG_MASK                64'h0000000000000BBB

`endif

