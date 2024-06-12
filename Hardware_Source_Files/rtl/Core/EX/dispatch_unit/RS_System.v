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
module RS_System
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
    input  wire [`RS_SYS_LEN-1:0]                               RSSYS_WrDataIn,
    input  wire                                                 RSSYS_WrValid,

    //Input for issue request confirmation
    input  wire                                                 RSSYS_Issued_Valid,      //1 => issue request confirmation is valid

    //Inputs for Wakeup
    input  wire [(`SCHED_PORTS*`WAKEUP_RESP_LEN)-1:0]           WakeupResponses,        //Wakeup Response Bus

    //Outputs related to space
    output wire                                                 RSSYS_FreeEntries,       //Available Free Entries in RS

    //Outputs for issue request
    output wire [`RS_SYS_LEN-1:0]                               RSSYS_IssueReq_Entries,  //Entries requested for issue
    output wire                                                 RSSYS_IssueReq_Valid     //i=1 => ith request for issue is valid

);

//separate merged Write Data input wires
wire [`RS_SYS_LEN-1:0]  WriteDataIn = RSSYS_WrDataIn;

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


//register for Reservation Stations
reg  [`RS_SYS_LEN-1:0] RS_Sys;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//wires for updateing status of entries in RS
wire                            Willbe_Killed;
wire [`SCHED_PORTS-1:0]         Wakeup_PRS1_tag_match;
wire [`SCHED_PORTS-1:0]         Wakeup_PRS2_tag_match;
wire                            Willbe_PRS1_Ready;
wire                            Willbe_PRS2_Ready;
wire                            Was_Issued;

genvar gw;
//Check if Entry will be killed
assign Willbe_Killed = RS_Sys[`RS_VALID] & Kill_Enable & |(FUBR_SpecTag & RS_Sys[`RS_KILLMASK]);

//check if wakeup response will make operands ready
generate
    for(gw=0; gw<`SCHED_PORTS; gw=gw+1) begin
        assign Wakeup_PRS1_tag_match[gw] = RS_Sys[`RS_VALID] & WakeupResp_Valid[gw] &
            (WakeupResp_PrdType[gw]==RS_Sys[`RS_RS1_TYPE]) & (WakeupResp_Prd[gw]==RS_Sys[`RS_PRS1]);
        assign Wakeup_PRS2_tag_match[gw] = RS_Sys[`RS_VALID] & WakeupResp_Valid[gw] &
            (WakeupResp_PrdType[gw]==RS_Sys[`RS_RS2_TYPE]) & (WakeupResp_Prd[gw]==RS_Sys[`RS_PRS2]);
    end
endgenerate
assign Willbe_PRS1_Ready = |Wakeup_PRS1_tag_match;
assign Willbe_PRS2_Ready = |Wakeup_PRS2_tag_match;

//check if Entry was requested for issue and request was confirmed
//i.e. Entry was issed, now to be invalidate
assign Was_Issued = RSSYS_Issued_Valid;


//wires for RS Entries to be written after killing, issue confirmation,
//operand ready and appending inputs. Killed/issued entries will be bubbles
wire [`RS_SYS_LEN-1:0] RS_Sys_next[0:1];
assign RS_Sys_next[0][`RS_VALID]    = (Willbe_Killed | Was_Issued) ? 1'b0 : RS_Sys[`RS_VALID];
assign RS_Sys_next[0][`RS_PRS1_RDY] = (Willbe_PRS1_Ready) ? 1'b1 : RS_Sys[`RS_PRS1_RDY];
assign RS_Sys_next[0][`RS_PRS2_RDY] = (Willbe_PRS2_Ready) ? 1'b1 : RS_Sys[`RS_PRS2_RDY];
assign RS_Sys_next[0][`RS_KILLMASK] = Update_KillMask ? (RS_Sys[`RS_KILLMASK] & ~FUBR_SpecTag) : RS_Sys[`RS_KILLMASK];

//copy remaining data as it is
assign RS_Sys_next[0][`RS_PRS3_RDY]              = RS_Sys[`RS_PRS3_RDY];
assign RS_Sys_next[0][`RS_SYS_LEN-1:`RS_TAG_LEN] = RS_Sys[`RS_SYS_LEN-1:`RS_TAG_LEN];

//append dispatched entries
assign RS_Sys_next[1][`RS_VALID]                      = WriteDataIn[`RS_VALID] & RSSYS_WrValid;
assign RS_Sys_next[1][`RS_SYS_LEN-1:`RS_VALID__BIT+1] = WriteDataIn[`RS_SYS_LEN-1:`RS_VALID__BIT+1];


//Main Collapsible Queue Logic
//invalid entries in RS are removed, entried after that are shifted and new
//data is appended.
reg  [`RS_SYS_LEN-1:0]  RS_Sys_next_collapsed;  //Next RS Sys Values without bubbles (collapsed)
reg                     isDone;
integer j;
always @* begin
    isDone = 0;
    RS_Sys_next_collapsed = 0;
    for(j=0; j<2;j=j+1) begin
        if(RS_Sys_next[j][`RS_VALID]==1'b1 && isDone==1'b0) begin
            RS_Sys_next_collapsed = RS_Sys_next[j];
            isDone = 1'b1;
        end
    end
end


//Main register assign logic
always @(posedge clk) begin
    if(rst | Flush) begin
        RS_Sys <= 0;
    end
    else if(~Stall) begin
        RS_Sys <= RS_Sys_next_collapsed;
    end
end


/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Internal status wires
wire Entry_Valid;        //1=>RS Entry is Valid
wire Entry_Ready;        //1=>RS Entry is Ready to be issued
assign Entry_Valid = RS_Sys[`RS_VALID];
assign Entry_Ready = Entry_Valid & RS_Sys[`RS_PRS1_RDY] & RS_Sys[`RS_PRS2_RDY];


//RS Entry Issue Request Logic
//Oldest Instruction (lower index) has higher priority for issue request
//For System Reservation Station is strictly ordered.
assign RSSYS_IssueReq_Entries = RS_Sys;
assign RSSYS_IssueReq_Valid   = Entry_Ready;


//RS Free Space Output
//Free Space output is conservative. It doesnot consideres RS Entries that
//will get freed due to killing or issue.
assign RSSYS_FreeEntries = ~Entry_Valid;

`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;
    `ifdef DEBUG_RSSYS
        always@(negedge clk) begin
            `ifdef DEBUG_RSSYS_ENTRY
                $display("[%t] RS_SYS@ENT 0: PC=%h | Will: Valid=%b Kill=%b WasIssued=%b prs1_rdy=%b prs2_rdy=%b | Issue: Rdy=%b, Reqed=%b", $time,
                    RS_Sys_next[0][`RS_PC], RS_Sys_next[0][`RS_VALID], Willbe_Killed, Was_Issued,
                    RS_Sys_next[0][`RS_PRS1_RDY], RS_Sys_next[0][`RS_PRS2_RDY],
                    Entry_Ready, Entry_Ready);
            `endif
            if(RSSYS_IssueReq_Valid) begin
                $display("[%t] RS_SYS@REQ 0: PC=%h ROB=%0d V=%b | ReqID=%0d", $time,
                    RSSYS_IssueReq_Entries[`RS_PC], RSSYS_IssueReq_Entries[`RS_ROBIDX], RSSYS_IssueReq_Valid, 0);
            end
        end
    `endif
`endif

endmodule

