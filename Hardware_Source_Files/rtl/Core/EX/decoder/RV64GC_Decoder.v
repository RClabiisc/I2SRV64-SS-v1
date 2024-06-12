//******************************************************************************
// Copyright (c) 2018 - 2023, Indian Institute of Science, Bangalore.
// All Rights Reserved. See LICENSE for license details.
//------------------------------------------------------------------------------

// Contributors // Manish Kumar(manishkumar5@iisc.ac.in), Shubham Yadav(shubhamyadav@iisc.ac.in)
// Sajin S (sajins@alum.iisc.ac.in), Shubham Sunil Garag (shubhamsunil@alum.iisc.ac.in)
// Anuj Phegade (anujphegade@alum.iisc.ac.in), Deepshikha Gusain (deepshikhag@alum.iisc.ac.in)
// Ronit Patel (ronitpatel@alum.iisc.ac.in), Vishal Kumar (vishalkumar@alum.iisc.ac.in)
// Kuruvilla Varghese (kuru@iisc.ac.in)
//******************************************************************************
`timescale 1ns/1ps
`include "core_defines.vh"

(* keep_hierarchy = "yes" *)
module RV64GC_Decoder
(
    //Input Peek Data of IB
    input  wire [(`DECODE_RATE*`IB_ENTRY_LEN)-1:0]      IB_DataOut,

    //Inputs from SysCtl
    input  wire [`XSTATUS_FS_LEN-1:0]                   csr_status_fs,      //FS Bits from xstatus CSR

    //Output Decoded Micro-Operations
    output wire [(`DECODE_RATE*`UOP_LEN)-1:0]           Uops,               //Decoded uops without spectag & killmask
    output reg  [`DECODE_RATE-1:0]                      AllocateNewSpectag, //i=1 => New Spectag Need to be allocated for next instr
    output reg  [`DECODE_RATE-1:0]                      AllocateLSorderTag  //i=1 => New Spectag Need to be allocated for next instr
);
`include "ISA_func.v"

//1. generated wires for input & extract fields
wire [`IB_ENTRY_LEN-1:0]    IB_Entry[0:`DECODE_RATE-1];
wire [31:0]                 IB_Instr[0:`DECODE_RATE-1];
genvar gb;
generate
    for(gb=0; gb<`DECODE_RATE; gb=gb+1) begin
        assign IB_Entry[gb] = IB_DataOut[(gb*`IB_ENTRY_LEN)+:`IB_ENTRY_LEN];
        assign IB_Instr[gb] = IB_Entry[gb][`IB_ENTRY_INSTR];
    end
endgenerate

//2. decompress compressed instructions to 32-bit equivalent instructions
wire [15:0] RVC_Instr[0:`DECODE_RATE-1];
wire [31:0] Expanded_Instr[0:`DECODE_RATE-1];
wire [31:0] Expanded_Imm[0:`DECODE_RATE-1];
wire        RVC_Invalid[0:`DECODE_RATE-1];
wire        RVC_Hint[0:`DECODE_RATE-1];
genvar gc;
generate
    for(gc=0; gc<`DECODE_RATE; gc=gc+1) begin:instr
        assign RVC_Instr[gc] = (IB_Entry[gc][`IB_ENTRY_IS16BIT]==1'b1) ? IB_Instr[gc][15:0] : `ISAC_INST_NOP;
        RVC_Decompressor RVC2RVI
        (
            .Instr16 (RVC_Instr[gc]),
            .Instr32 (Expanded_Instr[gc]),
            .Imm     (Expanded_Imm[gc]),
            .Invalid (RVC_Invalid[gc]),
            .Hint    (RVC_Hint[gc])
        );
    end
endgenerate

//3. Create Final 32-bit instr, Valid and Invalid signals
wire [31:0] Instr[0:`DECODE_RATE-1];                //Final 32-bit instruction either direct from IB entry or expanded
wire        Entry_Valid[0:`DECODE_RATE-1];          //1=>IB Entry was valid
wire        RVC_Instr_Invalid[0:`DECODE_RATE-1];    //1=>Invalid Instruction => will set exception bit in UOP
genvar gi;
generate
    for(gi=0; gi<`DECODE_RATE; gi=gi+1) begin
        assign Entry_Valid[gi]  = IB_Entry[gi][`IB_ENTRY_VALID];
        assign Instr[gi] = (IB_Entry[gi][`IB_ENTRY_IS16BIT]==1'b1) ? Expanded_Instr[gi] : IB_Instr[gi];
        assign RVC_Instr_Invalid[gi] = (IB_Entry[gi][`IB_ENTRY_IS16BIT]==1'b1) ? RVC_Invalid[gi] : 1'b0;
    end
endgenerate


//4. create/generate Local Wires and output wires
reg  [`UOP_LEN-1:0]         uop[0:`DECODE_RATE-1];
reg  [`UOP_CONTROL_LEN-1:0] uop_ctrl[0:`DECODE_RATE-1];
wire [4:0]                  rs1[0:`DECODE_RATE-1];
wire [4:0]                  rs2[0:`DECODE_RATE-1];
wire [4:0]                  rd[0:`DECODE_RATE-1];
wire [2:0]                  fn3[0:`DECODE_RATE-1];
wire [6:0]                  fn7[0:`DECODE_RATE-1];
genvar gr;
generate
    for(gr=0;gr<`DECODE_RATE;gr=gr+1) begin
        assign rs1[gr] = Instr[gr][`ISA_RS1_RANGE];
        assign rs2[gr] = Instr[gr][`ISA_RS2_RANGE];
        assign rd[gr]  = Instr[gr][`ISA_RD_RANGE];
        assign fn3[gr] = Instr[gr][`ISA_FN3_RANGE];
        assign fn7[gr] = Instr[gr][`ISA_FN7_RANGE];
    end
endgenerate


//5. Main Decoder Process
integer i;
always @* begin
    for(i=0; i<`DECODE_RATE; i=i+1) begin
        //Assign Default values
        uop[i]=0; uop_ctrl[i]=0; AllocateNewSpectag[i]=0; AllocateLSorderTag[i]=0;

        if(IB_Entry[i][`IB_ENTRY_VALID]==1'b1) begin
            //set data common to all
            uop[i][`UOP_VALID]  = 1'b1;
            uop[i][`UOP_PC]     = IB_Entry[i][`IB_ENTRY_PC];
            uop[i][`UOP_INSTR]  = IB_Entry[i][`IB_ENTRY_INSTR];

            //At this stage All instructions must be 32 bit (extra verification;
            //Redundant if Bundle_Generator does its job perfectly)
            //Cause exception if Invalid Compressed Instruction (which has now
            //modified to NOP)
            uop[i][`UOP_EXCEPTION] = (~|Instr[i][1:0]) | (IB_Entry[i][`IB_ENTRY_IS16BIT] & RVC_Instr_Invalid[i]);

            case(Instr[i][`ISA_OP_RANGE])
                `ISA_OP_LOAD: begin
                    uop[i][`UOP_FUTYPE]     = `FU_TYPE_LOAD;
                    uop[i][`UOP_REG_WE]     = 1'b1;
                    uop[i][`UOP_IMM]        = Unpack_I(Instr[i]);
                    uop[i][`UOP_IS_RD]      = 1'b1;
                    uop[i][`UOP_RD_TYPE]    = `REG_TYPE_INT;
                    uop[i][`UOP_RD]         = rd[i];
                    uop[i][`UOP_IS_RS1]     = 1'b1;
                    uop[i][`UOP_RS1_TYPE]   = `REG_TYPE_INT;
                    uop[i][`UOP_RS1]        = rs1[i];
                    uop[i][`UOP_IS_RS2]     = 1'b0;
                    uop[i][`UOP_OP1_SEL]    = `OP1_SEL_RS1;
                    uop[i][`UOP_OP2_SEL]    = `OP2_SEL_IMM;
                    uop[i][`UOP_RSTYPE]     = `RS_TYPE_MEM;
                    AllocateLSorderTag[i]   = 1'b1;

                    uop_ctrl[i][`UOP_MEM_DATA_TYPE] = fn3[i];
                end

                `ISA_OP_LOADFP: begin
                    uop[i][`UOP_FUTYPE]     = `FU_TYPE_LOAD;
                    uop[i][`UOP_REG_WE]     = 1'b1;
                    uop[i][`UOP_IMM]        = Unpack_I(Instr[i]);
                    uop[i][`UOP_IS_RD]      = 1'b1;
                    uop[i][`UOP_RD_TYPE]    = `REG_TYPE_FP;
                    uop[i][`UOP_RD]         = rd[i];
                    uop[i][`UOP_IS_RS1]     = 1'b1;
                    uop[i][`UOP_RS1_TYPE]   = `REG_TYPE_INT;
                    uop[i][`UOP_RS1]        = rs1[i];
                    uop[i][`UOP_IS_RS2]     = 1'b0;
                    uop[i][`UOP_OP1_SEL]    = `OP1_SEL_RS1;
                    uop[i][`UOP_OP2_SEL]    = `OP2_SEL_IMM;
                    uop[i][`UOP_RSTYPE]     = `RS_TYPE_MEM;
                    AllocateLSorderTag[i]   = 1'b1;

                    if((fn3[i]==`ISA_FN3_FLD) || (fn3[i]==`ISA_FN3_FLW))
                        uop_ctrl[i][`UOP_MEM_DATA_TYPE] = fn3[i];
                    else
                        uop[i][`UOP_EXCEPTION] = 1'b1;

                    //status.FS == OFF Check
                    if(csr_status_fs==`XSTATUS_FS__OFF)
                        uop[i][`UOP_EXCEPTION] = 1'b1;
                end

                `ISA_OP_MISCMEM: begin
                    case(fn3[i])
                        `ISA_FN3_FENCE: begin
                            if(fn3[i]==`ISA_FN3_FENCE) begin
                                uop[i][`UOP_FUTYPE]            = `FU_TYPE_SYSTEM;
                                uop[i][`UOP_RSTYPE]            = `RS_TYPE_BR;   //TODO: Multiplexed with Br as no typedef for System as of now
                                uop[i][`UOP_WAIT_TILL_EMPTY]   = 1'b1;  //XXX: Let all previous instr complete
                                uop[i][`UOP_STALL_TILL_RETIRE] = 1'b1;  //XXX: Stall next as cached data might be invalid
                                uop[i][`UOP_REG_WE]            = 1'b0;
                                uop[i][`UOP_IMM]               = 0;
                                uop[i][`UOP_IS_RD]             = 1'b0;  //User Spec v20191213 specifies rd=0
                                uop[i][`UOP_IS_RS1]            = 1'b0;  //User Spec v20191213 specifies rs1=0
                                uop[i][`UOP_IS_RS2]            = 1'b0;
                                uop[i][`UOP_OP1_SEL]           = `OP1_SEL_RS1; //Added for Future Compatibility
                                uop_ctrl[i][`UOP_SYS_IS_16BIT] = IB_Entry[i][`IB_ENTRY_IS16BIT];
                                uop_ctrl[i][`UOP_SYS_IS_FENCE] = 1'b1;
                                uop_ctrl[i][`UOP_SYS_DATA]     = Instr[i][31:7];
                            end
                            else
                                uop[i][`UOP_EXCEPTION] = 1'b1;
                        end
                        `ISA_FN3_FENCEI: begin
                            if(fn3[i]==`ISA_FN3_FENCEI) begin
                                uop[i][`UOP_FUTYPE]             = `FU_TYPE_SYSTEM;
                                uop[i][`UOP_RSTYPE]             = `RS_TYPE_BR;   //TODO: Multiplexed with Br as no typedef for System as of now
                                uop[i][`UOP_WAIT_TILL_EMPTY]    = 1'b1;  //XXX: Let all previous instr complete
                                uop[i][`UOP_STALL_TILL_RETIRE]  = 1'b1;  //XXX: Stall next as cached data might be invalid
                                uop[i][`UOP_REG_WE]             = 1'b0;
                                uop[i][`UOP_IMM]                = 0;    //User Spec v20191213 specifies Imm=0
                                uop[i][`UOP_IS_RD]              = 1'b0; //User Spec v20191213 specifies rd=0
                                uop[i][`UOP_IS_RS1]             = 1'b0; //User Spec v20191213 specifies rs1=0
                                uop[i][`UOP_IS_RS2]             = 1'b0;
                                uop[i][`UOP_OP1_SEL]            = `OP1_SEL_RS1; //Added for Future Compatibility
                                uop_ctrl[i][`UOP_SYS_IS_16BIT]  = IB_Entry[i][`IB_ENTRY_IS16BIT];
                                uop_ctrl[i][`UOP_SYS_IS_FENCEI] = 1'b1;
                                uop_ctrl[i][`UOP_SYS_DATA]      = Instr[i][31:7];
                            end
                            else
                                uop[i][`UOP_EXCEPTION] = 1'b1;
                        end
                        default: uop[i][`UOP_EXCEPTION] = 1'b1;
                    endcase
                end

                `ISA_OP_OPIMM: begin
                    uop[i][`UOP_FUTYPE]     = `FU_TYPE_IALU;
                    uop[i][`UOP_REG_WE]     = 1'b1;
                    uop[i][`UOP_IMM]        = Unpack_I(Instr[i]);
                    uop[i][`UOP_IS_RD]      = 1'b1;
                    uop[i][`UOP_RD_TYPE]    = `REG_TYPE_INT;
                    uop[i][`UOP_RD]         = rd[i];
                    uop[i][`UOP_IS_RS1]     = 1'b1;
                    uop[i][`UOP_RS1_TYPE]   = `REG_TYPE_INT;
                    uop[i][`UOP_RS1]        = rs1[i];
                    uop[i][`UOP_IS_RS2]     = 1'b0;
                    uop[i][`UOP_OP1_SEL]    = `OP1_SEL_RS1;
                    uop[i][`UOP_OP2_SEL]    = `OP2_SEL_IMM;
                    uop[i][`UOP_RSTYPE]     = `RS_TYPE_INT;

                    case(fn3[i])
                        `ISA_FN3_ADDI : uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_ADD;
                        `ISA_FN3_SLTI : uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_SLT;
                        `ISA_FN3_SLTIU: uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_SLTU;
                        `ISA_FN3_XORI : uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_XOR;
                        `ISA_FN3_ORI  : uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_OR;
                        `ISA_FN3_ANDI : uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_AND;
                        `ISA_FN3_SLLI : begin
                            if(Instr[i][31:26]==6'b000000) begin
                                uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_SLL;
                                uop[i][`UOP_IMM] = {26'b0,Instr[i][`ISA_SHAMT64_RANGE]};
                            end
                            else
                                uop[i][`UOP_EXCEPTION] = 1'b1;
                        end
                        `ISA_FN3_SRLI : begin
                            if(Instr[i][31:26]==6'b000000) begin
                                uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_SRL;
                                uop[i][`UOP_IMM] = {26'b0,Instr[i][`ISA_SHAMT64_RANGE]};
                            end
                            else if(Instr[i][31:26]==6'b010000) begin
                                uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_SRA;
                                uop[i][`UOP_IMM] = {26'b0,Instr[i][`ISA_SHAMT64_RANGE]};
                            end
                            else
                                uop[i][`UOP_EXCEPTION] = 1'b1;
                        end
                    endcase
                end

                `ISA_OP_AUIPC: begin
                    uop[i][`UOP_FUTYPE]     = `FU_TYPE_IALU;
                    uop[i][`UOP_REG_WE]     = 1'b1;
                    uop[i][`UOP_IMM]        = Unpack_U(Instr[i]);
                    uop[i][`UOP_IS_RD]      = 1'b1;
                    uop[i][`UOP_RD_TYPE]    = `REG_TYPE_INT;
                    uop[i][`UOP_RD]         = rd[i];
                    uop[i][`UOP_IS_RS1]     = 1'b0;
                    uop[i][`UOP_IS_RS2]     = 1'b0;
                    uop[i][`UOP_OP1_SEL]    = `OP1_SEL_PC;
                    uop[i][`UOP_OP2_SEL]    = `OP2_SEL_IMM;
                    uop[i][`UOP_RSTYPE]     = `RS_TYPE_INT;

                    uop_ctrl[i][`UOP_INT_IS_AUIPC] = 1'b1;
                end

                `ISA_OP_OPIMM32: begin
                    uop[i][`UOP_FUTYPE]     = `FU_TYPE_IALU;
                    uop[i][`UOP_REG_WE]     = 1'b1;
                    uop[i][`UOP_IMM]        = Unpack_I(Instr[i]);
                    uop[i][`UOP_IS_RD]      = 1'b1;
                    uop[i][`UOP_RD_TYPE]    = `REG_TYPE_INT;
                    uop[i][`UOP_RD]         = rd[i];
                    uop[i][`UOP_IS_RS1]     = 1'b1;
                    uop[i][`UOP_RS1_TYPE]   = `REG_TYPE_INT;
                    uop[i][`UOP_RS1]        = rs1[i];
                    uop[i][`UOP_IS_RS2]     = 1'b0;
                    uop[i][`UOP_OP1_SEL]    = `OP1_SEL_RS1;
                    uop[i][`UOP_OP2_SEL]    = `OP2_SEL_IMM;
                    uop[i][`UOP_RSTYPE]     = `RS_TYPE_INT;
                    uop_ctrl[i][`UOP_INT_IS_WORD] = 1'b1;

                    case(fn3[i])
                        `ISA_FN3_ADDIW : uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_ADD;
                        `ISA_FN3_SLLIW : begin
                            if(fn7[i]==`ISA_FN7_SLLIW) begin
                                uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_SLL;
                                uop[i][`UOP_IMM] = {27'b0,Instr[i][`ISA_SHAMT32_RANGE]};
                            end
                            else
                                uop[i][`UOP_EXCEPTION] = 1'b1;
                        end
                        `ISA_FN3_SRLIW : begin
                            if(fn7[i]==`ISA_FN7_SRLIW) begin
                                uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_SRL;
                                uop[i][`UOP_IMM] = {27'b0,Instr[i][`ISA_SHAMT32_RANGE]};
                            end
                            else if(fn7[i]==`ISA_FN7_SRAIW) begin
                                uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_SRA;
                                uop[i][`UOP_IMM] = {27'b0,Instr[i][`ISA_SHAMT32_RANGE]};
                            end
                            else
                                uop[i][`UOP_EXCEPTION] = 1'b1;
                        end
                        default: uop[i][`UOP_EXCEPTION] = 1'b1;
                    endcase
                end

                `ISA_OP_STORE: begin
                    uop[i][`UOP_FUTYPE]     = `FU_TYPE_STORE;
                    uop[i][`UOP_REG_WE]     = 1'b0;
                    uop[i][`UOP_IMM]        = Unpack_S(Instr[i]);
                    uop[i][`UOP_IS_RD]      = 1'b0;
                    uop[i][`UOP_IS_RS1]     = 1'b1;
                    uop[i][`UOP_RS1_TYPE]   = `REG_TYPE_INT;
                    uop[i][`UOP_RS1]        = rs1[i];
                    uop[i][`UOP_IS_RS2]     = 1'b1;
                    uop[i][`UOP_RS2_TYPE]   = `REG_TYPE_INT;
                    uop[i][`UOP_RS2]        = rs2[i];
                    uop[i][`UOP_OP1_SEL]    = `OP1_SEL_RS1;
                    uop[i][`UOP_OP2_SEL]    = `OP2_SEL_RS2;
                    uop[i][`UOP_OP3_SEL]    = `OP3_SEL_IMM;
                    uop[i][`UOP_RSTYPE]     = `RS_TYPE_MEM;
                    AllocateLSorderTag[i]   = 1'b1;

                    uop_ctrl[i][`UOP_MEM_DATA_TYPE] = fn3[i];
                    //*U Data Type NOT Supported
                    if(fn3[i][2]==1'b1)
                        uop[i][`UOP_EXCEPTION] = 1'b1;
                end

                `ISA_OP_STOREFP: begin
                    uop[i][`UOP_FUTYPE]     = `FU_TYPE_STORE;
                    uop[i][`UOP_REG_WE]     = 1'b0;
                    uop[i][`UOP_IMM]        = Unpack_S(Instr[i]);
                    uop[i][`UOP_IS_RD]      = 1'b0;
                    uop[i][`UOP_IS_RS1]     = 1'b1;
                    uop[i][`UOP_RS1_TYPE]   = `REG_TYPE_INT;
                    uop[i][`UOP_RS1]        = rs1[i];
                    uop[i][`UOP_IS_RS2]     = 1'b1;
                    uop[i][`UOP_RS2_TYPE]   = `REG_TYPE_FP;
                    uop[i][`UOP_RS2]        = rs2[i];
                    uop[i][`UOP_OP1_SEL]    = `OP1_SEL_RS1;
                    uop[i][`UOP_OP2_SEL]    = `OP2_SEL_RS2;
                    uop[i][`UOP_OP3_SEL]    = `OP3_SEL_IMM;
                    uop[i][`UOP_RSTYPE]     = `RS_TYPE_MEM;
                    AllocateLSorderTag[i]   = 1'b1;

                    if((fn3[i]==`ISA_FN3_FSD) || (fn3[i]==`ISA_FN3_FSW))
                        uop_ctrl[i][`UOP_MEM_DATA_TYPE] = fn3[i];
                    else
                        uop[i][`UOP_EXCEPTION] = 1'b1;

                    //status.FS == OFF Check
                    if(csr_status_fs==`XSTATUS_FS__OFF)
                        uop[i][`UOP_EXCEPTION] = 1'b1;
                end

                `ISA_OP_AMO: begin
                    uop[i][`UOP_FUTYPE]             = `FU_TYPE_STORE;
                    uop[i][`UOP_WAIT_TILL_EMPTY]    = 1'b1; //XXX: Forces aq,rl explicitely
                    uop[i][`UOP_STALL_TILL_RETIRE]  = 1'b1; //XXX: For single core, 0 is fine
                    uop[i][`UOP_REG_WE]             = 1'b1;
                    uop[i][`UOP_IMM]                = 0;
                    uop[i][`UOP_IS_RD]              = 1'b1;
                    uop[i][`UOP_RD_TYPE]            = `REG_TYPE_INT;
                    uop[i][`UOP_RD]                 = rd[i];
                    uop[i][`UOP_IS_RS1]             = 1'b1;
                    uop[i][`UOP_RS1_TYPE]           = `REG_TYPE_INT;
                    uop[i][`UOP_RS1]                = rs1[i];
                    uop[i][`UOP_RS2_TYPE]           = `REG_TYPE_INT;
                    uop[i][`UOP_RS2]                = rs2[i];
                    uop[i][`UOP_RSTYPE]             = `RS_TYPE_MEM;
                    AllocateLSorderTag[i]           = 1'b1;
                    uop[i][`UOP_OP1_SEL]            = `OP1_SEL_RS1;
                    uop[i][`UOP_OP2_SEL]            = `OP2_SEL_RS2;
                    uop_ctrl[i][`UOP_MEM_IS_ATOMIC] = 1'b1;
                    uop_ctrl[i][`UOP_MEM_AMO_DATA ] = Instr[i][26:25];  //aq,rl

                    if(fn3[i]==`ISA_FN3_RV32A)
                        uop_ctrl[i][`UOP_MEM_DATA_TYPE] = `DATA_TYPE_W;
                    else if(fn3[i]==`ISA_FN3_RV64A)
                        uop_ctrl[i][`UOP_MEM_DATA_TYPE] = `DATA_TYPE_D;
                    else
                        uop[i][`UOP_EXCEPTION] = 1'b1;

                    case(Instr[i][31:27])
                        `ISA_FN5_LR: begin
                            uop_ctrl[i][`UOP_MEM_AMO_SUBOP] = `AMO_OP_LR;
                            uop[i][`UOP_IS_RS2]     = 1'b0;
                        end
                        `ISA_FN5_SC: begin
                            uop_ctrl[i][`UOP_MEM_AMO_SUBOP] = `AMO_OP_SC;
                            uop[i][`UOP_IS_RS2]     = 1'b1;
                        end
                        `ISA_FN5_AMOSWAP: begin
                            uop_ctrl[i][`UOP_MEM_AMO_SUBOP] = `AMO_OP_SWAP;
                            uop[i][`UOP_IS_RS2]     = 1'b1;
                        end
                        `ISA_FN5_AMOADD: begin
                            uop_ctrl[i][`UOP_MEM_AMO_SUBOP] = `AMO_OP_ADD;
                            uop[i][`UOP_IS_RS2]     = 1'b1;
                        end
                        `ISA_FN5_AMOXOR: begin
                            uop_ctrl[i][`UOP_MEM_AMO_SUBOP] = `AMO_OP_XOR;
                            uop[i][`UOP_IS_RS2]     = 1'b1;
                        end
                        `ISA_FN5_AMOAND: begin
                            uop_ctrl[i][`UOP_MEM_AMO_SUBOP] = `AMO_OP_AND;
                            uop[i][`UOP_IS_RS2]     = 1'b1;
                        end
                        `ISA_FN5_AMOOR: begin
                            uop_ctrl[i][`UOP_MEM_AMO_SUBOP] = `AMO_OP_OR;
                            uop[i][`UOP_IS_RS2]     = 1'b1;
                        end
                        `ISA_FN5_AMOMIN: begin
                            uop_ctrl[i][`UOP_MEM_AMO_SUBOP] = `AMO_OP_MIN;
                            uop[i][`UOP_IS_RS2]     = 1'b1;
                        end
                        `ISA_FN5_AMOMAX: begin
                            uop_ctrl[i][`UOP_MEM_AMO_SUBOP] = `AMO_OP_MAX;
                            uop[i][`UOP_IS_RS2]     = 1'b1;
                        end
                        `ISA_FN5_AMOMINU: begin
                            uop_ctrl[i][`UOP_MEM_AMO_SUBOP] = `AMO_OP_MINU;
                            uop[i][`UOP_IS_RS2]     = 1'b1;
                        end
                        `ISA_FN5_AMOMAXU: begin
                            uop_ctrl[i][`UOP_MEM_AMO_SUBOP] = `AMO_OP_MAXU;
                            uop[i][`UOP_IS_RS2]     = 1'b1;
                        end
                        default: uop[i][`UOP_EXCEPTION] = 1'b1;
                    endcase
                end

                `ISA_OP_OP: begin
                    uop[i][`UOP_REG_WE]     = 1'b1;
                    uop[i][`UOP_IMM]        = 0;
                    uop[i][`UOP_IS_RD]      = 1'b1;
                    uop[i][`UOP_RD_TYPE]    = `REG_TYPE_INT;
                    uop[i][`UOP_RD]         = rd[i];
                    uop[i][`UOP_IS_RS1]     = 1'b1;
                    uop[i][`UOP_RS1_TYPE]   = `REG_TYPE_INT;
                    uop[i][`UOP_RS1]        = rs1[i];
                    uop[i][`UOP_IS_RS2]     = 1'b1;
                    uop[i][`UOP_RS2_TYPE]   = `REG_TYPE_INT;
                    uop[i][`UOP_RS2]        = rs2[i];
                    uop[i][`UOP_OP1_SEL]    = `OP1_SEL_RS1;
                    uop[i][`UOP_OP2_SEL]    = `OP2_SEL_RS2;
                    uop[i][`UOP_RSTYPE]     = `RS_TYPE_INT;

                    case({fn7[i],fn3[i]})
                        {`ISA_FN7_OP,`ISA_FN3_ADD}: begin
                            uop[i][`UOP_FUTYPE]         = `FU_TYPE_IALU;
                            uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_ADD;
                        end
                        {`ISA_FN7_SUB,`ISA_FN3_SUB}: begin
                            uop[i][`UOP_FUTYPE]         = `FU_TYPE_IALU;
                            uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_SUB;
                        end
                        {`ISA_FN7_OP, `ISA_FN3_SLL}: begin
                            uop[i][`UOP_FUTYPE]         = `FU_TYPE_IALU;
                            uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_SLL;
                        end
                        {`ISA_FN7_OP, `ISA_FN3_SLT}: begin
                            uop[i][`UOP_FUTYPE]         = `FU_TYPE_IALU;
                            uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_SLT;
                        end
                        {`ISA_FN7_OP, `ISA_FN3_SLTU}: begin
                            uop[i][`UOP_FUTYPE]         = `FU_TYPE_IALU;
                            uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_SLTU;
                        end
                        {`ISA_FN7_OP, `ISA_FN3_XOR}: begin
                            uop[i][`UOP_FUTYPE]         = `FU_TYPE_IALU;
                            uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_XOR;
                        end
                        {`ISA_FN7_OP, `ISA_FN3_SRL}: begin
                            uop[i][`UOP_FUTYPE]         = `FU_TYPE_IALU;
                            uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_SRL;
                        end
                        {`ISA_FN7_SRA, `ISA_FN3_SRA}: begin
                            uop[i][`UOP_FUTYPE]         = `FU_TYPE_IALU;
                            uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_SRA;
                        end
                        {`ISA_FN7_OP, `ISA_FN3_OR}: begin
                            uop[i][`UOP_FUTYPE]         = `FU_TYPE_IALU;
                            uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_OR;
                        end
                        {`ISA_FN7_OP, `ISA_FN3_AND}: begin
                            uop[i][`UOP_FUTYPE]         = `FU_TYPE_IALU;
                            uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_AND;
                        end
                        {`ISA_FN7_RV64M, `ISA_FN3_MUL}: begin
                            uop[i][`UOP_FUTYPE]             = `FU_TYPE_IMUL;
                            uop_ctrl[i][`UOP_INT_MULDIVOP]  = `INT_MULOP_S;
                        end
                        {`ISA_FN7_RV64M, `ISA_FN3_MULH}: begin
                            uop[i][`UOP_FUTYPE]             = `FU_TYPE_IMUL;
                            uop_ctrl[i][`UOP_INT_MULDIVOP]  = `INT_MULOP_H;
                        end
                        {`ISA_FN7_RV64M, `ISA_FN3_MULHSU}: begin
                            uop[i][`UOP_FUTYPE]             = `FU_TYPE_IMUL;
                            uop_ctrl[i][`UOP_INT_MULDIVOP]  = `INT_MULOP_HSU;
                        end
                        {`ISA_FN7_RV64M, `ISA_FN3_MULHU}: begin
                            uop[i][`UOP_FUTYPE]             = `FU_TYPE_IMUL;
                            uop_ctrl[i][`UOP_INT_MULDIVOP]  = `INT_MULOP_HU;
                        end
                        {`ISA_FN7_RV64M, `ISA_FN3_DIV}: begin
                            uop[i][`UOP_FUTYPE]             = `FU_TYPE_IDIV;
                            uop_ctrl[i][`UOP_INT_MULDIVOP]  = `INT_DIVOP_DIV;
                        end
                        {`ISA_FN7_RV64M, `ISA_FN3_DIVU}: begin
                            uop[i][`UOP_FUTYPE]             = `FU_TYPE_IDIV;
                            uop_ctrl[i][`UOP_INT_MULDIVOP]  = `INT_DIVOP_DIVU;
                        end
                        {`ISA_FN7_RV64M, `ISA_FN3_REM}: begin
                            uop[i][`UOP_FUTYPE]             = `FU_TYPE_IDIV;
                            uop_ctrl[i][`UOP_INT_MULDIVOP]  = `INT_DIVOP_REM;
                        end
                        {`ISA_FN7_RV64M, `ISA_FN3_REMU}: begin
                            uop[i][`UOP_FUTYPE]             = `FU_TYPE_IDIV;
                            uop_ctrl[i][`UOP_INT_MULDIVOP]  = `INT_DIVOP_REMU;
                        end
                        default: uop[i][`UOP_EXCEPTION] = 1'b1;
                    endcase
                end

                `ISA_OP_LUI: begin
                    uop[i][`UOP_FUTYPE]     = `FU_TYPE_IALU;
                    uop[i][`UOP_REG_WE]     = 1'b1;
                    uop[i][`UOP_IMM]        = Unpack_U(Instr[i]);
                    uop[i][`UOP_IS_RD]      = 1'b1;
                    uop[i][`UOP_RD_TYPE]    = `REG_TYPE_INT;
                    uop[i][`UOP_RD]         = rd[i];
                    uop[i][`UOP_IS_RS1]     = 1'b0;
                    uop[i][`UOP_IS_RS2]     = 1'b0;
                    uop[i][`UOP_OP1_SEL]    = `OP1_SEL_R0;
                    uop[i][`UOP_OP2_SEL]    = `OP2_SEL_IMM;
                    uop[i][`UOP_RSTYPE]     = `RS_TYPE_INT;

                    uop_ctrl[i][`UOP_INT_IS_LUI] = 1'b1;
                end

                `ISA_OP_OP32: begin
                    uop[i][`UOP_REG_WE]     = 1'b1;
                    uop[i][`UOP_IMM]        = 0;
                    uop[i][`UOP_IS_RD]      = 1'b1;
                    uop[i][`UOP_RD_TYPE]    = `REG_TYPE_INT;
                    uop[i][`UOP_RD]         = rd[i];
                    uop[i][`UOP_IS_RS1]     = 1'b1;
                    uop[i][`UOP_RS1_TYPE]   = `REG_TYPE_INT;
                    uop[i][`UOP_RS1]        = rs1[i];
                    uop[i][`UOP_IS_RS2]     = 1'b1;
                    uop[i][`UOP_RS2_TYPE]   = `REG_TYPE_INT;
                    uop[i][`UOP_RS2]        = rs2[i];
                    uop[i][`UOP_OP1_SEL]    = `OP1_SEL_RS1;
                    uop[i][`UOP_OP2_SEL]    = `OP2_SEL_RS2;
                    uop[i][`UOP_RSTYPE]     = `RS_TYPE_INT;
                    uop_ctrl[i][`UOP_INT_IS_WORD] = 1'b1;

                    case({fn7[i],fn3[i]})
                        {`ISA_FN7_ADDW,`ISA_FN3_ADDW}: begin
                            uop[i][`UOP_FUTYPE]         = `FU_TYPE_IALU;
                            uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_ADD;
                        end
                        {`ISA_FN7_SUBW,`ISA_FN3_SUBW}: begin
                            uop[i][`UOP_FUTYPE]         = `FU_TYPE_IALU;
                            uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_SUB;
                        end
                        {`ISA_FN7_SLLW, `ISA_FN3_SLLW}: begin
                            uop[i][`UOP_FUTYPE]         = `FU_TYPE_IALU;
                            uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_SLL;
                        end
                        {`ISA_FN7_SRLW, `ISA_FN3_SRLW}: begin
                            uop[i][`UOP_FUTYPE]         = `FU_TYPE_IALU;
                            uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_SRL;
                        end
                        {`ISA_FN7_SRAW, `ISA_FN3_SRAW}: begin
                            uop[i][`UOP_FUTYPE]         = `FU_TYPE_IALU;
                            uop_ctrl[i][`UOP_INT_ALUOP] = `INT_ALUOP_SRA;
                        end
                        {`ISA_FN7_RV32M, `ISA_FN3_MULW}: begin
                            uop[i][`UOP_FUTYPE]             = `FU_TYPE_IMUL;
                            uop_ctrl[i][`UOP_INT_MULDIVOP]  = `INT_MULOP_S;
                        end
                        {`ISA_FN7_RV32M, `ISA_FN3_DIVW}: begin
                            uop[i][`UOP_FUTYPE]             = `FU_TYPE_IDIV;
                            uop_ctrl[i][`UOP_INT_MULDIVOP]  = `INT_DIVOP_DIV;
                        end
                        {`ISA_FN7_RV32M, `ISA_FN3_DIVUW}: begin
                            uop[i][`UOP_FUTYPE]             = `FU_TYPE_IDIV;
                            uop_ctrl[i][`UOP_INT_MULDIVOP]  = `INT_DIVOP_DIVU;
                        end
                        {`ISA_FN7_RV32M, `ISA_FN3_REMW}: begin
                            uop[i][`UOP_FUTYPE]             = `FU_TYPE_IDIV;
                            uop_ctrl[i][`UOP_INT_MULDIVOP]  = `INT_DIVOP_REM;
                        end
                        {`ISA_FN7_RV32M, `ISA_FN3_REMUW}: begin
                            uop[i][`UOP_FUTYPE]             = `FU_TYPE_IDIV;
                            uop_ctrl[i][`UOP_INT_MULDIVOP]  = `INT_DIVOP_REMU;
                        end
                        default: uop[i][`UOP_EXCEPTION] = 1'b1;
                    endcase
                end

                `ISA_OP_MADD, `ISA_OP_MSUB, `ISA_OP_NMSUB, `ISA_OP_NMADD: begin
                    uop[i][`UOP_FUTYPE]     = `FU_TYPE_FMUL;
                    uop[i][`UOP_REG_WE]     = 1'b1;
                    uop[i][`UOP_IMM]        = 0;
                    uop[i][`UOP_IS_RD]      = 1'b1;
                    uop[i][`UOP_RD_TYPE]    = `REG_TYPE_FP;
                    uop[i][`UOP_RD]         = rd[i];
                    uop[i][`UOP_IS_RS1]     = 1'b1;
                    uop[i][`UOP_RS1_TYPE]   = `REG_TYPE_FP;
                    uop[i][`UOP_RS1]        = rs1[i];
                    uop[i][`UOP_IS_RS2]     = 1'b1;
                    uop[i][`UOP_RS2_TYPE]   = `REG_TYPE_FP;
                    uop[i][`UOP_RS2]        = rs2[i];
                    uop[i][`UOP_IS_RS3]     = 1'b1;
                    uop[i][`UOP_RS3]        = Instr[i][`ISA_RS3_RANGE];
                    uop[i][`UOP_OP1_SEL]    = `OP1_SEL_RS1;
                    uop[i][`UOP_OP2_SEL]    = `OP2_SEL_RS2;
                    uop[i][`UOP_OP3_SEL]    = `OP3_SEL_FRS3;
                    uop[i][`UOP_RSTYPE]     = `RS_TYPE_FP;

                    uop_ctrl[i][`UOP_FPU_IS_RS3] = 1'b1;
                    uop_ctrl[i][`UOP_FPU_ROUND]  = fn3[i];
                    uop_ctrl[i][`UOP_FPU_OP]     = `FPU_OP_FMA;
                    case(Instr[i][`ISA_OP_RANGE])
                        `ISA_OP_MADD:  uop_ctrl[i][`UOP_FPU_SUBOP]  = `FPU_SUBOP_FMADD;
                        `ISA_OP_MSUB:  uop_ctrl[i][`UOP_FPU_SUBOP]  = `FPU_SUBOP_FMSUB;
                        `ISA_OP_NMSUB: uop_ctrl[i][`UOP_FPU_SUBOP]  = `FPU_SUBOP_FNMSUB;
                        `ISA_OP_NMADD: uop_ctrl[i][`UOP_FPU_SUBOP]  = `FPU_SUBOP_FNMADD;
                        default:       uop_ctrl[i][`UOP_FPU_SUBOP]  = 3'b111;   //will never occure
                    endcase
                    if(Instr[i][`ISA_FN2_RANGE]==`ISA_FN2_MADDS)        //SP
                        uop_ctrl[i][`UOP_FPU_IS_DP] = 1'b0;
                    else if(Instr[i][`ISA_FN2_RANGE]==`ISA_FN2_MADDD)   //DP
                        uop_ctrl[i][`UOP_FPU_IS_DP] = 1'b1;
                    else
                        uop[i][`UOP_EXCEPTION] = 1'b1;

                    //status.FS == OFF Check
                    if(csr_status_fs==`XSTATUS_FS__OFF)
                        uop[i][`UOP_EXCEPTION] = 1'b1;
                end

                `ISA_OP_OPFP: begin
                    //assigning most common values, special cases will
                    //override later
                    uop[i][`UOP_FUTYPE]     = `FU_TYPE_FALU;
                    uop[i][`UOP_REG_WE]     = 1'b1;
                    uop[i][`UOP_IMM]        = 0;
                    uop[i][`UOP_IS_RD]      = 1'b1;
                    uop[i][`UOP_RD_TYPE]    = `REG_TYPE_FP;
                    uop[i][`UOP_RD]         = rd[i];
                    uop[i][`UOP_IS_RS1]     = 1'b1;
                    uop[i][`UOP_RS1_TYPE]   = `REG_TYPE_FP;
                    uop[i][`UOP_RS1]        = rs1[i];
                    uop[i][`UOP_IS_RS2]     = 1'b1;
                    uop[i][`UOP_RS2_TYPE]   = `REG_TYPE_FP;
                    uop[i][`UOP_RS2]        = rs2[i];
                    uop[i][`UOP_OP1_SEL]    = `OP1_SEL_RS1;
                    uop[i][`UOP_OP2_SEL]    = `OP2_SEL_RS2;
                    uop[i][`UOP_RSTYPE]     = `RS_TYPE_FP;
                    uop_ctrl[i][`UOP_FPU_ROUND] = fn3[i];

                    if(fn7[i][1:0]==2'b00)                  //SP
                        uop_ctrl[i][`UOP_FPU_IS_DP] = 1'b0;
                    else if(fn7[i][1:0]==2'b01)             //DP
                        uop_ctrl[i][`UOP_FPU_IS_DP] = 1'b1;
                    else                                    //Others
                        uop[i][`UOP_EXCEPTION] = 1'b1;

                    case(fn7[i][6:2])
                        `ISA_FN5_FADD: begin
                            uop_ctrl[i][`UOP_FPU_OP]    = `FPU_OP_ALU;
                            uop_ctrl[i][`UOP_FPU_SUBOP] = `FPU_SUBOP_ALU_ADD;
                        end

                        `ISA_FN5_FSUB: begin
                            uop_ctrl[i][`UOP_FPU_OP]    = `FPU_OP_ALU;
                            uop_ctrl[i][`UOP_FPU_SUBOP] = `FPU_SUBOP_ALU_SUB;
                        end

                        `ISA_FN5_FMUL: begin
                            uop[i][`UOP_FUTYPE]         = `FU_TYPE_FMUL;
                            uop_ctrl[i][`UOP_FPU_OP]    = `FPU_OP_MUL;
                        end

                        `ISA_FN5_FDIV: begin
                            uop[i][`UOP_FUTYPE]         = `FU_TYPE_FDIV;
                            uop_ctrl[i][`UOP_FPU_OP]    = `FPU_OP_DIV;
                        end

                        `ISA_FN5_FSQRT: begin
                            uop[i][`UOP_IS_RS2]         = 1'b0;
                            uop_ctrl[i][`UOP_FPU_OP]    = `FPU_OP_SQRT;
                            if(rs2[i]!=`ISA_RS2_FSQRT)
                                uop[i][`UOP_EXCEPTION]   = 1'b1;
                        end

                        `ISA_FN5_FSGNJ: begin
                            uop_ctrl[i][`UOP_FPU_OP]    = `FPU_OP_CNV;
                            case(fn3[i])
                                `ISA_FN3_FSGNJ : uop_ctrl[i][`UOP_FPU_SUBOP] = `FPU_SUBOP_CNV_SI;
                                `ISA_FN3_FSGNJN: uop_ctrl[i][`UOP_FPU_SUBOP] = `FPU_SUBOP_CNV_SINEG;
                                `ISA_FN3_FSGNJX: uop_ctrl[i][`UOP_FPU_SUBOP] = `FPU_SUBOP_CNV_SIXOR;
                                default: uop[i][`UOP_EXCEPTION]  = 1'b1;
                            endcase
                        end

                        `ISA_FN5_FMINMAX: begin
                            uop_ctrl[i][`UOP_FPU_OP]    = `FPU_OP_CMP;
                            case(fn3[i])
                                `ISA_FN3_FMIN: uop_ctrl[i][`UOP_FPU_SUBOP] = `FPU_SUBOP_CMP_MIN;
                                `ISA_FN3_FMAX: uop_ctrl[i][`UOP_FPU_SUBOP] = `FPU_SUBOP_CMP_MAX;
                                default: uop[i][`UOP_EXCEPTION]  = 1'b1;
                            endcase
                        end

                        `ISA_FN5_FCMP: begin
                            uop_ctrl[i][`UOP_FPU_OP]    = `FPU_OP_CMP;
                            uop[i][`UOP_RD_TYPE]        = `REG_TYPE_INT;
                            case(fn3[i])
                                `ISA_FN3_FEQ: uop_ctrl[i][`UOP_FPU_SUBOP] = `FPU_SUBOP_CMP_EQ;
                                `ISA_FN3_FLT: uop_ctrl[i][`UOP_FPU_SUBOP] = `FPU_SUBOP_CMP_LT;
                                `ISA_FN3_FLE: uop_ctrl[i][`UOP_FPU_SUBOP] = `FPU_SUBOP_CMP_LE;
                                default: uop[i][`UOP_EXCEPTION]  = 1'b1;
                            endcase
                        end

                        `ISA_FN5_FCVT_I2F : begin
                            uop[i][`UOP_IS_RS2]         = 1'b0;
                            uop[i][`UOP_RS1_TYPE]       = `REG_TYPE_INT;
                            uop_ctrl[i][`UOP_FPU_OP]    = `FPU_OP_CNV;
                            case(rs2[i])
                                `ISA_RS2_FCVTSL : begin
                                    uop_ctrl[i][`UOP_FPU_SUBOP]   = `FPU_SUBOP_CNV_I2FP;
                                    uop_ctrl[i][`UOP_FPU_IS_WORD] = 1'b0;
                                end
                                `ISA_RS2_FCVTSW : begin
                                    uop_ctrl[i][`UOP_FPU_SUBOP]   = `FPU_SUBOP_CNV_I2FP;
                                    uop_ctrl[i][`UOP_FPU_IS_WORD] = 1'b1;
                                end
                                `ISA_RS2_FCVTSLU: begin
                                    uop_ctrl[i][`UOP_FPU_SUBOP]   = `FPU_SUBOP_CNV_IU2FP;
                                    uop_ctrl[i][`UOP_FPU_IS_WORD] = 1'b0;
                                end
                                `ISA_RS2_FCVTSWU: begin
                                    uop_ctrl[i][`UOP_FPU_SUBOP]   = `FPU_SUBOP_CNV_IU2FP;
                                    uop_ctrl[i][`UOP_FPU_IS_WORD] = 1'b1;
                                end
                                default: uop[i][`UOP_EXCEPTION] = 1'b1;
                            endcase
                        end

                        `ISA_FN5_FCVT_F2I : begin
                            uop[i][`UOP_IS_RS2]         = 1'b0;
                            uop[i][`UOP_RD_TYPE]        = `REG_TYPE_INT;
                            uop_ctrl[i][`UOP_FPU_OP]    = `FPU_OP_CNV;
                            case(rs2[i])
                                `ISA_RS2_FCVTLS : begin
                                    uop_ctrl[i][`UOP_FPU_SUBOP]   = `FPU_SUBOP_CNV_FP2I;
                                    uop_ctrl[i][`UOP_FPU_IS_WORD] = 1'b0;
                                end
                                `ISA_RS2_FCVTWS : begin
                                    uop_ctrl[i][`UOP_FPU_SUBOP]   = `FPU_SUBOP_CNV_FP2I;
                                    uop_ctrl[i][`UOP_FPU_IS_WORD] = 1'b1;
                                end
                                `ISA_RS2_FCVTLUS: begin
                                    uop_ctrl[i][`UOP_FPU_SUBOP]   = `FPU_SUBOP_CNV_FP2IU;
                                    uop_ctrl[i][`UOP_FPU_IS_WORD] = 1'b0;
                                end
                                `ISA_RS2_FCVTWUS: begin
                                    uop_ctrl[i][`UOP_FPU_SUBOP]   = `FPU_SUBOP_CNV_FP2IU;
                                    uop_ctrl[i][`UOP_FPU_IS_WORD] = 1'b1;
                                end
                                default: uop[i][`UOP_EXCEPTION] = 1'b1;
                            endcase
                        end

                        `ISA_FN5_FCVT_F2F : begin
                            uop[i][`UOP_IS_RS2]         = 1'b0;
                            uop_ctrl[i][`UOP_FPU_OP]    = `FPU_OP_CNV;
                            case(rs2[i])
                                `ISA_RS2_FCVTSD : uop_ctrl[i][`UOP_FPU_SUBOP] = `FPU_SUBOP_CNV_FP2FP;
                                `ISA_RS2_FCVTDS : uop_ctrl[i][`UOP_FPU_SUBOP] = `FPU_SUBOP_CNV_FP2FP;
                                default: uop[i][`UOP_EXCEPTION] = 1'b1;
                            endcase
                        end

                        `ISA_FN5_FMV_F2I: begin
                            uop[i][`UOP_IS_RS2]         = 1'b0;
                            uop[i][`UOP_RD_TYPE]        = `REG_TYPE_INT;
                            uop_ctrl[i][`UOP_FPU_OP]    = `FPU_OP_TRN;
                            if(fn3[i]==`ISA_FN3_FMV) begin
                                if(rs2[i]==`ISA_RS2_FMVWX)
                                    uop_ctrl[i][`UOP_FPU_SUBOP] = `FPU_SUBOP_TRN_FP2INT;
                                else
                                    uop[i][`UOP_EXCEPTION] = 1'b1;
                            end
                            else if(fn3[i]==`ISA_FN3_FCLASS)
                                uop_ctrl[i][`UOP_FPU_SUBOP] = `FPU_SUBOP_TRN_FCLASS;
                            else
                                uop[i][`UOP_EXCEPTION] = 1'b1;
                        end

                        `ISA_FN5_FMV_I2F: begin
                            uop[i][`UOP_IS_RS2]         = 1'b0;
                            uop[i][`UOP_RS1_TYPE]       = `REG_TYPE_INT;
                            uop_ctrl[i][`UOP_FPU_OP]    = `FPU_OP_TRN;
                            if(fn3[i]==`ISA_FN3_FMV) begin
                                if(rs2[i]==`ISA_RS2_FMVXW)
                                    uop_ctrl[i][`UOP_FPU_SUBOP] = `FPU_SUBOP_TRN_INT2FP;
                                else
                                    uop[i][`UOP_EXCEPTION] = 1'b1;
                            end
                            else
                                uop[i][`UOP_EXCEPTION] = 1'b1;
                        end

                        default: uop[i][`UOP_EXCEPTION] = 1'b1;
                    endcase

                    //status.FS == OFF Check
                    if(csr_status_fs==`XSTATUS_FS__OFF)
                        uop[i][`UOP_EXCEPTION] = 1'b1;
                end

                `ISA_OP_BRANCH: begin
                    uop[i][`UOP_FUTYPE]     = `FU_TYPE_BRANCH;
                    uop[i][`UOP_REG_WE]     = 1'b0;
                    uop[i][`UOP_IMM]        = Unpack_B(Instr[i]);
                    uop[i][`UOP_IS_RD]      = 1'b0;
                    uop[i][`UOP_IS_RS1]     = 1'b1;
                    uop[i][`UOP_RS1_TYPE]   = `REG_TYPE_INT;
                    uop[i][`UOP_RS1]        = rs1[i];
                    uop[i][`UOP_IS_RS2]     = 1'b1;
                    uop[i][`UOP_RS2_TYPE]   = `REG_TYPE_INT;
                    uop[i][`UOP_RS2]        = rs2[i];
                    uop[i][`UOP_OP1_SEL]    = `OP1_SEL_RS1;
                    uop[i][`UOP_OP2_SEL]    = `OP2_SEL_RS2;
                    uop[i][`UOP_OP3_SEL]    = `OP3_SEL_IMM;
                    uop[i][`UOP_RSTYPE]     = `RS_TYPE_BR;

                    uop_ctrl[i][`UOP_BR_SUBTYPE]  = fn3[i];
                    uop_ctrl[i][`UOP_BR_TYPE]     = IB_Entry[i][`IB_ENTRY_BRTYPE];
                    uop_ctrl[i][`UOP_BR_FETCHPCL] = IB_Entry[i][`IB_ENTRY_FETCHPCL];
                    uop_ctrl[i][`UOP_BR_BINDEX]   = IB_Entry[i][`IB_ENTRY_BINDEX];
                    uop_ctrl[i][`UOP_BR_IS_16BIT] = IB_Entry[i][`IB_ENTRY_IS16BIT];
                    uop_ctrl[i][`UOP_BR_TARGET]   = IB_Entry[i][`IB_ENTRY_BRTARGET];
                    uop_ctrl[i][`UOP_BR_TAKEN]    = IB_Entry[i][`IB_ENTRY_BRTAKEN];
                    uop_ctrl[i][`UOP_BR_DP2BC]    = IB_Entry[i][`IB_ENTRY_DP2BC];
                    uop_ctrl[i][`UOP_BR_BTB2BC]   = IB_Entry[i][`IB_ENTRY_BTB2BC];
                    uop_ctrl[i][`UOP_BR_BTBHIT]   = IB_Entry[i][`IB_ENTRY_BTBHIT];
                    uop_ctrl[i][`UOP_BR_BTBWAY]   = IB_Entry[i][`IB_ENTRY_BTBWAY];
                    uop_ctrl[i][`UOP_BR_SPECTAG]  = 0;

                    AllocateNewSpectag[i] = 1'b1;
                end

                `ISA_OP_JALR: begin
                    uop[i][`UOP_FUTYPE]     = `FU_TYPE_BRANCH;
                    uop[i][`UOP_REG_WE]     = 1'b1;
                    uop[i][`UOP_IMM]        = Unpack_I(Instr[i]);
                    uop[i][`UOP_IS_RD]      = 1'b1;
                    uop[i][`UOP_RD_TYPE]    = `REG_TYPE_INT;
                    uop[i][`UOP_RD]         = rd[i];
                    uop[i][`UOP_IS_RS1]     = 1'b1;
                    uop[i][`UOP_RS1_TYPE]   = `REG_TYPE_INT;
                    uop[i][`UOP_RS1]        = rs1[i];
                    uop[i][`UOP_IS_RS2]     = 1'b0;
                    uop[i][`UOP_OP1_SEL]    = `OP1_SEL_RS1;
                    uop[i][`UOP_OP2_SEL]    = `OP2_SEL_IMM;
                    uop[i][`UOP_OP3_SEL]    = `OP3_SEL_IMM;
                    uop[i][`UOP_RSTYPE]     = `RS_TYPE_BR;

                    uop_ctrl[i][`UOP_BR_IS_JALR]  = 1'b1;
                    uop_ctrl[i][`UOP_BR_TYPE]     = IB_Entry[i][`IB_ENTRY_BRTYPE];
                    uop_ctrl[i][`UOP_BR_FETCHPCL] = IB_Entry[i][`IB_ENTRY_FETCHPCL];
                    uop_ctrl[i][`UOP_BR_BINDEX]   = IB_Entry[i][`IB_ENTRY_BINDEX];
                    uop_ctrl[i][`UOP_BR_IS_16BIT] = IB_Entry[i][`IB_ENTRY_IS16BIT];
                    uop_ctrl[i][`UOP_BR_TARGET]   = IB_Entry[i][`IB_ENTRY_BRTARGET];
                    uop_ctrl[i][`UOP_BR_TAKEN]    = IB_Entry[i][`IB_ENTRY_BRTAKEN];
                    uop_ctrl[i][`UOP_BR_DP2BC]    = IB_Entry[i][`IB_ENTRY_DP2BC];
                    uop_ctrl[i][`UOP_BR_BTB2BC]   = IB_Entry[i][`IB_ENTRY_BTB2BC];
                    uop_ctrl[i][`UOP_BR_BTBHIT]   = IB_Entry[i][`IB_ENTRY_BTBHIT];
                    uop_ctrl[i][`UOP_BR_BTBWAY]   = IB_Entry[i][`IB_ENTRY_BTBWAY];
                    uop_ctrl[i][`UOP_BR_SPECTAG]  = 0;

                    AllocateNewSpectag[i] = 1'b1;
                end

                `ISA_OP_JAL: begin
                    uop[i][`UOP_FUTYPE]     = `FU_TYPE_BRANCH;
                    uop[i][`UOP_REG_WE]     = 1'b1;
                    uop[i][`UOP_IMM]        = Unpack_J(Instr[i]);
                    uop[i][`UOP_IS_RD]      = 1'b1;
                    uop[i][`UOP_RD_TYPE]    = `REG_TYPE_INT;
                    uop[i][`UOP_RD]         = rd[i];
                    uop[i][`UOP_IS_RS1]     = 1'b0;
                    uop[i][`UOP_IS_RS2]     = 1'b0;
                    uop[i][`UOP_OP1_SEL]    = `OP1_SEL_PC;
                    uop[i][`UOP_OP2_SEL]    = `OP2_SEL_IMM;
                    uop[i][`UOP_OP3_SEL]    = `OP3_SEL_IMM;
                    uop[i][`UOP_RSTYPE]     = `RS_TYPE_BR;

                    uop_ctrl[i][`UOP_BR_IS_JAL]   = 1'b1;
                    uop_ctrl[i][`UOP_BR_TYPE]     = IB_Entry[i][`IB_ENTRY_BRTYPE];
                    uop_ctrl[i][`UOP_BR_FETCHPCL] = IB_Entry[i][`IB_ENTRY_FETCHPCL];
                    uop_ctrl[i][`UOP_BR_BINDEX]   = IB_Entry[i][`IB_ENTRY_BINDEX];
                    uop_ctrl[i][`UOP_BR_IS_16BIT] = IB_Entry[i][`IB_ENTRY_IS16BIT];
                    uop_ctrl[i][`UOP_BR_TARGET]   = IB_Entry[i][`IB_ENTRY_BRTARGET];
                    uop_ctrl[i][`UOP_BR_TAKEN]    = IB_Entry[i][`IB_ENTRY_BRTAKEN];
                    uop_ctrl[i][`UOP_BR_DP2BC]    = IB_Entry[i][`IB_ENTRY_DP2BC];
                    uop_ctrl[i][`UOP_BR_BTB2BC]   = IB_Entry[i][`IB_ENTRY_BTB2BC];
                    uop_ctrl[i][`UOP_BR_BTBHIT]   = IB_Entry[i][`IB_ENTRY_BTBHIT];
                    uop_ctrl[i][`UOP_BR_BTBWAY]   = IB_Entry[i][`IB_ENTRY_BTBWAY];
                    uop_ctrl[i][`UOP_BR_SPECTAG]  = 0;

                    //no need to allocate new spectag after this instr. As
                    //JAL can never be mispredicted.
                end

                `ISA_OP_SYSTEM: begin
                    uop[i][`UOP_FUTYPE] = `FU_TYPE_SYSTEM;
                    uop[i][`UOP_RSTYPE] = `RS_TYPE_BR;   //HACK: Multiplexed with Br as no typedef for System as of now

                    //XXX: Force all previous instr to completed before exec SYSTEM instr
                    uop[i][`UOP_WAIT_TILL_EMPTY] = 1'b1;

                    //XXX: Doesn't matter; as frontend gonna redirect in most cases.
                    //'stall' is preferred over 'flush' as it avoids phy reg & spectag allocation
                    uop[i][`UOP_STALL_TILL_RETIRE] = 1'b1;

                    uop_ctrl[i][`UOP_SYS_IS_16BIT] = IB_Entry[i][`IB_ENTRY_IS16BIT];

                    if(fn3[i]!=3'b000) begin    //CSR Instr
                        uop[i][`UOP_REG_WE]             = 1'b1;
                        uop[i][`UOP_IMM]                = {{32-12{1'b0}},Instr[i][`ISA_CSR_RANGE]};
                        uop[i][`UOP_IS_RD]              = 1'b1;
                        uop[i][`UOP_RD_TYPE]            = `REG_TYPE_INT;
                        uop[i][`UOP_RD]                 = rd[i];
                        uop[i][`UOP_IS_RS1]             = fn3[i][2] ? 1'b0 : 1'b1;  //Is_RS1=0 for Immediate CSR instructions
                        uop[i][`UOP_RS1_TYPE]           = `REG_TYPE_INT;
                        uop[i][`UOP_RS1]                = rs1[i];
                        uop[i][`UOP_IS_RS2]             = 1'b0;
                        uop[i][`UOP_OP1_SEL]            = `OP1_SEL_RS1;
                        uop[i][`UOP_OP2_SEL]            = `OP2_SEL_IMM;
                        uop_ctrl[i][`UOP_SYS_IS_CSR]    = 1'b1;
                        uop_ctrl[i][`UOP_SYS_CSR_SUBOP] = fn3[i];
                        uop_ctrl[i][`UOP_SYS_CSR_DATA]  = rs1[i];
`ifdef RELAXED_CSR
                        //Set ordering rules for CSRs
                        case(Instr[i][`ISA_CSR_RANGE])
                            //Strictly ordered as per spec (Zicsr User Spec 9.1)
                            `CSR_TIME, `CSR_CYCLE, `CSR_MCYCLE: begin
                                uop[i][`UOP_WAIT_TILL_EMPTY]   = 1'b1;
                                uop[i][`UOP_STALL_TILL_RETIRE] = 1'b1;
                            end

                            //Partially Relaxed (only prior instruction should
                            //be completed, no constraint on later
                            //instructions in program order)
                            //These CSR has no side effects (and if present
                            //they can be handled by value dependency)
                            `CSR_INSTRET, `CSR_MINSTRET,
                            `CSR_MSCRATCH, `CSR_SSCRATCH, `CSR_USCRATCH,
                            `CSR_MCAUSE, `CSR_SCAUSE, `CSR_UCAUSE,
                            `CSR_MTVAL, `CSR_STVAL, `CSR_UTVAL,
                            `CSR_MTVEC, `CSR_STVEC, `CSR_UTVEC : begin
                                uop[i][`UOP_WAIT_TILL_EMPTY]   = 1'b1;
                                uop[i][`UOP_STALL_TILL_RETIRE] = 1'b0;
                            end

                            //Fake Fully relaxed (As per CSR behaviour, these
                            //CSRs should be fully relaxed, but implementation
                            //do not support (XXX: Dispatch Unit dispatches to
                            //RS_SYS from 0th request only
                            `CSR_MISA, `CSR_MVENDORID, `CSR_MARCHID, `CSR_MIMPID, `CSR_MHARTID: begin
                                uop[i][`UOP_WAIT_TILL_EMPTY]   = 1'b1;
                                uop[i][`UOP_STALL_TILL_RETIRE] = 1'b0;
                            end

                            //default: strictly ordered
                            //Strictly Ordered as per implementation (these
                            //CSR has side effects)
                            default: begin
                                uop[i][`UOP_WAIT_TILL_EMPTY]   = 1'b1;
                                uop[i][`UOP_STALL_TILL_RETIRE] = 1'b1;
                            end
                        endcase
`endif
                    end
                    else if(Instr[i]==`ISA_INS_URET) begin
                        uop_ctrl[i][`UOP_SYS_IS_URET]  = 1'b1;
                    end
                    else if(Instr[i]==`ISA_INS_SRET) begin
                        uop_ctrl[i][`UOP_SYS_IS_SRET]  = 1'b1;
                    end
                    else if(Instr[i]==`ISA_INS_MRET) begin
                        uop_ctrl[i][`UOP_SYS_IS_MRET]  = 1'b1;
                    end
                    else if(Instr[i]==`ISA_INS_WFI) begin
                        uop_ctrl[i][`UOP_SYS_IS_WFI]   = 1'b1;
                    end
                    else if(Instr[i]==`ISA_INS_ECALL) begin
                        uop_ctrl[i][`UOP_SYS_IS_ECALL] = 1'b1;
                    end
                    else if(Instr[i]==`ISA_INS_EBREAK) begin
                        uop_ctrl[i][`UOP_SYS_IS_EBRK]  = 1'b1;
                    end
                    else if(fn7[i]==`ISA_FN7_SFENCEVMA) begin
                        uop[i][`UOP_IS_RS1]                = 1'b1;
                        uop[i][`UOP_RS1_TYPE]              = `REG_TYPE_INT;
                        uop[i][`UOP_RS1]                   = rs1[i];
                        uop[i][`UOP_IS_RS2]                = 1'b1;
                        uop[i][`UOP_RS2_TYPE]              = `REG_TYPE_INT;
                        uop[i][`UOP_RS2]                   = rs2[i];
                        uop[i][`UOP_OP1_SEL]               = `OP1_SEL_RS1;
                        uop[i][`UOP_OP2_SEL]               = `OP2_SEL_RS2;
                        uop_ctrl[i][`UOP_SYS_IS_SFENCEVMA] = 1'b1;
                        uop_ctrl[i][`UOP_SYS_DATA]         = Instr[i][31:7];
                    end
                    else
                        uop[i][`UOP_EXCEPTION] = 1'b1;
                end

                default: uop[i][`UOP_EXCEPTION] = 1'b1;
            endcase //end opcode case

            //Replace Instruction with Exception by NOP and set appropriate
            //decoded uop fields
            if(uop[i][`UOP_EXCEPTION] || IB_Entry[i][`IB_ENTRY_EXCEPTION]) begin
                //Set Final Exception bit
                uop[i][`UOP_EXCEPTION] = 1'b1;

                //set cause as per exception type
                uop[i][`UOP_ECAUSE] = IB_Entry[i][`IB_ENTRY_EXCEPTION] ? IB_Entry[i][`IB_ENTRY_ECAUSE] : `EXC_ILLEGAL_INSTR;

                //Override Spectag Allocation
                AllocateNewSpectag[i] = 1'b0;

                //change uOP to NOP equivalent [ADD x0, x0, x0] (only update overriding fields)
                uop[i][`UOP_WAIT_TILL_EMPTY ]   = 1'b0;
                uop[i][`UOP_STALL_TILL_RETIRE]  = 1'b0;
                uop[i][`UOP_REG_WE    ]         = 1'b0;
                uop[i][`UOP_FUTYPE    ]         = `FU_TYPE_IALU;
                uop[i][`UOP_RD_TYPE   ]         = `REG_TYPE_INT;
                uop[i][`UOP_RS1_TYPE  ]         = `REG_TYPE_INT;
                uop[i][`UOP_RS2_TYPE  ]         = `REG_TYPE_INT;
                uop[i][`UOP_OP1_SEL   ]         = `OP1_SEL_R0;
                uop[i][`UOP_OP2_SEL   ]         = `OP2_SEL_R0;
                uop[i][`UOP_RSTYPE    ]         = `RS_TYPE_INT;
                uop[i][`UOP_IS_RD     ]         = 1'b0;
                uop[i][`UOP_IS_RS1    ]         = 1'b0;
                uop[i][`UOP_IS_RS2    ]         = 1'b0;
                uop[i][`UOP_IS_RS3    ]         = 1'b0;
                uop[i][`UOP_RD        ]         = `ISA_ZERO;
                uop[i][`UOP_RS1       ]         = `ISA_ZERO;
                uop[i][`UOP_RS2       ]         = `ISA_ZERO;
                uop[i][`UOP_RS3       ]         = `ISA_ZERO;
                uop_ctrl[i]                     = 0;
                uop_ctrl[i][`UOP_INT_ALUOP]     = `INT_ALUOP_ADD;
            end //end exception oveeride if
        end //end valid if
    end //end for loop
end //end process


//6. Final uop assembly (merges uop_ctrl to uop, add exception reason
//When rd =x0 => is_rd=0;   reg_we=0;
//when rs1=x0 => is_rs1=0;  op1_sel=R0;
//when rs2=x0 => is_rs2=0;  op2_sel=R0;
wire [`UOP_LEN-1:0] final_uop[0:`DECODE_RATE-1];
wire                IsRs1_x0[0:`DECODE_RATE-1];
wire                IsRs2_x0[0:`DECODE_RATE-1];
wire                IsRd_x0[0:`DECODE_RATE-1];
genvar ga;
generate
    for(ga=0;ga<`DECODE_RATE;ga=ga+1) begin

        assign IsRs1_x0[ga] = uop[ga][`UOP_IS_RS1] & (uop[ga][`UOP_RS1_TYPE]==`REG_TYPE_INT) & (uop[ga][`UOP_RS1]==`ISA_ZERO);
        assign IsRs2_x0[ga] = uop[ga][`UOP_IS_RS2] & (uop[ga][`UOP_RS2_TYPE]==`REG_TYPE_INT) & (uop[ga][`UOP_RS2]==`ISA_ZERO);
        assign IsRd_x0[ga]  = uop[ga][`UOP_IS_RD]  & (uop[ga][`UOP_RD_TYPE]==`REG_TYPE_INT)  & (uop[ga][`UOP_RD]==`ISA_ZERO);

        assign final_uop[ga][`UOP_VALID     ] = uop[ga][`UOP_VALID     ];
        assign final_uop[ga][`UOP_PC        ] = uop[ga][`UOP_PC        ];
        assign final_uop[ga][`UOP_SPECTAG   ] = 0;
        assign final_uop[ga][`UOP_KILLMASK  ] = 0;

        assign final_uop[ga][`UOP_WAIT_TILL_EMPTY ]  = uop[ga][`UOP_WAIT_TILL_EMPTY ];
        assign final_uop[ga][`UOP_STALL_TILL_RETIRE] = uop[ga][`UOP_STALL_TILL_RETIRE];

        assign final_uop[ga][`UOP_REG_WE    ] = IsRd_x0[ga] ? 1'b0 : uop[ga][`UOP_REG_WE];

        assign final_uop[ga][`UOP_FUTYPE    ] = uop[ga][`UOP_FUTYPE    ];
        assign final_uop[ga][`UOP_INSTR     ] = uop[ga][`UOP_INSTR     ];
        assign final_uop[ga][`UOP_IMM       ] = uop[ga][`UOP_IMM       ];
        assign final_uop[ga][`UOP_RD_TYPE   ] = uop[ga][`UOP_RD_TYPE   ];
        assign final_uop[ga][`UOP_RS1_TYPE  ] = uop[ga][`UOP_RS1_TYPE  ];
        assign final_uop[ga][`UOP_RS2_TYPE  ] = uop[ga][`UOP_RS2_TYPE  ];
        assign final_uop[ga][`UOP_PRD       ] = 0;
        assign final_uop[ga][`UOP_PRS1      ] = 0;
        assign final_uop[ga][`UOP_PRS2      ] = 0;
        assign final_uop[ga][`UOP_PRS3      ] = 0;

        assign final_uop[ga][`UOP_OP1_SEL   ] = IsRs1_x0[ga] ? `OP1_SEL_R0 : uop[ga][`UOP_OP1_SEL];

        assign final_uop[ga][`UOP_OP2_SEL   ] = IsRs2_x0[ga] ? `OP2_SEL_R0 : uop[ga][`UOP_OP2_SEL];
        assign final_uop[ga][`UOP_OP3_SEL   ] = uop[ga][`UOP_OP3_SEL];

        assign final_uop[ga][`UOP_EXCEPTION ] = uop[ga][`UOP_EXCEPTION ];
        assign final_uop[ga][`UOP_ECAUSE    ] = uop[ga][`UOP_ECAUSE];

        assign final_uop[ga][`UOP_CONTROLS  ] = uop_ctrl[ga];

        assign final_uop[ga][`UOP_RSTYPE    ] = uop[ga][`UOP_RSTYPE    ];

        assign final_uop[ga][`UOP_IS_RD     ] = IsRd_x0[ga]  ? 1'b0 : uop[ga][`UOP_IS_RD];

        assign final_uop[ga][`UOP_IS_RS1    ] = IsRs1_x0[ga] ? 1'b0 : uop[ga][`UOP_IS_RS1];

        assign final_uop[ga][`UOP_IS_RS2    ] = IsRs2_x0[ga] ? 1'b0 : uop[ga][`UOP_IS_RS2];

        assign final_uop[ga][`UOP_IS_RS3    ] = uop[ga][`UOP_IS_RS3    ];
        assign final_uop[ga][`UOP_RD        ] = uop[ga][`UOP_RD        ];
        assign final_uop[ga][`UOP_RS1       ] = uop[ga][`UOP_RS1       ];
        assign final_uop[ga][`UOP_RS2       ] = uop[ga][`UOP_RS2       ];
        assign final_uop[ga][`UOP_RS3       ] = uop[ga][`UOP_RS3       ];

        assign Uops[(ga*`UOP_LEN)+:`UOP_LEN]  = final_uop[ga];
    end
endgenerate


endmodule
