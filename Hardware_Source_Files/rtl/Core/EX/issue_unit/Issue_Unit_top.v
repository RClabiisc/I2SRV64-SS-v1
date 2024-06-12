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
module Issue_Unit
(
    input  wire clk,
    input  wire rst,

    input  wire Stall,
    input  wire Flush,

    //input response from Branch (Resolution) unit
    input  wire [`FUBR_RESULT_LEN-1:0]                          FUBRresp,

    //Input Issue Resuests from Dispatch Unit
    input  wire [(`RS_INT_ISSUE_REQ*`RS_INT_LEN)-1:0]           RSINT_IssueReq_Entries, //Entries requested for issue
    input  wire [`RS_INT_ISSUE_REQ-1:0]                         RSINT_IssueReq_Valid,   //i=1 => ith request for issue is valid
    input  wire [(`RS_FP_ISSUE_REQ*`RS_FPU_LEN)-1:0]            RSFP_IssueReq_Entries,  //Entries requested for issue
    input  wire [`RS_FP_ISSUE_REQ-1:0]                          RSFP_IssueReq_Valid,    //i=1 => ith request for issue is valid
    input  wire [`RS_BR_LEN-1:0]                                RSBR_IssueReq_Entries,  //Entries requested for issue
    input  wire                                                 RSBR_IssueReq_Valid,    //i=1 => ith request for issue is valid
    input  wire [(`RS_MEM_ISSUE_REQ*`RS_MEM_LEN)-1:0]           RSMEM_IssueReq_Entries, //Entries requested for issue
    input  wire [`RS_MEM_ISSUE_REQ-1:0]                         RSMEM_IssueReq_Valid,   //i=1 => ith request for issue is valid
    input  wire [`RS_SYS_LEN-1:0]                               RSSYS_IssueReq_Entries, //Entries requested for issue
    input  wire                                                 RSSYS_IssueReq_Valid,   //i=1 => ith request for issue is valid

    //Output Issue Request Confirmation Outputs to Dispatch Unit
    output reg  [`RS_INT_ISSUE_REQ-1:0]                         RSINT_Issued_Valid,     //i=1 => ith issue request confirmation is valid
    output reg  [`RS_FP_ISSUE_REQ-1:0]                          RSFP_Issued_Valid,      //i=1 => ith issue request confirmation is valid
    output reg                                                  RSBR_Issued_Valid,      //1 => issue request confirmation is valid
    output reg  [`RS_MEM_ISSUE_REQ-1:0]                         RSMEM_Issued_Valid,     //i=1 => ith issue request confirmation is valid
    output reg                                                  RSSYS_Issued_Valid,     //1 => issue request confirmation is valid

    //Scheduler Port Inputs (Execution Unit to Scheduler Port)
    input  wire [`PORT_E2S_LEN-1:0]                             Port0_E2S,
    input  wire [`PORT_E2S_LEN-1:0]                             Port1_E2S,
    input  wire [`PORT_E2S_LEN-1:0]                             Port2_E2S,
    input  wire [`PORT_E2S_LEN-1:0]                             Port3_E2S,
    input  wire [`PORT_E2S_LEN-1:0]                             Port4_E2S,
    input  wire [`PORT_E2S_LEN-1:0]                             Port5_E2S,

    //Scheduler Port Outputs (Scheduler Port to Execution Unit)
    output wire [`PORT_S2E_LEN-1:0]                             Port0_S2E,
    output wire [`PORT_S2E_LEN-1:0]                             Port1_S2E,
    output wire [`PORT_S2E_LEN-1:0]                             Port2_S2E,
    output wire [`PORT_S2E_LEN-1:0]                             Port3_S2E,
    output wire [`PORT_S2E_LEN-1:0]                             Port4_S2E,
    output wire [`PORT_S2E_LEN-1:0]                             Port5_S2E,

    //Result Bus Inputs
    input  wire [`RESULT_LEN-1:0]                               ResultBus0,
    input  wire [`RESULT_LEN-1:0]                               ResultBus1,
    input  wire [`RESULT_LEN-1:0]                               ResultBus2,
    input  wire [`RESULT_LEN-1:0]                               ResultBus3,
    input  wire [`RESULT_LEN-1:0]                               ResultBus4,
    input  wire [`RESULT_LEN-1:0]                               ResultBus5
);

//local functions
function [`FU_MASK__LEN-1:0] FUType2FUMask
(
    input [`FU_TYPE__LEN-1:0] FUType
);
begin
    FUType2FUMask = 0;
    FUType2FUMask[FUType] = 1'b1;
end
endfunction


//generate local wires from FUBRresp
wire                        Branch_Mispredicted = FUBRresp[`FUBR_RESULT_VALID] & FUBRresp[`FUBR_RESULT_MISPRED];
wire                        Update_KillMask     = FUBRresp[`FUBR_RESULT_VALID] & FUBRresp[`FUBR_RESULT_ISSPEC] & ~FUBRresp[`FUBR_RESULT_MISPRED];
wire [`SPEC_STATES-1:0]     FUBR_SpecTag        = FUBRresp[`FUBR_RESULT_SPECTAG];

//geneate local wires for inputs
wire [`PORT_E2S_LEN-1:0]    Port_E2S         [0:`SCHED_PORTS-1];
wire                        Port_E2S_Ready   [0:`SCHED_PORTS-1];
wire [`FU_MASK__LEN-1:0]    Port_E2S_FUMask  [0:`SCHED_PORTS-1];

wire [`RS_INT_LEN-1:0]      RSINT_IssueReq_Entry[0:`RS_INT_ISSUE_REQ-1];
wire [`RS_FPU_LEN-1:0]      RSFP_IssueReq_Entry[0:`RS_FP_ISSUE_REQ-1];
wire [`RS_MEM_LEN-1:0]      RSMEM_IssueReq_Entry[0:`RS_MEM_ISSUE_REQ-1];
wire [`RS_BR_LEN-1 :0]      RSBR_IssueReq_Entry;
wire [`RS_SYS_LEN-1:0]      RSSYS_IssueReq_Entry;
wire [`FU_MASK__LEN-1:0]    RSINT_IssueReq_FUMask[0:`RS_INT_ISSUE_REQ-1];
wire [`FU_MASK__LEN-1:0]    RSFP_IssueReq_FUMask[0:`RS_FP_ISSUE_REQ-1];
wire [`FU_MASK__LEN-1:0]    RSMEM_IssueReq_FUMask[0:`RS_MEM_ISSUE_REQ-1];
wire [`FU_MASK__LEN-1:0]    RSBR_IssueReq_FUMask;
wire [`FU_MASK__LEN-1:0]    RSSYS_IssueReq_FUMask;
wire                        RSINT_IssueReq_Killed[0:`RS_INT_ISSUE_REQ-1];
wire                        RSFP_IssueReq_Killed[0:`RS_FP_ISSUE_REQ-1];
wire                        RSMEM_IssueReq_Killed[0:`RS_MEM_ISSUE_REQ-1];
wire                        RSBR_IssueReq_Killed;
wire                        RSSYS_IssueReq_Killed;

wire [`RESULT_LEN-1:0]      ResultBus        [0:`SCHED_PORTS-1];
wire                        ResultBus_Valid  [0:`SCHED_PORTS-1];
wire [`PRF_MAX_LEN-1:0]     ResultBus_prd    [0:`SCHED_PORTS-1];
wire                        ResultBus_WE     [0:`SCHED_PORTS-1];
wire                        ResultBus_prdType[0:`SCHED_PORTS-1];
wire [`XLEN-1:0]            ResultBus_Value  [0:`SCHED_PORTS-1];

wire [`RS_MEM_ISSUE_REQ-1:0]    RSMEM_PrevIssued = {RSMEM_Issued_Valid[`RS_MEM_ISSUE_REQ-2:0],1'b1}; //i=1 => RS mem issue request i-1 was issed

//generate local wires for Ports HACK:$@SCHED_PORTS
assign Port_E2S[0] = Port0_E2S;
assign Port_E2S[1] = Port1_E2S;
assign Port_E2S[2] = Port2_E2S;
assign Port_E2S[3] = Port3_E2S;
assign Port_E2S[4] = Port4_E2S;
assign Port_E2S[5] = Port5_E2S;

//generate local wires for Result Bus HACK:$@SCHED_PORTS
assign ResultBus[0] = ResultBus0;
assign ResultBus[1] = ResultBus1;
assign ResultBus[2] = ResultBus2;
assign ResultBus[3] = ResultBus3;
assign ResultBus[4] = ResultBus4;
assign ResultBus[5] = ResultBus5;

//Auto Extract Wires
genvar gp,gr;
genvar gii,gif,gim;
generate
    for(gp=0;gp<`SCHED_PORTS;gp=gp+1) begin
        assign Port_E2S_Ready[gp]  = Port_E2S[gp][`PORT_E2S_READY];
        assign Port_E2S_FUMask[gp] = Port_E2S[gp][`PORT_E2S_FUMASK];
    end

    for(gr=0; gr<`SCHED_PORTS; gr=gr+1) begin
        assign ResultBus_Valid[gr]   = ResultBus[gr][`RESULT_VALID];
        assign ResultBus_prd[gr]     = ResultBus[gr][`RESULT_PRD];
        assign ResultBus_prdType[gr] = ResultBus[gr][`RESULT_PRD_TYPE];
        assign ResultBus_WE[gr]      = ResultBus[gr][`RESULT_REG_WE];
        assign ResultBus_Value[gr]   = ResultBus[gr][`RESULT_VALUE];
    end

    for(gii=0; gii<`RS_INT_ISSUE_REQ;gii=gii+1) begin
        assign RSINT_IssueReq_Entry[gii] = RSINT_IssueReq_Entries[gii*`RS_INT_LEN+:`RS_INT_LEN];
        assign RSINT_IssueReq_FUMask[gii] = FUType2FUMask(RSINT_IssueReq_Entry[gii][`RS_FUTYPE]);
        assign RSINT_IssueReq_Killed[gii] = RSINT_IssueReq_Entry[gii][`RS_VALID] & Branch_Mispredicted
            & |(FUBR_SpecTag & RSINT_IssueReq_Entry[gii][`RS_KILLMASK]);
    end
    for(gif=0;gif<`RS_FP_ISSUE_REQ;gif=gif+1) begin
        assign RSFP_IssueReq_Entry[gif] = RSFP_IssueReq_Entries[gif*`RS_FPU_LEN+:`RS_FPU_LEN];
        assign RSFP_IssueReq_FUMask[gif] = FUType2FUMask(RSFP_IssueReq_Entry[gif][`RS_FUTYPE]);
        assign RSFP_IssueReq_Killed[gif] = RSFP_IssueReq_Entry[gif][`RS_VALID] & Branch_Mispredicted
            & |(FUBR_SpecTag & RSFP_IssueReq_Entry[gif][`RS_KILLMASK]);
    end
    for(gim=0;gim<`RS_MEM_ISSUE_REQ;gim=gim+1) begin
        assign RSMEM_IssueReq_Entry[gim] = RSMEM_IssueReq_Entries[gim*`RS_MEM_LEN+:`RS_MEM_LEN];
        assign RSMEM_IssueReq_FUMask[gim] = FUType2FUMask(RSMEM_IssueReq_Entry[gim][`RS_FUTYPE]);
        assign RSMEM_IssueReq_Killed[gim] = RSMEM_IssueReq_Entry[gim][`RS_VALID] & Branch_Mispredicted
            & |(FUBR_SpecTag & RSMEM_IssueReq_Entry[gim][`RS_KILLMASK]);
    end
    assign RSBR_IssueReq_Entry   = RSBR_IssueReq_Entries;
    assign RSBR_IssueReq_FUMask  = FUType2FUMask(RSBR_IssueReq_Entry[`RS_FUTYPE]);
    assign RSBR_IssueReq_Killed  = RSBR_IssueReq_Entry[`RS_VALID] & Branch_Mispredicted
        & |(FUBR_SpecTag & RSBR_IssueReq_Entry[`RS_KILLMASK]);

    assign RSSYS_IssueReq_Entry  = RSSYS_IssueReq_Entries;
    assign RSSYS_IssueReq_FUMask = FUType2FUMask(RSSYS_IssueReq_Entry[`RS_FUTYPE]);
    assign RSSYS_IssueReq_Killed = RSSYS_IssueReq_Entry[`RS_VALID] & Branch_Mispredicted
        & |(FUBR_SpecTag & RSSYS_IssueReq_Entry[`RS_KILLMASK]);

