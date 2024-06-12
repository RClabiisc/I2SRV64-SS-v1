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
module Decoder
(
    input  wire clk,
    input  wire rst,

    input  wire Stall,          //Stall Write Operation
    input  wire Flush,          //Flush Pipeline
    input  wire Spectag_Flush,  //Flush Spectag unit (on exception/branch mispred)

    //Inputs from IB
    input  wire [(`DECODE_RATE*`IB_ENTRY_LEN)-1:0]      IB_DataOut,         //IB Peek Data Input
    input  wire [`DECODE_RATE-1:0]                      IB_OutValid,

    //Input/Outputs from/to Backend control logic
    input  wire                                         PipelineNotEmpty,   //1 => Pipeline NOT empty
    input  wire                                         StallLockRelease,   //1 => Release Stall lock set by 'wait_till_retire'
    output reg                                          StallTillRetireLock,//1 => Decoder is stalled will a instruction retires

    //Inputs from SysCtl
    input  wire [`XSTATUS_FS_LEN-1:0]                   csr_status_fs,      //FS Bits from xstatus CSR

    //Inputs from Branch (Resolution) Unit
    input  wire [`FUBR_RESULT_LEN-1:0]                  FUBRresp,

    //IB Control Outputs
    output wire [$clog2(`DECODE_RATE):0]                IB_RdCnt,           //No. of instr to read from IB

    //Decoded Uops Outputs (registered with pipeline reg)
    output wire [(`RENAME_RATE*`UOP_LEN)-1:0]           Decoder_DataOut,    //Decoded uop Data
    output reg  [`RENAME_RATE-1:0]                      Decoder_OutValid,   //i=1 => Pipeline Register output is valid

    //Generic Outputs
    output wire [`SPEC_STATES-1:0]                      Spectag_Valid       //ith=1 => ith spec tag is speculative else not-speculative or unallocated
);

//local wire
wire Decoder_Stall;
wire Branch_Mispredicted = FUBRresp[`FUBR_RESULT_VALID] & FUBRresp[`FUBR_RESULT_MISPRED];
wire Update_KillMask     = FUBRresp[`FUBR_RESULT_VALID] & FUBRresp[`FUBR_RESULT_ISSPEC] & ~FUBRresp[`FUBR_RESULT_MISPRED];

//Speculative Tag Management Unit
wire [$clog2(`SPEC_STATES):0]               FreeSpectags;           //No. of available spec tags for allocation
wire [`DECODE_RATE-1:0]                     ToAlloc_SpectagValid;   //i=1 => ith Spectag Can be allocated else is invalid
reg  [`DECODE_RATE-1:0]                     Alloced_SpectagMask;    //1=>ith Spectag allocated
wire [(`DECODE_RATE*`SPEC_STATES)-1:0]      ToAlloc_Spectags;       //Current Spec Tag (Merged)  for allocation
wire [(`DECODE_RATE*`SPEC_STATES)-1:0]      ToAlloc_KillMasks;      //Current Kill Mask (Merged) for allocation

Spectag_Unit #(.SPECTAGS(`SPEC_STATES)) Spectag_Unit
(
    .clk                  ( clk                  ),
    .rst                  ( rst                  ),
    .Flush                ( Spectag_Flush        ),
    .Stall                ( Decoder_Stall        ),
    .Alloced_SpectagMask  ( Alloced_SpectagMask  ),
    .FUBRresp             ( FUBRresp             ),
    .FreeSpectags         ( FreeSpectags         ),
    .ToAlloc_SpectagValid ( ToAlloc_SpectagValid ),
    .ToAlloc_Spectags     ( ToAlloc_Spectags     ),
    .ToAlloc_KillMasks    ( ToAlloc_KillMasks    ),
    .Spectag_Valid        ( Spectag_Valid        )
);

//Generic RV64GC Decoder
wire [(`DECODE_RATE*`UOP_LEN)-1:0]  Uops;
wire [`DECODE_RATE-1:0]             AllocateNewSpectag;     //i=1 => "New" spectag needs to be allocated to next instr of i
wire [`DECODE_RATE-1:0]             AllocateLSorderTag;    //i=1 => Assign LS Ordering Tag to uop

