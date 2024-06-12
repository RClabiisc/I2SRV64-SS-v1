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
module EU
#(
    parameter [`FU_MASK__LEN-1:0] FU_PRESENT = 16'b1100_1101_0011_1101,
    parameter PORTID = -1
)
(
    input  wire clk,
    input  wire rst,

    input  wire Flush,

    //Input Response from Branch Resolution Unit to kill being executed instrs
    input  wire [`FUBR_RESULT_LEN-1:0]      FUBRresp,

    //Input from Spectag Unit
    input  wire [`SPEC_STATES-1:0]          Spectag_Valid,

    //Outputs to Scheduler Port (Execution Unit to Scheduler Port)
    output reg  [`PORT_E2S_LEN-1:0]         Port_E2S,

    //Inputs from Scheduler Port (Scheduler Port to Execution Unit)
    input  wire [`PORT_S2E_LEN-1:0]         Port_S2E,

    //Output Result & Wakeup Responses
    output reg  [`WAKEUP_RESP_LEN-1:0]      WakeupResp,
    output reg  [`RESULT_LEN-1:0]           ResultBus,

    //Special Buses from Functional Units
    input  wire [2:0]                       fcsr_frm,       //Rounding Mode Input from CSR
    output wire [`FUBR_RESULT_LEN-1:0]      FUBRrespOut,    //Special Bus From FUBR

    input  wire [`LSU_RESP_LEN-1:0]         LSU2Load,       //LSU to Load FU Bus
    input  wire [`LSU_RESP_LEN-1:0]         LSU2Store,      //LSU to Store FU Bus
    output wire [`LSU_REQ_LEN-1:0]          Load2LSU,       //Load FU to LSU Bus
    output wire [`LSU_REQ_LEN-1:0]          Store2LSU,      //Store FU to LSU Bus

    input  wire [`SYS_RESP_LEN-1:0]         SYSrespIn,      //Inputs from SYS Control Unit
    output wire [`SYS_REQ_LEN-1:0]          SYSreqOut       //outputs to SYS Control Unit
);

//generate local wires
wire                    Kill_Enable    = FUBRresp[`FUBR_RESULT_VALID] & FUBRresp[`FUBR_RESULT_MISPRED];
wire [`SPEC_STATES-1:0] Kill_VKillMask = FUBRresp[`FUBR_RESULT_SPECTAG];

//wires for individual functional unit
reg  [`FU_MASK__LEN-1:0]    FU_Port_Valid;
wire [`PORT_S2E_LEN-1:0]    FU_Port_S2E[0:`FU_MASK__LEN-1];
wire [`RESULT_LEN-1:0]      FU_ResultBus[0:`FU_MASK__LEN-1];
wire [`WAKEUP_RESP_LEN-1:0] FU_WakeupResp[0:`FU_MASK__LEN-1];
wire [`FU_MASK__LEN-1:0]    FU_Ready;
wire [`FU_MASK__LEN-1:0]    FU_OutputValid;


//1 assign input E2S Bus to functional units through valid muxes
//2 Mark FU Output Valid if Result Bus or Wakeup bus is valid
genvar gf;
generate
    for(gf=0; gf<`FU_MASK__LEN; gf=gf+1) begin
        assign FU_Port_S2E[gf]    = FU_Port_Valid[gf] ? Port_S2E : 0;
        assign FU_OutputValid[gf] = FU_ResultBus[gf][`RESULT_VALID] | FU_WakeupResp[gf][`WAKEUP_RESP_VALID];
    end
endgenerate


