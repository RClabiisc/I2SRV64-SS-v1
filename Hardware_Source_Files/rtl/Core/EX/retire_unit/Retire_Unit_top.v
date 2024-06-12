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
module Retire_Unit
(
    input  wire clk,
    input  wire rst,

    //ROB Peek data Input & Used Count
    input  wire [(`RETIRE_RATE*`ROB_LEN)-1:0]               ROB_ReadData,       //ROB Peek Data
    input  wire [$clog2(`ROB_DEPTH):0]                      ROB_UsedEntries,    //Used Entries in ROB

    //Inputs from SysCtl Unit
    input  wire                                             RetireAllowed,

    //output Requests to Sys Control Unit
    output wire [`RETIRE2SYSCTL_LEN-1:0]                    Retire2SysCtl_Bus,

    //outputs to ROB in dispatch_unit
    output reg  [$clog2(`RETIRE_RATE):0]                    RetireCnt,          //No. of instr retired

    //outputs to IFU
    output wire [`RETIRE_RATE-1:0]                          Retire_BranchTaken, //i=1 => ith instr in retire group was taken
    output wire [`RETIRE_RATE-1:0]                          Retire_BranchMask,  //i=1 => ith instr in retire group was branch

    //Output to Decoder Unit
    output reg                                              StallLockRelease,   //1=>instr with 'UOP_STALL_TILL_RETIRE' is retired

    //Generic Output
    output wire [`XLEN-1:0]                                 RetirePC,

    //outputs to Rename Unit
    output wire [(`RETIRE_RATE*`RETIRE2RENAME_PORT_LEN)-1:0]RetireRAT_Update_Bus,

    //outputs to LSU
    output wire [(`RETIRE_RATE*`RETIRE2LSU_PORT_LEN)-1:0]   Retire2LSU_Bus

);

//separate merged inputs
wire [`ROB_LEN-1:0]         ROB_PeekData[0:`RETIRE_RATE-1];
wire [`ECAUSE_LEN-1:0]      Entry_ECause[0:`RETIRE_RATE-1];
wire [`METADATA_LEN-1:0]    Entry_Metadata[0:`RETIRE_RATE-1];
genvar gp;
generate
    for(gp=0; gp<`RETIRE_RATE; gp=gp+1) begin
        assign ROB_PeekData[gp]   = ROB_ReadData[gp*`ROB_LEN+:`ROB_LEN];
        assign Entry_ECause[gp]   = ROB_PeekData[gp][`ROB_ECAUSE];
        assign Entry_Metadata[gp] = ROB_PeekData[gp][`ROB_METADATA];
    end
endgenerate

//convert ROB Used count to Peek Data Valid Mask
reg  [`RETIRE_RATE-1:0] ROB_PeekValid;
integer pd;
always @* begin
    ROB_PeekValid = 0;
    for(pd=0; pd<`RETIRE_RATE; pd=pd+1) begin
        if(pd<ROB_UsedEntries)
            ROB_PeekValid[pd] = 1'b1;
    end
end


wire                        IsSYS       [0:`RETIRE_RATE-1];
wire                        IsFPU       [0:`RETIRE_RATE-1];
wire                        IsBranch    [0:`RETIRE_RATE-1];
wire                        IsStore     [0:`RETIRE_RATE-1];

wire                        fcsr_WE     [0:`RETIRE_RATE-1];
wire                        FPU_dirty   [0:`RETIRE_RATE-1];
wire                        IsXRET      [0:`RETIRE_RATE-1];
wire                        IsPipeFlush [0:`RETIRE_RATE-1];
wire [1:0]                  RETmode     [0:`RETIRE_RATE-1];
wire [`FCSR_FFLAGS_LEN-1:0] fcsr_fflags [0:`RETIRE_RATE-1];
wire                        BranchTaken [0:`RETIRE_RATE-1];
wire [`SB_DEPTH_LEN-1:0]    SB_Idx      [0:`RETIRE_RATE-1];

genvar gs;
generate
    for(gs=0; gs<`RETIRE_RATE; gs=gs+1) begin
        assign IsBranch[gs]    = ~ROB_PeekData[gs][`ROB_EXCEPTION] & (Entry_Metadata[gs][`METADATA_BRANCH_ID]==1'b1);
        assign BranchTaken[gs] = Entry_Metadata[gs][`METADATA_BRANCH__BRTAKEN];

        assign IsFPU[gs]       = ~ROB_PeekData[gs][`ROB_EXCEPTION] & (Entry_Metadata[gs][`METADATA_FPUOP_ID]==1'b1);
        assign FPU_dirty[gs]   = Entry_Metadata[gs][`METADATA_FPUOP__DIRTY];
        assign fcsr_WE[gs]     = Entry_Metadata[gs][`METADATA_FPUOP__FFLAGS_WE];
        assign fcsr_fflags[gs] = Entry_Metadata[gs][`METADATA_FPUOP__FFLAGS];

        assign IsSYS[gs]       = ~ROB_PeekData[gs][`ROB_EXCEPTION] & (Entry_Metadata[gs][`METADATA_SYS_ID]==1'b1);
        assign IsXRET[gs]      = Entry_Metadata[gs][`METADATA_SYS__ISXRET];
        assign RETmode[gs]     = Entry_Metadata[gs][`METADATA_SYS__RETMODE];
        assign IsPipeFlush[gs] = Entry_Metadata[gs][`METADATA_SYS__FLUSHPIPE];

        assign IsStore[gs]     = ~ROB_PeekData[gs][`ROB_EXCEPTION] & (Entry_Metadata[gs][`METADATA_STORE_ID]==1'b1);
        assign SB_Idx[gs]      = Entry_Metadata[gs][`METADATA_STORE__SBIDX];
    end
endgenerate


///////////////////////////////////////////////////////////////////////////////
//Main retire logic
//Retire Valid & NOT ROB Busy instr sequentially until exception or IsXRET
//comes. Exception must be always the first instruction in retire group.
wire [`RETIRE_RATE-1:0] IsRedirect;     //i=1 => exception or XRET present in ith instr in retire group
wire [`RETIRE_RATE-1:0] RedirectBefore; //i=1 => exception or XRET present in instr<=i in retire group
wire [`RETIRE_RATE-1:0] IsBusy;         //i=1 => ith peek data Entry is Busy (execution NOT completed)
wire [`RETIRE_RATE-1:0] BusyBefore;     //i=i => instr is busy in instr<=i in retire group
wire [`RETIRE_RATE-1:0] IsEntryValid;   //i=1 => ith peek data entry is Valid
wire [`RETIRE_RATE-1:0] WillBeRetired;  //i=1 => ith peek data entry will be retired
genvar ge;
generate
    for(ge=0; ge<`RETIRE_RATE; ge=ge+1) begin
        assign IsEntryValid[ge] = ROB_PeekData[ge][`ROB_VALID] & ROB_PeekValid[ge];
        assign IsRedirect[ge]   = IsEntryValid[ge] & (ROB_PeekData[ge][`ROB_EXCEPTION] | IsSYS[ge]);
        assign IsBusy[ge]       = IsEntryValid[ge] & ROB_PeekData[ge][`ROB_BUSY];

        //special consideration for 0th instr
        if(ge==0) begin
            assign RedirectBefore[0]  = IsRedirect[0];
            assign BusyBefore[0]      = IsBusy[0];
            assign WillBeRetired[0]   = IsEntryValid[0] & ~BusyBefore[0] & RetireAllowed;
            //0th instr will not check for presence of exception, as
            //exception/XRET is retired from 0th position only
        end
        else begin
            assign RedirectBefore[ge]   = |IsRedirect[ge:0];
            assign BusyBefore[ge]       = |IsBusy[ge:0];
            assign WillBeRetired[ge]    = IsEntryValid[ge] & ~BusyBefore[ge] & ~RedirectBefore[ge] & RetireAllowed;
        end
    end
endgenerate


//count number of instructions retired
//(basically sum of WillBeRetired bits)
integer c;
always @* begin
    RetireCnt = 0;
    for(c=0; c<`RETIRE_RATE;c=c+1)
        RetireCnt = RetireCnt + WillBeRetired[c];
end


//Track the PC of instrs retired
integer rt;
(* DONT_TOUCH = "true" *) reg [`XLEN-1:0] Retire_PC;
always @(posedge clk) begin
    if(rst)
        Retire_PC <= 0;
    else begin
        for(rt=0; rt<`RETIRE_RATE; rt=rt+1) begin
            if(WillBeRetired[rt]) begin
                Retire_PC <= ROB_PeekData[rt][`ROB_PC];
            end
        end
    end
end
assign RetirePC = Retire_PC;

//track PC and Value of Instr retired in each cycle (for Debugging)
(* DONT_TOUCH = "true" *) reg  [31:0]      dbg_Retire_Instr [0:`RETIRE_RATE-1];
(* DONT_TOUCH = "true" *) wire [31:0]      dbg_retire_instr [0:`RETIRE_RATE-1];
(* DONT_TOUCH = "true" *) reg  [`XLEN-1:0] dbg_Retire_PC    [0:`RETIRE_RATE-1];
(* DONT_TOUCH = "true" *) wire [`XLEN-1:0] dbg_retire_pc    [0:`RETIRE_RATE-1];
integer db;
always @(posedge clk) begin
    for(db=0; db<`RETIRE_RATE; db=db+1) begin
        if(rst) begin
            dbg_Retire_Instr[db] <= 0;
            dbg_Retire_PC[db]    <= 0;
        end
        else if(WillBeRetired[db]) begin
            dbg_Retire_Instr[db] <= ROB_PeekData[db][`ROB_INSTR];
            dbg_Retire_PC[db]    <= ROB_PeekData[db][`ROB_PC];
        end
        else begin
            dbg_Retire_Instr[db] <= ROB_PeekData[db][`ROB_INSTR];
            dbg_Retire_PC[db]    <= 0;
        end
    end
end
genvar gdb;
generate
    for(gdb=0; gdb<`RETIRE_RATE; gdb=gdb+1) begin
        assign dbg_retire_instr[gdb] = dbg_Retire_Instr[gdb];
        assign dbg_retire_pc[gdb] = dbg_Retire_PC[gdb];
    end
endgenerate


//generate exception/XRET output for Sysctl Unit
//Exception is always generated for 1st instr from peek data
//EXC_PC is also used for PC of instruction which captured the interrupt.
//The EXC_PC_VALID is used to tell SysCtl unit that EXC_PC is valid. This is
//required in case when ROB is empty & interrupt comes then, SysCtl will wait
//until appropriate instr (PC) is available to capture by looking at this
//signal
reg  [63:0]             trap_val;
reg  [`ECAUSE_LEN-1:0]  trap_cause;
always @* begin
    case(ROB_PeekData[0][`ROB_ECAUSE])
        `EXC_ILLEGAL_INSTR      : begin
            trap_val   = {32'd0, ROB_PeekData[0][`ROB_INSTR]};
            trap_cause = ROB_PeekData[0][`ROB_ECAUSE];
        end
        `EXC_IADDR_MISALIGN     : begin
            trap_val   = ROB_PeekData[0][`ROB_PC];
            trap_cause = ROB_PeekData[0][`ROB_ECAUSE];
        end
        `EXC_IACCESS_FAULT      : begin
            trap_val   = ROB_PeekData[0][`ROB_PC];
            trap_cause = ROB_PeekData[0][`ROB_ECAUSE];
        end
        `EXC_BREAKPOINT         : begin
            trap_val   = ROB_PeekData[0][`ROB_METADATA];
            trap_cause = ROB_PeekData[0][`ROB_ECAUSE];
        end
        `EXC_LADDR_MISALIGN     : begin
            trap_val   = ROB_PeekData[0][`ROB_METADATA];
            trap_cause = ROB_PeekData[0][`ROB_ECAUSE];
        end
        `EXC_LACCESS_FAULT      : begin
            trap_val   = ROB_PeekData[0][`ROB_METADATA];
            trap_cause = ROB_PeekData[0][`ROB_ECAUSE];
        end
        `EXC_SADDR_MISALIGN     : begin
            trap_val   = ROB_PeekData[0][`ROB_METADATA];
            trap_cause = ROB_PeekData[0][`ROB_ECAUSE];
        end
        `EXC_SACCESS_FAULT      : begin
            trap_val   = ROB_PeekData[0][`ROB_METADATA];
            trap_cause = ROB_PeekData[0][`ROB_ECAUSE];
        end
        `EXC_ECALL_UMODE        : begin
            trap_val   = ROB_PeekData[0][`ROB_METADATA];
            trap_cause = ROB_PeekData[0][`ROB_ECAUSE];
        end
        `EXC_ECALL_SMODE        : begin
            trap_val   = ROB_PeekData[0][`ROB_METADATA];
            trap_cause = ROB_PeekData[0][`ROB_ECAUSE];
        end
        `EXC_ECALL_MMODE        : begin
            trap_val   = ROB_PeekData[0][`ROB_METADATA];
            trap_cause = ROB_PeekData[0][`ROB_ECAUSE];
        end
        `EXC_IPAGE_FAULT        : begin
            trap_val   = ROB_PeekData[0][`ROB_PC];
            trap_cause = ROB_PeekData[0][`ROB_ECAUSE];
        end
        `EXC_LPAGE_FAULT        : begin
            trap_val   = ROB_PeekData[0][`ROB_METADATA];
            trap_cause = ROB_PeekData[0][`ROB_ECAUSE];
        end
        `EXC_SPAGE_FAULT        : begin
            trap_val   = ROB_PeekData[0][`ROB_METADATA];
            trap_cause = ROB_PeekData[0][`ROB_ECAUSE];
        end
        `EXC_IACCESS_FAULT_SPL  : begin
            trap_val   = ROB_PeekData[0][`ROB_PC] + 2;
            trap_cause = `EXC_IACCESS_FAULT;
        end
        `EXC_IPAGE_FAULT_SPL    : begin
            trap_val   = ROB_PeekData[0][`ROB_PC] + 2;
            trap_cause = `EXC_IPAGE_FAULT;
        end
        default                 : begin
            trap_val   = 0;
            trap_cause = ROB_PeekData[0][`ROB_ECAUSE];
        end
    endcase
end
assign Retire2SysCtl_Bus[`RETIRE2SYSCTL_EXCEPTION]      = IsEntryValid[0] & ROB_PeekValid[0] & ~IsBusy[0] & ROB_PeekData[0][`ROB_EXCEPTION];
assign Retire2SysCtl_Bus[`RETIRE2SYSCTL_ECAUSE]         = trap_cause;
assign Retire2SysCtl_Bus[`RETIRE2SYSCTL_TRAP_VAL]       = trap_val;
assign Retire2SysCtl_Bus[`RETIRE2SYSCTL_EXC_PC]         = ROB_PeekData[0][`ROB_PC];
assign Retire2SysCtl_Bus[`RETIRE2SYSCTL_EXC_PC_VALID]   = ROB_PeekValid[0] & IsEntryValid[0];
assign Retire2SysCtl_Bus[`RETIRE2SYSCTL_IS_XRET]        = IsEntryValid[0] & ROB_PeekValid[0] & ~IsBusy[0] & IsSYS[0] & IsXRET[0];
assign Retire2SysCtl_Bus[`RETIRE2SYSCTL_IS_FLUSHPIPE]   = IsEntryValid[0] & ROB_PeekValid[0] & ~IsBusy[0] & IsSYS[0] & IsPipeFlush[0];
assign Retire2SysCtl_Bus[`RETIRE2SYSCTL_RETMODE]        = RETmode[0];
assign Retire2SysCtl_Bus[`RETIRE2SYSCTL_RETIRECNT]      = RetireCnt;


//generate Retire RAT update signals iff instruction is going to be retired
genvar gr;
wire [`RETIRE2RENAME_PORT_LEN-1:0] RetireRAT_Update[0:`RETIRE_RATE-1];
generate
    for(gr=0; gr<`RETIRE_RATE; gr=gr+1) begin
        assign RetireRAT_Update[gr][`RETIRE2RENAME_PORT_RD]     = ROB_PeekData[gr][`ROB_UOP_RD];
        assign RetireRAT_Update[gr][`RETIRE2RENAME_PORT_RDTYPE] = ROB_PeekData[gr][`ROB_UOP_RDTYPE];
        assign RetireRAT_Update[gr][`RETIRE2RENAME_PORT_WE]     = (WillBeRetired[gr] ? ROB_PeekData[gr][`ROB_REG_WE] : 1'b0);
        assign RetireRAT_Update[gr][`RETIRE2RENAME_PORT_PRD]    = ROB_PeekData[gr][`ROB_UOP_PRD];

        assign RetireRAT_Update_Bus[gr*`RETIRE2RENAME_PORT_LEN+:`RETIRE2RENAME_PORT_LEN] = RetireRAT_Update[gr];
    end
endgenerate


//generate output for StallLockRelease signal.
//StallLockRelease is asserted when instr which will be retired with
//'UOP_STALL_TILL_RETIRE' bit set will be retired.
integer sl;
always @* begin
    StallLockRelease = 1'b0;
    for(sl=0; sl<`RETIRE_RATE; sl=sl+1) begin
        if(WillBeRetired[sl] && ROB_PeekData[sl][`ROB_STALL_TILL_RETIRE])
            StallLockRelease = 1'b1;
    end
end


//assign data for updating fcsr_fflags. fflags from latest FP instr which will
//be retired is sent to SysCtl Unit for updating CSR
reg  [4:0]  final_fcsr_fflags;
reg         final_fcsr_we;
reg         final_fpu_dirty;
integer f;
always @* begin
    final_fcsr_we     = 1'b0;
    final_fcsr_fflags = 0;
    final_fpu_dirty   = 1'b0;
    for(f=0; f<`RETIRE_RATE; f=f+1) begin
        if(WillBeRetired[f] && IsFPU[f] && fcsr_WE[f]) begin
            final_fcsr_we     = 1'b1;
            final_fcsr_fflags = fcsr_fflags[f];
        end
        if(WillBeRetired[f] && IsFPU[f] && FPU_dirty[f])
            final_fpu_dirty   = 1'b1;
    end
end
assign Retire2SysCtl_Bus[`RETIRE2SYSCTL_FPU_DIRTY]  = final_fpu_dirty;
assign Retire2SysCtl_Bus[`RETIRE2SYSCTL_FCSR_WE]    = final_fcsr_we;
assign Retire2SysCtl_Bus[`RETIRE2SYSCTL_FCSR]       = final_fcsr_fflags;


//generate Retire Branch Mask & Taken if branch is going to be retired.
//ith bit of BranchMask=1 => ith retiring instr is branch
//ith bit of BranchTaken=1 => ith retiring branch direction was taken
genvar gb;
generate
    for(gb=0; gb<`RETIRE_RATE; gb=gb+1) begin
        assign Retire_BranchMask[gb]  = WillBeRetired[gb] & IsBranch[gb];
        assign Retire_BranchTaken[gb] = BranchTaken[gb];
    end
endgenerate


//generate Stores Retired responses to LSU Unit;
wire [`RETIRE2LSU_PORT_LEN-1:0]     Retire2LSU[0:`RETIRE_RATE-1];
genvar gsb;
generate
    for(gsb=0; gsb<`RETIRE_RATE; gsb=gsb+1) begin
        assign Retire2LSU[gsb][`RETIRE2LSU_PORT_VALID] = IsStore[gsb] & WillBeRetired[gsb];
        assign Retire2LSU[gsb][`RETIRE2LSU_PORT_SBIDX] = SB_Idx[gsb];

        assign Retire2LSU_Bus[gsb*`RETIRE2LSU_PORT_LEN+:`RETIRE2LSU_PORT_LEN] = Retire2LSU[gsb];
    end
endgenerate


`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;
    reg [(10*8)-1:0] MetaStr = "<>";
    `ifdef DEBUG_RETIRE
        always @(negedge clk) begin
            `ifdef DEBUG_RETIRE_STS
            $display("[%t] RETIRE@STS##: ROB_UsedCnt=%0d RetireCnt=%0d StallLockRelease=%b",$time,
                ROB_UsedEntries, RetireCnt, StallLockRelease);
            `endif

            for (Di=0; Di<`RETIRE_RATE; Di=Di+1) begin
                if(WillBeRetired[Di]) begin
                    if(IsBranch[Di])
                        $sformat(MetaStr, "BrTkn=%b", BranchTaken[Di]);
                    else if(fcsr_WE[Di])
                        $sformat(MetaStr, "fflag=%b", fcsr_fflags[Di]);
                    else if(IsStore[Di])
                        $sformat(MetaStr, "SBidx=%0d", SB_Idx[Di]);
                    else if(IsSYS[Di]&&IsXRET[Di])
                        $sformat(MetaStr, "%cRET", RETmode[Di]==`PRIV_LVL_M ? "M" : RETmode[Di]==`PRIV_LVL_S ? "S" : "U");
                    else
                        $sformat(MetaStr, "");

                    $display("[%t] RETIRE@#####: PC=%h (0x%h) ROB=%3d | %s: p%0d->p%0d | %s",$time,
                        ROB_PeekData[Di][`ROB_PC], ROB_PeekData[Di][`ROB_INSTR], (Dispatch_Unit.ROB.rd_ptr+Di)%`ROB_DEPTH,
                        PrintReg(ROB_PeekData[Di][`ROB_UOP_RD],ROB_PeekData[Di][`ROB_UOP_RDTYPE]),
                            Rename_Unit.Retire_RAT.FreeList_old_prd[Di],
                            (ROB_PeekData[Di][`ROB_REG_WE] ? ROB_PeekData[Di][`ROB_UOP_PRD] : 1'bx),
                        MetaStr
                    );
                end
            end
        end
    `endif
`endif

endmodule

