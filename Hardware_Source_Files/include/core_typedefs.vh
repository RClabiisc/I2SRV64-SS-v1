//NOTE: This is generated include file from 'core_typedefs.cfg'
//      Do NOT Modify here. Change the config file and generate this file again

`ifndef INC_CORE_TYPEDEF
`define INC_CORE_TYPEDEF

// Branch Type (see docs/IFU) Refer 2.5 in RISC-V spec
`define BRANCH_TYPE_NONE                3'b000
`define BRANCH_TYPE_COND                3'b001
`define BRANCH_TYPE_JMP                 3'b011
`define BRANCH_TYPE_CALL                3'b101
`define BRANCH_TYPE_IJMP                3'b010
`define BRANCH_TYPE_ICALL               3'b100
`define BRANCH_TYPE_RET                 3'b110
`define BRANCH_TYPE_COROU               3'b111
`define BRANCH_TYPE__LEN                3

// Data Type
`define DATA_TYPE_B                     3'b000
`define DATA_TYPE_H                     3'b001
`define DATA_TYPE_W                     3'b010
`define DATA_TYPE_D                     3'b011
`define DATA_TYPE_BU                    3'b100
`define DATA_TYPE_HU                    3'b101
`define DATA_TYPE_WU                    3'b110
`define DATA_TYPE__LEN                  3

// Memory Access Types
`define MEM_ACCESS_READ                 3'b001
`define MEM_ACCESS_WRITE                3'b010
`define MEM_ACCESS_EXECUTE              3'b100
`define MEM_ACCESS_NONE                 3'b000
`define MEM_ACCESS__LEN                 3

// RS_Type
`define RS_TYPE_INT                     2'b00
`define RS_TYPE_FP                      2'b01
`define RS_TYPE_MEM                     2'b10
`define RS_TYPE_BR                      2'b11
`define RS_TYPE__LEN                    2

// FU_Type (NOTE: Do NOT change already assigned paires. For addition used unused values. Do NOT modify this mapping table)
`define FU_TYPE_IALU                    4'b0000
`define FU_TYPE_UNUSED1                 4'b0001
`define FU_TYPE_IMUL                    4'b0010
`define FU_TYPE_IDIV                    4'b0011
`define FU_TYPE_LOAD                    4'b0100
`define FU_TYPE_STORE                   4'b0101
`define FU_TYPE_UNUSED6                 4'b0110
`define FU_TYPE_UNUSED7                 4'b0111
`define FU_TYPE_FALU                    4'b1000
`define FU_TYPE_UNUSED9                 4'b1001
`define FU_TYPE_FMUL                    4'b1010
`define FU_TYPE_FDIV                    4'b1011
`define FU_TYPE_UNUSED12                4'b1100
`define FU_TYPE_UNUSED13                4'b1101
`define FU_TYPE_BRANCH                  4'b1110
`define FU_TYPE_SYSTEM                  4'b1111
`define FU_TYPE__LEN                    4
`define FU_MASK__LEN                    16

// Logical Reg Type
`define REG_TYPE_INT                    1'b0
`define REG_TYPE_FP                     1'b1
`define REG_TYPE__LEN                   1

// OP1 Select Types
`define OP1_SEL_RS1                     2'b00
`define OP1_SEL_R0                      2'b01
`define OP1_SEL_PC                      2'b10
`define OP1_SEL__LEN                    2

// OP2 Select Types
`define OP2_SEL_RS2                     2'b00
`define OP2_SEL_R0                      2'b01
`define OP2_SEL_IMM                     2'b10
`define OP2_SEL__LEN                    2

