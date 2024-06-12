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
module FUBR
(
    input  wire clk,
    input  wire rst,

    input  wire Flush,

    //Branch Mispredition Inputs (from last cycle i.e. result of last cycle)
    input  wire                         Kill_Enable,
    input  wire [`SPEC_STATES-1:0]      Kill_VKillMask,

    //Input from Spectag Unit
    input  wire [`SPEC_STATES-1:0]      Spectag_Valid,

    //Inputs from scheduler port (S2E)
    input  wire                         Port_Valid,
    input  wire [`PORT_S2E_LEN-1:0]     Port_S2E,

    //Outputs to scheduler port (E2S)
    output wire                         Ready,

    //Wakeup Bus Outputs
    output reg  [`WAKEUP_RESP_LEN-1:0]  WakeupResp,

    //Result Bus Outputs
    output reg  [`RESULT_LEN-1:0]       ResultBus,

    //Branch (Resolution) Functional Unit Special Response Bus
    output wire [`FUBR_RESULT_LEN-1:0]  FUBRrespOut

);

//extract individual wires from Port S2E (Only required Controls)
wire [`UOP_CONTROL_LEN-1:0]     Controls        = Port_S2E[`PORT_S2E_CONTROLS];
wire [2:0]                      BRtype          = Controls[`UOP_BR_TYPE];
wire [2:0]                      BRSubType       = Controls[`UOP_BR_SUBTYPE];
wire [63:0]                     PredictedTarget = Controls[`UOP_BR_TARGET];
wire                            PredictedTaken  = Controls[`UOP_BR_TAKEN];
wire                            IsJAL           = Controls[`UOP_BR_IS_JAL];
wire                            IsJALR          = Controls[`UOP_BR_IS_JALR];
wire                            Is16bit         = Controls[`UOP_BR_IS_16BIT];
wire                            IsBranch        = (BRtype==`BRANCH_TYPE_COND);


wire [63:0]                     op1             = Port_S2E[`PORT_S2E_OP1];
wire [63:0]                     op2             = Port_S2E[`PORT_S2E_OP2];
wire [63:0]                     PC              = Port_S2E[`PORT_S2E_PC];
wire [63:0]                     Imm             = Port_S2E[`PORT_S2E_OP3];

