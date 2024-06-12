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
`timescale 1ns / 1ps
`include "core_defines.vh"
`include "regbit_defines.vh"
`include "bus_defines.vh"

(* keep_hierarchy = "yes" *)
module Branch_Checker
(
    input wire                                              clk,
    input wire                                              rst,

    input wire                                              Bubble, //1=>output BCresp is invalidated (see comments in header)

    //reponses from uBTB
    input wire  [`XLEN-1:0]                                 uBTB_TargetPC,      //Branch Target Address
    input wire  [`FETCH_RATE_HW_LEN-1:0]                    uBTB_BranchIndex,   //Taken Branch Index (HW offset from FetchPC)
    input wire  [`BRANCH_TYPE__LEN-1:0]                     uBTB_BranchType,    //Branch Type of taken branch
    input wire                                              uBTB_BranchTaken,   //1=>Branch Taken ny uBTB
    input wire                                              uBTB_BTBhit,        //1=>BTB was hit
    input wire  [1:0]                                       uBTB_BTB2bc,        //2bc value in BTB Entry
    input wire  [`BTB_WAYS_LEN-1:0]                         uBTB_BTBway,        //Way of BTB which was hit
    input wire  [`XLEN-1:0]                                 uBTB_RASpeek,       //Value at top of RAS

    //instruction bundles from Bundle_Generator
    input wire [(`BUNDLE_LEN*`FETCH_RATE_HW)-1:0]           InstrBundlesIn,
    input wire                                              Fetch_Exception,     //Pipelined I$ Exception
    input wire [`ECAUSE_LEN-1:0]                            Fetch_Ecause,        //Pipelined I$ Exception Cause

    //responses from Branch Quick Decode
    input wire  [(`BRANCH_TYPE__LEN*`FETCH_RATE_HW)-1:0]    BQD_BranchType_Bus,

    //responses from Direction Predictor (DP)
    input wire  [`FETCH_RATE-1:0]                           DP_2bc_Bus,
    input wire                                              DP_Hit,

    //update for uBTB
    output wire [`BC_RESP_LEN-1:0]                          BCresp,

    //Output to redirect FetchPC
    output reg  [`XLEN-1:0]                                 BC_NextFetchPC,
    output reg                                              BC_Redirect,

    //output to IB
    output reg  [`FETCH_RATE_HW-1:0]                        IB_EntryWE,     //tell which bundle entries to be enqueued in IB
    output reg  [`FETCH_RATE_HW:0]                          IB_WriteCnt,    //No. of entried to be enqueued in IB
    output wire [(`FETCH_RATE_HW*`IB_ENTRY_LEN)-1:0]        IB_Entries      //IB entries to be written to IB
);
`include "ISA_func.v"


//1. separate 'DP_2bc,BQD_BranchType' from bus to array
//2. Also extract individual instr bundle from InstrBundlesIn
//3. Extract instruction from every bundle
wire [1:0]                          DP_2bc[0:`FETCH_RATE_HW-1];
wire [`BRANCH_TYPE__LEN-1:0]        BQD_BranchType[0:`FETCH_RATE_HW-1];
wire [`BUNDLE_LEN-1:0]              bundle[0:`FETCH_RATE_HW-1];
wire [31:0]                         instr[0:`FETCH_RATE_HW-1];
wire [`XLEN-1:0]                    bundle_fetchpc[0:`FETCH_RATE_HW-1];
wire [`XLEN-1:0]                    bundle_pc[0:`FETCH_RATE_HW-1];
wire                                bundle_IsBranch [0:`FETCH_RATE_HW-1];
genvar gi;
generate
    for(gi=0;gi<`FETCH_RATE_HW;gi=gi+1) begin
        assign DP_2bc[gi]           = DP_2bc_Bus[(gi+1)*2-1:(gi)*2];
        assign BQD_BranchType[gi]   = BQD_BranchType_Bus[(gi*`BRANCH_TYPE__LEN)+:`BRANCH_TYPE__LEN];
        assign bundle[gi]           = InstrBundlesIn[((gi+1)*`BUNDLE_LEN)-1:(gi)*`BUNDLE_LEN];
        assign instr[gi]            = bundle[gi][`BUNDLE_INSTR];
        assign bundle_fetchpc[gi]   = bundle[gi][`BUNDLE_FETCHPC];
        assign bundle_pc[gi]        = bundle[gi][`BUNDLE_PC];
        assign bundle_IsBranch[gi]  = BQD_BranchType[gi]==`BRANCH_TYPE_COND;
    end
endgenerate


//output BCresponse wires
reg  [`XLEN-1:0]                    Resp_FetchPC;
wire [`FETCHPCL_LEN-1:0]            Resp_FetchPCL = Resp_FetchPC[`FETCHPCL_RANGE];
reg  [`XLEN-1:0]                    Resp_BranchTarget;
reg  [`XLEN-1:0]                    Resp_PushData;
reg  [`FETCH_RATE_HW_LEN-1:0]       Resp_BranchIndex;
reg                                 Resp_BranchIs16bit;
reg  [`BRANCH_TYPE__LEN-1:0]        Resp_BranchType;
reg                                 Resp_BranchTaken;
reg                                 Resp_Valid;
wire [1:0]                          Resp_BTB2bc = uBTB_BTB2bc;
wire                                Resp_BTBhit = uBTB_BTBhit;
wire [`BTB_WAYS_LEN-1:0]            Resp_BTBway = uBTB_BTBway;
wire [`XLEN-1:0]                    Resp_PC = Resp_FetchPC + {Resp_BranchIndex,1'b0};


//local variables (not physical registers)
reg                                 branch_found;                       //variable to indicate that first taken branch bundle has been found
reg [`FETCH_RATE_HW_LEN-1:0]        taken_branch_index;                 //variable indicated the index of first taken branch bundle
reg [`XLEN-1:0]                     calc_BTA[0:`FETCH_RATE_HW-1];       //calculated Branch Target Address for each bundle
reg [`XLEN-1:0]                     calc_NIA[0:`FETCH_RATE_HW-1];       //calculated Next Instruction Address for each bundle
reg [`XLEN-1:0]                     BranchTarget[0:`FETCH_RATE_HW-1];   //final (after uBTB & DP & instr consulation) Branch Target Address
reg                                 BranchTaken[0:`FETCH_RATE_HW-1];    //final (after uBTB & DP & instr consulation) Branch Direction


//calculate BTA & NIA for every valid instruction in bundle
integer l;
always @(*) begin
    for(l=0; l<`FETCH_RATE_HW; l=l+1) begin
        if(bundle[l][`BUNDLE_VALID]) begin
            //calculate next instruction address
            if(bundle[l][`BUNDLE_IS16BIT])
                calc_NIA[l] = bundle_pc[l] + 2;
            else
                calc_NIA[l] = bundle_pc[l] + 4;

            //calculate Branch target address
            case (BQD_BranchType[l])
                `BRANCH_TYPE_CALL, `BRANCH_TYPE_JMP: begin
                     calc_BTA[l] = bundle_pc[l] + ISA_get_offset(bundle[l][`BUNDLE_INSTR], bundle[l][`BUNDLE_IS16BIT], 1, 0, 0);
                end

                `BRANCH_TYPE_COND: begin
                    calc_BTA[l] = bundle_pc[l] + ISA_get_offset(bundle[l][`BUNDLE_INSTR], bundle[l][`BUNDLE_IS16BIT], 0, 1, 0);
                end

                default: calc_BTA[l] = 0;
            endcase
        end
        else begin
            calc_BTA[l]=0;
            calc_NIA[l]=0;
        end
    end
end


//Branch Checking Core loop
integer i;
always @(*)
begin
    branch_found       = 0;
    taken_branch_index = 0;
    BC_NextFetchPC     = 0;
    BC_Redirect        = 0;

    Resp_FetchPC       = 0;
    Resp_BranchIndex   = 0;
    Resp_BranchIs16bit = 0;
    Resp_BranchTarget  = 0;
    Resp_PushData      = 0;
    Resp_Valid         = 0;
    Resp_BranchType    = 0;
    Resp_BranchTaken   = 0;

    //iterate over all instr bundles
    for(i=0; i<`FETCH_RATE_HW; i=i+1) begin
        //initialise default data
        BranchTarget[i] = calc_NIA[i];
        BranchTaken[i]  = 1'b0;

        if(branch_found==0 && bundle[i][`BUNDLE_VALID]==1'b1) begin
            //write common data
            Resp_FetchPC     = bundle[i][`BUNDLE_FETCHPC];
            Resp_BranchIndex = i;
            Resp_BranchIs16bit = bundle[i][`BUNDLE_IS16BIT];
            Resp_BranchType  = BQD_BranchType[i];

            case(BQD_BranchType[i])
                `BRANCH_TYPE_CALL: begin
                    if(uBTB_BTBhit && uBTB_BranchType==`BRANCH_TYPE_CALL && uBTB_BranchIndex==i && uBTB_TargetPC==calc_BTA[i]) begin
                        //uBTB handled call correctly, just update uBTB
                        //for RAS
                        Resp_BranchTarget  = calc_BTA[i];
                        Resp_PushData      = calc_NIA[i];
                        Resp_Valid         = 1'b1;
                        Resp_BranchTaken   = 1'b1;
                        branch_found       = 1;
                        taken_branch_index = i;
                        BC_NextFetchPC     = calc_BTA[i];
                        BC_Redirect        = 1'b0;
                        BranchTarget[i]    = calc_BTA[i];
                        BranchTaken[i]     = 1'b1;

                    end
                    else begin
                        //uBTB mispredicted => update uBTB+redirect
                        Resp_BranchTarget  = calc_BTA[i];
                        Resp_PushData      = calc_NIA[i];
                        Resp_Valid         = 1'b1;
                        Resp_BranchTaken   = 1'b1;
                        branch_found       = 1;
                        taken_branch_index = i;
                        BC_NextFetchPC     = calc_BTA[i];
                        BC_Redirect        = 1'b1;
                        BranchTarget[i]    = calc_BTA[i];
                        BranchTaken[i]     = 1'b1;
                    end
                end

                `BRANCH_TYPE_RET: begin
                    if(uBTB_BTBhit==1'b1 && uBTB_BranchType==`BRANCH_TYPE_RET && uBTB_BranchIndex==i) begin
                        //correct prediction by uBTB => PC redirection from uBTB was valid
                        //=> No need of redirection from Branch Checker
                        branch_found       = 1; //since this is the last instruction in fetch group
                        taken_branch_index = i;
                        BranchTarget[i]    = uBTB_RASpeek;
                        BranchTaken[i]     = 1'b1;
                    end
                    else begin
                        //uBTB mispredicted => update uBTB & redirect PC
                        //to RAS peek value
                        Resp_Valid             = 1'b1;
                        Resp_BranchTaken       = 1'b1;
                        BC_NextFetchPC         = uBTB_RASpeek;
                        BranchTarget[i]        = uBTB_RASpeek;
                        if(|uBTB_RASpeek == 1'b1) begin
                            BC_Redirect        = 1'b1; //is RAS was empty, avoid redirection to wrong peeked value
                            branch_found       = 1;
                            taken_branch_index = i;
                            BranchTaken[i]     = 1'b1;
                        end
                    end
                end

                `BRANCH_TYPE_JMP: begin
                    if(uBTB_BTBhit==1'b1 && uBTB_BranchType==`BRANCH_TYPE_JMP &&
                        uBTB_BranchIndex==i && uBTB_TargetPC==calc_BTA[i]) begin
                        //correct prediction by uBTB => redirection of
                        //PC by uBTB is valid => no redirection from BC
                        branch_found       = 1;
                        taken_branch_index = i;
                        BranchTarget[i]    = calc_BTA[i];
                        BranchTaken[i]     = 1'b1;
                    end
                    else begin
                        //uBTB mispredicted => update & redirect PC
                        Resp_BranchTarget  = calc_BTA[i];
                        Resp_Valid         = 1'b1;
                        Resp_BranchTaken   = 1'b1;
                        BC_NextFetchPC     = calc_BTA[i];
                        BC_Redirect        = 1'b1;
                        branch_found       = 1;
                        taken_branch_index = i;
                        BranchTarget[i]    = calc_BTA[i];
                        BranchTaken[i]     = 1'b1;
                    end
                end

                `BRANCH_TYPE_IJMP: begin
                    //If indirect JMP is hit in uBTB (as updated by Branch Functional Unit)
                    if(uBTB_BTBhit==1'b1 && uBTB_BranchType==`BRANCH_TYPE_IJMP && uBTB_BranchIndex==i) begin
                        //correct prediction by uBTB => redirection of
                        //PC by uBTB is valid => no redirection from BC
                        branch_found       = 1;
                        taken_branch_index = i;
                        BranchTarget[i]    = uBTB_TargetPC;
                        BranchTaken[i]     = 1'b1;
                    end
                end

                `BRANCH_TYPE_ICALL: begin
                    //If indirect CALL is hit in uBTB (as updated by Branch Functional Unit)
                    if(uBTB_BTBhit==1'b1 && uBTB_BranchType==`BRANCH_TYPE_ICALL && uBTB_BranchIndex==i) begin
                        //prediction by uBTB => redirection of
                        //PC by uBTB is valid => no redirection from BC
                        branch_found       = 1;
                        taken_branch_index = i;
                        BranchTarget[i]    = uBTB_TargetPC;
                        BranchTaken[i]     = 1'b1;
                        //update uBTB RAS
                        Resp_BranchTarget  = 0;
                        Resp_PushData      = calc_NIA[i];
                        Resp_Valid         = 1'b1;
                        Resp_BranchTaken   = 1'b1;

                    end
                end

                `BRANCH_TYPE_COND: begin
                    if(uBTB_BTBhit==1'b1 && uBTB_BranchType==`BRANCH_TYPE_COND) begin
                        //BTB=Hit DP=Hit
                        if(DP_Hit) begin
                            //check branch predictions from uBTB & DP
                            case ({DP_2bc[i][1],uBTB_BTB2bc[1]})
                                2'b00: begin
                                    //No branch predicted to be taken by uBTB & DP => branch not taken
                                    branch_found = 0;
                                end
                                2'b01: begin
                                    //DP=not taken uBTB=taken
                                    if(uBTB_BranchIndex > i) begin
                                        //this bundle is not taken branch, it will come later => branch not found now
                                        branch_found = 0;
                                    end
                                    else begin
                                        //uBTB Mispredicted not taken as taken=> update uBTB
                                        //BC redirect to Next Instruction of branch & branch found=1
                                        Resp_BranchTarget  = uBTB_TargetPC;
                                        Resp_Valid         = 1'b1;
                                        Resp_BranchIndex   = uBTB_BranchIndex;
                                        Resp_BranchTaken   = 1'b0;
                                        branch_found       = 1;
                                        taken_branch_index = i;
                                        BC_NextFetchPC     = calc_NIA[i];
                                        BC_Redirect        = 1;
                                        BranchTarget[i]    = calc_NIA[i];
                                        BranchTaken[i]     = 1'b0;
                                    end
                                end
                                2'b10: begin
                                    //DP=taken uBTB=not taken => update uBTB
                                    //& PC redirection & branch found=1
                                    Resp_BranchTarget  = calc_BTA[i];
                                    Resp_Valid         = 1;
                                    Resp_BranchTaken   = 1'b1;
                                    branch_found       = 1;
                                    taken_branch_index = i;
                                    BC_NextFetchPC     = calc_BTA[i];
                                    BC_Redirect        = 1;
                                    BranchTarget[i]    = calc_BTA[i];
                                    BranchTaken[i]     = 1'b1;

                                end
                                2'b11: begin
                                    if(uBTB_BranchIndex==i && uBTB_TargetPC==calc_BTA[i]) begin
                                        //uBTB correct prediction => update uBTB 2bc
                                        //no redirection & branch found
                                        Resp_BranchTarget  = calc_BTA[i];
                                        Resp_Valid         = 1'b1;
                                        Resp_BranchTaken   = 1'b1;
                                        branch_found       = 1;
                                        taken_branch_index = i;
                                        BC_Redirect        = 0;
                                        BranchTarget[i]    = calc_BTA[i];
                                        BranchTaken[i]     = 1'b1;
                                    end
                                    else begin
                                        //uBTB mispredicted => update uBTB
                                        //BC redirection, branch found
                                        Resp_BranchTarget  = calc_BTA[i];
                                        Resp_Valid         = 1;
                                        Resp_BranchTaken   = 1'b1;
                                        branch_found       = 1;
                                        taken_branch_index = i;
                                        BC_NextFetchPC     = calc_BTA[i];
                                        BC_Redirect        = 1;
                                        BranchTarget[i]    = calc_BTA[i];
                                        BranchTaken[i]     = 1'b1;
                                    end
                                end
                            endcase
                        end
                        //DP Not hit but BTB hit as taken
                        else if(uBTB_BTB2bc[1]==1'b1) begin
                            if(uBTB_BranchIndex==i && uBTB_TargetPC==calc_BTA[i]) begin
                                //uBTB correct prediction => update uBTB 2bc
                                //no redirection & branch found
                                Resp_BranchTarget  = calc_BTA[i];
                                Resp_Valid         = 1'b1;
                                Resp_BranchTaken   = 1'b1;
                                branch_found       = 1;
                                taken_branch_index = i;
                                BC_Redirect        = 0;
                                BranchTarget[i]    = calc_BTA[i];
                                BranchTaken[i]     = 1'b1;
                            end
                            else begin
                                //uBTB mispredicted => update uBTB
                                //BC redirection, branch found
                                Resp_BranchTarget  = calc_BTA[i];
                                Resp_Valid         = 1;
                                Resp_BranchTaken   = 1'b1;
                                branch_found       = 1;
                                taken_branch_index = i;
                                BC_NextFetchPC     = calc_BTA[i];
                                BC_Redirect        = 1;
                                BranchTarget[i]    = calc_BTA[i];
                                BranchTaken[i]     = 1'b1;
                            end
                        end
                    end
                    else if(DP_Hit) begin
                        //uBTB not hit => update uBTB & BC redirection from DP & calc_BTA
                        if(DP_2bc[i][1]==1'b1) begin
                            Resp_BranchTarget  = calc_BTA[i];
                            Resp_Valid         = 1'b1;
                            Resp_BranchTaken   = 1'b1;
                            branch_found       = 1;
                            taken_branch_index = i;
                            BC_NextFetchPC     = calc_BTA[i];
                            BC_Redirect        = 1'b1;
                            BranchTarget[i]    = calc_BTA[i];
                            BranchTaken[i]     = 1'b1;
                        end
                    end
                end

                `BRANCH_TYPE_COROU: begin
                    //Not an Branch (currently treating Coroutine as NOT taken always. Since their address is unknown)
                    branch_found    = 0;
                end

                default: begin
                    branch_found = 0;

                end
            endcase
        end //branch found ends
    end //for loop

    //Override BC redirection if Bubble is asserted
    BC_Redirect = (!Bubble) & BC_Redirect;

end //always


//Generate IB entries
wire [`IB_ENTRY_LEN-1:0] IB_Entry[0:`FETCH_RATE_HW-1];
genvar gk;
generate
    for(gk=0;gk<`FETCH_RATE_HW;gk=gk+1) begin
        assign IB_Entry[gk][`IB_ENTRY_VALID]    = bundle[gk][`BUNDLE_VALID];
        assign IB_Entry[gk][`IB_ENTRY_PC]       = bundle_pc[gk];
        assign IB_Entry[gk][`IB_ENTRY_INSTR]    = bundle[gk][`BUNDLE_INSTR];
        assign IB_Entry[gk][`IB_ENTRY_IS16BIT]  = bundle[gk][`BUNDLE_IS16BIT];
        assign IB_Entry[gk][`IB_ENTRY_FETCHPCL] = bundle_fetchpc[gk][`FETCHPCL_RANGE];
        assign IB_Entry[gk][`IB_ENTRY_BINDEX]   = bundle[gk][`BUNDLE_BINDEX];
        assign IB_Entry[gk][`IB_ENTRY_BRTYPE]   = BQD_BranchType[gk];
        assign IB_Entry[gk][`IB_ENTRY_BRTARGET] = BranchTarget[gk];
        assign IB_Entry[gk][`IB_ENTRY_BRTAKEN]  = BranchTaken[gk];
        assign IB_Entry[gk][`IB_ENTRY_DP2BC]    = DP_2bc[gk];
        assign IB_Entry[gk][`IB_ENTRY_BTB2BC]   = uBTB_BTB2bc;
        assign IB_Entry[gk][`IB_ENTRY_BTBHIT]   = uBTB_BTBhit;
        assign IB_Entry[gk][`IB_ENTRY_EXCEPTION]= Fetch_Exception;
        assign IB_Entry[gk][`IB_ENTRY_ECAUSE]   = Fetch_Ecause;
        assign IB_Entry[gk][`IB_ENTRY_BTBWAY]   = uBTB_BTBway;
    end
endgenerate


//pack individual IB entries into IB entries (Bus)
genvar gj;
generate
    for(gj=0; gj<`FETCH_RATE_HW;gj=gj+1) begin
        assign IB_Entries[(gj+1)*`IB_ENTRY_LEN-1 : (gj)*`IB_ENTRY_LEN] = IB_Entry[gj];
    end
endgenerate


//Generate IB Entry Write Enable signals (bit j==1 => will be written in IB)
integer j;
always @* begin
    for(j=0; j<`FETCH_RATE_HW; j=j+1) begin
        if(rst)
            IB_EntryWE[j] = 0;
        else begin
            if(branch_found==1'b1)
                IB_EntryWE[j] = (j<=taken_branch_index) ? bundle[j][`BUNDLE_VALID] : 1'b0;  //if bundle before branch & valid => Write to IB else don't
            else
                IB_EntryWE[j] = bundle[j][`BUNDLE_VALID];
        end
    end
end

//IB Write Count => no of entries to be written in IB
integer wc;
always @* begin
    IB_WriteCnt = 0;
    for(wc=0; wc<`FETCH_RATE_HW; wc=wc+1)
        IB_WriteCnt = IB_WriteCnt + IB_EntryWE[wc];
end

//Generate Final BranchMask & TakenMask
integer z;
reg  [`FETCH_RATE_HW-1:0]       BCresp_BranchMask;
reg  [`FETCH_RATE_HW-1:0]       BCresp_TakenMask;
always @(*) begin
    BCresp_BranchMask = 0;
    BCresp_TakenMask  = 0;
    for(z=0; z<`FETCH_RATE_HW; z=z+1) begin
        BCresp_BranchMask[z] = bundle[z][`BUNDLE_VALID] && bundle_IsBranch[z] && (branch_found ? z<=taken_branch_index : 1'b1);
        BCresp_TakenMask[z]  = BranchTaken[z];
    end
end


//genrate BC Response Bus from individual
assign BCresp[`BC_RESP_VALID]    = (Bubble|rst == 1'b1) ? 1'b0 : Resp_Valid;
assign BCresp[`BC_RESP_PC]       = Resp_PC;
assign BCresp[`BC_RESP_FETCHPCL] = Resp_FetchPCL;
assign BCresp[`BC_RESP_BINDX]    = Resp_BranchIndex;
assign BCresp[`BC_RESP_BRTYPE]   = Resp_BranchType;
assign BCresp[`BC_RESP_BRTARGET] = Resp_BranchTarget;
assign BCresp[`BC_RESP_BRTAKEN]  = Resp_BranchTaken;
assign BCresp[`BC_RESP_BTB2BC]   = Resp_BTB2bc;
assign BCresp[`BC_RESP_BTBHIT]   = Resp_BTBhit;
assign BCresp[`BC_RESP_BTBWAY]   = Resp_BTBway;
assign BCresp[`BC_RESP_PUSH_DATA]   = Resp_PushData;
assign BCresp[`BC_RESP_BRANCH_MASK] = BCresp_BranchMask;
assign BCresp[`BC_RESP_TAKEN_MASK]  = BCresp_TakenMask;
assign BCresp[`BC_RESP_IS16BIT]     = Resp_BranchIs16bit;

`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;

    `ifdef DEBUG_IFU_BC
        always @(negedge clk) begin
            if(!Bubble) begin
                `ifdef DEBUG_IFU_BC_STS
                    if(BCresp[`BC_RESP_VALID]) begin
                        $display("[%t] IFUBC_@RSP##: FPC=%h BTarget=%h Bidx=%0d BT=%c | UpdtBTB: hit=%b 2bc=%b", $time,
                            Resp_FetchPC, BCresp[`BC_RESP_BRTARGET], BCresp[`BC_RESP_BINDX], B2C(BCresp[`BC_RESP_BRTYPE]),
                            BCresp[`BC_RESP_BTBHIT], BCresp[`BC_RESP_BTB2BC]);
                    end
                `endif

                `ifdef DEBUG_IFU_BC_ENTRY
                    for(Di=0; Di<`FETCH_RATE_HW; Di=Di+1) begin
                        if(IB_Entry[Di][`IB_ENTRY_VALID]) begin
                            $display("[%t] IFUBC_@ENT%-2d: PC=%h Instr=%h C=%b | Bidx=%0d Btype=%c BTarget=%h Btkn=%b | BTB2bc=%b DP2bc=%b | E=%b EC=%0d", $time, Di,
                                IB_Entry[Di][`IB_ENTRY_PC], IB_Entry[Di][`IB_ENTRY_INSTR], IB_Entry[Di][`IB_ENTRY_IS16BIT],
                                IB_Entry[Di][`IB_ENTRY_BINDEX], B2C(IB_Entry[Di][`IB_ENTRY_BRTYPE]),
                                    IB_Entry[Di][`IB_ENTRY_BRTARGET], IB_Entry[Di][`IB_ENTRY_BRTAKEN],
                                IB_Entry[Di][`IB_ENTRY_BTB2BC], IB_Entry[Di][`IB_ENTRY_DP2BC],
                                IB_Entry[Di][`IB_ENTRY_EXCEPTION], IB_Entry[Di][`IB_ENTRY_ECAUSE]
                            );
                        end
                    end
                `endif
            end
        end
    `endif
`endif

endmodule

