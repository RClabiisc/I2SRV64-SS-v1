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

(* keep_hierarchy = "yes" *)
module FALU_ADD
(
    input  wire [65:0]  INPUT_1,
    input  wire [65:0]  INPUT_2,
    input  wire [2:0]   Rounding_Mode,
    input  wire         IsDouble,
    input  wire         IsSubtract,
    output reg  [65:0]  OUTPUT,
    output reg          INVALID,
    output reg          OVERFLOW,
    output reg          UNDERFLOW,
    output reg          INEXACT
);

wire [65:0] INPUT_1_DP;
wire [65:0] INPUT_2_DP;
wire [65:0] INPUT_2_DP_NEG;
wire [65:0] OUTPUT_DP;
wire [33:0] INPUT_1_SP;
wire [33:0] INPUT_2_SP;
wire [33:0] INPUT_2_SP_NEG;
wire [33:0] OUTPUT_SP;

wire INEXACT_SP;
wire INEXACT_DP;

assign INPUT_1_SP = IsDouble ? 34'b0 : INPUT_1[33:0];
assign INPUT_2_SP = IsDouble ? 34'b0 : INPUT_2[33:0];
assign INPUT_2_SP_NEG = IsDouble ? 34'b0 : {INPUT_2_SP[33:32] , INPUT_2_SP[31]^1'b1 ,  INPUT_2_SP[30:0]};

assign INPUT_1_DP = IsDouble ? INPUT_1 : 66'b0;
assign INPUT_2_DP = IsDouble ? INPUT_2 : 66'b0;
assign INPUT_2_DP_NEG = IsDouble ? {INPUT_2[65:64] , INPUT_2[63]^1'b1 ,  INPUT_2[62:0]} : 66'b0;


/*********************************
*  Flopoco Adder Instantiation  *
*********************************/
(* keep_hierarchy = "yes" *)
FPAdd_8_23_comb_uid2 FPADD_SP
(
    .X       ( INPUT_1_SP                               ),
    .Y       ( IsSubtract ? INPUT_2_SP_NEG : INPUT_2_SP ),
    .RM      ( Rounding_Mode                            ),
    .R       ( OUTPUT_SP                                ),
    .INEXACT ( INEXACT_SP                               )
);

(* keep_hierarchy = "yes" *)
FPAdd_11_52_comb_uid2 FPADD_DP
(
    .X       ( INPUT_1_DP                               ),
    .Y       ( IsSubtract ? INPUT_2_DP_NEG : INPUT_2_DP ),
    .RM      ( Rounding_Mode                            ),
    .R       ( OUTPUT_DP                                ),
    .INEXACT ( INEXACT_DP                               )
);


always @(*) begin
    if (IsDouble) begin
        OUTPUT =  OUTPUT_DP;
    end
    else begin
        //Special case of NaN Boxing of Narrower Values (User Spec 12.2)
        OUTPUT =  {32'hFFFFFFFF, OUTPUT_SP};
    end
end

wire [1:0] EXC_BITS = IsDouble ? OUTPUT_DP[65:64] : OUTPUT_SP[33:32];
wire EXP_ZERO = IsDouble ? !(|OUTPUT_DP[62:52]) : !(|OUTPUT_SP[30:23]);

always @(*) begin

    INEXACT = IsDouble ? INEXACT_DP : INEXACT_SP;

    case(EXC_BITS)
        2'b00 : begin
            OVERFLOW = 1'b0;
            UNDERFLOW = 1'b1;
        end

        2'b01 : begin
            OVERFLOW = 1'b0;
            if(EXP_ZERO == 1'b1)
                UNDERFLOW = 1'b1;
            else
                UNDERFLOW = 1'b0;
        end

        2'b10 : begin
            OVERFLOW = 1'b1;
            UNDERFLOW = 1'b0;
        end

        default: begin
            OVERFLOW = 1'b0;
            UNDERFLOW = 1'b0;
        end
    endcase
end


wire [1:0] IN_1_EXC_BITS = IsDouble ? INPUT_1[65:64] : INPUT_1[33:32];
wire [1:0] IN_2_EXC_BITS = IsDouble ? INPUT_2[65:64] : INPUT_2[33:32];

wire IN_1_SNAN_BIT = IsDouble ? INPUT_1[51] : INPUT_1[22];
wire IN_2_SNAN_BIT = IsDouble ? INPUT_2[51] : INPUT_2[22];

wire IN_1_SIGN = IsDouble ? INPUT_1[63] : INPUT_1[31];
wire IN_2_SIGN = IsDouble ? INPUT_2[63] : INPUT_2[31];

always @(*) begin

    if (((IN_1_EXC_BITS == 2'b11) && (IN_1_SNAN_BIT == 1'b0)) || ((IN_2_EXC_BITS == 2'b11) && (IN_2_SNAN_BIT == 1'b0))) begin
        INVALID = 1'b1;
    end
    else if ((IN_1_EXC_BITS == 2'b10) && (IN_2_EXC_BITS == 2'b10)) begin
        if (IsSubtract == 1'b1) begin
            INVALID = ((IN_1_SIGN == IN_2_SIGN)) ? 1'b1 : 1'b0;
        end
        else begin
            INVALID = ((IN_1_SIGN != IN_2_SIGN)) ? 1'b1 : 1'b0;
        end
    end
    else begin
        INVALID = 1'b0;
    end

end

endmodule
