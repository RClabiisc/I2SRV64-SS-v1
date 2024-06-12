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

`define QNaN_DP 64'h7FF8000000000000
`define QNaN_SP 32'h7FC00000

(* keep_hierarchy = "yes" *)
module FALU_CMP
(
    input  wire [63:0]  INPUT_1,
    input  wire [63:0]  INPUT_2,
    input  wire         IsDouble,
    input  wire [2:0]   OPERATION,
    output reg  [63:0]  OUTPUT,
    output reg          INVALID
);


//modify input as per NaN Boxing
wire [63:0] INPUT1 = IsDouble ? INPUT_1 : (&INPUT_1[63:32] ? {{32{1'b1}}, INPUT_1[31:0]} : 64'hffffffff7fc00000);
wire [63:0] INPUT2 = IsDouble ? INPUT_2 : (&INPUT_2[63:32] ? {{32{1'b1}}, INPUT_2[31:0]} : 64'hffffffff7fc00000);

wire INPUT_1_QNAN_SP = (&INPUT1[30:23]) & (INPUT1[22]);
wire INPUT_2_QNAN_SP = (&INPUT2[30:23]) & (INPUT2[22]);
wire INPUT_1_QNAN_DP = (&INPUT1[62:52]) & (INPUT1[51]);
wire INPUT_2_QNAN_DP = (&INPUT2[62:52]) & (INPUT2[51]);

wire INPUT_1_SNAN_SP = (&INPUT1[30:23]) & (~INPUT1[22]) & (|INPUT1[22:0]);
wire INPUT_2_SNAN_SP = (&INPUT2[30:23]) & (~INPUT2[22]) & (|INPUT2[22:0]);
wire INPUT_1_SNAN_DP = (&INPUT1[62:52]) & (~INPUT1[51]) & (|INPUT1[51:0]);
wire INPUT_2_SNAN_DP = (&INPUT2[62:52]) & (~INPUT2[51]) & (|INPUT2[51:0]);


wire EQ;
wire LT;
wire LE;

FPCompare FP_Compare( .INPUT_1(INPUT1), .INPUT_2(INPUT2), .IsDouble(IsDouble), .EQ(EQ), .LT(LT), .LE(LE));

always @(*) begin
    if(IsDouble == 1) begin
        case(OPERATION)
            `FPU_SUBOP_CMP_EQ : begin
                if(INPUT_1_SNAN_DP | INPUT_2_SNAN_DP) begin
                    INVALID = 1'b1;
                    OUTPUT = {64{1'b0}};
                end
                else if(INPUT_1_QNAN_DP | INPUT_2_QNAN_DP) begin
                    INVALID = 1'b0;
                    OUTPUT = {64{1'b0}};
                end
                else begin
                    INVALID = 1'b0;
                    OUTPUT = {{63{1'b0}},EQ};
                end
            end
            `FPU_SUBOP_CMP_LT : begin
                if(INPUT_1_SNAN_DP | INPUT_2_SNAN_DP | INPUT_1_QNAN_DP | INPUT_2_QNAN_DP) begin
                    INVALID = 1'b1;
                    OUTPUT = {64{1'b0}};
                end
                else begin
                    INVALID = 1'b0;
                    OUTPUT = {{63{1'b0}},LT};
                end
            end
            `FPU_SUBOP_CMP_LE : begin
                if(INPUT_1_SNAN_DP | INPUT_2_SNAN_DP | INPUT_1_QNAN_DP | INPUT_2_QNAN_DP) begin
                    INVALID = 1'b1;
                    OUTPUT = {64{1'b0}};
                end
                else begin
                    INVALID = 1'b0;
                    OUTPUT = {{63{1'b0}},LE};
                end
            end
            `FPU_SUBOP_CMP_MIN : begin
                if(INPUT_1_SNAN_DP | INPUT_2_SNAN_DP | (INPUT_1_QNAN_DP & INPUT_2_QNAN_DP)) begin
                    INVALID = 1'b0;
                    OUTPUT = `QNaN_DP;
                end
                else if (INPUT_1_QNAN_DP) begin
                    INVALID = 1'b0;
                    OUTPUT = INPUT2;
                end
                else if (INPUT_2_QNAN_DP) begin
                    INVALID = 1'b0;
                    OUTPUT = INPUT1;
                end
                else begin
                    if (EQ == 1'b1) begin
                        OUTPUT = INPUT1;
                    end
                    else if (LT == 1'b1) begin
                        OUTPUT = INPUT1;
                    end
                    else begin
                        OUTPUT = INPUT2;
                    end
                    INVALID = 1'b0;
                 end
            end
            `FPU_SUBOP_CMP_MAX : begin
                if((INPUT_1_QNAN_DP & INPUT_2_QNAN_DP)) begin
                    INVALID = 1'b0;
                    OUTPUT = `QNaN_DP;
                end
                else if (INPUT_1_SNAN_DP) begin
                    INVALID = 1'b1;
                    OUTPUT = INPUT2;
                end
                else if(INPUT_2_SNAN_DP) begin
                    INVALID = 1'b1;
                    OUTPUT = INPUT1;
                end
                else if (INPUT_1_QNAN_DP) begin
                    INVALID = 1'b0;
                    OUTPUT = INPUT2;
                end
                else if (INPUT_2_QNAN_DP) begin
                    INVALID = 1'b0;
                    OUTPUT = INPUT1;
                end
                else begin
                    if (EQ == 1'b1) begin
                        OUTPUT = INPUT1;
                    end
                    else if (LT == 1'b1) begin
                        OUTPUT = INPUT2;
                    end
                    else begin
                        OUTPUT = INPUT1;
                    end
                    INVALID = 1'b0;
                 end
            end
            default: begin
                INVALID = 1'b0;
                OUTPUT = 0;
            end
        endcase
    end
    else begin
        case(OPERATION)
            `FPU_SUBOP_CMP_EQ : begin
                if(INPUT_1_SNAN_SP | INPUT_2_SNAN_SP) begin
                    INVALID = 1'b1;
                    OUTPUT = {64{1'b0}};
                end
                else if(INPUT_1_QNAN_SP | INPUT_2_QNAN_SP) begin
                    INVALID = 1'b0;
                    OUTPUT = {64{1'b0}};
                end
                else begin
                    INVALID = 1'b0;
                    OUTPUT = {{63{1'b0}},EQ};
                end
            end
            `FPU_SUBOP_CMP_LT : begin
                if(INPUT_1_SNAN_SP | INPUT_2_SNAN_SP | INPUT_1_QNAN_SP | INPUT_2_QNAN_SP) begin
                    INVALID = 1'b1;
                    OUTPUT = {64{1'b0}};
                end
                else begin
                    INVALID = 1'b0;
                    OUTPUT = {{63{1'b0}},LT};
                end
            end
            `FPU_SUBOP_CMP_LE : begin
                if(INPUT_1_SNAN_SP | INPUT_2_SNAN_SP | INPUT_1_QNAN_SP | INPUT_2_QNAN_SP) begin
                    INVALID = 1'b1;
                    OUTPUT = {64{1'b0}};
                end
                else begin
                    INVALID = 1'b0;
                    OUTPUT = {{63{1'b0}},LE};
                end
            end
            `FPU_SUBOP_CMP_MIN : begin
                if(INPUT_1_SNAN_SP | INPUT_2_SNAN_SP | (INPUT_1_QNAN_SP & INPUT_2_QNAN_SP)) begin
                    INVALID = 1'b0;
                    //Special case of NaN Boxing of Narrower Values (User Spec 12.2)
                    OUTPUT = {{32{1'b1}},`QNaN_SP};
                end
                else if (INPUT_1_QNAN_SP) begin
                    INVALID = 1'b0;
                    //Special case of NaN Boxing of Narrower Values (User Spec 12.2)
                    OUTPUT = {{32{1'b1}},INPUT2[31:0]};
                end
                else if (INPUT_2_QNAN_SP) begin
                    INVALID = 1'b0;
                    //Special case of NaN Boxing of Narrower Values (User Spec 12.2)
                    OUTPUT = {{32{1'b1}},INPUT1[31:0]};
                end
                else begin
                    if (EQ == 1'b1) begin
                        //Special case of NaN Boxing of Narrower Values (User Spec 12.2)
                        OUTPUT = {{32{1'b1}},INPUT1[31:0]};
                    end
                    else if (LT == 1'b1) begin
                        //Special case of NaN Boxing of Narrower Values (User Spec 12.2)
                        OUTPUT = {{32{1'b1}},INPUT1[31:0]};
                    end
                    else begin
                        //Special case of NaN Boxing of Narrower Values (User Spec 12.2)
                        OUTPUT = {{32{1'b1}},INPUT2[31:0]};
                    end
                    INVALID = 1'b0;
                 end
            end
            `FPU_SUBOP_CMP_MAX : begin
                if((INPUT_1_QNAN_SP & INPUT_2_QNAN_SP)) begin
                    INVALID = 1'b0;
                    //Special case of NaN Boxing of Narrower Values (User Spec 12.2)
                    OUTPUT = {{32{1'b1}},`QNaN_SP};
                end
                else if (INPUT_1_SNAN_SP) begin
                    INVALID = 1'b1;
                    OUTPUT = {{32{1'b1}},INPUT2[31:0]};
                end
                else if(INPUT_2_SNAN_SP) begin
                    INVALID = 1'b1;
                    OUTPUT = {{32{1'b1}},INPUT1[31:0]};
                end
                else if (INPUT_1_QNAN_SP) begin
                    INVALID = 1'b0;
                    //Special case of NaN Boxing of Narrower Values (User Spec 12.2)
                    OUTPUT = {{32{1'b1}},INPUT2[31:0]};
                end
                else if (INPUT_2_QNAN_SP) begin
                    INVALID = 1'b0;
                    //Special case of NaN Boxing of Narrower Values (User Spec 12.2)
                    OUTPUT = {{32{1'b1}},INPUT1[31:0]};
                end
                else begin
                    if (EQ == 1'b1) begin
                        //Special case of NaN Boxing of Narrower Values (User Spec 12.2)
                        OUTPUT = {{32{1'b1}},INPUT1[31:0]};
                    end
                    else if (LT == 1'b1) begin
                        //Special case of NaN Boxing of Narrower Values (User Spec 12.2)
                        OUTPUT = {{32{1'b1}},INPUT2[31:0]};
                    end
                    else begin
                        //Special case of NaN Boxing of Narrower Values (User Spec 12.2)
                        OUTPUT = {{32{1'b1}},INPUT1[31:0]};
                    end
                    INVALID = 1'b0;
                 end
            end
            default: begin
                INVALID = 1'b0;
                OUTPUT = 0;
            end
        endcase
    end
end

endmodule


///////////////////////////////////////////////////////////////////////////////
module FPCompare
(
    input  wire [63:0] INPUT_1,
    input  wire [63:0] INPUT_2,
    input  wire IsDouble,
    output reg  EQ,
    output reg  LT,
    output reg  LE
);

wire INPUT_1_zero_SP = INPUT_1[30:0]==0;
wire INPUT_1_zero_DP = INPUT_1[62:0]==0;
wire INPUT_2_zero_SP = INPUT_2[30:0]==0;
wire INPUT_2_zero_DP = INPUT_2[62:0]==0;

wire GT_mag_SP = INPUT_1[30:0] > INPUT_2[30:0];
wire LT_mag_SP = INPUT_1[30:0] < INPUT_2[30:0];
wire GT_mag_DP = INPUT_1[62:0] > INPUT_2[62:0];
wire LT_mag_DP = INPUT_1[62:0] < INPUT_2[62:0];

always @(*) begin
    if(IsDouble==1'b1) begin
        //EQ = (INPUT_1_zero_DP & INPUT_2_zero_DP) || (INPUT_1 == INPUT_2);
        //LT = INPUT_1[63] ^ INPUT_2[63] ? INPUT_1[63] & !(INPUT_1_zero_DP & INPUT_2_zero_DP) : INPUT_1[63] ? GT_mag_DP : LT_mag_DP;
        EQ = (INPUT_1 == INPUT_2);
        LT = (INPUT_1_zero_DP & INPUT_2_zero_DP & (INPUT_1[63] ^ INPUT_2[63])) ? INPUT_1[63] : (INPUT_1[63] ^ INPUT_2[63] ? INPUT_1[63] & !(INPUT_1_zero_DP & INPUT_2_zero_DP) : INPUT_1[63] ? GT_mag_DP : LT_mag_DP);
        LE = EQ | LT;
    end
    else begin
//        EQ = (INPUT_1_zero_SP & INPUT_2_zero_SP) || (INPUT_1 == INPUT_2);
//        LT = INPUT_1[31] ^ INPUT_2[31] ? INPUT_1[31] & !(INPUT_1_zero_SP & INPUT_2_zero_SP) : INPUT_1[31] ? GT_mag_SP : LT_mag_SP;
        EQ = (INPUT_1 == INPUT_2);
        LT = (INPUT_1_zero_SP & INPUT_2_zero_SP & (INPUT_1[31] ^ INPUT_2[31])) ? INPUT_1[31] : INPUT_1[31] ^ INPUT_2[31] ? INPUT_1[31] & !(INPUT_1_zero_SP & INPUT_2_zero_SP) : INPUT_1[31] ? GT_mag_SP : LT_mag_SP;
        LE = EQ | LT;
    end
end


endmodule