///////////////////////////////////////////////////////////////////////////////
reg             ActualTaken;
reg             IsSpeculative;                                                      //NOTE; This should be consistant with decoder
wire [63:0]     TakenTarget     = ((IsJALR) ? op1 : PC) + Imm;                      //Target Addr if branch is taken
wire [63:0]     NotTakenTarget  = PC + (Is16bit ? 64'd2 : 64'd4);                   //Target Addr if branch is NOT taken
wire [63:0]     ReturnAddr      = (IsJAL|IsJALR) ? NotTakenTarget : 0;              //Return Addr for JAL & JALR = Target Addr if branch is NOT taken
wire [63:0]     ActualTarget    = ActualTaken ? {TakenTarget[63:1],1'b0}
                                        : {NotTakenTarget[63:1],1'b0};              //Actual Target Address based upon actual direction. LSB will always be zero

wire            beq                 = (op1==op2);
wire            bne                 = ~beq;
wire            blt                 = ($signed(op1)<$signed(op2));
wire            bltu                = (op1<op2);
wire            bge                 = ($signed(op1)>=$signed(op2));
wire            bgeu                = (op1>=op2);
wire            AddrMispredicted    = (ActualTarget!=PredictedTarget);              //Target & Predicted Address Mismatch
wire            DirMispredicted     = (ActualTaken!=PredictedTaken);

//Actual Branch Direction Logic
always @(*) begin
    if(IsBranch) begin
        IsSpeculative = 1'b1;
        case(BRSubType)
            `BRANCH_SUBOP_EQ:  ActualTaken = beq;
            `BRANCH_SUBOP_NE:  ActualTaken = bne;
            `BRANCH_SUBOP_LT:  ActualTaken = blt;
            `BRANCH_SUBOP_GE:  ActualTaken = bge;
            `BRANCH_SUBOP_LTU: ActualTaken = bltu;
            `BRANCH_SUBOP_GEU: ActualTaken = bgeu;
            default:           ActualTaken = 1'b0;  //Should Never Happen. If happens => error in decoding.
        endcase
    end
    else if(IsJALR) begin
        //JALR are always taken but their target address can be mispredicted.
        //So JALR are also speculative.
        ActualTaken = 1'b1;
        IsSpeculative = 1'b1;
    end
    else if(IsJAL) begin
        //JAL are always taken and their target address is fixed. Hence can
        //not be wrong. => JAL are NOT speculative
        ActualTaken = 1'b1;
        IsSpeculative = 1'b0;
    end
    else begin
        ActualTaken = 1'b0; //Should Never Happen
        IsSpeculative = 1'b0;
    end
end


///////////////////////////////////////////////////////////////////////////////
//Branch Misprediction Handling. When branch mispredicted, the instr in
//Execute Unit can be killed if Killmask matches
wire Killed = Kill_Enable & |(Port_S2E[`PORT_S2E_KILLMASK] & Kill_VKillMask);

reg  [`METADATA_LEN-1:0] metadata_d;
always @(*) begin
    metadata_d                              = 0;
    metadata_d[`METADATA_BRANCH_ID]         = 1'b1;
    metadata_d[`METADATA_BRANCH__BRTAKEN]   = ActualTaken;
end


//Result & Wakeup Bus
always @(*) begin
    if(rst | Flush | Killed) begin
        WakeupResp  = 0;
        ResultBus   = 0;
    end
    else if(Port_Valid) begin
        WakeupResp[`WAKEUP_RESP_VALID]      = 1'b1;
        WakeupResp[`WAKEUP_RESP_PRD_TYPE]   = Port_S2E[`PORT_S2E_PRD_TYPE];
        WakeupResp[`WAKEUP_RESP_PRD]        = Port_S2E[`PORT_S2E_PRD];
        WakeupResp[`WAKEUP_RESP_REG_WE]     = Port_S2E[`PORT_S2E_REG_WE];
        WakeupResp[`WAKEUP_RESP_ROB_INDEX]  = Port_S2E[`PORT_S2E_ROB_INDEX];
        WakeupResp[`WAKEUP_RESP_EXCEPTION]  = 1'b0;
        WakeupResp[`WAKEUP_RESP_ECAUSE]     = 0;
        WakeupResp[`WAKEUP_RESP_METADATA]   = IsBranch ? metadata_d : 0;

        ResultBus[`RESULT_VALID]            = 1'b1;
        ResultBus[`RESULT_REG_WE]           = Port_S2E[`PORT_S2E_REG_WE];
        ResultBus[`RESULT_PRD_TYPE]         = Port_S2E[`PORT_S2E_PRD_TYPE];
        ResultBus[`RESULT_PRD]              = Port_S2E[`PORT_S2E_PRD];
        ResultBus[`RESULT_VALUE]            = ReturnAddr;
    end
    else begin
        WakeupResp   = 0;
        ResultBus    = 0;
    end
end

//FUBR Response outputs
//FUBR Response is registered, as it goes to multiple units for instr killing
reg  [`FUBR_RESULT_LEN-1:0] FUBRrespReg;
always @(posedge clk) begin
    if(rst | Flush | Killed) begin
        FUBRrespReg<= 0;
    end
    else if(Port_Valid) begin
        FUBRrespReg[`FUBR_RESULT_VALID]     <= 1'b1;
        FUBRrespReg[`FUBR_RESULT_PC]        <= Port_S2E[`PORT_S2E_PC];
        FUBRrespReg[`FUBR_RESULT_FETCHPCL]  <= Controls[`UOP_BR_FETCHPCL];
        FUBRrespReg[`FUBR_RESULT_BINDX]     <= Controls[`UOP_BR_BINDEX];
        FUBRrespReg[`FUBR_RESULT_BRTYPE]    <= Controls[`UOP_BR_TYPE];
        FUBRrespReg[`FUBR_RESULT_BRTARGET]  <= ActualTarget;
        FUBRrespReg[`FUBR_RESULT_BRTAKEN]   <= ActualTaken;
        FUBRrespReg[`FUBR_RESULT_DP2BC]     <= Controls[`UOP_BR_DP2BC];
        FUBRrespReg[`FUBR_RESULT_BTB2BC]    <= Controls[`UOP_BR_BTB2BC];
        FUBRrespReg[`FUBR_RESULT_BTBHIT]    <= Controls[`UOP_BR_BTBHIT];
        FUBRrespReg[`FUBR_RESULT_SPECTAG]   <= Controls[`UOP_BR_SPECTAG];
        FUBRrespReg[`FUBR_RESULT_MISPRED]   <= DirMispredicted | AddrMispredicted;
        FUBRrespReg[`FUBR_RESULT_BTBWAY]    <= Controls[`UOP_BR_BTBWAY];
        FUBRrespReg[`FUBR_RESULT_ISSPEC]    <= IsSpeculative;
        FUBRrespReg[`FUBR_RESULT_ROBIDX]    <= Port_S2E[`PORT_S2E_ROB_INDEX];
        FUBRrespReg[`FUBR_RESULT_IS16BIT]   <= Is16bit;
    end
    else begin
        FUBRrespReg <= 0;
    end
end


//assign Ready output
assign Ready = 1'b1; //As FUBR is single cycle. It will be always ready

assign FUBRrespOut = FUBRrespReg;


`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;
    `ifdef DEBUG_FU_RESULT
        reg        DPredictedTaken;
        reg [63:0] DPredictedTarget,DPC;
        always @(posedge clk) begin
            DPredictedTaken <= PredictedTaken;
            DPredictedTarget<= PredictedTarget;
            DPC <= PC;
        end

        always @(negedge clk) begin
            if(Killed) begin
                $display("[%t] RESULT@FUBR#: PC=%h ROB=%d | Killed", $time,
                    PC, Port_S2E[`PORT_S2E_ROB_INDEX],
                );
            end
            else if(Port_Valid) begin
                $display("[%t] RESULT@FUBR#: PC=%h ROB=%d |%b %s->p%0d=%h | op1=%h op2=%h | Target=%h", $time,
                    PC, Port_S2E[`PORT_S2E_ROB_INDEX],
                    Port_S2E[`PORT_S2E_REG_WE], PrintReg(Dispatch_Unit.ROB.ROB[Port_S2E[`PORT_S2E_ROB_INDEX]][`ROB_UOP_RD],Port_S2E[`PORT_S2E_PRD_TYPE]),
                        Port_S2E[`PORT_S2E_PRD], ReturnAddr,
                    op1, op2,
                    ActualTarget
                );
            end

            `ifdef DEBUG_FUBR
                if(FUBRrespOut[`FUBR_RESULT_VALID]) begin
                    $display("[%t] FUBR__@RESP#: PC=%h ROB=%d | M=%b(%c) SV=%b ST=%0d | PRD=%b ACT=%b BTB=%b DP=%b | prd=%h act=%h | FPC=%h Bidx=%0d", $time,
                        DPC, FUBRrespOut[`FUBR_RESULT_ROBIDX],
                        FUBRrespOut[`FUBR_RESULT_MISPRED], B2C(FUBRrespOut[`FUBR_RESULT_BRTYPE]), Spectag_Valid,
                            $clog2(FUBRrespOut[`FUBR_RESULT_SPECTAG]),
                        DPredictedTaken, FUBRrespOut[`FUBR_RESULT_BRTAKEN],
                            (FUBRrespOut[`FUBR_RESULT_BTBHIT] ? FUBRrespOut[`FUBR_RESULT_BTB2BC] : 2'bxx), FUBRrespOut[`FUBR_RESULT_DP2BC],
                        DPredictedTarget, FUBRrespOut[`FUBR_RESULT_BRTARGET],
                        {DPC[63:5],FUBRrespOut[`FUBR_RESULT_FETCHPCL]}, FUBRrespOut[`FUBR_RESULT_BINDX]
                    );
                end
            `endif
        end
    `endif
`endif

endmodule

