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
module ROB
(
    input  wire clk,
    input  wire rst,

    input  wire Stall,      //1=>Stall ROB Writing. This will never stall ROB update from wakeup bus & retire unit
    input  wire Flush,      //1=>Flush The ROB

    //Dispatch Inputs
    input  wire [(`DISPATCH_RATE*`ROB_LEN)-1:0]             ROB_WrDataIn,               //Data to be written to ROB
    input  wire [`DISPATCH_RATE-1:0]                        ROB_WrValid,                //1=> ith write input data to ROB is Valid

    //Inputs related to killing entries
    input  wire [`FUBR_RESULT_LEN-1:0]                      FUBRresp,

    //Wakeup Port Inputs
    input  wire [(`SCHED_PORTS*`WAKEUP_RESP_LEN)-1:0]       WakeupResponses,            //Wakeup Responses from Execution Unit

    //Inputs from Retire Unit
    input  wire [$clog2(`RETIRE_RATE):0]                    RetireCnt,                  //no. of instr retired

    //Outputs for retire unit
    output wire [(`RETIRE_RATE*`ROB_LEN)-1:0]               ROB_ReadData,

    //Outputs related to space
    output wire [$clog2(`ROB_DEPTH):0]                      ROB_FreeEntries,
    output wire [$clog2(`ROB_DEPTH):0]                      ROB_UsedEntries,
    output wire [(`DISPATCH_RATE*$clog2(`ROB_DEPTH))-1:0]   ROB_Index

);

//function to add offset to ptr and wrap to ROB DEPTH
function [`ROB_DEPTH_LEN-1:0] WrapIndex(input [`ROB_DEPTH_LEN-1:0] ptr, input integer offset);
    reg [`ROB_DEPTH_LEN:0] AddIndex, FullIndex;
    begin
        AddIndex = {1'b0,ptr} + offset[`ROB_DEPTH_LEN:0];
        if(AddIndex >= `ROB_DEPTH)
            FullIndex = AddIndex - `ROB_DEPTH;
        else
            FullIndex = AddIndex;
        WrapIndex = FullIndex[`ROB_DEPTH_LEN-1:0];
    end
endfunction

//separate merged WriteData inputs to separate wires
wire [`ROB_LEN-1:0] WriteData[0:`DISPATCH_RATE-1];
genvar ggw;
generate
    for(ggw=0;ggw<`DISPATCH_RATE;ggw=ggw+1) begin
        assign WriteData[ggw] = ROB_WrDataIn[ggw*`ROB_LEN+:`ROB_LEN];
    end
endgenerate

//separate merged WakeupResponses inputs to separate wires
wire [`WAKEUP_RESP_LEN-1:0] WakeupResp          [0:`SCHED_PORTS-1];
wire                        WakeupResp_Valid    [0:`SCHED_PORTS-1];
wire [`ROB_DEPTH_LEN-1:0]   WakeupResp_ROBindex [0:`SCHED_PORTS-1];
wire                        WakeupResp_Exception[0:`SCHED_PORTS-1];
wire [`ECAUSE_LEN-1:0]      WakeupResp_Ecause   [0:`SCHED_PORTS-1];
wire [`METADATA_LEN-1:0]    WakeupResp_Metadata [0:`SCHED_PORTS-1];

genvar giw;
generate
    for(giw=0; giw<`SCHED_PORTS; giw=giw+1) begin
        assign WakeupResp[giw]           = WakeupResponses[giw*`WAKEUP_RESP_LEN+:`WAKEUP_RESP_LEN];
        assign WakeupResp_Valid[giw]     = WakeupResp[giw][`WAKEUP_RESP_VALID];
        assign WakeupResp_ROBindex[giw]  = WakeupResp[giw][`WAKEUP_RESP_ROB_INDEX];
        assign WakeupResp_Exception[giw] = WakeupResp[giw][`WAKEUP_RESP_EXCEPTION];
        assign WakeupResp_Ecause[giw]    = WakeupResp[giw][`WAKEUP_RESP_ECAUSE];
        assign WakeupResp_Metadata[giw]  = WakeupResp[giw][`WAKEUP_RESP_METADATA];
    end
endgenerate

//separate wires from Branch (Resolution) Unit
wire                        Branch_Mispredicted     = FUBRresp[`FUBR_RESULT_VALID] & FUBRresp[`FUBR_RESULT_MISPRED];
wire                        Update_KillMask         = FUBRresp[`FUBR_RESULT_VALID] & FUBRresp[`FUBR_RESULT_ISSPEC] & ~FUBRresp[`FUBR_RESULT_MISPRED];
wire [`SPEC_STATES-1:0]     Mispredicted_SpecTag    = FUBRresp[`FUBR_RESULT_SPECTAG];
wire [`ROB_DEPTH_LEN-1:0]   Mispredicted_ROBindex   = FUBRresp[`FUBR_RESULT_ROBIDX];


//2D Array of Registers for ROB
reg  [`ROB_LEN-1:0]          ROB[0:`ROB_DEPTH-1];
reg  [`ROB_DEPTH_LEN-1:0]    wr_ptr;    //Tail
reg  [`ROB_DEPTH_LEN-1:0]    rd_ptr;    //Head


//local wires for write count
reg [$clog2(`DISPATCH_RATE):0] wr_cnt;
integer wc;
always @* begin
    wr_cnt = 0;
    for(wc=0; wc<`DISPATCH_RATE; wc=wc+1)
        wr_cnt = wr_cnt + ROB_WrValid[wc];
end


/////////////////////////////////////////////////////////////////////////////////////////////////////////
//wires for updateing status of entries in ROB
wire                            Willbe_Killed[0:`ROB_DEPTH-1];
wire [`SCHED_PORTS-1:0]         Wakeup_tag_match[0:`ROB_DEPTH-1];
wire                            Willbe_Ready[0:`ROB_DEPTH-1];

genvar ge,gw;
generate
    for(ge=0; ge<`ROB_DEPTH; ge=ge+1) begin
        //Check if Entry will be killed
        assign Willbe_Killed[ge] = ROB[ge][`ROB_VALID] & Branch_Mispredicted & |(Mispredicted_SpecTag & ROB[ge][`ROB_KILLMASK]);

        //check if wakeup response will make operands ready
        for(gw=0; gw<`SCHED_PORTS; gw=gw+1) begin
            assign Wakeup_tag_match[ge][gw] = ROB[ge][`ROB_VALID] & WakeupResp_Valid[gw] & (WakeupResp_ROBindex[gw]==ge);
        end
        assign Willbe_Ready[ge] = |Wakeup_tag_match[ge];

    end
endgenerate

//ROB next data
reg [`ROB_LEN-1:0]          ROB_next[0:`ROB_DEPTH-1];

//indexed used to wrap ROB index when goes above DEPTH
reg  [`ROB_DEPTH_LEN:0]     wr_index, rd_entry_index;

integer n,d,rr,e;
always @* begin
    wr_index       = 0;
    rd_entry_index = 0;
    for(n=0; n<`ROB_DEPTH; n=n+1) begin
        //copy old data
        ROB_next[n] = ROB[n];

        //set invalid to killed entries
        ROB_next[n][`ROB_VALID] = Willbe_Killed[n] ? 1'b0 : ROB[n][`ROB_VALID];

        //Update KillMask (Clear the Not Mispredicted SpecTag)
        ROB_next[n][`ROB_KILLMASK] = Update_KillMask ? (ROB[n][`ROB_KILLMASK] & ~Mispredicted_SpecTag) : ROB[n][`ROB_KILLMASK];

        //set ready (busy=0) to entries woken up from wakeup bus
        ROB_next[n][`ROB_BUSY]  = Willbe_Ready[n] ? 1'b0 : ROB[n][`ROB_BUSY];

        //add exception from wakeup bus to ROB Entry if already exception is
        //not present (this happens when exception from decoder but IALU do
        //not generate any, in this case do not override decoder exception)
        for(e=0; e<`SCHED_PORTS; e=e+1) begin
            if(Wakeup_tag_match[n][e]==1'b1) begin
                ROB_next[n][`ROB_METADATA] = WakeupResp_Metadata[e];

                if(ROB[n][`ROB_EXCEPTION]==1'b0) begin
                    ROB_next[n][`ROB_EXCEPTION] = WakeupResp_Exception[e];
                    ROB_next[n][`ROB_ECAUSE]    = WakeupResp_Ecause[e];
                end
            end
        end
    end

    //set invalid to retired entries (this is for Safe Side only as rd_ptr
    //itself will be modified)
    for(rr=0; rr<`RETIRE_RATE; rr=rr+1) begin
        if(rr<RetireCnt) begin
            ROB_next[WrapIndex(rd_ptr,rr)][`ROB_VALID] = 1'b0;
        end
    end

    //add new data to be written if ROB is NOT stalled (stalled => Writing
    //stalled.
    for(d=0; d<`DISPATCH_RATE; d=d+1) begin
        if(ROB_WrValid[d]==1'b1 && ~Stall) begin
            ROB_next[WrapIndex(wr_ptr,d)] = WriteData[d];
        end
    end
end

//ROB Data Write Process
integer r;
always @(posedge clk) begin
    if(rst | Flush) begin
        for(r=0;r<`ROB_DEPTH; r=r+1)
            ROB[r]<=0;
    end
    else begin
        for(r=0; r<`ROB_DEPTH; r=r+1)
            ROB[r] <= ROB_next[r];
    end
end


//ROB Write Ptr process
reg  [`ROB_DEPTH_LEN-1:0]    wr_ptr_d;    //Tail next value
always @(*) begin
    if(Flush)
        wr_ptr_d = 0;
    else if(Branch_Mispredicted) //Branch Mispredicted
        wr_ptr_d = WrapIndex(Mispredicted_ROBindex,1);
    else if(~Stall)
        wr_ptr_d = WrapIndex(wr_ptr,wr_cnt);
    else
        wr_ptr_d = wr_ptr;
end

always @(posedge clk) begin
    if(rst)
        wr_ptr <= 0;
    else
        wr_ptr <= wr_ptr_d;
end



//ROB Read Ptr Process
reg  [`ROB_DEPTH_LEN-1:0]    rd_ptr_d;    //Head next value
always @(*) begin
    if(Flush)
        rd_ptr_d = 0;
    else
        rd_ptr_d = WrapIndex(rd_ptr,RetireCnt);
end

always @(posedge clk) begin
    if(rst)
        rd_ptr <= 0;
    else
        rd_ptr <= rd_ptr_d;
end


//ROB Data Read (for retire unit) Process
//If entry is being killed in same cycle, this killing will not be reflected
//at ReadData. So Override read data if being killed.
reg  [`ROB_LEN-1:0] ReadData[0:`RETIRE_RATE-1];
integer o;
always @* begin
    for(o=0; o<`RETIRE_RATE; o=o+1) begin
        ReadData[o] = ROB[WrapIndex(rd_ptr,o)];
        if(Branch_Mispredicted & |(Mispredicted_SpecTag & ReadData[o][`ROB_KILLMASK]))
            ReadData[o][`ROB_VALID] = 1'b0;
    end
end


//pack retire outputs
genvar gro;
generate
    for(gro=0; gro<`RETIRE_RATE; gro=gro+1) begin
        assign ROB_ReadData[gro*`ROB_LEN+:`ROB_LEN] = ReadData[gro];
    end
endgenerate


//generate used & free entry count from ptrs
assign ROB_UsedEntries = (wr_ptr<rd_ptr) ? (wr_ptr + `ROB_DEPTH - rd_ptr) : (wr_ptr - rd_ptr);
assign ROB_FreeEntries = `ROB_DEPTH - ROB_UsedEntries;

genvar goi;
wire [`ROB_DEPTH_LEN:0] wr_entry_index[0:`DISPATCH_RATE-1];
wire [`ROB_DEPTH_LEN:0] wr_entry_index_wrapped[0:`DISPATCH_RATE-1];
generate
    for(goi=0; goi<`DISPATCH_RATE; goi=goi+1) begin
        localparam [`ROB_DEPTH_LEN:0] idx = goi;
        assign wr_entry_index[goi]          = {1'b0,wr_ptr[`ROB_DEPTH_LEN-1:0]} + idx;
        assign wr_entry_index_wrapped[goi]  = (wr_entry_index[goi]>=`ROB_DEPTH) ? (wr_entry_index[goi]-`ROB_DEPTH) : wr_entry_index[goi];

        assign ROB_Index[goi*`ROB_DEPTH_LEN+:`ROB_DEPTH_LEN] = wr_entry_index_wrapped[goi][`ROB_DEPTH_LEN-1:0];
    end
endgenerate

`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;
    `ifdef DEBUG_ROB
        always @(negedge clk) begin
            if(Stall) begin
                $display("[%t] ROB___@STS##: Stall=%b", $time,
                    Stall);
            end
            else begin
                $display("[%t] ROB___@STS##: Free=%0d Used=%0d RetireCnt=%0d WrValid=%b WrPtr=%0d(%0d) RdPtr=%0d(%0d)",$time,
                    ROB_FreeEntries, ROB_UsedEntries, RetireCnt, ROB_WrValid, wr_ptr, (wr_ptr%`ROB_DEPTH), rd_ptr, (rd_ptr%`ROB_DEPTH));

                `ifdef DEBUG_ROB_ENTRY
                    for(Di=0; Di<`ROB_DEPTH; Di=Di+1) begin
                        $display("[%t] ROB___@ENT%-2d: PC=%h | Will: Valid=%b Killed=%b, Busy=%b", $time, Di,
                            ROB_next[Di][`ROB_PC], ROB_next[Di][`ROB_VALID], Willbe_Killed[Di], ROB_next[Di][`ROB_BUSY]);
                    end
                `endif
            end
        end
    `endif
`endif

endmodule

