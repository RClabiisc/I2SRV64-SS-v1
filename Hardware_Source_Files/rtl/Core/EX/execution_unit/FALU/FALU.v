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
`include "bus_defines.vh"

(* keep_hierarchy = "yes" *)
module FALU
#(
    parameter MULTI_CYCLES_ADD_SP  = 3,  //FIXME
    parameter MULTI_CYCLES_ADD_DP  = 4,  //FIXME
    parameter MULTI_CYCLES_SQRT_SP = 5,  //FIXME
    parameter MULTI_CYCLES_SQRT_DP = 12, //FIXME
    parameter MULTI_CYCLES_CMP_SP  = 1,  //FIXME
    parameter MULTI_CYCLES_CMP_DP  = 1,  //FIXME
    parameter MULTI_CYCLES_CNV_SP  = 1,  //FIXME
    parameter MULTI_CYCLES_CNV_DP  = 1,  //FIXME
    parameter MULTI_CYCLES_TRN_SP  = 1,  //FIXME
    parameter MULTI_CYCLES_TRN_DP  = 1   //FIXME
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
wire                            IsWord       = Controls[`UOP_FPU_IS_WORD];
wire [2:0]                      FpuOp        = Controls[`UOP_FPU_OP];
wire [2:0]                      FpuSubop     = Controls[`UOP_FPU_SUBOP];
wire                            IsSubtract   = (FpuOp==`FPU_OP_ALU) && (FpuSubop==`FPU_SUBOP_ALU_SUB);
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
        if((FpuOp==`FPU_OP_CMP) || (FpuOp==`FPU_OP_TRN) ||
            ((FpuOp==`FPU_OP_CNV) && ((FpuSubop==`FPU_SUBOP_CNV_SI) || (FpuSubop==`FPU_SUBOP_CNV_SINEG) || (FpuSubop==`FPU_SUBOP_CNV_SI))) ) begin
            RMException = 1'b0;
        end
        else
            RMException = 1'b1;
    else
        RMException = 1'b0;
end

//generate operands based on precision after converting to flopoco from ieee
wire [63:0] op1 = Port_S2E[`PORT_S2E_OP1];
wire [63:0] op2 = Port_S2E[`PORT_S2E_OP2];

wire [63:0] op1e_dp = op1;                 // IEEE DP op1
wire [63:0] op2e_dp = op2;                 // IEEE DP op2

wire [31:0] op1e_sp = op1[31:0];           // IEEE SP op1
wire [31:0] op2e_sp = op2[31:0];           // IEEE SP op2

wire [65:0] op1f_dp, op2f_dp, op2f_neg_dp; // Flopoco DP op1, Flopoco DP op2
wire [33:0] op1f_sp, op2f_sp, op2f_neg_sp; // Flopoco SP op1, Floating SP op2

IEEE_TO_FLOPOCO_SP ieee_to_flopoco_sp_op1 (op1e_sp,op1f_sp);
IEEE_TO_FLOPOCO_SP ieee_to_flopoco_sp_op2 (op2e_sp,op2f_sp);
IEEE_TO_FLOPOCO_DP ieee_to_flopoco_dp_op1 (op1e_dp,op1f_dp);
IEEE_TO_FLOPOCO_DP ieee_to_flopoco_dp_op2 (op2e_dp,op2f_dp);

//generate negative op2 as required by SUB
assign op2f_neg_dp = {op2f_dp[65:64],~op2f_dp[62],op2f_dp[62:0]};   //flip sign bit
assign op2f_neg_sp = {op2f_sp[33:32],~op2f_sp[31],op2f_sp[30:0]};   //flip sign bit

///////////////////////////////////////////////////////////////////////////////
//Interconnect Wires
wire [65:0] add_result_flopoco, sqrt_result_flopoco;
wire [63:0] cmp_result, cnv_result, trn_result;

