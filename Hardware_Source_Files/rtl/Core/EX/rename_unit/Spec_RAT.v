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
module Spec_RAT
(
    input  wire clk,
    input  wire rst,

    input  wire Stall,  //Stalls all write port operations (NOT Flash Write)

    //RAT Read Ports
    input  wire [(`RENAME_RATE*5)-1:0]              RdPort_rs1_bus,
    input  wire [(`RENAME_RATE*5)-1:0]              RdPort_rs2_bus,
    input  wire [(`RENAME_RATE*5)-1:0]              RdPort_rs3_bus,
    input  wire [(`RENAME_RATE*1)-1:0]              RdPort_rs1Type_bus,
    input  wire [(`RENAME_RATE*1)-1:0]              RdPort_rs2Type_bus,

    //RAT Write Ports
    input  wire [(`RENAME_RATE*`SPEC_STATES)-1:0]   WrPort_KillMask_bus,
    input  wire [(`RENAME_RATE*1)-1:0]              WrPort_WE_bus,
    input  wire [(`RENAME_RATE*1)-1:0]              WrPort_rdType_bus,
    input  wire [(`RENAME_RATE*5)-1:0]              WrPort_rd_bus,

    //RAT Write data Input
    input  wire [(`RENAME_RATE*`PRF_MAX_LEN)-1:0]   WrData_bus,

    //Responses from Retire RAT & Retire Unit
    input  wire                                     FlashWriteEnable,
    input  wire [(32*`INT_PRF_LEN)-1:0]             FlashWriteData_INT,
    input  wire [(32*`FP_PRF_LEN)-1:0]              FlashWriteData_FP,

    //Response from Branch (Resolution) Unit
    input  wire [`FUBR_RESULT_LEN-1:0]              FUBRresp,

    //Input from Spectag_unit
    input  wire [`SPEC_STATES-1:0]                  Spectag_Valid,

    //RAT Read Data Output
    output wire [(`RENAME_RATE*`PRF_MAX_LEN)-1:0]   RdData_prs1_bus,
    output wire [(`RENAME_RATE*`PRF_MAX_LEN)-1:0]   RdData_prs2_bus,
    output wire [(`RENAME_RATE*`PRF_MAX_LEN)-1:0]   RdData_prs3_bus,

    //Mispred Recovery Phy Reg Mapping Bits
    output reg  [`INT_PRF_DEPTH-1:0]                Int_RecoveryPhyMapBits,     //i=1 => ith Int phy reg was mapped in snapshot which is being recoverd
    output reg  [`FP_PRF_DEPTH-1:0]                 Fp_RecoveryPhyMapBits       //i=1 => ith Fp phy reg was mapped in snapshot which is being recoverd

);

//generate generic local wires for input/outputs
wire [4:0]              RdPort_rs1      [0:`RENAME_RATE-1];
wire [4:0]              RdPort_rs2      [0:`RENAME_RATE-1];
wire [4:0]              RdPort_rs3      [0:`RENAME_RATE-1];
wire                    RdPort_IsRs1FP  [0:`RENAME_RATE-1];
wire                    RdPort_IsRs2FP  [0:`RENAME_RATE-1];
wire [4:0]              WrPort_rd       [0:`RENAME_RATE-1];
wire                    WrPort_IsRdFP   [0:`RENAME_RATE-1];
wire                    WrPort_WE       [0:`RENAME_RATE-1];
wire [`SPEC_STATES-1:0] WrPort_Spectag  [0:`RENAME_RATE-1];
wire [`SPEC_STATES-1:0] WrPort_KillMask [0:`RENAME_RATE-1];
wire [`PRF_MAX_LEN-1:0] WrData          [0:`RENAME_RATE-1];
reg  [`PRF_MAX_LEN-1:0] RdData_rs1      [0:`RENAME_RATE-1];
reg  [`PRF_MAX_LEN-1:0] RdData_rs2      [0:`RENAME_RATE-1];
reg  [`PRF_MAX_LEN-1:0] RdData_rs3      [0:`RENAME_RATE-1];


