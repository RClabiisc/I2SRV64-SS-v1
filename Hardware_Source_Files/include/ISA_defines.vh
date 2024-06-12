`ifndef INC_ISA_DEFINES
`define INC_ISA_DEFINES

//--------------------------------------------------------------------
// Instruction Format Defines
//--------------------------------------------------------------------
`define ISA_OP_RANGE        6:2
`define ISA_RD_RANGE        11:7
`define ISA_RS1_RANGE       19:15
`define ISA_RS2_RANGE       24:20
`define ISA_FN3_RANGE       14:12
`define ISA_FN7_RANGE       31:25

//special cases
`define ISA_RS3_RANGE       31:27
`define ISA_FN2_RANGE       26:25
`define ISA_SHAMT64_RANGE   25:20   //TODO: For RV64I
`define ISA_SHAMT32_RANGE   24:20   //TODO: For RV64I
`define ISA_CSR_RANGE       31:20
`define ISA_RM_RANGE        14:12


//--------------------------------------------------------------------
// Special Direct Defines
//--------------------------------------------------------------------
`define ISA_ZERO            5'd0
`define ISA_SP              5'd2
`define ISA_RA              5'd1
`define ISA_T0              5'd5

`define ISA_INS_NOP         32'h00000013


//--------------------------------------------------------------------
// LOAD         00000       (I-Type)
//--------------------------------------------------------------------
`define ISA_OP_LOAD         5'b00000
`define ISA_FN3_LB          3'b000
`define ISA_FN3_LH          3'b001
`define ISA_FN3_LW          3'b010
`define ISA_FN3_LBU         3'b100
`define ISA_FN3_LHU         3'b101
`define ISA_FN3_LWU         3'b110
`define ISA_FN3_LD          3'b011


//--------------------------------------------------------------------
// LOAD-FP      00001       (I-Type)
//--------------------------------------------------------------------
`define ISA_OP_LOADFP       5'b00001
`define ISA_FN3_FLW         3'b010
`define ISA_FN3_FLD         3'b011


//--------------------------------------------------------------------
// MISC-MEM     00011       (I-Type)
//--------------------------------------------------------------------
`define ISA_OP_MISCMEM      5'b00011
`define ISA_FN3_FENCE       3'b000
`define ISA_FN3_FENCEI      3'b001


//--------------------------------------------------------------------
// OP-IMM       00100       (I-Type)
//--------------------------------------------------------------------
`define ISA_OP_OPIMM        5'b00100
`define ISA_FN3_ADDI        3'b000
`define ISA_FN3_SLLI        3'b001
`define ISA_FN3_SLTI        3'b010
`define ISA_FN3_SLTIU       3'b011
`define ISA_FN3_XORI        3'b100
`define ISA_FN3_SRLI        3'b101
`define ISA_FN3_SRAI        3'b101
`define ISA_FN3_ORI         3'b110
`define ISA_FN3_ANDI        3'b111
`define ISA_FN7_SLLI        7'b0000000  //TODO: Beware of this in case of RV64
`define ISA_FN7_SRLI        7'b0000000  //TODO: Beware of this in case of RV64
`define ISA_FN7_SRAI        7'b0100000  //TODO: Beware of this in case of RV64


//--------------------------------------------------------------------
// AUIPC        00101       (U-Type)
//--------------------------------------------------------------------
`define ISA_OP_AUIPC        5'b00101


//--------------------------------------------------------------------
// OP-IMM-32    00110       (I-Type)
//--------------------------------------------------------------------
`define ISA_OP_OPIMM32      5'b00110
`define ISA_FN3_ADDIW       3'b000
`define ISA_FN3_SLLIW       3'b001
`define ISA_FN3_SRLIW       3'b101
`define ISA_FN3_SRAIW       3'b101
`define ISA_FN7_SLLIW       7'b0000000
`define ISA_FN7_SRLIW       7'b0000000
`define ISA_FN7_SRAIW       7'b0100000
`define ISA_FN7_SLLW        7'b0000000
`define ISA_FN7_SRLW        7'b0000000
`define ISA_FN7_SRAW        7'b0100000


