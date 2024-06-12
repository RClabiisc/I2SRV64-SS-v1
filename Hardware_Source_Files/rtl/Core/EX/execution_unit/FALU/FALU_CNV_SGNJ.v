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
module FSGNJ
(
    input  wire [63:0]  INPUT_1,
    input  wire [63:0]  INPUT_2,
    input  wire         IsDouble,
    input  wire         Is_SI,
    input  wire         Is_SI_NEG,
    input  wire         Is_SI_XOR,
    output reg  [63:0]  OUTPUT
);


//Check for whether INPUT_1 is boxed for Single FP
wire [63:0] INPUT1 = IsDouble ? INPUT_1 : (&INPUT_1[63:32] ? {{32{1'b1}}, INPUT_1[31:0]} : 64'hffffffff7fc00000);
wire [63:0] INPUT2 = IsDouble ? INPUT_2 : (&INPUT_2[63:32] ? {{32{1'b1}}, INPUT_2[31:0]} : 64'hffffffff7fc00000);

reg sign;
always @(*) begin
    if(IsDouble) begin
        if(Is_SI)
            sign = INPUT2[63];
        else if(Is_SI_NEG)
            sign = ~INPUT2[63];
        else if(Is_SI_XOR)
            sign = INPUT1[63] ^ INPUT2[63];
        else
            sign = 1'b0;

        OUTPUT = {sign,INPUT1[62:0]};
    end
    else begin
        if(Is_SI)
            sign = INPUT2[31];
        else if(Is_SI_NEG)
            sign = ~INPUT2[31];
        else if(Is_SI_XOR)
            sign = INPUT1[31] ^ INPUT2[31];
        else
            sign = 1'b0;

        OUTPUT = {{32{1'b1}},sign,INPUT1[30:0]};
    end
end
endmodule

