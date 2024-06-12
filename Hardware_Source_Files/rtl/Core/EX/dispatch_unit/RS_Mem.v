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
module RS_Mem
(
    input  wire clk,
    input  wire rst,

    input  wire Stall,
    input  wire Flush,

    //Inputs related to killing entries
    input  wire                                                 Kill_Enable,            //1=>branch mispredicted => kill instructions
    input  wire                                                 Update_KillMask,        //1=>Update KillMask on Branch Correct Prediction
    input  wire [`SPEC_STATES-1:0]                              FUBR_SpecTag,         //Spectag of branch which mispredicted

    //Inputs for adding uops to RS
    input  wire [(`DISPATCH_RATE*`RS_MEM_LEN)-1:0]              RSMEM_WrDataIn,
    input  wire [`DISPATCH_RATE-1:0]                            RSMEM_WrValid,

    //Input for issue request confirmation
    input  wire [`RS_MEM_ISSUE_REQ-1:0]                         RSMEM_Issued_Valid,     //i=1 => ith issue request confirmation is valid

    //Inputs for Wakeup
    input  wire [(`SCHED_PORTS*`WAKEUP_RESP_LEN)-1:0]           WakeupResponses,        //Wakeup Response Bus

    //Outputs related to space
    output reg  [$clog2(`RS_MEM_DEPTH):0]                       RSMEM_FreeEntries,      //Available Free Entries in RS

    //Outputs for issue request
    output wire [(`RS_MEM_ISSUE_REQ*`RS_MEM_LEN)-1:0]           RSMEM_IssueReq_Entries, //Entries requested for issue
    output wire [`RS_MEM_ISSUE_REQ-1:0]                         RSMEM_IssueReq_Valid    //i=1 => ith request for issue is valid

);

localparam RS_MEM_DEPTH_LEN = $clog2(`RS_MEM_DEPTH);

//separate merged Write Data input wires
wire [`RS_MEM_LEN-1:0] WriteDataIn[0:`DISPATCH_RATE-1];
genvar gid;
generate
    for(gid=0; gid<`DISPATCH_RATE;gid=gid+1) begin
        assign WriteDataIn[gid] = RSMEM_WrDataIn[gid*`RS_MEM_LEN+:`RS_MEM_LEN];
    end
endgenerate

//separate merged wakeup port data to individual wires
wire [`WAKEUP_RESP_LEN-1:0] WakeupResp          [0:`SCHED_PORTS-1];
wire                        WakeupResp_Valid    [0:`SCHED_PORTS-1];
wire                        WakeupResp_PrdType  [0:`SCHED_PORTS-1];
wire [`PRF_MAX_LEN-1:0]     WakeupResp_Prd      [0:`SCHED_PORTS-1];
genvar giw;
generate
    for(giw=0; giw<`SCHED_PORTS; giw=giw+1) begin
        assign WakeupResp[giw]         = WakeupResponses[giw*`WAKEUP_RESP_LEN+:`WAKEUP_RESP_LEN];
        assign WakeupResp_Valid[giw]   = WakeupResp[giw][`WAKEUP_RESP_VALID] & WakeupResp[giw][`WAKEUP_RESP_REG_WE];
        assign WakeupResp_PrdType[giw] = WakeupResp[giw][`WAKEUP_RESP_PRD_TYPE];
        assign WakeupResp_Prd[giw]     = WakeupResp[giw][`WAKEUP_RESP_PRD];
    end
endgenerate


