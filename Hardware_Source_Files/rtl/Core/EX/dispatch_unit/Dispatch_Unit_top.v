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
`include "regbit_defines.vh"
`include "bus_defines.vh"

(* keep_hierarchy = "yes" *)
module Dispatch_Unit
(
    input  wire clk,
    input  wire rst,

    input  wire Stall,  //1=>Stall Dispatch Unit & Sub-Units
    input  wire Flush,  //1=>Flush Dispatch Unit & Sub-Units

    //inputs from rename unit
    input  wire [(`DISPATCH_RATE*`UOP_LEN)-1:0]                 Rename_DataOut,         //Renamed uop Data
    input  wire [`DISPATCH_RATE-1:0]                            Rename_OutValid,        //i=1 => Pipeline Register output is valid

    //input response from Branch (Resolution) unit
    input  wire [`FUBR_RESULT_LEN-1:0]                          FUBRresp,

    //wakeup inputs from different execution units
    input  wire [(`SCHED_PORTS*`WAKEUP_RESP_LEN)-1:0]           WakeupResponses,        //Wakeup Response Bus

    //inputs from issue units
    input  wire [`RS_INT_ISSUE_REQ-1:0]                         RSINT_Issued_Valid,     //i=1 => ith issue request confirmation is valid
    input  wire [`RS_FP_ISSUE_REQ-1:0]                          RSFP_Issued_Valid,      //i=1 => ith issue request confirmation is valid
    input  wire                                                 RSBR_Issued_Valid,      //1 => issue request confirmation is valid
    input  wire [`RS_MEM_ISSUE_REQ-1:0]                         RSMEM_Issued_Valid,     //i=1 => ith issue request confirmation is valid
    input  wire                                                 RSSYS_Issued_Valid,     //1 => issue request confirmation is valid

    //inputs from retire units
    input  wire [$clog2(`RETIRE_RATE):0]                        RetireCnt,              //No. of instructions retired from ROB

    //Recovery Inputs for restoring correct status (busy or ready) of PRF
    input  wire [`INT_PRF_DEPTH-1:0]                            Int_RecoveryPhyMapBits, //i=1 => ith Int phy reg was mapped in snapshot which is being recoverd
    input  wire [`FP_PRF_DEPTH-1:0]                             Fp_RecoveryPhyMapBits,  //i=1 => ith Fp phy reg was mapped in snapshot which is being recoverd

    //Reservation Station outputs to issue unit
    output wire [(`RS_INT_ISSUE_REQ*`RS_INT_LEN)-1:0]           RSINT_IssueReq_Entries, //Entries requested for issue
    output wire [`RS_INT_ISSUE_REQ-1:0]                         RSINT_IssueReq_Valid,   //i=1 => ith request for issue is valid
    output wire [(`RS_FP_ISSUE_REQ*`RS_FPU_LEN)-1:0]            RSFP_IssueReq_Entries,  //Entries requested for issue
    output wire [`RS_FP_ISSUE_REQ-1:0]                          RSFP_IssueReq_Valid,    //i=1 => ith request for issue is valid
    output wire [`RS_BR_LEN-1:0]                                RSBR_IssueReq_Entries,  //Entries requested for issue
    output wire                                                 RSBR_IssueReq_Valid,    //i=1 => ith request for issue is valid
    output wire [(`RS_MEM_ISSUE_REQ*`RS_MEM_LEN)-1:0]           RSMEM_IssueReq_Entries, //Entries requested for issue
    output wire [`RS_MEM_ISSUE_REQ-1:0]                         RSMEM_IssueReq_Valid,   //i=1 => ith request for issue is valid
    output wire [`RS_SYS_LEN-1:0]                               RSSYS_IssueReq_Entries, //Entries requested for issue
    output wire                                                 RSSYS_IssueReq_Valid,   //i=1 => ith request for issue is valid

    //outputs to retire unit
    output wire [(`RETIRE_RATE*`ROB_LEN)-1:0]                   ROB_ReadData,
    output wire [$clog2(`ROB_DEPTH):0]                          ROB_UsedEntries,    //Used Entries in ROB

    //control outputs to stall rename unit
    output wire                                                 Rename_StallRequest

);

//generate local wires from FUBRresp
wire                    Kill_Enable = FUBRresp[`FUBR_RESULT_VALID] & FUBRresp[`FUBR_RESULT_MISPRED];
wire                    Update_KillMask = FUBRresp[`FUBR_RESULT_VALID] & FUBRresp[`FUBR_RESULT_ISSPEC] & ~FUBRresp[`FUBR_RESULT_MISPRED];
wire [`SPEC_STATES-1:0] FUBR_SpecTag = FUBRresp[`FUBR_RESULT_SPECTAG];

//separate merged renamed uops
wire [`UOP_LEN-1:0]     renamed_uop[0:`DISPATCH_RATE-1];
genvar gir;
generate
    for(gir=0; gir<`DISPATCH_RATE; gir=gir+1) begin
        assign renamed_uop[gir] = Rename_DataOut[gir*`UOP_LEN+:`UOP_LEN];
    end
endgenerate

