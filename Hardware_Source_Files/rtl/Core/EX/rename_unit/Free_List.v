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

(* keep_hierarchy = "yes" *)
module Free_List
(
    input  wire clk,
    input  wire rst,

    input  wire StallWriteUsed,         //1=>Stalls Write Used operation
    input  wire Exception,              //1=>Exception

    //Branch Misprediction Inputs
    input  wire                                     Branch_Mispredicted,    //1=>Branch Mispredicted
    input  wire                                     Update_KillMask,        //1=>Branch Not Mispredicted
    input  wire [`SPEC_STATES-1:0]                  Mispredicted_SpecTag,   //Spectag of Mispredicted Branch aka snapshot being restored
    input  wire [`SPEC_STATES-1:0]                  SpecTag_Valid,          //Spectag Valid


    //Recovery Inputs for restoring correct status (free or used) of PRF
    input  wire [`INT_PRF_DEPTH-1:0]                Int_RetirePhyMapBits,   //i=1 => ith Int phy reg was mapped in retire RAT
    input  wire [`FP_PRF_DEPTH-1:0]                 Fp_RetirePhyMapBits,    //i=1 => ith Fp phy reg was mapped in retire RAT

    //Responses from Rename Unit
    input  wire [(`RENAME_RATE*`PRF_MAX_LEN)-1:0]   WriteUsed_prd_bus,
    input  wire [(`RENAME_RATE*1)-1:0]              WriteUsed_rdType_bus,
    input  wire [(`RENAME_RATE*1)-1:0]              WriteUsed_WE_bus,
    input  wire [(`RENAME_RATE*`SPEC_STATES)-1:0]   WriteUsed_KillMask_bus,

    //Responses from Retire RAT (to mark free)
    input  wire [(`RETIRE_RATE*1)-1:0]              WriteFree_WE_bus,
    input  wire [(`RETIRE_RATE*1)-1:0]              WriteFree_rdType_bus,
    input  wire [(`RETIRE_RATE*`PRF_MAX_LEN)-1:0]   WriteFree_prd_bus,

    //General Outputs
    output wire [`RENAME_RATE-1:0]                  IntFreeReg_Valid,   //i=1 => IntFreeReg<i> is Valid
    output wire [`RENAME_RATE-1:0]                  FpFreeReg_Valid,    //i=1 => FpFreeReg<i> is Valid

    //Responses to Rename Unit
    output wire [(`RENAME_RATE*`INT_PRF_LEN)-1:0]   IntFreeReg_bus, //Int Free Regs (consolidated) for renaming
    output wire [(`RENAME_RATE*`FP_PRF_LEN)-1:0]    FpFreeReg_bus   //Fp Free Regs (consolidated) for renaming
);

//generic local wires for inputs & outputs
wire [`PRF_MAX_LEN-1:0] WriteUsed_prd       [0:`RENAME_RATE-1]; //Phy Reg (prd) for marking as used
wire                    WriteUsed_isRdFP    [0:`RENAME_RATE-1]; //1=>prd is Floating Point Phy Reg
wire                    WriteUsed_WE        [0:`RENAME_RATE-1]; //1=>Write/Update Enable
wire [`SPEC_STATES-1:0] WriteUsed_KillMask  [0:`RENAME_RATE-1]; //KillMask of instr writing phy reg as used
reg  [`INT_PRF_LEN-1:0] IntFreeReg          [0:`RENAME_RATE-1]; //Array of Free Integer Phy reg
reg  [`FP_PRF_LEN-1:0]  FpFreeReg           [0:`RENAME_RATE-1]; //Array of Free Floating Phy reg
wire [`PRF_MAX_LEN-1:0] WriteFree_old_prd   [0:`RETIRE_RATE-1]; //Old Phy Reg (old_prd) for marking as free
wire                    WriteFree_isRdFP    [0:`RETIRE_RATE-1]; //1=>old_prd is Floating Phy Reg
wire                    WriteFree_WE        [0:`RETIRE_RATE-1]; //1=>Write/Update Enable
reg  [`INT_PRF_LEN:0]   IntFreeRegCnt;                          //No. of Free Int Phy Reg
reg  [`FP_PRF_LEN:0]    FpFreeRegCnt;                           //No. of Free Floating Phy Reg


//generate local generic wire for ports
genvar gi;
generate
    for(gi=0; gi<`RENAME_RATE; gi=gi+1) begin
        assign WriteUsed_prd[gi]     = WriteUsed_prd_bus[gi*`PRF_MAX_LEN+:`PRF_MAX_LEN];
        assign WriteUsed_isRdFP[gi]  = WriteUsed_rdType_bus[gi*1+:1];
        assign WriteUsed_WE[gi]      = WriteUsed_WE_bus[gi*1+:1];
        assign WriteUsed_KillMask[gi]= WriteUsed_KillMask_bus[gi*`SPEC_STATES+:`SPEC_STATES];

        assign IntFreeReg_bus[gi*`INT_PRF_LEN+:`INT_PRF_LEN] = IntFreeReg[gi];
        assign FpFreeReg_bus[gi*`FP_PRF_LEN+:`FP_PRF_LEN]    = FpFreeReg[gi];
    end
endgenerate

//generate local generic wire for ports
genvar gj;
generate
    for(gj=0; gj<`RETIRE_RATE; gj=gj+1) begin
        assign WriteFree_WE[gj]      = WriteFree_WE_bus[gj*1+:1];
        assign WriteFree_isRdFP[gj]  = WriteFree_rdType_bus[gj*1+:1];
        assign WriteFree_old_prd[gj] = WriteFree_prd_bus[gj*`PRF_MAX_LEN+:`PRF_MAX_LEN];
    end
