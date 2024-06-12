//NOTE: This is generated include file from 'regbit_defines.cfg'
//      Do NOT Modify here. Change the config file and generate this file again

`ifndef INC_REGBIT_DEFINES
`define INC_REGBIT_DEFINES

//--------------------------------------------------------------------
// IFU Register Bit Fields
//--------------------------------------------------------------------

// Bundle Defines
`define BUNDLE_VALID                    0+:1
`define BUNDLE_FETCHPC                  1+:64
`define BUNDLE_INSTR                    65+:32
`define BUNDLE_IS16BIT                  97+:1
`define BUNDLE_BINDEX                   98+:3
`define BUNDLE_PC                       101+:64
`define BUNDLE_LEN                      (165)

// BTB Entry Structure
`define BTB_ENTRY_VALID                 0+:1
`define BTB_ENTRY_BRTYPE                1+:3
`define BTB_ENTRY_BINDX                 4+:3
`define BTB_ENTRY_TARGETPC              7+:64
`define BTB_ENTRY_2BC                   71+:2
`define BTB_ENTRY_2BC_MSB               72
`define BTB_ENTRY_FTAG                  73+:55
`define BTB_ENTRY_LEN                   (128)

// IB Entry Structure
`define IB_ENTRY_VALID                  0+:1
`define IB_ENTRY_PC                     1+:64
`define IB_ENTRY_INSTR                  65+:32
`define IB_ENTRY_IS16BIT                97+:1
`define IB_ENTRY_FETCHPCL               98+:5
`define IB_ENTRY_BINDEX                 103+:3
`define IB_ENTRY_BRTYPE                 106+:3
`define IB_ENTRY_BRTARGET               109+:64
`define IB_ENTRY_BRTAKEN                173+:1
`define IB_ENTRY_DP2BC                  174+:2
`define IB_ENTRY_BTB2BC                 176+:2
`define IB_ENTRY_BTBHIT                 178+:1
`define IB_ENTRY_EXCEPTION              179+:1
`define IB_ENTRY_ECAUSE                 180+:4
`define IB_ENTRY_BTBWAY                 184+:2
`define IB_ENTRY_LEN                    (186)

//--------------------------------------------------------------------
// EX Register Bit Fields
//--------------------------------------------------------------------

// uOP MEM Controls
`define UOP_MEM_IS_ATOMIC               0+:1
`define UOP_MEM_DATA_TYPE               1+:3
`define UOP_MEM_AMO_SUBOP               4+:4
`define UOP_MEM_AMO_DATA                8+:2
`define UOP_MEM_LSORDERTAG              10+:3
`define UOP_MEM_LEN                     (13)
`define UOP_MEM_CTRL_LEN                13

// uOP Branch Controls
`define UOP_BR_TYPE                     0+:3
`define UOP_BR_SUBTYPE                  3+:3
`define UOP_BR_IS_JAL                   6+:1
`define UOP_BR_IS_JALR                  7+:1
`define UOP_BR_FETCHPCL                 8+:5
`define UOP_BR_BINDEX                   13+:3
`define UOP_BR_IS_16BIT                 16+:1
`define UOP_BR_TARGET                   17+:64
`define UOP_BR_TAKEN                    81+:1
`define UOP_BR_DP2BC                    82+:2
`define UOP_BR_BTB2BC                   84+:2
`define UOP_BR_BTBHIT                   86+:1
`define UOP_BR_BTBWAY                   87+:2
`define UOP_BR_SPECTAG                  89+:8
`define UOP_BR_LEN                      (97)
`define UOP_BR_CTRL_LEN                 97

// uOP System Controls
`define UOP_SYS_IS_FENCE                0+:1
`define UOP_SYS_IS_FENCEI               1+:1
`define UOP_SYS_IS_URET                 2+:1
`define UOP_SYS_IS_SRET                 3+:1
`define UOP_SYS_IS_MRET                 4+:1
`define UOP_SYS_IS_WFI                  5+:1
`define UOP_SYS_IS_SFENCEVMA            6+:1
`define UOP_SYS_IS_ECALL                7+:1
`define UOP_SYS_IS_EBRK                 8+:1
`define UOP_SYS_IS_CSR                  9+:1
`define UOP_SYS_CSR_SUBOP               10+:3
`define UOP_SYS_CSR_DATA                13+:5
`define UOP_SYS_DATA                    18+:25
`define UOP_SYS_IS_16BIT                43+:1
`define UOP_SYS_LEN                     (44)
`define UOP_SYS_CTRL_LEN                44

