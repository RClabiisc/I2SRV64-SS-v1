//NOTE: This is generated include file from 'bus_defines.cfg'
//      Do NOT Modify here. Change the config file and generate this file again

`ifndef INC_BUS_DEFINES
`define INC_BUS_DEFINES

//--------------------------------------------------------------------
// Global Busses
//--------------------------------------------------------------------

// Branch Checker Response Bus
`define BC_RESP_VALID                   0+:1
`define BC_RESP_PC                      1+:64
`define BC_RESP_FETCHPCL                65+:5
`define BC_RESP_BINDX                   70+:3
`define BC_RESP_BRTYPE                  73+:3
`define BC_RESP_BRTARGET                76+:64
`define BC_RESP_BRTAKEN                 140+:1
`define BC_RESP_BTB2BC                  141+:2
`define BC_RESP_BTBHIT                  143+:1
`define BC_RESP_BTBWAY                  144+:2
`define BC_RESP_PUSH_DATA               146+:64
`define BC_RESP_BRANCH_MASK             210+:8
`define BC_RESP_TAKEN_MASK              218+:8
`define BC_RESP_IS16BIT                 226+:1
`define BC_RESP_LEN                     (227)

// Branch (Resolution) Unit Result Bus
`define FUBR_RESULT_VALID               0+:1
`define FUBR_RESULT_PC                  1+:64
`define FUBR_RESULT_FETCHPCL            65+:5
`define FUBR_RESULT_BINDX               70+:3
`define FUBR_RESULT_BRTYPE              73+:3
`define FUBR_RESULT_BRTARGET            76+:64
`define FUBR_RESULT_BRTAKEN             140+:1
`define FUBR_RESULT_DP2BC               141+:2
`define FUBR_RESULT_BTB2BC              143+:2
`define FUBR_RESULT_BTBHIT              145+:1
`define FUBR_RESULT_SPECTAG             146+:8
`define FUBR_RESULT_MISPRED             154+:1
`define FUBR_RESULT_BTBWAY              155+:2
`define FUBR_RESULT_ISSPEC              157+:1
`define FUBR_RESULT_ROBIDX              158+:6
`define FUBR_RESULT_IS16BIT             164+:1
`define FUBR_RESULT_LEN                 (165)

// Retire to Sysctl Bus
`define RETIRE2SYSCTL_EXCEPTION         0+:1
`define RETIRE2SYSCTL_ECAUSE            1+:4
`define RETIRE2SYSCTL_EXC_PC_VALID      5+:1
`define RETIRE2SYSCTL_EXC_PC            6+:64
`define RETIRE2SYSCTL_TRAP_VAL          70+:64
`define RETIRE2SYSCTL_IS_XRET           134+:1
`define RETIRE2SYSCTL_RETMODE           135+:2
`define RETIRE2SYSCTL_FPU_DIRTY         137+:1
`define RETIRE2SYSCTL_FCSR_WE           138+:1
`define RETIRE2SYSCTL_FCSR              139+:5
`define RETIRE2SYSCTL_IS_FLUSHPIPE      144+:1
`define RETIRE2SYSCTL_RETIRECNT         145+:3
`define RETIRE2SYSCTL_LEN               (148)

// Retire to LSU Store Buffer PORT Bus
`define RETIRE2LSU_PORT_VALID           0+:1
`define RETIRE2LSU_PORT_SBIDX           1+:3
`define RETIRE2LSU_PORT_LEN             (4)

// Retire to Rename PORT Bus
`define RETIRE2RENAME_PORT_WE           0+:1
`define RETIRE2RENAME_PORT_RDTYPE       1+:1
`define RETIRE2RENAME_PORT_RD           2+:5
`define RETIRE2RENAME_PORT_PRD          7+:6
`define RETIRE2RENAME_PORT_LEN          (13)

// System FU to Sysctl Bus (Request)
`define SYS_REQ_CSR_WE                  0+:1
`define SYS_REQ_CSR_RE                  1+:1
`define SYS_REQ_CSR_ADDR                2+:12
`define SYS_REQ_CSR_DATA                14+:64
`define SYS_REQ_FENCE_REQ               78+:1
`define SYS_REQ_FENCE_DATA              79+:12
`define SYS_REQ_FENCEI_REQ              91+:1
`define SYS_REQ_SFENCE_REQ              92+:1
`define SYS_REQ_SFENCE_ASID             93+:64
`define SYS_REQ_SFENCE_VADDR            157+:64
`define SYS_REQ_LEN                     (221)

