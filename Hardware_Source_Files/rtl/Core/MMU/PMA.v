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
`include "core_defines.vh"

(* keep_hierarchy = "yes" *)
module PMA
#(
    parameter PORTS = 2
)
(
    input  wire [(64*PORTS)-1:0]                Paddr_Bus,          //Consolidated Paddr as Bus

    input  wire                                 PMA_Check_Enable,

    input  wire [(3*PORTS)-1:0]                 AccessType_Bus,     //Consolidated AccessType as Bus (Use Macro `MEM_ACCESS_*)

    //Access Output
    output reg  [PORTS-1:0]                     AccessAllowed_Bus,  //Consolidate result (1=>Access Allowed)

    //Attributes
    output wire [(PORTS*`PMA_ATTR__LEN)-1:0]    PMA_Attributes_Bus  //Consolidate Attributes Output for each Port
);

`ifdef PMA_PK
    `include "PMA_PK_cfg.v"
`else
    `include "PMA_cfg.v"
`endif

`ifndef PMA_ENTRIES
    `define PMA_ENTRIES 0
`endif

//convert input busses to Arrays
wire [63:0]     Paddr[0:PORTS-1];
wire [2:0]      AccessType[0:PORTS-1];
genvar gi;
generate
    for(gi=0; gi<PORTS; gi=gi+1) begin
        assign Paddr[gi]      = Paddr_Bus[gi*64+:64];
        assign AccessType[gi] = AccessType_Bus[gi*3+:3];
    end
endgenerate

//convert arrays to output busses
reg  [`PMA_ATTR__LEN-1:0]   PMA_Attributes[0:PORTS-1];
genvar go;
generate
    for(go=0; go<PORTS; go=go+1) begin
        assign PMA_Attributes_Bus[go*`PMA_ATTR__LEN+:`PMA_ATTR__LEN] = PMA_Attributes[go];
    end
endgenerate


//Find Matching Entries
wire [`PMA_ENTRIES-1:0]     PMA_MatchFound[0:PORTS-1];
genvar gm,gp;
generate
    for(gp=0; gp<PORTS; gp=gp+1) begin
        for(gm=0; gm<`PMA_ENTRIES; gm=gm+1) begin
            assign PMA_MatchFound[gp][gm] = (PMA_Base[gm] & ~PMA_Size[gm])==(Paddr[gp] & ~PMA_Size[gm]);
        end
    end
endgenerate


//Find Attributes of matching entry
integer i,p;
always @(*) begin

    for (p=0; p<PORTS; p=p+1) begin
        //Reserved Space <= No matching PMA
        PMA_Attributes[p] = 0;

        for(i=0; i<`PMA_ENTRIES; i=i+1) begin
            if(PMA_MatchFound[p][i]) begin
                PMA_Attributes[p] = PMA_Attr[i];
            end
        end
        AccessAllowed_Bus[p] = PMA_Check_Enable ? (|(PMA_Attributes[p][`PMA_ATTR_ACCESS] & AccessType[p])) : 1'b1;
    end
end


endmodule

