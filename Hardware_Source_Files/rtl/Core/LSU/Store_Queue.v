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
module Store_Queue
(
    input  wire clk,
    input  wire rst,

    input  wire Stall,
    input  wire Exception_Flush,

    //Branch Misprediction Kill Signals
    input  wire                             BranchMispredicted,
    input  wire                             Update_KillMask,
    input  wire [`SPEC_STATES-1:0]          FUBR_SpecTag,

    //Store Buffer Write Requests/Responses
    input  wire [`SB_WR_REQ_LEN-1:0]        SBWriteReq0,
    output wire [`SB_DEPTH_LEN-1:0]         SB_Index,

    //Store Buffer Status
    output wire [`SB_DEPTH_LEN:0]           SB_FreeEntries,
    output wire [`SB_DEPTH_LEN:0]           SB_UsedEntries,

    //Store Retire Requests
    input  wire [(`RETIRE_RATE*`RETIRE2LSU_PORT_LEN)-1:0]   Retire2LSU_Bus,

    //Load Buffer Masked Data Requests/Responses
    input  wire [`LB_MATCH_REQ_LEN-1:0]     LBMatchReq0,
    output wire [`LB_MATCH_RESP_LEN-1:0]    LBMatchResp0,

    //D-Cache Write Port Request/Response
    input  wire                             DCache_WrResp_Done,
    input  wire                             DCache_WrResp_Ready,
    output reg                              DCache_WrReq_Valid,
    output reg  [`DATA_TYPE__LEN-1:0]       DCache_WrReq_DataType,
    output reg  [55:0]                      DCache_WrReq_Paddr,
    output reg  [63:0]                      DCache_WrReq_Data

);
`include "LSU_func.v"


//convert input ports into Arrays
wire [`SB_WR_REQ_LEN-1:0]       SBWriteReq[0:0];
wire [`LB_MATCH_REQ_LEN-1:0]    LBMatchReq[0:0];
wire [`RETIRE2LSU_PORT_LEN-1:0] RetireReq[0:`RETIRE_RATE-1];

assign SBWriteReq[0] = SBWriteReq0; //HACK: Need to be customised for every port
assign LBMatchReq[0] = LBMatchReq0; //HACK: Need to be customised for every port
genvar ggpa;
generate
    for(ggpa=0; ggpa<`RETIRE_RATE; ggpa=ggpa+1) begin
        assign RetireReq[ggpa] = Retire2LSU_Bus[ggpa*`RETIRE2LSU_PORT_LEN+:`RETIRE2LSU_PORT_LEN];
    end
endgenerate


//Extract Buses from Arrays to Individual Signals
wire                            WrReq_Valid       = SBWriteReq[0][`SB_WR_REQ_VALID];
wire [`SPEC_STATES-1:0]         WrReq_KillMask    = SBWriteReq[0][`SB_WR_REQ_KILLMASK];
wire [2:0]                      WrReq_DataType    = SBWriteReq[0][`SB_WR_REQ_DATA_TYPE];
wire [55:0]                     WrReq_Paddr       = SBWriteReq[0][`SB_WR_REQ_PADDR];
wire [63:0]                     WrReq_Data        = SBWriteReq[0][`SB_WR_REQ_DATA];
wire                            WrReq_Killed      = BranchMispredicted & |(WrReq_KillMask & FUBR_SpecTag);

