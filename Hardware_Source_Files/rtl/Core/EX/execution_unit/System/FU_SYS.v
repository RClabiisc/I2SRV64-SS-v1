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
module FU_System
(
    input  wire clk,
    input  wire rst,

    input  wire Flush,

    //Inputs from scheduler port (S2E)
    input  wire                         Port_Valid,
    input  wire [`PORT_S2E_LEN-1:0]     Port_S2E,

    //Outputs to scheduler port (E2S)
    output reg                          Ready,

    //Wakeup Bus Outputs
    output reg  [`WAKEUP_RESP_LEN-1:0]  WakeupResp,

    //Result Bus Outputs
    output reg  [`RESULT_LEN-1:0]       ResultBus,

    //Inputs from SYS Unit
    input  wire [`SYS_RESP_LEN-1:0]     SYSrespIn,

    //outputs to SYS Unit
    output reg  [`SYS_REQ_LEN-1:0]      SYSreqOut

);

//extract individual wires from Port S2E (Only required Controls)
wire [`UOP_CONTROL_LEN-1:0]     Controls = Port_S2E[`PORT_S2E_CONTROLS];
wire [24:0]                     SysData  = Controls[`UOP_SYS_DATA];

wire [2:0]                      CSRsubOp = Controls[`UOP_SYS_CSR_SUBOP];
wire [4:0]                      CSR_Data = Controls[`UOP_SYS_CSR_DATA];
wire [`XLEN-1:0]                op2      = Port_S2E[`PORT_S2E_OP2];
wire [`XLEN-1:0]                Imm      = Port_S2E[`PORT_S2E_OP3];
wire [`XLEN-1:0]                PC       = Port_S2E[`PORT_S2E_PC];

wire [`XLEN-1:0]                op1      = Port_S2E[`PORT_S2E_OP1];  //rs1 data here
wire [`XLEN-1:0]                CSR_Imm  = {59'b0,CSR_Data};
wire [11:0]                     CSR_Addr = Imm[11:0];
wire [`XLEN-1:0]                CSR_Op1  = CSRsubOp[2] ? CSR_Imm : op1;

///////////////////////////////////////////////////////////////////////////////

//operations
// CSR  => perform CSR action using CSR Read & Write from SYS req+resp bus
// ECALL=> set execption to invoke trap handler by retire unit. Exception
//          EXC_ECALL_UMODE, EXC_ECALL_SMODE, EXC_ECALL_MMODE based on current
//          mode present in SYS_Resp.
// EBRK => Cause Breakpoint Exception
// SFENC=> Request to SYS for TLB Flush
// WFI  => NOTE WFI is implemented as NOP
// MRET => determine return priv level. request SYS unit to copy *PIE to *IE. Set reserved bits to Exception Cause
// SRET => determine return priv level. request SYS unit to copy *PIE to *IE. Set reserved bits to Exception Cause
// URET => determine return priv level. request SYS unit to copy *PIE to *IE. Set reserved bits to Exception Cause
// FNCI => Request to SYS for Icache flush.
// FNC  => Tell SYS about Fence. As all previous will be retires already due
// to WAIT_TILL_EMPTY logic. SYS unit can signal to flush cache to memory or
// handle multicore scenarios.

/* Cases when Pipeline is flush is done when instr is commited.
*   SFENCE.VMA => ITLB Flushed => fetched instrs are stale => Flush Pipeline
*   FENCEI  => icache & dcache flushed => instrs may be stale => flush Pipeline
*/

reg                         Exception;
reg  [`ECAUSE_LEN-1:0]      ECause;
reg  [`XLEN-1:0]            Result;
reg  [`METADATA_LEN-1:0]    MetaData;

reg  completed;
always @(*) begin
    //Assign Default Values
    Exception = 1'b0;
    ECause    = 0;
    Result    = 0;
    MetaData  = 0;
    SYSreqOut = 0;

    if(Controls[`UOP_SYS_IS_CSR]) begin
        case(CSRsubOp)
            `ISA_FN3_CSRRW, `ISA_FN3_CSRRWI: begin
                SYSreqOut[`SYS_REQ_CSR_WE]   = 1'b1;
                //Read CSR Only if rd!=x0
                SYSreqOut[`SYS_REQ_CSR_RE]   = Port_S2E[`PORT_S2E_REG_WE];
                SYSreqOut[`SYS_REQ_CSR_ADDR] = CSR_Addr;
                SYSreqOut[`SYS_REQ_CSR_DATA] = CSR_Op1;
                Result                       = SYSrespIn[`SYS_RESP_CSR_RDDATA];
                Exception                    = SYSrespIn[`SYS_RESP_EXCEPTION];
                ECause                       = SYSrespIn[`SYS_RESP_ECAUSE];
            end
            `ISA_FN3_CSRRS, `ISA_FN3_CSRRSI: begin
                SYSreqOut[`SYS_REQ_CSR_RE]   = 1'b1;
                SYSreqOut[`SYS_REQ_CSR_ADDR] = CSR_Addr;
                Exception                    = SYSrespIn[`SYS_RESP_EXCEPTION];
                ECause                       = SYSrespIn[`SYS_RESP_ECAUSE];
                //Write CSR Only if rs1!=x0
                SYSreqOut[`SYS_REQ_CSR_WE]   = |CSR_Op1;
                SYSreqOut[`SYS_REQ_CSR_DATA] = SYSrespIn[`SYS_RESP_CSR_RDDATA] | CSR_Op1;
                Result                       = SYSrespIn[`SYS_RESP_CSR_RDDATA];
            end
            `ISA_FN3_CSRRC, `ISA_FN3_CSRRCI: begin
                SYSreqOut[`SYS_REQ_CSR_RE]   = 1'b1;
                SYSreqOut[`SYS_REQ_CSR_ADDR] = CSR_Addr;
                Exception                    = SYSrespIn[`SYS_RESP_EXCEPTION];
                ECause                       = SYSrespIn[`SYS_RESP_ECAUSE];
                //Write CSR Only if rs1!=x0
                SYSreqOut[`SYS_REQ_CSR_WE]   = |CSR_Op1;
                SYSreqOut[`SYS_REQ_CSR_DATA] = SYSrespIn[`SYS_RESP_CSR_RDDATA] & ~CSR_Op1;
                Result                       = SYSrespIn[`SYS_RESP_CSR_RDDATA];
            end
            default: begin
                Exception                    = 1'b1;
                ECause                       = `EXC_ILLEGAL_INSTR;
            end
        endcase
        completed = 1'b1; //Single Cycle
        MetaData[`METADATA_SYS_ID]           = SYSrespIn[`SYS_RESP_PIPEFLUSH];
        //Do NOT flush pipeline even if CSR causes side affect if CSR is
        //wriing to a register (HACK: HW limitation, flushing when retireRAT
        //is begin updated, will not be reflected in LatestRAT. And most
        //probably this atomic read-write is for testing.
        MetaData[`METADATA_SYS__FLUSHPIPE]   = Port_S2E[`PORT_S2E_REG_WE] ? 1'b0: SYSrespIn[`SYS_RESP_PIPEFLUSH];
    end
    else if(Controls[`UOP_SYS_IS_ECALL]) begin
        Exception = 1'b1;
        case(SYSrespIn[`SYS_RESP_PRIV_LVL])
            `PRIV_LVL_M: ECause = `EXC_ECALL_MMODE;
            `PRIV_LVL_S: ECause = `EXC_ECALL_SMODE;
            `PRIV_LVL_U: ECause = `EXC_ECALL_UMODE;
            default:     ECause = `EXC_ILLEGAL_INSTR;
        endcase
        MetaData  = PC[`METADATA_LEN-1:0];
        completed = 1'b1; //Single Cycle
    end
    else if(Controls[`UOP_SYS_IS_MRET]) begin
        MetaData[`METADATA_SYS_ID]       = 1'b1;
        MetaData[`METADATA_SYS__ISXRET]  = 1'b1;
        MetaData[`METADATA_SYS__RETMODE] = `PRIV_LVL_M;
        completed                        = 1'b1; //Single Cycle
    end
    else if(Controls[`UOP_SYS_IS_SRET]) begin
        //check for TSR bit in xstatus
        if(SYSrespIn[`SYS_RESP_STATUS_TSR] && SYSrespIn[`SYS_RESP_PRIV_LVL]==`PRIV_LVL_S) begin
            MetaData  = {32'd0, `ISA_INS_SRET};
            Exception = 1'b1;
            ECause    = `EXC_ILLEGAL_INSTR;
        end
        else begin
            MetaData[`METADATA_SYS_ID]       = 1'b1;
            MetaData[`METADATA_SYS__ISXRET]  = 1'b1;
            MetaData[`METADATA_SYS__RETMODE] = `PRIV_LVL_S;
        end
        completed                             = 1'b1; //Single Cycle
    end
    else if(Controls[`UOP_SYS_IS_FENCE]) begin
        SYSreqOut[`SYS_REQ_FENCE_REQ] = 1'b1;
        SYSreqOut[`SYS_REQ_FENCE_DATA]= SysData[(31-7):(20-7)];
        if(SYSrespIn[`SYS_RESP_FENCE_DONE])
            completed = 1'b1;
        else
            completed = 1'b0;
    end
    else if(Controls[`UOP_SYS_IS_SFENCEVMA]) begin
        //check for TVM bit in xstatus
        if(SYSrespIn[`SYS_RESP_STATUS_TVM] && SYSrespIn[`SYS_RESP_PRIV_LVL]==`PRIV_LVL_S) begin
            MetaData  = 0; //Will Be written by retire unit
            Exception = 1'b1;
            ECause    = `EXC_ILLEGAL_INSTR;
            completed = 1'b1;
        end
        else begin
            SYSreqOut[`SYS_REQ_SFENCE_REQ]     = 1'b1;
            SYSreqOut[`SYS_REQ_SFENCE_ASID]    = op2;
            SYSreqOut[`SYS_REQ_SFENCE_VADDR]   = op1;
            Exception                          = SYSrespIn[`SYS_RESP_EXCEPTION];
            ECause                             = SYSrespIn[`SYS_RESP_ECAUSE];
            MetaData[`METADATA_SYS_ID]         = 1'b1;
            MetaData[`METADATA_SYS__FLUSHPIPE] = 1'b1;
            if(SYSrespIn[`SYS_RESP_SFENCE_DONE])
                completed = 1'b1;
            else
                completed = 1'b0;
        end
    end
    else if(Controls[`UOP_SYS_IS_FENCEI]) begin
        SYSreqOut[`SYS_REQ_FENCEI_REQ]     = 1'b1;
        MetaData[`METADATA_SYS_ID]         = 1'b1;
        MetaData[`METADATA_SYS__FLUSHPIPE] = 1'b1;
        if(SYSrespIn[`SYS_RESP_FENCEI_DONE])
            completed = 1'b1;
        else
            completed = 1'b0;
    end
    else if(Controls[`UOP_SYS_IS_EBRK]) begin
        Exception = 1'b1;
        ECause    = `EXC_BREAKPOINT;
        MetaData  = PC[`METADATA_LEN-1:0];
        completed = 1'b1; //Single Cycle
    end
    else if(Controls[`UOP_SYS_IS_URET]) begin
        //N-Extension is not Supported
        Exception = 1'b1;
        ECause    = `EXC_ILLEGAL_INSTR;
        completed = 1'b1;
    end
    else if(Controls[`UOP_SYS_IS_WFI]) begin
        //NOTE: WFI Currently Implemented as NOP
        completed = 1'b1; //Single Cycle as implemented as NOP
    end
    else begin
        Exception = 1'b1;
        ECause    = `EXC_ILLEGAL_INSTR;
        completed = 1'b1;
    end
end

//FU Ready Logic
always @* begin
    if(rst | Flush) begin
        Ready = 1'b1;
    end
    else if(Port_Valid & ~completed) begin
        //Now Func Unit is busy so NOT ready
        Ready = 1'b0;
    end
    else begin
        //completed => mark as ready
        Ready = 1'b1;
    end
end

always @(*) begin
    if(rst | Flush) begin
        WakeupResp = 0;
        ResultBus  = 0;
    end
    else if(Port_Valid & completed) begin
        WakeupResp[`WAKEUP_RESP_VALID]      = 1'b1;
        WakeupResp[`WAKEUP_RESP_PRD_TYPE]   = Port_S2E[`PORT_S2E_PRD_TYPE];
        WakeupResp[`WAKEUP_RESP_PRD]        = Port_S2E[`PORT_S2E_PRD];
        WakeupResp[`WAKEUP_RESP_REG_WE]     = Port_S2E[`PORT_S2E_REG_WE];
        WakeupResp[`WAKEUP_RESP_ROB_INDEX]  = Port_S2E[`PORT_S2E_ROB_INDEX];
        WakeupResp[`WAKEUP_RESP_EXCEPTION]  = Exception;
        WakeupResp[`WAKEUP_RESP_ECAUSE]     = ECause;
        WakeupResp[`WAKEUP_RESP_METADATA]   = MetaData;

        ResultBus[`RESULT_VALID]            = 1'b1;
        ResultBus[`RESULT_REG_WE]           = Port_S2E[`PORT_S2E_REG_WE];
        ResultBus[`RESULT_PRD_TYPE]         = Port_S2E[`PORT_S2E_PRD_TYPE];
        ResultBus[`RESULT_PRD]              = Port_S2E[`PORT_S2E_PRD];
        ResultBus[`RESULT_VALUE]            = Result;
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
            if(Port_Valid & completed) begin
                $display("[%t] RESULT@FUSY#: PC=%h ROB=%d |%b %s->p%0d=%h | E=%b Ec=%0d | op1=%h op2=%h ",$time,
                    Port_S2E[`PORT_S2E_PC], Port_S2E[`PORT_S2E_ROB_INDEX],
                    Port_S2E[`PORT_S2E_REG_WE], PrintReg(Dispatch_Unit.ROB.ROB[Port_S2E[`PORT_S2E_ROB_INDEX]][`ROB_UOP_RD],Port_S2E[`PORT_S2E_PRD_TYPE]),
                        Port_S2E[`PORT_S2E_PRD], Result,
                    Exception, ECause,
                    Port_S2E[`PORT_S2E_OP1], Port_S2E[`PORT_S2E_OP2]);
            end
        end
    `endif
`endif

endmodule