//--------------------------------------------------------------------
// STORE        01000       (S-Type)
//--------------------------------------------------------------------
`define ISA_OP_STORE        5'b01000
`define ISA_FN3_SB          3'b000
`define ISA_FN3_SH          3'b001
`define ISA_FN3_SW          3'b010
`define ISA_FN3_SD          3'b011


//--------------------------------------------------------------------
// STORE-FP     01001       (S-Type)
//--------------------------------------------------------------------
`define ISA_OP_STOREFP      5'b01001
`define ISA_FN3_FSW         3'b010
`define ISA_FN3_FSD         3'b011


//--------------------------------------------------------------------
// AMO          01011       (R-Type)
//--------------------------------------------------------------------
`define ISA_OP_AMO          5'b01011
`define ISA_FN3_RV32A       3'b010
`define ISA_FN3_RV64A       3'b011
`define ISA_FN5_LR          5'b00010
`define ISA_FN5_SC          5'b00011
`define ISA_FN5_AMOSWAP     5'b00001
`define ISA_FN5_AMOADD      5'b00000
`define ISA_FN5_AMOXOR      5'b00100
`define ISA_FN5_AMOAND      5'b01100
`define ISA_FN5_AMOOR       5'b01000
`define ISA_FN5_AMOMIN      5'b10000
`define ISA_FN5_AMOMAX      5'b10100
`define ISA_FN5_AMOMINU     5'b11000
`define ISA_FN5_AMOMAXU     5'b11100


//--------------------------------------------------------------------
// OP           01100       (R-Type)
//--------------------------------------------------------------------
`define ISA_OP_OP           5'b01100
`define ISA_FN3_ADD         3'b000
`define ISA_FN3_SUB         3'b000
`define ISA_FN3_SLL         3'b001
`define ISA_FN3_SLT         3'b010
`define ISA_FN3_SLTU        3'b011
`define ISA_FN3_XOR         3'b100
`define ISA_FN3_SRL         3'b101
`define ISA_FN3_SRA         3'b101
`define ISA_FN3_OR          3'b110
`define ISA_FN3_AND         3'b111
`define ISA_FN7_OP          7'b0000000
`define ISA_FN7_SUB         7'b0100000
`define ISA_FN7_SRA         7'b0100000

/****************RV64M Instructions*******************/
`define ISA_FN7_RV64M       7'b0000001
`define ISA_FN3_MUL         3'b000
`define ISA_FN3_MULH        3'b001
`define ISA_FN3_MULHSU      3'b010
`define ISA_FN3_MULHU       3'b011
`define ISA_FN3_DIV         3'b100
`define ISA_FN3_DIVU        3'b101
`define ISA_FN3_REM         3'b110
`define ISA_FN3_REMU        3'b111


//--------------------------------------------------------------------
// LUI          01101       (U-Type)
//--------------------------------------------------------------------
`define ISA_OP_LUI          5'b01101


//--------------------------------------------------------------------
// OP-32        01110       (R-Type)
//--------------------------------------------------------------------
`define ISA_OP_OP32         5'b01110
`define ISA_FN3_ADDW        3'b000
`define ISA_FN3_SUBW        3'b000
`define ISA_FN3_SLLW        3'b001
`define ISA_FN3_SRLW        3'b101
`define ISA_FN3_SRAW        3'b101
`define ISA_FN7_ADDW        7'b0000000
`define ISA_FN7_SUBW        7'b0100000
`define ISA_FN7_SRLW        7'b0000000
`define ISA_FN7_SRAW        7'b0100000

/****************RV32M Instructions*******************/
`define ISA_FN7_RV32M       7'b0000001
`define ISA_FN3_MULW        3'b000
`define ISA_FN3_DIVW        3'b100
`define ISA_FN3_DIVUW       3'b101
`define ISA_FN3_REMW        3'b110
`define ISA_FN3_REMUW       3'b111


