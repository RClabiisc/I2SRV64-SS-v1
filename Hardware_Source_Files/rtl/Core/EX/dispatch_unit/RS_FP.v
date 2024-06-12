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
module RS_FP
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
    input  wire [(`DISPATCH_RATE*`RS_FPU_LEN)-1:0]              RSFP_WrDataIn,
    input  wire [`DISPATCH_RATE-1:0]                            RSFP_WrValid,

    //Input for issue request confirmation
    input  wire [`RS_FP_ISSUE_REQ-1:0]                          RSFP_Issued_Valid,      //i=1 => ith issue request confirmation is valid

    //Inputs for Wakeup
    input  wire [(`SCHED_PORTS*`WAKEUP_RESP_LEN)-1:0]           WakeupResponses,        //Wakeup Response Bus

    //Outputs related to space
    output reg  [$clog2(`RS_FP_DEPTH):0]                        RSFP_FreeEntries,       //Available Free Entries in RS

    //Outputs for issue request
    output wire [(`RS_FP_ISSUE_REQ*`RS_FPU_LEN)-1:0]            RSFP_IssueReq_Entries,  //Entries requested for issue
    output wire [`RS_FP_ISSUE_REQ-1:0]                          RSFP_IssueReq_Valid     //i=1 => ith request for issue is valid

);

localparam RS_FP_DEPTH_LEN = $clog2(`RS_FP_DEPTH);

//separate merged Write Data input wires
wire [`RS_FPU_LEN-1:0] WriteDataIn[0:`DISPATCH_RATE-1];
genvar gid;
generate
    for(gid=0; gid<`DISPATCH_RATE;gid=gid+1) begin
        assign WriteDataIn[gid] = RSFP_WrDataIn[gid*`RS_FPU_LEN+:`RS_FPU_LEN];
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
reg  [`RS_FPU_LEN-1:0] RS_Fp[0:`RS_FP_DEPTH-1];

/////////////////////////////////////////////////////////////////////////////////////////////////////////
//wires for updateing status of entries in RS
wire                            Willbe_Killed[0:`RS_FP_DEPTH-1];
wire [`SCHED_PORTS-1:0]         Wakeup_PRS1_tag_match[0:`RS_FP_DEPTH-1];
wire [`SCHED_PORTS-1:0]         Wakeup_PRS2_tag_match[0:`RS_FP_DEPTH-1];
wire [`SCHED_PORTS-1:0]         Wakeup_PRS3_tag_match[0:`RS_FP_DEPTH-1];
wire                            Willbe_PRS1_Ready[0:`RS_FP_DEPTH-1];
wire                            Willbe_PRS2_Ready[0:`RS_FP_DEPTH-1];
wire                            Willbe_PRS3_Ready[0:`RS_FP_DEPTH-1];
wire [`RS_FP_ISSUE_REQ-1:0]     WasIssued_id_match[0:`RS_FP_DEPTH-1];
wire                            Was_Issued[0:`RS_FP_DEPTH-1];
reg [RS_FP_DEPTH_LEN-1:0]       IssueReq_Id[0:`RS_FP_ISSUE_REQ-1];         //Index of RS Entry Requested for issue

