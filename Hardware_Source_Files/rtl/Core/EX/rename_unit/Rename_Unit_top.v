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
module Rename_Unit
(
    input  wire clk,
    input  wire rst,

    input  wire Stall,  //Stall Rename Operation
    input  wire Flush,  //Exception Flush

    //Inputs from Decoder (Decoder Output Pipeline Registers)
    input  wire [(`RENAME_RATE*`UOP_LEN)-1:0]                   Decoder_DataOut,     //Decoder output Peek Data
    input  wire [`RENAME_RATE-1:0]                              Decoder_OutValid,    //i=1 => ith output is valid

    //Global Input from Spectag Unit
    input  wire [`SPEC_STATES-1:0]                              Spectag_Valid,      //ith=1 => ith spec tag is speculative else not-speculative or unallocated

    //Inputs from Retire Unit
    input  wire [(`RETIRE_RATE*`RETIRE2RENAME_PORT_LEN)-1:0]    RetireRAT_Update_Bus,

    //Inputs from Branch (Resolution) Unit
    input  wire [`FUBR_RESULT_LEN-1:0]                          FUBRresp,

    //Decoded Uops Outputs (registered with pipeline reg)
    output wire [(`DISPATCH_RATE*`UOP_LEN)-1:0]                 Rename_DataOut,     //Decoded uop Data
    output reg  [`DISPATCH_RATE-1:0]                            Rename_OutValid,    //i=1 => Pipeline Register output is valid
    output wire                                                 Decode_StallRequest,//Stall decoder if all uops cannot be registerd at outputs

    //Outputs to Busy List
    output wire [`INT_PRF_DEPTH-1:0]                            Int_RecoveryPhyMapBits, //i=1 => ith Int phy reg was mapped in snapshot which is being recoverd
    output wire [`FP_PRF_DEPTH-1:0]                             Fp_RecoveryPhyMapBits   //i=1 => ith Fp phy reg was mapped in snapshot which is being recoverd

);

//extract fields from merged inputs
wire [`UOP_LEN-1:0]     decoder_uop  [0:`RENAME_RATE-1];
wire                    uop_valid    [0:`RENAME_RATE-1];
wire [`SPEC_STATES-1:0] uop_killmask [0:`RENAME_RATE-1];
wire [`SPEC_STATES-1:0] uop_spectag  [0:`RENAME_RATE-1];
wire                    uop_reg_WE   [0:`RENAME_RATE-1];
wire                    uop_rd_type  [0:`RENAME_RATE-1];
wire                    uop_rs1_type [0:`RENAME_RATE-1];
wire                    uop_rs2_type [0:`RENAME_RATE-1];
wire                    uop_is_rd    [0:`RENAME_RATE-1];
wire                    uop_is_rs1   [0:`RENAME_RATE-1];
wire                    uop_is_rs2   [0:`RENAME_RATE-1];
wire                    uop_is_rs3   [0:`RENAME_RATE-1];
wire [4:0]              uop_rd       [0:`RENAME_RATE-1];
wire [4:0]              uop_rs1      [0:`RENAME_RATE-1];
wire [4:0]              uop_rs2      [0:`RENAME_RATE-1];
wire [4:0]              uop_rs3      [0:`RENAME_RATE-1];
wire                    uop_exception[0:`RENAME_RATE-1];
wire                    uop_to_rename[0:`RENAME_RATE-1];
wire [`RENAME_RATE-1:0] decode_valid;