wire                            MatchReq_Valid    = LBMatchReq[0][`LB_MATCH_REQ_VALID];
wire [55:0]                     MatchReq_Paddr    = LBMatchReq[0][`LB_MATCH_REQ_PADDR];
wire [15:0]                     MatchReq_ByteMask = LBMatchReq[0][`LB_MATCH_REQ_BYTEMASK];


//2D Array of Registers for Store Buffer
reg  [`SB_ENTRY_LEN-1:0]    StoreBuff[0:`SB_DEPTH-1];
reg  [`SB_DEPTH_LEN-1:0]    wr_ptr;    //Tail
reg  [`SB_DEPTH_LEN-1:0]    rd_ptr;    //Head

//Metadata of each entry in Store Buffer
wire                            Entry_Valid[0:`SB_DEPTH-1];
wire                            Entry_Retired[0:`SB_DEPTH-1];
wire [15:0]                     Entry_Mask[0:`SB_DEPTH-1];
wire [55:0]                     Entry_Paddr[0:`SB_DEPTH-1];
wire [`SPEC_STATES-1:0]         Entry_KillMask[0:`SB_DEPTH-1];
wire [63:0]                     Entry_Data[0:`SB_DEPTH-1];
genvar gbe;
generate
    for(gbe=0; gbe<`SB_DEPTH; gbe=gbe+1) begin
        assign Entry_Valid[gbe]    = StoreBuff[gbe][`SB_ENTRY_VALID];
        assign Entry_Retired[gbe]  = StoreBuff[gbe][`SB_ENTRY_RETIRED];
        assign Entry_KillMask[gbe] = StoreBuff[gbe][`SB_ENTRY_KILLMASK];
        assign Entry_Mask[gbe]     = StoreBuff[gbe][`SB_ENTRY_MASK];
        assign Entry_Paddr[gbe]    = StoreBuff[gbe][`SB_ENTRY_PADDR];
        assign Entry_Data[gbe]     = StoreBuff[gbe][`SB_ENTRY_DATA];
    end
endgenerate


//Logic for killing entries in Store Buffer
//If Exception Flush is requested, All Valid & Not Retired Entries are Killed
//else if Branch mispredicted, valid & not retired branches with mispredicted branch's
//spectag matches with entry killmask
wire    Entry_WillbeKilled[0:`SB_DEPTH-1];
genvar gke;
generate
    for(gke=0; gke<`SB_DEPTH; gke=gke+1) begin
        assign Entry_WillbeKilled[gke] = Entry_Valid[gke] & ~Entry_Retired[gke] & (Exception_Flush ? 1'b1 :
            (BranchMispredicted ? |(Entry_KillMask[gke] & FUBR_SpecTag) : 1'b0) );
    end
endgenerate


//Logic for Retiring Store Buffer Entries
wire [`RETIRE_RATE-1:0] Retire_SBentry_Match[0:`SB_DEPTH-1];
wire                    Entry_WillbeRetired[0:`SB_DEPTH-1];
genvar gre, grr;
generate
    for(gre=0; gre<`SB_DEPTH; gre=gre+1) begin
        for(grr=0; grr<`RETIRE_RATE; grr=grr+1) begin
            assign Retire_SBentry_Match[gre][grr] = RetireReq[grr][`RETIRE2LSU_PORT_VALID] &
                (gre==RetireReq[grr][`RETIRE2LSU_PORT_SBIDX]);
        end
        assign Entry_WillbeRetired[gre] = |Retire_SBentry_Match[gre];
    end
endgenerate


//Store Buffer next value Logic
reg  [`SB_ENTRY_LEN-1:0]    StoreBuff_next[0:`SB_DEPTH-1];  //next value of store buffer entries
reg                         DCache_Completed;               //1=>D-Cache Transaction is completed (FSM Output Async)
integer i;
always @(*) begin
    for(i=0; i<`SB_DEPTH; i=i+1) begin
        //copy old data
        StoreBuff_next[i] = StoreBuff[i];

        //Mark to be retired entries as retired
        StoreBuff_next[i][`SB_ENTRY_RETIRED] = Entry_WillbeRetired[i] ? 1'b1 : Entry_Retired[i];

        //Logic for killing Store Buffer Entries
        //Killed bit is used to update store buffer pointer in case
        //misprediction
        StoreBuff_next[i][`SB_ENTRY_VALID]  = Entry_WillbeKilled[i] ? 1'b0 : Entry_Valid[i];
        StoreBuff_next[i][`SB_ENTRY_KILLED] = Entry_WillbeKilled[i] ? 1'b1 : StoreBuff[i][`SB_ENTRY_KILLED];

        //Update KillMask when Branch Not Mispredicted
        if(Update_KillMask)
            StoreBuff_next[i][`SB_ENTRY_KILLMASK] = StoreBuff[i][`SB_ENTRY_KILLMASK] & ~FUBR_SpecTag;
    end

    //set invalid to entry whose writing to D-Cache completed
    if(DCache_Completed) begin
        StoreBuff_next[rd_ptr][`SB_ENTRY_VALID]   = 1'b0;
        StoreBuff_next[rd_ptr][`SB_ENTRY_RETIRED] = 1'b0;
        StoreBuff_next[rd_ptr][`SB_ENTRY_KILLED]  = 1'b0;
    end

    //adding new entries to store buffer if not stalled (stall => writing
    //stalled)
    if(WrReq_Valid & ~Stall & ~Exception_Flush) begin
        StoreBuff_next[wr_ptr][`SB_ENTRY_VALID]    = WrReq_Killed ? 1'b0 : 1'b1;
        StoreBuff_next[wr_ptr][`SB_ENTRY_KILLED]   = WrReq_Killed ? 1'b1 : 1'b0;
        StoreBuff_next[wr_ptr][`SB_ENTRY_RETIRED]  = 1'b0;
        StoreBuff_next[wr_ptr][`SB_ENTRY_KILLMASK] = Update_KillMask ? (WrReq_KillMask & ~FUBR_SpecTag) : WrReq_KillMask;
        StoreBuff_next[wr_ptr][`SB_ENTRY_PADDR]    = WrReq_Paddr;
        StoreBuff_next[wr_ptr][`SB_ENTRY_DATA]     = WrReq_Data;
        StoreBuff_next[wr_ptr][`SB_ENTRY_DATATYPE] = WrReq_DataType;
        StoreBuff_next[wr_ptr][`SB_ENTRY_MASK]     = AddrType2Mask(WrReq_Paddr,WrReq_DataType);
    end
end


//Store Buffer Data Write Process
integer r;
always @(posedge clk) begin
    if(rst) begin
        for(r=0;r<`SB_DEPTH; r=r+1)
            StoreBuff[r]<=0;
    end
    else begin
        for(r=0; r<`SB_DEPTH; r=r+1)
            StoreBuff[r] <= StoreBuff_next[r];
    end
end


//Store Buffer wr_ptr update process
always @(posedge clk) begin
    if(rst)
        wr_ptr <= 0;
    else if(~Stall && WrReq_Valid && ~Exception_Flush) begin
        if(wr_ptr<(`SB_DEPTH-1))
            wr_ptr <= wr_ptr + 1;
        else
            wr_ptr <= 0;
    end