// OP3 Select Types
`define OP3_SEL_FRS3                    1'b1
`define OP3_SEL_IMM                     1'b0
`define OP3_SEL__LEN                    1

// Atomic Operation Types
`define AMO_OP_LR                       4'b1100
`define AMO_OP_SC                       4'b1110
`define AMO_OP_SWAP                     4'b1010
`define AMO_OP_ADD                      4'b0000
`define AMO_OP_XOR                      4'b0001
`define AMO_OP_AND                      4'b0011
`define AMO_OP_OR                       4'b0010
`define AMO_OP_MIN                      4'b0100
`define AMO_OP_MAX                      4'b0101
`define AMO_OP_MINU                     4'b0110
`define AMO_OP_MAXU                     4'b0111
`define AMO_OP__LEN                     4

// FPU Op Types
`define FPU_OP_ALU                      3'b000
`define FPU_OP_MUL                      3'b001
`define FPU_OP_DIV                      3'b010
`define FPU_OP_SQRT                     3'b011
`define FPU_OP_CMP                      3'b100
`define FPU_OP_CNV                      3'b101
`define FPU_OP_FMA                      3'b110
`define FPU_OP_TRN                      3'b111
`define FPU_OP__LEN                     3

// FPU SubOp Types
`define FPU_SUBOP_ALU_ADD               3'b000
`define FPU_SUBOP_ALU_SUB               3'b001
`define FPU_SUBOP_CMP_EQ                3'b000
`define FPU_SUBOP_CMP_LT                3'b001
`define FPU_SUBOP_CMP_LE                3'b010
`define FPU_SUBOP_CMP_MIN               3'b100
`define FPU_SUBOP_CMP_MAX               3'b101
`define FPU_SUBOP_CNV_FP2I              3'b000
`define FPU_SUBOP_CNV_FP2IU             3'b001
`define FPU_SUBOP_CNV_I2FP              3'b010
`define FPU_SUBOP_CNV_IU2FP             3'b011
`define FPU_SUBOP_CNV_SI                3'b100
`define FPU_SUBOP_CNV_SINEG             3'b101
`define FPU_SUBOP_CNV_SIXOR             3'b110
`define FPU_SUBOP_CNV_FP2FP             3'b111
`define FPU_SUBOP_FMADD                 3'b000
`define FPU_SUBOP_FMSUB                 3'b001
`define FPU_SUBOP_FNMADD                3'b010
`define FPU_SUBOP_FNMSUB                3'b011
`define FPU_SUBOP_TRN_INT2FP            3'b000
`define FPU_SUBOP_TRN_FP2INT            3'b001
`define FPU_SUBOP_TRN_FCLASS            3'b100
`define FPU_SUBOP__LEN                  3

// INT ALUop
`define INT_ALUOP_ADD                   4'b0000
`define INT_ALUOP_SUB                   4'b1000
`define INT_ALUOP_SLL                   4'b0001
`define INT_ALUOP_SLT                   4'b0010
`define INT_ALUOP_SLTU                  4'b0011
`define INT_ALUOP_XOR                   4'b0100
`define INT_ALUOP_SRL                   4'b0101
`define INT_ALUOP_SRA                   4'b1101
`define INT_ALUOP_OR                    4'b0110
`define INT_ALUOP_AND                   4'b0111
`define INT_ALUOP__LEN                  4

// INT MULDIVop
`define INT_MULOP_S                     2'b00
`define INT_MULOP_H                     2'b01
`define INT_MULOP_HU                    2'b10
`define INT_MULOP_HSU                   2'b11
`define INT_DIVOP_DIV                   2'b00
`define INT_DIVOP_DIVU                  2'b01
`define INT_DIVOP_REM                   2'b10
`define INT_DIVOP_REMU                  2'b11
`define INT_MULDIVOP__LEN               2

// Branch SubOp
`define BRANCH_SUBOP_EQ                 3'b000
`define BRANCH_SUBOP_NE                 3'b001
`define BRANCH_SUBOP_LT                 3'b100
`define BRANCH_SUBOP_GE                 3'b101
`define BRANCH_SUBOP_LTU                3'b110
`define BRANCH_SUBOP_GEU                3'b111
`define BRANCH_SUBOP__LEN               3