// uOP FPU Controls
`define UOP_FPU_IS_DP                   0+:1
`define UOP_FPU_IS_RS3                  1+:1
`define UOP_FPU_OP                      2+:3
`define UOP_FPU_SUBOP                   5+:3
`define UOP_FPU_ROUND                   8+:3
`define UOP_FPU_IS_WORD                 11+:1
`define UOP_FPU_LEN                     (12)
`define UOP_FPU_CTRL_LEN                12

// uOP INT Controls
`define UOP_INT_IS_LUI                  0+:1
`define UOP_INT_IS_AUIPC                1+:1
`define UOP_INT_ALUOP                   2+:4
`define UOP_INT_MULDIVOP                6+:2
`define UOP_INT_IS_WORD                 8+:1
`define UOP_INT_LEN                     (9)
`define UOP_INT_CTRL_LEN                9

// Max Control Length
`define UOP_CONTROL_LEN                 97

// Decoded uOP Signals
`define UOP_VALID                       0+:1
`define UOP_PC                          1+:64
`define UOP_KILLMASK                    65+:8
`define UOP_SPECTAG                     73+:8
`define UOP_WAIT_TILL_EMPTY             81+:1
`define UOP_STALL_TILL_RETIRE           82+:1
`define UOP_REG_WE                      83+:1
`define UOP_EXCEPTION                   84+:1
`define UOP_ECAUSE                      85+:4
`define UOP_FUTYPE                      89+:4
`define UOP_INSTR                       93+:32
`define UOP_IMM                         125+:32
`define UOP_RD_TYPE                     157+:1
`define UOP_RS1_TYPE                    158+:1
`define UOP_RS2_TYPE                    159+:1
`define UOP_PRD                         160+:6
`define UOP_PRS1                        166+:6
`define UOP_PRS2                        172+:6
`define UOP_PRS3                        178+:6
`define UOP_OP1_SEL                     184+:2
`define UOP_OP2_SEL                     186+:2
`define UOP_OP3_SEL                     188+:1
`define UOP_RSTYPE                      189+:2
`define UOP_IS_RD                       191+:1
`define UOP_IS_RS1                      192+:1
`define UOP_IS_RS2                      193+:1
`define UOP_IS_RS3                      194+:1
`define UOP_RD                          195+:5
`define UOP_RS1                         200+:5
`define UOP_RS2                         205+:5
`define UOP_RS3                         210+:5

// Instr Specific Controls
`define UOP_CONTROLS_START              215
`define UOP_CONTROLS                    215+:97
`define UOP_LEN                         (312)

// Reservation Station (RS) Layout Defines

// RS Tag Part
`define RS_VALID                        0+:1
`define RS_VALID__BIT                   0
`define RS_KILLMASK                     1+:8
`define RS_PRS1_RDY                     9+:1
`define RS_PRS2_RDY                     10+:1
`define RS_PRS3_RDY                     11+:1
`define RS_TAG_LEN                      12

`define RS_ROBIDX                       12+:6
`define RS_PC                           18+:64
`define RS_REG_WE                       82+:1
`define RS_RD_TYPE                      83+:1
`define RS_PRD                          84+:6
`define RS_RS1_TYPE                     90+:1
`define RS_PRS1                         91+:6
`define RS_RS2_TYPE                     97+:1
`define RS_PRS2                         98+:6
`define RS_IMM                          104+:32
`define RS_IMM__SIGN_BIT                135
`define RS_OP1_SEL                      136+:2
`define RS_OP2_SEL                      138+:2
`define RS_OP3_SEL                      140+:1
`define RS_FUTYPE                       141+:4
`define RS_LEN                          (145)

// RS Type Specific
`define RS_CONTROL_START                145
`define RS_INT_CTRLS                    145+:9
`define RS_INT_LEN                      154
`define RS_MEM_CTRLS                    145+:13
`define RS_MEM_LEN                      158
`define RS_BR_CTRLS                     145+:97
`define RS_BR_LEN                       242
`define RS_SYS_CTRLS                    145+:44
`define RS_SYS_LEN                      189
`define RS_FPU_CTRLS                    145+:12
`define RS_FPU_PRS3                     157+:6
`define RS_FPU_LEN                      163
`define RS_MAX_LEN                      242