endgenerate


///////////////////////////////////////////////////////////////////////////////
//Generate Issue Possiblility Matrix
//For each Issue request check whether it can be issued to EU provided issue
//request is valid, EU is NOT busy and FU is available in EU required by UOP,
//uop is NOT to be killed by Branch Misprediction
//(i.e. Generated FUMask from RS Issue Request should match with FUMASK given
//by port at least for a bit)
wire [`SCHED_PORTS-1:0]     Int_Check[0:`RS_INT_ISSUE_REQ-1];
wire [`SCHED_PORTS-1:0]     Fp_Check [0:`RS_FP_ISSUE_REQ-1];
wire [`SCHED_PORTS-1:0]     Mem_Check[0:`RS_MEM_ISSUE_REQ-1];
wire [`SCHED_PORTS-1:0]     Br_Check;
wire [`SCHED_PORTS-1:0]     Sys_Check;

genvar gci, gcf, gcm, gcp;
generate
    for(gcp=0; gcp<`SCHED_PORTS; gcp=gcp+1) begin
        for(gci=0; gci<`RS_INT_ISSUE_REQ; gci=gci+1) begin
            assign Int_Check[gci][gcp] = RSINT_IssueReq_Valid[gci] & Port_E2S[gcp][`PORT_E2S_READY] & ~RSINT_IssueReq_Killed[gci]
                & |(RSINT_IssueReq_FUMask[gci] & Port_E2S[gcp][`PORT_E2S_FUMASK]);
        end
        for(gcf=0; gcf<`RS_FP_ISSUE_REQ; gcf=gcf+1) begin
            assign Fp_Check[gcf][gcp] = RSFP_IssueReq_Valid[gcf] & Port_E2S[gcp][`PORT_E2S_READY] & ~RSFP_IssueReq_Killed[gcf]
                & |(RSFP_IssueReq_FUMask[gcf] & Port_E2S[gcp][`PORT_E2S_FUMASK]);
        end
        for(gcm=0; gcm<`RS_MEM_ISSUE_REQ; gcm=gcm+1) begin
            assign Mem_Check[gcm][gcp] = RSMEM_IssueReq_Valid[gcm] & Port_E2S[gcp][`PORT_E2S_READY] & ~RSMEM_IssueReq_Killed[gcm]
                & |(RSMEM_IssueReq_FUMask[gcm] & Port_E2S[gcp][`PORT_E2S_FUMASK]);
        end
        assign Br_Check[gcp] = RSBR_IssueReq_Valid & Port_E2S[gcp][`PORT_E2S_READY] & ~RSBR_IssueReq_Killed
            & |(RSBR_IssueReq_FUMask & Port_E2S[gcp][`PORT_E2S_FUMASK]);

        assign Sys_Check[gcp] = RSSYS_IssueReq_Valid & Port_E2S[gcp][`PORT_E2S_READY] & ~RSSYS_IssueReq_Killed
            & |(RSSYS_IssueReq_FUMask & Port_E2S[gcp][`PORT_E2S_FUMASK]);
    end
