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
`include "ISA_defines.vh"

module RVC_Decompressor
(
    input  wire [15:0]  Instr16,

    output reg  [31:0]  Instr32,
    output reg  [31:0]  Imm,
    output reg          Invalid,
    output reg          Hint
);
`include "ISA_func.v"

//extract fields from instr
wire [1:0] quad = Instr16[`ISAC_OP_RANGE];
wire [2:0] fn3  = Instr16[`ISAC_FN3_RANGE];
wire [4:0] rs1c = {2'b01, Instr16[`ISAC_RS1C_RANGE]};
wire [4:0] rs2c = {2'b01, Instr16[`ISAC_RS2C_RANGE]};
wire [4:0] rdcq0= {2'b01, Instr16[`ISAC_RDCQ0_RANGE]};
wire [4:0] rs1  = Instr16[`ISAC_RS1_RANGE];
wire [4:0] rs2  = Instr16[`ISAC_RS2_RANGE];
wire [4:0] rd   = Instr16[`ISAC_RD_RANGE];

//expand immediates (refer 16.8 of User Specification RVC encoding)
wire [31:0] nzuimm;
wire [31:0] uimm_5376;
wire [31:0] uimm_5326;
wire [31:0] nzimm_540;
wire [31:0] imm_11;
wire [31:0] imm_540;
wire [31:0] nzimm_9;
wire [31:0] nzimm_17;
wire [31:0] nzuimm_540;
wire [31:0] imm_843;
wire [31:0] uimm_543;
wire [31:0] uimm_542;
wire [31:0] uimm_5386;
wire [31:0] uimm_5276;

assign {nzuimm[5:4],nzuimm[9:6],nzuimm[2],nzuimm[3]} = Instr16[12:5];
assign {nzuimm[31:10],nzuimm[1:0]} = 0;

assign {uimm_5376[5:3],uimm_5376[7:6]} = {Instr16[12:10],Instr16[6:5]};
assign {uimm_5376[31:8],uimm_5376[2:0]} = 0;

assign {uimm_5326[5:3],uimm_5326[2],uimm_5326[6]} = {Instr16[12:10], Instr16[6:5]};
assign {uimm_5326[31:7],uimm_5326[1:0]} = 0;

assign {nzimm_540[5],nzimm_540[4:0]} = {Instr16[12],Instr16[6:2]};
assign nzimm_540[31:6] = {26{Instr16[12]}};

assign {imm_11[11],imm_11[4],imm_11[9:8],imm_11[10],imm_11[6],imm_11[7],imm_11[3:1],imm_11[5]} = Instr16[12:2];
assign imm_11[31:12] = {20{Instr16[12]}};

assign {imm_540[5],imm_540[4:0]} = {Instr16[12],Instr16[6:2]};
assign imm_540[31:6] = {26{Instr16[12]}};

assign {nzimm_9[9],nzimm_9[4],nzimm_9[6],nzimm_9[8:7],nzimm_9[5]} = {Instr16[12],Instr16[6:2]};
assign nzimm_9[3:0] = 0;
assign nzimm_9[31:10] = {22{Instr16[12]}};

assign {nzimm_17[17],nzimm_17[16:12]} = {Instr16[12],Instr16[6:2]};
assign nzimm_17[11:0] = 0;
assign nzimm_17[31:18] = {14{Instr16[12]}};

assign {nzuimm_540[5],nzuimm_540[4:0]} = {Instr16[12],Instr16[6:2]};
assign nzuimm_540[31:6] = 0;

assign {imm_843[8],imm_843[4:3],imm_843[7:6],imm_843[2:1],imm_843[5]} = {Instr16[12:10],Instr16[6:2]};
assign imm_843[0] = 0;
assign imm_843[31:9] = {23{Instr16[12]}};

assign {uimm_543[5],uimm_543[4:3],uimm_543[8:6]} = {Instr16[12],Instr16[6:2]};
assign {uimm_543[31:9],uimm_543[2:0]} = 0;

assign {uimm_542[5],uimm_542[4:2], uimm_542[7:6]} = {Instr16[12],Instr16[6:2]};
assign {uimm_542[31:8],uimm_542[1:0]} = 0;

assign {uimm_5386[5:3],uimm_5386[8:6]} = Instr16[12:7];
assign {uimm_5386[31:9],uimm_5386[2:0]} = 0;

assign {uimm_5276[5:2],uimm_5276[7:6]} = Instr16[12:7];
assign {uimm_5276[21:8],uimm_5276[1:0]} = 0;


//convert 16-bit to 32-bit
reg [31:0] I32; //just for short name
always @* begin
    //setting default values
    I32 = `ISA_INS_NOP; Invalid = 0; Hint = 0; Imm = 0; Instr32 = I32;
    case ({fn3,quad})
        {`ISAC_FN3_ADDI4,`ISAC_Q0_OP}: begin
            if(nzuimm==0)                               //RES
                Invalid = 1;
            else begin                                  //C.ADDI4SPN = addi rd',x2,imm
                I32[`ISA_OP_RANGE]  = `ISA_OP_OPIMM;
                I32[`ISA_RD_RANGE]  = rdcq0;
                I32[`ISA_RS1_RANGE] = `ISA_SP;
                Imm                 = nzuimm;
                Instr32             = Pack_I(I32,Imm);
            end
        end

        {`ISAC_FN3_FLD,`ISAC_Q0_OP}: begin              //C.FLD = FLD frd', imm(rs1')
            I32[`ISA_OP_RANGE]  = `ISA_OP_LOADFP;
            I32[`ISA_RD_RANGE]  = rdcq0;
            I32[`ISA_RS1_RANGE] = rs1c;
            I32[`ISA_FN3_RANGE] = `ISA_FN3_FLD;
            Imm                 = uimm_5376;
            Instr32             = Pack_I(I32,Imm);
        end

        {`ISAC_FN3_LW,`ISAC_Q0_OP}: begin               //C.LW = LW rd', imm(rs1')
            I32[`ISA_OP_RANGE]  = `ISA_OP_LOAD;
            I32[`ISA_RD_RANGE]  = rdcq0;
            I32[`ISA_RS1_RANGE] = rs1c;
            I32[`ISA_FN3_RANGE] = `ISA_FN3_LW;
            Imm                 = uimm_5326;
            Instr32             = Pack_I(I32,Imm);
        end

        {`ISAC_FN3_LD,`ISAC_Q0_OP}: begin               //C.LD = LD rd', imm(rs1')
            I32[`ISA_OP_RANGE]  = `ISA_OP_LOAD;
            I32[`ISA_RD_RANGE]  = rdcq0;
            I32[`ISA_RS1_RANGE] = rs1c;
            I32[`ISA_FN3_RANGE] = `ISA_FN3_LD;
            Imm                 = uimm_5376;
            Instr32             = Pack_I(I32,Imm);
        end

        {`ISAC_FN3_FSD,`ISAC_Q0_OP}: begin              //C.FSD = FSD frs2', imm(rs1')
            I32[`ISA_OP_RANGE]  = `ISA_OP_STOREFP;
            I32[`ISA_RS1_RANGE] = rs1c;
            I32[`ISA_RS2_RANGE] = rs2c;
            I32[`ISA_FN3_RANGE] = `ISA_FN3_FSD;
            Imm                 = uimm_5376;
            Instr32             = Pack_S(I32,Imm);
        end

        {`ISAC_FN3_SW, `ISAC_Q0_OP}: begin              //C.SW = SW rs2', imm(rs1')
            I32[`ISA_OP_RANGE]  = `ISA_OP_STORE;
            I32[`ISA_RS1_RANGE] = rs1c;
            I32[`ISA_RS2_RANGE] = rs2c;
            I32[`ISA_FN3_RANGE] = `ISA_FN3_SW;
            Imm                 = uimm_5326;
            Instr32             = Pack_S(I32,Imm);
        end

        {`ISAC_FN3_SD,`ISAC_Q0_OP}: begin               //C.SD = SD rs2', imm(rs1')
            I32[`ISA_OP_RANGE]  = `ISA_OP_STORE;
            I32[`ISA_RS1_RANGE] = rs1c;
            I32[`ISA_RS2_RANGE] = rs2c;
            I32[`ISA_FN3_RANGE] = `ISA_FN3_SD;
            Imm                 = uimm_5376;
            Instr32             = Pack_S(I32,Imm);
        end

        /*------------------------------------------------------------------------------------------*/

        {`ISAC_FN3_ADDI,`ISAC_Q1_OP}: begin
            if((rd==0 && nzimm_540!=0) || (rd!=0 && nzimm_540==0))             //HINT
                Hint = 1;
            else begin                                  //C.ADDI = ADDI rd, rd, imm
                I32[`ISA_OP_RANGE]  = `ISA_OP_OPIMM;
                I32[`ISA_FN3_RANGE] = `ISA_FN3_ADDI;
                I32[`ISA_RS1_RANGE] = rd;
                I32[`ISA_RD_RANGE]  = rd;
                Imm                 = nzimm_540;
                Instr32             = Pack_I(I32,Imm);
            end

        end

        {`ISAC_FN3_ADDIW, `ISAC_Q1_OP}: begin           //C.ADDIW = ADDIW rd, rd, imm
            if(rd==0)
                Invalid = 1;
            else begin
                I32[`ISA_OP_RANGE]  = `ISA_OP_OPIMM32;
                I32[`ISA_FN3_RANGE] = `ISA_FN3_ADDIW;
                I32[`ISA_RS1_RANGE] = rd;
                I32[`ISA_RD_RANGE]  = rd;
                Imm                 = nzimm_540;
                Instr32             = Pack_I(I32,Imm);
            end
        end

        {`ISAC_FN3_LI, `ISAC_Q1_OP}: begin              //C.LI = ADDI rd, x0, imm
            if(rd==0)
                Hint = 1;
            else begin
                I32[`ISA_OP_RANGE]  = `ISA_OP_OPIMM;
                I32[`ISA_FN3_RANGE] = `ISA_FN3_ADDI;
                I32[`ISA_RS1_RANGE] = `ISA_ZERO;
                I32[`ISA_RD_RANGE]  = rd;
                Imm                 = nzimm_540;
                Instr32             = Pack_I(I32,Imm);
            end
        end

        {`ISAC_FN3_LUI, `ISAC_Q1_OP}: begin
            if(rd==2) begin
                if(nzimm_9==0)
                    Invalid = 1;
                else begin                                  //C.ADDI16SP = ADDI x2, x2, imm
                    I32[`ISA_OP_RANGE]  = `ISA_OP_OPIMM;
                    I32[`ISA_FN3_RANGE] = `ISA_FN3_ADDI;
                    I32[`ISA_RS1_RANGE] = `ISA_SP;
                    I32[`ISA_RD_RANGE]  = `ISA_SP;
                    Imm                 = nzimm_9;
                    Instr32             = Pack_I(I32,Imm);
                end
            end
            else if(rd!=0) begin                            //C.LUI = LUI rd, imm
                I32[`ISA_OP_RANGE] = `ISA_OP_LUI;
                I32[`ISA_RD_RANGE] = rd;
                Imm                = nzimm_17;
                Instr32            = Pack_U(I32,Imm);
            end
            else
                Hint = 1;                                   //Hint
        end

        {`ISAC_FN3_ARITH,`ISAC_Q1_OP}: begin
            case(Instr16[11:10])
                2'b00: begin                                                //C.SRLI = SRLI rd', rd', imm
                    I32[`ISA_OP_RANGE]      = `ISA_OP_OPIMM;
                    I32[`ISA_FN3_RANGE]     = `ISA_FN3_SRLI;
                    I32[`ISA_RS1_RANGE]     = rs1c;
                    I32[`ISA_RD_RANGE]      = rs1c;
                    I32[`ISA_FN7_RANGE]     = `ISA_FN7_SRLI;  // Do NOT Reorder
                    I32[`ISA_SHAMT64_RANGE] = nzuimm_540[5:0];// these two
                    Imm                     = nzuimm_540;
                    Instr32                 = I32;
                end

                2'b01: begin                                                //C.SRAI = SRAI rd', rd', imm
                    I32[`ISA_OP_RANGE]      = `ISA_OP_OPIMM;
                    I32[`ISA_FN3_RANGE]     = `ISA_FN3_SRAI;
                    I32[`ISA_RS1_RANGE]     = rs1c;
                    I32[`ISA_RD_RANGE]      = rs1c;
                    I32[`ISA_FN7_RANGE]     = `ISA_FN7_SRAI;  // Do NOT Reorder
                    I32[`ISA_SHAMT64_RANGE] = nzuimm_540[5:0];// these two
                    Imm                     = nzuimm_540;
                    Instr32                 = I32;
                end

                2'b10: begin                                                //C.ANDI = ANDI rd', rd', imm
                    I32[`ISA_OP_RANGE]  = `ISA_OP_OPIMM;
                    I32[`ISA_FN3_RANGE] = `ISA_FN3_ANDI;
                    I32[`ISA_RS1_RANGE] = rs1c;
                    I32[`ISA_RD_RANGE]  = rs1c;
                    Imm                 = imm_540;
                    Instr32             = Pack_I(I32,Imm);
                end

                2'b11: begin
                    I32[`ISA_OP_RANGE]  = `ISA_OP_OP;
                    I32[`ISA_RS1_RANGE] = rs1c;
                    I32[`ISA_RS2_RANGE] = rs2c;
                    I32[`ISA_RD_RANGE]  = rs1c;

                    if(Instr16[12]==0 && Instr16[6:5]==2'b00) begin         //C.SUB = SUB rd', rd', rs2'
                        I32[`ISA_FN3_RANGE] = `ISA_FN3_SUB;
                        I32[`ISA_FN7_RANGE] = `ISA_FN7_SUB;
                    end
                    else if(Instr16[12]==0 && Instr16[6:5]==2'b01) begin    //C.XOR = XOR rd', rd', rs2'
                        I32[`ISA_FN3_RANGE] = `ISA_FN3_XOR;
                        I32[`ISA_FN7_RANGE] = `ISA_FN7_OP;
                    end
                    else if(Instr16[12]==0 && Instr16[6:5]==2'b10) begin    //C.OR = OR rd', rd', rs2'
                        I32[`ISA_FN3_RANGE] = `ISA_FN3_OR;
                        I32[`ISA_FN7_RANGE] = `ISA_FN7_OP;
                    end
                    else if(Instr16[12]==0 && Instr16[6:5]==2'b11) begin    //C.AND = AND rd', rd', rs2'
                        I32[`ISA_FN3_RANGE] = `ISA_FN3_AND;
                        I32[`ISA_FN7_RANGE] = `ISA_FN7_OP;
                    end
                    else if(Instr16[12]==1 && Instr16[6:5]==2'b00) begin    //C.SUBW = SUBW rd', rd', rs2'
                        I32[`ISA_OP_RANGE]  = `ISA_OP_OP32;
                        I32[`ISA_FN3_RANGE] = `ISA_FN3_SUBW;
                        I32[`ISA_FN7_RANGE] = `ISA_FN7_SUBW;
                    end
                    else if(Instr16[12]==1 && Instr16[6:5]==2'b01) begin    //C.ADDW = ADDW rd', rd', rs2'
                        I32[`ISA_OP_RANGE]  = `ISA_OP_OP32;
                        I32[`ISA_FN3_RANGE] = `ISA_FN3_ADDW;
                        I32[`ISA_FN7_RANGE] = `ISA_FN7_ADDW;
                    end
                    else
                        Invalid = 1;                                        //RESERVED
                    Instr32 = I32;
                end
                default: Invalid = 1;
            endcase
        end

        {`ISAC_FN3_J,`ISAC_Q1_OP}: begin                //C.J = JAL x0, imm
            I32[`ISA_OP_RANGE] = `ISA_OP_JAL;
            I32[`ISA_RD_RANGE] = `ISA_ZERO;
            Imm                = imm_11;
            Instr32            = Pack_J(I32,Imm);
        end

        {`ISAC_FN3_BEQZ, `ISAC_Q1_OP}: begin            //C.BEQZ = BEQ rs1', x0, imm
            I32[`ISA_OP_RANGE]  = `ISA_OP_BRANCH;
            I32[`ISA_FN3_RANGE] = `ISA_FN3_BEQ;
            I32[`ISA_RS1_RANGE] = rs1c;
            I32[`ISA_RS2_RANGE] = `ISA_ZERO;
            Imm                 = imm_843;
            Instr32             = Pack_B(I32,Imm);
        end

        {`ISAC_FN3_BNEZ, `ISAC_Q1_OP}: begin            //C.BNEZ = BNE rs1', x0, imm
            I32[`ISA_OP_RANGE]  = `ISA_OP_BRANCH;
            I32[`ISA_FN3_RANGE] = `ISA_FN3_BNE;
            I32[`ISA_RS1_RANGE] = rs1c;
            I32[`ISA_RS2_RANGE] = `ISA_ZERO;
            Imm                 = imm_843;
            Instr32             = Pack_B(I32,Imm);
        end

        /*------------------------------------------------------------------------------------------*/

        {`ISAC_FN3_SLLI,`ISAC_Q2_OP}: begin
            if(rd==0)
                Hint = 1;
            else begin                                  //C.SLLI = SLLI rd,rd,Imm
                I32[`ISA_OP_RANGE]      = `ISA_OP_OPIMM;
                I32[`ISA_FN3_RANGE]     = `ISA_FN3_SLLI;
                I32[`ISA_RS1_RANGE]     = rd;
                I32[`ISA_RD_RANGE]      = rd;
                I32[`ISA_FN7_RANGE]     = `ISA_FN7_SLLI;  // Do NOT Reorder
                I32[`ISA_SHAMT64_RANGE] = nzuimm_540[5:0];// these two
                Imm                     = nzuimm_540;
                Instr32                 = I32;
            end
        end

        {`ISAC_FN3_FLDSP,`ISAC_Q2_OP}: begin            //C.FLDSP = FLD frd, Imm(x2)
            I32[`ISA_OP_RANGE]  = `ISA_OP_LOADFP;
            I32[`ISA_FN3_RANGE] = `ISA_FN3_FLD;
            I32[`ISA_RD_RANGE]  = rd;
            I32[`ISA_RS1_RANGE] = `ISA_SP;
            Imm                 = uimm_543;
            Instr32             = Pack_I(I32,Imm);
        end

        {`ISAC_FN3_LWSP,`ISAC_Q2_OP}: begin             //C.LWSP = LW rd, Imm(x2)
            I32[`ISA_OP_RANGE]  = `ISA_OP_LOAD;
            I32[`ISA_FN3_RANGE] = `ISA_FN3_LW;
            I32[`ISA_RD_RANGE]  = rd;
            I32[`ISA_RS1_RANGE] = `ISA_SP;
            Imm                 = uimm_542;
            Instr32             = Pack_I(I32,Imm);
        end

        {`ISAC_FN3_LDSP,`ISAC_Q2_OP}: begin             //C.LDSP = LD rd, Imm(x2)
            I32[`ISA_OP_RANGE]  = `ISA_OP_LOAD;
            I32[`ISA_FN3_RANGE] = `ISA_FN3_LD;
            I32[`ISA_RD_RANGE]  = rd;
            I32[`ISA_RS1_RANGE] = `ISA_SP;
            Imm                 = uimm_543;
            Instr32             = Pack_I(I32,Imm);
        end

        {`ISAC_FN3_100,`ISAC_Q2_OP}: begin
            if(Instr16[12]==0      && rs1!=0           && Instr16[6:2]==0) begin    //C.JR = JALR x0, rs1, 0
                I32[`ISA_OP_RANGE]  = `ISA_OP_JALR;
                I32[`ISA_RD_RANGE]  = `ISA_ZERO;
                I32[`ISA_RS1_RANGE] = rs1;
                Imm                 = 0;
                Instr32             = Pack_I(I32,Imm);
            end
            else if(Instr16[12]==0 && rd!=0            && rs2!=0) begin             //C.MV = ADD rd, x0, rs2
                I32[`ISA_OP_RANGE]  = `ISA_OP_OP;
                I32[`ISA_FN3_RANGE] = `ISA_FN3_ADD;
                I32[`ISA_FN7_RANGE] = `ISA_FN7_OP;
                I32[`ISA_RD_RANGE]  = rd;
                I32[`ISA_RS1_RANGE] = `ISA_ZERO;
                I32[`ISA_RS2_RANGE] = rs2;
                Instr32             = I32;
            end
            else if(Instr16[12]==1 && Instr16[11:7]==0 && Instr16[6:2]==0) begin    //C.EBREAK = EBREAK
                Instr32 = `ISA_INS_EBREAK;
            end
            else if(Instr16[12]==1 && rs1!=0           && Instr16[6:2]==0) begin    //C.JALR = JALR x1, rs1, 0
                I32[`ISA_OP_RANGE]  = `ISA_OP_JALR;
                I32[`ISA_RD_RANGE]  = `ISA_RA;
                I32[`ISA_RS1_RANGE] = rs1;
                Imm                 = 0;
                Instr32             = Pack_I(I32,Imm);
            end
            else if(Instr16[12]==1 && rd!=0            && rs2!=0) begin             //C.ADD = ADD rd, rd, rs2
                I32[`ISA_OP_RANGE]  = `ISA_OP_OP;
                I32[`ISA_FN3_RANGE] = `ISA_FN3_ADD;
                I32[`ISA_FN7_RANGE] = `ISA_FN7_OP;
                I32[`ISA_RD_RANGE]  = rd;
                I32[`ISA_RS1_RANGE] = rd;
                I32[`ISA_RS2_RANGE] = rs2;
                Instr32             = I32;
            end
            else
                Hint = 1;
        end

        {`ISAC_FN3_FSDSP,`ISAC_Q2_OP}: begin            //C.FSDSP = FSD frs2, imm(x2)
            I32[`ISA_OP_RANGE]  = `ISA_OP_STOREFP;
            I32[`ISA_FN3_RANGE] = `ISA_FN3_FSD;
            I32[`ISA_RS2_RANGE] = rs2;
            I32[`ISA_RS1_RANGE] = `ISA_SP;
            Imm                 = uimm_5386;
            Instr32             = Pack_S(I32,Imm);
        end

        {`ISAC_FN3_SWSP,`ISAC_Q2_OP}: begin             //C.SWSP = SW rs2, imm(x2)
            I32[`ISA_OP_RANGE]  = `ISA_OP_STORE;
            I32[`ISA_FN3_RANGE] = `ISA_FN3_SW;
            I32[`ISA_RS2_RANGE] = rs2;
            I32[`ISA_RS1_RANGE] = `ISA_SP;
            Imm                 = uimm_5276;
            Instr32             = Pack_S(I32,Imm);
        end

        {`ISAC_FN3_SDSP,`ISAC_Q2_OP}: begin             //C.SDSP = SD rs2, imm(x2)
            I32[`ISA_OP_RANGE]  = `ISA_OP_STORE;
            I32[`ISA_FN3_RANGE] = `ISA_FN3_SD;
            I32[`ISA_RS2_RANGE] = rs2;
            I32[`ISA_RS1_RANGE] = `ISA_SP;
            Imm                 = uimm_5386;
            Instr32             = Pack_S(I32,Imm);
        end

        default: begin
            Invalid = 1;
        end
    endcase
end

endmodule