genvar gn;
generate
    for(gn=0; gn<`RENAME_RATE; gn=gn+1) begin
        assign decoder_uop[gn] = Decoder_DataOut[(gn*`UOP_LEN)+:`UOP_LEN];

        assign uop_valid[gn]     = decoder_uop[gn][`UOP_VALID];
        assign uop_killmask[gn]  = decoder_uop[gn][`UOP_KILLMASK];
        assign uop_spectag[gn]   = decoder_uop[gn][`UOP_SPECTAG];
        assign uop_reg_WE[gn]    = decoder_uop[gn][`UOP_REG_WE];
        assign uop_rd_type[gn]   = decoder_uop[gn][`UOP_RD_TYPE];
        assign uop_rs1_type[gn]  = decoder_uop[gn][`UOP_RS1_TYPE];
        assign uop_rs2_type[gn]  = decoder_uop[gn][`UOP_RS2_TYPE];
        assign uop_is_rd[gn]     = decoder_uop[gn][`UOP_IS_RD];
        assign uop_is_rs1[gn]    = decoder_uop[gn][`UOP_IS_RS1];
        assign uop_is_rs2[gn]    = decoder_uop[gn][`UOP_IS_RS2];
        assign uop_is_rs3[gn]    = decoder_uop[gn][`UOP_IS_RS3];
        assign uop_rd[gn]        = decoder_uop[gn][`UOP_RD];
        assign uop_rs1[gn]       = decoder_uop[gn][`UOP_RS1];
        assign uop_rs2[gn]       = decoder_uop[gn][`UOP_RS2];
        assign uop_rs3[gn]       = decoder_uop[gn][`UOP_RS3];
        assign uop_exception[gn] = decoder_uop[gn][`UOP_EXCEPTION];

        assign decode_valid[gn]  = uop_valid[gn] & Decoder_OutValid[gn];
        //Rename only iff uop_is_valid & Decoder_output_is_valid
        //& instr_write_to_reg & id_rd_exists (double check) & no_exception
        assign uop_to_rename[gn] = decode_valid[gn] & uop_reg_WE[gn] & uop_is_rd[gn] & ~uop_exception[gn];
    end
endgenerate


//create interconnect wires
//for Renaming (marking used)
reg  [4:0]                      SpecRAT_RdPort_rs1      [0:`RENAME_RATE-1];
reg  [4:0]                      SpecRAT_RdPort_rs2      [0:`RENAME_RATE-1];
reg  [4:0]                      SpecRAT_RdPort_rs3      [0:`RENAME_RATE-1];
reg                             SpecRAT_RdPort_rs1Type  [0:`RENAME_RATE-1];
reg                             SpecRAT_RdPort_rs2Type  [0:`RENAME_RATE-1];

reg  [4:0]                      SpecRAT_WrPort_rd       [0:`RENAME_RATE-1];
reg                             SpecRAT_WrPort_rdType   [0:`RENAME_RATE-1];
reg                             SpecRAT_WrPort_WE       [0:`RENAME_RATE-1];
reg  [`SPEC_STATES-1:0]         SpecRAT_WrPort_KillMask [0:`RENAME_RATE-1];

reg  [`PRF_MAX_LEN-1:0]         SpecRAT_WrData          [0:`RENAME_RATE-1];

wire [`PRF_MAX_LEN-1:0]         SpecRAT_RdData_prs1     [0:`RENAME_RATE-1];
wire [`PRF_MAX_LEN-1:0]         SpecRAT_RdData_prs2     [0:`RENAME_RATE-1];
wire [`PRF_MAX_LEN-1:0]         SpecRAT_RdData_prs3     [0:`RENAME_RATE-1];

wire [`RENAME_RATE-1:0]         IntFreeReg_Valid;
wire [`RENAME_RATE-1:0]         FpFreeReg_Valid;
wire [`INT_PRF_LEN-1:0]         IntFreeReg              [0:`RENAME_RATE-1];
wire [`FP_PRF_LEN-1:0]          FpFreeReg               [0:`RENAME_RATE-1];

reg  [`PRF_MAX_LEN-1:0]         FreeList_WrUsed_prd     [0:`RENAME_RATE-1];
reg                             FreeList_WrUsed_rdType  [0:`RENAME_RATE-1];
reg                             FreeList_WrUsed_WE      [0:`RENAME_RATE-1];
reg  [`SPEC_STATES-1:0]         FreeList_WrUsed_KillMask[0:`RENAME_RATE-1];

//for Freeing (marking free)
reg  [4:0]                      RetireRAT_WrPort_rd     [0:`RETIRE_RATE-1];
reg                             RetireRAT_WrPort_rdType [0:`RETIRE_RATE-1];
reg                             RetireRAT_WrPort_WE     [0:`RETIRE_RATE-1];
reg  [`PRF_MAX_LEN-1:0]         RetireRAT_WrPort_prd    [0:`RETIRE_RATE-1];