genvar ge,gw,gi;
generate
    for(ge=0; ge<`RS_FP_DEPTH; ge=ge+1) begin
        //Check if Entry will be killed
        assign Willbe_Killed[ge] = RS_Fp[ge][`RS_VALID] & Kill_Enable & |(FUBR_SpecTag & RS_Fp[ge][`RS_KILLMASK]);

        //check if wakeup response will make operands ready
        for(gw=0; gw<`SCHED_PORTS; gw=gw+1) begin
            assign Wakeup_PRS1_tag_match[ge][gw] = RS_Fp[ge][`RS_VALID] & WakeupResp_Valid[gw] &
                (WakeupResp_PrdType[gw]==RS_Fp[ge][`RS_RS1_TYPE]) & (WakeupResp_Prd[gw]==RS_Fp[ge][`RS_PRS1]);
            assign Wakeup_PRS2_tag_match[ge][gw] = RS_Fp[ge][`RS_VALID] & WakeupResp_Valid[gw] &
                (WakeupResp_PrdType[gw]==RS_Fp[ge][`RS_RS2_TYPE]) & (WakeupResp_Prd[gw]==RS_Fp[ge][`RS_PRS2]);
            assign Wakeup_PRS3_tag_match[ge][gw] = RS_Fp[ge][`RS_VALID] & WakeupResp_Valid[gw] &
                (WakeupResp_PrdType[gw]==`REG_TYPE_FP) &
                (WakeupResp_Prd[gw][`FP_PRF_LEN-1:0]==RS_Fp[ge][`RS_FPU_PRS3]);
        end
        assign Willbe_PRS1_Ready[ge] = |Wakeup_PRS1_tag_match[ge];
        assign Willbe_PRS2_Ready[ge] = |Wakeup_PRS2_tag_match[ge];
        assign Willbe_PRS3_Ready[ge] = |Wakeup_PRS3_tag_match[ge];

        //check if Entry was requested for issue and request was confirmed
        //i.e. Entry was issed, now to be invalidate
        for(gi=0; gi<`RS_FP_ISSUE_REQ; gi=gi+1) begin
            assign WasIssued_id_match[ge][gi] = RSFP_Issued_Valid[gi] & (IssueReq_Id[gi]==ge);
        end
        assign Was_Issued[ge] = |WasIssued_id_match[ge];
    end
endgenerate


//wires for RS Entries to be written after killing, issue confirmation,
//operand ready and appending inputs. Killed/issued entries will be bubbles
wire [`RS_FPU_LEN-1:0] RS_Fp_next[0:(`RS_FP_DEPTH+`DISPATCH_RATE)-1];
genvar gn,gm;
generate
    for(gn=0; gn<`RS_FP_DEPTH; gn=gn+1) begin
        assign RS_Fp_next[gn][`RS_VALID]    = (Willbe_Killed[gn] | Was_Issued[gn]) ? 1'b0 : RS_Fp[gn][`RS_VALID];
        assign RS_Fp_next[gn][`RS_PRS1_RDY] = (Willbe_PRS1_Ready[gn]) ? 1'b1 : RS_Fp[gn][`RS_PRS1_RDY];
        assign RS_Fp_next[gn][`RS_PRS2_RDY] = (Willbe_PRS2_Ready[gn]) ? 1'b1 : RS_Fp[gn][`RS_PRS2_RDY];
        assign RS_Fp_next[gn][`RS_PRS3_RDY] = (Willbe_PRS3_Ready[gn]) ? 1'b1 : RS_Fp[gn][`RS_PRS3_RDY];
        assign RS_Fp_next[gn][`RS_KILLMASK] = Update_KillMask ? (RS_Fp[gn][`RS_KILLMASK] & ~FUBR_SpecTag) : RS_Fp[gn][`RS_KILLMASK];

        //copy remaining data as it is
        assign RS_Fp_next[gn][`RS_FPU_LEN-1:`RS_TAG_LEN] = RS_Fp[gn][`RS_FPU_LEN-1:`RS_TAG_LEN];
    end

    //append dispatched entries
    for(gm=0; gm<`DISPATCH_RATE; gm=gm+1) begin
        assign RS_Fp_next[`RS_FP_DEPTH+gm][`RS_VALID] = WriteDataIn[gm][`RS_VALID] & RSFP_WrValid[gm];
        assign RS_Fp_next[`RS_FP_DEPTH+gm][`RS_FPU_LEN-1:`RS_VALID__BIT+1] = WriteDataIn[gm][`RS_FPU_LEN-1:`RS_VALID__BIT+1];
    end
endgenerate


