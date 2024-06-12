//******************************************************************************
// Copyright (c) 2018 - 2023, Indian Institute of Science, Bangalore.
// All Rights Reserved. See LICENSE for license details.
//------------------------------------------------------------------------------

// Contributors // Manish Kumar(manishkumar5@iisc.ac.in), Shubham Yadav(shubhamyadav@iisc.ac.in)
// Sajin S (sajins@alum.iisc.ac.in), Shubham Sunil Garag (shubhamsunil@alum.iisc.ac.in)
// Anuj Phegade (anujphegade@alum.iisc.ac.in), Deepshikha Gusain (deepshikhag@alum.iisc.ac.in)
// Ronit Patel (ronitpatel@alum.iisc.ac.in), Vishal Kumar (vishalkumar@alum.iisc.ac.in)
// Kuruvilla Varghese (kuru@iisc.ac.in)
//*******************************************************************************
`timescale 1ns/1ps
`include "core_defines.vh"
`include "regbit_defines.vh"
`include "bus_defines.vh"

(* keep_hierarchy = "yes" *)
module IFU
#(
    parameter RESET_PC    = 64'h0,
    parameter MEM_TYPE    = "xpm"               // "rtl", "xip", "xpm"
)
(
    input  wire clk,
    input  wire rst,

    input  wire IFU_Stall,      //Stall Frontend

    //Request/Responses to I-Cache (MMU included)
    input  wire                                         ICache_Resp_Hit,        //I-Cache is Hit
    input  wire [`ICACHE_LINE_LEN-1:0]                  ICache_Resp_Line,       //I-Cache Whole Line
    input  wire                                         ICache_Resp_Exception,  //1=>Exception in I$ Fetching
    input  wire [`ECAUSE_LEN-1:0]                       ICache_Resp_ECause,     //Exception cause
    output wire [`XLEN-1:0]                             ICache_Req_FetchPC,     //I-Cache Fetch PC Address

    //requests from Decode/Rename Unit
    input  wire [$clog2(`DECODE_RATE):0]                IB_RdCnt,               //No. of instr to read from IB

    //responses from Branch Functional Unit
    input  wire [`FUBR_RESULT_LEN-1:0]                  FUBRresp,               //Branch Unit Response

    //responses from retire unit
    input  wire [`RETIRE_RATE-1:0]                      Retire_BranchTaken,     //i=1 => ith instr in retire group was taken
    input  wire [`RETIRE_RATE-1:0]                      Retire_BranchMask,      //i=1 => ith instr in retire group was branch

    //responses from SysCtl Unit
    input  wire                                         SysCtl_Redirect,        //1=>execption/interrupt/*RET/ECALL redirection
    input  wire [`XLEN-1:0]                             SysCtl_RedirectPC,      //Redirection address when redirect request is valid

    //Branch Predictor Control Inputs from SysCtl Unit
    input  wire                                         uBTB_Enable,            //1=>Enable uBTB
    input  wire                                         uBTB_RAS_Enable,        //1=>Enable Return Address Stack
    input  wire                                         DP_Enable,              //1=>Enable Direction Predictor

    //Outputs
    output wire [(`DECODE_RATE*`IB_ENTRY_LEN)-1:0]      IB_DataOut,             //IB Read Data Output
    output wire [`DECODE_RATE-1:0]                      IB_OutValid             //i=1 => IB ith output is valid
);


//--------------------------------------------------------------------
// Local Wires
//--------------------------------------------------------------------
wire [`XLEN-1:0]                                uBTB_TargetPC;
wire [`FETCH_RATE_HW_LEN-1:0]                   uBTB_BranchIndex;
wire [`BRANCH_TYPE__LEN-1:0]                    uBTB_BranchType;
wire                                            uBTB_BranchTaken;
wire                                            uBTB_BTBhit;
wire [1:0]                                      uBTB_BTB2bc;
wire [`BTB_WAYS_LEN-1:0]                        uBTB_BTBway;
wire [`XLEN-1:0]                                uBTB_RASpeek;
wire [`BC_RESP_LEN-1:0]                         BCresp;
wire [`FETCH_RATE-1:0]                          DP_2bc;
wire                                            DP_Hit;
wire [(`FETCH_RATE_HW*`BUNDLE_LEN)-1:0]         InstrBundles_IF2;
wire [(`FETCH_RATE_HW*`BUNDLE_LEN)-1:0]         InstrBundles_IF1;
wire [(`BRANCH_TYPE__LEN*`FETCH_RATE_HW)-1:0]   Bundles_BranchType;
wire [`FETCH_RATE_HW-1:0]                       IB_EntryWE_Request;
wire [`FETCH_RATE_HW-1:0]                       IB_EntryWE_Actual;
wire [`FETCH_RATE_HW:0]                         IB_WriteCnt;
wire [(`FETCH_RATE_HW*`IB_ENTRY_LEN)-1:0]       IB_Entries;
wire                                            IB_Full;
wire                                            uBTB_Redirect;
wire [`XLEN-1:0]                                uBTB_NextFetchPC;
wire [`XLEN-1:0]                                BG_NextFetchAddr;
wire                                            BC_Redirect;
wire [`XLEN-1:0]                                BC_NextFetchPC;
reg  [`XLEN-1:0]                                FetchPC_d;

reg                                             uBTB_Stall,uBTB_Bubble;
reg                                             DP_Stall, DP_Bubble, DP_GHR_commit_load;
reg                                             BG_Stall, BG_Flush, BG_Bubble;
reg                                             BQD_Stall, BQD_Bubble;
reg                                             BC_Bubble;
reg                                             IB_Flush;

wire [`IB_DEPTH_LEN:0]                          IB_FreeCnt;
wire [`IB_DEPTH_LEN:0]                          IB_UsedCnt;
wire                                            Fetch_Exception;
wire [`ECAUSE_LEN-1:0]                          Fetch_Ecause;