// Sysctl to System FU Bus (Response)
`define SYS_RESP_CSR_RDDATA             0+:64
`define SYS_RESP_EXCEPTION              64+:1
`define SYS_RESP_ECAUSE                 65+:4
`define SYS_RESP_PIPEFLUSH              69+:1
`define SYS_RESP_PRIV_LVL               70+:2
`define SYS_RESP_STATUS_TSR             72+:1
`define SYS_RESP_STATUS_TW              73+:1
`define SYS_RESP_STATUS_TVM             74+:1
`define SYS_RESP_FENCE_DONE             75+:1
`define SYS_RESP_FENCEI_DONE            76+:1
`define SYS_RESP_SFENCE_DONE            77+:1
`define SYS_RESP_LEN                    (78)

// Atomic Reservation Request Bus
`define AR_REQ_VALID                    0+:1
`define AR_REQ_ISLR                     1+:1
`define AR_REQ_ISWORD                   2+:1
`define AR_REQ_PADDR                    3+:56
`define AR_REQ_LEN                      (59)

// Atomic Reservation Response Bus
`define AR_RESP_DONE                    0+:1
`define AR_RESP_RESERVATION             1+:1
`define AR_RESP_LEN                     (2)

// FULD/FUST to LSU Bus (Request)
`define LSU_REQ_VALID                   0+:1
`define LSU_REQ_KILLED                  1+:1
`define LSU_REQ_OPER                    2+:3
`define LSU_REQ_DATA_TYPE               5+:3
`define LSU_REQ_KILLMASK                8+:8
`define LSU_REQ_ORDERTAG                16+:3
`define LSU_REQ_VADDR                   19+:64
`define LSU_REQ_ST_DATA                 83+:64
`define LSU_REQ_AMO_DATA                147+:2
`define LSU_REQ_LEN                     (149)

// LSU to FULD/FUST Bus (Response)
`define LSU_RESP_DONE                   0+:1
`define LSU_RESP_READY                  1+:1
`define LSU_RESP_DATA                   2+:64
`define LSU_RESP_EXCEPTION              66+:1
`define LSU_RESP_ECAUSE                 67+:4
`define LSU_RESP_LEN                    (71)

//--------------------------------------------------------------------
// EX Internal Busses
//--------------------------------------------------------------------

// Wakeup Bus
`define WAKEUP_RESP_VALID               0+:1
`define WAKEUP_RESP_PRD_TYPE            1+:1
`define WAKEUP_RESP_PRD                 2+:6
`define WAKEUP_RESP_REG_WE              8+:1
`define WAKEUP_RESP_ROB_INDEX           9+:6
`define WAKEUP_RESP_EXCEPTION           15+:1
`define WAKEUP_RESP_ECAUSE              16+:4
`define WAKEUP_RESP_METADATA            20+:64
`define WAKEUP_RESP_LEN                 (84)

// Execution Unit Result Bus
`define RESULT_VALID                    0+:1
`define RESULT_REG_WE                   1+:1
`define RESULT_PRD_TYPE                 2+:1
`define RESULT_PRD                      3+:6
`define RESULT_VALUE                    9+:64
`define RESULT_LEN                      (73)

//--------------------------------------------------------------------
// LSU Internal Busses
//--------------------------------------------------------------------

// Store Buffer Write Request Bus
`define SB_WR_REQ_VALID                 0+:1
`define SB_WR_REQ_DATA_TYPE             1+:3
`define SB_WR_REQ_KILLMASK              4+:8
`define SB_WR_REQ_PADDR                 12+:56
`define SB_WR_REQ_DATA                  68+:64
`define SB_WR_REQ_LEN                   (132)

// Load Buffer Match Request Bus
`define LB_MATCH_REQ_VALID              0+:1
`define LB_MATCH_REQ_PADDR              1+:56
`define LB_MATCH_REQ_BYTEMASK           57+:16
`define LB_MATCH_REQ_LEN                (73)

// Load Buffer Match Response Bus
`define LB_MATCH_RESP_VALID             0+:1
`define LB_MATCH_RESP_MATCHMASK         1+:16
`define LB_MATCH_RESP_BYTEDATA          17+:128
`define LB_MATCH_RESP_LEN               (145)

// Load Buffer Read Request Bus
`define LB_RD_REQ_VALID                 0+:1
`define LB_RD_REQ_KILLED                1+:1
`define LB_RD_REQ_DATATYPE              2+:3
`define LB_RD_REQ_PADDR                 5+:56
`define LB_RD_REQ_LEN                   (61)

// Load Buffer Read Response Bus
`define LB_RD_RESP_DONE                 0+:1
`define LB_RD_RESP_READY                1+:1
`define LB_RD_RESP_DATA                 2+:64
`define LB_RD_RESP_LEN                  (66)

`endif

// Generated File 'bus_defines.vh' Ends

