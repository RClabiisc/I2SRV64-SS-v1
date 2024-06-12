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
module simple_dpram
#(
    parameter WIDTH = 32,
    parameter DEPTH = 32,
    parameter SYNC_READ = 0
)
(
    input  wire clk,                               //clk (posedge)
    input  wire rst,                               //rst (sync, active high)

    input  wire  [WIDTH-1:0]         port0_din,    //Port0 Data Input
    input  wire                      port0_we,     //Port0 Write Enable
    input  wire  [$clog2(DEPTH)-1:0] port0_addr,   //Port0 Address
    input  wire                      port1_en,     //Port1 Output Enable
    input  wire  [$clog2(DEPTH)-1:0] port1_addr,   //Port1 Address
    output wire [WIDTH-1:0]          port1_dout    //Port1 Data Output
);

reg [WIDTH-1:0] mem[0:DEPTH-1];
reg [WIDTH-1:0] port1_mem_read;

integer i;
always @(posedge clk)
begin
    if(rst) begin
        for(i=0; i<DEPTH;i=i+1)
            mem[i]=0;
    end
    else if(port0_we==1'b1) begin
        mem[port0_addr]<=port0_din;
    end
end

always @(posedge clk)
begin
    if(rst)
        port1_mem_read <= 0;
    else if(port1_en==1'b1)
        port1_mem_read <= mem[port1_addr];
end

generate
    if(SYNC_READ==1)
        assign port1_dout = port1_mem_read;
    else
        assign port1_dout = (port1_en==1'b1) ? mem[port1_addr] : 0;
endgenerate


endmodule

