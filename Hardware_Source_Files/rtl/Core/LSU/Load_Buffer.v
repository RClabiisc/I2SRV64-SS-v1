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
module Load_Buffer
(
    input  wire     clk,
    input  wire     rst,

    input  wire     Exception_Flush,

    //Load Buffer Write Requests/Responses
    input  wire [`LB_RD_REQ_LEN-1:0]        LBReadReq0,
    output wire [`LB_RD_RESP_LEN-1:0]       LBReadResp0,

    //Load Buffer Masked Data Requests/Responses
    output wire [`LB_MATCH_REQ_LEN-1:0]     LBMatchReq0,
    input  wire [`LB_MATCH_RESP_LEN-1:0]    LBMatchResp0,

    //D-Cache Read Port Request/Response
    output wire                             DCache_RdReq_Valid,
    output wire [55:0]                      DCache_RdReq_Paddr,
    output wire [`DATA_TYPE__LEN-1:0]       DCache_RdReq_DataType,
    output wire                             DCache_RdReq_Abort,
    input  wire                             DCache_RdResp_Done,
    input  wire                             DCache_RdResp_Ready,
    input  wire [63:0]                      DCache_RdResp_Data
);
`include "LSU_func.v"

//convert input ports into Arrays
wire [`LB_RD_REQ_LEN-1:0]           LBReadReq[0:0];
wire [`LB_MATCH_RESP_LEN-1:0]       LBMatchResp[0:0];

assign LBReadReq[0]   = LBReadReq0;      //HACK: Need to be customised for every port
assign LBMatchResp[0] = LBMatchResp0;   //HACK: Need to be customised for every port


//Extract Buses from Arrays to Individual Signals
wire                    i_LoadReq_Valid         = LBReadReq[0][`LB_RD_REQ_VALID];
wire                    i_LoadReq_Killed        = LBReadReq[0][`LB_RD_REQ_KILLED];
wire [2:0]              i_LoadReq_DataType      = LBReadReq[0][`LB_RD_REQ_DATATYPE];
wire [55:0]             i_LoadReq_Paddr         = LBReadReq[0][`LB_RD_REQ_PADDR];

wire                    i_MatchResp_Done        = LBMatchResp[0][`LB_MATCH_RESP_VALID];
wire [15:0]             i_MatchResp_MatchMask   = LBMatchResp[0][`LB_MATCH_RESP_MATCHMASK];
wire [127:0]            i_MatchResp_ByteData    = LBMatchResp[0][`LB_MATCH_RESP_BYTEDATA];

//Outputs
wire                    OutputDone;
wire [63:0]             OutputData;

////////////////////////////////////////////////////////////////////////////////////////////////
//Load Buffer Busy Control
wire OutputDone_d;
reg  LB_Busy;
always @(posedge clk) begin
    if(rst | Exception_Flush) begin
        LB_Busy <= 0;
    end
    else if(LB_Busy==1'b0 && i_LoadReq_Valid==1'b1) begin
        LB_Busy <= 1'b1;
    end
    else if(LB_Busy==1'b1 && i_LoadReq_Valid==1'b0) begin
        LB_Busy <= 1'b0;
    end
end

////////////////////////////////////////////////////////////////////////////////////////////////
//Store Buffer Match FSM
localparam MT_IDLE = 2'b00;
localparam MT_REQ  = 2'b01;
localparam MT_DONE = 2'b11;

//Registers to Latch Data
reg  [1:0]              MatchTxn;
reg  [15:0]             MatchResp_MatchMask;
reg  [127:0]            MatchResp_ByteData;

//Match Request Output to Store Buffer
wire        o_MatchReq_Valid        = (MatchTxn!=MT_DONE) & i_LoadReq_Valid & ~i_LoadReq_Killed;
wire [55:0] o_MatchReq_Paddr        = i_LoadReq_Paddr;
wire [15:0] o_MatchReq_ByteMask     = AddrType2Mask(i_LoadReq_Paddr,i_LoadReq_DataType);

always @(posedge clk) begin
    if(rst | i_LoadReq_Killed)
        MatchTxn <= MT_IDLE;
    else if(MatchTxn==MT_IDLE && i_MatchResp_Done==1'b1) //Since Match Txn is single cycle
        MatchTxn <= MT_DONE;
    /*else if(MatchTxn==MT_IDLE && i_LoadReq_Valid==1'b1)//For future multicycle compatibility
        MatchTxn <= MT_REQ;
    else if(MatchTxn==MT_REQ && i_MatchResp_Done==1'b1)
        MatchTxn <= MT_DONE;*/
    else if(MatchTxn==MT_DONE && OutputDone)
        MatchTxn <= MT_IDLE;

end

always @(posedge clk) begin
    if(rst) begin
        MatchResp_MatchMask <= 0;
        MatchResp_ByteData  <= 0;
    end
    else if(MatchTxn==MT_IDLE && i_MatchResp_Done) begin
        MatchResp_MatchMask <= i_MatchResp_MatchMask;
        MatchResp_ByteData  <= i_MatchResp_ByteData;
    end
    else if(MatchTxn==MT_DONE && OutputDone) begin
        MatchResp_MatchMask <= 0;
        MatchResp_ByteData  <= 0;
    end
end


////////////////////////////////////////////////////////////////////////////////////////////////
//DCache Done Latching register
localparam DC_IDLE = 2'b00;
localparam DC_REQ  = 2'b01;
localparam DC_DONE = 2'b11;

//D-Cache FSM
reg [1:0] DCacheTxn;
always @(posedge clk) begin
    if(rst | i_LoadReq_Killed)
        DCacheTxn <= DC_IDLE;
    else if(DCacheTxn==DC_IDLE && i_LoadReq_Valid==1'b1 && DCache_RdResp_Ready==1'b1)
        DCacheTxn <= DC_REQ;
    else if(DCacheTxn==DC_REQ && DCache_RdResp_Done && OutputDone_d)
    /*    DCacheTxn <= DC_DONE;
    else if(DCacheTxn==DC_DONE && OutputDone) */
        DCacheTxn <= DC_IDLE;
end

//D-Cache Request Outputs
assign DCache_RdReq_Valid      = i_LoadReq_Valid & ~i_LoadReq_Killed & DCache_RdResp_Ready;
assign DCache_RdReq_Paddr      = i_LoadReq_Paddr;
assign DCache_RdReq_DataType   = i_LoadReq_DataType;
assign DCache_RdReq_Abort      = i_LoadReq_Killed;

////////////////////////////////////////////////////////////////////////////////////////////////
//Output data assembly combo process
reg  [127:0] DCacheResp_ByteData;   //Data from D-Cache aligned to double word boundary and converted to QuadWord
reg  [127:0] Merged_ByteData;       //Output Bytedata generated by muxing from match response and D-Cache Response
reg  [63:0]  Merged_Data;           //ByteData converted to Double Word
reg  [63:0]  OutputData_d;          //Final Data as per DataType

integer m;
always @* begin
    //align DCache Output to DoubleWord Boundary in Quadword format
    DCacheResp_ByteData = AlignDataByAddr(DCache_RdResp_Data,i_LoadReq_Paddr);

    //for every byte in Match Response, if match is found in use data from
    //Store Buffer else use from D-Cache
    for(m=0; m<16; m=m+1) begin
        Merged_ByteData[m*8+:8] = MatchResp_MatchMask[m] ? MatchResp_ByteData[m*8+:8] : DCacheResp_ByteData[m*8+:8];
    end

    //convert ByteMask to 64-bit unaligned data
    Merged_Data = Merged_ByteData>>{i_LoadReq_Paddr[2:0],3'b000};

    //convert 64-bit data as per DataType
    case(i_LoadReq_DataType)
        `DATA_TYPE_B  : OutputData_d = {{56{Merged_Data[ 7]}},Merged_Data[7 :0]};
        `DATA_TYPE_H  : OutputData_d = {{48{Merged_Data[15]}},Merged_Data[15:0]};
        `DATA_TYPE_W  : OutputData_d = {{32{Merged_Data[31]}},Merged_Data[31:0]};
        `DATA_TYPE_D  : OutputData_d = Merged_Data;
        `DATA_TYPE_BU : OutputData_d = {56'b0,Merged_Data[ 7:0]};
        `DATA_TYPE_HU : OutputData_d = {48'b0,Merged_Data[15:0]};
        `DATA_TYPE_WU : OutputData_d = {32'b0,Merged_Data[31:0]};
        default:        OutputData_d = 0;
    endcase
end

//OutputDone_d Logic
//NOTE: As We are not registering DCache o/p direct done output is used to produce OutputDone_d
assign OutputDone_d = (MatchTxn==MT_DONE) && (DCacheTxn==DC_REQ && DCache_RdResp_Done) && i_LoadReq_Killed==1'b0;


//Final Output Valid Process
assign OutputDone = rst ? 1'b0 : OutputDone_d;

//Final Output Data Process
assign  OutputData  = OutputData_d;

////////////////////////////////////////////////////////////////////////////////////////////////
//convert individual signals to busses
wire [`LB_MATCH_REQ_LEN-1:0] LBMatchReq[0:0];
wire [`LB_RD_RESP_LEN-1:0]   LBReadResp[0:0];

assign LBMatchReq[0][`LB_MATCH_REQ_VALID]   = o_MatchReq_Valid;
assign LBMatchReq[0][`LB_MATCH_REQ_PADDR]   = o_MatchReq_Paddr;
assign LBMatchReq[0][`LB_MATCH_REQ_BYTEMASK]= o_MatchReq_ByteMask;

assign LBReadResp[0][`LB_RD_RESP_DONE]      = OutputDone;
assign LBReadResp[0][`LB_RD_RESP_READY]     = (MatchTxn==MT_IDLE) && (DCacheTxn==DC_IDLE);
assign LBReadResp[0][`LB_RD_RESP_DATA]      = OutputData;

//convert Arrays into output ports
assign LBReadResp0 = LBReadResp[0];
assign LBMatchReq0 = LBMatchReq[0];


endmodule

