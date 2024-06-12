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
`timescale 1ns / 1ps

`define RNE 3'b000
`define RZ  3'b001
`define RDN 3'b010
`define RUP 3'b011
`define RMM 3'b100

module Rounding_Mode_DP
(
    input  wire [64:0] EXP_FRAC,
    input  wire [2:0] Rounding_Mode,
    input  wire [2:0] Guard_Bits,
    input  wire Sign,
    output reg  [64:0] OUT_EXP_FRAC,
    output reg  INEXACT
);

wire LSB;
wire Guard;
wire Round;
wire Sticky;
reg Add_Rounding_Bit;

assign LSB = EXP_FRAC[0];
assign Guard = Guard_Bits[2];
assign Round = Guard_Bits[1];
assign Sticky = Guard_Bits[0];

always @(*) begin
    case(Rounding_Mode)
        `RNE : begin
                Add_Rounding_Bit <= Guard & (LSB | Round | Sticky);
                end
        `RZ  : begin
                Add_Rounding_Bit <= 1'b0;
                end
        `RDN : begin
                Add_Rounding_Bit <= Sign & (Guard | Round | Sticky);
                end
        `RUP : begin
                Add_Rounding_Bit <= (~Sign) & (Guard | Round | Sticky);
                end
        `RMM : begin
                Add_Rounding_Bit <= Guard;
                end
        default: begin
                Add_Rounding_Bit <= 1'b0;
                end
    endcase
end

always @(*) begin
    OUT_EXP_FRAC = EXP_FRAC + {64'b0000000000000000000000000000000000000000000000000000000000000000, Add_Rounding_Bit};

    INEXACT <= (Guard | Round | Sticky);
end
endmodule

