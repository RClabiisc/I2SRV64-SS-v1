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
module IALU
(
    input  wire clk,
    input  wire rst,

    input  wire Flush,

    //Branch Mispredition Inputs
    input  wire                         Kill_Enable,
    input  wire [`SPEC_STATES-1:0]      Kill_VKillMask,

    //Inputs from scheduler port (S2E)
    input  wire                         Port_Valid,
    input  wire [`PORT_S2E_LEN-1:0]     Port_S2E,

    //Outputs to scheduler port (E2S)
    output wire                         Ready,

    //Wakeup Bus Outputs
    output reg  [`WAKEUP_RESP_LEN-1:0]  WakeupResp,

    //Result Bus Outputs
    output reg  [`RESULT_LEN-1:0]       ResultBus

);

//extract individual wires from Port S2E (Only required Controls)
wire [`UOP_CONTROL_LEN-1:0]     Controls = Port_S2E[`PORT_S2E_CONTROLS];
wire                            IsLUI   = Controls[`UOP_INT_IS_LUI];
wire                            IsAUIPC = Controls[`UOP_INT_IS_AUIPC];
wire [3:0]                      AluOp;
wire                            IsWord  = Controls[`UOP_INT_IS_WORD];

wire [63:0]                     op1 = Port_S2E[`PORT_S2E_OP1];
wire [63:0]                     op2 = Port_S2E[`PORT_S2E_OP2];
wire [63:0]                     PC  = Port_S2E[`PORT_S2E_PC];


///////////////////////////////////////////////////////////////////////////////
wire [63:0] result_add, result_add64, result_sub, result_sub64, result_slt, result_sltu, result_xor, result_or, result_and;