RV64GC_Decoder RV64GC_Decoder
(
    .IB_DataOut         (IB_DataOut        ),
    .csr_status_fs      (csr_status_fs     ),
    .Uops               (Uops              ),
    .AllocateNewSpectag (AllocateNewSpectag),
    .AllocateLSorderTag (AllocateLSorderTag)
);


//separate merged Uops, spectags, killmask from merged
wire [`UOP_LEN-1:0]     decoded_uop[0:`DECODE_RATE-1];
wire [`SPEC_STATES-1:0] Spectag[0:`DECODE_RATE-1];              //extracted Spectag from merged Bus
wire [`SPEC_STATES-1:0] KillMask[0:`DECODE_RATE-1];             //extracted killmask from merged bus
genvar gi;
generate
    for(gi=0;gi<`DECODE_RATE;gi=gi+1) begin
        assign decoded_uop[gi] = Uops[(gi*`UOP_LEN)+:`UOP_LEN];
        assign Spectag[gi]     = ToAlloc_Spectags[(gi*`SPEC_STATES)+:`SPEC_STATES];
        assign KillMask[gi]    = ToAlloc_KillMasks[(gi*`SPEC_STATES)+:`SPEC_STATES];
    end
endgenerate


//uops ready to rename (writing to decode-rename pipeline)
//considering "IB Output Valid", "uop_valid","unique_instr" handling
reg                     Uop_IsReady[0:`DECODE_RATE-1];
wire [`DECODE_RATE-1:0] is_prev_wait_till_empty;
wire [`DECODE_RATE-1:0] is_wait_till_empty;
genvar gu,gv;
generate
    for(gv=0;gv<`DECODE_RATE; gv=gv+1) begin
        assign is_wait_till_empty[gv] = decoded_uop[gv][`UOP_WAIT_TILL_EMPTY] & decoded_uop[gv][`UOP_VALID] & IB_OutValid[gv];
    end
    assign is_prev_wait_till_empty[0] = 1'b0;
    for(gu=1;gu<`DECODE_RATE;gu=gu+1) begin
        assign is_prev_wait_till_empty[gu] = |is_wait_till_empty[gu:0];
    end
endgenerate

integer r;
always @* begin
    for(r=0; r<`DECODE_RATE; r=r+1) begin
        if(IB_OutValid[r] && decoded_uop[r][`UOP_VALID]) begin
            //if one of the previous instr was 'wait_till_empty' => stall => not ready
            //or Stall till retire lock is set => stall => not ready
            if(is_prev_wait_till_empty[r] || StallTillRetireLock)
                Uop_IsReady[r] = 1'b0;
            //if instr itself is 'wait_till_empty' and retire_unit/EX says PipelineNotEmpty
            //(ROB not empty, LSQ Not empty) => stall => not ready
            else if(is_wait_till_empty[r] && PipelineNotEmpty)
                Uop_IsReady[r] = 1'b0;
            else
                Uop_IsReady[r] = 1'b1;
        end
        else
            Uop_IsReady[r] = 1'b0;
    end
end


//Load/Store Ordering Tag Allocation
reg  [`LS_ORDER_TAG_LEN-1:0]    ls_order_tag;                       //Register to store current Ordering Tag
reg  [$clog2(`DECODE_RATE):0]   ls_tag_incr_cnt;                    //no. of ls ordering tags allocated
reg  [`LS_ORDER_TAG_LEN-1:0]    uop_LSorderTag[0:`DECODE_RATE-1];   //LS Ordering Tag to be allocated to ith uop
always @(posedge clk) begin
    if(rst | Spectag_Flush)
        ls_order_tag <= 0;
    else if(~Stall)
        ls_order_tag <= ls_order_tag + ls_tag_incr_cnt;
end


