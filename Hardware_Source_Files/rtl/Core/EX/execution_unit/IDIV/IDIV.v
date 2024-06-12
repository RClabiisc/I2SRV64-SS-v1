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
module IDIV
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
wire [1:0]                      DivOp    = Controls[`UOP_INT_MULDIVOP];
wire                            IsWord   = Controls[`UOP_INT_IS_WORD];
wire [63:0]                     op1      = Port_S2E[`PORT_S2E_OP1];
wire [63:0]                     op2      = Port_S2E[`PORT_S2E_OP2];
wire [63:0]                     PC       = Port_S2E[`PORT_S2E_PC];

//interconnect wires
wire [63:0] div_op1, div_op2;
wire [63:0] serdiv_result,idiv_result;
reg  [1:0]  div_oper;

//Assign inputs to Multiplier IP based on MulOp
assign div_op1 = (IsWord) ? {{32{op1[32]}},op1[31:0]} : op1;
assign div_op2 = (IsWord) ? {{32{op2[32]}},op2[31:0]} : op2;

//assign divider operation
always @* begin
    case(DivOp)
        `INT_DIVOP_DIV:  div_oper = 2'b01;
        `INT_DIVOP_DIVU: div_oper = 2'b00;
        `INT_DIVOP_REM:  div_oper = 2'b11;
        `INT_DIVOP_REMU: div_oper = 2'b10;
        default:         div_oper = 2'b00;
    endcase
end

//Branch Misprediction Handling. When branch mispredicted, the instr in
//Execute Unit can be killed if Killmask matches
wire Killed = Kill_Enable & |(Port_S2E[`PORT_S2E_KILLMASK] & Kill_VKillMask);

//input valid wire
wire input_valid = Port_Valid;

//output valid wire i.e. completed
wire completed;

//Instantiation Serial Divider
serialdiv #(.WIDTH(64)) serial_divider
(
    .clk          (clk            ),
    .rst          (rst            ),
    .flush        (Flush | Killed ),
    .input1       (div_op1        ),
    .input2       (div_op2        ),
    .operation    (div_oper       ),
    .input_valid  (input_valid    ),
    .ready        (Ready          ),
    .output_valid (completed      ),
    .result       (serdiv_result  )
);

//assign output based on data type
assign idiv_result = IsWord ? {{32{serdiv_result[31]}},serdiv_result[31:0]} : serdiv_result;


//Output Registering is NOT required as output is already registered in serial
//divider. So when 'completed' signal is asserted both wakeup and result
//busses are made valid
always @* begin
    if(rst | Flush | Killed) begin
        WakeupResp = 0;
        ResultBus  = 0;
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
        ResultBus[`RESULT_VALUE]            = idiv_result;
    end
    else begin
        WakeupResp = 0;
        ResultBus  = 0;
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
                $display("[%t] RESULT@IDIV#: PC=%h ROB=%d | Killed",$time,
                    Port_S2E[`PORT_S2E_PC], Port_S2E[`PORT_S2E_ROB_INDEX]);
            end
            else if(completed) begin
                $display("[%t] RESULT@IDIV#: PC=%h ROB=%d |%b %s->p%0d=%h | op1=%h op2=%h ",$time,
                    Port_S2E[`PORT_S2E_PC], Port_S2E[`PORT_S2E_ROB_INDEX],
                    Port_S2E[`PORT_S2E_REG_WE], PrintReg(Dispatch_Unit.ROB.ROB[Port_S2E[`PORT_S2E_ROB_INDEX]][`ROB_UOP_RD],Port_S2E[`PORT_S2E_PRD_TYPE]),
                        Port_S2E[`PORT_S2E_PRD], idiv_result,
                    Port_S2E[`PORT_S2E_OP1], Port_S2E[`PORT_S2E_OP2]);
            end
        end
    `endif
`endif

endmodule