//--------------------------------------------------------------------
// MADD         10000
//--------------------------------------------------------------------
`define ISA_OP_MADD         5'b10000
`define ISA_FN2_MADDS       2'b00
`define ISA_FN2_MADDD       2'b01

//--------------------------------------------------------------------
// MSUB         10001
//--------------------------------------------------------------------
`define ISA_OP_MSUB         5'b10001
`define ISA_FN2_MSUBS       2'b00
`define ISA_FN2_MSUBD       2'b01


//--------------------------------------------------------------------
// NMSUB        10010
//--------------------------------------------------------------------
`define ISA_OP_NMSUB        5'b10010
`define ISA_FN2_NMSUBS      2'b00
`define ISA_FN2_NMSUBD      2'b01


//--------------------------------------------------------------------
// NMADD        10011
//--------------------------------------------------------------------
`define ISA_OP_NMADD        5'b10011
`define ISA_FN2_NMADDS      2'b00
`define ISA_FN2_NMADDD      2'b01

`define ISA_FN2_RVF         2'b00
`define ISA_FN2_RVD         2'b01


//--------------------------------------------------------------------
// OP-FP        10100
//--------------------------------------------------------------------
`define ISA_OP_OPFP         5'b10100
`define ISA_FN5_FADD        5'b00000
`define ISA_FN5_FSUB        5'b00001
`define ISA_FN5_FMUL        5'b00010
`define ISA_FN5_FDIV        5'b00011
`define ISA_FN5_FSQRT       5'b01011
`define ISA_FN5_FSGNJ       5'b00100
`define ISA_FN5_FMINMAX     5'b00101
`define ISA_FN5_FCMP        5'b10100
`define ISA_FN5_FCVT_F2I    5'b11000
`define ISA_FN5_FCVT_I2F    5'b11010
`define ISA_FN5_FCVT_F2F    5'b01000
`define ISA_FN5_FMV_F2I     5'b11100
`define ISA_FN5_FMV_I2F     5'b11110

`define ISA_RS2_FSQRT       5'b00000
`define ISA_RS2_FCVTWS      5'b00000
`define ISA_RS2_FCVTWUS     5'b00001
`define ISA_RS2_FCVTSW      5'b00000
`define ISA_RS2_FCVTSWU     5'b00001
`define ISA_RS2_FCVTLS      5'b00010
`define ISA_RS2_FCVTLUS     5'b00011
`define ISA_RS2_FCVTSL      5'b00010
`define ISA_RS2_FCVTSLU     5'b00011
`define ISA_RS2_FCVTSD      5'b00001
`define ISA_RS2_FCVTDS      5'b00000
`define ISA_RS2_FCVTWD      5'b00000
`define ISA_RS2_FCVTWUD     5'b00001
`define ISA_RS2_FCVTDW      5'b00000
`define ISA_RS2_FCVTDWU     5'b00001
`define ISA_RS2_FCVTLD      5'b00010
`define ISA_RS2_FCVTLUD     5'b00011
`define ISA_RS2_FCVTDL      5'b00010
`define ISA_RS2_FCVTDLU     5'b00011
`define ISA_RS2_FMVXW       5'b00000
`define ISA_RS2_FMVWX       5'b00000
`define ISA_RS2_FMVXD       5'b00000
`define ISA_RS2_FMVDX       5'b00000
`define ISA_RS2_FCLASS      5'b00000

`define ISA_FN3_FSGNJ       3'b000
`define ISA_FN3_FSGNJN      3'b001
`define ISA_FN3_FSGNJX      3'b010
`define ISA_FN3_FMIN        3'b000
`define ISA_FN3_FMAX        3'b001
`define ISA_FN3_FEQ         3'b010
`define ISA_FN3_FLT         3'b001
`define ISA_FN3_FLE         3'b000
`define ISA_FN3_FMV         3'b000
`define ISA_FN3_FCLASS      3'b001


