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
module Execution_Unit
(
    input  wire clk,
    input  wire rst,

    input  wire Flush,

    //Inputs from Spectag Unit
    input  wire [`SPEC_STATES-1:0]                      Spectag_Valid,

    //Inputs from Scheduler Port (Scheduler Port to Execution Unit)
    input  wire [`PORT_S2E_LEN-1:0]                     Port0_S2E,
    input  wire [`PORT_S2E_LEN-1:0]                     Port1_S2E,
    input  wire [`PORT_S2E_LEN-1:0]                     Port2_S2E,
    input  wire [`PORT_S2E_LEN-1:0]                     Port3_S2E,
    input  wire [`PORT_S2E_LEN-1:0]                     Port4_S2E,
    input  wire [`PORT_S2E_LEN-1:0]                     Port5_S2E,

    //Outputs to Scheduler Port Inputs (Execution Unit to Scheduler Port)
    output wire [`PORT_E2S_LEN-1:0]                     Port0_E2S,
    output wire [`PORT_E2S_LEN-1:0]                     Port1_E2S,
    output wire [`PORT_E2S_LEN-1:0]                     Port2_E2S,
    output wire [`PORT_E2S_LEN-1:0]                     Port3_E2S,
    output wire [`PORT_E2S_LEN-1:0]                     Port4_E2S,
    output wire [`PORT_E2S_LEN-1:0]                     Port5_E2S,

    //Result Bus Outputs
    output wire [`RESULT_LEN-1:0]                       ResultBus0,
    output wire [`RESULT_LEN-1:0]                       ResultBus1,
    output wire [`RESULT_LEN-1:0]                       ResultBus2,
    output wire [`RESULT_LEN-1:0]                       ResultBus3,
    output wire [`RESULT_LEN-1:0]                       ResultBus4,
    output wire [`RESULT_LEN-1:0]                       ResultBus5,

    //Wakeup Responses Outputs
    output wire [(`SCHED_PORTS*`WAKEUP_RESP_LEN)-1:0]   WakeupResponses,

    //Special Buses from Functional Units
    input  wire [`FCSR_FRM_LEN-1:0]                     fcsr_frm,       //Rounding Mode Input from CSR
    output wire [`FUBR_RESULT_LEN-1:0]                  FUBRresp,       //Special Bus From FUBR
    input  wire [`LSU_RESP_LEN-1:0]                     LSU2Load,       //LSU to Load FU Bus
    input  wire [`LSU_RESP_LEN-1:0]                     LSU2Store,      //LSU to Store FU Bus
    output wire [`LSU_REQ_LEN-1:0]                      Load2LSU,       //Load FU to LSU Bus
    output wire [`LSU_REQ_LEN-1:0]                      Store2LSU,      //Store FU to LSU Bus

    input  wire [`SYS_RESP_LEN-1:0]                     SYSrespIn,       //Inputs from SYS Control Unit
    output wire [`SYS_REQ_LEN-1:0]                      SYSreqOut

);

//geneate local wires for inputs
wire [`PORT_E2S_LEN-1:0]    Port_E2S  [0:`SCHED_PORTS-1];
wire [`PORT_S2E_LEN-1:0]    Port_S2E  [0:`SCHED_PORTS-1];
wire [`RESULT_LEN-1:0]      ResultBus [0:`SCHED_PORTS-1];
wire [`WAKEUP_RESP_LEN-1:0] WakeupResp[0:`SCHED_PORTS-1];

//generate local wires for Ports HACK:$@SCHED_PORTS
assign Port0_E2S = Port_E2S[0];
assign Port1_E2S = Port_E2S[1];
assign Port2_E2S = Port_E2S[2];
assign Port3_E2S = Port_E2S[3];
assign Port4_E2S = Port_E2S[4];
assign Port5_E2S = Port_E2S[5];

//assign local wires to Scheduler Port outputs HACK:$@SCHED_PORTS
assign Port_S2E[0] = Port0_S2E;
assign Port_S2E[1] = Port1_S2E;
assign Port_S2E[2] = Port2_S2E;
assign Port_S2E[3] = Port3_S2E;
assign Port_S2E[4] = Port4_S2E;
assign Port_S2E[5] = Port5_S2E;


//generate local wires for Result Bus HACK:$@SCHED_PORTS
assign ResultBus0 = ResultBus[0];
assign ResultBus1 = ResultBus[1];
assign ResultBus2 = ResultBus[2];
assign ResultBus3 = ResultBus[3];
assign ResultBus4 = ResultBus[4];
assign ResultBus5 = ResultBus[5];

//merge indivitual Wakeup Responses to bus
genvar gw;
generate
    for(gw=0; gw<`SCHED_PORTS; gw=gw+1) begin
        assign WakeupResponses[gw*`WAKEUP_RESP_LEN+:`WAKEUP_RESP_LEN] = WakeupResp[gw];
    end
endgenerate

wire [`FUBR_RESULT_LEN-1:0] FUBRrespOut; //Special Result Bus From FUBR


///////////////////////////////////////////////////////////////////////////////
//Execution Unit 0 : IALU, FALU, FMUL, IDIV
EU #(.FU_PRESENT(16'b0000_0101_0000_1001), .PORTID(0)) EU0 //HACK: $@FU_TYPE define
(
    .clk           (clk          ),
    .rst           (rst          ),
    .Flush         (Flush        ),
    .FUBRresp      (FUBRresp     ),
    .Spectag_Valid (Spectag_Valid),
    .Port_E2S      (Port_E2S[0]  ),
    .Port_S2E      (Port_S2E[0]  ),
    .WakeupResp    (WakeupResp[0]),
    .ResultBus     (ResultBus[0] ),
    .fcsr_frm      (fcsr_frm     ),
    .FUBRrespOut   (),
    .LSU2Load      (),
    .LSU2Store     (),
    .Load2LSU      (),
    .Store2LSU     (),
    .SYSrespIn     (),
    .SYSreqOut     ()
);

//Execution Unit 1 : IALU, FALU, FDIV
EU #(.FU_PRESENT(16'b0000_1001_0000_0001), .PORTID(1)) EU1 //HACK: $@FU_TYPE define
(
    .clk           (clk          ),
    .rst           (rst          ),
    .Flush         (Flush        ),
    .FUBRresp      (FUBRresp     ),
    .Spectag_Valid (Spectag_Valid),
    .Port_E2S      (Port_E2S[1]  ),
    .Port_S2E      (Port_S2E[1]  ),
    .WakeupResp    (WakeupResp[1]),
    .ResultBus     (ResultBus[1] ),
    .fcsr_frm      (fcsr_frm     ),
    .FUBRrespOut   (),
    .LSU2Load      (),
    .LSU2Store     (),
    .Load2LSU      (),
    .Store2LSU     (),
    .SYSrespIn     (),
    .SYSreqOut     ()
);

//Execution Unit 2 : IALU, IMUL
EU #(.FU_PRESENT(16'b0000_0000_0000_0101), .PORTID(2)) EU2 //HACK: $@FU_TYPE define
(
    .clk           (clk          ),
    .rst           (rst          ),
    .Flush         (Flush        ),
    .FUBRresp      (FUBRresp     ),
    .Spectag_Valid (Spectag_Valid),
    .Port_E2S      (Port_E2S[2]  ),
    .Port_S2E      (Port_S2E[2]  ),
    .WakeupResp    (WakeupResp[2]),
    .ResultBus     (ResultBus[2] ),
    .fcsr_frm      (fcsr_frm     ),
    .FUBRrespOut   (),
    .LSU2Load      (),
    .LSU2Store     (),
    .Load2LSU      (),
    .Store2LSU     (),
    .SYSrespIn     (),
    .SYSreqOut     ()
);

//Execution Unit 3 : Load
EU #(.FU_PRESENT(16'b0000_0000_0001_0000), .PORTID(3)) EU3 //HACK: $@FU_TYPE define
(
    .clk           (clk          ),
    .rst           (rst          ),
    .Flush         (Flush        ),
    .FUBRresp      (FUBRresp     ),
    .Spectag_Valid (Spectag_Valid),
    .Port_E2S      (Port_E2S[3]  ),
    .Port_S2E      (Port_S2E[3]  ),
    .WakeupResp    (WakeupResp[3]),
    .ResultBus     (ResultBus[3] ),
    .fcsr_frm      (fcsr_frm     ),
    .FUBRrespOut   (),
    .LSU2Load      (LSU2Load     ),
    .LSU2Store     (),
    .Load2LSU      (Load2LSU     ),
    .Store2LSU     (),
    .SYSrespIn     (),
    .SYSreqOut     ()
);

//Execution Unit 4 : Store
EU #(.FU_PRESENT(16'b0000_0000_0010_0000), .PORTID(4)) EU4 //HACK: $@FU_TYPE define
(
    .clk           (clk          ),
    .rst           (rst          ),
    .Flush         (Flush        ),
    .FUBRresp      (FUBRresp     ),
    .Spectag_Valid (Spectag_Valid),
    .Port_E2S      (Port_E2S[4]  ),
    .Port_S2E      (Port_S2E[4]  ),
    .WakeupResp    (WakeupResp[4]),
    .ResultBus     (ResultBus[4] ),
    .fcsr_frm      (fcsr_frm     ),
    .FUBRrespOut   (),
    .LSU2Load      (),
    .LSU2Store     (LSU2Store    ),
    .Load2LSU      (),
    .Store2LSU     (Store2LSU    ),
    .SYSrespIn     (),
    .SYSreqOut     ()
);

//Execution Unit 5 : Branch, Sys
EU #(.FU_PRESENT(16'b1100_0000_0000_0000), .PORTID(5)) EU5 //HACK: $@FU_TYPE define
(
    .clk           (clk          ),
    .rst           (rst          ),
    .Flush         (Flush        ),
    .FUBRresp      (FUBRresp     ),
    .Spectag_Valid (Spectag_Valid),
    .Port_E2S      (Port_E2S[5]  ),
    .Port_S2E      (Port_S2E[5]  ),
    .WakeupResp    (WakeupResp[5]),
    .ResultBus     (ResultBus[5] ),
    .fcsr_frm      (fcsr_frm     ),
    .FUBRrespOut   (FUBRrespOut  ),
    .LSU2Load      (),
    .LSU2Store     (),
    .Load2LSU      (),
    .Store2LSU     (),
    .SYSrespIn     (SYSrespIn    ),
    .SYSreqOut     (SYSreqOut    )
);


///////////////////////////////////////////////////////////////////////////////
//Design has implicit assumption that there will be only one branch
//(resolution) Functional Unit. So No need to arbiterate and mux
assign FUBRresp = FUBRrespOut;

//Currently LSU has one request & response pair for each Load & Store
//Operation. As only one load and store FU are present, no need to arbiterate
//and mux. Further if more load/store unit are added, arbiteration & muxing
//needs to be done along with handshaking with load/store FU.



`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;
    `ifdef DEBUG_EU_RESULT
        always @(negedge clk) begin
            for(Di=0; Di<`SCHED_PORTS; Di=Di+1) begin
                if(ResultBus[Di][`RESULT_VALID]) begin
                    $display("[%t] RESULT@EU%1d##: ROB=%d | Exc=%b Ecause=%0d| we=%b prd=%0d%c Value=%h",$time, Di,
                        WakeupResp[Di][`WAKEUP_RESP_ROB_INDEX], ResultBus[Di][`RESULT_VALID],
                        WakeupResp[Di][`WAKEUP_RESP_EXCEPTION], WakeupResp[Di][`WAKEUP_RESP_ECAUSE],
                        ResultBus[Di][`RESULT_REG_WE], ResultBus[Di][`RESULT_PRD], (ResultBus[Di][`RESULT_PRD_TYPE]==`REG_TYPE_INT ? "i" : "f"), ResultBus[Di][`RESULT_VALUE]);
                end
            end
        end
    `endif
`endif


endmodule

