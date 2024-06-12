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

`define SRC_MMU     1'b0
`define SRC_LS      1'b1

(* keep_hierarchy = "yes" *)
module LSU
(
    input  wire clk,
    input  wire rst,

    input  wire Stall,
    input  wire Exception_Flush,

    //Branch (resolution) Functional Unit Result Bus
    input  wire [`FUBR_RESULT_LEN-1:0]      FUBRresp,

    //Request/Response from/to FU Port0
    input  wire [`LSU_REQ_LEN-1:0]          FU2LSUreq0,
    output wire [`LSU_RESP_LEN-1:0]         LSU2FUresp0,

    //Request/Response from/to FU Port1
    input  wire [`LSU_REQ_LEN-1:0]          FU2LSUreq1,
    output wire [`LSU_RESP_LEN-1:0]         LSU2FUresp1,

    //Request/Responses to D-Cache Read Port
    input  wire                             DCache_RdResp_Done,
    input  wire                             DCache_RdResp_Ready,
    input  wire [63:0]                      DCache_RdResp_Data,
    output wire                             DCache_RdReq_Valid,
    output wire [55:0]                      DCache_RdReq_Paddr,
    output wire [`DATA_TYPE__LEN-1:0]       DCache_RdReq_DataType,
    output wire                             DCache_RdReq_Abort,

    //Request/Responses to D-Cache Write Port
    input  wire                             DCache_WrResp_Done,
    input  wire                             DCache_WrResp_Ready,
    output wire                             DCache_WrReq_Valid,
    output wire [`DATA_TYPE__LEN-1:0]       DCache_WrReq_DataType,
    output wire [55:0]                      DCache_WrReq_Paddr,
    output wire [63:0]                      DCache_WrReq_Data,

    //Request/Responses to MMU Port 0
    output wire                             MMU_Req0_Valid,
    output wire [`MEM_ACCESS__LEN-1:0]      MMU_Req0_AccessType,
    output wire                             MMU_Req0_IsAtomic,
    output wire [63:0]                      MMU_Req0_Vaddr,
    output wire                             MMU_Req0_Abort,
    input  wire                             MMU_Resp0_Done,
    input  wire                             MMU_Resp0_Ready,
    input  wire [55:0]                      MMU_Resp0_Paddr,
    input  wire                             MMU_Resp0_Exception,
    input  wire [`ECAUSE_LEN-1:0]           MMU_Resp0_ECause,

    //Request/Responses to MMU Port 1
    output wire                             MMU_Req1_Valid,
    output wire [`MEM_ACCESS__LEN-1:0]      MMU_Req1_AccessType,
    output wire                             MMU_Req1_IsAtomic,
    output wire [63:0]                      MMU_Req1_Vaddr,
    output wire                             MMU_Req1_Abort,
    input  wire                             MMU_Resp1_Done,
    input  wire                             MMU_Resp1_Ready,
    input  wire [55:0]                      MMU_Resp1_Paddr,
    input  wire                             MMU_Resp1_Exception,
    input  wire [`ECAUSE_LEN-1:0]           MMU_Resp1_ECause,

    //Requests from Retire Unit
    input  wire [(`RETIRE_RATE*`RETIRE2LSU_PORT_LEN)-1:0]   Retire2LSU_Bus,

    //Store Buffer Status to EX Unit
    output wire                             SB_Empty,

    //Request/responses for Atomic Reservation
    input  wire [`AR_RESP_LEN-1:0]          AR_Resp,
    output wire [`AR_REQ_LEN-1:0]           AR_Req

);
`include "LSU_func.v"

//Extract individual signals from input requests
wire                         LSUreq0_Valid       = FU2LSUreq0[`LSU_REQ_VALID];
wire                         LSUreq0_Killed      = FU2LSUreq0[`LSU_REQ_KILLED];
wire [`LSU_OPER__LEN-1:0]    LSUreq0_Oper        = FU2LSUreq0[`LSU_REQ_OPER];
wire [`DATA_TYPE__LEN-1:0]   LSUreq0_DataType    = FU2LSUreq0[`LSU_REQ_DATA_TYPE];
wire [`SPEC_STATES-1:0]      LSUreq0_KillMask    = FU2LSUreq0[`LSU_REQ_KILLMASK];
wire [`LS_ORDER_TAG_LEN-1:0] LSUreq0_OrderTag    = FU2LSUreq0[`LSU_REQ_ORDERTAG];
wire [63:0]                  LSUreq0_Vaddr       = FU2LSUreq0[`LSU_REQ_VADDR];
wire [63:0]                  LSUreq0_StoreData   = FU2LSUreq0[`LSU_REQ_ST_DATA];
wire [1:0]                   LSUreq0_AmoData     = FU2LSUreq0[`LSU_REQ_AMO_DATA];

wire                         LSUreq1_Valid       = FU2LSUreq1[`LSU_REQ_VALID];
wire                         LSUreq1_Killed      = FU2LSUreq1[`LSU_REQ_KILLED];
wire [`LSU_OPER__LEN-1:0]    LSUreq1_Oper        = FU2LSUreq1[`LSU_REQ_OPER];
wire [`DATA_TYPE__LEN-1:0]   LSUreq1_DataType    = FU2LSUreq1[`LSU_REQ_DATA_TYPE];
wire [`SPEC_STATES-1:0]      LSUreq1_KillMask    = FU2LSUreq1[`LSU_REQ_KILLMASK];
wire [`LS_ORDER_TAG_LEN-1:0] LSUreq1_OrderTag    = FU2LSUreq1[`LSU_REQ_ORDERTAG];
wire [63:0]                  LSUreq1_Vaddr       = FU2LSUreq1[`LSU_REQ_VADDR];
wire [63:0]                  LSUreq1_StoreData   = FU2LSUreq1[`LSU_REQ_ST_DATA];
wire [1:0]                   LSUreq1_AmoData     = FU2LSUreq1[`LSU_REQ_AMO_DATA];

wire                         BranchMispredicted  = FUBRresp[`FUBR_RESULT_VALID] & FUBRresp[`FUBR_RESULT_MISPRED];
wire                         Update_KillMask     = FUBRresp[`FUBR_RESULT_VALID] & FUBRresp[`FUBR_RESULT_ISSPEC] & ~FUBRresp[`FUBR_RESULT_MISPRED];
wire [`SPEC_STATES-1:0]      FUBR_SpecTag        = FUBRresp[`FUBR_RESULT_SPECTAG];

//Local Interconnect Wires
wire [`LB_MATCH_REQ_LEN-1:0]    LBMatchReq0;
wire [`LB_MATCH_RESP_LEN-1:0]   LBMatchResp0;
wire [`LB_RD_REQ_LEN-1:0]       LBReadReq0;
wire [`LB_RD_RESP_LEN-1:0]      LBReadResp0;
wire [`SB_WR_REQ_LEN-1:0]       SBWriteReq0;
wire [`SB_DEPTH_LEN-1:0]        SB_Index;
wire [`SB_DEPTH_LEN:0]          SB_FreeEntries;
wire [`SB_DEPTH_LEN:0]          SB_UsedEntries;


//Other Misc Wires
reg             LoadReq_Valid;      //1=>Request to Load Buffer is Valid
reg             LoadReq_IsLR;       //1=>Request to Load Buffer is Atomic LR
reg             LoadReq_Src;        //Source for Load Buffer Request 0:LSreq0 1:LSreq1
wire            LoadResp_Done;      //1=>Load Buffer Transaction Completed
wire            LoadResp_Ready;     //1=>Load Buffer is Ready
wire [63:0]     LoadResp_Data;      //Load Buffer Output Data

reg             StoreReq_Valid;     //1=>Request to write in Store Queue is Valid
reg             StoreReq_IsSC;      //1=>Request to Store Buffer is Atomic SC
reg             StoreReq_Src;       //Source for Store Queue Write Request 0:LSreq0 1:LSreq1
wire            StoreResp_Done;     //1=>Store Buffer Writing COmpleted
wire            StoreResp_Ready;    //1=>Writing to Store Queue Completed
wire [63:0]     StoreResp_Data;     //Store Queue Entry index where input was written

reg             LSreq0_Issued;      //Load/Store Request 0 is issued
reg             LSreq0_IssueAllowd; //Load/Store Request 0 issue is permitted
wire            LSreq0_Valid;       //Load/Store Request 0 is Valid
wire [55:0]     LSreq0_Paddr;       //Load/Store Request 0 Physical Address
wire            LSresp0_Done;       //Load/Store Request 0 Completed
wire [63:0]     LSresp0_Data;       //Load/Store Request 0 Output Data

reg             LSreq1_Issued;      //Load/Store Request 1 is issued
reg             LSreq1_IssueAllowd; //Load/Store Request 1 issue is permitted
wire            LSreq1_Valid;       //Load/Store Request 1 is Valid
wire [55:0]     LSreq1_Paddr;       //Load/Store Request 1 Physical Address
wire            LSresp1_Done;       //Load/Store Request 1 Completed
wire [63:0]     LSresp1_Data;       //Load/Store Request 1 Output Data


/////////////////////////////////////////////////////////////////////////////////////
//FSM Outputs (non registered)
reg  send_MMUreq0, send_MMUreq1;            //1=>forward LSU request to MMU
reg  LSUresp0_Busy, LSUresp1_Busy;          //1=>LSU Port * is busy
reg  LSUresp0_Done, LSUresp1_Done;          //1=>LSU Port * output is Valid
reg  latch_Output0, latch_Output1;          //1=>Latch Output of LSU
reg  latch_OutputSrc0, latch_OutputSrc1;    //`SRC_LS & `SRC_MMU
reg  latch_MMUresp0, latch_MMUresp1;        //1=>MMU Response is latched as next block migh not be ready
reg  LSreq0_Pending, LSreq1_Pending;        //1=>Load/Store Request is Pending/Ongoing


localparam S_Idle       = 3'b000;
localparam S_MMUwait    = 3'b001;
localparam S_MMU        = 3'b011;
localparam S_DCacheWait = 3'b010;
localparam S_DCache     = 3'b110;

//FSM State registers
reg [2:0]    State0, State0_d;
reg [2:0]    State1, State1_d;

//Though LSU can accept two requests at a time, it can not guarrenty about
//there execution ordering as both request happens simulataneously. Due to
//unpredictable cycles taken by MMU & DCache, ordering can be disturedbed.
//A way to avoid this is to check overlapping of addresses, and allow only
//older request in program order to execute first with the help of LS Order
//Tag.
//The best way is to check overlap of Paddr. But obtaining Paddr itself
//involves MMU which is dynamic multicycle. So if newer request obtained Paddr
//first while older is yet to obtain, in this case newer can being cache
//operation as Paddr match fails. To overcome this problem, Vaddr match is
//done. Though two different Vaddr can be mapped to same Paddr. But its
//extream corner case to be handled now. The probability of Paddr overlap when
//Vaddr Overlaps is very high.


//check Older request from both (Assuming both are adjacent; since Mem
//instructions are issued in-order but two at a time. So following logic finds
//which is older in them relatively)
reg OlderReq;
always @* begin
    //if quardrant bit (MSB) is same
    if(LSUreq0_OrderTag[`LS_ORDER_TAG_LEN-1]==LSUreq1_OrderTag[`LS_ORDER_TAG_LEN-1]) begin
        if(LSUreq0_OrderTag[`LS_ORDER_TAG_LEN-2:0] > LSUreq1_OrderTag[`LS_ORDER_TAG_LEN-2:0])
            OlderReq = 1'b1;
        else
            OlderReq = 1'b0;
    end
    else begin
        if(LSUreq0_OrderTag[`LS_ORDER_TAG_LEN-2:0] > LSUreq1_OrderTag[`LS_ORDER_TAG_LEN-2:0])
            OlderReq = 1'b0;
        else
            OlderReq = 1'b1;
    end
end

//Vaddr Overlap Check
wire Vaddr_Overlap  = IsAddrOverlap(LSUreq0_Vaddr,LSUreq0_DataType,LSUreq1_Vaddr,LSUreq1_DataType);

//Allow only older request if overlap
reg  LSUreq0_OverlapStall, LSUreq1_OverlapStall;
always @(*) begin
    if(LSUreq0_Valid && LSUreq1_Valid && Vaddr_Overlap) begin
        if(OlderReq==1'b0) begin
            LSUreq0_OverlapStall = 1'b0;
            LSUreq1_OverlapStall = 1'b1;
        end
        else begin
            LSUreq0_OverlapStall = 1'b1;
            LSUreq1_OverlapStall = 1'b0;
        end
    end
    else begin
        LSUreq0_OverlapStall = 1'b0;
        LSUreq1_OverlapStall = 1'b0;
    end
end


//LSU Req0 FSM Process
always @* begin
    //Assign Default O/Ps
    send_MMUreq0     = 1'b0;
    LSUresp0_Busy    = 1'b1;
    LSUresp0_Done    = 1'b0;
    latch_Output0    = 1'b0;
    latch_OutputSrc0 = `SRC_MMU;
    latch_MMUresp0   = 1'b0;
    LSreq0_Pending   = 1'b0;
    LSreq0_Issued    = 1'b0;

    case(State0)
        S_Idle: begin
            LSUresp0_Busy = 1'b0;
            if(LSUreq0_Valid & !LSUreq0_Killed) begin
                LSUresp0_Busy = 1'b1;
                if(LSUreq0_OverlapStall) begin
                    State0_d     = S_Idle;
                end
                else if(MMU_Resp0_Ready) begin
                    send_MMUreq0 = 1'b1;

                    //Special Case when MMU responds in same clock cycle
                    if(!MMU_Resp0_Done) begin
                        //MMU Response Awaited
                        State0_d = S_MMU;
                    end
                    else if(MMU_Resp0_Exception) begin
                        //MMU Response Received but has exception
                        latch_Output0    = 1'b1;
                        latch_OutputSrc0 = `SRC_MMU;
                        LSUresp0_Done    = 1'b1;
                        LSUresp0_Busy    = 1'b0;
                        State0_d         = S_Idle;
                    end
                    else if(LSreq0_IssueAllowd) begin
                        //MMU Response was Issued to Load/Store Buffers i.e. D$
                        latch_MMUresp0 = 1'b1;
                        State0_d       = S_DCache;
                    end
                    else begin
                        //MMU Response can not be issued to Load/Store Buffers
                        latch_MMUresp0 = 1'b1;
                        State0_d       = S_DCacheWait;
                    end
                end
                else begin
                    State0_d     = S_MMUwait;
                end
            end
            else begin
                State0_d = S_Idle;
            end
        end

        S_MMUwait: begin
            if(LSUreq0_Killed | !LSUreq0_Valid)
                State0_d = S_Idle;
            else if(MMU_Resp0_Ready) begin
                send_MMUreq0 = 1'b1;

                //Special Case when MMU responds in same clock cycle
                if(!MMU_Resp0_Done) begin
                    //MMU Response Awaited
                    State0_d = S_MMU;
                end
                else if(MMU_Resp0_Exception) begin
                    //MMU Response Received but has exception
                    latch_Output0    = 1'b1;
                    latch_OutputSrc0 = `SRC_MMU;
                    LSUresp0_Done    = 1'b1;
                    LSUresp0_Busy    = 1'b0;
                    State0_d         = S_Idle;
                end
                else if(LSreq0_IssueAllowd) begin
                    //MMU Response was Issued to Load/Store Buffers i.e. D$
                    latch_MMUresp0 = 1'b1;
                    State0_d       = S_DCache;
                end
                else begin
                    //MMU Response can not be issued to Load/Store Buffers
                    latch_MMUresp0 = 1'b1;
                    State0_d       = S_DCacheWait;
                end
            end
            else begin
                State0_d     = S_MMUwait;
            end
        end

        S_MMU: begin
            send_MMUreq0 = 1'b1;
            if(LSUreq0_Killed)
                State0_d = S_Idle;
            else if(!MMU_Resp0_Done) begin
                //MMU Response Awaited
                State0_d = S_MMU;
            end
            else if(MMU_Resp0_Exception) begin
                //MMU Response Received but has exception
                latch_Output0    = 1'b1;
                latch_OutputSrc0 = `SRC_MMU;
                LSUresp0_Done    = 1'b1;
                LSUresp0_Busy    = 1'b0;
                State0_d         = S_Idle;
            end
            else if(LSreq0_IssueAllowd) begin
                //MMU Response was Issued to Load/Store Buffers i.e. D$
                latch_MMUresp0 = 1'b1;
                State0_d       = S_DCache;
            end
            else begin
                //MMU Response can not be issued to Load/Store Buffers
                latch_MMUresp0 = 1'b1;
                State0_d       = S_DCacheWait;
            end
        end

        S_DCacheWait: begin
            LSreq0_Pending = 1'b1;
            if(LSUreq0_Killed)
                State0_d = S_Idle;
            else if(LSreq0_IssueAllowd)
                State0_d = S_DCache;
            else
                State0_d = S_DCacheWait;
        end

        S_DCache: begin
            LSreq0_Pending = 1'b1;
            LSreq0_Issued  = 1'b1;
            if(LSUreq0_Killed)
                State0_d = S_Idle;
            else if(LSresp0_Done) begin
                LSUresp0_Done    = 1'b1;
                LSUresp0_Busy    = 1'b0;
                State0_d         = S_Idle;
                latch_Output0    = 1'b1;
                latch_OutputSrc0 = `SRC_LS;
            end
            else
                State0_d = S_DCache;
        end

        default : begin
            State0_d = S_Idle;
        end
    endcase
end


//LSU Req1 FSM Process
always @* begin
    //Assign Default O/Ps
    send_MMUreq1     = 1'b0;
    LSUresp1_Busy    = 1'b1;
    LSUresp1_Done    = 1'b0;
    latch_Output1    = 1'b0;
    latch_OutputSrc1 = `SRC_MMU;
    latch_MMUresp1   = 1'b0;
    LSreq1_Pending   = 1'b0;
    LSreq1_Issued    = 1'b0;

    case(State1)
        S_Idle: begin
            LSUresp1_Busy = 1'b0;
            if(LSUreq1_Valid & !LSUreq1_Killed) begin
                LSUresp1_Busy = 1'b1;
                if(LSUreq1_OverlapStall) begin
                    State1_d     = S_Idle;
                end
                else if(MMU_Resp1_Ready) begin
                    send_MMUreq1 = 1'b1;

                    //Special Case when MMU responds in same clock cycle
                    if(!MMU_Resp1_Done) begin
                        //MMU Response Awaited
                        State1_d = S_MMU;
                    end
                    else if(MMU_Resp1_Exception) begin
                        //MMU Response Received but has exception
                        latch_Output1    = 1'b1;
                        latch_OutputSrc1 = `SRC_MMU;
                        LSUresp1_Done    = 1'b1;
                        LSUresp1_Busy    = 1'b0;
                        State1_d         = S_Idle;
                    end
                    else if(LSreq1_IssueAllowd && LSresp1_Done) begin
                        //since store buffer is single cycle we can directly go to
                        //output stage
                        LSUresp1_Done    = 1'b1;
                        LSUresp1_Busy    = 1'b0;
                        State1_d         = S_Idle;
                        latch_Output1    = 1'b1;
                        latch_OutputSrc1 = `SRC_LS;
                    end
                    else if(LSreq1_IssueAllowd && !LSresp1_Done) begin
                        //MMU Response was Issued to Load/Store Buffers i.e. D$
                        latch_MMUresp1 = 1'b1;
                        State1_d       = S_DCache;
                    end
                    else begin
                        //MMU Response can not be issued to Load/Store Buffers
                        latch_MMUresp1 = 1'b1;
                        State1_d       = S_DCacheWait;
                    end
                end
                else begin
                    State1_d     = S_MMUwait;
                end
            end
            else begin
                State1_d = S_Idle;
            end
        end

        S_MMUwait: begin
            if(LSUreq1_Killed | !LSUreq1_Valid)
                State1_d = S_Idle;
            else if(MMU_Resp1_Ready) begin
                send_MMUreq1 = 1'b1;

                //Special Case when MMU responds in same clock cycle
                if(!MMU_Resp1_Done) begin
                    //MMU Response Awaited
                    State1_d = S_MMU;
                end
                else if(MMU_Resp1_Exception) begin
                    //MMU Response Received but has exception
                    latch_Output1    = 1'b1;
                    latch_OutputSrc1 = `SRC_MMU;
                    LSUresp1_Done    = 1'b1;
                    LSUresp1_Busy    = 1'b0;
                    State1_d         = S_Idle;
                end
                else if(LSreq1_IssueAllowd && LSresp1_Done) begin
                    //since store buffer is single cycle we can directly go to
                    //output stage
                    LSUresp1_Done    = 1'b1;
                    LSUresp1_Busy    = 1'b0;
                    State1_d         = S_Idle;
                    latch_Output1    = 1'b1;
                    latch_OutputSrc1 = `SRC_LS;
                end
                else if(LSreq1_IssueAllowd && !LSresp1_Done) begin
                    //MMU Response was Issued to Load/Store Buffers i.e. D$
                    latch_MMUresp1 = 1'b1;
                    State1_d       = S_DCache;
                end
                else begin
                    //MMU Response can not be issued to Load/Store Buffers
                    latch_MMUresp1 = 1'b1;
                    State1_d       = S_DCacheWait;
                end
            end
            else begin
                State1_d     = S_MMUwait;
            end
        end

        S_MMU: begin
            send_MMUreq1 = 1'b1;
            if(LSUreq1_Killed)
                State1_d = S_Idle;
            else if(!MMU_Resp1_Done) begin
                //MMU Response Awaited
                State1_d = S_MMU;
            end
            else if(MMU_Resp1_Exception) begin
                //MMU Response Received but has exception
                latch_Output1    = 1'b1;
                latch_OutputSrc1 = `SRC_MMU;
                LSUresp1_Done    = 1'b1;
                LSUresp1_Busy    = 1'b0;
                State1_d         = S_Idle;
            end
            else if(LSreq1_IssueAllowd && LSresp1_Done) begin
                //since store buffer is single cycle we can directly go to
                //output stage
                LSUresp1_Done    = 1'b1;
                LSUresp1_Busy    = 1'b0;
                State1_d         = S_Idle;
                latch_Output1    = 1'b1;
                latch_OutputSrc1 = `SRC_LS;
            end
            else if(LSreq1_IssueAllowd && !LSresp1_Done) begin
                //MMU Response was Issued to Load/Store Buffers i.e. D$
                latch_MMUresp1 = 1'b1;
                State1_d       = S_DCache;
            end
            else begin
                //MMU Response can not be issued to Load/Store Buffers
                latch_MMUresp1 = 1'b1;
                State1_d       = S_DCacheWait;
            end
        end

        S_DCacheWait: begin
            LSreq1_Pending = 1'b1;
            if(LSUreq1_Killed)
                State1_d = S_Idle;
            else if(LSreq1_IssueAllowd && !LSresp1_Done)
                State1_d = S_DCache;
            else if(LSreq1_IssueAllowd && LSresp1_Done) begin
                LSUresp1_Done    = 1'b1;
                LSUresp1_Busy    = 1'b0;
                State1_d         = S_Idle;
                latch_Output1    = 1'b1;
                latch_OutputSrc1 = `SRC_LS;
            end
            else
                State1_d = S_DCacheWait;
        end

        S_DCache: begin
            LSreq1_Pending = 1'b1;
            LSreq1_Issued  = 1'b1;
            if(LSUreq1_Killed)
                State1_d = S_Idle;
            else if(LSresp1_Done) begin
                LSUresp1_Done    = 1'b1;
                LSUresp1_Busy    = 1'b0;
                State1_d         = S_Idle;
                latch_Output1    = 1'b1;
                latch_OutputSrc1 = `SRC_LS;
            end
            else
                State1_d = S_DCache;
        end

        default : begin
            State1_d = S_Idle;
        end
    endcase
end


//Next State Assignment Process
always @(posedge clk) begin
    if(rst) begin
        State0 <= S_Idle;
        State1 <= S_Idle;
    end
    else begin
        State0 <= State0_d;
        State1 <= State1_d;
    end
end


/////////////////////////////////////////////////////////////////////////////////////
//MMU Request Response DataPath
assign MMU_Req0_Valid      = send_MMUreq0;
assign MMU_Req0_AccessType = LSUoper2AccessType(LSUreq0_Oper);
assign MMU_Req0_IsAtomic   = IsLSUOperAtomic(LSUreq0_Oper);
assign MMU_Req0_Vaddr      = LSUreq0_Vaddr;
assign MMU_Req0_Abort      = send_MMUreq0 & LSUreq0_Killed;

assign MMU_Req1_Valid      = send_MMUreq1;
assign MMU_Req1_AccessType = LSUoper2AccessType(LSUreq1_Oper);
assign MMU_Req1_IsAtomic   = IsLSUOperAtomic(LSUreq1_Oper);
assign MMU_Req1_Vaddr      = LSUreq1_Vaddr;
assign MMU_Req1_Abort      = send_MMUreq1 & LSUreq1_Killed;


//MMU Response Latching Process0
reg         MMU_Resp0Latched_Valid;
reg [55:0]  MMU_Resp0Latched_Paddr;
always @(posedge clk) begin
    if(rst) begin
        MMU_Resp0Latched_Valid <= 0;
        MMU_Resp0Latched_Paddr <= 0;
    end
    else if(latch_MMUresp0) begin
        MMU_Resp0Latched_Valid <= MMU_Resp0_Done;
        MMU_Resp0Latched_Paddr <= MMU_Resp0_Paddr;
    end
end

//MMU Response Latching Process1
reg         MMU_Resp1Latched_Valid;
reg [55:0]  MMU_Resp1Latched_Paddr;
always @(posedge clk) begin
    if(rst) begin
        MMU_Resp1Latched_Valid <= 0;
        MMU_Resp1Latched_Paddr <= 0;
    end
    else if(latch_MMUresp1) begin
        MMU_Resp1Latched_Valid <= MMU_Resp1_Done;
        MMU_Resp1Latched_Paddr <= MMU_Resp1_Paddr;
    end
end


//LS Requests from MMU Output or MMU Latched Data
//If    LSreq is Pending => MMU Latched data is forwarded as LS Request
//else                      MMU output is forwarded as LS Request
assign LSreq0_Valid = LSreq0_Pending ? MMU_Resp0Latched_Valid : (MMU_Resp0_Done && !MMU_Resp0_Exception);
assign LSreq1_Valid = LSreq1_Pending ? MMU_Resp1Latched_Valid : (MMU_Resp1_Done && !MMU_Resp1_Exception);
assign LSreq0_Paddr = LSreq0_Pending ? MMU_Resp0Latched_Paddr : MMU_Resp0_Paddr;
assign LSreq1_Paddr = LSreq1_Pending ? MMU_Resp1Latched_Paddr : MMU_Resp1_Paddr;

/////////////////////////////////////////////////////////////////////////////////////
//Check Cases when two requests can not be issued

//check for Overlapping Paddrs in both requests.
wire Paddr_Overlap  = IsAddrOverlap({8'b0,LSreq0_Paddr},LSUreq0_DataType,{8'b1,LSreq1_Paddr},LSUreq1_DataType);

//HACK: Both are stores case cannot occure since we have only one store unit.
//Rather both are loads can occure since Store FU can generate Load Request
//Also for atomic operations
//See Table Below
//  req0 from Load  FU of Port 3 => Load
//  req1 from Store FU of Port 4 => Store, ALoad, AStore, LR, SC
//  ---------------------
//  Load    Store   => Overlap Check
//  Load    ALoad   => Issue Only Older
//  Load    AStore  => Overlap Check
//  Load    LR      => Issue Only Older
//  Load    SC      => Overlap Check
//
always @* begin
    LoadReq_Src   = 1'b0;     StoreReq_Src = 1'b1;
    LoadReq_Valid = 1'b0;   StoreReq_Valid = 1'b0;
    LoadReq_IsLR  = 1'b0;   StoreReq_IsSC  = 1'b0;

    if(LSreq0_Valid && LSreq1_Valid) begin
        case(LSUreq1_Oper)
            `LSU_OPER_STORE, `LSU_OPER_AMOSTORE, `LSU_OPER_AMOSC: begin
                //check for overlap; if overlap allow only oldest;
                if(Paddr_Overlap) begin
                    if(OlderReq==1'b0) begin
                        LSreq0_IssueAllowd = LSreq0_Issued ? 1'b1 : LoadResp_Ready;
                        LSreq1_IssueAllowd = 1'b0;
                    end
                    else begin
                        LSreq0_IssueAllowd = 1'b0;
                        LSreq1_IssueAllowd = LSreq1_Issued ? 1'b1 : StoreResp_Ready;
                    end
                    LoadReq_Valid          = LSreq0_IssueAllowd;
                    StoreReq_Valid         = LSreq1_IssueAllowd;
                end
                else begin
                    LSreq0_IssueAllowd = LSreq0_Issued ? 1'b1 : LoadResp_Ready;
                    LSreq1_IssueAllowd = LSreq1_Issued ? 1'b1 : StoreResp_Ready;
                    LoadReq_Valid      = LSreq0_IssueAllowd;
                    StoreReq_Valid     = LSreq1_IssueAllowd;
                end
            end
            `LSU_OPER_AMOLOAD, `LSU_OPER_AMOLR: begin
                //only older can be issued
                if(OlderReq==1'b0) begin
                    LoadReq_Src        = 1'b0;
                    LSreq0_IssueAllowd = LSreq0_Issued ? 1'b1 : LoadResp_Ready;
                    LSreq1_IssueAllowd = 1'b0;
                    LoadReq_Valid      = LSreq0_IssueAllowd;
                end
                else begin
                    LoadReq_Src        = 1'b1;
                    LSreq0_IssueAllowd = 1'b0;
                    LSreq1_IssueAllowd = LSreq1_Issued ? 1'b1 : LoadResp_Ready;
                    LoadReq_Valid      = LSreq1_IssueAllowd;
                end
            end
            default: begin
                LSreq0_IssueAllowd = LSreq0_Issued ? 1'b1 : LoadResp_Ready;
                LSreq1_IssueAllowd = 1'b0;
                LoadReq_Src        = 1'b0;
                LoadReq_Valid      = LSreq0_IssueAllowd;
            end
        endcase
    end
    else if(LSreq0_Valid & (LSUreq0_Oper==`LSU_OPER_LOAD)) begin
        LSreq0_IssueAllowd = LSreq0_Issued ? 1'b1 : LoadResp_Ready;
        LSreq1_IssueAllowd = 1'b1;
        LoadReq_Valid      = LSreq0_IssueAllowd;
        LoadReq_Src        = 1'b0;
    end
    else if(LSreq1_Valid & ((LSUreq1_Oper==`LSU_OPER_AMOSTORE) || (LSUreq1_Oper==`LSU_OPER_STORE) || (LSUreq1_Oper==`LSU_OPER_AMOSC))) begin
        LSreq0_IssueAllowd = 1'b0;
        LSreq1_IssueAllowd = LSreq1_Issued ? 1'b1 : StoreResp_Ready;
        StoreReq_Valid     = LSreq1_IssueAllowd;
        StoreReq_Src       = 1'b1;
    end
    else if(LSreq1_Valid & ((LSUreq1_Oper==`LSU_OPER_AMOLOAD) || (LSUreq1_Oper==`LSU_OPER_AMOLR)) ) begin
        LSreq0_IssueAllowd = 1'b0;
        LSreq1_IssueAllowd = LSreq1_Issued ? 1'b1 : LoadResp_Ready;
        LoadReq_Valid     = LSreq1_IssueAllowd;
        LoadReq_Src       = 1'b1;
    end
    else begin
        LSreq0_IssueAllowd = 1'b0;
        LSreq1_IssueAllowd = 1'b0;
        LoadReq_Valid      = 1'b0;
        StoreReq_Valid     = 1'b0;
    end

    StoreReq_IsSC = (LSUreq1_Oper==`LSU_OPER_AMOSC);
    LoadReq_IsLR  = (LSUreq1_Oper==`LSU_OPER_AMOLR);

    //since store buffer is single cycle, StoreReq_Valid should be deasserted
    //if state is output
    //TODO: VERIFY StoreReq_Valid = (State1==S_Output) ? 1'b0 : StoreReq_Valid;
end


/////////////////////////////////////////////////////////////////////////////////////
//Atomic Reservation Request & Response
assign AR_Req[`AR_REQ_VALID]  = (LoadReq_Valid & LoadReq_IsLR) | (StoreReq_Valid & StoreReq_IsSC);
assign AR_Req[`AR_REQ_ISLR]   = (LoadReq_Valid & LoadReq_IsLR);
assign AR_Req[`AR_REQ_ISWORD] = LSUreq1_DataType==`DATA_TYPE_W;
assign AR_Req[`AR_REQ_PADDR]  = (LoadReq_Valid & LoadReq_IsLR) ? LBReadReq0[`LB_RD_REQ_PADDR] : SBWriteReq0[`SB_WR_REQ_PADDR];


/////////////////////////////////////////////////////////////////////////////////////
//Assign request to Load Buffer as per LoadReq_Src
assign LBReadReq0[`LB_RD_REQ_VALID]    = LoadReq_Valid;
assign LBReadReq0[`LB_RD_REQ_KILLED]   = LoadReq_Src ? LSUreq1_Killed : LSUreq0_Killed;
assign LBReadReq0[`LB_RD_REQ_DATATYPE] = LoadReq_Src ? LSUreq1_DataType : LSUreq0_DataType;
assign LBReadReq0[`LB_RD_REQ_PADDR]    = LoadReq_Src ? LSreq1_Paddr : LSreq0_Paddr;
assign LoadResp_Done                   = LBReadResp0[`LB_RD_RESP_DONE];
assign LoadResp_Ready                  = LBReadResp0[`LB_RD_RESP_READY];
assign LoadResp_Data                   = LBReadResp0[`LB_RD_RESP_DATA];

Load_Buffer Load_Buffer
(
    .clk                   (clk                  ),
    .rst                   (rst                  ),

    .Exception_Flush       (Exception_Flush      ),

    .LBReadReq0            (LBReadReq0           ),
    .LBReadResp0           (LBReadResp0          ),

    .LBMatchReq0           (LBMatchReq0          ),
    .LBMatchResp0          (LBMatchResp0         ),

    .DCache_RdReq_Valid    (DCache_RdReq_Valid   ),
    .DCache_RdReq_Paddr    (DCache_RdReq_Paddr   ),
    .DCache_RdReq_DataType (DCache_RdReq_DataType),
    .DCache_RdReq_Abort    (DCache_RdReq_Abort   ),
    .DCache_RdResp_Done    (DCache_RdResp_Done   ),
    .DCache_RdResp_Ready   (DCache_RdResp_Ready  ),
    .DCache_RdResp_Data    (DCache_RdResp_Data   )
);


/////////////////////////////////////////////////////////////////////////////////////
//Store Conditional Handling
reg StoreReq_Valid_final;
reg SC_Failed;
always @(*) begin
    SC_Failed = 1'b0;
    StoreReq_Valid_final = StoreReq_Valid;
    if(StoreReq_Valid) begin
        if(StoreReq_IsSC) begin
            if(AR_Resp[`AR_RESP_DONE] & AR_Resp[`AR_RESP_RESERVATION]) begin
                SC_Failed = 1'b0;
                StoreReq_Valid_final = 1'b1;
            end
            else begin
                SC_Failed = 1'b1;
                StoreReq_Valid_final = 1'b0;
            end
        end
    end
end


assign SBWriteReq0[`SB_WR_REQ_VALID]     = StoreReq_Valid_final;
assign SBWriteReq0[`SB_WR_REQ_DATA_TYPE] = StoreReq_Src ? LSUreq1_DataType : LSUreq0_DataType;
assign SBWriteReq0[`SB_WR_REQ_KILLMASK]  = StoreReq_Src ? LSUreq1_KillMask : LSUreq0_KillMask;
assign SBWriteReq0[`SB_WR_REQ_PADDR]     = StoreReq_Src ? LSreq1_Paddr     : LSreq0_Paddr;
assign SBWriteReq0[`SB_WR_REQ_DATA]      = StoreReq_Src ? LSUreq1_StoreData: LSUreq0_StoreData;

assign StoreResp_Ready                   = (SB_FreeEntries>1);
assign StoreResp_Data                    = (StoreReq_IsSC & SC_Failed) ? -(64'd1) : {{(64-`SB_DEPTH_LEN){1'b0}},SB_Index};
assign StoreResp_Done                    = StoreResp_Ready & StoreReq_Valid;

Store_Queue Store_Queue
(
    .clk                   (clk                  ),
    .rst                   (rst                  ),

    .Stall                 (Stall                ),
    .Exception_Flush       (Exception_Flush      ),

    .BranchMispredicted    (BranchMispredicted   ),
    .Update_KillMask       (Update_KillMask      ),
    .FUBR_SpecTag          (FUBR_SpecTag         ),

    .SBWriteReq0           (SBWriteReq0          ),
    .SB_Index              (SB_Index             ),

    .SB_FreeEntries        (SB_FreeEntries       ),
    .SB_UsedEntries        (SB_UsedEntries       ),

    .Retire2LSU_Bus        (Retire2LSU_Bus       ),

    .LBMatchReq0           (LBMatchReq0          ),
    .LBMatchResp0          (LBMatchResp0         ),

    .DCache_WrResp_Done    (DCache_WrResp_Done   ),
    .DCache_WrResp_Ready   (DCache_WrResp_Ready  ),
    .DCache_WrReq_Valid    (DCache_WrReq_Valid   ),
    .DCache_WrReq_DataType (DCache_WrReq_DataType),
    .DCache_WrReq_Paddr    (DCache_WrReq_Paddr   ),
    .DCache_WrReq_Data     (DCache_WrReq_Data    )
);

/////////////////////////////////////////////////////////////////////////////////////
//LS Output Merging Based on Source
assign LSresp0_Done = (LoadReq_Valid && LoadReq_Src==1'b0) ? LoadResp_Done : (
                                (StoreReq_Valid && StoreReq_Src==1'b0) ? StoreResp_Done : 1'b0 );
assign LSresp0_Data = (LoadReq_Valid && LoadReq_Src==1'b0) ? LoadResp_Data : (
                                (StoreReq_Valid && StoreReq_Src==1'b0) ? StoreResp_Data : 0 );

assign LSresp1_Done = (LoadReq_Valid && LoadReq_Src==1'b1) ? LoadResp_Done : (
                                (StoreReq_Valid && StoreReq_Src==1'b1) ? StoreResp_Done : 1'b0 );
assign LSresp1_Data = (LoadReq_Valid && LoadReq_Src==1'b1) ? LoadResp_Data : (
                                (StoreReq_Valid && StoreReq_Src==1'b1) ? StoreResp_Data : 0 );

//Final Output Registering Process
reg  [63:0]             LSUresp0_Data;
reg  [`ECAUSE_LEN-1:0]  LSUresp0_ECause;
reg                     LSUresp0_Exception;
always @(*) begin
    LSUresp0_Data       = latch_OutputSrc0==`SRC_LS ? LSresp0_Data : {8'b0,MMU_Resp0_Paddr};
    LSUresp0_ECause     = latch_OutputSrc0==`SRC_LS ? 0            : MMU_Resp0_ECause;
    LSUresp0_Exception  = latch_OutputSrc0==`SRC_LS ? 0            : MMU_Resp0_Exception;
end

reg  [63:0]             LSUresp1_Data;
reg  [`ECAUSE_LEN-1:0]  LSUresp1_ECause;
reg                     LSUresp1_Exception;
always @(*) begin
    LSUresp1_Data       = latch_OutputSrc1==`SRC_LS ? LSresp1_Data : {8'b0,MMU_Resp1_Paddr};
    LSUresp1_ECause     = latch_OutputSrc1==`SRC_LS ? 0            : MMU_Resp1_ECause;
    LSUresp1_Exception  = latch_OutputSrc1==`SRC_LS ? 0            : MMU_Resp1_Exception;
end

assign LSU2FUresp0[`LSU_RESP_DONE]      = LSUresp0_Done;
assign LSU2FUresp0[`LSU_RESP_READY]     = ~LSUresp0_Busy;
assign LSU2FUresp0[`LSU_RESP_DATA]      = LSUresp0_Data;
assign LSU2FUresp0[`LSU_RESP_EXCEPTION] = LSUresp0_Exception;
assign LSU2FUresp0[`LSU_RESP_ECAUSE]    = LSUresp0_ECause;

assign LSU2FUresp1[`LSU_RESP_DONE]      = LSUresp1_Done;
assign LSU2FUresp1[`LSU_RESP_READY]     = ~LSUresp1_Busy;
assign LSU2FUresp1[`LSU_RESP_DATA]      = LSUresp1_Data;
assign LSU2FUresp1[`LSU_RESP_EXCEPTION] = LSUresp1_Exception;
assign LSU2FUresp1[`LSU_RESP_ECAUSE]    = LSUresp1_ECause;

assign SB_Empty = (SB_UsedEntries==0);

endmodule