wire                            FreeList_WrFree_WE      [0:`RETIRE_RATE-1];
wire                            FreeList_WrFree_rdType  [0:`RETIRE_RATE-1];
wire [`PRF_MAX_LEN-1:0]         FreeList_WrFree_prd     [0:`RETIRE_RATE-1];

//For copying Retire RAT to Speculative RAT
wire                            FlashWriteEnable = Flush;
wire [(32*`INT_PRF_LEN)-1:0]    FlashWriteData_INT;
wire [(32*`FP_PRF_LEN)-1:0]     FlashWriteData_FP;

//For renaming related
wire [`UOP_LEN-1:0]             renamed_uop             [0:`RENAME_RATE-1];
reg  [`PRF_MAX_LEN-1:0]         phy_rs1                 [0:`RENAME_RATE-1];
reg  [`PRF_MAX_LEN-1:0]         phy_rs2                 [0:`RENAME_RATE-1];
reg  [`PRF_MAX_LEN-1:0]         phy_rs3                 [0:`RENAME_RATE-1];
reg  [`PRF_MAX_LEN-1:0]         phy_rd                  [0:`RENAME_RATE-1];
reg                             phy_rd_renamed          [0:`RENAME_RATE-1];
reg                             renaming_NoFreeSpace;

//Update From Retire Unit
wire [`RETIRE2RENAME_PORT_LEN-1:0]  Retire_Resp         [0:`RETIRE_RATE-1];

//Phy Reg Mapping Related
wire [`INT_PRF_DEPTH-1:0]       Int_RetirePhyMapBits;   //i=1 => ith Int phy reg was mapped in retire RAT
wire [`FP_PRF_DEPTH-1:0]        Fp_RetirePhyMapBits;     //i=1 => ith Fp phy reg was mapped in retire RAT

//Misprediction Related
wire                            Branch_Mispredicted  = FUBRresp[`FUBR_RESULT_VALID] & FUBRresp[`FUBR_RESULT_MISPRED];
wire                            Update_KillMask      = FUBRresp[`FUBR_RESULT_VALID] & FUBRresp[`FUBR_RESULT_ISSPEC] & ~FUBRresp[`FUBR_RESULT_MISPRED];
wire [`SPEC_STATES-1:0]         Mispredicted_SpecTag = FUBRresp[`FUBR_RESULT_SPECTAG];


//Convert Arrays into Busses
wire [(`RENAME_RATE*`PRF_MAX_LEN)-1:0]   FreeList_WrUsed_prd_bus;
wire [(`RENAME_RATE*1)-1:0]              FreeList_WrUsed_rdType_bus;
wire [(`RENAME_RATE*1)-1:0]              FreeList_WrUsed_WE_bus;
wire [(`RENAME_RATE*`SPEC_STATES)-1:0]   FreeList_WrUsed_KillMask_bus;

wire [(`RENAME_RATE*`INT_PRF_LEN)-1:0]   IntFreeReg_bus;
wire [(`RENAME_RATE*`FP_PRF_LEN)-1:0]    FpFreeReg_bus;

wire [(`RENAME_RATE*5)-1:0]              SpecRAT_RdPort_rs1_bus;
wire [(`RENAME_RATE*5)-1:0]              SpecRAT_RdPort_rs2_bus;
wire [(`RENAME_RATE*5)-1:0]              SpecRAT_RdPort_rs3_bus;
wire [(`RENAME_RATE*1)-1:0]              SpecRAT_RdPort_rs1Type_bus;
wire [(`RENAME_RATE*1)-1:0]              SpecRAT_RdPort_rs2Type_bus;

wire [(`RENAME_RATE*`SPEC_STATES)-1:0]   SpecRAT_WrPort_KillMask_bus;
wire [(`RENAME_RATE*1)-1:0]              SpecRAT_WrPort_WE_bus;
wire [(`RENAME_RATE*1)-1:0]              SpecRAT_WrPort_rdType_bus;
wire [(`RENAME_RATE*5)-1:0]              SpecRAT_WrPort_rd_bus;