//Main Collapsible Queue Logic
//invalid entries in RS are removed, entried after that are shifted and new
//data is appended.
reg  [`RS_FPU_LEN-1:0]                  RS_Fp_next_collapsed[0:`RS_FP_DEPTH-1];  //Next RS Fp Values without bubbles (collapsed)
reg  [`RS_FP_DEPTH+`DISPATCH_RATE-1:0]  isUsed;
reg  [`RS_FP_DEPTH-1:0]                 isDone;
integer i,j;
always @* begin
    isDone = 0;
    isUsed = 0;

    for(i=0; i<`RS_FP_DEPTH; i=i+1) begin
        RS_Fp_next_collapsed[i] = 0;
        for(j=i; j<(`RS_FP_DEPTH+`DISPATCH_RATE);j=j+1) begin
            if(RS_Fp_next[j][`RS_VALID]==1'b1 && isUsed[j]==1'b0 && isDone[i]==1'b0) begin
                RS_Fp_next_collapsed[i] = RS_Fp_next[j];
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
        for(a=0;a<`RS_FP_DEPTH;a=a+1) begin
            RS_Fp[a] <= 0;
        end
    end
    else if(~Stall) begin
        for(b=0;b<`RS_FP_DEPTH;b=b+1) begin
            RS_Fp[b] <= RS_Fp_next_collapsed[b];
        end
    end
end


/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Internal status wires
wire Entry_Valid[0:`RS_FP_DEPTH-1];        //1=>RS Entry is Valid
wire Entry_Ready[0:`RS_FP_DEPTH-1];        //1=>RS Entry is Ready to be issued

genvar gs;
generate
    for(gs=0; gs<`RS_FP_DEPTH; gs=gs+1) begin
        assign Entry_Valid[gs] = RS_Fp[gs][`RS_VALID];
        assign Entry_Ready[gs] = Entry_Valid[gs] & RS_Fp[gs][`RS_PRS1_RDY] & RS_Fp[gs][`RS_PRS2_RDY] & RS_Fp[gs][`RS_PRS3_RDY];
    end
endgenerate


//RS Entry Issue Request Logic
//Oldest Instruction (lower index) has higher priority for issue request
reg                                 Entry_Requested[0:`RS_FP_WINDOW];           //1=>RS Entry is requested for issue
reg [`RS_FPU_LEN-1:0]               IssueReq_Entries[0:`RS_FP_ISSUE_REQ-1];     //
reg [`RS_FP_ISSUE_REQ-1:0]          IssueReq_Valid;                             //i=1 => ith issue request port output is valid
integer s,t,sc;
always @* begin
    for(sc=0; sc<`RS_FP_ISSUE_REQ; sc=sc+1) begin
        IssueReq_Valid[sc]   = 0;
        IssueReq_Entries[sc] = 0;
        IssueReq_Id[sc]      = 0;
    end

    for(s=0; s<`RS_FP_WINDOW; s=s+1) begin
        Entry_Requested[s] = 0;
        for(t=0;t<`RS_FP_ISSUE_REQ;t=t+1) begin  //find appropriate issue request port
            if(Entry_Ready[s]==1'b1 && IssueReq_Valid[t]==1'b0 && Entry_Requested[s]==1'b0) begin
                Entry_Requested[s]  = 1'b1;     //Mark that this RS entry is requested for issue
                IssueReq_Valid[t]   = 1'b1;     //Mark that t th issue request port is used
                IssueReq_Entries[t] = RS_Fp[s];//assign RS Entry
                IssueReq_Id[t]      = s;        //Asign RS Entry Id (index)
            end
        end
    end
end
//pack issue request outputs into merged wires
genvar gr;
generate
    for(gr=0; gr<`RS_FP_ISSUE_REQ; gr=gr+1) begin
        assign RSFP_IssueReq_Entries[gr*`RS_FPU_LEN+:`RS_FPU_LEN] = IssueReq_Entries[gr];
    end
    assign RSFP_IssueReq_Valid = IssueReq_Valid;
endgenerate


//RS Free Space Output
//Free Space output is conservative. It doesnot consideres RS Entries that
//will get freed due to killing or issue.
integer of;
always @* begin
    RSFP_FreeEntries = 0;
    for(of=0; of<`RS_FP_DEPTH; of=of+1) begin
        RSFP_FreeEntries = RSFP_FreeEntries + (!Entry_Valid[of]);
    end
end

`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;
    `ifdef DEBUG_RSFP
        always@(negedge clk) begin
            `ifdef DEBUG_RSFP_ENTRY
                for(Di=0; Di<`RS_FP_DEPTH; Di=Di+1) begin
                    $display("[%t] RS_FP_@ENT%-2d: PC=%h | Will: Valid=%b Kill=%b WasIssued=%b prs1_rdy=%b prs2_rdy=%b prs3_rdy=%b | Issue: Rdy=%b, Reqed=%b", $time, Di,
                        RS_Fp_next[Di][`RS_PC], RS_Fp_next[Di][`RS_VALID], Willbe_Killed[Di], Was_Issued[Di],
                        RS_Fp_next[Di][`RS_PRS1_RDY], RS_Fp_next[Di][`RS_PRS2_RDY], RS_Fp_next[Di][`RS_PRS3_RDY],
                        Entry_Ready[Di], Entry_Requested[Di]);
                end
            `endif

            for(Di=0; Di<`RS_FP_ISSUE_REQ; Di=Di+1) begin
                if(IssueReq_Valid[Di]) begin
                    $display("[%t] RS_FP_@REQ%-2d: PC=%h ROB=%0d V=%b | ReqID=%0d", $time, Di,
                        IssueReq_Entries[Di][`RS_PC], IssueReq_Entries[Di][`RS_ROBIDX], IssueReq_Valid[Di], IssueReq_Id[Di]);
                end
            end
        end
    `endif
`endif

endmodule