//2D array of registers for Reservation Stations
reg  [`RS_MEM_LEN-1:0] RS_Mem[0:`RS_MEM_DEPTH-1];

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//wires for updateing status of entries in RS
wire                            Willbe_Killed[0:`RS_MEM_DEPTH-1];
wire [`SCHED_PORTS-1:0]         Wakeup_PRS1_tag_match[0:`RS_MEM_DEPTH-1];
wire [`SCHED_PORTS-1:0]         Wakeup_PRS2_tag_match[0:`RS_MEM_DEPTH-1];
wire                            Willbe_PRS1_Ready[0:`RS_MEM_DEPTH-1];
wire                            Willbe_PRS2_Ready[0:`RS_MEM_DEPTH-1];
wire [`RS_MEM_ISSUE_REQ-1:0]    WasIssued_id_match[0:`RS_MEM_DEPTH-1];
wire                            Was_Issued[0:`RS_MEM_DEPTH-1];
reg [RS_MEM_DEPTH_LEN-1:0]      IssueReq_Id[0:`RS_MEM_ISSUE_REQ-1];         //Index of RS Entry Requested for issue

genvar ge,gw,gi;
generate
    for(ge=0; ge<`RS_MEM_DEPTH; ge=ge+1) begin
        //Check if Entry will be killed
        assign Willbe_Killed[ge] = RS_Mem[ge][`RS_VALID] & Kill_Enable & |(FUBR_SpecTag & RS_Mem[ge][`RS_KILLMASK]);

        //check if wakeup response will make operands ready
        for(gw=0; gw<`SCHED_PORTS; gw=gw+1) begin
            assign Wakeup_PRS1_tag_match[ge][gw] = RS_Mem[ge][`RS_VALID] & WakeupResp_Valid[gw] &
                (WakeupResp_PrdType[gw]==RS_Mem[ge][`RS_RS1_TYPE]) & (WakeupResp_Prd[gw]==RS_Mem[ge][`RS_PRS1]);
            assign Wakeup_PRS2_tag_match[ge][gw] = RS_Mem[ge][`RS_VALID] & WakeupResp_Valid[gw] &
                (WakeupResp_PrdType[gw]==RS_Mem[ge][`RS_RS2_TYPE]) & (WakeupResp_Prd[gw]==RS_Mem[ge][`RS_PRS2]);
        end
        assign Willbe_PRS1_Ready[ge] = |Wakeup_PRS1_tag_match[ge];
        assign Willbe_PRS2_Ready[ge] = |Wakeup_PRS2_tag_match[ge];

        //check if Entry was requested for issue and request was confirmed
        //i.e. Entry was issed, now to be invalidate
        for(gi=0; gi<`RS_MEM_ISSUE_REQ; gi=gi+1) begin
            assign WasIssued_id_match[ge][gi] = RSMEM_Issued_Valid[gi] & (IssueReq_Id[gi]==ge);
        end
        assign Was_Issued[ge] = |WasIssued_id_match[ge];
    end
endgenerate


//wires for RS Entries to be written after killing, issue confirmation,
//operand ready and appending inputs. Killed/issued entries will be bubbles
wire [`RS_MEM_LEN-1:0] RS_Mem_next[0:(`RS_MEM_DEPTH+`DISPATCH_RATE)-1];
genvar gn,gm;
generate
    for(gn=0; gn<`RS_MEM_DEPTH; gn=gn+1) begin
        assign RS_Mem_next[gn][`RS_VALID]    = (Willbe_Killed[gn] | Was_Issued[gn]) ? 1'b0 : RS_Mem[gn][`RS_VALID];
        assign RS_Mem_next[gn][`RS_PRS1_RDY] = (Willbe_PRS1_Ready[gn]) ? 1'b1 : RS_Mem[gn][`RS_PRS1_RDY];
        assign RS_Mem_next[gn][`RS_PRS2_RDY] = (Willbe_PRS2_Ready[gn]) ? 1'b1 : RS_Mem[gn][`RS_PRS2_RDY];
        assign RS_Mem_next[gn][`RS_KILLMASK] = Update_KillMask ? (RS_Mem[gn][`RS_KILLMASK] & ~FUBR_SpecTag) : RS_Mem[gn][`RS_KILLMASK];

        //copy remaining data as it is
        assign RS_Mem_next[gn][`RS_PRS3_RDY]              = RS_Mem[gn][`RS_PRS3_RDY];
        assign RS_Mem_next[gn][`RS_MEM_LEN-1:`RS_TAG_LEN] = RS_Mem[gn][`RS_MEM_LEN-1:`RS_TAG_LEN];
    end

    //append dispatched entries
    for(gm=0; gm<`DISPATCH_RATE; gm=gm+1) begin
        assign RS_Mem_next[`RS_MEM_DEPTH+gm][`RS_VALID] = WriteDataIn[gm][`RS_VALID] & RSMEM_WrValid[gm];
        assign RS_Mem_next[`RS_MEM_DEPTH+gm][`RS_MEM_LEN-1:`RS_VALID__BIT+1] = WriteDataIn[gm][`RS_MEM_LEN-1:`RS_VALID__BIT+1];
    end
endgenerate