//generated wires
wire                BranchMispredicted = FUBRresp[`FUBR_RESULT_MISPRED];
wire [`XLEN-1:0]    BranchActualNextPC = FUBRresp[`FUBR_RESULT_BRTARGET];
wire                ICache_Resp_Valid  = ICache_Resp_Hit | ICache_Resp_Exception;
assign              ICache_Req_FetchPC = FetchPC_d;

//Registers
reg  [`XLEN-1:0]    FetchPC;


//--------------------------------------------------------------------
// Sub-Block Instantiation
//--------------------------------------------------------------------
uBTB #(.MEM_TYPE(MEM_TYPE)) uBTB
(
    .clk                        (clk                    ),
    .rst                        (rst                    ),

    .uBTB_Enable                (uBTB_Enable            ),
    .uBTB_RAS_Enable            (uBTB_RAS_Enable        ),

    .FetchPC                    (FetchPC_d              ),
    .Stall                      (uBTB_Stall             ),
    .Bubble                     (uBTB_Bubble            ),

    .uBTB_TargetPC              (uBTB_TargetPC          ),
    .uBTB_BranchIndex           (uBTB_BranchIndex       ),
    .uBTB_BranchType            (uBTB_BranchType        ),
    .uBTB_BranchTaken           (uBTB_BranchTaken       ),
    .uBTB_BTBhit                (uBTB_BTBhit            ),
    .uBTB_BTB2bc                (uBTB_BTB2bc            ),
    .uBTB_BTBway                (uBTB_BTBway            ),
    .uBTB_RASpeek               (uBTB_RASpeek           ),

    .uBTB_Redirect              (uBTB_Redirect          ),
    .uBTB_NextFetchPC           (uBTB_NextFetchPC       ),

    .BCresp                     (BCresp                 ),

    .FUBRresp                   (FUBRresp               )
);

