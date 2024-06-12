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
module PMP
#(
    parameter PMP_ENTRIES = `PMP_ENTRIES        //no. of PMP Entries Implemented
)
(
    //inputs
    input  wire [55:0]          Paddr,          //Phy Addr to be checked
    input  wire [2:0]           Access_Type,    //Access Type (Use Macro `MEM_ACCESS_*)
    input  wire [1:0]           Priv_Level,     //Current Priv Level (Use Macro `PRIV_LVL_*)

    //PMP Config & Addr from CSRs
    input  wire [(8*16)-1:0]    CSR_pmpcfg,     //Consolidated pmpcfg CSRs from CSR Module
    input  wire [(54*16)-1:0]   CSR_pmpaddr,    //Comsolidated pmpaddr CSRs from CSR Module

    //Outputs
    output reg                  AccessAllowed   //1=>Access Allowed
);




//Extracts pmpcfg and pmpaddr into arrays
wire [7:0]      pmpcfg[0:15];
wire [53:0]     pmpaddr[0:15];

genvar gc;
generate
    for(gc=0; gc<16; gc=gc+1) begin
        if(gc<PMP_ENTRIES) begin
            assign pmpcfg[gc]  = CSR_pmpcfg[8*gc+:8];
            assign pmpaddr[gc] = CSR_pmpaddr[54*gc+:54];
        end
        else begin
            assign pmpcfg[gc]  = 0;
            assign pmpaddr[gc] = 0;
        end
    end
endgenerate


//match Paddr with PMP entries
reg  [15:0]             PMP_AddrMatch;
wire [55:0]             PMP_AddrMask[0:15];

//generate Base, Mask & Size for NAPOT type entries
genvar gbv, gbi;
generate
    for(gbv=0; gbv<PMP_ENTRIES; gbv=gbv+1) begin: PMPMask
        PMPMask PMP_Mask (.pmpaddr(pmpaddr[gbv]), .PMPMask(PMP_AddrMask[gbv]));
    end
    for(gbi=PMP_ENTRIES; gbi<16; gbi=gbi+1) begin
        assign PMP_AddrMask[gbi] = 0;
    end
endgenerate

integer m;
always @(*) begin
    for(m=0; m<PMP_ENTRIES; m=m+1) begin
        case(pmpcfg[m][`PMPCFG_ADDRMODE])
            `PMPCFG_ADDRMODE__OFF: begin
                PMP_AddrMatch[m] = 1'b0;
            end
            `PMPCFG_ADDRMODE__TOR: begin
                if(m==0)
                    PMP_AddrMatch[m] = (Paddr <= {pmpaddr[m],2'b00});
                else
                    PMP_AddrMatch[m] = ((Paddr >= {pmpaddr[m-1],2'b00}) && (Paddr <= {pmpaddr[m],2'b00}));
            end
            `PMPCFG_ADDRMODE__NA4: begin
                PMP_AddrMatch[m] = Paddr[55:2]==pmpaddr[m];
            end
            `PMPCFG_ADDRMODE__NAPOT: begin
                PMP_AddrMatch[m] = (Paddr & PMP_AddrMask[m])==({pmpaddr[m],2'b00} & PMP_AddrMask[m]);
            end
        endcase
    end

    for(m=PMP_ENTRIES; m<16; m=m+1)
        PMP_AddrMatch[m] = 1'b0;
end


//check for Access based on permission and Priv Mode
integer i;
reg done;
always @(*) begin
    AccessAllowed = 1'b0;
    done = 1'b0;
    for(i=0; i<PMP_ENTRIES; i=i+1) begin
        //Verify Permission Bits if Priv Level is U or S
        //or Also if lock is set
        if(Priv_Level!=`PRIV_LVL_M || pmpcfg[i][`PMPCFG_LOCK]) begin
            if(PMP_AddrMatch[i] && !done) begin
                AccessAllowed = |(pmpcfg[i][`PMPCFG_ACCESS] & Access_Type);
                done = 1'b1;
            end
        end
    end

    //if no PMP entries are matched and priv level is M => allow all
    if(done==1'b0 && Priv_Level==`PRIV_LVL_M)
        AccessAllowed = 1'b1;

    //If No PMP Entries are implemented => Allow Access to all
    if(PMP_ENTRIES==0)
        AccessAllowed=1'b1;
end

endmodule

///////////////////////////////////////////////////////////////////////////////
//module to get PMP Size by counting trailing ones
module PMPMask
(
    input  wire [53:0] pmpaddr,
    output reg  [55:0] PMPMask
);

`ifdef PMP_MASK_USING_ADDER
    wire [53:0] leadingOnes;
    genvar gi;
    generate
        for(gi=0; gi<54; gi=gi+1) begin
            assign leadingOnes[gi] = &pmpaddr[gi:0];
        end
    endgenerate

    integer fi;
    reg [$clog2(59)-1:0] PMPsize;
    always @* begin
        PMPsize = 4;
        for(fi=0; fi<54; fi=fi+1) begin
            if(leadingOnes[fi]) begin
                PMPsize = fi+5;
            end
        end
        PMPMask = ~( (56'd1<<PMPsize) - 56'd1);
    end
`else
    integer i;
    reg     zero_found;
    reg  [56:0] PMPMask_d;
    always @* begin
        zero_found = 0;
        PMPMask_d = 0;
        for(i=0; i<54; i=i+1) begin
            if(!zero_found) begin
                PMPMask_d[i+3] = !pmpaddr[i];
                zero_found   = !pmpaddr[i];
            end
            else
                PMPMask_d[i+3] = 1'b1;
        end
        PMPMask = PMPMask_d[55:0];
    end
`endif

endmodule