end


//Store Buffer rd_ptr update process
always @(posedge clk) begin
    if(rst)
        rd_ptr <= 0;
    else if(DCache_Completed) begin
        if(rd_ptr<(`SB_DEPTH-1))
            rd_ptr <= rd_ptr + 1;
        else
            rd_ptr <= 0;
    end
end


//D-Cache Writing Logic
wire [`SB_ENTRY_LEN-1:0]    SB_PeekData = StoreBuff[rd_ptr]; //Entry Pointed By rd_ptr (tail)
reg                         DCache_Busy;                     //1=>D-Cache Transaction is ongoing (Physical Register)
//Next values of FSM & Output Registers
reg  [2:0]                  DCache_WrReq_DataType_d;
reg  [55:0]                 DCache_WrReq_Paddr_d;
reg  [63:0]                 DCache_WrReq_Data_d;
reg                         DCache_Busy_d;

always @(*) begin
    //If No ongoing D-Cache Write Process
    if(~DCache_Busy) begin
        DCache_WrReq_Valid = 1'b0;
        if(SB_PeekData[`SB_ENTRY_VALID] && SB_PeekData[`SB_ENTRY_RETIRED] && DCache_WrResp_Ready) begin
            //If Peek Entry is Valid & Retired.
            DCache_WrReq_DataType_d = SB_PeekData[`SB_ENTRY_DATATYPE];
            DCache_WrReq_Paddr_d    = SB_PeekData[`SB_ENTRY_PADDR];
            DCache_WrReq_Data_d     = SB_PeekData[`SB_ENTRY_DATA];
            DCache_Busy_d           = 1'b1;
            DCache_Completed        = 1'b0;
        end
        else if(!SB_PeekData[`SB_ENTRY_VALID] && SB_PeekData[`SB_ENTRY_KILLED]) begin
            //If Peek Data is not valid as the entry was killed, So Say that
            //Writing Process is completed so that rd_ptr can be incremented.
            DCache_WrReq_DataType_d = 0;
            DCache_WrReq_Paddr_d    = 0;
            DCache_WrReq_Data_d     = 0;
            DCache_Busy_d           = 1'b0;
            DCache_Completed        = 1'b1;
        end
        else begin
            //Peek Entry is Not Retired Yet or Not Valid Entry is present yet
            //or DCache is NOT Ready
            DCache_WrReq_DataType_d = 0;
            DCache_WrReq_Paddr_d    = 0;
            DCache_WrReq_Data_d     = 0;
            DCache_Busy_d           = 1'b0;
            DCache_Completed        = 1'b0;
        end
    end
    else begin
        DCache_WrReq_Valid = 1'b1;
        if(DCache_WrResp_Done) begin
            //DCache has finished writing => Set FSM as NOT busy. Clear output
            //registers. Set DCache Completed async output, so that rd_ptr is
            //incremented
            DCache_WrReq_DataType_d = 0;
            DCache_WrReq_Paddr_d    = 0;
            DCache_WrReq_Data_d     = 0;
            DCache_Busy_d           = 1'b0;
            DCache_Completed        = 1'b1;
        end
        else begin
            //DCache writing is going on. Maintain data at output registers
            DCache_WrReq_DataType_d = DCache_WrReq_DataType;
            DCache_WrReq_Paddr_d    = DCache_WrReq_Paddr;
            DCache_WrReq_Data_d     = DCache_WrReq_Data;
            DCache_Busy_d           = 1'b1;
            DCache_Completed        = 1'b0;
        end
    end
end

always @(posedge clk) begin
    if(rst) begin
        DCache_WrReq_DataType <= 0;
        DCache_WrReq_Paddr    <= 0;
        DCache_WrReq_Data     <= 0;
        DCache_Busy           <= 0;
    end
    else begin
        DCache_WrReq_DataType <= DCache_WrReq_DataType_d;
        DCache_WrReq_Paddr    <= DCache_WrReq_Paddr_d;
        DCache_WrReq_Data     <= DCache_WrReq_Data_d;
        DCache_Busy           <= DCache_Busy_d;
    end
end


//SB Current Write Index Output
assign SB_Index = wr_ptr;


//generate used & free entry count from ptrs
assign SB_UsedEntries = (wr_ptr<rd_ptr) ? (wr_ptr + (`SB_DEPTH-rd_ptr)) : (wr_ptr - rd_ptr);
assign SB_FreeEntries = `SB_DEPTH - SB_UsedEntries;


//Load Buffer Data Match Request Logic
wire [`SB_DEPTH_LEN:0]  rd_ptr_index[0:`SB_DEPTH-1];
wire [`SB_DEPTH_LEN:0]  rd_index_wrapped[0:`SB_DEPTH-1];

wire [55:0]     MatchReq_PaddrPrev = MatchReq_Paddr-8;  //paddr Prev DoubleWord
wire [55:0]     MatchReq_PaddrNext = MatchReq_Paddr+8;  //paddr Next DoubleWord

wire [15:0]     SBEntry_Mask_Aligned[0:`SB_DEPTH-1];    //SB Mask after aligning and comapring Match Base paddr
wire [127:0]    SBEntry_ByteData[0:`SB_DEPTH-1];

//Ordered Data (See note in always block below)
wire [15:0]     SBEntry_Mask_AlignedOrdered[0:`SB_DEPTH-1];
wire [127:0]    SBEntry_ByteData_Ordered[0:`SB_DEPTH-1];    //Data in SB Aligned as per double word aligned base address paddr

genvar gsd;
generate
    for(gsd=0; gsd<`SB_DEPTH; gsd=gsd+1) begin
        //1. Relative Age Logic:
        //  Current Design has in-order load store. So at any stage when load
        //  match request is sent, stores in store buffer are surely older than load
        //  But for Out-of-Order Load/Store dispatch, load should track which
        //  stores are older than load.

        //2. SB Entry Mask Alignment
        //  Below logic checks the overlap of Store Paddr and Load Paddr even
        //  when they are overflowed to next double-word (e.g. double word
        //  staring at paddr[2:0]=0b100 will overflow into next doubleword which
        //  might not match with load/store paddr. also in reverse way)
        //
        //                                          f e d c b a 9 8 7 6 5 4 3 2 1 0
        //                                         +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
        //             STORE DW                    | | | | | | |X|X|X|X|X|X|X|X| | |                  Paddr:11010_010
        //                                         +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
        //                                                         |               |
        //                                                     1101_1xxx       1101_0xxx
        //
        //                          f e d c b a 9 8 7 6 5 4 3 2 1 0
        //                         +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
        //             LOAD1 DW    | | | | | | | | |X|X|X|X|X|X|X|X|                                  Paddr:11011_000
        //                         +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
        //                                         |               |
        //                                     1110_0xxx       1101_1xxx
        //
        //                                                          f e d c b a 9 8 7 6 5 4 3 2 1 0
        //                                                         +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
        //             LOAD2 DW                        LOAD1       | | |X|X|X|X|X|X|X|X| | | | | | |  Paddr:11001_110
        //                                                         +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
        //                                                                         |               |
        //                                                                     1101_0xxx       1100_1xxx
        //If MatchReq.paddr[55:3] == Entry.paddr[55:3]
        //  SBEntry_Mask_Aligned = Entry_Mask
        //elseIf MatchReq.paddrPrev[55:3] == Entry.padr[55:3]
        //  SBEntry_Mask_Aligned = {16'b0, Entry.Mask[15:8]}
        //elseIf MatchReq.paddrNext[55:3] == Entry.padd[55:3]
        //  SBEntry_Mask_Aligned = {Entry.Mask[7:0], 16'b0}
        //else
        //  SBEntry_Mask_Aligned = 0
        assign SBEntry_Mask_Aligned[gsd] =  (Entry_Valid[gsd]==1'b0) ? 16'b0 : (
                                                (MatchReq_Paddr[55:3]    ==Entry_Paddr[gsd][55:3]) ? (Entry_Mask[gsd]) : (
                                                (MatchReq_PaddrPrev[55:3]==Entry_Paddr[gsd][55:3]) ? {8'b0, Entry_Mask[gsd][15:8]} : (
                                                (MatchReq_PaddrNext[55:3]==Entry_Paddr[gsd][55:3]) ? {Entry_Mask[gsd][7:0], 8'b0} : 16'b0 ) ) );


        //3. Data Alignment to double word aligned base address
        //  generate Aligned Data Mask as per 64-bit aligned base address paddr
        assign SBEntry_ByteData[gsd] = AlignDataByAddr(Entry_Data[gsd],Entry_Paddr[gsd]);


        //4. SB Entry Mask & Data Ordering (Data is also ordered)
        //  The SBEntry Mask & Data are ordered from oldest(rd_ptr) to latest(wr_ptr).
        //  Then they will be matched with priority to latest
        localparam [`SB_DEPTH_LEN-1:0] idx      = gsd;
        assign rd_ptr_index[gsd]                = ({1'b0, rd_ptr} + {1'b0,idx});
        assign rd_index_wrapped[gsd]            = (rd_ptr_index[gsd]>=`SB_DEPTH) ? rd_ptr_index[gsd]-`SB_DEPTH : rd_ptr_index[gsd];
        assign SBEntry_Mask_AlignedOrdered[gsd] = SBEntry_Mask_Aligned[rd_index_wrapped[gsd][`SB_DEPTH_LEN-1:0]]; //0 is oldest
        assign SBEntry_ByteData_Ordered[gsd]    = SBEntry_ByteData[rd_index_wrapped[gsd][`SB_DEPTH_LEN-1:0]];
    end
endgenerate


//For all entries in Store Buffer, Mask is matched between Store Entry Mask
//and Load Match Request Mask. If Overlap is found, that byte is taken from
//that store buffer entry. The Store Buffer entry which is later in program
//order has preference. So that Load can get Latest data.
integer j,k;
reg  [15:0]     MatchResp_MatchMask;
reg  [15:0]     SBEntry_MatchMaskResult[0:`SB_DEPTH-1];
reg  [127:0]    MatchResp_ByteData;
always @* begin
    MatchResp_ByteData = 0;
    MatchResp_MatchMask = 0;
    for(j=0; j<`SB_DEPTH; j=j+1) begin
        SBEntry_MatchMaskResult[j] = (MatchReq_ByteMask & SBEntry_Mask_AlignedOrdered[j]);
        //bit i=1 => ith byte can be copied from SB Entry Data (Aligned) to Match Req Output

        MatchResp_MatchMask = MatchResp_MatchMask | SBEntry_MatchMaskResult[j];

        for(k=0; k<16; k=k+1) begin
            if(SBEntry_MatchMaskResult[j][k]) begin
                MatchResp_ByteData[k*8+:8] = SBEntry_ByteData_Ordered[j][k*8+:8];
            end
        end
    end
end


//Merge LB Responses to LBMatch Port
wire [`LB_MATCH_RESP_LEN-1:0]    LBMatchResp[0:0];
assign LBMatchResp[0][`LB_MATCH_RESP_VALID]     = MatchReq_Valid;
assign LBMatchResp[0][`LB_MATCH_RESP_MATCHMASK] = MatchResp_MatchMask;
assign LBMatchResp[0][`LB_MATCH_RESP_BYTEDATA]  = MatchResp_ByteData;

assign LBMatchResp0 = LBMatchResp[0]; //HACK: Need to be customised for every port


endmodule