DP #(.MEM_TYPE(MEM_TYPE)) Direction_Predictor
(
    .clk                        (clk                    ),
    .rst                        (rst                    ),

    .DP_Enable                  (DP_Enable              ),

    .FetchPC                    (FetchPC                ),
    .Stall                      (DP_Stall               ),
    .Bubble                     (DP_Bubble              ),

    .DP_2bc                     (DP_2bc                 ),
    .DP_Hit                     (DP_Hit                 ),

    .FUBRresp                   (FUBRresp               ),
    .BCresp                     (BCresp                 ),

    .branch_commit_taken        (Retire_BranchTaken     ),
    .branch_commit_mask         (Retire_BranchMask      ),
    .GHR_commit_load            (DP_GHR_commit_load     )
);

Bundle_Generator Bundle_Generator
(
    .clk                        (clk                    ),
    .rst                        (rst                    ),

    .Stall                      (BG_Stall               ),
    .Flush                      (BG_Flush               ),
    .Bubble                     (BG_Bubble              ),

    .FetchPC                    (FetchPC                ),
    .Icache_LineIn              (ICache_Resp_Line       ),
    .Icache_Exception           (ICache_Resp_Exception  ),
    .Icache_Ecause              (ICache_Resp_ECause     ),

    .InstrBundles               (InstrBundles_IF2       ),
    .InstrBundles_async         (InstrBundles_IF1       ),
    .NextFetchAddr              (BG_NextFetchAddr       ),
    .Fetch_Exception            (Fetch_Exception        ),
    .Fetch_Ecause               (Fetch_Ecause           )
);

Branch_Quick_Decoder Branch_Quick_Decoder
(
    .clk                        (clk                    ),
    .rst                        (rst                    ),

    .Stall                      (BQD_Stall              ),
    .Bubble                     (BQD_Bubble             ),

    .InstrBundlesIn             (InstrBundles_IF1       ),
    .BranchType_Bus             (Bundles_BranchType     )
);

Branch_Checker Branch_Checker
(
    .clk                        (clk                    ),
    .rst                        (rst                    ),

    .Bubble                     (BC_Bubble              ),

    .uBTB_TargetPC              (uBTB_TargetPC          ),
    .uBTB_BranchIndex           (uBTB_BranchIndex       ),
    .uBTB_BranchType            (uBTB_BranchType        ),
    .uBTB_BranchTaken           (uBTB_BranchTaken       ),
    .uBTB_BTBhit                (uBTB_BTBhit            ),
    .uBTB_BTB2bc                (uBTB_BTB2bc            ),
    .uBTB_BTBway                (uBTB_BTBway            ),
    .uBTB_RASpeek               (uBTB_RASpeek           ),

    .InstrBundlesIn             (InstrBundles_IF2       ),
    .Fetch_Exception            (Fetch_Exception        ),
    .Fetch_Ecause               (Fetch_Ecause           ),

    .BQD_BranchType_Bus         (Bundles_BranchType     ),

    .DP_2bc_Bus                 (DP_2bc                 ),
    .DP_Hit                     (DP_Hit                 ),

    .BCresp                     (BCresp                 ),

    .BC_NextFetchPC             (BC_NextFetchPC         ),
    .BC_Redirect                (BC_Redirect            ),

    .IB_EntryWE                 (IB_EntryWE_Request     ),
    .IB_Entries                 (IB_Entries             ),
    .IB_WriteCnt                (IB_WriteCnt            )
);

Instruction_Buffer
#(
    .DEPTH(`IB_DEPTH),
    .WIDTH(`IB_ENTRY_LEN),
    .WRITE_PORTS(`FETCH_RATE_HW),
    .READ_PORTS(`RENAME_RATE),
    .MEM_TYPE(MEM_TYPE)
)
Instruction_Buffer
(
    .clk                        (clk                    ),
    .rst                        (rst                    ),

    .Flush                      (IB_Flush               ),

    .DataIn                     (IB_Entries             ),
    .WriteEnable                (IB_EntryWE_Actual      ),

    .ReadEnableCnt              (IB_RdCnt               ),
    .DataOut                    (IB_DataOut             ),

    .FreeCnt                    (IB_FreeCnt             ),
    .UsedCnt                    (IB_UsedCnt             ),
    .OutputValidMask            (IB_OutValid            )
);