//separate ROB Indexes
wire [(`DISPATCH_RATE*$clog2(`ROB_DEPTH))-1:0]   ROB_Index;
wire [`ROB_DEPTH_LEN-1:0]   ROB_WrIndex[0:`DISPATCH_RATE-1];
genvar giri;
generate
    for(giri=0; giri<`DISPATCH_RATE; giri=giri+1) begin
        assign ROB_WrIndex[giri] = ROB_Index[giri*`ROB_DEPTH_LEN+:`ROB_DEPTH_LEN];
    end
endgenerate


//local wires for interconnection
wire [$clog2(`RS_INT_DEPTH):0]  RSINT_FreeEntries;
wire [$clog2(`RS_FP_DEPTH):0]   RSFP_FreeEntries;
wire [$clog2(`RS_BR_DEPTH):0]   RSBR_FreeEntries;
wire [$clog2(`RS_MEM_DEPTH):0]  RSMEM_FreeEntries;
wire                            RSSYS_FreeEntries;
wire [$clog2(`ROB_DEPTH):0]     ROB_FreeEntries;

wire [`DISPATCH_RATE-1:0]       ROB_WrValid;


///////////////////////////////////////////////////////////////////////////////
//count renamed uop by instructions
reg  [$clog2(`DISPATCH_RATE):0] Int_uop_cnt, Fp_uop_cnt, Br_uop_cnt, Mem_uop_cnt, uop_cnt;
integer dc;
always @* begin
    Int_uop_cnt=0; Fp_uop_cnt=0; Br_uop_cnt=0; Mem_uop_cnt=0; uop_cnt=0;
    for(dc=0; dc<`DISPATCH_RATE; dc=dc+1) begin
        if(renamed_uop[dc][`UOP_VALID] && Rename_OutValid[dc]) begin
            Int_uop_cnt    = renamed_uop[dc][`UOP_RSTYPE]==`RS_TYPE_INT ? Int_uop_cnt+1 : Int_uop_cnt;
            Fp_uop_cnt     = renamed_uop[dc][`UOP_RSTYPE]==`RS_TYPE_FP  ? Fp_uop_cnt+1  : Fp_uop_cnt;
            Br_uop_cnt     = ((renamed_uop[dc][`UOP_RSTYPE]==`RS_TYPE_BR) && (renamed_uop[dc][`UOP_FUTYPE]==`FU_TYPE_BRANCH)) ? Br_uop_cnt+1 : Br_uop_cnt;
            Mem_uop_cnt    = renamed_uop[dc][`UOP_RSTYPE]==`RS_TYPE_MEM ? Mem_uop_cnt+1 : Mem_uop_cnt;
        end
        if(renamed_uop[dc][`UOP_VALID] & Rename_OutValid[dc]) begin
            uop_cnt = uop_cnt + 1;
        end

    end
end


//Busy Unit Wires
wire [`PRF_MAX_LEN-1:0] WriteBusy_prd   [0:`DISPATCH_RATE-1];
wire                    WriteBusy_rdType[0:`DISPATCH_RATE-1];
wire                    WriteBusy_WE    [0:`DISPATCH_RATE-1];
wire [`PRF_MAX_LEN-1:0] ReadBusy_prs1   [0:`DISPATCH_RATE-1];
wire [`PRF_MAX_LEN-1:0] ReadBusy_prs2   [0:`DISPATCH_RATE-1];
wire [`PRF_MAX_LEN-1:0] ReadBusy_prs3   [0:`DISPATCH_RATE-1];
wire [1:0]              ReadBusy_rsType [0:`DISPATCH_RATE-1];
wire [2:0]              ReadBusy_BusyBit[0:`DISPATCH_RATE-1];
genvar gb;
generate
    for(gb=0;gb<`DISPATCH_RATE;gb=gb+1) begin
        assign WriteBusy_prd[gb]      = renamed_uop[gb][`UOP_PRD];
        assign WriteBusy_rdType[gb]   = renamed_uop[gb][`UOP_RD_TYPE];
        assign WriteBusy_WE[gb]       = renamed_uop[gb][`UOP_REG_WE] & ROB_WrValid[gb];
        assign ReadBusy_prs1[gb]      = renamed_uop[gb][`UOP_PRS1];
        assign ReadBusy_prs2[gb]      = renamed_uop[gb][`UOP_PRS2];
        assign ReadBusy_prs3[gb]      = renamed_uop[gb][`UOP_PRS3];
        assign ReadBusy_rsType[gb][0] = renamed_uop[gb][`UOP_RS1_TYPE];
        assign ReadBusy_rsType[gb][1] = renamed_uop[gb][`UOP_RS2_TYPE];
    end
endgenerate


//RS Size check: Free entries in RS should be greater or equal to uop to be
//issued //1=>Space Available to write uops; 0=>No space available in RS -> stall
wire RS_Int_FreeCheck   = (Int_uop_cnt <= RSINT_FreeEntries);
wire RS_Fp_FreeCheck    = (Fp_uop_cnt  <= RSFP_FreeEntries);
wire RS_Br_FreeCheck    = (Br_uop_cnt  <= RSBR_FreeEntries);
wire RS_Mem_FreeCheck   = (Mem_uop_cnt <= RSMEM_FreeEntries);
wire RS_Sys_FreeCheck   = (renamed_uop[0][`UOP_VALID] & Rename_OutValid[0] & (renamed_uop[0][`UOP_FUTYPE]==`FU_TYPE_SYSTEM)) ?
                            RSSYS_FreeEntries : 1'b1;    //if system instr then only check for space
wire ROB_FreeCheck      = (uop_cnt     < ROB_FreeEntries);
wire RS_FreeCheck       = (RS_Int_FreeCheck & RS_Fp_FreeCheck & RS_Br_FreeCheck & RS_Mem_FreeCheck & RS_Sys_FreeCheck);
wire FreeCheck          = RS_FreeCheck & ROB_FreeCheck;

//generate RS entries for each RS Types & ROB Entries for writing to ROB if
//all Free Space Checks are Met && Not Branch Mispredicted
wire [`RS_INT_LEN-1:0]      RS_Int_WriteData[0:`DISPATCH_RATE-1];
wire [`RS_FPU_LEN-1:0]      RS_Fp_WriteData[0:`DISPATCH_RATE-1];
wire [`RS_BR_LEN-1:0]       RS_Br_WriteData[0:`DISPATCH_RATE-1];
wire [`RS_MEM_LEN-1:0]      RS_Mem_WriteData[0:`DISPATCH_RATE-1];
wire [`RS_SYS_LEN-1:0]      RS_Sys_WriteData;
wire [`ROB_LEN-1:0]         ROB_WriteData[0:`DISPATCH_RATE-1];
wire [`DISPATCH_RATE-1:0]   RSINT_WrValid;
wire [`DISPATCH_RATE-1:0]   RSFP_WrValid;
wire [`DISPATCH_RATE-1:0]   RSBR_WrValid;
wire [`DISPATCH_RATE-1:0]   RSMEM_WrValid;
wire                        RSSYS_WrValid;


assign RS_Sys_WriteData[`RS_VALID]     = (renamed_uop[0][`UOP_FUTYPE]==`FU_TYPE_SYSTEM);
assign RS_Sys_WriteData[`RS_KILLMASK]  = Update_KillMask ? (renamed_uop[0][`UOP_KILLMASK] & ~FUBR_SpecTag) : renamed_uop[0][`UOP_KILLMASK];
assign RS_Sys_WriteData[`RS_PRS1_RDY]  = ~(renamed_uop[0][`UOP_IS_RS1] & ReadBusy_BusyBit[0][0]);
assign RS_Sys_WriteData[`RS_PRS2_RDY]  = ~(renamed_uop[0][`UOP_IS_RS2] & ReadBusy_BusyBit[0][1]);
assign RS_Sys_WriteData[`RS_PRS3_RDY]  = 1'b1;
assign RS_Sys_WriteData[`RS_ROBIDX]    = ROB_WrIndex[0];
assign RS_Sys_WriteData[`RS_PC]        = renamed_uop[0][`UOP_PC];
assign RS_Sys_WriteData[`RS_REG_WE]    = renamed_uop[0][`UOP_REG_WE];
assign RS_Sys_WriteData[`RS_RD_TYPE]   = renamed_uop[0][`UOP_RD_TYPE];
assign RS_Sys_WriteData[`RS_PRD]       = renamed_uop[0][`UOP_PRD];
assign RS_Sys_WriteData[`RS_RS1_TYPE]  = renamed_uop[0][`UOP_RS1_TYPE];
assign RS_Sys_WriteData[`RS_PRS1]      = renamed_uop[0][`UOP_PRS1];
assign RS_Sys_WriteData[`RS_RS2_TYPE]  = renamed_uop[0][`UOP_RS2_TYPE];
assign RS_Sys_WriteData[`RS_PRS2]      = renamed_uop[0][`UOP_PRS2];
assign RS_Sys_WriteData[`RS_IMM]       = renamed_uop[0][`UOP_IMM];
assign RS_Sys_WriteData[`RS_OP1_SEL]   = renamed_uop[0][`UOP_OP1_SEL];
assign RS_Sys_WriteData[`RS_OP2_SEL]   = renamed_uop[0][`UOP_OP2_SEL];
assign RS_Sys_WriteData[`RS_OP3_SEL]   = renamed_uop[0][`UOP_OP3_SEL];
assign RS_Sys_WriteData[`RS_FUTYPE]    = renamed_uop[0][`UOP_FUTYPE];
assign RS_Sys_WriteData[`RS_SYS_CTRLS] = renamed_uop[0][`UOP_CONTROLS_START+:`UOP_SYS_CTRL_LEN];

assign RSSYS_WrValid = (renamed_uop[0][`UOP_FUTYPE]==`FU_TYPE_SYSTEM) & FreeCheck & ~Kill_Enable & Rename_OutValid[0] & renamed_uop[0][`UOP_VALID];

genvar e;
generate
    for(e=0; e<`DISPATCH_RATE; e=e+1) begin
        assign RS_Int_WriteData[e][`RS_VALID]     = (renamed_uop[e][`UOP_RSTYPE]==`RS_TYPE_INT);
        assign RS_Int_WriteData[e][`RS_KILLMASK]  = Update_KillMask ? (renamed_uop[e][`UOP_KILLMASK] & ~FUBR_SpecTag) : renamed_uop[e][`UOP_KILLMASK];
        assign RS_Int_WriteData[e][`RS_PRS1_RDY]  = ~(renamed_uop[e][`UOP_IS_RS1] & ReadBusy_BusyBit[e][0]);
        assign RS_Int_WriteData[e][`RS_PRS2_RDY]  = ~(renamed_uop[e][`UOP_IS_RS2] & ReadBusy_BusyBit[e][1]);
        assign RS_Int_WriteData[e][`RS_PRS3_RDY]  = 1'b1;
        assign RS_Int_WriteData[e][`RS_ROBIDX]    = ROB_WrIndex[e];
        assign RS_Int_WriteData[e][`RS_PC]        = renamed_uop[e][`UOP_PC];
        assign RS_Int_WriteData[e][`RS_REG_WE]    = renamed_uop[e][`UOP_REG_WE];
        assign RS_Int_WriteData[e][`RS_RD_TYPE]   = renamed_uop[e][`UOP_RD_TYPE];
        assign RS_Int_WriteData[e][`RS_PRD]       = renamed_uop[e][`UOP_PRD];
        assign RS_Int_WriteData[e][`RS_RS1_TYPE]  = renamed_uop[e][`UOP_RS1_TYPE];
        assign RS_Int_WriteData[e][`RS_PRS1]      = renamed_uop[e][`UOP_PRS1];
        assign RS_Int_WriteData[e][`RS_RS2_TYPE]  = renamed_uop[e][`UOP_RS2_TYPE];
        assign RS_Int_WriteData[e][`RS_PRS2]      = renamed_uop[e][`UOP_PRS2];
        assign RS_Int_WriteData[e][`RS_IMM]       = renamed_uop[e][`UOP_IMM];
        assign RS_Int_WriteData[e][`RS_OP1_SEL]   = renamed_uop[e][`UOP_OP1_SEL];
        assign RS_Int_WriteData[e][`RS_OP2_SEL]   = renamed_uop[e][`UOP_OP2_SEL];
        assign RS_Int_WriteData[e][`RS_OP3_SEL]   = renamed_uop[e][`UOP_OP3_SEL];
        assign RS_Int_WriteData[e][`RS_FUTYPE]    = renamed_uop[e][`UOP_FUTYPE];
        assign RS_Int_WriteData[e][`RS_INT_CTRLS] = renamed_uop[e][`UOP_CONTROLS_START+:`UOP_INT_CTRL_LEN];

        assign RS_Fp_WriteData[e][`RS_VALID]     = (renamed_uop[e][`UOP_RSTYPE]==`RS_TYPE_FP);
        assign RS_Fp_WriteData[e][`RS_KILLMASK]  = Update_KillMask ? (renamed_uop[e][`UOP_KILLMASK] & ~FUBR_SpecTag) : renamed_uop[e][`UOP_KILLMASK];
        assign RS_Fp_WriteData[e][`RS_PRS1_RDY]  = ~(renamed_uop[e][`UOP_IS_RS1] & ReadBusy_BusyBit[e][0]);
        assign RS_Fp_WriteData[e][`RS_PRS2_RDY]  = ~(renamed_uop[e][`UOP_IS_RS2] & ReadBusy_BusyBit[e][1]);
        assign RS_Fp_WriteData[e][`RS_PRS3_RDY]  = ~(renamed_uop[e][`UOP_IS_RS3] & ReadBusy_BusyBit[e][2]);
        assign RS_Fp_WriteData[e][`RS_ROBIDX]    = ROB_WrIndex[e];
        assign RS_Fp_WriteData[e][`RS_PC]        = renamed_uop[e][`UOP_PC];
        assign RS_Fp_WriteData[e][`RS_REG_WE]    = renamed_uop[e][`UOP_REG_WE];
        assign RS_Fp_WriteData[e][`RS_RD_TYPE]   = renamed_uop[e][`UOP_RD_TYPE];
        assign RS_Fp_WriteData[e][`RS_PRD]       = renamed_uop[e][`UOP_PRD];
        assign RS_Fp_WriteData[e][`RS_RS1_TYPE]  = renamed_uop[e][`UOP_RS1_TYPE];
        assign RS_Fp_WriteData[e][`RS_PRS1]      = renamed_uop[e][`UOP_PRS1];
        assign RS_Fp_WriteData[e][`RS_RS2_TYPE]  = renamed_uop[e][`UOP_RS2_TYPE];
        assign RS_Fp_WriteData[e][`RS_PRS2]      = renamed_uop[e][`UOP_PRS2];
        assign RS_Fp_WriteData[e][`RS_IMM]       = renamed_uop[e][`UOP_IMM];
        assign RS_Fp_WriteData[e][`RS_OP1_SEL]   = renamed_uop[e][`UOP_OP1_SEL];
        assign RS_Fp_WriteData[e][`RS_OP2_SEL]   = renamed_uop[e][`UOP_OP2_SEL];
        assign RS_Fp_WriteData[e][`RS_OP3_SEL]   = renamed_uop[e][`UOP_OP3_SEL];
        assign RS_Fp_WriteData[e][`RS_FUTYPE]    = renamed_uop[e][`UOP_FUTYPE];
        assign RS_Fp_WriteData[e][`RS_FPU_CTRLS] = renamed_uop[e][`UOP_CONTROLS_START+:`UOP_FPU_CTRL_LEN];
        assign RS_Fp_WriteData[e][`RS_FPU_PRS3]  = renamed_uop[e][`UOP_PRS3];

        assign RS_Br_WriteData[e][`RS_VALID]      = (renamed_uop[e][`UOP_RSTYPE]==`RS_TYPE_BR);
        assign RS_Br_WriteData[e][`RS_KILLMASK]   = Update_KillMask ? (renamed_uop[e][`UOP_KILLMASK] & ~FUBR_SpecTag) : renamed_uop[e][`UOP_KILLMASK];
        assign RS_Br_WriteData[e][`RS_PRS1_RDY]   = ~(renamed_uop[e][`UOP_IS_RS1] & ReadBusy_BusyBit[e][0]);
        assign RS_Br_WriteData[e][`RS_PRS2_RDY]   = ~(renamed_uop[e][`UOP_IS_RS2] & ReadBusy_BusyBit[e][1]);
        assign RS_Br_WriteData[e][`RS_PRS3_RDY]   = 1'b1;
        assign RS_Br_WriteData[e][`RS_ROBIDX]     = ROB_WrIndex[e];
        assign RS_Br_WriteData[e][`RS_PC]         = renamed_uop[e][`UOP_PC];
        assign RS_Br_WriteData[e][`RS_REG_WE]     = renamed_uop[e][`UOP_REG_WE];
        assign RS_Br_WriteData[e][`RS_RD_TYPE]    = renamed_uop[e][`UOP_RD_TYPE];
        assign RS_Br_WriteData[e][`RS_PRD]        = renamed_uop[e][`UOP_PRD];
        assign RS_Br_WriteData[e][`RS_RS1_TYPE]   = renamed_uop[e][`UOP_RS1_TYPE];
        assign RS_Br_WriteData[e][`RS_PRS1]       = renamed_uop[e][`UOP_PRS1];
        assign RS_Br_WriteData[e][`RS_RS2_TYPE]   = renamed_uop[e][`UOP_RS2_TYPE];
        assign RS_Br_WriteData[e][`RS_PRS2]       = renamed_uop[e][`UOP_PRS2];
        assign RS_Br_WriteData[e][`RS_IMM]        = renamed_uop[e][`UOP_IMM];
        assign RS_Br_WriteData[e][`RS_OP1_SEL]    = renamed_uop[e][`UOP_OP1_SEL];
        assign RS_Br_WriteData[e][`RS_OP2_SEL]    = renamed_uop[e][`UOP_OP2_SEL];
        assign RS_Br_WriteData[e][`RS_OP3_SEL]    = renamed_uop[e][`UOP_OP3_SEL];
        assign RS_Br_WriteData[e][`RS_FUTYPE]     = renamed_uop[e][`UOP_FUTYPE];
        assign RS_Br_WriteData[e][`RS_BR_CTRLS]   = renamed_uop[e][`UOP_CONTROLS_START+:`UOP_BR_CTRL_LEN];

        assign RS_Mem_WriteData[e][`RS_VALID]     = (renamed_uop[e][`UOP_RSTYPE]==`RS_TYPE_MEM);
        assign RS_Mem_WriteData[e][`RS_KILLMASK]  = Update_KillMask ? (renamed_uop[e][`UOP_KILLMASK] & ~FUBR_SpecTag) : renamed_uop[e][`UOP_KILLMASK];
        assign RS_Mem_WriteData[e][`RS_PRS1_RDY]  = ~(renamed_uop[e][`UOP_IS_RS1] & ReadBusy_BusyBit[e][0]);
        assign RS_Mem_WriteData[e][`RS_PRS2_RDY]  = ~(renamed_uop[e][`UOP_IS_RS2] & ReadBusy_BusyBit[e][1]);
        assign RS_Mem_WriteData[e][`RS_PRS3_RDY]  = 1'b1;
        assign RS_Mem_WriteData[e][`RS_ROBIDX]    = ROB_WrIndex[e];
        assign RS_Mem_WriteData[e][`RS_PC]        = renamed_uop[e][`UOP_PC];
        assign RS_Mem_WriteData[e][`RS_REG_WE]    = renamed_uop[e][`UOP_REG_WE];
        assign RS_Mem_WriteData[e][`RS_RD_TYPE]   = renamed_uop[e][`UOP_RD_TYPE];
        assign RS_Mem_WriteData[e][`RS_PRD]       = renamed_uop[e][`UOP_PRD];
        assign RS_Mem_WriteData[e][`RS_RS1_TYPE]  = renamed_uop[e][`UOP_RS1_TYPE];
        assign RS_Mem_WriteData[e][`RS_PRS1]      = renamed_uop[e][`UOP_PRS1];
        assign RS_Mem_WriteData[e][`RS_RS2_TYPE]  = renamed_uop[e][`UOP_RS2_TYPE];
        assign RS_Mem_WriteData[e][`RS_PRS2]      = renamed_uop[e][`UOP_PRS2];
        assign RS_Mem_WriteData[e][`RS_IMM]       = renamed_uop[e][`UOP_IMM];
        assign RS_Mem_WriteData[e][`RS_OP1_SEL]   = renamed_uop[e][`UOP_OP1_SEL];
        assign RS_Mem_WriteData[e][`RS_OP2_SEL]   = renamed_uop[e][`UOP_OP2_SEL];
        assign RS_Mem_WriteData[e][`RS_OP3_SEL]   = renamed_uop[e][`UOP_OP3_SEL];
        assign RS_Mem_WriteData[e][`RS_FUTYPE]    = renamed_uop[e][`UOP_FUTYPE];
        assign RS_Mem_WriteData[e][`RS_MEM_CTRLS] = renamed_uop[e][`UOP_CONTROLS_START+:`UOP_MEM_CTRL_LEN];

        //Generate ROB Entry
        assign ROB_WriteData[e][`ROB_VALID]             = 1'b1;
        assign ROB_WriteData[e][`ROB_BUSY]              = 1'b1;
        assign ROB_WriteData[e][`ROB_PC]                = renamed_uop[e][`UOP_PC];
        assign ROB_WriteData[e][`ROB_KILLMASK]          = Update_KillMask ? (renamed_uop[e][`UOP_KILLMASK] & ~FUBR_SpecTag) : renamed_uop[e][`UOP_KILLMASK];
        assign ROB_WriteData[e][`ROB_WAIT_TILL_EMPTY]   = renamed_uop[e][`UOP_WAIT_TILL_EMPTY];
        assign ROB_WriteData[e][`ROB_STALL_TILL_RETIRE] = renamed_uop[e][`UOP_STALL_TILL_RETIRE];
        assign ROB_WriteData[e][`ROB_EXCEPTION]         = renamed_uop[e][`UOP_EXCEPTION];
        assign ROB_WriteData[e][`ROB_ECAUSE]            = renamed_uop[e][`UOP_ECAUSE];
        assign ROB_WriteData[e][`ROB_INSTR]             = renamed_uop[e][`UOP_INSTR];
        assign ROB_WriteData[e][`ROB_METADATA]          = renamed_uop[e][`UOP_ECAUSE];
        assign ROB_WriteData[e][`ROB_UOP_RD]            = renamed_uop[e][`UOP_RD];
        assign ROB_WriteData[e][`ROB_UOP_RDTYPE]        = renamed_uop[e][`UOP_RD_TYPE];
        assign ROB_WriteData[e][`ROB_UOP_PRD]           = renamed_uop[e][`UOP_PRD];
        assign ROB_WriteData[e][`ROB_REG_WE]            = renamed_uop[e][`UOP_REG_WE];

        assign RSINT_WrValid[e] = (renamed_uop[e][`UOP_RSTYPE]==`RS_TYPE_INT) & FreeCheck & ~Kill_Enable & Rename_OutValid[e] & renamed_uop[e][`UOP_VALID];
        assign RSFP_WrValid[e]  = (renamed_uop[e][`UOP_RSTYPE]==`RS_TYPE_FP)  & FreeCheck & ~Kill_Enable & Rename_OutValid[e] & renamed_uop[e][`UOP_VALID];
        assign RSMEM_WrValid[e] = (renamed_uop[e][`UOP_RSTYPE]==`RS_TYPE_MEM) & FreeCheck & ~Kill_Enable & Rename_OutValid[e] & renamed_uop[e][`UOP_VALID];
        assign RSBR_WrValid[e]  = (renamed_uop[e][`UOP_RSTYPE]==`RS_TYPE_BR)  & (renamed_uop[e][`UOP_FUTYPE]==`FU_TYPE_BRANCH)
                                                                              & FreeCheck & ~Kill_Enable & Rename_OutValid[e] & renamed_uop[e][`UOP_VALID];

        assign ROB_WrValid[e] = FreeCheck & ~Kill_Enable & Rename_OutValid[e] & renamed_uop[e][`UOP_VALID];
    end
endgenerate

///////////////////////////////////////////////////////////////////////////////
//Local Wires
wire [(`DISPATCH_RATE*`RS_INT_LEN)-1:0]         RSINT_WrDataIn;
wire [(`DISPATCH_RATE*`RS_FPU_LEN)-1:0]         RSFP_WrDataIn;
wire [(`DISPATCH_RATE*`RS_BR_LEN)-1:0]          RSBR_WrDataIn;
wire [(`DISPATCH_RATE*`RS_MEM_LEN)-1:0]         RSMEM_WrDataIn;
wire [`RS_SYS_LEN-1:0]                          RSSYS_WrDataIn = RS_Sys_WriteData;
wire [(`DISPATCH_RATE*`ROB_LEN)-1:0]            ROB_WrDataIn;

wire [(`DISPATCH_RATE*`PRF_MAX_LEN)-1:0]        SetBusy_Prd;        //Set Busy Phy Reg (prd)
wire [`DISPATCH_RATE-1:0]                       SetBusy_RdType;     //Set Busy Phy Reg (prd) Type
wire [`DISPATCH_RATE-1:0]                       SetBusy_WE;         //Set Busy Enable
wire [(3*`DISPATCH_RATE*`PRF_MAX_LEN)-1:0]      GetBusy_Phy_Reg;    //3*`DISPATCH_RATE Ports for reading busy bit of Phy Reg
wire [(2*`DISPATCH_RATE)-1:0]                   GetBusy_Reg_Type;   //Type of Physical Reg (Int/Fp)
wire [(3*`DISPATCH_RATE)-1:0]                   GetBusy_BusyBit;    //Output Busy Bit corresponding to input phy_reg

genvar gwd;
generate
    for(gwd=0; gwd<`DISPATCH_RATE; gwd=gwd+1) begin
        assign RSINT_WrDataIn[gwd*`RS_INT_LEN+:`RS_INT_LEN] = RS_Int_WriteData[gwd];
        assign RSFP_WrDataIn[gwd*`RS_FPU_LEN+:`RS_FPU_LEN]  = RS_Fp_WriteData[gwd];
        assign RSBR_WrDataIn[gwd*`RS_BR_LEN+:`RS_BR_LEN]    = RS_Br_WriteData[gwd];
        assign RSMEM_WrDataIn[gwd*`RS_MEM_LEN+:`RS_MEM_LEN] = RS_Mem_WriteData[gwd];
        assign ROB_WrDataIn[gwd*`ROB_LEN+:`ROB_LEN]         = ROB_WriteData[gwd];

        assign SetBusy_Prd[gwd*`PRF_MAX_LEN+:`PRF_MAX_LEN]           = WriteBusy_prd[gwd];
        assign SetBusy_RdType[gwd]                                   = WriteBusy_rdType[gwd];
        assign SetBusy_WE[gwd]                                       = WriteBusy_WE[gwd];
        assign GetBusy_Phy_Reg[(3*gwd)*`PRF_MAX_LEN+:`PRF_MAX_LEN]   = ReadBusy_prs1[gwd];
        assign GetBusy_Phy_Reg[(3*gwd+1)*`PRF_MAX_LEN+:`PRF_MAX_LEN] = ReadBusy_prs2[gwd];
        assign GetBusy_Phy_Reg[(3*gwd+2)*`PRF_MAX_LEN+:`PRF_MAX_LEN] = ReadBusy_prs3[gwd];
        assign GetBusy_Reg_Type[gwd*2+:2]                            = ReadBusy_rsType[gwd];
        assign ReadBusy_BusyBit[gwd]                                 = GetBusy_BusyBit[gwd*3+:3];
    end
endgenerate

///////////////////////////////////////////////////////////////////////////////

//request rename unit (and hence decoder unit) to stall if free checks are NOT
//met. i.e. dispatch unit cannot dispatch all uops in current clk cycle.
assign Rename_StallRequest = ~FreeCheck;

wire RS_Int_Stall    = Stall;
wire RS_Fp_Stall     = Stall;
wire RS_Branch_Stall = Stall;
wire RS_Mem_Stall    = Stall;
wire RS_Sys_Stall    = Stall;
wire ROB_Stall       = Stall;
wire Busy_List_Stall = Stall;

wire RS_Int_Flush    = Flush;
wire RS_Fp_Flush     = Flush;
wire RS_Branch_Flush = Flush;
wire RS_Mem_Flush    = Flush;
wire RS_Sys_Flush    = Flush;
wire ROB_Flush       = Flush;
wire Busy_List_Flush = Flush;

///////////////////////////////////////////////////////////////////////////////
RS_INT RS_INT
(
    .clk                    (clk                   ),
    .rst                    (rst                   ),
    .Stall                  (RS_Int_Stall          ),
    .Flush                  (RS_Int_Flush          ),
    .Kill_Enable            (Kill_Enable           ),
    .Update_KillMask        (Update_KillMask       ),
    .FUBR_SpecTag           (FUBR_SpecTag          ),
    .RSINT_WrDataIn         (RSINT_WrDataIn        ),
    .RSINT_WrValid          (RSINT_WrValid         ),
    .RSINT_Issued_Valid     (RSINT_Issued_Valid    ),
    .WakeupResponses        (WakeupResponses       ),
    .RSINT_FreeEntries      (RSINT_FreeEntries     ),
    .RSINT_IssueReq_Entries (RSINT_IssueReq_Entries),
    .RSINT_IssueReq_Valid   (RSINT_IssueReq_Valid  )
);

RS_FP RS_FP
(
    .clk                   (clk                  ),
    .rst                   (rst                  ),
    .Stall                 (RS_Fp_Stall          ),
    .Flush                 (RS_Fp_Flush          ),
    .Kill_Enable           (Kill_Enable          ),
    .Update_KillMask       (Update_KillMask      ),
    .FUBR_SpecTag          (FUBR_SpecTag         ),
    .RSFP_WrDataIn         (RSFP_WrDataIn        ),
    .RSFP_WrValid          (RSFP_WrValid         ),
    .RSFP_Issued_Valid     (RSFP_Issued_Valid    ),
    .WakeupResponses       (WakeupResponses      ),
    .RSFP_FreeEntries      (RSFP_FreeEntries     ),
    .RSFP_IssueReq_Entries (RSFP_IssueReq_Entries),
    .RSFP_IssueReq_Valid   (RSFP_IssueReq_Valid  )
);

RS_Branch RS_Branch
(
    .clk                   (clk                  ),
    .rst                   (rst                  ),
    .Stall                 (RS_Branch_Stall      ),
    .Flush                 (RS_Branch_Flush      ),
    .Kill_Enable           (Kill_Enable          ),
    .Update_KillMask       (Update_KillMask      ),
    .FUBR_SpecTag          (FUBR_SpecTag         ),
    .RSBR_WrDataIn         (RSBR_WrDataIn        ),
    .RSBR_WrValid          (RSBR_WrValid         ),
    .RSBR_Issued_Valid     (RSBR_Issued_Valid    ),
    .WakeupResponses       (WakeupResponses      ),
    .RSBR_FreeEntries      (RSBR_FreeEntries     ),
    .RSBR_IssueReq_Entries (RSBR_IssueReq_Entries),
    .RSBR_IssueReq_Valid   (RSBR_IssueReq_Valid  )
);

RS_Mem RS_Mem
(
    .clk                    (clk                   ),
    .rst                    (rst                   ),
    .Stall                  (RS_Mem_Stall          ),
    .Flush                  (RS_Mem_Flush          ),
    .Kill_Enable            (Kill_Enable           ),
    .Update_KillMask        (Update_KillMask       ),
    .FUBR_SpecTag           (FUBR_SpecTag          ),
    .RSMEM_WrDataIn         (RSMEM_WrDataIn        ),
    .RSMEM_WrValid          (RSMEM_WrValid         ),
    .RSMEM_Issued_Valid     (RSMEM_Issued_Valid    ),
    .WakeupResponses        (WakeupResponses       ),
    .RSMEM_FreeEntries      (RSMEM_FreeEntries     ),
    .RSMEM_IssueReq_Entries (RSMEM_IssueReq_Entries),
    .RSMEM_IssueReq_Valid   (RSMEM_IssueReq_Valid  )
);

RS_System RS_System
(
    .clk                    (clk                   ),
    .rst                    (rst                   ),
    .Stall                  (RS_Sys_Stall          ),
    .Flush                  (RS_Sys_Flush          ),
    .Kill_Enable            (Kill_Enable           ),
    .Update_KillMask        (Update_KillMask       ),
    .FUBR_SpecTag           (FUBR_SpecTag          ),
    .RSSYS_WrDataIn         (RSSYS_WrDataIn        ),
    .RSSYS_WrValid          (RSSYS_WrValid         ),
    .RSSYS_Issued_Valid     (RSSYS_Issued_Valid    ),
    .WakeupResponses        (WakeupResponses       ),
    .RSSYS_FreeEntries      (RSSYS_FreeEntries     ),
    .RSSYS_IssueReq_Entries (RSSYS_IssueReq_Entries),
    .RSSYS_IssueReq_Valid   (RSSYS_IssueReq_Valid  )
);

ROB ROB
(
    .clk                    (clk            ),
    .rst                    (rst            ),
    .Stall                  (ROB_Stall      ),
    .Flush                  (ROB_Flush      ),
    .ROB_WrDataIn           (ROB_WrDataIn   ),
    .ROB_WrValid            (ROB_WrValid    ),
    .FUBRresp               (FUBRresp       ),
    .WakeupResponses        (WakeupResponses),
    .RetireCnt              (RetireCnt      ),
    .ROB_ReadData           (ROB_ReadData   ),
    .ROB_FreeEntries        (ROB_FreeEntries),
    .ROB_UsedEntries        (ROB_UsedEntries),
    .ROB_Index              (ROB_Index      )
);

Busy_List Busy_List
(
    .clk                    (clk                    ),
    .rst                    (rst                    ),
    .Stall                  (Busy_List_Stall        ),
    .Flush                  (Busy_List_Flush        ),
    .Branch_Mispredicted    (Kill_Enable            ),
    .Int_RecoveryPhyMapBits (Int_RecoveryPhyMapBits ),
    .Fp_RecoveryPhyMapBits  (Fp_RecoveryPhyMapBits  ),
    .SetBusy_Prd            (SetBusy_Prd            ),
    .SetBusy_RdType         (SetBusy_RdType         ),
    .SetBusy_WE             (SetBusy_WE             ),
    .WakeupResponses        (WakeupResponses        ),
    .GetBusy_Phy_Reg        (GetBusy_Phy_Reg        ),
    .GetBusy_Reg_Type       (GetBusy_Reg_Type       ),
    .GetBusy_BusyBit        (GetBusy_BusyBit        )
);


`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;
    `ifdef DEBUG_DISPATCH
        always @(negedge clk) begin
            if(Stall) begin
                $display("[%t] DISPT_@STS##: Stall. Stall=%b", $time, Stall);
            end
            else begin
                `ifdef DEBUG_DISPATCH_STS
                //print uop counts
                $display("[%t] DISPT_@STS##: uop_cnt> INT=%0d FP=%0d BR=%0d MEM=%0d TOTAL=%0d InputValid=%b",$time,
                        Int_uop_cnt, Fp_uop_cnt, Br_uop_cnt, Mem_uop_cnt, uop_cnt, Rename_OutValid);

                //print free entries & free check result
                $display("[%t] DISPT_@STS##: FreeCheck(%b)> INT(%b)=%0d FP(%b)=%0d BR(%b)=%0d MEM(%b)=%0d SYS(%b)=%d ROB(%b)=%0d",$time, FreeCheck,
                        RS_Int_FreeCheck, RSINT_FreeEntries, RS_Fp_FreeCheck,  RSFP_FreeEntries, RS_Br_FreeCheck, RSBR_FreeEntries,
                        RS_Mem_FreeCheck, RSMEM_FreeEntries, RS_Sys_FreeCheck, RSSYS_FreeEntries, ROB_FreeCheck, ROB_FreeEntries);
                `endif

                `ifdef DEBUG_DISPATCH_ENTRY
                for(Di=0; Di<`DISPATCH_RATE; Di=Di+1) begin
                    if(RSINT_WrValid[Di]) begin
                        $display("[%t] DISPT_@INT%-2d: PC=%h ROB=%0d | prs1_rdy=%b prs2_rdy=%b", $time, Di,
                            RS_Int_WriteData[Di][`RS_PC],RS_Int_WriteData[Di][`RS_ROBIDX],
                            RS_Int_WriteData[Di][`RS_PRS1_RDY], RS_Int_WriteData[Di][`RS_PRS2_RDY]);
                    end
                    if(RSFP_WrValid[Di]) begin
                        $display("[%t] DISPT_@FP %-2d: PC=%h ROB=%0d | prs1_rdy=%b prs2_rdy=%b psr3_rdy=%b", $time, Di,
                            RS_Fp_WriteData[Di][`RS_PC],       RS_Fp_WriteData[Di][`RS_ROBIDX],
                            RS_Fp_WriteData[Di][`RS_PRS1_RDY], RS_Fp_WriteData[Di][`RS_PRS2_RDY], RS_Fp_WriteData[Di][`RS_PRS3_RDY]);
                    end
                    if(RSMEM_WrValid[Di]) begin
                        $display("[%t] DISPT_@MEM%-2d: PC=%h ROB=%0d | prs1_rdy=%b prs2_rdy=%b", $time, Di,
                            RS_Mem_WriteData[Di][`RS_PC],       RS_Mem_WriteData[Di][`RS_ROBIDX],
                            RS_Mem_WriteData[Di][`RS_PRS1_RDY], RS_Mem_WriteData[Di][`RS_PRS2_RDY]);
                    end
                    if(RSBR_WrValid[Di]) begin
                        $display("[%t] DISPT_@BR %-2d: PC=%h ROB=%0d | prs1_rdy=%b prs2_rdy=%b", $time, Di,
                            RS_Br_WriteData[Di][`RS_PC],       RS_Br_WriteData[Di][`RS_ROBIDX],
                            RS_Br_WriteData[Di][`RS_PRS1_RDY], RS_Br_WriteData[Di][`RS_PRS2_RDY]);
                    end
                    if(RSSYS_WrValid) begin
                        $display("[%t] DISPT_@SYS%-2d: PC=%h ROB=%0d | prs1_rdy=%b prs2_rdy=%b", $time, Di,
                            RS_Sys_WriteData[`RS_PC],       RS_Sys_WriteData[`RS_ROBIDX],
                            RS_Sys_WriteData[`RS_PRS1_RDY], RS_Sys_WriteData[`RS_PRS2_RDY]);
                    end
                end
                `endif
            end
        end
    `endif
`endif

endmodule

