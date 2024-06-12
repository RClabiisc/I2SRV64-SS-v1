//******************************************************************************
// Copyright (c) 2018 - 2023, Indian Institute of Science, Bangalore.
// All Rights Reserved. See LICENSE for license details.
//------------------------------------------------------------------------------

// Contributors // Manish Kumar(manishkumar5@iisc.ac.in), Shubham Yadav(shubhamyadav@iisc.ac.in)
// Sajin S (sajins@alum.iisc.ac.in, Shubham Sunil Garag (shubhamsunil@alum.iisc.ac.in)
// Anuj Phegade (anujphegade@alum.iisc.ac.in), Deepshikha Gusain (deepshikhag@alum.iisc.ac.in)
// Ronit Patel (ronitpatel@alum.iisc.ac.in), Vishal Kumar (vishalkumar@alum.iisc.ac.in)
// Kuruvilla Varghese (kuru@iisc.ac.in)
//******************************************************************************
`timescale 1ns / 1ps

(* keep_hierarchy = "yes" *)
module spram
#(
    parameter WIDTH = 32,
    parameter DEPTH = 32,
    parameter SYNC_READ = 0
)
(
    input  wire clk,                         //clk (posedge)
    input  wire rst,                         //rst (sync, active high)

    input  wire  [WIDTH-1:0]         din,    //Data Input
    input  wire                      we,     //Write Enable
    input  wire                      en,     //Output Enable
    input  wire  [$clog2(DEPTH)-1:0] addr,   //Address
    output wire [WIDTH-1:0]          dout    //Data Output
);

reg [WIDTH-1:0] mem[0:DEPTH-1];
reg [WIDTH-1:0] mem_read;

integer i;
always @(posedge clk)
begin
    if(rst) begin
        for(i=0; i<DEPTH;i=i+1)
            mem[i]<=0;
    end
    else if(we==1'b1) begin
        mem[addr]<=din;
    end
end

always @(posedge clk)
begin
    if(rst)
        mem_read <= 0;
    else if(en==1'b1)
        mem_read <= mem[addr];
end

generate
    if(SYNC_READ==1)
        assign dout = mem_read;
    else
        assign dout = (en==1'b1) ? mem[addr] : 0;
endgenerate


endmodule

