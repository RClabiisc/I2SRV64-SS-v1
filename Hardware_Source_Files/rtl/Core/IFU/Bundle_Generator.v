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
`include "core_defines.vh"
`include "regbit_defines.vh"
`include "bus_defines.vh"

(* keep_hierarchy = "yes" *)
module Bundle_Generator
(
    input wire clk,
    input wire rst,

    input wire Stall,                                                   //Stalls update of sync o/p registers
    input wire Flush,                                                   //Invalidates (flushes) o/p registers
    input wire Bubble,                                                  //Invalidates o/p but retains WCBR state

    input wire  [`XLEN-1:0]                        FetchPC,             //FetchPC used for input Cache Line
    input wire  [`ICACHE_LINE_LEN-1:0]             Icache_LineIn,       //Whole Cache Line input
    input wire                                     Icache_Exception,    //ICache Exception
    input wire  [`ECAUSE_LEN-1:0]                  Icache_Ecause,       //Exception Cause

    output reg  [(`FETCH_RATE_HW*`BUNDLE_LEN)-1:0] InstrBundles,        //Sync. Instruction Bundles (IF2)
    output wire [(`FETCH_RATE_HW*`BUNDLE_LEN)-1:0] InstrBundles_async,  //async. Instruction Bundles (IF1)
    output reg  [`XLEN-1:0]                        NextFetchAddr,       //Next Fetch Address for Redirecting FetchPC
    output reg                                     Fetch_Exception,     //Sync. Fetch Exception
    output reg  [`ECAUSE_LEN-1:0]                  Fetch_Ecause         //Sync. Fetch Exception Cause
);

//local wires
wire [15:0]                 unaligned_instr_hw[0:`ICACHE_LINE_SIZEHW -1];   //halfword wire array for cache line (unaligned)
reg  [15:0]                 instr_hw[0:`FETCH_RATE_HW-1];   //halfword wire array after alignment based on FetchPC[4:1]
wire [`FETCH_RATE_HW-1:0]   hw_is32;                        //1=>halfword is 32 bit => next halfword (aka bundle) will be invalid
reg  [`FETCH_RATE_HW-1:0]   hw_isValid;                     //used to indicate Valid (precisely NOT empty due to allignment) halfwords
reg  [`BUNDLE_LEN-1:0]      bundle[0:`FETCH_RATE_HW-1];     //packed bundle for each instr
wire [(`FETCH_RATE_HW*`BUNDLE_LEN)-1:0]  InstrBundles_d;    //async output before registering at output InstrBundles

//separate consolidated cache line i9nto halfword wires
genvar gh;
generate
    for(gh=0; gh<`ICACHE_LINE_SIZEHW; gh=gh+1) begin
        assign unaligned_instr_hw[gh] = Icache_LineIn[((gh+1)*16)-1 : (gh)*16];
    end
endgenerate


//Word across Cache Boundary Recovery
//When 32-bit instruction word's lower HW falls at cache line end. It
//need to be stored and need to be appended with next fetch groups
//halfword[0].
//WCBR Logic wires & registers
reg  [15:0] WCBR_data, WCBR_data_d;
reg         WCBR;
reg         WCBR_enable;
reg         WCBR_Exception;
reg [`ECAUSE_LEN-1:0]   WCBR_ECause;


//align halfword cache wires w.r.t FetchPC[4:1] such that only FETCH_RATE wide
//halfwords are selected
integer i, i_hw_offset;
always @*
begin
    for(i=0;i<`FETCH_RATE_HW;i=i+1) begin
        //check if fetch group of FETCH_RATE wide bytes exceeds cache line boundary
        i_hw_offset = FetchPC[`ICACHE_LINE_SIZE_LEN-1:1] + i;

        instr_hw[i] = 0;
        hw_isValid[i] = 1'b0;

        if(i_hw_offset < `ICACHE_LINE_SIZEHW) begin //does not exceed
            instr_hw[i] = unaligned_instr_hw[i_hw_offset];
            hw_isValid[i] = 1'b1;
        end
         //exceeds => pad with zero & mark as invalid
     end

     //Word across Cache Boundary Recovery Logic
     //If only first HW in Fetch Group is valid => WCB condition true
     //Hence enable WCB Recovery (WCBR)
     if(hw_isValid[0]==1'b1 && ((|hw_isValid[`FETCH_RATE_HW-1:1])==1'b0) && hw_is32[0]==1'b1) begin
         WCBR_enable = 1'b1;
         WCBR_data_d = instr_hw[0];
         hw_isValid[0] = 1'b0;
     end
     else begin
         WCBR_enable = 1'b0;
         WCBR_data_d = 0;
     end
