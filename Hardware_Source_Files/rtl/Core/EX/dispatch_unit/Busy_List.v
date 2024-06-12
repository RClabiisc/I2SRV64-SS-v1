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
`include "regbit_defines.vh"
`include "bus_defines.vh"

(* keep_hierarchy = "yes" *)
module Busy_List
(
    input  wire clk,
    input  wire rst,

    input  wire Stall,                  //Stall Busy Writing Operation
    input  wire Flush,                  //Exception Flush
    input  wire Branch_Mispredicted,    //1=>Branch Mispredicted

    //Recovery Inputs for restoring correct status (busy or ready) of PRF
    input  wire [`INT_PRF_DEPTH-1:0]                    Int_RecoveryPhyMapBits, //i=1 => ith Int phy reg was mapped in snapshot which is being recoverd
    input  wire [`FP_PRF_DEPTH-1:0]                     Fp_RecoveryPhyMapBits,  //i=1 => ith Fp phy reg was mapped in snapshot which is being recoverd

    //Write/Set Busy Inputs
    input  wire [(`DISPATCH_RATE*`PRF_MAX_LEN)-1:0]     SetBusy_Prd,        //Set Busy Phy Reg (prd)
    input  wire [`DISPATCH_RATE-1:0]                    SetBusy_RdType,     //Set Busy Phy Reg (prd) Type
    input  wire [`DISPATCH_RATE-1:0]                    SetBusy_WE,         //Set Busy Enable

    //wakeup inputs from different execution units
    input  wire [(`SCHED_PORTS*`WAKEUP_RESP_LEN)-1:0]   WakeupResponses,    //Wakeup Response Bus

    //Read Busy status Ports
    //{rs3,rs2,rs1}
    input  wire [(3*`DISPATCH_RATE*`PRF_MAX_LEN)-1:0]   GetBusy_Phy_Reg,    //3*`DISPATCH_RATE Ports for reading busy bit of Phy Reg
    input  wire [(2*`DISPATCH_RATE)-1:0]                GetBusy_Reg_Type,   //Type of Physical Reg (Int/Fp)
    output wire [(3*`DISPATCH_RATE)-1:0]                GetBusy_BusyBit     //Output Busy Bit corresponding to input phy_reg
);

