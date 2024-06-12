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
module FMUL
#(
    parameter MULTI_CYCLES_MUL_SP = 2,  //FIXME
    parameter MULTI_CYCLES_MUL_DP = 3,  //FIXME
    parameter MULTI_CYCLES_FMA_SP = 6,  //FIXME
    parameter MULTI_CYCLES_FMA_DP = 8   //FIXME
)
(
    input  wire clk,
    input  wire rst,

    input  wire Flush,

    //Branch Mispredition Inputs
    input  wire                         Kill_Enable,
    input  wire [`SPEC_STATES-1:0]      Kill_VKillMask,

    //Rounding Mode Input from CSR
    input  wire [2:0]                   fcsr_frm,

    //Inputs from scheduler port (S2E)
    input  wire                         Port_Valid,
    input  wire [`PORT_S2E_LEN-1:0]     Port_S2E,

    //Outputs to scheduler port (E2S)
    output reg                          Ready,

    //Wakeup Bus Outputs
    output reg  [`WAKEUP_RESP_LEN-1:0]  WakeupResp,

    //Result Bus Outputs
    output reg  [`RESULT_LEN-1:0]       ResultBus

);

//extract individual wires from Port S2E (Only required Controls)
wire [`UOP_CONTROL_LEN-1:0]     Controls     = Port_S2E[`PORT_S2E_CONTROLS];
wire                            IsDouble     = Controls[`UOP_FPU_IS_DP];
wire [2:0]                      FpuOp        = Controls[`UOP_FPU_OP];
wire [2:0]                      FpuSubop     = Controls[`UOP_FPU_SUBOP];
wire                            IsFMA        = (FpuOp==`FPU_OP_FMA);
wire                            IsSubtract   = (FpuSubop==`FPU_SUBOP_FMSUB) | (FpuSubop==`FPU_SUBOP_FNMSUB);
wire                            NegAddResult = (FpuSubop==`FPU_SUBOP_FNMADD) | (FpuSubop==`FPU_SUBOP_FNMSUB);
wire [63:0]                     PC           = Port_S2E[`PORT_S2E_PC];


//rounding mode logic
reg [2:0]   RoundingMode;   //Final Rounding Mode to be used
reg         RMException;    //Rounding Mode Exception
always @* begin
    if(Controls[`UOP_FPU_ROUND]==3'b111) //dynamic rounding mode
        RoundingMode = fcsr_frm;
    else
        RoundingMode = Controls[`UOP_FPU_ROUND];

    //check if final Rounding mode is valid
    if(RoundingMode>3'b100) //HACK: 101, 110, 111 are invalid
        RMException = 1'b1;
    else
        RMException = 1'b0;
end

//generate operands based on precision after converting to flopoco from ieee
wire [63:0] op1 = Port_S2E[`PORT_S2E_OP1];
wire [63:0] op2 = Port_S2E[`PORT_S2E_OP2];

wire [63:0] op1e_dp = (IsDouble==1'b1) ? op1 : 0;           //IEEE DP
wire [63:0] op2e_dp = (IsDouble==1'b1) ? op2 : 0;           //IEEE DP

wire [31:0] op1e_sp = (IsDouble==1'b0) ? op1[31:0] : 0;     //IEEE SP
wire [31:0] op2e_sp = (IsDouble==1'b0) ? op2[31:0] : 0;     //IEEE SP

wire [65:0] op1f_dp, op2f_dp, mul_result_dp_flopoco;       //Flopoco DP Result
wire        mul_dp_inexact;
wire [33:0] op1f_sp, op2f_sp, mul_result_sp_flopoco;       //Flopoco SP Result
wire        mul_sp_inexact;

//inputs for additional adder unit required by fused multiply operations
wire [63:0] op3 = Port_S2E[`PORT_S2E_OP3];