endgenerate


//Free List Registers (1=>Used, 0=>Free)
reg  [`INT_PRF_DEPTH-1:0] IntFreeList;
reg  [`FP_PRF_DEPTH-1:0]  FpFreeList;

//Free List Owner Snapshot
//Owner => Which snapshot marked physical register as used. So that when
//restoring snapshot, physical regs which are marked as used by snapshot other
//than snapshot being restored is marked as free. Here there is implicite
//assumption that branches are excuted in order.
reg  [`SPEC_STATES-1:0] IntFL_KillMask[`INT_PRF_DEPTH-1:0];
reg  [`SPEC_STATES-1:0] FpFL_KillMask [`FP_PRF_DEPTH-1:0];


//Free List Update Process
integer i,f,wu,wf;
always @(posedge clk) begin
    if(rst) begin
        IntFreeList[0]    <= 1'b0;     //As mapping x0-->ipr0 is invalid, mark ipr0 as free
        IntFL_KillMask[0] <= 0;

        for(i=1; i<32; i=i+1) begin
            IntFreeList[i]    <= 1'b1; //mark ipr(1 to 31) as used
            IntFL_KillMask[i] <= 0;
        end
        for(i=32; i<`INT_PRF_DEPTH; i=i+1) begin
            IntFreeList[i]    <= 1'b0; //mark ipr(32 to rest) as free
            IntFL_KillMask[i] <= 0;
        end

        for(f=0; f<32; f=f+1) begin
            FpFreeList[f]     <= 1'b1; //mark fpr(0 to 31) as used
            FpFL_KillMask[f]  <= 0;
        end
        for(f=32; f<`FP_PRF_DEPTH; f=f+1) begin
            FpFreeList[f]     <= 1'b0; //mark fpr(32 to rest) as free
            FpFL_KillMask[f]  <= 0;
        end
    end
    else if(Exception) begin
        for(i=0; i<`INT_PRF_DEPTH; i=i+1) begin
            IntFreeList[i]    <= Int_RetirePhyMapBits[i];  //if IntPhyReg was mapped in retire RAT(=1) then mark it as used (=1)
            IntFL_KillMask[i] <= 0;
        end
        for(f=0; f<`FP_PRF_DEPTH;f=f+1) begin
            FpFreeList[f]    <= Fp_RetirePhyMapBits[f];    //if FpPhyReg was mapped in retire RAT (=1) then mark it as used (=1)
            FpFL_KillMask[f] <= 0;
        end
    end
    else begin
        //Each Physical Register has KillMask associated with it. This
        //KillMask is the KillMask of Instruction which is going to write into
        //it.
        //When a branch is mispredicted, this killmask is compared with
        //mispredicted spectag, if match is found and that physical register
        //is not mapped in retire RAT then that register is marked as free if
        //it was used earlier (similar to killing instruction in RS)
        //When branch is correctly predicted, the KillMask for every PRF is
        //updated corresponding to spectag of correctly predicted branch.
        if(Branch_Mispredicted) begin
            for(i=0; i<`INT_PRF_DEPTH; i=i+1) begin
                if(IntFreeList[i]==1'b1 && |(IntFL_KillMask[i] & Mispredicted_SpecTag) && Int_RetirePhyMapBits[i]==1'b0)
                    IntFreeList[i] <= 1'b0;
            end

            for(f=0; f<`FP_PRF_DEPTH;f=f+1) begin
                if(FpFreeList[f]==1'b1 && |(FpFL_KillMask[f] & Mispredicted_SpecTag) && Fp_RetirePhyMapBits[f]==1'b0)
                    FpFreeList[f] <= 1'b0;
            end
        end
        else if(Update_KillMask) begin
            for(i=0; i<`INT_PRF_DEPTH; i=i+1) begin
                IntFL_KillMask[i] <= IntFL_KillMask[i] & ~Mispredicted_SpecTag;
            end

            for(f=0; f<`FP_PRF_DEPTH;f=f+1) begin
                FpFL_KillMask[f] <= FpFL_KillMask[f] & ~Mispredicted_SpecTag;
            end
        end

        //If instrs are retiring, mark phy reg as free. This will override
        //free list recovered values after misprediction
        for(wf=0; wf<`RETIRE_RATE; wf=wf+1) begin
            if(WriteFree_WE[wf]==1'b1) begin
                if(WriteFree_isRdFP[wf]==`REG_TYPE_FP)
                    FpFreeList[WriteFree_old_prd[wf][`FP_PRF_LEN-1:0]]   <= 1'b0;
                else
                    IntFreeList[WriteFree_old_prd[wf][`INT_PRF_LEN-1:0]] <= 1'b0;
            end
        end

        //Mark phy reg as used if renamed
        for(wu=0; wu<`RENAME_RATE; wu=wu+1) begin
            if(WriteUsed_WE[wu]==1'b1 && ~StallWriteUsed) begin
                if(WriteUsed_isRdFP[wu]==`REG_TYPE_FP) begin
                    FpFreeList[WriteUsed_prd[wu][`FP_PRF_LEN-1:0]]      <= 1'b1;
                    FpFL_KillMask[WriteUsed_prd[wu][`FP_PRF_LEN-1:0]]   <=
                        Update_KillMask ? (WriteUsed_KillMask[wu] & ~Mispredicted_SpecTag) : WriteUsed_KillMask[wu];
                end
                else begin
                    IntFreeList[WriteUsed_prd[wu][`INT_PRF_LEN-1:0]]    <= 1'b1;
                    IntFL_KillMask[WriteUsed_prd[wu][`INT_PRF_LEN-1:0]] <=
                        Update_KillMask ? (WriteUsed_KillMask[wu] & ~Mispredicted_SpecTag) : WriteUsed_KillMask[wu];
                end
            end
        end
    end