wire [(`RENAME_RATE*`PRF_MAX_LEN)-1:0]   SpecRAT_WrData_bus;

wire [(`RENAME_RATE*`PRF_MAX_LEN)-1:0]   SpecRAT_RdData_prs1_bus;
wire [(`RENAME_RATE*`PRF_MAX_LEN)-1:0]   SpecRAT_RdData_prs2_bus;
wire [(`RENAME_RATE*`PRF_MAX_LEN)-1:0]   SpecRAT_RdData_prs3_bus;

wire [(`RETIRE_RATE*5)-1:0]              RetireRAT_WrPort_rd_bus;
wire [(`RETIRE_RATE*1)-1:0]              RetireRAT_WrPort_rdType_bus;
wire [(`RETIRE_RATE*1)-1:0]              RetireRAT_WrPort_WE_bus;
wire [(`RETIRE_RATE*`PRF_MAX_LEN)-1:0]   RetireRAT_WrPort_prd_bus;

wire [(`RETIRE_RATE*1)-1:0]              FreeList_WrFree_WE_bus;
wire [(`RETIRE_RATE*1)-1:0]              FreeList_WrFree_rdType_bus;
wire [(`RETIRE_RATE*`PRF_MAX_LEN)-1:0]   FreeList_WrFree_prd_bus;

genvar gi;
generate
    for(gi=0; gi<`RENAME_RATE; gi=gi+1) begin
        //SpecRAT Busses
        assign SpecRAT_RdPort_rs1_bus[gi*5+:5]                            = SpecRAT_RdPort_rs1[gi];
        assign SpecRAT_RdPort_rs2_bus[gi*5+:5]                            = SpecRAT_RdPort_rs2[gi];
        assign SpecRAT_RdPort_rs3_bus[gi*5+:5]                            = SpecRAT_RdPort_rs3[gi];
        assign SpecRAT_RdPort_rs1Type_bus[gi*1+:1]                        = SpecRAT_RdPort_rs1Type[gi];
        assign SpecRAT_RdPort_rs2Type_bus[gi*1+:1]                        = SpecRAT_RdPort_rs2Type[gi];

        assign SpecRAT_WrPort_rd_bus[gi*5+:5]                             = SpecRAT_WrPort_rd[gi];
        assign SpecRAT_WrPort_rdType_bus[gi*1+:1]                         = SpecRAT_WrPort_rdType[gi];
        assign SpecRAT_WrPort_WE_bus[gi*1+:1]                             = SpecRAT_WrPort_WE[gi];
        assign SpecRAT_WrPort_KillMask_bus[gi*`SPEC_STATES+:`SPEC_STATES] = SpecRAT_WrPort_KillMask[gi];

        assign SpecRAT_WrData_bus[gi*`PRF_MAX_LEN+:`PRF_MAX_LEN]          = SpecRAT_WrData[gi];

        assign SpecRAT_RdData_prs1[gi]                                    = SpecRAT_RdData_prs1_bus[gi*`PRF_MAX_LEN+:`PRF_MAX_LEN];
        assign SpecRAT_RdData_prs2[gi]                                    = SpecRAT_RdData_prs2_bus[gi*`PRF_MAX_LEN+:`PRF_MAX_LEN];
        assign SpecRAT_RdData_prs3[gi]                                    = SpecRAT_RdData_prs3_bus[gi*`PRF_MAX_LEN+:`PRF_MAX_LEN];

        //Free List Busses
        assign IntFreeReg[gi]                                             = IntFreeReg_bus[gi*`INT_PRF_LEN+:`INT_PRF_LEN];
        assign FpFreeReg[gi]                                              = FpFreeReg_bus[gi*`FP_PRF_LEN+:`FP_PRF_LEN];

        assign FreeList_WrUsed_prd_bus[gi*`PRF_MAX_LEN+:`PRF_MAX_LEN]     = FreeList_WrUsed_prd[gi];
        assign FreeList_WrUsed_rdType_bus[gi*1+:1]                        = FreeList_WrUsed_rdType[gi];
        assign FreeList_WrUsed_WE_bus[gi*1+:1]                            = FreeList_WrUsed_WE[gi];
        assign FreeList_WrUsed_KillMask_bus[gi*`SPEC_STATES+:`SPEC_STATES]= FreeList_WrUsed_KillMask[gi];
    end
endgenerate

genvar gj;
generate
    for(gj=0; gj<`RETIRE_RATE; gj=gj+1) begin
        //Retire RAT Busses
        assign RetireRAT_WrPort_rd_bus[gj*5+:5]                        = RetireRAT_WrPort_rd[gj];
        assign RetireRAT_WrPort_rdType_bus[gj*1+:1]                    = RetireRAT_WrPort_rdType[gj];
        assign RetireRAT_WrPort_WE_bus[gj*1+:1]                        = RetireRAT_WrPort_WE[gj];
        assign RetireRAT_WrPort_prd_bus[gj*`PRF_MAX_LEN+:`PRF_MAX_LEN] = RetireRAT_WrPort_prd[gj];

        assign Retire_Resp[gj]                                         = RetireRAT_Update_Bus[gj*`RETIRE2RENAME_PORT_LEN+:`RETIRE2RENAME_PORT_LEN];

        //Free List Busses
        assign FreeList_WrFree_WE[gj]                                  = FreeList_WrFree_WE_bus[gj*1+:1];
        assign FreeList_WrFree_rdType[gj]                              = FreeList_WrFree_rdType_bus[gj*1+:1];
        assign FreeList_WrFree_prd[gj]                                 = FreeList_WrFree_prd_bus[gj*`PRF_MAX_LEN+:`PRF_MAX_LEN];
    end
endgenerate


//Instantiate Submodules
Spec_RAT Spec_RAT
(
    .clk                    (clk                        ),
    .rst                    (rst                        ),

    .Stall                  (Stall                      ),

    .RdPort_rs1_bus         (SpecRAT_RdPort_rs1_bus     ),
    .RdPort_rs2_bus         (SpecRAT_RdPort_rs2_bus     ),
    .RdPort_rs3_bus         (SpecRAT_RdPort_rs3_bus     ),
    .RdPort_rs1Type_bus     (SpecRAT_RdPort_rs1Type_bus ),
    .RdPort_rs2Type_bus     (SpecRAT_RdPort_rs2Type_bus ),

    .WrPort_KillMask_bus    (SpecRAT_WrPort_KillMask_bus),
    .WrPort_WE_bus          (SpecRAT_WrPort_WE_bus      ),
    .WrPort_rdType_bus      (SpecRAT_WrPort_rdType_bus  ),
    .WrPort_rd_bus          (SpecRAT_WrPort_rd_bus      ),

    .WrData_bus             (SpecRAT_WrData_bus         ),

    .FlashWriteEnable       (FlashWriteEnable           ),
    .FlashWriteData_INT     (FlashWriteData_INT         ),
    .FlashWriteData_FP      (FlashWriteData_FP          ),

    .FUBRresp               (FUBRresp                   ),
    .Spectag_Valid          (Spectag_Valid              ),

    .RdData_prs1_bus        (SpecRAT_RdData_prs1_bus    ),
    .RdData_prs2_bus        (SpecRAT_RdData_prs2_bus    ),
    .RdData_prs3_bus        (SpecRAT_RdData_prs3_bus    ),

    .Int_RecoveryPhyMapBits (Int_RecoveryPhyMapBits     ),
    .Fp_RecoveryPhyMapBits  (Fp_RecoveryPhyMapBits      )
);

Retire_RAT Retire_RAT
(
    .clk                    (clk                            ),
    .rst                    (rst                            ),

    .WrPort_rd_bus          (RetireRAT_WrPort_rd_bus        ),
    .WrPort_rdType_bus      (RetireRAT_WrPort_rdType_bus    ),
    .WrPort_WE_bus          (RetireRAT_WrPort_WE_bus        ),
    .WrPort_prd_bus         (RetireRAT_WrPort_prd_bus       ),

    .WriteFree_WE_bus       (FreeList_WrFree_WE_bus         ),
    .WriteFree_rdType_bus   (FreeList_WrFree_rdType_bus     ),
    .WriteFree_prd_bus      (FreeList_WrFree_prd_bus        ),

    .FlashWriteData_INT     (FlashWriteData_INT             ),
    .FlashWriteData_FP      (FlashWriteData_FP              ),

    .Int_RetirePhyMapBits   (Int_RetirePhyMapBits           ),
    .Fp_RetirePhyMapBits    (Fp_RetirePhyMapBits            )
);

Free_List Free_List
(
    .clk                    (clk                        ),
    .rst                    (rst                        ),

    .StallWriteUsed         (Stall                      ),
    .Exception              (Flush                      ),

    .Branch_Mispredicted    (Branch_Mispredicted        ),
    .Update_KillMask        (Update_KillMask            ),
    .Mispredicted_SpecTag   (Mispredicted_SpecTag       ),
    .SpecTag_Valid          (Spectag_Valid              ),

    .Int_RetirePhyMapBits   (Int_RetirePhyMapBits       ),
    .Fp_RetirePhyMapBits    (Fp_RetirePhyMapBits        ),

    .WriteUsed_prd_bus      (FreeList_WrUsed_prd_bus    ),
    .WriteUsed_rdType_bus   (FreeList_WrUsed_rdType_bus ),
    .WriteUsed_WE_bus       (FreeList_WrUsed_WE_bus     ),
    .WriteUsed_KillMask_bus (FreeList_WrUsed_KillMask_bus),

    .WriteFree_WE_bus       (FreeList_WrFree_WE_bus     ),
    .WriteFree_rdType_bus   (FreeList_WrFree_rdType_bus ),
    .WriteFree_prd_bus      (FreeList_WrFree_prd_bus    ),

    .IntFreeReg_Valid       (IntFreeReg_Valid           ),
    .FpFreeReg_Valid        (FpFreeReg_Valid            ),

    .IntFreeReg_bus         (IntFreeReg_bus             ),
    .FpFreeReg_bus          (FpFreeReg_bus              )
);


//logic for renaming
integer w;
reg [$clog2(`RENAME_RATE)-1:0]  INT_index, FP_index;
always @* begin
    INT_index = 0; FP_index = 0;
    renaming_NoFreeSpace = 1'b0;

    for(w=0; w<`RENAME_RATE; w=w+1) begin
        phy_rd[w] = 0; phy_rd_renamed[w] = 1'b0;

        if(uop_to_rename[w]==1'b1 && ~Stall) begin
            if(uop_rd_type[w]==`REG_TYPE_INT) begin
                if(IntFreeReg_Valid[INT_index]==1'b1) begin
                    phy_rd[w][`INT_PRF_LEN-1:0] = IntFreeReg[INT_index];
                    phy_rd_renamed[w] = 1'b1;
                    INT_index = INT_index + 1;
                end
                else
                    renaming_NoFreeSpace = 1'b1;
            end
            else begin
                if(FpFreeReg_Valid[FP_index]==1'b1) begin
                    phy_rd[w][`FP_PRF_LEN-1:0] = FpFreeReg[FP_index];
                    phy_rd_renamed[w] = 1'b1;
                    FP_index = FP_index + 1;
                end
                else
                    renaming_NoFreeSpace = 1'b1;
            end
        end
    end

end


//logic for reading specRAT and assigning to renamed_uop
integer sr;
always @* begin
    for(sr=0;sr<`RENAME_RATE;sr=sr+1) begin
        SpecRAT_RdPort_rs3[sr]     = uop_rs3[sr];
        SpecRAT_RdPort_rs2Type[sr] = uop_rs2_type[sr];
        SpecRAT_RdPort_rs2[sr]     = uop_rs2[sr];
        SpecRAT_RdPort_rs1Type[sr] = uop_rs1_type[sr];
        SpecRAT_RdPort_rs1[sr]     = uop_rs1[sr];

        if(uop_is_rs1[sr]==1'b1 && decode_valid[sr]==1'b1)
            phy_rs1[sr] = SpecRAT_RdData_prs1[sr];
        else
            phy_rs1[sr] = 0;

        if(uop_is_rs2[sr]==1'b1 && decode_valid[sr]==1'b1)
            phy_rs2[sr] = SpecRAT_RdData_prs2[sr];
        else
            phy_rs2[sr] = 0;

        if(uop_is_rs3[sr]==1'b1 && decode_valid[sr]==1'b1)
            phy_rs3[sr] = SpecRAT_RdData_prs3[sr];
        else
            phy_rs3[sr] = 0;
    end
end


//logic for writing to specRAT and FreeList
//If Renaming of all instrs cannot be done. stall all; Partial renaming not
//allowed
integer s;
always @* begin
    for(s=0; s<`RENAME_RATE; s=s+1) begin
        //Do NOT write to SpecRAT and FreeList if Stalled or Branch_Mispredicted or all instrs can not be renamed
        if(~Stall & ~Branch_Mispredicted & ~renaming_NoFreeSpace) begin
            SpecRAT_WrPort_KillMask[s] = uop_killmask[s];
            SpecRAT_WrPort_WE[s]       = phy_rd_renamed[s];
            SpecRAT_WrPort_rdType[s]   = uop_rd_type[s];
            SpecRAT_WrPort_rd[s]       = uop_rd[s];

            SpecRAT_WrData[s]          = phy_rd[s];

            FreeList_WrUsed_KillMask[s]= uop_killmask[s];
            FreeList_WrUsed_WE[s]      = phy_rd_renamed[s];
            FreeList_WrUsed_rdType[s]  = uop_rd_type[s];
            FreeList_WrUsed_prd[s]     = phy_rd[s];
        end
        else begin
            SpecRAT_WrPort_KillMask[s] = 0;
            SpecRAT_WrPort_WE[s]       = 0;
            SpecRAT_WrPort_rdType[s]   = 0;
            SpecRAT_WrPort_rd[s]       = 0;

            SpecRAT_WrData[s]          = 0;

            FreeList_WrUsed_KillMask[s]= 0;
            FreeList_WrUsed_WE[s]      = 0;
            FreeList_WrUsed_rdType[s]  = 0;
            FreeList_WrUsed_prd[s]     = 0;
        end
    end
end


//Logic for Retire RAT update and Free list freeing
integer t;
always @* begin
    for(t=0; t<`RETIRE_RATE; t=t+1) begin
        RetireRAT_WrPort_WE[t]     = Retire_Resp[t][`RETIRE2RENAME_PORT_WE];
        RetireRAT_WrPort_rd[t]     = Retire_Resp[t][`RETIRE2RENAME_PORT_RD];
        RetireRAT_WrPort_rdType[t] = Retire_Resp[t][`RETIRE2RENAME_PORT_RDTYPE];
        RetireRAT_WrPort_prd[t]    = Retire_Resp[t][`RETIRE2RENAME_PORT_PRD];
    end
end


//create post renaming output uop
reg  [`UOP_LEN-1:0] rename_dataout_d[0:`RENAME_RATE-1];
integer f;
always @* begin
    for(f=0;f<`RENAME_RATE; f=f+1) begin
        rename_dataout_d[f] = decoder_uop[f];

        //Update KillMask if Branch is not Mispredicted
        if(Update_KillMask)
            rename_dataout_d[f][`UOP_KILLMASK] = decoder_uop[f][`UOP_KILLMASK] & ~FUBRresp[`FUBR_RESULT_SPECTAG];

        //override null values of prd, prs1, prs2, prs3 in decoder_uop with
        //actual one (as actual one are available now)
        rename_dataout_d[f][`UOP_PRD]  = phy_rd[f][`INT_PRF_LEN-1:0];
        rename_dataout_d[f][`UOP_PRS1] = phy_rs1[f][`INT_PRF_LEN-1:0];
        rename_dataout_d[f][`UOP_PRS2] = phy_rs2[f][`INT_PRF_LEN-1:0];
        rename_dataout_d[f][`UOP_PRS3] = phy_rs3[f][`FP_PRF_LEN-1:0];
    end
end


//HACK: $@RENAME_RATE $@DISPATCH_RATE
//NOTE: if(`RENAME_RATE==`DISPATCH_RATE) the simple piepline register can be used as
//output stage. The fallowing code assumes this. If RENAME_RATE & DISPATCH_RATE
//are different, then multiported queue needs to be implemented.

//Rename output stage pipeline registers
reg  [`UOP_LEN-1:0] Rename_Data[0:`DISPATCH_RATE-1];
integer o;
always @(posedge clk) begin
    if(rst | Flush | Branch_Mispredicted | renaming_NoFreeSpace) begin
        for(o=0;o<`DISPATCH_RATE;o=o+1)
            Rename_Data[o] <= 0;
        Rename_OutValid <= 0;
    end
    else if(~Stall) begin
        Rename_OutValid <= decode_valid;
        for(o=0; o<`DISPATCH_RATE; o=o+1) begin
            if(decode_valid[o]==1'b1)
                Rename_Data[o] <= rename_dataout_d[o];
        end
    end
    else if(Update_KillMask) begin
        for(o=0; o<`DISPATCH_RATE; o=o+1)
            Rename_Data[o][`UOP_KILLMASK] <= Rename_Data[o][`UOP_KILLMASK] & ~FUBRresp[`FUBR_RESULT_SPECTAG];
    end
end

//generate merged outputs
genvar go;
generate
    for(go=0;go<`DISPATCH_RATE;go=go+1) begin
        assign Rename_DataOut[(go*`UOP_LEN)+:`UOP_LEN] = Rename_Data[go];
    end
endgenerate


//Logic to tell Decoder that renaming was unsuccessful due to unavailability of
//free registers => Request Decoder to Stall
assign Decode_StallRequest = renaming_NoFreeSpace;


`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;
    `ifdef DEBUG_RENAME
        always @(negedge clk) begin
            if(Stall) begin
                $display("[%t] RENAME@STS##: Stall=%b", $time,
                    Stall);
            end
            else begin
                $write("[%t] RENAME@STS##: NoFreeReg=%b | ",$time, renaming_NoFreeSpace);
                for(Di=0; Di<`RENAME_RATE; Di=Di+1)
                    $write("I(%0d)=%0d F(%0d)=%0d ",Di,(IntFreeReg_Valid[Di] ? IntFreeReg[Di] : 1'bx), Di, (FpFreeReg_Valid[Di] ? FpFreeReg[Di] : 1'bx));
                $display("");

                for(Di=0; Di<`RENAME_RATE; Di=Di+1) begin
                    if(Decoder_OutValid[Di] && !renaming_NoFreeSpace) begin
                        $display("[%t] RENAME@INP%-2d: PC=%h | rd:%b %s->p%0d | rs1:%b %s->p%0d | rs2:%b %s->p%0d | ST=%0d", $time, Di,
                            decoder_uop[Di][`UOP_PC],
                            uop_is_rd[Di],  RegAbiName(uop_rd[Di], uop_rd_type[Di]), phy_rd[Di],
                            uop_is_rs1[Di], RegAbiName(uop_rs1[Di],uop_rs1_type[Di]),phy_rs1[Di],
                            uop_is_rs2[Di], RegAbiName(uop_rs2[Di],uop_rs2_type[Di]),phy_rs2[Di],
                            $clog2(uop_spectag[Di])
                        );
                    end
                end
            end
        end
    `endif

`endif


endmodule
