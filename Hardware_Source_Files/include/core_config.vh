//NOTE: This is generated include file from 'core_config.cfg'
//      Do NOT Modify here. Change the config file and generate this file again

`ifndef INC_CORE_CONFIG
`define INC_CORE_CONFIG

//--------------------------------------------------------------------
// Core uArch Configuration
//--------------------------------------------------------------------
`define XLEN                            64
`define PLEN                            56
`define VLEN                            39
`define FETCH_RATE                      16
`define DISPATCH_RATE                   4
`define SCHED_PORTS                     6
`define RETIRE_RATE                     4
`define SPEC_STATES                     8
`define INT_PRF_DEPTH                   64
`define FP_PRF_DEPTH                    48
`define LS_ORDER_TAG_LEN                3
`define STORE_BUFFER_DEPTH              8
`define RS_INT_DEPTH                    12
`define RS_FP_DEPTH                     8
`define RS_BR_DEPTH                     6
`define RS_MEM_DEPTH                    8
`define RS_INT_ISSUE_REQ                3
`define RS_FP_ISSUE_REQ                 2
`define RS_MEM_ISSUE_REQ                2
`define RS_INT_WINDOW                   8
`define RS_FP_WINDOW                    4
`define ROB_DEPTH                       44
`define RAS_DEPTH                       32
`define IB_DEPTH                        32
`define GHR_WIDTH                       8
`define ICACHE_LINE_SIZE                32
`define PMP_ENTRIES                     4
`define FAST_FORWARD                    1

//--------------------------------------------------------------------
// Implementation Level ISA Overrides
//--------------------------------------------------------------------
`define OOO_MISA                        64'h800000000014112D
`define OOO_VENDOR_ID                   64'h0
`define OOO_ARCH_ID                     64'h0
`define OOO_IMPL_ID                     64'h0000000000000005
`define OOO_XSTATUS_M_RD_MASK           (`ISA_XSTATUS_M_RD_MASK & ~64'h0000000000000011)
`define OOO_XSTATUS_S_RD_MASK           (`ISA_XSTATUS_S_RD_MASK & ~64'h0000000000000011)
`define OOO_XSTATUS_U_RD_MASK           (`ISA_XSTATUS_U_RD_MASK & ~64'h0000000000000011)
`define OOO_XSTATUS_M_WR_MASK           (`ISA_XSTATUS_M_WR_MASK & ~64'h0000000000000011)
`define OOO_XSTATUS_S_WR_MASK           (`ISA_XSTATUS_S_WR_MASK & ~64'h0000000000000011)
`define OOO_XSTATUS_U_WR_MASK           (`ISA_XSTATUS_U_WR_MASK & ~64'h0000000000000011)
`define OOO_XIE_M_WR_MASK               (`ISA_XIE_M_WR_MASK & ~64'h0000000000000111)
`define OOO_XIE_M_RD_MASK               (`ISA_XIE_M_RD_MASK & ~64'h0000000000000111)
`define OOO_XIP_M_RD_MASK               (`ISA_XIP_M_RD_MASK & ~64'h0000000000000111)
`define OOO_XIP_M_WR_MASK               (`ISA_XIP_M_WR_MASK & ~64'h0000000000000111)
`define OOO_XIP_S_WR_MASK               (`ISA_XIP_S_WR_MASK & ~64'h0000000000000111)
`define OOO_MEDELEG_MASK                `ISA_MEDELEG_MASK
`define OOO_MIDELEG_MASK                `ISA_MIDELEG_MASK

//--------------------------------------------------------------------
// SoC Level Defines
//--------------------------------------------------------------------
`define NMI_PC                          64'h0
`define PLIC_PRIORITY_LEVELS            8
`define C_AXI_IBUS_DATA_WIDTH           (64)
`define C_AXI_IBUS_ADDR_WIDTH           (64)
`define C_AXI_DBUS_DATA_WIDTH           (64)
`define C_AXI_DBUS_ADDR_WIDTH           (64)
`define C_AXI_PBUS_DATA_WIDTH           (32)
`define C_AXI_PBUS_ADDR_WIDTH           (32)

`endif

// Generated File 'core_config.vh' Ends

