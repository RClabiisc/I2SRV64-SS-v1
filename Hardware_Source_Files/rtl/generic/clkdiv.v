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
module clkdiv
#(
    parameter DIVIDE_BY = 8
)
(
    input  wire clk_in,
    input  wire rst_in,

    output wire clk_out
);

localparam MAX = (DIVIDE_BY/2)-1;

reg [$clog2(DIVIDE_BY/2)-1:0] cnt;
reg toggle;

wire overflow = (cnt==MAX);

always @(posedge clk_in) begin
    if(rst_in | overflow)
        cnt <= 0;
    else
        cnt <= cnt + 1;
end

always @(posedge clk_in) begin
    if(rst_in)
        toggle <= 1'b0;
    else if(overflow)
        toggle <= ~toggle;
end

assign clk_out = toggle;

endmodule