//Instantiate Functional Units if enabled by FU_PRESENT parameter bits
generate
    if(FU_PRESENT[`FU_TYPE_IALU]) begin: IALU
        IALU FU_IALU
        (
            .clk            (clk           ),
            .rst            (rst           ),
            .Flush          (Flush         ),
            .Kill_Enable    (Kill_Enable   ),
            .Kill_VKillMask (Kill_VKillMask),
            .Port_Valid     (FU_Port_Valid[`FU_TYPE_IALU]    ),
            .Port_S2E       (FU_Port_S2E[`FU_TYPE_IALU]      ),
            .Ready          (FU_Ready[`FU_TYPE_IALU]         ),
            .WakeupResp     (FU_WakeupResp[`FU_TYPE_IALU]    ),
            .ResultBus      (FU_ResultBus[`FU_TYPE_IALU]     )
        );
    end
    else begin
        assign FU_Ready[`FU_TYPE_IALU]      = 1'b1;
        assign FU_WakeupResp[`FU_TYPE_IALU] = 0;
        assign FU_ResultBus[`FU_TYPE_IALU]  = 0;
    end

    if(FU_PRESENT[`FU_TYPE_IMUL]) begin: IMUL
        IMUL FU_IMUL
        (
            .clk            (clk           ),
            .rst            (rst           ),
            .Flush          (Flush         ),
            .Kill_Enable    (Kill_Enable   ),
            .Kill_VKillMask (Kill_VKillMask),
            .Port_Valid     (FU_Port_Valid[`FU_TYPE_IMUL]    ),
            .Port_S2E       (FU_Port_S2E[`FU_TYPE_IMUL]      ),
            .Ready          (FU_Ready[`FU_TYPE_IMUL]         ),
            .WakeupResp     (FU_WakeupResp[`FU_TYPE_IMUL]    ),
            .ResultBus      (FU_ResultBus[`FU_TYPE_IMUL]     )
        );
    end
    else begin
        assign FU_Ready[`FU_TYPE_IMUL]      = 1'b1;
        assign FU_WakeupResp[`FU_TYPE_IMUL] = 0;
        assign FU_ResultBus[`FU_TYPE_IMUL]  = 0;
    end

    if(FU_PRESENT[`FU_TYPE_IDIV]) begin: IDIV
        IDIV FU_IDIV
        (
            .clk            (clk           ),
            .rst            (rst           ),
            .Flush          (Flush         ),
            .Kill_Enable    (Kill_Enable   ),
            .Kill_VKillMask (Kill_VKillMask),
            .Port_Valid     (FU_Port_Valid[`FU_TYPE_IDIV]    ),
            .Port_S2E       (FU_Port_S2E[`FU_TYPE_IDIV]      ),
            .Ready          (FU_Ready[`FU_TYPE_IDIV]         ),
            .WakeupResp     (FU_WakeupResp[`FU_TYPE_IDIV]    ),
            .ResultBus      (FU_ResultBus[`FU_TYPE_IDIV]     )
        );
    end
    else begin
        assign FU_Ready[`FU_TYPE_IDIV]      = 1'b1;
        assign FU_WakeupResp[`FU_TYPE_IDIV] = 0;
        assign FU_ResultBus[`FU_TYPE_IDIV]  = 0;
    end

    if(FU_PRESENT[`FU_TYPE_FALU]) begin: FALU
        FALU FU_FALU
        (
            .clk            (clk           ),
            .rst            (rst           ),
            .Flush          (Flush         ),
            .Kill_Enable    (Kill_Enable   ),
            .Kill_VKillMask (Kill_VKillMask),
            .fcsr_frm       (fcsr_frm      ),
            .Port_Valid     (FU_Port_Valid[`FU_TYPE_FALU]    ),
            .Port_S2E       (FU_Port_S2E[`FU_TYPE_FALU]      ),
            .Ready          (FU_Ready[`FU_TYPE_FALU]         ),
            .WakeupResp     (FU_WakeupResp[`FU_TYPE_FALU]    ),
            .ResultBus      (FU_ResultBus[`FU_TYPE_FALU]     )
        );
    end
    else begin
        assign FU_Ready[`FU_TYPE_FALU]      = 1'b1;
        assign FU_WakeupResp[`FU_TYPE_FALU] = 0;
        assign FU_ResultBus[`FU_TYPE_FALU]  = 0;
    end


    if(FU_PRESENT[`FU_TYPE_FMUL]) begin: FMUL
         FMUL FU_FMUL
         (
             .clk            (clk           ),
             .rst            (rst           ),
             .Flush          (Flush         ),
             .Kill_Enable    (Kill_Enable   ),
             .Kill_VKillMask (Kill_VKillMask),
             .fcsr_frm       (fcsr_frm      ),
             .Port_Valid     (FU_Port_Valid[`FU_TYPE_FMUL]    ),
             .Port_S2E       (FU_Port_S2E[`FU_TYPE_FMUL]      ),
             .Ready          (FU_Ready[`FU_TYPE_FMUL]         ),
             .WakeupResp     (FU_WakeupResp[`FU_TYPE_FMUL]    ),
             .ResultBus      (FU_ResultBus[`FU_TYPE_FMUL]     )
         );
    end
    else begin
        assign FU_Ready[`FU_TYPE_FMUL]      = 1'b1;
        assign FU_WakeupResp[`FU_TYPE_FMUL] = 0;
        assign FU_ResultBus[`FU_TYPE_FMUL]  = 0;
    end

    if(FU_PRESENT[`FU_TYPE_FDIV]) begin: FDIV
         FDIV FU_FDIV
         (
             .clk            (clk           ),
             .rst            (rst           ),
             .Flush          (Flush         ),
             .Kill_Enable    (Kill_Enable   ),
             .Kill_VKillMask (Kill_VKillMask),
             .fcsr_frm       (fcsr_frm      ),
             .Port_Valid     (FU_Port_Valid[`FU_TYPE_FDIV]    ),
             .Port_S2E       (FU_Port_S2E[`FU_TYPE_FDIV]      ),
             .Ready          (FU_Ready[`FU_TYPE_FDIV]         ),
             .WakeupResp     (FU_WakeupResp[`FU_TYPE_FDIV]    ),
             .ResultBus      (FU_ResultBus[`FU_TYPE_FDIV]     )
         );
    end
    else begin
        assign FU_Ready[`FU_TYPE_FDIV]      = 1'b1;
        assign FU_WakeupResp[`FU_TYPE_FDIV] = 0;
        assign FU_ResultBus[`FU_TYPE_FDIV]  = 0;
    end

    if(FU_PRESENT[`FU_TYPE_BRANCH]) begin: FUBR
        FUBR FU_Branch
        (
            .clk            (clk           ),
            .rst            (rst           ),
            .Flush          (Flush         ),
            .Kill_Enable    (Kill_Enable   ),
            .Kill_VKillMask (Kill_VKillMask),
            .Spectag_Valid  (Spectag_Valid ),
            .Port_Valid     (FU_Port_Valid[`FU_TYPE_BRANCH]    ),
            .Port_S2E       (FU_Port_S2E[`FU_TYPE_BRANCH]      ),
            .Ready          (FU_Ready[`FU_TYPE_BRANCH]         ),
            .WakeupResp     (FU_WakeupResp[`FU_TYPE_BRANCH]    ),
            .ResultBus      (FU_ResultBus[`FU_TYPE_BRANCH]     ),
            .FUBRrespOut    (FUBRrespOut   )
        );
    end
    else begin
        assign FU_Ready[`FU_TYPE_BRANCH]      = 1'b1;
        assign FU_WakeupResp[`FU_TYPE_BRANCH] = 0;
        assign FU_ResultBus[`FU_TYPE_BRANCH]  = 0;
        assign FUBRrespOut   = 0;
    end

    if(FU_PRESENT[`FU_TYPE_LOAD]) begin: FULD
        FU_Load FU_Load
        (
            .clk            (clk           ),
            .rst            (rst           ),
            .Flush          (Flush         ),
            .Kill_Enable    (Kill_Enable   ),
            .Kill_VKillMask (Kill_VKillMask),
            .Port_Valid     (FU_Port_Valid[`FU_TYPE_LOAD]    ),
            .Port_S2E       (FU_Port_S2E[`FU_TYPE_LOAD]      ),
            .Ready          (FU_Ready[`FU_TYPE_LOAD]         ),
            .WakeupResp     (FU_WakeupResp[`FU_TYPE_LOAD]    ),
            .ResultBus      (FU_ResultBus[`FU_TYPE_LOAD]     ),
            .LSUrespIn      (LSU2Load     ),
            .LSUreqOut      (Load2LSU     )
        );
    end
    else begin
        assign FU_Ready[`FU_TYPE_LOAD]      = 1'b1;
        assign FU_WakeupResp[`FU_TYPE_LOAD] = 0;
        assign FU_ResultBus[`FU_TYPE_LOAD]  = 0;
        assign Load2LSU      = 0;
    end

    if(FU_PRESENT[`FU_TYPE_STORE]) begin: FUST
        FU_Store FU_Store
        (
            .clk            (clk           ),
            .rst            (rst           ),
            .Flush          (Flush         ),
            .Kill_Enable    (Kill_Enable   ),
            .Kill_VKillMask (Kill_VKillMask),
            .Port_Valid     (FU_Port_Valid[`FU_TYPE_STORE]    ),
            .Port_S2E       (FU_Port_S2E[`FU_TYPE_STORE]      ),
            .Ready          (FU_Ready[`FU_TYPE_STORE]         ),
            .WakeupResp     (FU_WakeupResp[`FU_TYPE_STORE]    ),
            .ResultBus      (FU_ResultBus[`FU_TYPE_STORE]     ),
            .LSUrespIn      (LSU2Store     ),
            .LSUreqOut      (Store2LSU     )
        );
    end
    else begin
        assign FU_Ready[`FU_TYPE_STORE]      = 1'b1;
        assign FU_WakeupResp[`FU_TYPE_STORE] = 0;
        assign FU_ResultBus[`FU_TYPE_STORE]  = 0;
        assign Store2LSU     = 0;
    end

    if(FU_PRESENT[`FU_TYPE_SYSTEM]) begin: FUSYS
        FU_System FU_System
        (
            .clk        (clk       ),
            .rst        (rst       ),
            .Flush      (Flush     ),
            .Port_Valid (FU_Port_Valid[`FU_TYPE_SYSTEM]),
            .Port_S2E   (FU_Port_S2E[`FU_TYPE_SYSTEM]  ),
            .Ready      (FU_Ready[`FU_TYPE_SYSTEM]     ),
            .WakeupResp (FU_WakeupResp[`FU_TYPE_SYSTEM]),
            .ResultBus  (FU_ResultBus[`FU_TYPE_SYSTEM] ),
            .SYSrespIn  (SYSrespIn ),
            .SYSreqOut  (SYSreqOut )
        );
    end
    else begin
        assign FU_Ready[`FU_TYPE_SYSTEM]      = 1'b1;
        assign FU_WakeupResp[`FU_TYPE_SYSTEM] = 0;
        assign FU_ResultBus[`FU_TYPE_SYSTEM]  = 0;
        assign SYSreqOut     = 0;
    end


    //HACK: Assign wires for Unused FU Type to default values.
    assign FU_Port_S2E  [`FU_TYPE_UNUSED1]  = 0;
    assign FU_ResultBus [`FU_TYPE_UNUSED1]  = 0;
    assign FU_WakeupResp[`FU_TYPE_UNUSED1]  = 0;
    assign FU_Ready     [`FU_TYPE_UNUSED1]  = 1'b1;

    assign FU_Port_S2E  [`FU_TYPE_UNUSED6]  = 0;
    assign FU_ResultBus [`FU_TYPE_UNUSED6]  = 0;
    assign FU_WakeupResp[`FU_TYPE_UNUSED6]  = 0;
    assign FU_Ready     [`FU_TYPE_UNUSED6]  = 1'b1;

    assign FU_Port_S2E  [`FU_TYPE_UNUSED7]  = 0;
    assign FU_ResultBus [`FU_TYPE_UNUSED7]  = 0;
    assign FU_WakeupResp[`FU_TYPE_UNUSED7]  = 0;
    assign FU_Ready     [`FU_TYPE_UNUSED7]  = 1'b1;

    assign FU_Port_S2E  [`FU_TYPE_UNUSED9]  = 0;
    assign FU_ResultBus [`FU_TYPE_UNUSED9]  = 0;
    assign FU_WakeupResp[`FU_TYPE_UNUSED9]  = 0;
    assign FU_Ready     [`FU_TYPE_UNUSED9]  = 1'b1;

    assign FU_Port_S2E  [`FU_TYPE_UNUSED12] = 0;
    assign FU_ResultBus [`FU_TYPE_UNUSED12] = 0;
    assign FU_WakeupResp[`FU_TYPE_UNUSED12] = 0;
    assign FU_Ready     [`FU_TYPE_UNUSED12] = 1'b1;

    assign FU_Port_S2E  [`FU_TYPE_UNUSED13] = 0;
    assign FU_ResultBus [`FU_TYPE_UNUSED13] = 0;
    assign FU_WakeupResp[`FU_TYPE_UNUSED13] = 0;
    assign FU_Ready     [`FU_TYPE_UNUSED13] = 1'b1;
endgenerate


///////////////////////////////////////////////////////////////////////////////
//1. ready logic => if any one busy => all busy; ignore not present FU;
//This is done because current an execution unit (EU) and execute only one
//instruction at a time in either FU. So if one FU is busy => whole EU is busy
//=> all FU are busy.
//Separate FU busy bits are kept for future when EU can execute multiple instr
//in multiple FU and arbitarate result.
always @* begin
    Port_E2S[`PORT_E2S_FUMASK] = FU_PRESENT;
    if(~&FU_Ready)
        Port_E2S[`PORT_E2S_READY] = 1'b0;
    else
        Port_E2S[`PORT_E2S_READY] = 1'b1;
end


//2. Set FU port valid based on FU_TYPE from Port
always @* begin
    FU_Port_Valid = 0;
    if(Port_S2E[`PORT_S2E_VALID])
        FU_Port_Valid[Port_S2E[`PORT_S2E_FUTYPE]] = 1'b1;
end

//3. MUX result & Wakeup busses
integer f;
always @* begin
    WakeupResp = 0;
    ResultBus  = 0;
    for(f=0; f<`FU_MASK__LEN; f=f+1) begin
        if(FU_PRESENT[f]) begin
            if(FU_OutputValid[f]) begin
                WakeupResp = FU_WakeupResp[f];
                ResultBus  = FU_ResultBus[f];
            end
        end
    end
end

`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;
    `ifdef DEBUG_EU
        always @(negedge clk) begin
            if(Port_S2E[`PORT_S2E_VALID]) begin
                $display("[%t] EU%1d___@REQ##: PC=%h ROB=%d | FU=%s | op1=%h op2=%h",$time, PORTID,
                    Port_S2E[`PORT_S2E_PC], Port_S2E[`PORT_S2E_ROB_INDEX],
                    FU2Str(Port_S2E[`PORT_S2E_FUTYPE]),
                    Port_S2E[`PORT_S2E_OP1], Port_S2E[`PORT_S2E_OP2]);
            end
        end
    `endif
`endif

endmodule

