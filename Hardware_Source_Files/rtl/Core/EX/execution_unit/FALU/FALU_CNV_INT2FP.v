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
`include "ISA_priv_defines.vh"

(* keep_hierarchy = "yes" *)
module INT2FP
(
    input  wire [63:0]  INPUT,
    input  wire [2:0]   Rounding_Mode,
    input  wire         IsDouble,
    input  wire         IsWord,
    input  wire         Is_Unsigned,
    output reg  [63:0]  OUTPUT,
    output reg          INEXACT
);

wire [7:0] Zero_Exp_SP = {1'b0,{7{1'b1}}}; //BIAS = 127
wire [10:0] Zero_Exp_DP = {1'b0,{10{1'b1}}}; //BIAS = 1023

wire INPUT_zero = IsWord ? (INPUT[30:0]== 0) : (INPUT[62:0]==0);

wire [63:0] INPUT_mag = IsWord ? (Is_Unsigned ? {32'd0,INPUT[31:0]} : (INPUT[31] ? {32'd0,~INPUT[31:0]+32'd1} : {31'd0, INPUT[31:0]}) ) :
                                 (Is_Unsigned ? INPUT               : (INPUT[63] ? -INPUT                     : INPUT               ) ) ;

wire sign = Is_Unsigned ? 1'b0 : (IsWord ? INPUT[31] : INPUT[63]);

wire [5:0] Leading_Zero_Count;
FPLZC  FPLZC (.i(INPUT_mag), .o(Leading_Zero_Count) );

// 63 because for both wourd/double word, we are counting the zeros from the 64th bit.
// Double word=OKAY, WORD=choice->either take 32 and count zeros from 32nd bit, or take 64 and count zeros from 64th bit.
wire [7:0] EXP_SP = INPUT_zero ? 0 : (Zero_Exp_SP + 63 - {2'b0,Leading_Zero_Count});
wire [10:0] EXP_DP = INPUT_zero ? 0 : (Zero_Exp_DP + 63 - {5'b0,Leading_Zero_Count});

wire [63:0] Sig_mag = INPUT_mag << Leading_Zero_Count;

//wire LSB = IsWord ? Sig_mag[8] : Sig_mag[40];
//wire Guard = IsWord ? Sig_mag[7] : Sig_mag[39];
//wire Round = IsWord ? Sig_mag[6] : Sig_mag[38];
//wire Sticky = IsWord ? (|Sig_mag[5:0]) : (|Sig_mag[37:0]);
wire LSB = Sig_mag[40];
wire Guard = Sig_mag[39];
wire Round = Sig_mag[38];
wire Sticky = (|Sig_mag[37:0]);
reg Add_Rounding_Bit;

wire LSB_DP = Sig_mag[11];
wire Guard_DP = Sig_mag[10];
wire Round_DP = Sig_mag[9];
wire Sticky_DP = |Sig_mag[8:0];
reg Add_Rounding_Bit_DP;


always @(*) begin
    case(Rounding_Mode)
        `FCSR_FRM_RNE : begin
                Add_Rounding_Bit = Guard & (LSB | Round | Sticky);
                end
        `FCSR_FRM_RTZ  : begin
                Add_Rounding_Bit = 1'b0;
                end
        `FCSR_FRM_RDN : begin
                Add_Rounding_Bit = Is_Unsigned ? 1'b0 : (sign & (Guard | Round | Sticky));
                end
        `FCSR_FRM_RUP : begin
                Add_Rounding_Bit = Is_Unsigned ? 1'b0 : ((~sign) & (Guard | Round | Sticky));
                end
        `FCSR_FRM_RMM : begin
                Add_Rounding_Bit = Guard;
                end
        default: begin
                Add_Rounding_Bit = 1'b0;
                end
    endcase
end

always @(*) begin
    case(Rounding_Mode)
        `FCSR_FRM_RNE : begin
                Add_Rounding_Bit_DP = Guard_DP & (LSB_DP | Round_DP | Sticky_DP);
                end
        `FCSR_FRM_RTZ  : begin
                Add_Rounding_Bit_DP = 1'b0;
                end
        `FCSR_FRM_RDN : begin
                Add_Rounding_Bit_DP = Is_Unsigned ? 1'b0 : (sign & (Guard_DP | Round_DP | Sticky_DP));
                end
        `FCSR_FRM_RUP : begin
                Add_Rounding_Bit_DP = Is_Unsigned ? 1'b0 : ((~sign) & (Guard_DP | Round_DP | Sticky_DP));
                end
        `FCSR_FRM_RMM : begin
                Add_Rounding_Bit_DP = Guard_DP;
                end
        default: begin
                Add_Rounding_Bit_DP = 1'b0;
                end
    endcase
end

wire [22:0] Mantissa_SP = Sig_mag[62:40];
wire [51:0] Mantissa_DP = Sig_mag[62:11];


always @(*) begin
    if(IsDouble==1) begin
            if (IsWord) begin //no rounding needed as flags will all be zero
                OUTPUT = {sign,EXP_DP,Mantissa_DP};
                INEXACT = 1'b0;
            end
            else begin
                OUTPUT = {sign,EXP_DP,Mantissa_DP} + {63'b0,Add_Rounding_Bit_DP};
                INEXACT = Add_Rounding_Bit_DP;
            end
    end
    else begin
        //Special case of NaN Boxing of Narrower Values (User Spec 12.2)
        OUTPUT = { {32{1'b1}} , ({sign,EXP_SP,Mantissa_SP} + {31'b0,Add_Rounding_Bit}) };
        INEXACT = Add_Rounding_Bit;
    end
end

endmodule

