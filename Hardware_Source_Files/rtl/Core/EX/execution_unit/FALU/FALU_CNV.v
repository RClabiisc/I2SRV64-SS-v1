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
module FALU_CNV
(
    input  wire [63:0]  INPUT_1,
    input  wire [63:0]  INPUT_2,
    input  wire [2:0]   Rounding_Mode,
    input  wire         IsDouble,
    input  wire         IsWord,
    input  wire [2:0]   SubOp,
    output reg  [63:0]  OUTPUT,
    output reg          INVALID,
    output reg          OVERFLOW,
    output reg          UNDERFLOW,
    output reg          INEXACT
);

/***************************************
*  INT to FP Sub-Sub Functional Unit  *
***************************************/
wire        Is_I2FP          = (SubOp==`FPU_SUBOP_CNV_I2FP) || (SubOp==`FPU_SUBOP_CNV_IU2FP);
wire        Is_I2FP_Unsigned = (SubOp==`FPU_SUBOP_CNV_IU2FP);
wire [63:0] INPUT_int_to_FP  =  Is_I2FP ? INPUT_1 : 0;
wire [63:0] OUTPUT_int_to_FP;
wire        INEXACT_int_to_FP;

INT2FP INT2FP
(
    .INPUT         ( INPUT_int_to_FP   ),
    .Rounding_Mode ( Rounding_Mode     ),
    .IsDouble      ( IsDouble          ),
    .IsWord        ( IsWord            ),
    .Is_Unsigned   ( Is_I2FP_Unsigned  ),
    .OUTPUT        ( OUTPUT_int_to_FP  ),
    .INEXACT       ( INEXACT_int_to_FP )
);


/***************************************
*  FP to INT Sub-Sub Functional Unit  *
***************************************/
wire        Is_FP2I          = (SubOp==`FPU_SUBOP_CNV_FP2I) || (SubOp==`FPU_SUBOP_CNV_FP2IU);
wire        Is_FP2I_Unsigned = (SubOp==`FPU_SUBOP_CNV_FP2IU);
wire [63:0] INPUT_FP_to_int  = Is_FP2I ? INPUT_1 : 0;
wire [63:0] OUTPUT_FP_to_int;
wire        INVALID_FP_to_int, OVERFLOW_FP_to_int, UNDERFLOW_FP_to_int;

FP2INT FP2INT
(
    .INPUT           (INPUT_FP_to_int    ),
    .IsDouble        (IsDouble           ),
    .Is_Unsigned     (Is_FP2I_Unsigned   ),
    .IsWord          (IsWord             ),
    .Rounding_Mode   (Rounding_Mode      ),
    .OUTPUT          (OUTPUT_FP_to_int   ),
    .INVALID         (INVALID_FP_to_int  ),
    .OVERFLOW        (OVERFLOW_FP_to_int ),
    .UNDERFLOW       (UNDERFLOW_FP_to_int)
);


/**************************************
*  FP to FP Sub-Sub Functional Unit  *
**************************************/
wire        Is_FP2FP       = (SubOp==`FPU_SUBOP_CNV_FP2FP);
wire [63:0] INPUT_FP_to_FP = Is_FP2FP ? INPUT_1 : 0;
wire [63:0] OUTPUT_FP_to_FP;
wire        OVERFLOW_FP_to_FP, UNDERFLOW_FP_to_FP, INEXACT_FP_to_FP;

FP2FP FP2FP
(
    .INPUT         (INPUT_FP_to_FP    ),
    .Rounding_Mode (Rounding_Mode     ),
    .IsDouble      (IsDouble          ),
    .OUTPUT        (OUTPUT_FP_to_FP   ),
    .OVERFLOW      (OVERFLOW_FP_to_FP ),
    .UNDERFLOW     (UNDERFLOW_FP_to_FP),
    .INEXACT       (INEXACT_FP_to_FP  )
);


/********************************************
*  Sign Injection Sub-Sub Functional Unit  *
********************************************/
wire        Is_SI = (SubOp==`FPU_SUBOP_CNV_SI)||(SubOp==`FPU_SUBOP_CNV_SINEG)||(SubOp==`FPU_SUBOP_CNV_SIXOR);
wire [63:0] INPUT_1_SIGN_INJECTION = Is_SI ? INPUT_1 : 0;
wire [63:0] INPUT_2_SIGN_INJECTION = Is_SI ? INPUT_2 : 0;
wire [63:0] OUTPUT_SIGN_INJECTION;
wire        Is_SI_SI               = (SubOp==`FPU_SUBOP_CNV_SI);
wire        Is_SI_NEG              = (SubOp==`FPU_SUBOP_CNV_SINEG);
wire        Is_SI_XOR              = (SubOp==`FPU_SUBOP_CNV_SIXOR);

FSGNJ FSGNJ
(
    .INPUT_1   ( INPUT_1_SIGN_INJECTION ),
    .INPUT_2   ( INPUT_2_SIGN_INJECTION ),
    .IsDouble  ( IsDouble               ),
    .Is_SI     ( Is_SI_SI               ),
    .Is_SI_NEG ( Is_SI_NEG              ),
    .Is_SI_XOR ( Is_SI_XOR              ),
    .OUTPUT    ( OUTPUT_SIGN_INJECTION  )
);


/*****************************************************************************
*                             Final Result Mux                              *
*****************************************************************************/
//Mux Results of All Sub-Sub Functional Units
always @(*) begin
    case(SubOp)
        `FPU_SUBOP_CNV_I2FP, `FPU_SUBOP_CNV_IU2FP: begin
            OUTPUT    = OUTPUT_int_to_FP;
            INVALID   = 1'b0;
            OVERFLOW  = 1'b0;
            UNDERFLOW = 1'b0;
            INEXACT   = INEXACT_int_to_FP;
        end

        `FPU_SUBOP_CNV_FP2I, `FPU_SUBOP_CNV_FP2IU: begin
            OUTPUT    = OUTPUT_FP_to_int;
            INVALID   = INVALID_FP_to_int;
            OVERFLOW  = OVERFLOW_FP_to_int;
            UNDERFLOW = UNDERFLOW_FP_to_int;
            INEXACT   = 1'b0;
        end

        `FPU_SUBOP_CNV_FP2FP: begin
            OUTPUT    = OUTPUT_FP_to_FP;
            INVALID   = 1'b0;
            OVERFLOW  = OVERFLOW_FP_to_FP;
            UNDERFLOW = UNDERFLOW_FP_to_FP;
            INEXACT   = INEXACT_FP_to_FP;
        end

        `FPU_SUBOP_CNV_SI, `FPU_SUBOP_CNV_SINEG, `FPU_SUBOP_CNV_SIXOR: begin
            OUTPUT    = OUTPUT_SIGN_INJECTION;
            INVALID   = 1'b0;
            OVERFLOW  = 1'b0;
            UNDERFLOW = 1'b0;
            INEXACT   = 1'b0;
        end

        default: begin
            OUTPUT    = 0;
            INVALID   = 1'b0;
            OVERFLOW  = 1'b0;
            UNDERFLOW = 1'b0;
            INEXACT   = 1'b0;
        end
    endcase
end
endmodule