end

//INT & FP Free register valid logic
//Free Phy Reg count process
integer ci, cf;
always @* begin
    IntFreeRegCnt = 0;
    FpFreeRegCnt  = 0;
    for(ci=0; ci<`INT_PRF_DEPTH; ci=ci+1)
        IntFreeRegCnt = IntFreeRegCnt + (!IntFreeList[ci]);
    for(cf=0; cf<`FP_PRF_DEPTH; cf=cf+1)
        FpFreeRegCnt = FpFreeRegCnt + (!FpFreeList[cf]);
end
//free count => valid logic
genvar gv;
generate
    for(gv=0; gv<`RENAME_RATE; gv=gv+1) begin
        assign IntFreeReg_Valid[gv] = (gv<IntFreeRegCnt) ? 1'b1 : 1'b0;
        assign FpFreeReg_Valid[gv]  = (gv<FpFreeRegCnt) ? 1'b1 : 1'b0;
    end
endgenerate


//Integer Free Physical Register output generator
//(multi-output Priority decoder with higher priority for lower index phy reg)
reg [`INT_PRF_DEPTH-1:0] int_preg_checked;      //Variable Not register
reg [`RENAME_RATE-1:0]   int_free_output_done;
integer oi,ip;
always @* begin
    int_preg_checked = 0;
    int_free_output_done = 0;
    for(ip=0; ip<`RENAME_RATE; ip=ip+1) begin
        IntFreeReg[ip] = 0;
        for(oi=0; oi<`INT_PRF_DEPTH; oi=oi+1) begin   //decending => lower number has high priority
            if( (IntFreeList[oi]==1'b0) && (int_preg_checked[oi]==1'b0) && (int_free_output_done[ip]==1'b0)) begin
                //Phy Reg[oi] is free AND is NOT checked/selected yet and
                //Output is NOT done yet
                int_preg_checked[oi] = 1'b1;
                int_free_output_done[ip] = 1'b1;
                IntFreeReg[ip] = oi;
            end
        end
    end
end


//Floating Point Free Physical Register output generator
//(multi-output Priority decoder with higher priority for lower index phy reg)
reg [`FP_PRF_DEPTH-1:0] fp_preg_checked;      //Variable Not register
reg [`RENAME_RATE-1:0]  fp_free_output_done;
integer of,fp;
always @* begin
    fp_preg_checked = 0;
    fp_free_output_done = 0;
    for(fp=0; fp<`RENAME_RATE; fp=fp+1) begin
        FpFreeReg[fp] = 0;
        for(of=0; of<`FP_PRF_DEPTH; of=of+1) begin   //decending => lower number has high priority
            if( (FpFreeList[of]==1'b0) && (fp_preg_checked[of]==1'b0) && (fp_free_output_done[fp]==1'b0) ) begin
                //Phy Reg[of] is free AND is NOT checked/selected yet and
                //Output is NOT done yet
                fp_preg_checked[of] = 1'b1;
                fp_free_output_done[fp] = 1'b1;
                FpFreeReg[fp] = of;
            end
        end
    end
end

`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;
    reg [`INT_PRF_DEPTH-1:0] DIntFreeList_Bus;
    reg [`FP_PRF_DEPTH-1:0]  DFpFreeList_Bus;

    `ifdef DEBUG_FREELIST
        always @(negedge clk) begin
            if(StallWriteUsed) begin
                $display("[%t] FREE__@STS##: Stall=%b", $time,
                    StallWriteUsed);
            end
            else begin
                $display("[%t] FREE__@STS##: Free INT=%0d FP=%0d", $time,
                    IntFreeRegCnt, FpFreeRegCnt
                );
            end
        end
    `endif
`endif


endmodule

