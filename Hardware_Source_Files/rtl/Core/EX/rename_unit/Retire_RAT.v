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
module Retire_RAT
(
    input  wire clk,
    input  wire rst,

    //Responses from retire unit
    input  wire [(`RETIRE_RATE*5)-1:0]              WrPort_rd_bus,
    input  wire [(`RETIRE_RATE*1)-1:0]              WrPort_rdType_bus,
    input  wire [(`RETIRE_RATE*1)-1:0]              WrPort_WE_bus,
    input  wire [(`RETIRE_RATE*`PRF_MAX_LEN)-1:0]   WrPort_prd_bus,

    //Responses to Free List Unit
    output wire [(`RETIRE_RATE*1)-1:0]              WriteFree_WE_bus,
    output wire [(`RETIRE_RATE*1)-1:0]              WriteFree_rdType_bus,
    output wire [(`RETIRE_RATE*`PRF_MAX_LEN)-1:0]   WriteFree_prd_bus,

    //Responses to Spec_RAT for Flash Write
    output wire [(32*`INT_PRF_LEN)-1:0]             FlashWriteData_INT,
    output wire [(32*`FP_PRF_LEN)-1:0]              FlashWriteData_FP,

    //Exception Phy Reg Mapping Bits
    output reg  [`INT_PRF_DEPTH-1:0]                Int_RetirePhyMapBits,   //i=1 => ith Int phy reg was mapped in retire RAT
    output reg  [`FP_PRF_DEPTH-1:0]                 Fp_RetirePhyMapBits     //i=1 => ith Fp phy reg was mapped in retire RAT

);

//generate generic local wires for input/output
wire [4:0]              WrPort_rd       [0:`RETIRE_RATE-1];
wire                    WrPort_isRdFP   [0:`RETIRE_RATE-1];
wire                    WrPort_WE       [0:`RETIRE_RATE-1];
wire [`PRF_MAX_LEN-1:0] WrPort_data     [0:`RETIRE_RATE-1];
reg  [`PRF_MAX_LEN-1:0] FreeList_old_prd[0:`RETIRE_RATE-1];
reg                     FreeList_isRdFP [0:`RETIRE_RATE-1];
reg                     FreeList_WE     [0:`RETIRE_RATE-1];

//generate local generic wire for ports
genvar gi;
generate
    for(gi=0; gi<`RETIRE_RATE; gi=gi+1) begin
        assign WrPort_rd[gi]     = WrPort_rd_bus[gi*5+:5];
        assign WrPort_isRdFP[gi] = WrPort_rdType_bus[gi*1+:1];
        assign WrPort_WE[gi]     = WrPort_WE_bus[gi*1+:1];
        assign WrPort_data[gi]   = WrPort_prd_bus[gi*`PRF_MAX_LEN+:`PRF_MAX_LEN];

        assign WriteFree_WE_bus[gi*1+:1]                        = FreeList_WE[gi];
        assign WriteFree_rdType_bus[gi*1+:1]                    = FreeList_isRdFP[gi];
        assign WriteFree_prd_bus[gi*`PRF_MAX_LEN+:`PRF_MAX_LEN] = FreeList_old_prd[gi];
    end
endgenerate


//Retire RAT registers for INT & FP
reg [`INT_PRF_LEN-1:0]  IntRetireRAT[0:31];
reg [`FP_PRF_LEN-1:0]   FpRetireRAT[0:31];


//Retire RAT Write Process
//Priority in writing Port3>Port2>Port1>Port0 (i.e. if both Port1 and Port3
//are writing to same RetireRAT then Port3 value will dominate; and will be
//written
integer r,rw;
always @(posedge clk) begin
    if(rst) begin
        for(r=0; r<32; r=r+1) begin
            IntRetireRAT[r] <= r;
            FpRetireRAT[r]  <= r;
        end
    end
    else begin
        for(rw=0; rw<`RETIRE_RATE; rw=rw+1) begin
            if(WrPort_WE[rw]==1'b1) begin
                if(WrPort_isRdFP[rw]==`REG_TYPE_FP)
                    FpRetireRAT[WrPort_rd[rw]]  <= WrPort_data[rw][`FP_PRF_LEN-1:0];
                else
                    IntRetireRAT[WrPort_rd[rw]] <= WrPort_data[rw][`INT_PRF_LEN-1:0];
            end
        end
    end
end


//Free List Output Generation
integer f, F;
always @(*) begin
    for(f=0; f<`RETIRE_RATE; f=f+1) begin
        FreeList_WE[f]      = WrPort_WE[f];
        FreeList_isRdFP[f]  = WrPort_isRdFP[f];
        FreeList_old_prd[f] = 0;
        if(FreeList_isRdFP[f]==`REG_TYPE_FP)
            FreeList_old_prd[f][`FP_PRF_LEN-1:0]  = FpRetireRAT[WrPort_rd[f]];
        else
            FreeList_old_prd[f][`INT_PRF_LEN-1:0] = IntRetireRAT[WrPort_rd[f]];

        //Internal Forwarding from Retire RAT write input to Free List
        //e.g.  RetireRAT: a4->10
        //      Retire 0 : a4->19   => To be Freed 10
        //      Retire 1 : a4->20   => To be Freed 19
        //      Retire 2 : a4->21   => To be Freed 20
        //      Retire 3 : a4->22   => To be Freed 21
        for(F=0; F<f; F=F+1) begin
            if(WrPort_WE[F]==1'b1 && WrPort_isRdFP[F]==FreeList_isRdFP[f] && WrPort_rd[F]==WrPort_rd[f]) begin
                if(FreeList_isRdFP[f]==`REG_TYPE_FP)
                    FreeList_old_prd[f][`FP_PRF_LEN-1:0]  = WrPort_data[F][`FP_PRF_LEN-1:0];
                else
                    FreeList_old_prd[f][`INT_PRF_LEN-1:0] = WrPort_data[F][`INT_PRF_LEN-1:0];
            end
        end
    end
end


//pack Retire RAT registers into FlashWriteData wires
genvar gf;
generate
    for(gf=0; gf<32; gf=gf+1) begin
        assign FlashWriteData_INT[(gf*`INT_PRF_LEN) +: `INT_PRF_LEN] = IntRetireRAT[gf];
        assign FlashWriteData_FP[(gf*`FP_PRF_LEN)   +: `FP_PRF_LEN]  = FpRetireRAT[gf];
    end
endgenerate


//Generate Recovery Physical Reg. mapping bits
integer ri, rf;
always @* begin
    Int_RetirePhyMapBits = 0;
    Fp_RetirePhyMapBits = 0;
    for(ri=1;ri<32;ri=ri+1)
        Int_RetirePhyMapBits[IntRetireRAT[ri]] = 1'b1;
    for(rf=0;rf<32;rf=rf+1)
        Fp_RetirePhyMapBits[FpRetireRAT[rf]] = 1'b1;
end

endmodule

