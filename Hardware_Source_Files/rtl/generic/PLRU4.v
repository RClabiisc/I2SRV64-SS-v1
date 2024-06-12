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
`timescale 1ns / 1ps

(* keep_hierarchy = "yes" *)
module PLRU4
#(
    parameter SETS      = 256,
    parameter MEM_TYPE  = "rtl"                 // "rtl", "xip", "xpm"
)
(
    input wire                    clk,          //
    input wire                    rst,          //

    input wire                    UpdateEn,     // 1=>enable LRU state update

    input wire [$clog2(SETS)-1:0] ReadSet,      // Cache set number being read
    input wire [1:0]              ReadWay,      // 1=>Cache Way which is hit on read operation
    input wire                    ReadAccess,   // 1=>Cache Read Operation

    input wire [$clog2(SETS)-1:0] WriteSet,     // Cache set number for cache write operation
    input wire [1:0]              WriteWay,     // Cache Way where write operation will happen (if not known already, connect to PLRU_Way output externally)
    input wire                    WriteAccess,  // Cache Write Operation

    output reg [1:0]              LRU_Way       // LRU Way
);


//Internal wires
reg  [2:0] PLRUwrite_WriteData;
wire [2:0] PLRUwrite_ReadData;
reg  [2:0] PLRUread_WriteData;
wire [2:0] PLRUread_ReadData;
reg        PLRUwrite_WE;
reg        PLRUread_WE;

//memory instantiation
generate
    if(MEM_TYPE=="rtl") begin: RTL
        true_dpram #(.WIDTH(3), .DEPTH(SETS), .SYNC_READ(0))
            PLRU_mem (  .clk        (clk       ),
                        .rst        (rst       ),
                        .port0_din  (PLRUwrite_WriteData),
                        .port0_we   (PLRUwrite_WE),
                        .port0_addr (WriteSet),
                        .port0_en   (1'b1),
                        .port0_dout (PLRUwrite_ReadData),
                        .port1_din  (PLRUread_WriteData),
                        .port1_we   (PLRUread_WE),
                        .port1_en   (1'b1),
                        .port1_addr (ReadSet),
                        .port1_dout (PLRUread_ReadData)
                    );
    end
    else if(MEM_TYPE=="xip") begin: XIP
        //TODO: No Xilinx IP Available for True Dual Port RAM with Async. Read
    end
    else if(MEM_TYPE=="xpm") begin: XPM
        //TODO: XPM Macro can not synthesize True Dual Port RAM with Async.
        //Read
    end
endgenerate


//PLRU update logic
always @*
begin
    PLRUread_WE=0; PLRUwrite_WE=0;
    PLRUwrite_WriteData=0;
    PLRUread_WriteData=0;

    if(UpdateEn) begin
        if(ReadAccess) begin
            PLRUread_WE = 1'b1;
            case (ReadWay)
                2'b00 : PLRUread_WriteData = {2'b11,PLRUread_ReadData[0]};
                2'b01 : PLRUread_WriteData = {2'b10,PLRUread_ReadData[0]};
                2'b10 : PLRUread_WriteData = {1'b0, PLRUread_ReadData[0], 1'b1};
                2'b11 : PLRUread_WriteData = {1'b0, PLRUread_ReadData[0], 1'b0};
            endcase
        end

        if((WriteAccess==1) && ~((ReadAccess==1) && (ReadSet == WriteSet))) begin
            PLRUwrite_WE = 1'b1;
            case (WriteWay)
                2'b00 : PLRUwrite_WriteData = {2'b11,PLRUwrite_ReadData[0]};
                2'b01 : PLRUwrite_WriteData = {2'b10,PLRUwrite_ReadData[0]};
                2'b10 : PLRUwrite_WriteData = {1'b0, PLRUwrite_ReadData[0], 1'b1};
                2'b11 : PLRUwrite_WriteData = {1'b0, PLRUwrite_ReadData[0], 1'b0};
            endcase
        end
    end
end

//LRU way output logic
always @*
begin
    casez(PLRUwrite_ReadData)
        3'b00z : LRU_Way = 2'b00;
        3'b01z : LRU_Way = 2'b01;
        3'b1z0 : LRU_Way = 2'b10;
        3'b1z1 : LRU_Way = 2'b11;
    endcase
end

endmodule
