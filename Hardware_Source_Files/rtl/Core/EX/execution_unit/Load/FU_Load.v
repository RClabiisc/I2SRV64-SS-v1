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
module FU_Load
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
    output reg  [`RESULT_LEN-1:0]       ResultBus,

    //Inputs from LSU
    input  wire [`LSU_RESP_LEN-1:0]     LSUrespIn,

    //outputs to LSU
    output wire [`LSU_REQ_LEN-1:0]      LSUreqOut

);

//extract individual wires from Port S2E (Only required Controls)
//NOTE: Load FU Do not deal with any atomic operation
wire [`UOP_CONTROL_LEN-1:0]     Controls = Port_S2E[`PORT_S2E_CONTROLS];
wire [`DATA_TYPE__LEN-1:0]      DataType = Controls[`UOP_MEM_DATA_TYPE];
wire [`LS_ORDER_TAG_LEN-1:0]    OrderTag = Controls[`UOP_MEM_LSORDERTAG];

wire [63:0]                     op1 = Port_S2E[`PORT_S2E_OP1];  //rs1 data here
wire [63:0]                     Imm = Port_S2E[`PORT_S2E_OP2];  //Immediate here
wire [63:0]                     PC  = Port_S2E[`PORT_S2E_PC];
wire [63:0]                     Load_Vaddr = op1 + Imm;

///////////////////////////////////////////////////////////////////////////////
//Branch Misprediction Handling. When branch mispredicted, the instr in
//Execute Unit can be killed if Killmask matches
wire Killed = Kill_Enable & |(Port_S2E[`PORT_S2E_KILLMASK] & Kill_VKillMask);

assign LSUreqOut[`LSU_REQ_VALID]        = Port_Valid & Port_S2E[`PORT_S2E_VALID];
assign LSUreqOut[`LSU_REQ_KILLED]       = Killed | Flush;
assign LSUreqOut[`LSU_REQ_OPER]         = `LSU_OPER_LOAD;
assign LSUreqOut[`LSU_REQ_DATA_TYPE]    = DataType;
assign LSUreqOut[`LSU_REQ_KILLMASK]     = Port_S2E[`PORT_S2E_KILLMASK];
assign LSUreqOut[`LSU_REQ_ORDERTAG]     = Controls[`UOP_MEM_LSORDERTAG];
assign LSUreqOut[`LSU_REQ_VADDR]        = Load_Vaddr;
assign LSUreqOut[`LSU_REQ_ST_DATA]      = 0; //FU Load Cannot Issue Store => No Store data
assign LSUreqOut[`LSU_REQ_AMO_DATA]     = 0; //FU Load Do not issue any atomic => no AMO data

wire [63:0] Load_RespData = LSUrespIn[`LSU_RESP_DATA];

///////////////////////////////////////////////////////////////////////////////
assign Ready = LSUrespIn[`LSU_RESP_READY] | Killed | Flush;

reg  [63:0] MetaData;
always @* begin
    MetaData = 0;
    if(rst | Flush | Killed) begin
        WakeupResp = 0;
        ResultBus  = 0;
    end
    else if(Port_Valid & LSUrespIn[`LSU_RESP_DONE]) begin
        //if Input valid, Response Valid
        //if exception set mtval accordingly
        WakeupResp[`WAKEUP_RESP_VALID]      = 1'b1;
        WakeupResp[`WAKEUP_RESP_PRD_TYPE]   = Port_S2E[`PORT_S2E_PRD_TYPE];
        WakeupResp[`WAKEUP_RESP_PRD]        = Port_S2E[`PORT_S2E_PRD];
        WakeupResp[`WAKEUP_RESP_REG_WE]     = Port_S2E[`PORT_S2E_REG_WE];
        WakeupResp[`WAKEUP_RESP_ROB_INDEX]  = Port_S2E[`PORT_S2E_ROB_INDEX];
        WakeupResp[`WAKEUP_RESP_EXCEPTION]  = LSUrespIn[`LSU_RESP_EXCEPTION];
        WakeupResp[`WAKEUP_RESP_ECAUSE]     = LSUrespIn[`LSU_RESP_ECAUSE];

        if(LSUrespIn[`LSU_RESP_EXCEPTION])
            WakeupResp[`WAKEUP_RESP_METADATA]    = Load_Vaddr[`METADATA_LEN-1:0];
        else if(Port_S2E[`PORT_S2E_PRD_TYPE]==`REG_TYPE_FP) begin
            MetaData                            = 0;
            MetaData[`METADATA_FPUOP_ID]        = 1'b1;
            MetaData[`METADATA_FPUOP__DIRTY]    = 1'b1;
            WakeupResp[`WAKEUP_RESP_METADATA]   = MetaData;
        end
        else
            WakeupResp[`WAKEUP_RESP_METADATA]   = 0;

        ResultBus[`RESULT_VALID]            = 1'b1;
        ResultBus[`RESULT_REG_WE]           = Port_S2E[`PORT_S2E_REG_WE];
        ResultBus[`RESULT_PRD_TYPE]         = Port_S2E[`PORT_S2E_PRD_TYPE];
        ResultBus[`RESULT_PRD]              = Port_S2E[`PORT_S2E_PRD];

        //Special case of NaN Boxing of Narrower Values (User Spec 12.2)
        if(Port_S2E[`PORT_S2E_PRD_TYPE]==`REG_TYPE_FP && DataType==`DATA_TYPE_W)
            ResultBus[`RESULT_VALUE]        = {32'hffffffff,Load_RespData[31:0]};
        else
            ResultBus[`RESULT_VALUE]        = Load_RespData;
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
                $display("[%t] RESULT@FULD#: PC=%h ROB=%d | Killed",$time,
                    Port_S2E[`PORT_S2E_PC], Port_S2E[`PORT_S2E_ROB_INDEX]);
            end
            else if(Port_Valid & LSUrespIn[`LSU_RESP_DONE]) begin
                $display("[%t] RESULT@FULD#: PC=%h ROB=%d |%b %s->p%0d=%h | Vaddr=%h %c OT=%0d | op1=%h op2=%h ",$time,
                    Port_S2E[`PORT_S2E_PC], Port_S2E[`PORT_S2E_ROB_INDEX],
                    Port_S2E[`PORT_S2E_REG_WE], PrintReg(Dispatch_Unit.ROB.ROB[Port_S2E[`PORT_S2E_ROB_INDEX]][`ROB_UOP_RD],Port_S2E[`PORT_S2E_PRD_TYPE]),
                        Port_S2E[`PORT_S2E_PRD], ResultBus[`RESULT_VALUE],
                    Load_Vaddr, DT2C(DataType), OrderTag,
                    Port_S2E[`PORT_S2E_OP1], Port_S2E[`PORT_S2E_OP2]);
            end
        end
    `endif
`endif

endmodule

