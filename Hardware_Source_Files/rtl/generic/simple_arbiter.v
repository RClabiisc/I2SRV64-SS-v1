//******************************************************************************
// Copyright (c) 2018 - 2023, Indian Institute of Science, Bangalore.
// All Rights Reserved. See LICENSE for license details.
//------------------------------------------------------------------------------

// Contributors // Manish Kumar(manishkumar5@iisc.ac.in), Shubham Yadav(shubhamyadav@iisc.ac.in)
// Sajin S (sajins@alum.iisc.ac.in, Shubham Sunil Garag (shubhamsunil@alum.iisc.ac.in)
// Anuj Phegade (anujphegade@alum.iisc.ac.in), Deepshikha Gusain (deepshikhag@alum.iisc.ac.in)
// Ronit Patel (ronitpatel@alum.iisc.ac.in), Vishal Kumar (vishalkumar@alum.iisc.ac.in)
// Kuruvilla Varghese (kuru@iisc.ac.in)
//******************************************************************************
`timescale 1ns/1ps

(* keep_hierarchy = "yes" *)
module simple_arbiter
#(
    parameter PORTS = 3,
    parameter ADDR_WIDTH = 56,
    parameter DATA_WIDTH = 64,
    parameter DATA_TYPE_WIDTH = 3
)
(
    input  wire clk,
    input  wire rst,

    input  wire                         InReq0_Valid,
    input  wire [ADDR_WIDTH-1:0]        InReq0_Addr,
    input  wire [DATA_TYPE_WIDTH-1:0]   InReq0_DataType,
    input  wire                         InReq0_Abort,
    output wire                         InResp0_Done,
    output wire                         InResp0_Ready,
    output wire [DATA_WIDTH-1:0]        InResp0_Data,

    input  wire                         InReq1_Valid,
    input  wire [ADDR_WIDTH-1:0]        InReq1_Addr,
    input  wire [DATA_TYPE_WIDTH-1:0]   InReq1_DataType,
    input  wire                         InReq1_Abort,
    output wire                         InResp1_Done,
    output wire                         InResp1_Ready,
    output wire [DATA_WIDTH-1:0]        InResp1_Data,

    input  wire                         InReq2_Valid,
    input  wire [ADDR_WIDTH-1:0]        InReq2_Addr,
    input  wire [DATA_TYPE_WIDTH-1:0]   InReq2_DataType,
    input  wire                         InReq2_Abort,
    output wire                         InResp2_Done,
    output wire                         InResp2_Ready,
    output wire [DATA_WIDTH-1:0]        InResp2_Data,

    output reg                          OutReq_Valid,
    output reg  [ADDR_WIDTH-1:0]        OutReq_Addr,
    output reg  [DATA_TYPE_WIDTH-1:0]   OutReq_DataType,
    output reg                          OutReq_Abort,
    input  wire                         OutResp_Done,
    input  wire                         OutResp_Ready,
    input  wire [DATA_WIDTH-1:0]        OutResp_Data
);

//convert wires to arrays
localparam AW = ADDR_WIDTH;
localparam DW = DATA_WIDTH;
localparam DTW= DATA_TYPE_WIDTH;

wire                         InReq_Valid    [0:PORTS-1];
wire [ADDR_WIDTH-1:0]        InReq_Addr     [0:PORTS-1];
wire [DATA_TYPE_WIDTH-1:0]   InReq_DataType [0:PORTS-1];
wire                         InReq_Abort    [0:PORTS-1];
reg                          InResp_Done    [0:PORTS-1];
wire                         InResp_Ready   [0:PORTS-1];
reg  [DATA_WIDTH-1:0]        InResp_Data    [0:PORTS-1];

//HACK: Fix this for number of ports
assign InReq_Valid[0]    = InReq0_Valid;
assign InReq_Addr[0]     = InReq0_Addr;
assign InReq_DataType[0] = InReq0_DataType;
assign InReq_Abort[0]    = InReq0_Abort;
assign InResp0_Done      = InResp_Done[0];
assign InResp0_Ready     = InResp_Ready[0];
assign InResp0_Data      = InResp_Data[0];

assign InReq_Valid[1]    = InReq1_Valid;
assign InReq_Addr[1]     = InReq1_Addr;
assign InReq_DataType[1] = InReq1_DataType;
assign InReq_Abort[1]    = InReq1_Abort;
assign InResp1_Done      = InResp_Done[1];
assign InResp1_Ready     = InResp_Ready[1];
assign InResp1_Data      = InResp_Data[1];

assign InReq_Valid[2]    = InReq2_Valid;
assign InReq_Addr[2]     = InReq2_Addr;
assign InReq_DataType[2] = InReq2_DataType;
assign InReq_Abort[2]    = InReq2_Abort;
assign InResp2_Done      = InResp_Done[2];
assign InResp2_Ready     = InResp_Ready[2];
assign InResp2_Data      = InResp_Data[2];

//Internal Registers & Variable/Wires
reg                     ReqPending [0:PORTS-1];
reg                     TargetBusy, TargetBusy_d;
reg [$clog2(PORTS)-1:0] ActiveRequest, ActiveRequest_d;

//convert input request pulse to level
integer i;
always @(posedge clk) begin
    for(i=0; i<PORTS; i=i+1) begin
        if(rst)
            ReqPending[i] <= 1'b0;
        else if(ReqPending[i]==1'b1 &&
            ( (ActiveRequest==i && OutResp_Done) || InReq_Abort[i]) ) //modified to InReq_Abort[i] from InReq_Abort[active Request]  //clear pending when done or abort 
            ReqPending[i] <= 1'b0;
        else if(InReq_Valid[i])
            ReqPending[i] <= 1'b1;
    end
end

//Select Highest Priority Request as active if No Requsest is Ongoing
integer a;
always @(*) begin
    if(TargetBusy) begin
        if(OutResp_Done || InReq_Abort[ActiveRequest]) begin
            //One Request Completed.
            //Next Will be checked in next cycle
            TargetBusy_d    = 1'b0;
            ActiveRequest_d = ActiveRequest;
        end
        else begin
            //Current Ruquest is going one
            //Maintain old values
            TargetBusy_d    = TargetBusy;
            ActiveRequest_d = ActiveRequest;
        end
    end
    else begin
        //No Active Request => Check for new request
        TargetBusy_d    = 1'b0;
        ActiveRequest_d = ActiveRequest;
        //Higher Port Number Higher is the priority
        for(a=0; a<PORTS; a=a+1) begin
            if((OutResp_Ready) && (ReqPending[a]==1'b1 || InReq_Valid[a]) && !InReq_Abort[a]) begin
                TargetBusy_d    = 1'b1;
                ActiveRequest_d = a;
            end
        end
    end
end
always @(posedge clk) begin
    if(rst) begin
        TargetBusy    <= 1'b0;
        ActiveRequest <= 0;
    end
    else begin
        TargetBusy    <= TargetBusy_d;
        ActiveRequest <= ActiveRequest_d;
    end
end

//Route Request from Active Request to Target and Response from target to
//Active Request's Response
genvar gj;
generate
    for(gj=0; gj<PORTS; gj=gj+1) begin
        assign InResp_Ready[gj] = OutResp_Ready;
    end
endgenerate

integer j;
always @* begin
    OutReq_Addr                 = InReq_Addr[ActiveRequest_d];
    OutReq_DataType             = InReq_DataType[ActiveRequest_d];

    if(TargetBusy==1'b0 && TargetBusy_d==1'b0) begin
        OutReq_Valid        = 1'b0;
        for(j=0; j<PORTS; j=j+1) begin
            InResp_Done[j]  = 1'b0;
            InResp_Data[j]  = 0;
        end
    end
    else begin
        for(j=0; j<PORTS; j=j+1) begin
            InResp_Done[j]  = 1'b0;
            InResp_Data[j]  = 0;
        end
        OutReq_Valid                = 1'b1;
        InResp_Done[ActiveRequest]  = OutResp_Done;
        InResp_Data[ActiveRequest]  = OutResp_Data;
    end

    OutReq_Abort = TargetBusy ? InReq_Abort[ActiveRequest] : 1'b0;
end


endmodule

