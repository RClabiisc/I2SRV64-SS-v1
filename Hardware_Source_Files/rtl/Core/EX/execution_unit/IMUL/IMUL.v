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
module IMUL
#(
    parameter MULTI_CYCLES_W = 2, //FIXME
    parameter MULTI_CYCLES_DW = 2 //FIXME
)
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
    output reg                          Ready,

    //Wakeup Bus Outputs
    output reg  [`WAKEUP_RESP_LEN-1:0]  WakeupResp,

    //Result Bus Outputs
    output reg  [`RESULT_LEN-1:0]       ResultBus

);

//extract individual wires from Port S2E (Only required Controls)
wire [`UOP_CONTROL_LEN-1:0]     Controls = Port_S2E[`PORT_S2E_CONTROLS];
wire [1:0]                      MulOp    = Controls[`UOP_INT_MULDIVOP];
wire                            IsWord   = Controls[`UOP_INT_IS_WORD];
wire [63:0]                     op1      = Port_S2E[`PORT_S2E_OP1];
wire [63:0]                     op2      = Port_S2E[`PORT_S2E_OP2];
wire [63:0]                     PC       = Port_S2E[`PORT_S2E_PC];


//interconnect wires
reg  [64:0]  mul_op1, mul_op2;
wire [129:0] intmul_result;


///////////////////////////////////////////////////////////////////////////////
//Assign inputs to Multiplier IP based on MulOp
always @* begin
    case(MulOp)
        `INT_MULOP_S: begin
            if(IsWord==1'b1) begin
                mul_op1 = {{33{op1[31]}},op1[31:0]};    //sign extended 32 bit
                mul_op2 = {{33{op2[31]}},op2[31:0]};    //sign extended 32 bit
            end
            else begin
                mul_op1 = {op1[63],op1};    //signed Lower
                mul_op2 = {op2[63],op2};    //signed Lower
            end
        end

        `INT_MULOP_H: begin
            mul_op1 = {op1[63],op1};    //signed Upper
            mul_op2 = {op2[63],op2};    //Signed Upper
        end

        `INT_MULOP_HU: begin
            mul_op1 = {1'b0,op1};   //Unsigned Upper
            mul_op2 = {1'b0,op2};   //Unsigned Upper
        end

        `INT_MULOP_HSU: begin
            mul_op1 = {op1[63],op1};    //Signed Upper rs1
            mul_op2 = {1'b0,op2};       //Unsigned Upper rs2
        end
    endcase
end

//Integer Multiplier IP Instantiation
(* keep_hierarchy = "yes" *)
IntMultiplier_UsingDSP_65_65_130_signed_comb_uid2 IMUL_65sx65s
(
    .X(mul_op1),
    .Y(mul_op2),
    .R(intmul_result)
);


//Branch Misprediction Handling. When branch mispredicted, the instr in
//Execute Unit can be killed if Killmask matches
wire Killed = Kill_Enable & |(Port_S2E[`PORT_S2E_KILLMASK] & Kill_VKillMask);


//Multicycle path control logic
reg  [$clog2(MULTI_CYCLES_DW):0] count;
wire                          completed = (IsWord==1'b1) ? (count==MULTI_CYCLES_W-1) : (count==MULTI_CYCLES_DW-1);
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

reg [63:0] imul_result;
always @(*) begin
    case(MulOp)
        `INT_MULOP_S: begin
            if(IsWord==1'b1)
                imul_result <= {{32{intmul_result[31]}},intmul_result[31:0]};
            else
                imul_result <= intmul_result[63:0];
        end
        `INT_MULOP_H:
            imul_result <= intmul_result[127:64];    //(signed x signed) Upper
        `INT_MULOP_HU:
            imul_result <= intmul_result[127:64];    //(unsigned x unsigned) Upper
        `INT_MULOP_HSU:
            imul_result <= intmul_result[127:64];    //(unsigned x signed) Upper
        default:
            imul_result <= -1;
    endcase
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
        WakeupResp[`WAKEUP_RESP_EXCEPTION]  = 1'b0;
        WakeupResp[`WAKEUP_RESP_ECAUSE]     = 0;
        WakeupResp[`WAKEUP_RESP_METADATA]   = 0;

        ResultBus[`RESULT_VALID]            = 1'b1;
        ResultBus[`RESULT_REG_WE]           = Port_S2E[`PORT_S2E_REG_WE];
        ResultBus[`RESULT_PRD_TYPE]         = Port_S2E[`PORT_S2E_PRD_TYPE];
        ResultBus[`RESULT_PRD]              = Port_S2E[`PORT_S2E_PRD];
        ResultBus[`RESULT_VALUE]            = imul_result;
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
                $display("[%t] RESULT@IMUL#: PC=%h ROB=%0d | Killed",$time,
                    Port_S2E[`PORT_S2E_PC], Port_S2E[`PORT_S2E_ROB_INDEX]);
            end
            else if(completed) begin
                $display("[%t] RESULT@IMUL#: PC=%h ROB=%d |%b %s->p%0d=%h | op1=%h op2=%h ",$time,
                    Port_S2E[`PORT_S2E_PC], Port_S2E[`PORT_S2E_ROB_INDEX],
                    Port_S2E[`PORT_S2E_REG_WE], PrintReg(Dispatch_Unit.ROB.ROB[Port_S2E[`PORT_S2E_ROB_INDEX]][`ROB_UOP_RD],Port_S2E[`PORT_S2E_PRD_TYPE]),
                        Port_S2E[`PORT_S2E_PRD], imul_result,
                    Port_S2E[`PORT_S2E_OP1], Port_S2E[`PORT_S2E_OP2]);
            end
        end
    `endif
`endif

endmodule