// Scheduler Port Layout
`define PORT_S2E_VALID                  0+:1
`define PORT_S2E_KILLMASK               1+:8
`define PORT_S2E_ROB_INDEX              9+:6
`define PORT_S2E_PRD_TYPE               15+:1
`define PORT_S2E_PRD                    16+:6
`define PORT_S2E_REG_WE                 22+:1
`define PORT_S2E_OP1                    23+:64
`define PORT_S2E_OP2                    87+:64
`define PORT_S2E_OP3                    151+:64
`define PORT_S2E_FUTYPE                 215+:4
`define PORT_S2E_PC                     219+:64
`define PORT_S2E_CONTROLS               283+:97
`define PORT_S2E_LEN                    (380)

// Execution Unit to Schedular Port
`define PORT_E2S_READY                  0+:1
`define PORT_E2S_FUMASK                 1+:16
`define PORT_E2S_LEN                    (17)

// ROB Layout Defines
`define ROB_VALID                       0+:1
`define ROB_BUSY                        1+:1
`define ROB_PC                          2+:64
`define ROB_KILLMASK                    66+:8
`define ROB_WAIT_TILL_EMPTY             74+:1
`define ROB_STALL_TILL_RETIRE           75+:1
`define ROB_EXCEPTION                   76+:1
`define ROB_ECAUSE                      77+:4
`define ROB_UOP_RD                      81+:5
`define ROB_UOP_RDTYPE                  86+:1
`define ROB_UOP_PRD                     87+:6
`define ROB_REG_WE                      93+:1
`define ROB_METADATA                    94+:64
`define ROB_INSTR                       158+:32
`define ROB_LEN                         (190)

// ROB Metadata Masks
`define METADATA_DATA                   0+:59
`define METADATA_UNUSED                 59+:1
`define METADATA_SYS_ID                 60+:1
`define METADATA_BRANCH_ID              61+:1
`define METADATA_FPUOP_ID               62+:1
`define METADATA_STORE_ID               63+:1
`define METADATA_LEN                    (64)

// Metadata Field Typedefs
`define METADATA_STORE__SBIDX           0+:3
`define METADATA_FPUOP__DIRTY           6
`define METADATA_FPUOP__FFLAGS_WE       5
`define METADATA_FPUOP__FFLAGS          0+:5
`define METADATA_BRANCH__BRTAKEN        0
`define METADATA_SYS__RETMODE           0+:2
`define METADATA_SYS__ISXRET            2
`define METADATA_SYS__FLUSHPIPE         3

//--------------------------------------------------------------------
// LSU Register Bit Fields
//--------------------------------------------------------------------

// SB Entry Defines
`define SB_ENTRY_VALID                  0+:1
`define SB_ENTRY_RETIRED                1+:1
`define SB_ENTRY_KILLED                 2+:1
`define SB_ENTRY_DATATYPE               3+:3
`define SB_ENTRY_KILLMASK               6+:8
`define SB_ENTRY_MASK                   14+:16
`define SB_ENTRY_PADDR                  30+:56
`define SB_ENTRY_DATA                   86+:64
`define SB_ENTRY_LEN                    (150)

//--------------------------------------------------------------------
// Misc Defines
//--------------------------------------------------------------------
`define UOP_MEM_LSORDERTAG__ABS         (215+10)+:3
`define UOP_BR_SPECTAG__ABS             (215+89)+:8

`endif

// Generated File 'regbit_defines.vh' Ends