//generate wires from input & output
wire [`PRF_MAX_LEN-1:0] WriteBusy_prd   [0:`DISPATCH_RATE-1];
wire                    WriteBusy_rdType[0:`DISPATCH_RATE-1];
wire                    WriteBusy_WE    [0:`DISPATCH_RATE-1];
wire [`PRF_MAX_LEN-1:0] ReadBusy_prs1   [0:`DISPATCH_RATE-1];
wire [`PRF_MAX_LEN-1:0] ReadBusy_prs2   [0:`DISPATCH_RATE-1];
wire [`PRF_MAX_LEN-1:0] ReadBusy_prs3   [0:`DISPATCH_RATE-1];
wire [1:0]              ReadBusy_rsType [0:`DISPATCH_RATE-1];
reg  [2:0]              ReadBusy_BusyBit[0:`DISPATCH_RATE-1];
genvar gd;
generate
    for(gd=0; gd<`DISPATCH_RATE; gd=gd+1) begin
        assign WriteBusy_prd[gd]        = SetBusy_Prd[gd*`PRF_MAX_LEN+:`PRF_MAX_LEN];
        assign WriteBusy_rdType[gd]     = SetBusy_RdType[gd];
        assign WriteBusy_WE[gd]         = SetBusy_WE[gd];
        assign ReadBusy_prs1[gd]        = GetBusy_Phy_Reg[(3*gd)*`PRF_MAX_LEN+:`PRF_MAX_LEN];
        assign ReadBusy_prs2[gd]        = GetBusy_Phy_Reg[(3*gd+1)*`PRF_MAX_LEN+:`PRF_MAX_LEN];
        assign ReadBusy_prs3[gd]        = GetBusy_Phy_Reg[(3*gd+2)*`PRF_MAX_LEN+:`PRF_MAX_LEN];
        assign ReadBusy_rsType[gd]      = GetBusy_Reg_Type[gd*2+:2];
        assign GetBusy_BusyBit[gd*3+:3] = ReadBusy_BusyBit[gd];
    end
endgenerate

//extract individual wires from wakeup responses
wire [`WAKEUP_RESP_LEN-1:0] WakeupResp[0:`SCHED_PORTS-1];
wire                    Wakeup_Valid  [0:`SCHED_PORTS-1];
wire [`PRF_MAX_LEN-1:0] Wakeup_prd    [0:`SCHED_PORTS-1];
wire                    Wakeup_prdType[0:`SCHED_PORTS-1];
wire                    Wakeup_WE     [0:`SCHED_PORTS-1];
genvar gw;
generate
    for(gw=0; gw<`SCHED_PORTS; gw=gw+1) begin
        assign WakeupResp[gw]     = WakeupResponses[gw*`WAKEUP_RESP_LEN+:`WAKEUP_RESP_LEN];
        assign Wakeup_Valid[gw]   = WakeupResp[gw][`WAKEUP_RESP_VALID];
        assign Wakeup_prd[gw]     = WakeupResp[gw][`WAKEUP_RESP_PRD];
        assign Wakeup_prdType[gw] = WakeupResp[gw][`WAKEUP_RESP_PRD_TYPE];
        assign Wakeup_WE[gw]      = WakeupResp[gw][`WAKEUP_RESP_REG_WE];
    end
endgenerate


//Busy Bit Registers (1=>Busy, 0=>Valid)
reg [`INT_PRF_DEPTH-1:0] IntBusyList;
reg [`FP_PRF_DEPTH-1:0]  FpBusyList;


//Write Busy Process
integer ii,ff,wd,ww;
always @(posedge clk) begin
    if(rst | Flush) begin   //If Exception Flush, Mark all as not busy
        for(ii=0;ii<`INT_PRF_DEPTH;ii=ii+1)
            IntBusyList[ii] <= 0;
        for(ff=0; ff<`FP_PRF_DEPTH;ff=ff+1)
            FpBusyList[ff] <= 0;
    end
    else if(Branch_Mispredicted) begin
        //If Phy reg is Busy
        //  If Phy Reg is not mapped in snapshot being restored => mark as not busy
        //else in all other cases do not modify the value
        for(ii=0;ii<`INT_PRF_DEPTH;ii=ii+1) begin
            if(IntBusyList[ii]==1'b1 && Int_RecoveryPhyMapBits[ii]==1'b0)
                IntBusyList[ii] <= 1'b0;
        end
        for(ff=0; ff<`FP_PRF_DEPTH;ff=ff+1) begin
            if(FpBusyList[ff]==1'b1 && Fp_RecoveryPhyMapBits[ff]==1'b0)
                FpBusyList[ff]  <= 1'b0;
        end

        //mark phy_reg as NOT busy if wakeup port data matches
        for(ww=0;ww<`SCHED_PORTS;ww=ww+1) begin
            if(Wakeup_Valid[ww] & Wakeup_WE[ww]) begin
                if(Wakeup_prdType[ww]==`REG_TYPE_FP)
                    FpBusyList[Wakeup_prd[ww][`FP_PRF_LEN-1:0]]   <= 1'b0;
                else
                    IntBusyList[Wakeup_prd[ww][`INT_PRF_LEN-1:0]] <= 1'b0;
            end
        end
    end
    else if(~Stall) begin //TODO: check writing priority
        //mark phy_reg as busy if written by Write Port
        for(wd=0;wd<`DISPATCH_RATE;wd=wd+1) begin
            if(WriteBusy_WE[wd]==1'b1) begin
                if(WriteBusy_rdType[wd]==`REG_TYPE_FP)
                    FpBusyList[WriteBusy_prd[wd][`FP_PRF_LEN-1:0]]   <= 1'b1;
                else
                    IntBusyList[WriteBusy_prd[wd][`INT_PRF_LEN-1:0]] <= 1'b1;
            end
        end

        //mark phy_reg as NOT busy if wakeup port data matches
        for(ww=0;ww<`SCHED_PORTS;ww=ww+1) begin
            if(Wakeup_Valid[ww] & Wakeup_WE[ww]) begin
                if(Wakeup_prdType[ww]==`REG_TYPE_FP)
                    FpBusyList[Wakeup_prd[ww][`FP_PRF_LEN-1:0]]   <= 1'b0;
                else
                    IntBusyList[Wakeup_prd[ww][`INT_PRF_LEN-1:0]] <= 1'b0;
            end
        end
    end
end


//Busy Bit Read Process
//(Incorportates Write Through with descending Priority)
//i.e. If dispatch_port0 is setting a register busy then that will be visible
//to reading port1
integer i,j,k;
always @* begin
    for(i=0; i<`DISPATCH_RATE; i=i+1) begin
        //reading rs1
        if(ReadBusy_rsType[i][0]==`REG_TYPE_FP)
            ReadBusy_BusyBit[i][0] = FpBusyList[ReadBusy_prs1[i][`FP_PRF_LEN-1:0]];
        else
            ReadBusy_BusyBit[i][0] = IntBusyList[ReadBusy_prs1[i][`INT_PRF_LEN-1:0]];

        //reading rs2
        if(ReadBusy_rsType[i][1]==`REG_TYPE_FP)
            ReadBusy_BusyBit[i][1] = FpBusyList[ReadBusy_prs2[i][`FP_PRF_LEN-1:0]];
        else
            ReadBusy_BusyBit[i][1] = IntBusyList[ReadBusy_prs2[i][`INT_PRF_LEN-1:0]];

        //reading rs3
        ReadBusy_BusyBit[i][2] = FpBusyList[ReadBusy_prs3[i][`FP_PRF_LEN-1:0]];

        //Write Through Logic
        for(j=0; j<i; j=j+1) begin
            //for rs1
            if((WriteBusy_WE[j]==1'b1) && (WriteBusy_rdType[j]==ReadBusy_rsType[i][0]) && (WriteBusy_prd[j]==ReadBusy_prs1[i]))
                ReadBusy_BusyBit[i][0] = 1'b1;
            //for rs2
            if((WriteBusy_WE[j]==1'b1) && (WriteBusy_rdType[j]==ReadBusy_rsType[i][1]) && (WriteBusy_prd[j]==ReadBusy_prs2[i]))
                ReadBusy_BusyBit[i][1] = 1'b1;
            //for rs3
            if((WriteBusy_WE[j]==1'b1) && (WriteBusy_rdType[j]==`REG_TYPE_FP) && (WriteBusy_prd[j]==ReadBusy_prs3[i]))
                ReadBusy_BusyBit[i][2] = 1'b1;
        end

        //Write Through Logic from wakeup Port
        //mark phy_reg as NOT busy if wakeup port data matches
        for(k=0;k<`SCHED_PORTS;k=k+1) begin
            //for rs1
            if(Wakeup_Valid[k] && Wakeup_WE[k] && (Wakeup_prd[k]==ReadBusy_prs1[i]) && (Wakeup_prdType[k]==ReadBusy_rsType[i][0]))
                ReadBusy_BusyBit[i][0] = 1'b0;
            //for rs2
            if(Wakeup_Valid[k] && Wakeup_WE[k] && (Wakeup_prd[k]==ReadBusy_prs2[i]) && (Wakeup_prdType[k]==ReadBusy_rsType[i][1]))
                ReadBusy_BusyBit[i][1] = 1'b0;
            //for rs3
            if(Wakeup_Valid[k] && Wakeup_WE[k] && (Wakeup_prd[k]==ReadBusy_prs1[i]) && (Wakeup_prdType[k]==`REG_TYPE_FP))
                ReadBusy_BusyBit[i][2] = 1'b0;
        end

    end
end


endmodule

