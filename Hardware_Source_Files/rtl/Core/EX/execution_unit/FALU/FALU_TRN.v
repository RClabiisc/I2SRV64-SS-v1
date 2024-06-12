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
`include "core_typedefs.vh"

(* keep_hierarchy = "yes" *)
module FALU_TRN
(
    input  wire [63:0]  INPUT,
    input  wire         IsDouble,
    input  wire [2:0]   OPERATION,
    output reg [63:0]   OUTPUT
);

wire sign_SP = INPUT[31];
wire sign_DP = INPUT[63];

wire [7:0] exp_SP = INPUT[30:23];
wire [10:0] exp_DP = INPUT[62:52];

wire [22:0] man_SP = INPUT[22:0];
wire [51:0] man_DP = INPUT[51:0];

wire NEG_INFINITY  = IsDouble ? ((sign_DP) & (&exp_DP) & ~(|man_DP)) : ((sign_SP) & (&exp_SP) & ~(|man_SP));
wire NEG_SUBNORMAL = IsDouble ? ((sign_DP) & ~(|exp_DP) & (|man_DP)) : ((sign_SP) & ~(|exp_SP) & (|man_SP));
wire NEG_ZERO      = IsDouble ? ((sign_DP) & ~(|exp_DP) & ~(|man_DP)) : ((sign_SP) & ~(|exp_SP) & ~(|man_SP));
wire POS_ZERO      = IsDouble ? ((~sign_DP) & ~(|exp_DP) & ~(|man_DP)) : ((~sign_SP) & ~(|exp_SP) & ~(|man_SP));
wire POS_SUBNORMAL = IsDouble ? ((~sign_DP) & ~(|exp_DP) & (|man_DP)) : ((~sign_SP) & ~(|exp_SP) & (|man_SP));
wire POS_INFINITY  = IsDouble ? ((~sign_DP) & (&exp_DP) & ~(|man_DP)) : ((~sign_SP) & (&exp_SP) & ~(|man_SP));
wire SIGNALING_NAN = IsDouble ? ((&exp_DP) & ~man_DP[51] & (|man_DP)) : ((&exp_SP) & ~man_SP[22]  & (|man_SP));
wire QUIET_NAN     = IsDouble ? ((&exp_DP) & man_DP[51]) : ((&exp_SP) & man_SP[22]);
wire NEG_NORMAL    = IsDouble ? ((sign_DP) & ~NEG_INFINITY & ~NEG_SUBNORMAL & ~NEG_ZERO & ~SIGNALING_NAN & ~QUIET_NAN) : ((sign_SP) & ~NEG_INFINITY & ~NEG_SUBNORMAL & ~NEG_ZERO & ~SIGNALING_NAN & ~QUIET_NAN);
wire POS_NORMAL    = IsDouble ? ((~sign_DP) & ~POS_INFINITY & ~POS_SUBNORMAL & ~POS_ZERO & ~SIGNALING_NAN & ~QUIET_NAN) : ((~sign_SP) & ~POS_INFINITY & ~POS_SUBNORMAL & ~POS_ZERO & ~SIGNALING_NAN & ~QUIET_NAN);


always @ (*) begin
    case (OPERATION)
        `FPU_SUBOP_TRN_INT2FP : begin
            //Special case for NaN Boxing of Narrower Values (User Spec 12.2)
            OUTPUT = (IsDouble) ? INPUT : {{32{1'b1}},INPUT[31:0]};
        end

        `FPU_SUBOP_TRN_FP2INT : begin
            //From Spec:For RV64, the higher 32 bits of the destination register are filled
            //with copies of the floating-point number’s sign bit
            OUTPUT = (IsDouble) ? INPUT : {{32{INPUT[31]}}, INPUT[31:0]};
        end

        `FPU_SUBOP_TRN_FCLASS : begin
            OUTPUT = {{54{1'b0}}, QUIET_NAN,  SIGNALING_NAN, POS_INFINITY, POS_NORMAL, POS_SUBNORMAL, POS_ZERO, NEG_ZERO, NEG_SUBNORMAL, NEG_NORMAL, NEG_INFINITY};
        end

        default : begin
            OUTPUT = 0;
        end
    endcase
end

endmodule

