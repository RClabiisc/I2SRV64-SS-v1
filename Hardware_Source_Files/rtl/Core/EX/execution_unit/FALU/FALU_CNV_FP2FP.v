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

`define QNaN_DP 64'h7FF8000000000000
`define QNaN_SP 32'h7FC00000

(* keep_hierarchy = "yes" *)
module FP2FP
(
    input  wire [63:0]  INPUT,
    input  wire [2:0]   Rounding_Mode,
    input  wire         IsDouble,                 //Output Is Floating Point Double Precision
    output reg  [63:0]  OUTPUT,
    output reg          OVERFLOW,
    output reg          UNDERFLOW,
    output reg          INEXACT
);

//Convertes from SP to DP and DP to SP. So if output is DP,input must be SP
//& vice versa
wire InputIsDouble = ~IsDouble;

wire [10:0] Zero_Exp_DP = {1'b0,{10{1'b1}}};

wire sign = InputIsDouble ? INPUT[63] : INPUT[31];

wire [7:0] exp_INPUT_SP = INPUT[30:23];
wire [10:0] exp_INPUT_DP = INPUT[62:52];

wire [22:0] man_INPUT_SP = INPUT[22:0];
wire [51:0] man_INPUT_DP = INPUT[51:0];

wire INPUT_NaN = InputIsDouble ? ((&exp_INPUT_DP) & (|man_INPUT_DP)) : ((&exp_INPUT_SP) & (|man_INPUT_SP));


wire [10:0] exp_SP_temp = (exp_INPUT_DP - 896);

// NOTE: If the exponent is all zeros, the floating-point number is denormalized and the most significant bit
//of the mantissa is known to be a zero. Otherwise, the floating-point number is normalized and the most
//significant bit of the mantissa is known to be one.

//wire [5:0] Trailing_Zero_Count;
//FPTZC  FPTZC (.i(man_INPUT_DP), .o(Trailing_Zero_Count) );

//wire [10:0] DP_mantessa_len = (23-(52 - {5'b0,Trailing_Zero_Count}));
//wire Not_overflow_DP2SP = (896 - exp_INPUT_DP) < (DP_mantessa_len);
//wire [52:0] man_new_DP = {1'b1,man_INPUT_DP}>>(DP_mantessa_len+1);
//wire [22:0] man_new_SP = man_new_DP[51:29]; // of form 0.M (denormalized)

wire [5:0]check_underflow = (Zero_Exp_DP - exp_INPUT_DP )-127;
wire [52:0] man_new_DP = {1'b1,man_INPUT_DP}>>(check_underflow);


always @(*) begin
    if(INPUT_NaN == 1'b1) begin
       OVERFLOW  = 1'b0;
       UNDERFLOW = 1'b0;
    end
    else if(InputIsDouble==1) begin
        UNDERFLOW  = check_underflow >32;
       OVERFLOW = exp_INPUT_DP > (Zero_Exp_DP + 127); //min exp 1?
    end
    else begin
       // exp range 1 to 254
       OVERFLOW  = (exp_INPUT_SP == 8'hFF);
       UNDERFLOW = (exp_INPUT_SP == 8'h00);
    end
end

wire [7:0] exp_SP = OVERFLOW ? {8{1'b1}} : UNDERFLOW ? {8{1'b0}} : (check_underflow <32 ? 8'b0 : exp_SP_temp[7:0]);
wire [22:0] man_SP = OVERFLOW ? {23{1'b0}} : UNDERFLOW ? {23{1'b0}} : (check_underflow <32 ? man_new_DP[52:30] : man_INPUT_DP[51:29]);

wire [10:0] exp_DP = OVERFLOW ? {11{1'b1}} : UNDERFLOW ? {11{1'b0}} : ({3'b000,exp_INPUT_SP} + 896);
wire [51:0] man_DP = OVERFLOW ? {52{1'b0}} : UNDERFLOW ? {52{1'b0}} : {man_INPUT_SP,{29{1'b0}}};

wire LSB = man_INPUT_DP[29];
wire Guard = man_INPUT_DP[28];
wire Round = man_INPUT_DP[27];
wire Sticky = |man_INPUT_DP[26:0];
reg Add_Rounding_Bit;

always @(*) begin
    case(Rounding_Mode)
        `FCSR_FRM_RNE : begin
                Add_Rounding_Bit = Guard & (LSB | Round | Sticky);
                end
        `FCSR_FRM_RTZ  : begin
                Add_Rounding_Bit = 1'b0;
                end
        `FCSR_FRM_RDN : begin
                Add_Rounding_Bit = (sign & (Guard | Round | Sticky));
                end
        `FCSR_FRM_RUP : begin
                Add_Rounding_Bit = ((~sign) & (Guard | Round | Sticky));
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
    if(IsDouble==1'b0) begin //DP->SP
        if(INPUT_NaN == 1'b1) begin
            //Special case of NaN Boxing of Narrower Values (User Spec 12.2)
            OUTPUT = {{32{1'b1}},`QNaN_SP};
            INEXACT = 1'b0;
        end
        else begin
            OUTPUT = { {32{1'b1}}, ({sign,exp_SP,man_SP} + {31'b0,Add_Rounding_Bit}) };
            INEXACT = Add_Rounding_Bit;
        end
    end
    else begin //SP->DP
        if(INPUT_NaN == 1'b1) begin
            OUTPUT = `QNaN_DP;
            INEXACT = 1'b0;
        end
        else begin
            OUTPUT = {sign,exp_DP,man_DP};
            INEXACT = 1'b0;
        end
    end
end

endmodule

//module FPTZC
//(
//    input [51:0] i,
//    output reg [5:0] o
//);


//// cntlz8 results in faster result than cntlz16
//reg done;
//integer j;
//always @(*)
//begin
//    done = 0;
//    for (j=0;j<52;j=j+1) begin
//        if (i[j]!=0 && (!done)) begin
//            o = j;
//            done =1;
//        end
//    end
//end

//endmodule
