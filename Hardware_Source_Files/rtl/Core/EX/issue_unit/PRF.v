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

(* keep_hierarchy = "yes" *)
module PRF
#(
    parameter WIDTH       = 64,
    parameter DEPTH       = 32,
    parameter READ_PORTS  = 12,
    parameter WRITE_PORTS = 4,
    parameter [WRITE_PORTS-1:0] FORWARDING  = 0
)
(
    input  wire clk,
    input  wire rst,

    input  wire Stall,  //Global Enable Control
    input  wire Flush,  //Global flush (rst) control

    //Read Port Inputs
    input  wire [(READ_PORTS*$clog2(DEPTH))-1:0]    RdAddr,     //Read Address

    //Write Port Inputs
    input  wire [(WRITE_PORTS*$clog2(DEPTH))-1:0]   WrAddr,     //Write Address
    input  wire [(WRITE_PORTS*WIDTH)-1:0]           WrData,     //Write Data
    input  wire [WRITE_PORTS-1:0]                   WrEn,       //Write Enable

    //Read Port Outputs
    output wire [(READ_PORTS*WIDTH)-1:0]            RdData      //Read Data

);

localparam DEPTH_LEN = $clog2(DEPTH);

//separate wires from merged READ_PORTS
reg  [WIDTH-1:0]        ReadData[0:READ_PORTS-1];
wire [DEPTH_LEN-1:0]    ReadAddr[0:READ_PORTS-1];
genvar gr;
generate
    for(gr=0; gr<READ_PORTS; gr=gr+1) begin
        assign ReadAddr[gr] = RdAddr[gr*DEPTH_LEN+:DEPTH_LEN];
        assign RdData[gr*WIDTH+:WIDTH] = ReadData[gr];
    end
endgenerate

//separate wires from merged WRITE_PORTS
wire [WIDTH-1:0]        WriteData[0:WRITE_PORTS-1];
wire [DEPTH_LEN-1:0]    WriteAddr[0:WRITE_PORTS-1];
wire                    WriteEn[0:WRITE_PORTS-1];
genvar gw;
generate
    for(gw=0; gw<WRITE_PORTS; gw=gw+1) begin
        assign WriteAddr[gw] = WrAddr[gw*DEPTH_LEN+:DEPTH_LEN];
        assign WriteData[gw] = WrData[gw*WIDTH+:WIDTH];
        assign WriteEn[gw]   = WrEn[gw];
    end
endgenerate


//Main Memory
reg  [WIDTH-1:0]    preg[0:DEPTH-1];


//Write Process
integer i,wp;
always @(posedge clk) begin
    if(rst | Flush) begin
        for(i=0; i<DEPTH; i=i+1)
            preg[i] <= 0;
    end
    else if(~Stall) begin
        for(wp=0; wp<WRITE_PORTS; wp=wp+1) begin
            if(WriteEn[wp]==1'b1)
                preg[WriteAddr[wp]] <= WriteData[wp];
        end
    end
end


//Read Process
integer rp,rwp;
always @(*) begin
    for(rp=0; rp<READ_PORTS; rp=rp+1) begin
        ReadData[rp] = preg[ReadAddr[rp]];

        for(rwp=0; rwp<WRITE_PORTS; rwp=rwp+1) begin
            if(FORWARDING[rwp]) begin
                if(WriteEn[rwp] && WriteAddr[rwp]==ReadAddr[rp])
                    ReadData[rp] = WriteData[rwp];
            end
        end
    end
end


endmodule