// LSU Operation
`define LSU_OPER_LOAD                   3'b000
`define LSU_OPER_STORE                  3'b001
`define LSU_OPER_AMOLOAD                3'b100
`define LSU_OPER_AMOSTORE               3'b101
`define LSU_OPER_AMOLR                  3'b110
`define LSU_OPER_AMOSC                  3'b111
`define LSU_OPER__LEN                   3

// Exception Causes Typedef
`define ECAUSE_LEN                      4
`define EXC_IADDR_MISALIGN              `ISA_EXC_IADDR_MISALIGN
`define EXC_IACCESS_FAULT               `ISA_EXC_IACCESS_FAULT
`define EXC_ILLEGAL_INSTR               `ISA_EXC_ILLEGAL_INSTR
`define EXC_BREAKPOINT                  `ISA_EXC_BREAKPOINT
`define EXC_LADDR_MISALIGN              `ISA_EXC_LADDR_MISALIGN
`define EXC_LACCESS_FAULT               `ISA_EXC_LACCESS_FAULT
`define EXC_SADDR_MISALIGN              `ISA_EXC_SADDR_MISALIGN
`define EXC_SACCESS_FAULT               `ISA_EXC_SACCESS_FAULT
`define EXC_ECALL_UMODE                 `ISA_EXC_ECALL_UMODE
`define EXC_ECALL_SMODE                 `ISA_EXC_ECALL_SMODE
`define EXC_ECALL_MMODE                 `ISA_EXC_ECALL_MMODE
`define EXC_IPAGE_FAULT                 `ISA_EXC_IPAGE_FAULT
`define EXC_LPAGE_FAULT                 `ISA_EXC_LPAGE_FAULT
`define EXC_SPAGE_FAULT                 `ISA_EXC_SPAGE_FAULT
`define EXC_IACCESS_FAULT_SPL           `ISA_EXC_RESERVED
`define EXC_IPAGE_FAULT_SPL             `ISA_EXC_RESERVED_STD

// Custom PMA Attribute TypeDefs
`define PMA_ATTR_READ                   0
`define PMA_ATTR_READ__ALLOW            1'b1
`define PMA_ATTR_READ__DENY             1'b0
`define PMA_ATTR_WRITE                  1
`define PMA_ATTR_WRITE__ALLOW           1'b1
`define PMA_ATTR_WRITE__DENY            1'b0
`define PMA_ATTR_EXECUTE                2
`define PMA_ATTR_EXECUTE__ALLOW         1'b1
`define PMA_ATTR_EXECUTE__DENY          1'b0
`define PMA_ATTR_RESERVED3              3
`define PMA_ATTR_RESERVED3__DEFAULT     1'b0
`define PMA_ATTR_CACHEABLE              4
`define PMA_ATTR_CACHEABLE__TRUE        1'b1
`define PMA_ATTR_CACHEABLE__FALSE       1'b0
`define PMA_ATTR_ATOMIC                 5
`define PMA_ATTR_ATOMIC__ALLOW          1'b1
`define PMA_ATTR_ATOMIC__DENY           1'b0
`define PMA_ATTR_TYPE                   6
`define PMA_ATTR_TYPE__MEM              1'b0
`define PMA_ATTR_TYPE__MMIO             1'b1
`define PMA_ATTR_RESERVED7              7
`define PMA_ATTR_RESERVED7__DEFAULT     1'b0
`define PMA_ATTR_BUS                    8+:2
`define PMA_ATTR_BUS__PRIVATE           2'b01
`define PMA_ATTR_BUS__RESERVED          2'b00
`define PMA_ATTR_BUS__AXI_L2            2'b10
`define PMA_ATTR_BUS__AXI_L3            2'b11
`define PMA_ATTR_BUS_LEN                2
`define PMA_ATTR_ACCESS                 2:0
`define PMA_ATTR__LEN                   10

//--------------------------------------------------------------------
// Non Standard (Custom) CSRs
//--------------------------------------------------------------------
`define CSR_CACHECTL                    12'hBC0
`define CSR_MMUCTL                      12'hBC1
`define CSR_PERFCTL                     12'hBC2

// [cachectl] custom csr fields
`define CACHECTL_ICACHE_EN              0
`define CACHECTL_DCACHE_EN              1

// [mmuctl] custom csr fields
`define MMUCTL_ITLB_EN                  0
`define MMUCTL_DTLB_EN                  1
`define MMUCTL_PMA_CHECK_EN             2

// [perfctl] custom csr fields
`define PERFCTL_UBTB_EN                 0
`define PERFCTL_RAS_EN                  1
`define PERFCTL_DP_EN                   2

`endif

// Generated File 'core_typedefs.vh' Ends