//--------------------------------------------------------------------
// FetchPC_d MUX logic & FetchPC register logic
//--------------------------------------------------------------------
//Delay reset by 1 clk so that next fetch address is RESET_PC on next clk edge
//after rst
reg rst_streched;
always @(posedge clk) begin
    if(rst)
        rst_streched <= 1'b1;
    else
        rst_streched <= rst;
end


always @* begin
    if(SysCtl_Redirect) //exception, interrupt, *CALL, *RET
        FetchPC_d = SysCtl_RedirectPC;
    else if(BranchMispredicted)
        FetchPC_d = BranchActualNextPC;
    else if(BC_Redirect)
        FetchPC_d = BC_NextFetchPC;
    else if(uBTB_Redirect)
        FetchPC_d = uBTB_NextFetchPC;
    else if(ICache_Resp_Valid & ~IB_Full & ~rst_streched)
        FetchPC_d = BG_NextFetchAddr;
    else
        FetchPC_d = FetchPC;
end

always @(posedge clk) begin
    if(rst)
        FetchPC <= RESET_PC;
    else
        FetchPC <= FetchPC_d;
end


//--------------------------------------------------------------------
// Subunit Stall/Flush/Bubble logic
//--------------------------------------------------------------------
//IB Full Logic: if(IB Free Space < instr to write) => IB_Full
assign IB_Full = ((IB_FreeCnt <= IB_WriteCnt) || IB_FreeCnt==0) ? 1'b1 : 1'b0;
assign IB_EntryWE_Actual = (IB_Full==1'b1) ? 0 : IB_EntryWE_Request;

always @* begin
    uBTB_Stall=0;   uBTB_Bubble=0;  DP_Stall=0;     DP_Bubble=0;    DP_GHR_commit_load=0;
    BG_Stall=0;     BG_Flush=0;     BQD_Stall=0;    BQD_Bubble=0;   BC_Bubble=0;    IB_Flush=0;
    BG_Bubble=0;

    if(SysCtl_Redirect || BranchMispredicted) begin
        IB_Flush    = 1'b1;
        BC_Bubble   = 1'b1;
        BG_Flush    = 1'b1;
        BQD_Bubble  = 1'b1;
        uBTB_Bubble = 1'b1; uBTB_Stall = 1'b0;
        DP_Bubble   = 1'b1; DP_GHR_commit_load = SysCtl_Redirect;
    end
    else if(IFU_Stall) begin
        BC_Bubble  = 1'b1;
        BG_Stall   = 1'b1;
        BQD_Stall  = 1'b1;
        uBTB_Stall = 1'b1;
        DP_Stall   = 1'b1;
    end
    else begin
        case ({IB_Full,BC_Redirect,~ICache_Resp_Valid})
            3'b100, 3'b110, 3'b111, 3'b101: begin
                BC_Bubble  = 1'b1;
                BG_Stall   = 1'b1;
                BQD_Stall  = 1'b1;
                uBTB_Stall = 1'b1;
                DP_Stall   = 1'b1;
            end
            3'b010, 3'b011: begin
                BG_Flush    = 1'b1;
                BQD_Bubble  = 1'b1;
                uBTB_Bubble = 1'b1; uBTB_Stall = 1'b1;
                DP_Bubble   = 1'b1;
            end
            3'b001: begin
                BG_Bubble   = 1'b1;
                BQD_Bubble  = 1'b1;
                uBTB_Bubble = 1'b1; uBTB_Stall = 1'b1;
                DP_Bubble   = 1'b1;
            end
        endcase
    end
end

`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;

    `ifdef DEBUG_IFU
        always @(negedge clk) begin
            $display("[%t] IFU___@STS##: FPC=%h NextFPC=%h | IBfull=%b BCredirect=%b I$hit=%b", $time,
                FetchPC, FetchPC_d,
                IB_Full, BC_Redirect, ICache_Resp_Hit);
        end
    `endif
`endif

endmodule