assign result_add64 = op1 + op2;
assign result_add   = (IsWord==1'b1) ? {{32{result_add64[31]}},result_add64[31:0]} : result_add64;

assign result_sub64 = op1 - op2;
assign result_sub   = (IsWord==1'b1) ? {{32{result_sub64[31]}},result_sub64[31:0]}: result_sub64;

assign result_slt  = ($signed(op1) < $signed(op2)) ? 64'd1 : 64'd0;

assign result_sltu = ((op1) < (op2)) ? 64'd1 : 64'd0;

assign result_xor  = op1 ^ op2;

assign result_and  = op1 & op2;

assign result_or   = op1 | op2;

//Shifting Logic
wire [63:0] BarrelInput, BarrelOutput, result_shifter;
wire [5:0]  shamt;

wire IsLeft  = (AluOp==`INT_ALUOP_SLL);
wire IsArith = (AluOp==`INT_ALUOP_SRA);

assign BarrelInput      = IsWord ? (IsArith ? {{32{op1[31]}},op1[31:0]} : {{32{1'b0}},op1[31:0]}) : op1;
assign shamt            = IsWord ? {1'b0,op2[4:0]} : op2[5:0];
assign result_shifter   = IsWord ? {{32{BarrelOutput[31]}},BarrelOutput[31:0]} : BarrelOutput;

Shifter64 Shifter64
(
    .op1     (BarrelInput   ),
    .shamt   (shamt         ),
    .IsLeft  (IsLeft        ),
    .IsArith (IsArith       ),
    .out     (BarrelOutput  )
);


//Alu Operation (If LUI or AUIPC then AluOp is just Add as operands are
//already taken considered in Issue Unit. i.e. op1 is PC already if IsAUIPC is
//set
assign AluOp = (IsLUI | IsAUIPC) ? `INT_ALUOP_ADD : Controls[`UOP_INT_ALUOP];

//Final Mux
reg [63:0] ialu_result;
always @* begin
    case(AluOp)
        `INT_ALUOP_ADD:  ialu_result = result_add;
        `INT_ALUOP_SUB:  ialu_result = result_sub;
        `INT_ALUOP_SLL:  ialu_result = result_shifter;
        `INT_ALUOP_SLT:  ialu_result = result_slt;
        `INT_ALUOP_SLTU: ialu_result = result_sltu;
        `INT_ALUOP_XOR:  ialu_result = result_xor;
        `INT_ALUOP_SRL:  ialu_result = result_shifter;
        `INT_ALUOP_SRA:  ialu_result = result_shifter;
        `INT_ALUOP_OR:   ialu_result = result_or;
        `INT_ALUOP_AND:  ialu_result = result_and;
        default:         ialu_result = 0;
    endcase
end


//Branch Misprediction Handling. When branch mispredicted, the instr in
//Execute Unit can be killed if Killmask matches
wire Killed = Kill_Enable & |(Port_S2E[`PORT_S2E_KILLMASK] & Kill_VKillMask);


//Output Registering (to reduce critical path)
//Result & Wakeup Bus outputs
always @(*) begin
    if(rst | Flush | Killed) begin
        WakeupResp = 0;
        ResultBus  = 0;
    end
    else if(Port_Valid) begin
        WakeupResp[`WAKEUP_RESP_VALID]      = 1'b1;
        WakeupResp[`WAKEUP_RESP_PRD_TYPE]   = Port_S2E[`PORT_S2E_PRD_TYPE];
        WakeupResp[`WAKEUP_RESP_PRD]        = Port_S2E[`PORT_S2E_PRD];
        WakeupResp[`WAKEUP_RESP_REG_WE]     = Port_S2E[`PORT_S2E_REG_WE];
        WakeupResp[`WAKEUP_RESP_ROB_INDEX]  = Port_S2E[`PORT_S2E_ROB_INDEX];
        WakeupResp[`WAKEUP_RESP_EXCEPTION]  = 1'b0;
        WakeupResp[`WAKEUP_RESP_ECAUSE]     = 0;
        WakeupResp[`WAKEUP_RESP_METADATA]   = 0;

        ResultBus[`RESULT_VALID]            = 1'b1;
        ResultBus[`RESULT_REG_WE]           = Port_S2E[`PORT_S2E_REG_WE];
        ResultBus[`RESULT_PRD_TYPE]         = Port_S2E[`PORT_S2E_PRD_TYPE];
        ResultBus[`RESULT_PRD]              = Port_S2E[`PORT_S2E_PRD];
        ResultBus[`RESULT_VALUE]            = ialu_result;
    end
    else begin
        WakeupResp  = 0;
        ResultBus   = 0;
    end
end


//assign Ready output
assign Ready = 1'b1; //As IALU is single cycle. It will be always ready

`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;
    `ifdef DEBUG_FU_RESULT
        always @(negedge clk) begin
            if(Killed & Port_Valid) begin
                $display("[%t] RESULT@IALU#: PC=%h ROB=%d | Killed",$time,
                    Port_S2E[`PORT_S2E_PC], Port_S2E[`PORT_S2E_ROB_INDEX]);
            end
            else if(Port_Valid) begin
                $display("[%t] RESULT@IALU#: PC=%h ROB=%d |%b %s->p%0d=%h | op1=%h op2=%h ",$time,
                    Port_S2E[`PORT_S2E_PC], Port_S2E[`PORT_S2E_ROB_INDEX],
                    Port_S2E[`PORT_S2E_REG_WE], PrintReg(Dispatch_Unit.ROB.ROB[Port_S2E[`PORT_S2E_ROB_INDEX]][`ROB_UOP_RD],Port_S2E[`PORT_S2E_PRD_TYPE]),
                        Port_S2E[`PORT_S2E_PRD], ialu_result,
                    Port_S2E[`PORT_S2E_OP1], Port_S2E[`PORT_S2E_OP2]);
            end
        end
    `endif
`endif


endmodule


module Shifter64
(
    input  wire [63:0]  op1,
    input  wire [5:0]   shamt,
    input  wire         IsLeft,
    input  wire         IsArith,
    output wire [63:0]  out
);

wire [63:0] level[0:6];
assign level[0] = op1;
//                                            SLL                                     SRA                          SRL
//                                              V                                       V                           V
assign level[1] = shamt[0] ? (IsLeft ? {level[0][62:0], 1'b0} : (IsArith ? {{ 1{level[0][63]}},level[0][63: 1]} : { 1'b0,level[0][63: 1]})) : level[0] ;
assign level[2] = shamt[1] ? (IsLeft ? {level[1][61:0], 2'b0} : (IsArith ? {{ 2{level[1][63]}},level[1][63: 2]} : { 2'b0,level[1][63: 2]})) : level[1] ;
assign level[3] = shamt[2] ? (IsLeft ? {level[2][59:0], 4'b0} : (IsArith ? {{ 4{level[2][63]}},level[2][63: 4]} : { 4'b0,level[2][63: 4]})) : level[2] ;
assign level[4] = shamt[3] ? (IsLeft ? {level[3][55:0], 8'b0} : (IsArith ? {{ 8{level[3][63]}},level[3][63: 8]} : { 8'b0,level[3][63: 8]})) : level[3] ;
assign level[5] = shamt[4] ? (IsLeft ? {level[4][47:0],16'b0} : (IsArith ? {{16{level[4][63]}},level[4][63:16]} : {16'b0,level[4][63:16]})) : level[4] ;
assign level[6] = shamt[5] ? (IsLeft ? {level[5][31:0],32'b0} : (IsArith ? {{32{level[5][63]}},level[5][63:32]} : {32'b0,level[5][63:32]})) : level[5] ;

assign out = level[6];
endmodule