endgenerate


//Main Issue Logic
//Issue one of the checked uop to port

//HACK: Scheduler Port & RS Request Mapping (whether Issue Request from a type of RS
//can go to particular Port)
//  SchPort RS_SYS(4)   RS_BR(3)    RS_MEM(2)   RS_FP(1)    RS_INT(0)
//  0       0           0           0           1           1           5'b00011
//  1       0           0           0           1           1           5'b00011
//  2       0           0           0           1           1           5'b00011
//  3       0           0           1           0           0           5'b00100
//  4       0           0           1           0           0           5'b00100
//  5       1           1           0           0           0           5'b11000
localparam [5*`SCHED_PORTS-1:0] SchPort_RS_Map = {5'b11000,5'b00100,5'b00100,5'b00011,5'b00011,5'b00011};

integer p,ir;
localparam INT_FP_MAX_ISSUE_REG = (`RS_INT_ISSUE_REQ > `RS_FP_ISSUE_REQ) ? `RS_INT_ISSUE_REQ : `RS_FP_ISSUE_REQ;
reg                     Port_Issue_Valid[0:`SCHED_PORTS-1];
reg  [`RS_MAX_LEN-1:0]  RS_IssuedTo_Port[0:`SCHED_PORTS-1];
always @* begin
    RSINT_Issued_Valid  = 0;
    RSFP_Issued_Valid   = 0;
    RSBR_Issued_Valid   = 0;
    RSMEM_Issued_Valid  = 0;
    RSSYS_Issued_Valid  = 0;

    for(p=0; p<`SCHED_PORTS; p=p+1) begin
        RS_IssuedTo_Port[p] = 0;
        Port_Issue_Valid[p] = 0;

        //HACK: Preference of Issueing RS by type to a port. Current
        //(SYS>Br>MEM>(INT/FP))

        if(SchPort_RS_Map[5*p+1] | SchPort_RS_Map[5*p+0]) begin //Int & FP
            for(ir=0; ir<INT_FP_MAX_ISSUE_REG; ir=ir+1) begin
                //Both INT & FP have same priority. So We will check same
                //numbered issue request. i.e. priority will be like
                //int_req0 > fp_req0 > int_req1 > fp_req1 > int_req2 ...
                //TODO: In future complex algorith can be added

                if(ir<`RS_INT_ISSUE_REQ) begin //Safeside bound check if RS_FP_ISSUE_REQ>RS_INT_ISSUE_REQ
                    if(Int_Check[ir][p] & ~RSINT_Issued_Valid[ir] & ~Port_Issue_Valid[p]) begin
                        RSINT_Issued_Valid[ir] = 1'b1;
                        Port_Issue_Valid[p]    = 1'b1;
                        RS_IssuedTo_Port[p] = 0;
                        RS_IssuedTo_Port[p][`RS_INT_LEN-1:0]    = RSINT_IssueReq_Entry[ir];
                    end
                end

                if(ir<`RS_FP_ISSUE_REQ) begin //safeside bound check if RS_INT_ISSUE_REQ>RS_FP_ISSUE_REQ
                    if(Fp_Check[ir][p] & ~RSFP_Issued_Valid[ir] & ~Port_Issue_Valid[p]) begin
                        RSFP_Issued_Valid[ir]  = 1'b1;
                        Port_Issue_Valid[p]    = 1'b1;
                        RS_IssuedTo_Port[p] = 0;
                        RS_IssuedTo_Port[p][`RS_FPU_LEN-1:0] = RSFP_IssueReq_Entry[ir];
                    end
                end
            end //ir for loop
        end //int&fp if

        if(SchPort_RS_Map[5*p+2]) begin //Mem
            for(ir=0; ir<`RS_MEM_ISSUE_REQ; ir=ir+1) begin
                //Issue iff Check is true & Issue Request is NOT already Issued
                //& Port is NOT already Issued & Previous Issue Request is
                //issed
                //Checking for previous issued ensures in order dispatch of
                //Mem operations. NOTE: RSMEM_PrevIssued[0] is always 0
                if(Mem_Check[ir][p] & ~RSMEM_Issued_Valid[ir] & ~Port_Issue_Valid[p] & RSMEM_PrevIssued[ir]) begin
                    RSMEM_Issued_Valid[ir] = 1'b1;
                    Port_Issue_Valid[p]    = 1'b1;
                    RS_IssuedTo_Port[p] = 0;
                    RS_IssuedTo_Port[p][`RS_MEM_LEN-1:0] = RSMEM_IssueReq_Entry[ir];
                end
            end
        end

        if(SchPort_RS_Map[5*p+3]) begin //Branch
            if(Br_Check[p]==1'b1) begin
                RSBR_Issued_Valid   = 1'b1;
                Port_Issue_Valid[p] = 1'b1;
                RS_IssuedTo_Port[p] = 0;
                RS_IssuedTo_Port[p][`RS_BR_LEN-1:0] = RSBR_IssueReq_Entry;
            end
        end

        if(SchPort_RS_Map[5*p+4]) begin      //SYS
            if(Sys_Check[p]==1'b1) begin
                RSSYS_Issued_Valid  = 1'b1;
                Port_Issue_Valid[p] = 1'b1;
                RS_IssuedTo_Port[p] = 0;
                RS_IssuedTo_Port[p][`RS_SYS_LEN-1:0] = RSSYS_IssueReq_Entry;
            end
        end

    end //port for loop
end //always


///////////////////////////////////////////////////////////////////////////////
localparam INT_PRF_WRITE_PORTS = `SCHED_PORTS;
localparam INT_PRF_READ_PORTS  = 2*`SCHED_PORTS;
localparam FP_PRF_WRITE_PORTS  = 1+1+0+1+0+0;   //HACK: $@SCHED_PORTS: optimised as per FU mapping in EU. No Write ports to EU if no FP FU present
localparam FP_PRF_READ_PORTS   = 3+2+0+0+1+0;   //HACK: $@SCHED_PORTS: optimised as per FU mapping in EU. No read ports to EU if no FP FU present


//Individual Port wires for Int & Fp PRF
wire [`INT_PRF_LEN-1:0]     Int_PRF_WriteAddr[0:INT_PRF_WRITE_PORTS-1];
wire [`XLEN-1:0]            Int_PRF_WriteData[0:INT_PRF_WRITE_PORTS-1];
wire                        Int_PRF_WriteEn  [0:INT_PRF_WRITE_PORTS-1];
wire [`INT_PRF_LEN-1:0]     Int_PRF_ReadAddr [0:INT_PRF_READ_PORTS-1];
wire [`XLEN-1:0]            Int_PRF_ReadData [0:INT_PRF_READ_PORTS-1];

wire [`FP_PRF_LEN-1:0]      Fp_PRF_WriteAddr [0:FP_PRF_WRITE_PORTS-1];
wire [`XLEN-1:0]            Fp_PRF_WriteData [0:FP_PRF_WRITE_PORTS-1];
wire                        Fp_PRF_WriteEn   [0:FP_PRF_WRITE_PORTS-1];
wire [`FP_PRF_LEN-1:0]      Fp_PRF_ReadAddr  [0:FP_PRF_READ_PORTS-1];
wire [`XLEN-1:0]            Fp_PRF_ReadData  [0:FP_PRF_READ_PORTS-1];

//Generate Merged Wires for IO to Int & FP PRF
wire [(INT_PRF_WRITE_PORTS*`INT_PRF_LEN)-1:0]   IntPRF_WrAddr;
wire [(INT_PRF_WRITE_PORTS*`XLEN)-1:0]          IntPRF_WrData;
wire [INT_PRF_WRITE_PORTS-1:0]                  IntPRF_WrEn;
wire [(INT_PRF_READ_PORTS*`INT_PRF_LEN)-1:0]    IntPRF_RdAddr;
wire [(INT_PRF_READ_PORTS*`XLEN)-1:0]           IntPRF_RdData;
wire [(FP_PRF_WRITE_PORTS*`FP_PRF_LEN)-1:0]     FpPRF_WrAddr;
wire [(FP_PRF_WRITE_PORTS*`XLEN)-1:0]           FpPRF_WrData;
wire [FP_PRF_WRITE_PORTS-1:0]                   FpPRF_WrEn;
wire [(FP_PRF_READ_PORTS*`FP_PRF_LEN)-1:0]      FpPRF_RdAddr;
wire [(FP_PRF_READ_PORTS*`XLEN)-1:0]            FpPRF_RdData;

genvar gfir,gffr,gfiw,gffw;
generate
    //Int PRF Read Ports merged wire & array mapping
    for(gfir=0; gfir<INT_PRF_READ_PORTS; gfir=gfir+1) begin
        assign IntPRF_RdAddr[gfir*`INT_PRF_LEN+:`INT_PRF_LEN] = Int_PRF_ReadAddr[gfir];
        assign Int_PRF_ReadData[gfir]                         = IntPRF_RdData[gfir*`XLEN+:`XLEN];
    end
    //Int PRF Write Ports merged wire & array mapping
    for(gfiw=0; gfiw<INT_PRF_WRITE_PORTS; gfiw=gfiw+1) begin
        assign IntPRF_WrAddr[gfiw*`INT_PRF_LEN+:`INT_PRF_LEN] = Int_PRF_WriteAddr[gfiw];
        assign IntPRF_WrData[gfiw*`XLEN+:`XLEN]               = Int_PRF_WriteData[gfiw];
        assign IntPRF_WrEn[gfiw]                              = Int_PRF_WriteEn[gfiw];
    end
    //FP PRF Read Ports merged wire & array mapping
    for(gffr=0; gffr<FP_PRF_READ_PORTS; gffr=gffr+1) begin
        assign FpPRF_RdAddr[gffr*`FP_PRF_LEN+:`FP_PRF_LEN]    = Fp_PRF_ReadAddr[gffr];
        assign Fp_PRF_ReadData[gffr]                          = FpPRF_RdData[gffr*`XLEN+:`XLEN];
    end
    //FP PRF Write Ports merged wire & array mapping
    for(gffw=0; gffw<FP_PRF_WRITE_PORTS; gffw=gffw+1) begin
        assign FpPRF_WrAddr[gffw*`FP_PRF_LEN+:`FP_PRF_LEN]    = Fp_PRF_WriteAddr[gffw];
        assign FpPRF_WrData[gffw*`XLEN+:`XLEN]                = Fp_PRF_WriteData[gffw];
        assign FpPRF_WrEn[gffw]                               = Fp_PRF_WriteEn[gffw];
    end
endgenerate

PRF #(
    .WIDTH       (`XLEN         ),
    .DEPTH       (`INT_PRF_DEPTH),
    .READ_PORTS  (INT_PRF_READ_PORTS),
    .WRITE_PORTS (INT_PRF_WRITE_PORTS)

    `ifdef FAST_FORWARD
    ,.FORWARDING  (6'b000111)    //HACK: Allow Forwarding from those write ports only where IALU is present
    `endif
)
INT_PRF
(
    .clk    (clk   ),
    .rst    (rst   ),
    .Stall  (Stall ),
    .Flush  (1'b0),
    .RdAddr (IntPRF_RdAddr),
    .WrAddr (IntPRF_WrAddr),
    .WrData (IntPRF_WrData),
    .WrEn   (IntPRF_WrEn  ),
    .RdData (IntPRF_RdData)
);

PRF #(
    .WIDTH       (`XLEN         ),
    .DEPTH       (`FP_PRF_DEPTH ),
    .READ_PORTS  (FP_PRF_READ_PORTS),
    .WRITE_PORTS (FP_PRF_WRITE_PORTS)
)
FP_PRF
(
    .clk    (clk   ),
    .rst    (rst   ),
    .Stall  (Stall ),
    .Flush  (1'b0  ),
    .RdAddr (FpPRF_RdAddr),
    .WrAddr (FpPRF_WrAddr),
    .WrData (FpPRF_WrData),
    .WrEn   (FpPRF_WrEn  ),
    .RdData (FpPRF_RdData)
);


//Regfile Write Logic From Result Bus
//Map Result Bus Ports to Int/Fp PRF Write Ports
//HACK: This Needs to be configured manually to optimise ports on PRF.
//e.g. if only 2 EU are generating FP Result, then we need not have >2 write
//ports for FP PRF

genvar gpwi;
generate
    for(gpwi=0; gpwi<`SCHED_PORTS; gpwi=gpwi+1) begin
        assign Int_PRF_WriteAddr[gpwi] = ResultBus_prd[gpwi][`INT_PRF_LEN-1:0];
        assign Int_PRF_WriteData[gpwi] = ResultBus_Value[gpwi];
        assign Int_PRF_WriteEn[gpwi]   = ResultBus_Valid[gpwi] & ResultBus_WE[gpwi] & (ResultBus_prdType[gpwi]==`REG_TYPE_INT);
    end
endgenerate

//HACK: Sch Port 0 Support FP Operations
assign Fp_PRF_WriteAddr[0] = ResultBus_prd[0][`FP_PRF_LEN-1:0];
assign Fp_PRF_WriteData[0] = ResultBus_Value[0];
assign Fp_PRF_WriteEn[0]   = ResultBus_Valid[0] & ResultBus_WE[0] & (ResultBus_prdType[0]==`REG_TYPE_FP);
//HACK: Sch Port 1 Support FP Operations
assign Fp_PRF_WriteAddr[1] = ResultBus_prd[1][`FP_PRF_LEN-1:0];
assign Fp_PRF_WriteData[1] = ResultBus_Value[1];
assign Fp_PRF_WriteEn[1]   = ResultBus_Valid[1] & ResultBus_WE[1] & (ResultBus_prdType[1]==`REG_TYPE_FP);
//HACK: Sch Port 3 Support FP Write Operations
assign Fp_PRF_WriteAddr[2] = ResultBus_prd[3][`FP_PRF_LEN-1:0];
assign Fp_PRF_WriteData[2] = ResultBus_Value[3];
assign Fp_PRF_WriteEn[2]   = ResultBus_Valid[3] & ResultBus_WE[3] & (ResultBus_prdType[3]==`REG_TYPE_FP);


//Regfile Read Logic for scheduler ports
wire [`PRF_MAX_LEN-1:0]     Port_Int_prs1     [0:`SCHED_PORTS-1];
wire [`PRF_MAX_LEN-1:0]     Port_Int_prs2     [0:`SCHED_PORTS-1];
wire [`XLEN-1:0]            Port_Int_prs1Data [0:`SCHED_PORTS-1];
wire [`XLEN-1:0]            Port_Int_prs2Data [0:`SCHED_PORTS-1];
wire [`PRF_MAX_LEN-1:0]     Port_Fp_prs1      [0:`SCHED_PORTS-1];
wire [`PRF_MAX_LEN-1:0]     Port_Fp_prs2      [0:`SCHED_PORTS-1];
wire [`FP_PRF_LEN-1:0]      Port_Fp_prs3      [0:`SCHED_PORTS-1];
wire [`XLEN-1:0]            Port_Fp_prs1Data  [0:`SCHED_PORTS-1];
wire [`XLEN-1:0]            Port_Fp_prs2Data  [0:`SCHED_PORTS-1];
wire [`XLEN-1:0]            Port_Fp_prs3Data  [0:`SCHED_PORTS-1];

//Int/Fp PRF Read Ports to Scheduler Ports
//HACK: This Needs to be configured manually to optimise ports on PRF.
//e.g. if only 2 EU are reading FP, then we need not have >2 read port for FP PRF
//Similar in case of reading op3 (Not All EU needs op3)

genvar gpri;
generate
    for(gpri=0; gpri<`SCHED_PORTS; gpri=gpri+1) begin
        assign Port_Int_prs1[gpri]        = RS_IssuedTo_Port[gpri][`RS_PRS1];
        assign Port_Int_prs2[gpri]        = RS_IssuedTo_Port[gpri][`RS_PRS2];
        assign Int_PRF_ReadAddr[2*gpri]   = Port_Int_prs1[gpri][`INT_PRF_LEN-1:0];
        assign Int_PRF_ReadAddr[2*gpri+1] = Port_Int_prs2[gpri][`INT_PRF_LEN-1:0];
        assign Port_Int_prs1Data[gpri]    = Int_PRF_ReadData[2*gpri];
        assign Port_Int_prs2Data[gpri]    = Int_PRF_ReadData[2*gpri+1];
    end
endgenerate

//HACK: Scheduler Port 0 support FP operation with 3 operand
assign Port_Fp_prs1[0]     = RS_IssuedTo_Port[0][`RS_PRS1];
assign Port_Fp_prs2[0]     = RS_IssuedTo_Port[0][`RS_PRS2];
assign Port_Fp_prs3[0]     = RS_IssuedTo_Port[0][`RS_FPU_PRS3];
assign Fp_PRF_ReadAddr[0]  = Port_Fp_prs1[0][`FP_PRF_LEN-1:0];
assign Fp_PRF_ReadAddr[1]  = Port_Fp_prs2[0][`FP_PRF_LEN-1:0];
assign Fp_PRF_ReadAddr[2]  = Port_Fp_prs3[0][`FP_PRF_LEN-1:0];
assign Port_Fp_prs1Data[0] = Fp_PRF_ReadData[0];
assign Port_Fp_prs2Data[0] = Fp_PRF_ReadData[1];
assign Port_Fp_prs3Data[0] = Fp_PRF_ReadData[2];

//HACK: Scheduler Port 1 support FP operation with 2 operand only
assign Port_Fp_prs1[1]     = RS_IssuedTo_Port[1][`RS_PRS1];
assign Port_Fp_prs2[1]     = RS_IssuedTo_Port[1][`RS_PRS2];
assign Fp_PRF_ReadAddr[3]  = Port_Fp_prs1[1][`FP_PRF_LEN-1:0];
assign Fp_PRF_ReadAddr[4]  = Port_Fp_prs2[1][`FP_PRF_LEN-1:0];
assign Port_Fp_prs1Data[1] = Fp_PRF_ReadData[3];
assign Port_Fp_prs2Data[1] = Fp_PRF_ReadData[4];
assign Port_Fp_prs3Data[1] = 0;

//HACK: Scheduler Port 2 do not need FP operand
assign Port_Fp_prs1Data[2] = 0;
assign Port_Fp_prs2Data[2] = 0;
assign Port_Fp_prs3Data[2] = 0;

//HACK: Scheduler Port 3 do not need FP operand
assign Port_Fp_prs1Data[3] = 0;
assign Port_Fp_prs2Data[3] = 0;
assign Port_Fp_prs3Data[3] = 0;

//HACK: Scheduler Port 4 need FP operand rs2
assign Port_Fp_prs2[4]     = RS_IssuedTo_Port[4][`RS_PRS2];
assign Fp_PRF_ReadAddr[5]  = Port_Fp_prs2[4][`FP_PRF_LEN-1:0];
assign Port_Fp_prs1Data[4] = 0;
assign Port_Fp_prs2Data[4] = Fp_PRF_ReadData[5];
assign Port_Fp_prs3Data[4] = 0;

//HACK: Scheduler Port 5 do not need FP operand
assign Port_Fp_prs1Data[5] = 0;
assign Port_Fp_prs2Data[5] = 0;
assign Port_Fp_prs3Data[5] = 0;

///////////////////////////////////////////////////////////////////////////////
//create data to be written to port after getting data from regfile.
wire [`PORT_S2E_LEN-1:0]    Port_S2E_d[0:`SCHED_PORTS-1];
reg  [63:0]                 Port_op1  [0:`SCHED_PORTS-1];
reg  [63:0]                 Port_op2  [0:`SCHED_PORTS-1];
reg  [63:0]                 Port_op3  [0:`SCHED_PORTS-1];

//generate operations for FU from PRF read data, RS_OP*_SEL & RS_PRS*_TYPE
integer op;
always @* begin
    for(op=0; op<`SCHED_PORTS; op=op+1) begin
        case(RS_IssuedTo_Port[op][`RS_OP1_SEL])
            `OP1_SEL_RS1: Port_op1[op] = (RS_IssuedTo_Port[op][`RS_RS1_TYPE]==`REG_TYPE_FP) ? Port_Fp_prs1Data[op] : Port_Int_prs1Data[op];
            `OP1_SEL_R0:  Port_op1[op] = 0;
            `OP1_SEL_PC:  Port_op1[op] = RS_IssuedTo_Port[op][`RS_PC];
            default:      Port_op1[op] = 0;
        endcase
        case(RS_IssuedTo_Port[op][`RS_OP2_SEL])
            `OP2_SEL_RS2: Port_op2[op] = (RS_IssuedTo_Port[op][`RS_RS2_TYPE]==`REG_TYPE_FP) ? Port_Fp_prs2Data[op] : Port_Int_prs2Data[op];
            `OP2_SEL_R0 : Port_op2[op] = 0;
            `OP2_SEL_IMM: Port_op2[op] = {{32{RS_IssuedTo_Port[op][`RS_IMM__SIGN_BIT]}}, RS_IssuedTo_Port[op][`RS_IMM]};
            default:      Port_op2[op] = 0;
        endcase
        case(RS_IssuedTo_Port[op][`RS_OP3_SEL])
            `OP3_SEL_FRS3:Port_op3[op] = Port_Fp_prs3Data[op];
            `OP3_SEL_IMM :Port_op3[op] = {{32{RS_IssuedTo_Port[op][`RS_IMM__SIGN_BIT]}}, RS_IssuedTo_Port[op][`RS_IMM]};
            default:      Port_op3[op] = 0;
        endcase
    end
end


genvar gx;
generate
    for(gx=0; gx<`SCHED_PORTS; gx=gx+1) begin
        assign Port_S2E_d[gx][`PORT_S2E_VALID]     = Port_Issue_Valid[gx];
        assign Port_S2E_d[gx][`PORT_S2E_KILLMASK]  = Update_KillMask ? (RS_IssuedTo_Port[gx][`RS_KILLMASK] & ~FUBR_SpecTag) : RS_IssuedTo_Port[gx][`RS_KILLMASK];
        assign Port_S2E_d[gx][`PORT_S2E_ROB_INDEX] = RS_IssuedTo_Port[gx][`RS_ROBIDX];
        assign Port_S2E_d[gx][`PORT_S2E_PRD_TYPE]  = RS_IssuedTo_Port[gx][`RS_RD_TYPE];
        assign Port_S2E_d[gx][`PORT_S2E_PRD]       = RS_IssuedTo_Port[gx][`RS_PRD];
        assign Port_S2E_d[gx][`PORT_S2E_REG_WE]    = RS_IssuedTo_Port[gx][`RS_REG_WE];
        assign Port_S2E_d[gx][`PORT_S2E_OP1]       = Port_op1[gx];
        assign Port_S2E_d[gx][`PORT_S2E_OP2]       = Port_op2[gx];
        assign Port_S2E_d[gx][`PORT_S2E_OP3]       = Port_op3[gx];
        assign Port_S2E_d[gx][`PORT_S2E_FUTYPE]    = RS_IssuedTo_Port[gx][`RS_FUTYPE];
        assign Port_S2E_d[gx][`PORT_S2E_PC]        = RS_IssuedTo_Port[gx][`RS_PC];
        assign Port_S2E_d[gx][`PORT_S2E_CONTROLS]  = RS_IssuedTo_Port[gx][`RS_CONTROL_START+:`UOP_CONTROL_LEN];
    end
endgenerate


//assign issued uops to port registers
reg  [`PORT_S2E_LEN-1:0]    Port_S2E[0:`SCHED_PORTS-1];
integer s;
always @(posedge clk) begin
    if(rst | Flush) begin
        for(s=0;s<`SCHED_PORTS;s=s+1)
            Port_S2E[s] <= 0;
    end
    else begin
        for(s=0;s<`SCHED_PORTS;s=s+1) begin
            //keep value registered at port until new can be issed
            //New can be issued only when FU is ready.
            if(~Stall) begin
                if(Port_S2E_d[s][`PORT_S2E_VALID] & Port_E2S_Ready[s])          //FU ready and New Can be issued
                    Port_S2E[s] <= Port_S2E_d[s];
                else if(!Port_S2E_d[s][`PORT_S2E_VALID] & Port_E2S_Ready[s])    //FU ready but new can not be issued
                    Port_S2E[s] <= 0;
                else begin
                    //in other cases when Port is not ready, hold the value (for
                    //multicycle FUs). Only Update KILLMASK if Branch is
                    //correctly updated
                    if(Update_KillMask)
                        Port_S2E[s][`PORT_S2E_KILLMASK] <= Port_S2E[s][`PORT_S2E_KILLMASK] & ~FUBR_SpecTag;
                end
            end
        end
    end
end


//assign local wires to Scheduler Port outputs HACK:$@SCHED_PORTS
assign Port0_S2E = Port_S2E[0];
assign Port1_S2E = Port_S2E[1];
assign Port2_S2E = Port_S2E[2];
assign Port3_S2E = Port_S2E[3];
assign Port4_S2E = Port_S2E[4];
assign Port5_S2E = Port_S2E[5];

`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;
    `ifdef DEBUG_ISSUE
        always @(negedge clk) begin
            if(Stall) begin
                $display("[%t] ISSUE@STS##: Stall=%b", $time,
                    Stall);
            end
            else begin
                for (Di=0; Di<`RS_INT_ISSUE_REQ; Di=Di+1) begin
                    if(RSINT_IssueReq_Valid[Di]) begin
                        $display("[%t] ISUREQ@INT%-2d: PC=%h ROB=%0d V=%b | Killed=%b PortCheck=%b Issued=%b",$time, Di,
                            RSINT_IssueReq_Entry[Di][`RS_PC], RSINT_IssueReq_Entry[Di][`RS_ROBIDX], RSINT_IssueReq_Valid[Di],
                            RSINT_IssueReq_Killed[Di], Int_Check[Di], RSINT_Issued_Valid[Di]);
                    end
                end
                for (Di=0; Di<`RS_FP_ISSUE_REQ; Di=Di+1) begin
                    if(RSFP_IssueReq_Valid[Di]) begin
                        $display("[%t] ISUREQ@FP %-2d: PC=%h ROB=%0d V=%b | Killed=%b PortCheck=%b Issued=%b",$time, Di,
                            RSFP_IssueReq_Entry[Di][`RS_PC], RSFP_IssueReq_Entry[Di][`RS_ROBIDX], RSFP_IssueReq_Valid[Di],
                            RSFP_IssueReq_Killed[Di], Fp_Check[Di], RSFP_Issued_Valid[Di]);
                    end
                end
                for (Di=0; Di<`RS_MEM_ISSUE_REQ; Di=Di+1) begin
                    if(RSMEM_IssueReq_Valid[Di]) begin
                        $display("[%t] ISUREQ@MEM%-2d: PC=%h ROB=%0d V=%b | Killed=%b PortCheck=%b Issued=%b",$time, Di,
                            RSMEM_IssueReq_Entry[Di][`RS_PC], RSMEM_IssueReq_Entry[Di][`RS_ROBIDX], RSMEM_IssueReq_Valid[Di],
                            RSMEM_IssueReq_Killed[Di], Mem_Check[Di],RSMEM_Issued_Valid[Di]);
                    end
                end
                if(RSBR_IssueReq_Valid) begin
                    $display("[%t] ISUREQ@BR 0 : PC=%h ROB=%0d V=%b | Killed=%b PortCheck=%b Issued=%b",$time,
                        RSBR_IssueReq_Entry[`RS_PC], RSBR_IssueReq_Entry[`RS_ROBIDX], RSBR_IssueReq_Valid,
                        RSBR_IssueReq_Killed, Br_Check, RSBR_Issued_Valid);
                end

                if(RSSYS_IssueReq_Valid) begin
                    $display("[%t] ISUREQ@SYS0 : PC=%h ROB=%0d V=%b | Killed=%b PortCheck=%b Issued=%b",$time,
                        RSSYS_IssueReq_Entry[`RS_PC], RSSYS_IssueReq_Entry[`RS_ROBIDX], RSSYS_IssueReq_Valid,
                        RSSYS_IssueReq_Killed, Sys_Check, RSSYS_Issued_Valid);
                end

                for(Di=0; Di<`SCHED_PORTS; Di=Di+1) begin
                    if(Port_S2E_d[Di][`PORT_S2E_VALID]) begin
                        $display("[%t] ISSUE_@PRT%-2d: PC=%h ROB=%0d V=%b | FU=%s PortReady=%b", $time, Di,
                            Port_S2E_d[Di][`PORT_S2E_PC], Port_S2E_d[Di][`PORT_S2E_ROB_INDEX], Port_S2E_d[Di][`PORT_S2E_VALID],
                            FU2Str(Port_S2E_d[Di][`PORT_S2E_FUTYPE]), Port_E2S_Ready[Di]);
                    end
                end
            end
        end
    `endif
`endif

endmodule