end


//check whether 16-bit instr or not
genvar gc;
generate
    for(gc=0; gc<`FETCH_RATE_HW; gc=gc+1) begin
       assign hw_is32[gc] = (instr_hw[gc][1:0]==2'b11) ? 1 : 0;
   end
endgenerate


//decompression logic
reg [`FETCH_RATE_HW_LEN-1:0] j;
integer x,y;
reg [`FETCH_RATE_HW-1:0] bundle_valid;
reg [`FETCH_RATE_HW-1:0] bundle_is16bit;
always @*
begin
    //assume all are valid
    for (x=0; x<`FETCH_RATE_HW; x=x+1) begin
        bundle[x][`BUNDLE_VALID]    = 1'b1;
        bundle[x][`BUNDLE_FETCHPC]  = FetchPC;
        bundle[x][`BUNDLE_PC]       = FetchPC + 2*x;
    end

    //logic for first half word
    if(~WCBR) begin
        bundle[0][`BUNDLE_BINDEX]  = 0;
        bundle[0][`BUNDLE_VALID]   = hw_isValid[0];
        if(hw_is32[0]) begin
            bundle[1][`BUNDLE_VALID]   = 1'b0;
            bundle[0][`BUNDLE_IS16BIT] = 0;
            bundle[0][`BUNDLE_INSTR]   = {instr_hw[1],instr_hw[0]};
        end
        else begin
            bundle[0][`BUNDLE_INSTR]   = {16'h0000,instr_hw[0]};
            bundle[0][`BUNDLE_IS16BIT] = 1'b1;
        end
    end
    else begin
        bundle[0][`BUNDLE_PC]      = FetchPC-2;
        bundle[0][`BUNDLE_BINDEX]  = 0;
        bundle[0][`BUNDLE_VALID]   = 1'b1;
        bundle[0][`BUNDLE_IS16BIT] = 0;
        bundle[0][`BUNDLE_INSTR]   = {instr_hw[0],WCBR_data};
    end

    //logic for intermediate half words
    for(j=1; j<`FETCH_RATE_HW-1;j=j+1) begin
        bundle[j][`BUNDLE_BINDEX]  = j;
        if((bundle[j][`BUNDLE_VALID]==1) && hw_isValid[j]) begin  //Bundle valid => bundle is valid otherwise might be overridden by preceding 32 bit instr
            if(hw_is32[j]) begin
                if(hw_isValid[j+1]) //Next half-word should also be available
                    bundle[j][`BUNDLE_VALID]   = 1'b1;
                else
                    bundle[j][`BUNDLE_VALID]   = 1'b0;
                bundle[j+1][`BUNDLE_VALID] = 1'b0;
                bundle[j][`BUNDLE_IS16BIT] = 0;
                bundle[j][`BUNDLE_INSTR]   = {instr_hw[j+1],instr_hw[j]};
            end
            else begin
                bundle[j][`BUNDLE_VALID]   = 1'b1;
                bundle[j][`BUNDLE_INSTR]   = {16'h0000,instr_hw[j]};
                bundle[j][`BUNDLE_IS16BIT] = 1'b1;
            end
        end
        else begin
            bundle[j][`BUNDLE_VALID]   = 1'b0;
            bundle[j][`BUNDLE_INSTR]   = 0;
            bundle[j][`BUNDLE_IS16BIT] = 1'b0;
        end
    end

    //logic for last half word
    if((bundle[`FETCH_RATE_HW-1][`BUNDLE_VALID]==1) && hw_isValid[`FETCH_RATE_HW-1]) begin
        bundle[`FETCH_RATE_HW-1][`BUNDLE_BINDEX]  = (`FETCH_RATE_HW-1);
        bundle[`FETCH_RATE_HW-1][`BUNDLE_INSTR]   = {16'h0000,instr_hw[`FETCH_RATE_HW-1]};
        if(hw_is32[`FETCH_RATE_HW-1]) begin
            bundle[`FETCH_RATE_HW-1][`BUNDLE_VALID] = 0;
            bundle[`FETCH_RATE_HW-1][`BUNDLE_IS16BIT] = 1'b0;
        end
        else begin
            bundle[`FETCH_RATE_HW-1][`BUNDLE_VALID]   = 1'b1;
            bundle[`FETCH_RATE_HW-1][`BUNDLE_IS16BIT] = 1'b1;
        end
    end
    else
        bundle[`FETCH_RATE_HW-1][`BUNDLE_LEN-1:0] = 0;

    for(y=0; y<`FETCH_RATE_HW; y=y+1) begin
        bundle_valid[y]   = bundle[y][`BUNDLE_VALID];
        bundle_is16bit[y] = bundle[y][`BUNDLE_IS16BIT];
    end
end


//logic for NextFetchAddr generation
wire [`FETCH_RATE_HW_LEN:0] last_valid_hw_temp = (`ICACHE_LINE_SIZEHW-1) - FetchPC[`ICACHE_LINE_SIZE_LEN-1:1];
wire [`FETCH_RATE_HW_LEN-1:0] last_valid_hw    = (last_valid_hw_temp>=`FETCH_RATE_HW) ? `FETCH_RATE_HW-1 : last_valid_hw_temp[`FETCH_RATE_HW_LEN-1:0];
wire [`FETCH_RATE_HW_LEN-1:0] last2nd_valid_hw = last_valid_hw - 1;

always @* begin
    //A Half Word can be
    //  1. A compressed Instruction (hw_is32=0)
    //  2. Lower HW of 32 bit instr (hw_is32=1)
    //  3. Upper HW of 32 bit instr (hw_is32=?)
    //      In this case hw_is32 can be any value, since bit 1:0 can be 2'b11
    //      for some upper HW also.

    if(last_valid_hw==0) begin
        //If 0th HW is last valid HW then,
        //  1. If it is 16-bit instr => NFA = Last_Valid_HW + 2;
        //  2. If it is Lower HW of 32-bit inst => NFA = Last_Valid_HW + 2;
        //      (In this case, no bundle output will be valid and WCBR will start)
        //  3. It can not be (must not be) Upper HW of instr. How can FetchPC
        //      jump to invalid PC value i.e. Upper HW of instr.
        //
        //        Case 2                         Case 1
        //  0   |______*|<-32 (LHW)         0  |_______|<-16
        //  1   |_______|                   1  |_______|
        //    NFA=Last_Valid_HW+2           NFA = Last_Valid_HW+2
        //
        NextFetchAddr = FetchPC + {last_valid_hw,1'b0} + 2;
    end
    else if(bundle[last_valid_hw][`BUNDLE_VALID]==1'b1 && bundle[last_valid_hw][`BUNDLE_IS16BIT]==1'b1) begin
        //If Last Valid HW is 16-bit instr, then NFA is Last_Valid_HW+2
        NextFetchAddr = FetchPC + {last_valid_hw,1'b0} + 2;
    end
    else if(bundle[last_valid_hw][`BUNDLE_VALID]==1'b0 && bundle[last2nd_valid_hw][`BUNDLE_VALID]==1'b1
            && bundle[last2nd_valid_hw][`BUNDLE_IS16BIT]==1'b0) begin
        //If 2nd last valid HW is Lower HW of 32-bit instr,
        //then NFA = Last_Valid_HW+2;
        //
        // 3rd Last Valid HW      |_______|
        // 2nd Last Valid HW      |      *|<- 32 LHW
        // Last Valid HW          |_______|<- 32 UHW
        //                      NFA = Last_Valid_HW+2


        NextFetchAddr = FetchPC + {last_valid_hw,1'b0} + 2;
    end
    else if(bundle[last_valid_hw][`BUNDLE_VALID]==1'b0 && hw_is32[last_valid_hw]==1'b1) begin
        //If Last Valid HW is Lower HW of 32-bit instr, then instr can not be
        //constructed, so set NFA = Last Valid HW so that WCBR can start in
        //next cycle
        //
        // 3rd Last Valid HW  |_______|                   |      *|<- 32 LHW
        // 2nd Last Valid HW  |_______|<- 16              |_______|
        // Last Valid HW      |      *|<- 32 Lower HW     |      *|<- 32 LHw
        //                  NFA = Last_Valid_HW          NFA = Last_Valid_HW
        //
        //Cache Line End is in middle of fetch group halfwords. So check for
        //last halfword, that whether we could sucessfully extract bundle out
        //of it. If yes then next fetch address is next cache line, else next
        //fetch address is that hw address. So that WCBR can start in next
        //cycle
        NextFetchAddr = FetchPC + {last_valid_hw,1'b0};
    end
    else begin
        NextFetchAddr = FetchPC + `FETCH_RATE;
    end
end


//pack individual bundle array to single wire InstrBundles
genvar gb;
generate
    for(gb=0; gb<`FETCH_RATE_HW; gb=gb+1) begin
        assign InstrBundles_d[((gb+1)*`BUNDLE_LEN)-1 : gb*`BUNDLE_LEN] = bundle[gb];
    end
endgenerate


//async output of Instruction Bundles
assign InstrBundles_async = InstrBundles_d;


//register Instruction Bundles for next stage
always @(posedge clk) begin
    if(rst | Flush | Bubble) begin
        InstrBundles    <= 0;
        Fetch_Exception <= 0;
        Fetch_Ecause    <= 0;
    end
    else if(~Stall) begin
        InstrBundles    <= InstrBundles_d;
        if(WCBR) begin
            if(WCBR_Exception) begin
                //check if there was exception in lower halfword fetch
                Fetch_Exception <= 1'b1;
                Fetch_Ecause    <= WCBR_ECause;
            end
            else if(Icache_Exception) begin
                //check if there is exception in upper halfword fetch
                //The instead of sending actual ECause, send Special cases of
                //ECause so that Retire Unit can identify this difference
                //& generate mtval accordingly
                Fetch_Exception <= 1'b1;
                case(Icache_Ecause)
                    `EXC_IACCESS_FAULT: Fetch_Ecause <= `EXC_IACCESS_FAULT_SPL;
                    `EXC_IPAGE_FAULT  : Fetch_Ecause <= `EXC_IPAGE_FAULT_SPL;
                    default           : Fetch_Ecause <= Icache_Ecause;
                endcase
            end
            else begin
                //No Exception
                Fetch_Exception <= 1'b0;
                Fetch_Ecause    <= 0;
            end
        end
        else begin
            Fetch_Exception <= Icache_Exception;
            Fetch_Ecause    <= Icache_Ecause;
        end
    end
end


//WCBR Register Logic
always @(posedge clk) begin
    if(rst | Flush) begin
        WCBR           <= 0;
        WCBR_data      <= 0;
        WCBR_Exception <= 0;
        WCBR_ECause    <= 0;
    end
    else if(Stall | Bubble) begin
        WCBR           <= WCBR;
        WCBR_data      <= WCBR_data;
        WCBR_Exception <= WCBR_Exception;
        WCBR_ECause    <= WCBR_ECause;
    end
    else if(WCBR_enable) begin
        WCBR           <= 1'b1;
        WCBR_data      <= WCBR_data_d;
        WCBR_Exception <= Icache_Exception;
        WCBR_ECause    <= Icache_Ecause;
    end
    else if(WCBR) begin
        WCBR           <= 0;
        WCBR_data      <= 0;
        WCBR_Exception <= 0;
        WCBR_ECause    <= 0;
    end
end


`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;

    `ifdef DEBUG_IFU_BG
        always @(negedge clk) begin
            if(Stall | Flush | Bubble) begin
                `ifdef DEBUG_IFU_BG_STS
                    $display("[%t] IFUBG_@STS##: Stall=%b Flush=%b Bubble=%b", $time,
                        Stall, Flush, Bubble);
                `endif
            end
            else begin
                `ifdef DEBUG_IFU_BG_STS
                    $display("[%t] IFUBG_@STS##: FPC=%h NFA=%h HV=%b LVHW=%d", $time,
                        FetchPC, NextFetchAddr, hw_isValid, last_valid_hw);
                `endif

                `ifdef DEBUG_IFU_BG_ENTRY
                    for(Di=0; Di<`FETCH_RATE_HW; Di=Di+1) begin
                        if(bundle[Di][`BUNDLE_VALID]) begin
                            $display("[%t] IFUBG_@ENT%-2d: PC=%h Instr=%h | IsC=%b E=%b", $time, bundle[Di][`BUNDLE_BINDEX],
                                bundle[Di][`BUNDLE_PC], bundle[Di][`BUNDLE_INSTR],
                                bundle[Di][`BUNDLE_IS16BIT], Icache_Exception
                            );
                        end
                    end
                `endif
            end
        end
    `endif
`endif

endmodule