//--------------------------------------------------------------------
// BRANCH       11000       (B-Type)
//--------------------------------------------------------------------
`define ISA_OP_BRANCH       5'b11000
`define ISA_FN3_BEQ         3'b000
`define ISA_FN3_BNE         3'b001
`define ISA_FN3_BLT         3'b100
`define ISA_FN3_BGE         3'b101
`define ISA_FN3_BLTU        3'b110
`define ISA_FN3_BGEU        3'b111


//--------------------------------------------------------------------
// JALR         11001       (I-Type)
//--------------------------------------------------------------------
`define ISA_OP_JALR         5'b11001
`define ISA_FN3_JALR        3'b000


//--------------------------------------------------------------------
// JAL          11011       (J-Type)
//--------------------------------------------------------------------
`define ISA_OP_JAL          5'b11011


//--------------------------------------------------------------------
// SYSTEM       11100       (I-Type)
//--------------------------------------------------------------------
`define ISA_OP_SYSTEM       5'b11100
`define ISA_FN3_ECALL       3'b000
`define ISA_FN3_EBREAK      3'b000
`define ISA_FN3_CSRRW       3'b001
`define ISA_FN3_CSRRS       3'b010
`define ISA_FN3_CSRRC       3'b011
`define ISA_FN3_CSRRWI      3'b101
`define ISA_FN3_CSRRSI      3'b110
`define ISA_FN3_CSRRCI      3'b111
`define ISA_IMM_ECALL       12'd0
`define ISA_IMM_EBREAK      12'd1

`define ISA_FN7_URET        7'b0000000
`define ISA_FN7_SRET        7'b0001000
`define ISA_FN7_MRET        7'b0011000
`define ISA_FN7_WFI         7'b0001000
`define ISA_FN7_SFENCEVMA   7'b0001001



`define ISA_INS_ECALL       32'h00000073
`define ISA_INS_EBREAK      32'h00100073
`define ISA_INS_URET        32'h00200073
`define ISA_INS_SRET        32'h10200073
`define ISA_INS_MRET        32'h30200073
`define ISA_INS_WFI         32'h10500073

`define ISA_FN7_SFENCE      7'b0001001
`define ISA_FN3_SFENCE      3'b000
`define ISA_RD_SFENCE       5'b00000

//TODO: excluding HFENCE.BVMA & HFENCE.GVMA


//--------------------------------------------------------------------
// RVC Instructions
//--------------------------------------------------------------------
`define ISAC_OP_RANGE       1:0
`define ISAC_FN3_RANGE      15:13
`define ISAC_RS1C_RANGE     9:7
`define ISAC_RS2C_RANGE     4:2
`define ISAC_RDCQ0_RANGE    4:2
`define ISAC_RS1_RANGE      11:7
`define ISAC_RS2_RANGE      6:2
`define ISAC_RD_RANGE       11:7


`define ISAC_Q0_OP          2'b00
`define ISAC_Q1_OP          2'b01
`define ISAC_Q2_OP          2'b10

`define ISAC_INST_NOP       16'd1

//Quadrant 0 instructions
`define ISAC_FN3_ADDI4      3'b000
`define ISAC_FN3_LW         3'b010
`define ISAC_FN3_LD         3'b011
`define ISAC_FN3_FLD        3'b001
`define ISAC_FN3_SW         3'b110
`define ISAC_FN3_SD         3'b111
`define ISAC_FN3_FSD        3'b101

//quadrant 1 instructions
`define ISAC_FN3_ADDI       3'b000
`define ISAC_FN3_ADDIW      3'b001
`define ISAC_FN3_LI         3'b010
`define ISAC_FN3_LUI        3'b011
`define ISAC_FN3_ARITH      3'b100
`define ISAC_FN3_J          3'b101
`define ISAC_FN3_BEQZ       3'b110
`define ISAC_FN3_BNEZ       3'b111

//quadrant 2 intructions
`define ISAC_FN3_SLLI       3'b000
`define ISAC_FN3_FLDSP      3'b001
`define ISAC_FN3_LWSP       3'b010
`define ISAC_FN3_LDSP       3'b011
`define ISAC_FN3_100        3'b100
`define ISAC_FN3_FSDSP      3'b101
`define ISAC_FN3_SWSP       3'b110
`define ISAC_FN3_SDSP       3'b111


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

`endif

