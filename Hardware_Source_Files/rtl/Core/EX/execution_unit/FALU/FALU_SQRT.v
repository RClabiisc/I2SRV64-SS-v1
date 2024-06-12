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
module FALU_SQRT
(
    input  wire [65:0]  INPUT,
    input  wire [2:0]   Rounding_Mode,
    input  wire         IsDouble,
    output reg  [65:0]  OUTPUT,
    output reg          INVALID,
    output reg          OVERFLOW,
    output reg          UNDERFLOW,
    output reg          INEXACT
);

wire [65:0] INPUT_DP;
wire [65:0] OUTPUT_DP;
wire [33:0] INPUT_SP;
wire [33:0] OUTPUT_SP;

wire INEXACT_SP;
wire INEXACT_DP;

assign INPUT_SP = IsDouble ? 34'b0 : INPUT[33:0];
assign INPUT_DP = IsDouble ? INPUT : 66'b0;

/********************************
*  Flopoco SQRT Instantiation  *
********************************/
(* keep_hierarchy = "yes" *)
FPSqrt_8_23 FPSQRT_SP
(
    .X       ( INPUT_SP      ),
    .RM      ( Rounding_Mode ),
    .R       ( OUTPUT_SP     ),
    .INEXACT ( INEXACT_SP    )
);

(* keep_hierarchy = "yes" *)
FPSqrt_11_52 FPSQRT_DP
(
    .X       ( INPUT_DP      ),
    .RM      ( Rounding_Mode ),
    .R       ( OUTPUT_DP     ),
    .INEXACT ( INEXACT_DP    )
);


always @(*) begin
    if (IsDouble) begin
        OUTPUT <=  OUTPUT_DP;
    end
    else begin
        //Special case of NaN Boxing of Narrower Values (User Spec 12.2)
        OUTPUT <=  {32'hFFFFFFFF, OUTPUT_SP};
    end
end


wire [1:0] EXC_BITS = IsDouble ? OUTPUT_DP[65:64] : OUTPUT_SP[33:32];
wire EXP_ZERO = IsDouble ? !(|OUTPUT_DP[62:52]) : !(|OUTPUT_SP[30:23]);

always @(*) begin

    INEXACT <= IsDouble ? INEXACT_DP : INEXACT_SP;

    case(EXC_BITS)
        2'b00 : begin
            OVERFLOW <= 1'b0;
            UNDERFLOW <= 1'b1;
        end

        2'b01 : begin
            OVERFLOW <= 1'b0;
            if(EXP_ZERO == 1'b1)
                UNDERFLOW <= 1'b1;
            else
                UNDERFLOW <= 1'b0;
        end

        2'b10 : begin
            OVERFLOW <= 1'b1;
            UNDERFLOW <= 1'b0;
        end

        default: begin
            OVERFLOW <= 1'b0;
            UNDERFLOW <= 1'b0;
        end
    endcase
end

wire [1:0] IN_EXC_BITS = IsDouble ? INPUT[65:64] : INPUT[33:32];
wire IN_SNAN_BIT = IsDouble ? INPUT[51] : INPUT[22];
wire IN_SIGN = IsDouble ? INPUT[63] : INPUT[31];

always @(*) begin

    if ((IN_EXC_BITS == 2'b11) && (IN_SNAN_BIT == 1'b0)) begin
        INVALID <= 1'b1;
    end
    else if (IN_SIGN == 1'b1) begin
        INVALID <= 1'b1;
    end
    else begin
        INVALID <= 1'b0;
    end

end

endmodule

