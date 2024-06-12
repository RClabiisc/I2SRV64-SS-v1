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
module EX
(
    input  wire clk,
    input  wire rst,

    input  wire EX_Stall,           //1=>Stall The Whole Execution unit. (May NOT stall all operations)
    input  wire EX_Flush,           //Exception/Interrupt/RET (redirect) from SysCtl Unit

    //Inputs & Outputs from/to IFU
    input  wire [(`DECODE_RATE*`IB_ENTRY_LEN)-1:0]      IB_DataOut,         //IB Peek Data Input
    input  wire [`DECODE_RATE-1:0]                      IB_OutValid,        //i=1 => ith IB output is valid
    output wire [$clog2(`DECODE_RATE):0]                IB_RdCnt,           //No. of instr to read from IB
    output wire [`RETIRE_RATE-1:0]                      Retire_BranchTaken, //i=1 => ith instr in retire group was taken
    output wire [`RETIRE_RATE-1:0]                      Retire_BranchMask,  //i=1 => ith instr in retire group was branch

    //Branch (resolution) FU Special Result Bus
    output wire [`FUBR_RESULT_LEN-1:0]                  FUBRresp,           //Special Bus From FUBR

    //Request & Responses to LSU
    input  wire                                         SB_Empty,           //1=>Store Buffer is Empty
    input  wire [`LSU_RESP_LEN-1:0]                     LSU2Load,           //LSU to Load FU Bus
    input  wire [`LSU_RESP_LEN-1:0]                     LSU2Store,          //LSU to Store FU Bus
    output wire [`LSU_REQ_LEN-1:0]                      Load2LSU,           //Load FU to LSU Bus
    output wire [`LSU_REQ_LEN-1:0]                      Store2LSU,          //Store FU to LSU Bus
    output wire [(`RETIRE_RATE*`RETIRE2LSU_PORT_LEN)-1:0] Retire2LSU_Bus,   //Retire Unit to LSU

    //Request & Responses to SysCtl Unit
    output wire                                         StallTillRetireLock,//Stall Till Retire Lock signal from decoder
    input  wire [`SYS_RESP_LEN-1:0]                     SYSrespIn,          //Responses from SysCtl Unit to SYS FU
    input  wire                                         RetireAllowed,      //1=>Retire Allowed (from SysCtl to Retire_Unit)
    input  wire [`FCSR_FRM_LEN-1:0]                     csr_fcsr_frm,       //Rounding Mode Input from CSR RegFile
    input  wire [`XSTATUS_FS_LEN-1:0]                   csr_status_fs,      //FS Bits from xstatus CSR
    output wire [`SYS_REQ_LEN-1:0]                      SYSreqOut,          //Requests to SysCtl Unit from SYS FU
    output wire [`RETIRE2SYSCTL_LEN-1:0]                Retire2SysCtl_Bus,  //Requests to SysCtl Unit from Retire Unit

    //Generic Output
    output wire [`XLEN-1:0]                             RetirePC

);

///////////////////////////////////////////////////////////////////////////////
//Local Interconnection Wires
//Uop Wires
wire [(`RENAME_RATE*`UOP_LEN)-1:0]              Decoder_DataOut;        //Decoded uop
wire [`RENAME_RATE-1:0]                         Decoder_OutValid;       //i=1 => decoded uop output is valid
wire [(`DISPATCH_RATE*`UOP_LEN)-1:0]            Rename_DataOut;         //Renamed uop Data
wire [`DISPATCH_RATE-1:0]                       Rename_OutValid;        //i=1 => renamed uop output is valid

//Renaming & RAT Related Wires
wire [(`RETIRE_RATE*`RETIRE2RENAME_PORT_LEN)-1:0] RetireRAT_Update_Bus; //Retire to Rename.RetireRAT Update Bus
wire [`INT_PRF_DEPTH-1:0]                       Int_RecoveryPhyMapBits; //i=1 => ith Int phy reg was mapped in snapshot which is being recoverd
wire [`FP_PRF_DEPTH-1:0]                        Fp_RecoveryPhyMapBits;  //i=1 => ith Fp phy reg was mapped in snapshot which is being recoverd

//Issue Related Wires
wire [`RS_INT_ISSUE_REQ-1:0]                    RSINT_Issued_Valid;     //i=1 => ith issue request confirmation is valid
wire [`RS_FP_ISSUE_REQ-1:0]                     RSFP_Issued_Valid;      //i=1 => ith issue request confirmation is valid
wire                                            RSBR_Issued_Valid;      //1 => issue request confirmation is valid
wire [`RS_MEM_ISSUE_REQ-1:0]                    RSMEM_Issued_Valid;     //i=1 => ith issue request confirmation is valid
wire                                            RSSYS_Issued_Valid;     //1 => issue request confirmation is valid

