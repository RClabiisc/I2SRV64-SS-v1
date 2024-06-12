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
module RS_Branch
(
    input  wire clk,
    input  wire rst,

    input  wire Stall,
    input  wire Flush,

    //Inputs related to killing entries
    input  wire                                                 Kill_Enable,            //1=>branch mispredicted => kill instructions
    input  wire                                                 Update_KillMask,        //1=>Update KillMask on Branch Correct Prediction
    input  wire [`SPEC_STATES-1:0]                              FUBR_SpecTag,           //Spectag of branch which mispredicted

    //Inputs for adding uops to RS
    input  wire [(`DISPATCH_RATE*`RS_BR_LEN)-1:0]               RSBR_WrDataIn,
    input  wire [`DISPATCH_RATE-1:0]                            RSBR_WrValid,

    //Input for issue request confirmation
    input  wire                                                 RSBR_Issued_Valid,      //1 => issue request confirmation is valid

    //Inputs for Wakeup
    input  wire [(`SCHED_PORTS*`WAKEUP_RESP_LEN)-1:0]           WakeupResponses,        //Wakeup Response Bus

    //Outputs related to space
    output reg  [$clog2(`RS_BR_DEPTH):0]                        RSBR_FreeEntries,       //Available Free Entries in RS

    //Outputs for issue request
    output wire [`RS_BR_LEN-1:0]                                RSBR_IssueReq_Entries,  //Entries requested for issue
    output wire                                                 RSBR_IssueReq_Valid     //i=1 => ith request for issue is valid

);

localparam RS_BR_DEPTH_LEN = $clog2(`RS_BR_DEPTH);

//separate merged Write Data input wires
wire [`RS_BR_LEN-1:0] WriteDataIn[0:`DISPATCH_RATE-1];
genvar gid;
generate
    for(gid=0; gid<`DISPATCH_RATE;gid=gid+1) begin
        assign WriteDataIn[gid] = RSBR_WrDataIn[gid*`RS_BR_LEN+:`RS_BR_LEN];
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
reg  [`RS_BR_LEN-1:0] RS_Br[0:`RS_BR_DEPTH-1];

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//wires for updateing status of entries in RS
wire                            Willbe_Killed[0:`RS_BR_DEPTH-1];
wire [`SCHED_PORTS-1:0]         Wakeup_PRS1_tag_match[0:`RS_BR_DEPTH-1];
wire [`SCHED_PORTS-1:0]         Wakeup_PRS2_tag_match[0:`RS_BR_DEPTH-1];
wire                            Willbe_PRS1_Ready[0:`RS_BR_DEPTH-1];
wire                            Willbe_PRS2_Ready[0:`RS_BR_DEPTH-1];
wire                            Was_Issued[0:`RS_BR_DEPTH-1];

genvar ge,gw,gi;
generate
    for(ge=0; ge<`RS_BR_DEPTH; ge=ge+1) begin
        //Check if Entry will be killed
        assign Willbe_Killed[ge] = RS_Br[ge][`RS_VALID] & Kill_Enable & |(FUBR_SpecTag & RS_Br[ge][`RS_KILLMASK]);

        //check if wakeup response will make operands ready
        for(gw=0; gw<`SCHED_PORTS; gw=gw+1) begin
            assign Wakeup_PRS1_tag_match[ge][gw] = RS_Br[ge][`RS_VALID] & WakeupResp_Valid[gw] &
                (WakeupResp_PrdType[gw]==RS_Br[ge][`RS_RS1_TYPE]) & (WakeupResp_Prd[gw]==RS_Br[ge][`RS_PRS1]);
            assign Wakeup_PRS2_tag_match[ge][gw] = RS_Br[ge][`RS_VALID] & WakeupResp_Valid[gw] &
                (WakeupResp_PrdType[gw]==RS_Br[ge][`RS_RS2_TYPE]) & (WakeupResp_Prd[gw]==RS_Br[ge][`RS_PRS2]);
        end
        assign Willbe_PRS1_Ready[ge] = |Wakeup_PRS1_tag_match[ge];
        assign Willbe_PRS2_Ready[ge] = |Wakeup_PRS2_tag_match[ge];

        //check if Entry was requested for issue and request was confirmed
        //i.e. Entry was issed, now to be invalidate
        assign Was_Issued[ge] = RSBR_Issued_Valid & (ge==0);
    end
endgenerate


//wires for RS Entries to be written after killing, issue confirmation,
//operand ready and appending inputs. Killed/issued entries will be bubbles
wire [`RS_BR_LEN-1:0] RS_Br_next[0:(`RS_BR_DEPTH+`DISPATCH_RATE)-1];
genvar gn,gm;
generate
    for(gn=0; gn<`RS_BR_DEPTH; gn=gn+1) begin
        assign RS_Br_next[gn][`RS_VALID]    = (Willbe_Killed[gn] | Was_Issued[gn]) ? 1'b0 : RS_Br[gn][`RS_VALID];
        assign RS_Br_next[gn][`RS_PRS1_RDY] = (Willbe_PRS1_Ready[gn]) ? 1'b1 : RS_Br[gn][`RS_PRS1_RDY];
        assign RS_Br_next[gn][`RS_PRS2_RDY] = (Willbe_PRS2_Ready[gn]) ? 1'b1 : RS_Br[gn][`RS_PRS2_RDY];
        assign RS_Br_next[gn][`RS_KILLMASK] = Update_KillMask ? (RS_Br[gn][`RS_KILLMASK] & ~FUBR_SpecTag) : RS_Br[gn][`RS_KILLMASK];

        //copy remaining data as it is
        assign RS_Br_next[gn][`RS_PRS3_RDY]             = RS_Br[gn][`RS_PRS3_RDY];
        assign RS_Br_next[gn][`RS_BR_LEN-1:`RS_TAG_LEN] = RS_Br[gn][`RS_BR_LEN-1:`RS_TAG_LEN];
    end

    //append dispatched entries
    for(gm=0; gm<`DISPATCH_RATE; gm=gm+1) begin
        assign RS_Br_next[`RS_BR_DEPTH+gm][`RS_VALID] = WriteDataIn[gm][`RS_VALID] & RSBR_WrValid[gm];
        assign RS_Br_next[`RS_BR_DEPTH+gm][`RS_BR_LEN-1:`RS_VALID__BIT+1] = WriteDataIn[gm][`RS_BR_LEN-1:`RS_VALID__BIT+1];
    end
endgenerate


//Main Collapsible Queue Logic
//invalid entries in RS are removed, entried after that are shifted and new
//data is appended.
reg  [`RS_BR_LEN-1:0]                   RS_Br_next_collapsed[0:`RS_BR_DEPTH-1];  //Next RS Br Values without bubbles (collapsed)
reg  [`RS_BR_DEPTH+`DISPATCH_RATE-1:0]  isUsed;
reg  [`RS_BR_DEPTH-1:0]                 isDone;
integer i,j;
always @* begin
    isDone = 0;
    isUsed = 0;

    for(i=0; i<`RS_BR_DEPTH; i=i+1) begin
        RS_Br_next_collapsed[i] = 0;
        for(j=i; j<(`RS_BR_DEPTH+`DISPATCH_RATE);j=j+1) begin
            if(RS_Br_next[j][`RS_VALID]==1'b1 && isUsed[j]==1'b0 && isDone[i]==1'b0) begin
                RS_Br_next_collapsed[i] = RS_Br_next[j];
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
        for(a=0;a<`RS_BR_DEPTH;a=a+1) begin
            RS_Br[a] <= 0;
        end
    end
    else if(~Stall) begin
        for(b=0;b<`RS_BR_DEPTH;b=b+1) begin
            RS_Br[b] <= RS_Br_next_collapsed[b];
        end
    end
end


/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Internal status wires
wire Entry_Valid[0:`RS_BR_DEPTH-1];        //1=>RS Entry is Valid
wire Entry_Ready[0:`RS_BR_DEPTH-1];        //1=>RS Entry is Ready to be issued

genvar gs;
generate
    for(gs=0; gs<`RS_BR_DEPTH; gs=gs+1) begin
        assign Entry_Valid[gs] = RS_Br[gs][`RS_VALID];
        assign Entry_Ready[gs] = Entry_Valid[gs] & RS_Br[gs][`RS_PRS1_RDY] & RS_Br[gs][`RS_PRS2_RDY];
    end
endgenerate


//RS Entry Issue Request Logic
//Oldest Instruction (lower index) has higher priority for issue request
//For Branch Reservation Stations are strictly ordered.
assign RSBR_IssueReq_Entries = RS_Br[0];
assign RSBR_IssueReq_Valid = Entry_Ready[0];


//RS Free Space Output
//Free Space output is conservative. It doesnot consideres RS Entries that
//will get freed due to killing or issue.
integer of;
always @* begin
    RSBR_FreeEntries = 0;
    for(of=0; of<`RS_BR_DEPTH; of=of+1) begin
        RSBR_FreeEntries = RSBR_FreeEntries + (!Entry_Valid[of]);
    end
end

`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;
    `ifdef DEBUG_RSBR
        always@(negedge clk) begin
            `ifdef DEBUG_RSBR_ENTRY
                for(Di=0; Di<`RS_BR_DEPTH; Di=Di+1) begin
                    $display("[%t] RS_BR_@ENT%-2d: PC=%h | Will: Valid=%b Kill=%b WasIssued=%b prs1_rdy=%b prs2_rdy=%b | Issue: Rdy=%b Reqed=%b", $time, Di,
                        RS_Br_next[Di][`RS_PC], RS_Br_next[Di][`RS_VALID], Willbe_Killed[Di], Was_Issued[Di],
                        RS_Br_next[Di][`RS_PRS1_RDY], RS_Br_next[Di][`RS_PRS2_RDY],
                        Entry_Ready[Di], (Di==0 ? Entry_Ready[Di] : 1'b0));
                end
            `endif
            if(RSBR_IssueReq_Valid) begin
                $display("[%t] RS_BR_@REQ0 : PC=%h ROB=%0d V=%b | ReqID=%0d", $time,
                    RSBR_IssueReq_Entries[`RS_PC], RSBR_IssueReq_Entries[`RS_ROBIDX], RSBR_IssueReq_Valid, 0);
            end
        end
    `endif
`endif

endmodule