//Main Collapsible Queue Logic
//invalid entries in RS are removed, entried after that are shifted and new
//data is appended.
reg  [`RS_MEM_LEN-1:0]      RS_Mem_next_collapsed[0:`RS_MEM_DEPTH-1];  //Next RS Mem Values without bubbles (collapsed)
reg  [`RS_MEM_DEPTH+`DISPATCH_RATE-1:0]    isUsed;
reg  [`RS_MEM_DEPTH-1:0]    isDone;
integer i,j;
always @* begin
    isDone = 0;
    isUsed = 0;

    for(i=0; i<`RS_MEM_DEPTH; i=i+1) begin
        RS_Mem_next_collapsed[i] = 0;
        for(j=i; j<(`RS_MEM_DEPTH+`DISPATCH_RATE);j=j+1) begin
            if(RS_Mem_next[j][`RS_VALID]==1'b1 && isUsed[j]==1'b0 && isDone[i]==1'b0) begin
                RS_Mem_next_collapsed[i] = RS_Mem_next[j];
                isUsed[j] = 1'b1;
                isDone[i] = 1'b1;
            end
        end
    end
end


//Main register assign logic
integer a,b;
always @(posedge clk) begin
    if(rst | Flush) begin
        for(a=0;a<`RS_MEM_DEPTH;a=a+1) begin
            RS_Mem[a] <= 0;
        end
    end
    else if(~Stall) begin
        for(b=0;b<`RS_MEM_DEPTH;b=b+1) begin
            RS_Mem[b] <= RS_Mem_next_collapsed[b];
        end
    end
end


/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Internal status wires
wire Entry_Valid[0:`RS_MEM_DEPTH-1];        //1=>RS Entry is Valid
wire Entry_Ready[0:`RS_MEM_DEPTH-1];        //1=>RS Entry is Ready to be issued
genvar gs;
generate
    for(gs=0; gs<`RS_MEM_DEPTH; gs=gs+1) begin
        assign Entry_Valid[gs] = RS_Mem[gs][`RS_VALID];
        assign Entry_Ready[gs] = Entry_Valid[gs] & RS_Mem[gs][`RS_PRS1_RDY] & RS_Mem[gs][`RS_PRS2_RDY];
    end
endgenerate

//Check Whether Previous Entry is valid
reg Entry_PrevReady[0:`RS_MEM_ISSUE_REQ-1];    //1=>All Previous RS Entries are Ready to be issued
integer pr;
always @(*) begin
    Entry_PrevReady[0] = 1'b1;
    for(pr=1; pr<`RS_MEM_ISSUE_REQ; pr=pr+1) begin
        Entry_PrevReady[pr] = Entry_PrevReady[pr-1] & Entry_Ready[pr];
    end
end

//RS Entry Issue Request Logic (strictly ordered dispatch)
//Oldest Instruction (lower index) has higher priority for issue request
//e.g. If RS_MEM_ISSUE_REQ is 2 i.e. 2 entry can be requested then
//      1. If Entry 0 is ready => entry 0 can be requested
//      2. If Entry 1 is ready but entry 0 is not => entry 1 can not be requested
//      3. If both 0 & 1 entries are ready => both can be requested
reg [`RS_MEM_LEN-1:0]               IssueReq_Entries[0:`RS_MEM_ISSUE_REQ-1];    //
reg [`RS_MEM_ISSUE_REQ-1:0]         IssueReq_Valid;                             //i=1 => ith issue request port output is valid
integer sc;
always @* begin
    for(sc=0; sc<`RS_MEM_ISSUE_REQ; sc=sc+1) begin
        IssueReq_Valid[sc]   = Entry_Ready[sc] & Entry_PrevReady[sc];
        IssueReq_Entries[sc] = RS_Mem[sc];
        IssueReq_Id[sc]      = sc;
    end
end
//pack issue request outputs into merged wires
genvar gr;
generate
    for(gr=0; gr<`RS_MEM_ISSUE_REQ; gr=gr+1) begin
        assign RSMEM_IssueReq_Entries[gr*`RS_MEM_LEN+:`RS_MEM_LEN] = IssueReq_Entries[gr];
    end
    assign RSMEM_IssueReq_Valid = IssueReq_Valid;
endgenerate


//RS Free Space Output
//Free Space output is conservative. It doesnot consideres RS Entries that
//will get freed due to killing or issue.
integer of;
always @* begin
    RSMEM_FreeEntries = 0;
    for(of=0; of<`RS_MEM_DEPTH; of=of+1) begin
        RSMEM_FreeEntries = RSMEM_FreeEntries + (!Entry_Valid[of]);
    end
end

`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;
    `ifdef DEBUG_RSMEM
        always@(negedge clk) begin
            `ifdef DEBUG_RSMEM_ENTRY
                for(Di=0; Di<`RS_MEM_DEPTH; Di=Di+1) begin
                    $display("[%t] RS_MEM@ENT%-2d: PC=%h | Will: Valid=%b Kill=%b WasIssued=%b prs1_rdy=%b prs2_rdy=%b | Issue: Rdy=%b, Reqed=%b", $time, Di,
                        RS_Mem_next[Di][`RS_PC], RS_Mem_next[Di][`RS_VALID], Willbe_Killed[Di], Was_Issued[Di],
                        RS_Mem_next[Di][`RS_PRS1_RDY], RS_Mem_next[Di][`RS_PRS2_RDY],
                        Entry_Ready[Di], (Di<2 ? Entry_Ready[Di] : 1'b0));
                end
            `endif
            for(Di=0; Di<`RS_MEM_ISSUE_REQ; Di=Di+1) begin
                if(IssueReq_Valid[Di]) begin
                    $display("[%t] RS_MEM@REQ%-2d: PC=%h ROB=%0d V=%b | ReqID=%0d", $time, Di,
                        IssueReq_Entries[Di][`RS_PC], IssueReq_Entries[Di][`RS_ROBIDX], IssueReq_Valid[Di], IssueReq_Id[Di]);
                end
            end
        end
    `endif
`endif

endmodule