wire [63:0] op3e_dp = (IsDouble==1'b1) ? op3 : 0;           //IEEE DP
wire [31:0] op3e_sp = (IsDouble==1'b0) ? op3[31:0] : 0;     //IEEE SP

wire [65:0] op3f_dp, op3f_neg_dp, add_result_dp_flopoco, add_result_neg_dp_flopoco;
wire        add_dp_inexact;
wire [33:0] op3f_sp, op3f_neg_sp, add_result_sp_flopoco, add_result_neg_sp_flopoco;
wire        add_sp_inexact;

IEEE_TO_FLOPOCO_SP ieee_to_flopoco_sp_op1 (op1e_sp,op1f_sp);
IEEE_TO_FLOPOCO_SP ieee_to_flopoco_sp_op2 (op2e_sp,op2f_sp);
IEEE_TO_FLOPOCO_SP ieee_to_flopoco_sp_op3 (op3e_sp,op3f_sp);
IEEE_TO_FLOPOCO_DP ieee_to_flopoco_dp_op1 (op1e_dp,op1f_dp);
IEEE_TO_FLOPOCO_DP ieee_to_flopoco_dp_op2 (op2e_dp,op2f_dp);
IEEE_TO_FLOPOCO_DP ieee_to_flopoco_dp_op3 (op3e_dp,op3f_dp);

//generate negative op3 as required by MSUB and NMSUB
//also negate result as required by NMADD and NMSUB
assign op3f_neg_dp = {op3f_dp[65:64],~op3f_dp[63],op3f_dp[62:0]};   //flip sign bit
assign op3f_neg_sp = {op3f_sp[33:32],~op3f_sp[31],op3f_sp[30:0]};   //flip sign bit
assign add_result_neg_dp_flopoco = {add_result_dp_flopoco[65:64],~add_result_dp_flopoco[63],add_result_dp_flopoco[62:0]};
assign add_result_neg_sp_flopoco = {add_result_sp_flopoco[33:32],~add_result_sp_flopoco[31],add_result_sp_flopoco[30:0]};


//Flopoco IP instantiation
(* keep_hierarchy = "yes" *)
FPMult_8_23_8_23_8_23_comb_uid2 FPMULT_SP
(
    .X(op1f_sp),
    .Y(op2f_sp),
    .RM(RoundingMode),
    .R(mul_result_sp_flopoco),
    .INEXACT(mul_sp_inexact)
);

(* keep_hierarchy = "yes" *)
FPMult_11_52_11_52_11_52_comb_uid2 FPMULT_DP
(
    .X(op1f_dp),
    .Y(op2f_dp),
    .RM(RoundingMode),
    .R(mul_result_dp_flopoco),
    .INEXACT(mul_dp_inexact)
);

(* keep_hierarchy = "yes" *)
FPAdd_8_23_comb_uid2 FMAADD_SP
(
    .X(mul_result_sp_flopoco),
    .Y(IsSubtract ? op3f_neg_sp : op3f_sp),
    .RM(RoundingMode),
    .R(add_result_sp_flopoco),
    .INEXACT(add_sp_inexact)
);

(* keep_hierarchy = "yes" *)
FPAdd_11_52_comb_uid2 FMAADD_DP
(
    .X(mul_result_dp_flopoco),
    .Y(IsSubtract ? op3f_neg_dp : op3f_dp),
    .RM(RoundingMode),
    .R(add_result_dp_flopoco),
    .INEXACT(add_dp_inexact)
);


//final result assembly
wire [65:0] fmul_result_dp_flopoco = (IsFMA) ? (NegAddResult ? add_result_neg_dp_flopoco : add_result_dp_flopoco) : mul_result_dp_flopoco;
wire [33:0] fmul_result_sp_flopoco = (IsFMA) ? (NegAddResult ? add_result_neg_sp_flopoco : add_result_sp_flopoco) : mul_result_sp_flopoco;
wire [63:0] fmul_result_dp_ieee;
wire [31:0] fmul_result_sp_ieee;

//convert flopoco result to IEEE format
FLOPOCO_TO_IEEE_DP flopoco_to_ieee_dp (fmul_result_dp_flopoco,fmul_result_dp_ieee);
FLOPOCO_TO_IEEE_SP flopoco_to_ieee_sp (fmul_result_sp_flopoco,fmul_result_sp_ieee);

//mux result according to precision cosidering case of NaN Boxing of Narrower Values (User Spec 12.2)
wire [63:0] fmul_result = IsDouble ? fmul_result_dp_ieee : {32'hFFFFFFFF,fmul_result_sp_ieee};


///////////////////////////////////////////////////////////////////////////////
//flag generation logic
reg [`FCSR_FFLAGS_LEN-1:0] fflags;

//Inexact (bit 0 : NX)
always @* begin
    if(IsFMA)
        fflags[`FCSR_FFLAGS_NX] = (IsDouble==1'b1) ? (mul_dp_inexact|add_dp_inexact) : (mul_sp_inexact|add_sp_inexact);
    else
        fflags[`FCSR_FFLAGS_NX] = (IsDouble==1'b1) ? mul_dp_inexact : mul_sp_inexact;
end

//Underflow & Overflow (bit1:UF & bit2:OF)
//For UF & OF flags if FMA type intruction then use adder result to generate
//these flags. If only MUL type instruction then use multiplier result to
//generate flags
wire [1:0] ExcessBits = (IsFMA) ? (IsDouble ? add_result_dp_flopoco[65:64] : add_result_sp_flopoco[33:32]) :
                                  (IsDouble ? mul_result_dp_flopoco[65:64] : mul_result_sp_flopoco[33:32]);

wire ExpoZero = (IsFMA) ? (IsDouble ? ~|add_result_dp_flopoco[62:52] : ~|add_result_sp_flopoco[30:23]) :
                          (IsDouble ? ~|mul_result_dp_flopoco[62:52] : ~|mul_result_sp_flopoco[30:23]);
always @(*) begin
    case(ExcessBits)
        2'b00 : begin
            fflags[`FCSR_FFLAGS_OF] = 1'b0;
            fflags[`FCSR_FFLAGS_UF] = 1'b1;
        end

        2'b01 : begin
            fflags[`FCSR_FFLAGS_OF] = 1'b0;
            fflags[`FCSR_FFLAGS_UF] = ExpoZero;
        end

        2'b10 : begin
            fflags[`FCSR_FFLAGS_OF] = 1'b1;
            fflags[`FCSR_FFLAGS_UF] = 1'b0;
        end

        default: begin
            fflags[`FCSR_FFLAGS_OF] = 1'b0;
            fflags[`FCSR_FFLAGS_UF] = 1'b0;
        end
    endcase
end

wire [1:0] op1_ExcessBits        = IsDouble ? op1f_dp[65:64] : op1f_sp[33:32];
wire [1:0] op2_ExcessBits        = IsDouble ? op2f_dp[65:64] : op2f_sp[33:32];
wire [1:0] op3_ExcessBits        = IsDouble ? op3f_dp[65:64] : op3f_sp[33:32];
wire [1:0] mul_result_ExcessBits = IsDouble ? mul_result_dp_flopoco[65:64] : mul_result_sp_flopoco[33:32];

//Divide By Zero (Bit 3: DZ)
//Invalid (bit4 : NV)
wire op1_SNAN = IsDouble ? op1f_dp[51] : op1f_sp[22];
wire op2_SNAN = IsDouble ? op2f_dp[51] : op2f_sp[22];
wire op3_SNAN = IsDouble ? op3f_dp[51] : op3f_sp[22];
wire mul_result_SNAN = IsDouble ? mul_result_dp_flopoco[51] : mul_result_sp_flopoco[22];
reg mul_invalid, add_invalid;
always @(*) begin //TODO: Modified
    //Divide By Zero (Bit 3: DZ)
    fflags[`FCSR_FFLAGS_DZ] = 1'b0;    //No divide by zero in multiply

    //check invalid for multiplier
    if (    ((op1_ExcessBits==2'b11) && (op1_SNAN==1'b0))        ||
            ((op2_ExcessBits==2'b11) && (op2_SNAN==1'b0))        ||
            ((op1_ExcessBits==2'b00) && (op2_ExcessBits==2'b00)) ||
            ((op1_ExcessBits==2'b10) && (op2_ExcessBits==2'b10))    ) begin
            mul_invalid = 1'b1;
    end
    else
        mul_invalid = 1'b0;

    //check invalid for adder
    if (    ((mul_result_ExcessBits==2'b11) && (mul_result_SNAN==1'b0)) ||
            ((op3_ExcessBits==2'b11)        && (op3_SNAN==1'b0))        ||
            ((mul_result_ExcessBits==2'b00) && (op3_ExcessBits==2'b00)) ||
            ((mul_result_ExcessBits==2'b10) && (op3_ExcessBits==2'b10))    ) begin
            add_invalid = 1'b1;
    end
    else
        add_invalid = 1'b0;

    //final flag assignment
    fflags[`FCSR_FFLAGS_NV] = (IsFMA) ? (mul_invalid|add_invalid) : mul_invalid;
end


///////////////////////////////////////////////////////////////////////////////
//Branch Misprediction Handling. When branch mispredicted, the instr in
//Execute Unit can be killed if Killmask matches
wire Killed = Kill_Enable & |(Port_S2E[`PORT_S2E_KILLMASK] & Kill_VKillMask);

//Multicycle path control logic
reg  [$clog2(MULTI_CYCLES_FMA_DP):0] count;
wire completed = IsFMA ? (IsDouble ? (count==MULTI_CYCLES_FMA_DP-1) : (count==MULTI_CYCLES_FMA_SP-1)) :
                         (IsDouble ? (count==MULTI_CYCLES_MUL_DP-1) : (count==MULTI_CYCLES_MUL_SP-1));
always @(posedge clk) begin
    if(rst | Flush | Killed | completed) begin
        //required cycles completed or killed => reset the count
        count <= 0;
    end
    else if(Port_Valid) begin
        //instr is being executed
        count <= count + 1;
    end
end

always @* begin
    if(rst | Flush | Killed) begin
        Ready = 1'b1;
    end
    else if(Port_Valid & ~completed) begin
        //Now Func Unit is busy so NOT ready
        Ready = 1'b0;
    end
    else begin
        //required cycles completed => mark as ready
        Ready = 1'b1;
    end
end

reg  [`METADATA_LEN-1:0] metadata_d;
always @* begin
    metadata_d                             = 0;
    metadata_d[`METADATA_FPUOP_ID]         = 1'b1;
    metadata_d[`METADATA_FPUOP__DIRTY]     = (Port_S2E[`PORT_S2E_PRD_TYPE]==`REG_TYPE_FP) && (Port_S2E[`PORT_S2E_REG_WE]==1'b1);
    metadata_d[`METADATA_FPUOP__FFLAGS_WE] = 1'b1;
    metadata_d[`METADATA_FPUOP__FFLAGS]    = fflags;
end


//Result & Wakeup Bus outputs
always @(*) begin
    if(rst | Flush | Killed) begin
        WakeupResp  = 0;
        ResultBus   = 0;
    end
    else if(completed) begin
        WakeupResp[`WAKEUP_RESP_VALID]      = 1'b1;
        WakeupResp[`WAKEUP_RESP_PRD_TYPE]   = Port_S2E[`PORT_S2E_PRD_TYPE];
        WakeupResp[`WAKEUP_RESP_PRD]        = Port_S2E[`PORT_S2E_PRD];
        WakeupResp[`WAKEUP_RESP_REG_WE]     = Port_S2E[`PORT_S2E_REG_WE];
        WakeupResp[`WAKEUP_RESP_ROB_INDEX]  = Port_S2E[`PORT_S2E_ROB_INDEX];
        WakeupResp[`WAKEUP_RESP_EXCEPTION]  = RMException;

        //fflags are written in ROB metadata. Upon retirement retirement unit
        //write its to csr. Upon Illegal Instr Exception METADATA should be instr,
        //but we don't have instr now; so as per spec set it as 0;
        WakeupResp[`WAKEUP_RESP_ECAUSE]     = (RMException==1'b1) ? `EXC_ILLEGAL_INSTR : 0;
        WakeupResp[`WAKEUP_RESP_METADATA]   = (RMException==1'b1) ? 0 : metadata_d;

        ResultBus[`RESULT_VALID]            = 1'b1;
        ResultBus[`RESULT_REG_WE]           = Port_S2E[`PORT_S2E_REG_WE];
        ResultBus[`RESULT_PRD_TYPE]         = Port_S2E[`PORT_S2E_PRD_TYPE];
        ResultBus[`RESULT_PRD]              = Port_S2E[`PORT_S2E_PRD];

        ResultBus[`RESULT_VALUE]            = fmul_result;
    end
    else begin
        WakeupResp  = 0;
        ResultBus   = 0;
    end
end

`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;
    `ifdef DEBUG_FU_RESULT
        always @(negedge clk) begin
            if(Killed & Port_Valid) begin
                $display("[%t] RESULT@FMUL#: PC=%h ROB=%d | Killed",$time,
                    Port_S2E[`PORT_S2E_PC], Port_S2E[`PORT_S2E_ROB_INDEX]);
            end
            else if(completed) begin
                $display("[%t] RESULT@FMUL#: PC=%h ROB=%d |%b %s->p%0d=%h | op1=%h op2=%h op3=%h | flg=%b E=%b",$time,
                    Port_S2E[`PORT_S2E_PC], Port_S2E[`PORT_S2E_ROB_INDEX],
                    Port_S2E[`PORT_S2E_REG_WE], PrintReg(Dispatch_Unit.ROB.ROB[Port_S2E[`PORT_S2E_ROB_INDEX]][`ROB_UOP_RD],Port_S2E[`PORT_S2E_PRD_TYPE]),
                        Port_S2E[`PORT_S2E_PRD], fmul_result,
                    Port_S2E[`PORT_S2E_OP1], Port_S2E[`PORT_S2E_OP2], Port_S2E[`PORT_S2E_OP3],
                    metadata_d[`FCSR_FFLAGS_LEN-1:0], RMException
                );
            end
        end
    `endif
`endif

endmodule