//generate local generic wires for ports
genvar gi;
generate
    for(gi=0; gi<`RENAME_RATE; gi=gi+1) begin
        assign RdPort_rs1[gi]      = RdPort_rs1_bus[gi*5+:5];
        assign RdPort_rs2[gi]      = RdPort_rs2_bus[gi*5+:5];
        assign RdPort_rs3[gi]      = RdPort_rs3_bus[gi*5+:5];
        assign RdPort_IsRs1FP[gi]  = RdPort_rs1Type_bus[gi*1+:1];
        assign RdPort_IsRs2FP[gi]  = RdPort_rs2Type_bus[gi*1+:1];
        assign WrPort_rd[gi]       = WrPort_rd_bus[gi*5+:5];
        assign WrPort_IsRdFP[gi]   = WrPort_rdType_bus[gi*1+:1];
        assign WrPort_WE[gi]       = WrPort_WE_bus[gi*1+:1];
        assign WrPort_KillMask[gi] = WrPort_KillMask_bus[gi*`SPEC_STATES+:`SPEC_STATES];
        assign WrData[gi]          = WrData_bus[gi*`PRF_MAX_LEN+:`PRF_MAX_LEN];

        assign RdData_prs1_bus[gi*`PRF_MAX_LEN+:`PRF_MAX_LEN] = RdData_rs1[gi];
        assign RdData_prs2_bus[gi*`PRF_MAX_LEN+:`PRF_MAX_LEN] = RdData_rs2[gi];
        assign RdData_prs3_bus[gi*`PRF_MAX_LEN+:`PRF_MAX_LEN] = RdData_rs3[gi];
    end
endgenerate


//generate wires for FUBR Response
wire FUBR_Valid                             = FUBRresp[`FUBR_RESULT_VALID] & FUBRresp[`FUBR_RESULT_ISSPEC];
wire FUBR_BranchMispredicted                = FUBRresp[`FUBR_RESULT_MISPRED];
wire [`SPEC_STATES-1:0] FUBR_Spectag_onehot = FUBRresp[`FUBR_RESULT_SPECTAG];
reg  [$clog2(`SPEC_STATES)-1:0] FUBR_Spectag;
integer fs;
always @* begin
    FUBR_Spectag = 0;
    for(fs=0;fs<`SPEC_STATES;fs=fs+1) begin
        if(FUBR_Spectag_onehot[fs]==1'b1)
            FUBR_Spectag = fs;
    end
end


//decompose FlashWriteData into array
wire [`INT_PRF_LEN-1:0] IntFlashWrData[0:31];
wire [`FP_PRF_LEN-1:0]  FpFlashWrData[0:31];
genvar gf;
generate
    for(gf=0; gf<32; gf=gf+1) begin
        assign IntFlashWrData[gf] = FlashWriteData_INT[(gf*`INT_PRF_LEN) +: `INT_PRF_LEN];
        assign FpFlashWrData[gf]  = FlashWriteData_FP[(gf*`FP_PRF_LEN) +: `FP_PRF_LEN];
    end
endgenerate


//Latest & Snapshot RATS for both INT & FP registers
reg [`INT_PRF_LEN-1:0]  IntLatestRAT[0:31];                     //Integer Reg RAT for Storing Latest Mapping
reg [`INT_PRF_LEN-1:0]  IntLatestRAT_d[0:31];                   //Next Value for Latest Int RAT
reg [`FP_PRF_LEN-1:0]   FpLatestRAT[0:31];                      //Floating Point Reg RAT for Storing Latest Mapping
reg [`FP_PRF_LEN-1:0]   FpLatestRAT_d[0:31];                    //Next Value for Latest FP RAT
reg [`INT_PRF_LEN-1:0]  IntSnapshotRAT[0:`SPEC_STATES-1][0:31]; //Snapshots of Latest Int RATs
reg [`FP_PRF_LEN-1:0]   FpSnapshotRAT[0:`SPEC_STATES-1][0:31];  //Snapshots of Latest FP RATs


//Latest RAT Write Process
//Write Value Generation + Write Value assign
//Priority in writing Port3>Port2>Port1>Port0 (i.e. if both Port1 and Port3
//are writing to same RAT then Port3 value will dominate; and will be
//written
integer l,lw;
always @(*) begin
    if(FlashWriteEnable==1'b1) begin
        for(l=0;l<32;l=l+1) begin
            IntLatestRAT_d[l] = IntFlashWrData[l];
            FpLatestRAT_d[l]  = FpFlashWrData[l];
        end
    end
    else if(FUBR_Valid==1'b1 && FUBR_BranchMispredicted==1'b1) begin
        for(l=0;l<32;l=l+1) begin
            IntLatestRAT_d[l] = IntSnapshotRAT[FUBR_Spectag][l];
            FpLatestRAT_d[l]  = FpSnapshotRAT[FUBR_Spectag][l];
        end
    end
    else begin
        for(l=0;l<32;l=l+1) begin
            IntLatestRAT_d[l] = IntLatestRAT[l];
            FpLatestRAT_d[l]  = FpLatestRAT[l];
        end

        for(lw=0; lw<`RENAME_RATE; lw=lw+1) begin
            if(WrPort_WE[lw]==1'b1) begin
                if(WrPort_IsRdFP[lw]==`REG_TYPE_FP)
                    FpLatestRAT_d[WrPort_rd[lw]] = WrData[lw][`FP_PRF_LEN-1:0];
                else
                    IntLatestRAT_d[WrPort_rd[lw]]= WrData[lw][`INT_PRF_LEN-1:0];
            end
        end
    end
end
always @(posedge clk) begin
    if(rst) begin
        for(l=0;l<32;l=l+1) begin
            IntLatestRAT[l] <= l;
            FpLatestRAT[l]  <= l;
        end
    end
    else  begin
        for(l=0;l<32;l=l+1) begin
            IntLatestRAT[l] <= IntLatestRAT_d[l];
            FpLatestRAT[l]  <= FpLatestRAT_d[l];
        end
    end
end


//Latest RAT Read Process (Incorporates Write Through with descending
//Priority) See docs
integer li, lj;
always @* begin
    for(li=0; li<`RENAME_RATE; li=li+1) begin
        RdData_rs1[li] = 0;
        RdData_rs2[li] = 0;
        RdData_rs3[li] = 0;

        if(RdPort_IsRs1FP[li]==`REG_TYPE_FP)
            RdData_rs1[li][`FP_PRF_LEN-1:0]  = FpLatestRAT[RdPort_rs1[li]];
        else
            RdData_rs1[li][`INT_PRF_LEN-1:0] = IntLatestRAT[RdPort_rs1[li]];

        if(RdPort_IsRs2FP[li]==`REG_TYPE_FP)
            RdData_rs2[li][`FP_PRF_LEN-1:0]  = FpLatestRAT[RdPort_rs2[li]];
        else
            RdData_rs2[li][`INT_PRF_LEN-1:0] = IntLatestRAT[RdPort_rs2[li]];

        RdData_rs3[li][`FP_PRF_LEN-1:0] = FpLatestRAT[RdPort_rs3[li]];

        //write through logic
        for(lj=0; lj<li; lj=lj+1) begin
            if((RdPort_IsRs1FP[li]==WrPort_IsRdFP[lj]) && (RdPort_rs1[li]==WrPort_rd[lj]) && (WrPort_WE[lj]==1'b1))
                RdData_rs1[li] = WrData[lj];

            if((RdPort_IsRs2FP[li]==WrPort_IsRdFP[lj]) && (RdPort_rs2[li]==WrPort_rd[lj]) && (WrPort_WE[lj]==1'b1))
                RdData_rs2[li] = WrData[lj];

            if((WrPort_IsRdFP[lj]==`REG_TYPE_FP) && (RdPort_rs3[li]==WrPort_rd[lj]) && (WrPort_WE[lj]==1'b1))
                RdData_rs3[li] = WrData[lj];
        end
    end
end


//Snapshot update mask on RAT write
//Sets Update Enable for (Own & Future snapshots)
//i.e Not (Old & Valid)
wire [`SPEC_STATES-1:0] SnapshotUpdateEn[0:`SPEC_STATES-1];
genvar gu;
generate
    for(gu=0; gu<`RENAME_RATE; gu=gu+1) begin
        assign SnapshotUpdateEn[gu] = ~(WrPort_KillMask[gu] & Spectag_Valid);
    end
endgenerate


//Snapshot Write Process
integer si,sj,sp;
always @(posedge clk) begin
    if(rst) begin
        for(si=0;si<`SPEC_STATES;si=si+1) begin
            for(sj=0;sj<32;sj=sj+1) begin
                IntSnapshotRAT[si][sj]  <= sj;
                FpSnapshotRAT[si][sj]   <= sj;
            end
        end
    end
    else if(FlashWriteEnable==1'b1) begin
        for(si=0;si<`SPEC_STATES;si=si+1) begin
            for(sj=0;sj<32;sj=sj+1) begin
                IntSnapshotRAT[si][sj]  <= IntFlashWrData[sj];
                FpSnapshotRAT[si][sj]   <= FpFlashWrData[sj];
            end
        end
    end
    else if(FUBR_Valid==1'b1 && FUBR_BranchMispredicted==1'b1) begin
        for(si=0;si<`SPEC_STATES;si=si+1) begin
            for(sj=0;sj<32;sj=sj+1) begin
                IntSnapshotRAT[si][sj]  <= IntSnapshotRAT[FUBR_Spectag][sj];
                FpSnapshotRAT[si][sj]   <= FpSnapshotRAT[FUBR_Spectag][sj];
            end
        end
    end
    else begin
        for(sp=0; sp<`RENAME_RATE;sp=sp+1) begin                        //iterate over all ports
            if(WrPort_WE[sp]==1'b1 && ~Stall) begin                     //if Wr Port is updating RAT
                for(si=0; si<`SPEC_STATES;si=si+1) begin                //iterate over all snapshots
                    if(SnapshotUpdateEn[sp][si]==1'b1) begin            //if snapshot[si] needs to be updated for Wrport[sp]
                        if(WrPort_IsRdFP[sp]==`REG_TYPE_FP)                     //is rd == FP reg
                            FpSnapshotRAT[si][WrPort_rd[sp]] <= WrData[sp][`FP_PRF_LEN-1:0];
                        else
                            IntSnapshotRAT[si][WrPort_rd[sp]] <= WrData[sp][`INT_PRF_LEN-1:0];
                    end
                end
            end
        end

        //override Snapshot RAT Update if Branch Predicted Correctly
        //Replace Snapshot of Branch by Latest
        if(FUBR_Valid==1'b1 && FUBR_BranchMispredicted==0) begin
            for(sj=0; sj<32;sj=sj+1) begin
                IntSnapshotRAT[FUBR_Spectag][sj] <= IntLatestRAT_d[sj];
                FpSnapshotRAT[FUBR_Spectag][sj]  <= FpLatestRAT_d[sj];
            end
        end
    end
end


//Generate Recovery Physical Reg. mapping bits
integer ri;
always @* begin
    Int_RecoveryPhyMapBits = 0;
    Fp_RecoveryPhyMapBits = 0;
    if(FUBR_BranchMispredicted==1'b1 && FUBR_Valid==1'b1) begin
        for(ri=0;ri<32;ri=ri+1) begin
            Int_RecoveryPhyMapBits[IntSnapshotRAT[FUBR_Spectag][ri]] = 1'b1;
            Fp_RecoveryPhyMapBits[FpSnapshotRAT[FUBR_Spectag][ri]] = 1'b1;
        end
    end
end

`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;
    `ifdef DEBUG_SPEC
        always @(negedge clk) begin
            if(Stall) begin
                $display("[%t] SPEC_R@STS##: Stall=%b", $time,
                    Stall);
            end
            `ifdef DEBUG_SPEC_ENTRY
                for(Di=0; Di<`RENAME_RATE; Di=Di+1) begin
                    if(WrPort_WE[Di] & ~Stall) begin
                        $display("[%t] SPEC_R@ENT%2d: UpdateMask=%b KillMask=%b", $time, Di,
                            SnapshotUpdateEn[Di], WrPort_KillMask[Di]);
                    end
                end
            `endif

            if(FlashWriteEnable | (FUBR_Valid & FUBR_BranchMispredicted)) begin
                for(Di=0; Di<32; Di=Di+1) begin
                    $display("[%t] SPEC_R@RST%2d: Ex=%b Mis=%b BrSpecTag=%d| INT: p%0d->p%0d | FP: p%0d->p%0d ",$time, Di,
                        FlashWriteEnable, (FUBR_Valid & FUBR_BranchMispredicted), FUBR_Spectag,
                        IntLatestRAT[Di], IntLatestRAT_d[Di],
                        FpLatestRAT[Di], FpLatestRAT_d[Di]);
                end
            end
        end
    `endif
`endif

endmodule

