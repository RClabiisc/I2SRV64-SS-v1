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
module Spectag_Unit
#(
    parameter SPECTAGS = `SPEC_STATES
)
(
    input  wire clk,
    input  wire rst,

    input  wire                                 Flush,              //interrupt/exception/ECALL/*ret
    input  wire                                 Stall,              //Stalled Spectag Allocation (Freeing is never Stalled)

    //Responses from decoder
    input  wire [`DECODE_RATE-1:0]              Alloced_SpectagMask,   //1=>ith Spectag allocated

    //Responses from Branch (Resolution) Unit
    input  wire [`FUBR_RESULT_LEN-1:0]          FUBRresp,

    //Outputs for decoder
    output reg  [$clog2(SPECTAGS):0]            FreeSpectags,           //No. of available spec tags for allocation
    output wire [`DECODE_RATE-1:0]              ToAlloc_SpectagValid,   //i=1 => Spectag ith is valid for allocation
    output wire [(`DECODE_RATE*SPECTAGS)-1:0]   ToAlloc_Spectags,       //Current Spec Tag (Merged)  for allocation
    output wire [(`DECODE_RATE*SPECTAGS)-1:0]   ToAlloc_KillMasks,      //Current Kill Mask (Merged) for allocation

    //global outputs
    output reg  [SPECTAGS-1:0]                  Spectag_Valid       //ith=1 => ith spec tag is speculative else not-speculative or unallocated
);

//generated wires from FUBR response
wire                FUBR_Valid              = FUBRresp[`FUBR_RESULT_VALID] & FUBRresp[`FUBR_RESULT_ISSPEC];
wire                FUBR_BranchMispredicted = FUBRresp[`FUBR_RESULT_MISPRED];
wire [SPECTAGS-1:0] FUBR_Spectag            = FUBRresp[`FUBR_RESULT_SPECTAG];


//local wires for CurrentSpectags & CurrentKillMasks
reg  [SPECTAGS-1:0] Spectag_output[0:`DECODE_RATE-1];
reg  [SPECTAGS-1:0] SpectagKillMask_output[0:`DECODE_RATE-1];


//physical registers for storing current spectag
reg  [$clog2(SPECTAGS)-1:0] current_spectag;    //current spectag in binary format


//count no. of spect_tags allocated to instructions (branch & JALR/JR only)
//create mask to update valid register
reg  [$clog2(`DECODE_RATE):0]   allocated_spectag_cnt;
reg  [SPECTAGS-1:0]             spectag_valid_update_mask;
integer j;
always @* begin
    allocated_spectag_cnt = 0;
    spectag_valid_update_mask = 0;
    for(j=0; j<`DECODE_RATE; j=j+1) begin
        allocated_spectag_cnt = allocated_spectag_cnt + (Alloced_SpectagMask[j] ? 1 : 0);
        spectag_valid_update_mask = spectag_valid_update_mask | (Alloced_SpectagMask[j]==1'b1 ? Spectag_output[j] : 0);
    end
end

function [$clog2(SPECTAGS)-1:0] OneHot2Binary (input [SPECTAGS-1:0] OneHot);
    integer f_i;
    begin
        for(f_i=0; f_i<SPECTAGS; f_i=f_i+1) begin
            if(OneHot[f_i]==1'b1)
                OneHot2Binary = f_i;
        end
    end
endfunction


//current spectag register
always @(posedge clk) begin
    if(rst | Flush) begin
        //On Exception reset all speculative states
        current_spectag <= 0;
        Spectag_Valid   <= 0;
    end
    else if(FUBR_Valid && FUBR_BranchMispredicted==1'b1) begin
        //On Branch Misprediction, no need to save future speculative states.
        //therefore invalidate all. But will not start from 0th tag, as their
        //might be some old instructions with 0th tag set in kill mask, which
        //can get killed due to misprediction of newly allocated 0th branch.
        //(where old instructions had nothing to do with new branch)
        current_spectag <= OneHot2Binary(FUBR_Spectag)+1;
        Spectag_Valid   <= 0;
    end
    else if(FUBR_Valid && FUBR_BranchMispredicted==1'b0) begin
        //On Branch correct prediction, the speculative tag of that branch is
        //marked as invalid. As it is no longer speculative
        if(~Stall) begin
            Spectag_Valid   <= (Spectag_Valid & ~FUBR_Spectag) | spectag_valid_update_mask; //set newly allocated, clear old correct branch
            current_spectag <= current_spectag + allocated_spectag_cnt;
        end
        else
            Spectag_Valid   <= (Spectag_Valid & ~FUBR_Spectag); //clear old correct branch
    end
    else begin
        if(~Stall) begin
            Spectag_Valid   <= Spectag_Valid | spectag_valid_update_mask;
            current_spectag <= current_spectag + allocated_spectag_cnt;
        end
    end
end


//generate outputs: spectag for allocation and kill masks
integer i,k,m;
reg  [SPECTAGS-1:0] spectag_cumulative_outmask[0:`DECODE_RATE-1];
reg [$clog2(SPECTAGS)-1:0] spectag_idx;
always @* begin
    for(i=0; i<`DECODE_RATE; i=i+1) begin
        Spectag_output[i] = 0;
        spectag_idx       = current_spectag + i;
        Spectag_output[i][spectag_idx] = 1'b1;
    end
    SpectagKillMask_output[0] = Spectag_Valid;
    for(k=1;k<`DECODE_RATE; k=k+1) begin
        //All prev valid speculative instr can kill kth => create cumulative
        //mask for kth
        spectag_cumulative_outmask[k] = 0;
        //Bitwise or all previous Spectag to be allocated
        for(m=0; m<k; m=m+1)
            spectag_cumulative_outmask[k] = spectag_cumulative_outmask[k] | Spectag_output[m];

        //Final Killmask to be allocated => already allocated spectags in
        //earlier cycles (Spectag_Valid) OR cumulative mask for kth output
        SpectagKillMask_output[k] = Spectag_Valid | spectag_cumulative_outmask[k];   //all previous valid speculative instr can kill kth
    end
end


//no. of available free masks output
integer z;
always @* begin
    FreeSpectags = 0;
    for(z=0; z<SPECTAGS;z=z+1)
        FreeSpectags = FreeSpectags + (!Spectag_Valid[z]);
end


//pack outputs
genvar gi;
generate
    for(gi=0; gi<`DECODE_RATE;gi=gi+1) begin
        assign ToAlloc_Spectags[(gi*SPECTAGS) +: SPECTAGS]  = Spectag_output[gi];
        assign ToAlloc_KillMasks[(gi*SPECTAGS) +: SPECTAGS] = SpectagKillMask_output[gi];
        assign ToAlloc_SpectagValid[gi] = (gi<FreeSpectags) ? 1'b1 : 1'b0;
    end
endgenerate

endmodule