//Spectag,killmask & LS Ordering Tag Allocation to final_uop considering Uop_IsReady & spectag_allocation
reg  [`DECODE_RATE-1:0]             UopOut_Valid;                           //i=1 => uop is valid considering Is_it Ready & spectag_is_available
reg  [$clog2(`DECODE_RATE)-1:0]     CurrentSpectagIndex;
reg  [`SPEC_STATES-1:0]             uop_Spectag[0:`DECODE_RATE-1];          //spectag to be allocated to ith uop
reg  [`SPEC_STATES-1:0]             uop_KillMask[0:`DECODE_RATE-1];         //killmask to be allocated to ith uop
reg                                 NoFreeSpectagToAlloc;
integer d;
always @* begin
    CurrentSpectagIndex = 0;
    Alloced_SpectagMask = 0;
    ls_tag_incr_cnt = 0;
    NoFreeSpectagToAlloc = 1'b0;

    for(d=0; d<`DECODE_RATE; d=d+1) begin
        //is uop ready to be registerd at output? (if it is not going to pipeline in this
        //clk cycle, then there is no point to assign spectag to that uop in
        //current cycle
        if(Uop_IsReady[d] && ~Branch_Mispredicted && ~NoFreeSpectagToAlloc) begin
            //do we have to allocate new spectag? (actually new tag will be
            //allocated to next instr)
            if(AllocateNewSpectag[d]==1'b1) begin
                //Is 'CurrentSpectagIndex' Spectag available to allocate?
                if(ToAlloc_SpectagValid[CurrentSpectagIndex]==1'b1) begin
                    uop_Spectag[d]  = Spectag[CurrentSpectagIndex];
                    uop_KillMask[d] = KillMask[CurrentSpectagIndex];

                    //set that 'CurrentSpectagIndex' tag is now used
                    UopOut_Valid[d]                         = 1'b1;
                    Alloced_SpectagMask[CurrentSpectagIndex]= 1'b1;
                    CurrentSpectagIndex                     = CurrentSpectagIndex + 1;
                end
                else begin
                    //Also if Spectag is not available to allocate, do not process
                    //succeding instrs
                    NoFreeSpectagToAlloc=1'b1;
                    uop_Spectag[d]      = 0;       //default = invalid
                    uop_KillMask[d]     = 0;       //default = invalid
                    UopOut_Valid[d]     = 1'b0;
                end
            end
            else begin
                //No need to Allocated "New" => allocate current
                uop_Spectag[d]       = Spectag[CurrentSpectagIndex];
                uop_KillMask[d]      = KillMask[CurrentSpectagIndex];
                UopOut_Valid[d]      = 1'b1;
            end

            //assign LS Ordering Tag
            if(AllocateLSorderTag[d]==1'b1) begin
                uop_LSorderTag[d] = ls_order_tag + ls_tag_incr_cnt;
                ls_tag_incr_cnt   = ls_tag_incr_cnt + 1;
            end
            else
                uop_LSorderTag[d] = 0;
        end
        else begin
            uop_Spectag[d]       = 0;       //default = invalid
            uop_KillMask[d]      = 0;       //default = invalid
            UopOut_Valid[d]      = 1'b0;    //UopOutput is Not Valid since either input was not valid, or no need to issue now
            uop_LSorderTag[d]    = 0;
        end
    end
end


//Create final output uop
reg  [`UOP_LEN-1:0]  decoder_dataout_d[0:`DECODE_RATE-1];
integer f;
always @* begin
    for(f=0;f<`DECODE_RATE; f=f+1) begin
        decoder_dataout_d[f] = decoded_uop[f];
        //override null values of spectag & killmask in decoded_uop with
        //actual one (as actual one are available now)
        if((AllocateNewSpectag[f]==1'b1) || (decoded_uop[f][`UOP_RSTYPE]==`RS_TYPE_BR))
            decoder_dataout_d[f][`UOP_BR_SPECTAG__ABS]  = uop_Spectag[f]; //Only allocated to Branch Type Instructions

        decoder_dataout_d[f][`UOP_KILLMASK]    = Update_KillMask ? (uop_KillMask[f] & ~FUBRresp[`FUBR_RESULT_SPECTAG]) : uop_KillMask[f];
        decoder_dataout_d[f][`UOP_SPECTAG ]    = uop_Spectag[f];

        //Assign LS Order Tag to uop if needed
        if(AllocateLSorderTag[f]==1'b1)
            decoder_dataout_d[f][`UOP_MEM_LSORDERTAG__ABS]  = uop_LSorderTag[f]; //Only Allocated to memory operation instructions
    end
end


//HACK: $@DECODE_RATE $@RENAME_RATE
//NOTE: if(`DECODE_RATE==`RENAME_RATE) the simple piepline register can be used as
//output stage. The fallowing code assumes this. If DECODE_RATE & RENAME_RATE
//are different, then multiported queue needs to be implemented.

//Pipeline Register data write process
integer o;
reg  [`UOP_LEN-1:0] Decoder_Data[0:`RENAME_RATE];
always @(posedge clk) begin
    if(rst | Flush | Branch_Mispredicted) begin
        for(o=0; o<`RENAME_RATE; o=o+1)
            Decoder_Data[o] <= 0;
        Decoder_OutValid    <= 0;
    end
    else if(~Decoder_Stall) begin
        Decoder_OutValid <= UopOut_Valid;
        for(o=0; o<`RENAME_RATE; o=o+1) begin
            if(UopOut_Valid[o]==1'b1)
                Decoder_Data[o] <= decoder_dataout_d[o];
        end
    end
    else if(Update_KillMask) begin
        for(o=0; o<`RENAME_RATE; o=o+1)
            Decoder_Data[o][`UOP_KILLMASK] <= Decoder_Data[o][`UOP_KILLMASK] & ~FUBRresp[`FUBR_RESULT_SPECTAG];
    end
end
//generate output wires
genvar go;
generate
    for(go=0;go<`RENAME_RATE;go=go+1) begin
        assign Decoder_DataOut[(go*`UOP_LEN)+:`UOP_LEN] = Decoder_Data[go];
    end
endgenerate


//Stall Till Retire Locking logic
always @(posedge clk) begin
    if(rst | Flush | Branch_Mispredicted)
        StallTillRetireLock <= 0;
    else if(StallLockRelease)
        StallTillRetireLock <= 0;
    else if(decoded_uop[0][`UOP_STALL_TILL_RETIRE] && UopOut_Valid[0])
        //NOTE: Only supports stalling uop behind 0th. This is case when uop0 is 'wait_till_empty'
        //Simply StallTillRetire must also imply wait_till_empty
        StallTillRetireLock <= 1'b1;
end


//Decoder Stall Logic
//Stall all decoder operation (including spectag allocation) if Stall is
//requested externally;
assign Decoder_Stall = Stall;

//No. of instr to be dequeued from IB
integer x;
reg [$clog2(`DECODE_RATE):0] ValidUopSum;
always @* begin
    ValidUopSum=0;
    for(x=0; x<`DECODE_RATE; x=x+1)
        ValidUopSum = ValidUopSum + UopOut_Valid[x];
end
assign IB_RdCnt = (~Decoder_Stall) ? ValidUopSum : 0;


`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;

    `ifdef DEBUG_DECODER
        always @(negedge clk) begin
            if(Decoder_Stall) begin
                $display("[%t] DECODE@STS##: Decoder Stall. Stall=%b StallTillRetireLock=%b", $time,
                    Stall, StallTillRetireLock);
            end
            else begin
                for(Di=0; Di<`DECODE_RATE; Di=Di+1) begin
                    if(IB_OutValid[Di] & UopOut_Valid[Di]) begin
                        $display("[%t] DECODE@INP%-2d: PC=%h Instr=%h | ST=%b KM=%b OT=%0d | E=%b", $time, Di,
                            decoded_uop[Di][`UOP_PC], RV64GC_Decoder.IB_Instr[Di],
                            uop_Spectag[Di], uop_KillMask[Di], uop_LSorderTag[Di],
                            decoded_uop[Di][`UOP_EXCEPTION]);
                    end
                end
                $display("[%t] DECODE@STS##: IB_RdCnt=%d SpecValid=%b FreeSpectag=%0d",$time,
                    IB_RdCnt, Spectag_Valid, FreeSpectags);
            end
        end
    `endif
`endif


endmodule