wire [(`RS_INT_ISSUE_REQ*`RS_INT_LEN)-1:0]      RSINT_IssueReq_Entries; //Entries requested for issue
wire [`RS_INT_ISSUE_REQ-1:0]                    RSINT_IssueReq_Valid;   //i=1 => ith request for issue is valid
wire [(`RS_FP_ISSUE_REQ*`RS_FPU_LEN)-1:0]       RSFP_IssueReq_Entries;  //Entries requested for issue
wire [`RS_FP_ISSUE_REQ-1:0]                     RSFP_IssueReq_Valid;    //i=1 => ith request for issue is valid
wire [`RS_BR_LEN-1:0]                           RSBR_IssueReq_Entries;  //Entries requested for issue
wire                                            RSBR_IssueReq_Valid;    //i=1 => ith request for issue is valid
wire [(`RS_MEM_ISSUE_REQ*`RS_MEM_LEN)-1:0]      RSMEM_IssueReq_Entries; //Entries requested for issue
wire [`RS_MEM_ISSUE_REQ-1:0]                    RSMEM_IssueReq_Valid;   //i=1 => ith request for issue is valid
wire [`RS_SYS_LEN-1:0]                          RSSYS_IssueReq_Entries; //Entries requested for issue
wire                                            RSSYS_IssueReq_Valid;   //i=1 => ith request for issue is valid

//Scheduler Port Related Wires
wire [`PORT_E2S_LEN-1:0]                        Port0_E2S;              //Execution Unit to Scheduler Port 0
wire [`PORT_E2S_LEN-1:0]                        Port1_E2S;              //Execution Unit to Scheduler Port 1
wire [`PORT_E2S_LEN-1:0]                        Port2_E2S;              //Execution Unit to Scheduler Port 2
wire [`PORT_E2S_LEN-1:0]                        Port3_E2S;              //Execution Unit to Scheduler Port 3
wire [`PORT_E2S_LEN-1:0]                        Port4_E2S;              //Execution Unit to Scheduler Port 4
wire [`PORT_E2S_LEN-1:0]                        Port5_E2S;              //Execution Unit to Scheduler Port 5

wire [`PORT_S2E_LEN-1:0]                        Port0_S2E;              //Scheduler Port 0 to Execution Unit
wire [`PORT_S2E_LEN-1:0]                        Port1_S2E;              //Scheduler Port 1 to Execution Unit
wire [`PORT_S2E_LEN-1:0]                        Port2_S2E;              //Scheduler Port 2 to Execution Unit
wire [`PORT_S2E_LEN-1:0]                        Port3_S2E;              //Scheduler Port 3 to Execution Unit
wire [`PORT_S2E_LEN-1:0]                        Port4_S2E;              //Scheduler Port 4 to Execution Unit
wire [`PORT_S2E_LEN-1:0]                        Port5_S2E;              //Scheduler Port 5 to Execution Unit

//Result & Wakeup Busses
wire [`RESULT_LEN-1:0]                          ResultBus0;             //Result Bus 0
wire [`RESULT_LEN-1:0]                          ResultBus1;             //Result Bus 1
wire [`RESULT_LEN-1:0]                          ResultBus2;             //Result Bus 2
wire [`RESULT_LEN-1:0]                          ResultBus3;             //Result Bus 3
wire [`RESULT_LEN-1:0]                          ResultBus4;             //Result Bus 4
wire [`RESULT_LEN-1:0]                          ResultBus5;             //Result Bus 5
wire [(`SCHED_PORTS*`WAKEUP_RESP_LEN)-1:0]      WakeupResponses;        //Consolidated Wakeup Bus

//ROB Peek Data & Control Wires
wire [(`RETIRE_RATE*`ROB_LEN)-1:0]              ROB_ReadData;           //ROB Peek Data
wire [$clog2(`ROB_DEPTH):0]                     ROB_UsedEntries;        //Used Entries in ROB
wire [$clog2(`RETIRE_RATE):0]                   RetireCnt;              //No. of instr retired

//Control Signals
wire                                            Spectag_Flush;          //Flush Spectag unit (on exception/branch mispred)
wire                                            Decode_Stall;           //Stall Decode o/p reg Write Operation
wire                                            Decode_Flush;           //Flush decoder o/p reg
wire                                            Rename_Stall;           //Stall Rename Operation
wire                                            Rename_Flush;           //Rename Unit Flush
wire                                            Dispatch_Stall;         //Dispatch Stall
wire                                            Dispatch_Flush;         //Dispatch Unit Flush
wire                                            Issue_Stall;            //Issue Unit Stall
wire                                            Issue_Flush;            //Issue Unit Flush
wire                                            Execution_Flush;        //Execution Unit Flush

wire                                            StallLockRelease;       //1 => Release Stall lock set by 'wait_till_retire'
wire                                            PipelineNotEmpty;       //1 => Pipeline NOT empty
wire                                            Decode_StallRequest;    //1 => decoder stall request from rename unit
wire                                            Rename_StallRequest;    //1 => rename stall request from dispatch unit

//Misc Busses
wire [`SPEC_STATES-1:0]                         Spectag_Valid;          //i=1 => ith spec tag is speculative else (not-speculative or unallocated)


///////////////////////////////////////////////////////////////////////////////
//Instantiate Sub Modules
//Decoder Unit
Decoder Decoder
(
    .clk              (clk             ),
    .rst              (rst             ),

    .Stall            (Decode_Stall    ),
    .Flush            (Decode_Flush    ),
    .Spectag_Flush    (Spectag_Flush   ),

    .IB_DataOut       (IB_DataOut      ),
    .IB_OutValid      (IB_OutValid     ),

    .PipelineNotEmpty (PipelineNotEmpty),
    .StallLockRelease (StallLockRelease),
    .StallTillRetireLock(StallTillRetireLock),
    .csr_status_fs    (csr_status_fs   ),

    .FUBRresp         (FUBRresp        ),

    .IB_RdCnt         (IB_RdCnt        ),

    .Decoder_DataOut  (Decoder_DataOut ),
    .Decoder_OutValid (Decoder_OutValid),

    .Spectag_Valid    (Spectag_Valid   )
);


//Rename Unit
Rename_Unit Rename_Unit
(
    .clk                    (clk                   ),
    .rst                    (rst                   ),

    .Stall                  (Rename_Stall          ),
    .Flush                  (Rename_Flush          ),

    .Decoder_DataOut        (Decoder_DataOut       ),
    .Decoder_OutValid       (Decoder_OutValid      ),

    .Spectag_Valid          (Spectag_Valid         ),

    .RetireRAT_Update_Bus   (RetireRAT_Update_Bus  ),

    .FUBRresp               (FUBRresp              ),

    .Rename_DataOut         (Rename_DataOut        ),
    .Rename_OutValid        (Rename_OutValid       ),
    .Decode_StallRequest    (Decode_StallRequest   ),

    .Int_RecoveryPhyMapBits (Int_RecoveryPhyMapBits),
    .Fp_RecoveryPhyMapBits  (Fp_RecoveryPhyMapBits )
);


//Dispatch Unit
Dispatch_Unit Dispatch_Unit
(
    .clk                    (clk                   ),
    .rst                    (rst                   ),

    .Stall                  (Dispatch_Stall        ),
    .Flush                  (Dispatch_Flush        ),

    .Rename_DataOut         (Rename_DataOut        ),
    .Rename_OutValid        (Rename_OutValid       ),

    .FUBRresp               (FUBRresp              ),

    .WakeupResponses        (WakeupResponses       ),

    .RSINT_Issued_Valid     (RSINT_Issued_Valid    ),
    .RSFP_Issued_Valid      (RSFP_Issued_Valid     ),
    .RSBR_Issued_Valid      (RSBR_Issued_Valid     ),
    .RSMEM_Issued_Valid     (RSMEM_Issued_Valid    ),
    .RSSYS_Issued_Valid     (RSSYS_Issued_Valid    ),

    .RetireCnt              (RetireCnt             ),

    .Int_RecoveryPhyMapBits (Int_RecoveryPhyMapBits),
    .Fp_RecoveryPhyMapBits  (Fp_RecoveryPhyMapBits ),

    .RSINT_IssueReq_Entries (RSINT_IssueReq_Entries),
    .RSINT_IssueReq_Valid   (RSINT_IssueReq_Valid  ),
    .RSFP_IssueReq_Entries  (RSFP_IssueReq_Entries ),
    .RSFP_IssueReq_Valid    (RSFP_IssueReq_Valid   ),
    .RSBR_IssueReq_Entries  (RSBR_IssueReq_Entries ),
    .RSBR_IssueReq_Valid    (RSBR_IssueReq_Valid   ),
    .RSMEM_IssueReq_Entries (RSMEM_IssueReq_Entries),
    .RSMEM_IssueReq_Valid   (RSMEM_IssueReq_Valid  ),
    .RSSYS_IssueReq_Entries (RSSYS_IssueReq_Entries),
    .RSSYS_IssueReq_Valid   (RSSYS_IssueReq_Valid  ),

    .ROB_ReadData           (ROB_ReadData          ),
    .ROB_UsedEntries        (ROB_UsedEntries       ),

    .Rename_StallRequest    (Rename_StallRequest   )

);


//Issue Unit
Issue_Unit Issue_Unit
(
    .clk                    (clk                   ),
    .rst                    (rst                   ),

    .Stall                  (Issue_Stall           ),
    .Flush                  (Issue_Flush           ),

    .FUBRresp               (FUBRresp              ),

    .RSINT_IssueReq_Entries (RSINT_IssueReq_Entries),
    .RSINT_IssueReq_Valid   (RSINT_IssueReq_Valid  ),
    .RSFP_IssueReq_Entries  (RSFP_IssueReq_Entries ),
    .RSFP_IssueReq_Valid    (RSFP_IssueReq_Valid   ),
    .RSBR_IssueReq_Entries  (RSBR_IssueReq_Entries ),
    .RSBR_IssueReq_Valid    (RSBR_IssueReq_Valid   ),
    .RSMEM_IssueReq_Entries (RSMEM_IssueReq_Entries),
    .RSMEM_IssueReq_Valid   (RSMEM_IssueReq_Valid  ),
    .RSSYS_IssueReq_Entries (RSSYS_IssueReq_Entries),

    .RSSYS_IssueReq_Valid   (RSSYS_IssueReq_Valid  ),
    .RSINT_Issued_Valid     (RSINT_Issued_Valid    ),
    .RSFP_Issued_Valid      (RSFP_Issued_Valid     ),
    .RSBR_Issued_Valid      (RSBR_Issued_Valid     ),
    .RSMEM_Issued_Valid     (RSMEM_Issued_Valid    ),
    .RSSYS_Issued_Valid     (RSSYS_Issued_Valid    ),

    .Port0_E2S              (Port0_E2S             ),
    .Port1_E2S              (Port1_E2S             ),
    .Port2_E2S              (Port2_E2S             ),
    .Port3_E2S              (Port3_E2S             ),
    .Port4_E2S              (Port4_E2S             ),
    .Port5_E2S              (Port5_E2S             ),

    .Port0_S2E              (Port0_S2E             ),
    .Port1_S2E              (Port1_S2E             ),
    .Port2_S2E              (Port2_S2E             ),
    .Port3_S2E              (Port3_S2E             ),
    .Port4_S2E              (Port4_S2E             ),
    .Port5_S2E              (Port5_S2E             ),

    .ResultBus0             (ResultBus0            ),
    .ResultBus1             (ResultBus1            ),
    .ResultBus2             (ResultBus2            ),
    .ResultBus3             (ResultBus3            ),
    .ResultBus4             (ResultBus4            ),
    .ResultBus5             (ResultBus5            )
);


//Execution Unit
Execution_Unit Execution_Unit
(
    .clk             (clk            ),
    .rst             (rst            ),

    .Flush           (Execution_Flush),

    .Spectag_Valid   (Spectag_Valid  ),

    .Port0_S2E       (Port0_S2E      ),
    .Port1_S2E       (Port1_S2E      ),
    .Port2_S2E       (Port2_S2E      ),
    .Port3_S2E       (Port3_S2E      ),
    .Port4_S2E       (Port4_S2E      ),
    .Port5_S2E       (Port5_S2E      ),

    .Port0_E2S       (Port0_E2S      ),
    .Port1_E2S       (Port1_E2S      ),
    .Port2_E2S       (Port2_E2S      ),
    .Port3_E2S       (Port3_E2S      ),
    .Port4_E2S       (Port4_E2S      ),
    .Port5_E2S       (Port5_E2S      ),

    .ResultBus0      (ResultBus0     ),
    .ResultBus1      (ResultBus1     ),
    .ResultBus2      (ResultBus2     ),
    .ResultBus3      (ResultBus3     ),
    .ResultBus4      (ResultBus4     ),
    .ResultBus5      (ResultBus5     ),

    .WakeupResponses (WakeupResponses),

    .fcsr_frm        (csr_fcsr_frm   ),

    .FUBRresp        (FUBRresp       ),

    .LSU2Load        (LSU2Load       ),
    .LSU2Store       (LSU2Store      ),

    .Load2LSU        (Load2LSU       ),
    .Store2LSU       (Store2LSU      ),

    .SYSrespIn       (SYSrespIn      ),
    .SYSreqOut       (SYSreqOut      )

);


//Retire Unit
Retire_Unit Retire_Unit
(
    .clk                    (clk                    ),
    .rst                    (rst                    ),

    .ROB_ReadData           (ROB_ReadData           ),
    .ROB_UsedEntries        (ROB_UsedEntries        ),

    .RetireAllowed          (RetireAllowed          ),

    .Retire2SysCtl_Bus      (Retire2SysCtl_Bus      ),

    .RetireCnt              (RetireCnt              ),

    .Retire_BranchTaken     (Retire_BranchTaken     ),
    .Retire_BranchMask      (Retire_BranchMask      ),

    .StallLockRelease       (StallLockRelease       ),

    .RetirePC               (RetirePC               ),

    .RetireRAT_Update_Bus   (RetireRAT_Update_Bus   ),

    .Retire2LSU_Bus         (Retire2LSU_Bus         )
);


///////////////////////////////////////////////////////////////////////////////
//Basic Signals
wire Branch_Mispredicted = FUBRresp[`FUBR_RESULT_VALID] & FUBRresp[`FUBR_RESULT_MISPRED];


//generate control signals
//Flush Spectag when there is confirmed exception or interrupt from SysCtl
//Unit
assign Spectag_Flush    = EX_Flush;

//Flush Decoder when Branch is mispredicted or confirmed exception/interrupt
//from SysCtl Unit (Branch Mispredicted is handled internally)
assign Decode_Flush     = EX_Flush;

//Flush Rename Unit when Branch Mispredicted or confirmed exception/interrupt.
//(Branch Misprediction fluish is handled internally)
assign Rename_Flush     = EX_Flush;

//Flush Dispatch Unit when Exception/Interrupt occures.
assign Dispatch_Flush   = EX_Flush;

//Flush Issue Unit on exception
assign Issue_Flush      = EX_Flush;

//Flush Execution unit on exception
assign Execution_Flush  = EX_Flush;


//Stall Decoder if requested by Rename Unit or Rename itself Stalled
assign Decode_Stall     = Decode_StallRequest | Rename_Stall | EX_Stall;

//Stall Rename Unit if requested by Dispatch Unit or dispatch itself stalled
assign Rename_Stall     = Rename_StallRequest | Dispatch_Stall | EX_Stall;

//Usually there is NO reason to stall Dispatch Unit explicitely. As space
//availbility is checked inside Dispatch Module Only. But if Stall Request
//from Core, Stall Dispatch Also
assign Dispatch_Stall   = EX_Stall;

//Similarly There is NO reason to stall Issue unit Explicitely. FU/EU
//availbility is checked inside Issue Unit itself. But if Stall Request from
//Core, stall Issue Also
assign Issue_Stall      = EX_Stall;

//Pipeline is Not Empty untill all instructions are retired (i.e. ROB is
//Empty), Store Buffer is also not empty, No instruction in Rename-Dispatch
//pipeline register and no instruction in Decode-Rename Pipeline Register
assign PipelineNotEmpty = (ROB_UsedEntries!=0) || (SB_Empty==1'b0) || (|Decoder_OutValid) || (|Rename_OutValid);


`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;
    `ifdef DEBUG_IRF_VALUE
        always @(negedge clk) begin
            for(Di=0; Di<32; Di=Di+1) begin
                $display("[%t] INTRF_@REG%-2d: x%0d=p%0d=%h", $time, Di, Di,
                    Rename_Unit.Retire_RAT.IntRetireRAT[Di],
                    (Di>0 ? Issue_Unit.INT_PRF.preg[Rename_Unit.Retire_RAT.IntRetireRAT[Di]] : 64'b0 ));
            end
        end
    `endif
    `ifdef DEBUG_FRF_VALUE
        always @(negedge clk) begin
            for(Di=0; Di<32; Di=Di+1) begin
                $display("[%t] FPRF__@REG%-2d: f%0d=p%0d=%h", $time, Di, Di,
                    Rename_Unit.Retire_RAT.FpRetireRAT[Di],
                    Issue_Unit.FP_PRF.preg[Rename_Unit.Retire_RAT.FpRetireRAT[Di]]);
            end
        end
    `endif
`endif

endmodule