wire [`FCSR_FFLAGS_LEN-1:0]  add_fflag, sqrt_fflag, cmp_fflag, cnv_fflag, trn_fflag;

//Instantiating Sub Functional Units
FALU_ADD FALU_ADD
(
    .INPUT_1       (IsDouble ? op1f_dp : {32'd0, op1f_sp}),
    .INPUT_2       (IsDouble ? op2f_dp : {32'd0, op2f_sp}),
    .Rounding_Mode (RoundingMode              ),
    .IsDouble      (IsDouble                  ),
    .IsSubtract    (IsSubtract                ),
    .OUTPUT        (add_result_flopoco        ),
    .INVALID       (add_fflag[`FCSR_FFLAGS_NV]),
    .OVERFLOW      (add_fflag[`FCSR_FFLAGS_OF]),
    .UNDERFLOW     (add_fflag[`FCSR_FFLAGS_UF]),
    .INEXACT       (add_fflag[`FCSR_FFLAGS_NX])
);
assign add_fflag[`FCSR_FFLAGS_DZ] = 1'b0;

FALU_SQRT FALU_SQRT
(
    .INPUT         (IsDouble ? op1f_dp : {32'd0, op1f_sp}),
    .Rounding_Mode (RoundingMode               ),
    .IsDouble      (IsDouble                   ),
    .OUTPUT        (sqrt_result_flopoco        ),
    .INVALID       (sqrt_fflag[`FCSR_FFLAGS_NV]),
    .OVERFLOW      (sqrt_fflag[`FCSR_FFLAGS_OF]),
    .UNDERFLOW     (sqrt_fflag[`FCSR_FFLAGS_UF]),
    .INEXACT       (sqrt_fflag[`FCSR_FFLAGS_NX])
);
assign sqrt_fflag[`FCSR_FFLAGS_DZ] = 1'b0;

FALU_CMP FALU_CMP
(
    .INPUT_1   (op1                       ),
    .INPUT_2   (op2                       ),
    .IsDouble  (IsDouble                  ),
    .OPERATION (FpuSubop                  ),
    .OUTPUT    (cmp_result                ),
    .INVALID   (cmp_fflag[`FCSR_FFLAGS_NV])
);
assign cmp_fflag[`FCSR_FFLAGS_OF] = 1'b0;
assign cmp_fflag[`FCSR_FFLAGS_UF] = 1'b0;
assign cmp_fflag[`FCSR_FFLAGS_NX] = 1'b0;
assign cmp_fflag[`FCSR_FFLAGS_DZ] = 1'b0;

FALU_CNV FALU_CNV
(
    .INPUT_1       (op1                       ),
    .INPUT_2       (op2                       ),
    .Rounding_Mode (RoundingMode              ),
    .IsDouble      (IsDouble                  ),
    .IsWord        (IsWord                    ),
    .SubOp         (FpuSubop                  ),
    .OUTPUT        (cnv_result                ),
    .INVALID       (cnv_fflag[`FCSR_FFLAGS_NV]),
    .OVERFLOW      (cnv_fflag[`FCSR_FFLAGS_OF]),
    .UNDERFLOW     (cnv_fflag[`FCSR_FFLAGS_UF]),
    .INEXACT       (cnv_fflag[`FCSR_FFLAGS_NX])
);
assign cnv_fflag[`FCSR_FFLAGS_DZ] = 1'b0;

FALU_TRN FALU_TRN
(
    .INPUT     (op1       ),
    .IsDouble  (IsDouble  ),
    .OPERATION (FpuSubop  ),
    .OUTPUT    (trn_result)
);
assign trn_fflag = 0;


//convert flopoco output from adder & sqrt IP to IEEE
wire [65:0] addsqrt_result_flopoco = (FpuOp==`FPU_OP_SQRT) ? sqrt_result_flopoco : add_result_flopoco;
wire [63:0] addsqrt_result_dp_ieee;
wire [31:0] addsqrt_result_sp_ieee;

//convert flopoco result to IEEE format
FLOPOCO_TO_IEEE_DP flopoco_to_ieee_dp (addsqrt_result_flopoco,addsqrt_result_dp_ieee);
FLOPOCO_TO_IEEE_SP flopoco_to_ieee_sp (addsqrt_result_flopoco[33:0],addsqrt_result_sp_ieee);

//mux result accoding to data type
wire [63:0] addsqrt_result = IsDouble ? addsqrt_result_dp_ieee : {32'd0, addsqrt_result_sp_ieee};

///////////////////////////////////////////////////////////////////////////////
//final flag generation logic & final result generation logic
reg                        fflags_we;
reg [`FCSR_FFLAGS_LEN-1:0] fflags;
reg [63:0]                 falu_result;
always @* begin
    case(FpuOp)
        `FPU_OP_ALU: begin
            fflags      = add_fflag;
            falu_result = addsqrt_result;
            fflags_we   = 1'b1;
        end

        `FPU_OP_SQRT: begin
            fflags      = sqrt_fflag;
            falu_result = addsqrt_result;
            fflags_we   = 1'b1;
        end

        `FPU_OP_CNV: begin
            fflags      = cnv_fflag;
            falu_result = cnv_result;
            fflags_we   = !((FpuSubop==`FPU_SUBOP_CNV_SI)||(FpuSubop==`FPU_SUBOP_CNV_SINEG)||(FpuSubop==`FPU_SUBOP_CNV_SIXOR));
        end

        `FPU_OP_CMP: begin
            fflags      = cmp_fflag;
            falu_result = cmp_result;
            fflags_we   = 1'b1;
        end

        `FPU_OP_TRN: begin
            fflags      = trn_fflag;
            falu_result = trn_result;
            fflags_we   = 1'b0;
        end

        default: begin
            fflags      = 0;
            falu_result = 0;
            fflags_we   = 1'b0;
        end
    endcase
end


///////////////////////////////////////////////////////////////////////////////
//Branch Misprediction Handling. When branch mispredicted, the instr in
//Execute Unit can be killed if Killmask matches
wire Killed = Kill_Enable & |(Port_S2E[`PORT_S2E_KILLMASK] & Kill_VKillMask);

//Multicycle path control logic
reg  [$clog2(MULTI_CYCLES_SQRT_DP):0] count;
reg  [$clog2(MULTI_CYCLES_SQRT_DP):0] count_check;
always @* begin
    case(FpuOp)
        `FPU_OP_ALU:  count_check = (IsDouble ? MULTI_CYCLES_ADD_DP-1  : MULTI_CYCLES_ADD_SP-1);
        `FPU_OP_SQRT: count_check = (IsDouble ? MULTI_CYCLES_SQRT_DP-1 : MULTI_CYCLES_SQRT_SP-1);
        `FPU_OP_CNV:  count_check = (IsDouble ? MULTI_CYCLES_CNV_DP-1  : MULTI_CYCLES_CNV_SP-1);
        `FPU_OP_CMP:  count_check = (IsDouble ? MULTI_CYCLES_CMP_DP-1  : MULTI_CYCLES_CMP_SP-1);
        `FPU_OP_TRN:  count_check = (IsDouble ? MULTI_CYCLES_TRN_DP-1  : MULTI_CYCLES_TRN_SP-1);
        default: count_check = 0;
    endcase
end

wire completed = (count==count_check);
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
    metadata_d[`METADATA_FPUOP__FFLAGS_WE] = fflags_we;
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
        ResultBus[`RESULT_VALUE]            = falu_result;
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
                $display("[%t] RESULT@FALU#: PC=%h ROB=%d | Killed",$time,
                    Port_S2E[`PORT_S2E_PC], Port_S2E[`PORT_S2E_ROB_INDEX]);
            end
            else if(completed) begin
                $display("[%t] RESULT@FALU#: PC=%h ROB=%d |%b %s->p%0d=%h | op1=%h op2=%h | flg=%b E=%b",$time,
                    Port_S2E[`PORT_S2E_PC], Port_S2E[`PORT_S2E_ROB_INDEX],
                    Port_S2E[`PORT_S2E_REG_WE], PrintReg(Dispatch_Unit.ROB.ROB[Port_S2E[`PORT_S2E_ROB_INDEX]][`ROB_UOP_RD],Port_S2E[`PORT_S2E_PRD_TYPE]),
                        Port_S2E[`PORT_S2E_PRD], falu_result,
                    Port_S2E[`PORT_S2E_OP1], Port_S2E[`PORT_S2E_OP2],
                    metadata_d[`FCSR_FFLAGS_LEN-1:0], RMException
                );
            end
        end
    `endif
`endif

endmodule

