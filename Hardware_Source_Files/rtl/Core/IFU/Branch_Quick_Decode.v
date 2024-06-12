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
module Branch_Quick_Decoder
(
    input  wire clk,
    input  wire rst,

    input  wire Stall,          //1=>Stalls o/p register update
    input  wire Bubble,         //1=>Invalidates o/p register outputs

    input  wire [(`BUNDLE_LEN*`FETCH_RATE_HW)-1:0]          InstrBundlesIn,  //Bundles From Bungle Generator async output (i.e. IF1 output)

    output reg  [(`BRANCH_TYPE__LEN*`FETCH_RATE_HW)-1:0]    BranchType_Bus      //Decoded Branch Types
);

//extract individual bundles from bus
wire [`BUNDLE_LEN-1:0] bundle[0:`FETCH_RATE_HW-1];
wire [31:0] instr[0:`FETCH_RATE_HW-1];
wire [(`BRANCH_TYPE__LEN*`FETCH_RATE_HW)-1:0] BranchType_Bus_d;

genvar gi;
generate
    for(gi=0;gi<`FETCH_RATE_HW;gi=gi+1) begin
        assign bundle[gi] = InstrBundlesIn[((gi+1)*`BUNDLE_LEN)-1:(gi)*`BUNDLE_LEN];
        assign instr[gi]  = bundle[gi][`BUNDLE_INSTR];
    end
endgenerate


//local wire
reg [`BRANCH_TYPE__LEN-1:0] BranchType[0:`FETCH_RATE_HW-1];


//branch type decode
integer i;
always @*
begin
    for(i=0; i<`FETCH_RATE_HW;i=i+1) begin
        BranchType[i] = 0;

        if(bundle[i][`BUNDLE_VALID]) begin
            if(bundle[i][`BUNDLE_IS16BIT]) begin //16 bit instr
                if(instr[i][`ISAC_OP_RANGE]==`ISAC_Q1_OP) begin  //Q1
                    if((instr[i][`ISAC_FN3_RANGE]==`ISAC_FN3_BEQZ) || (instr[i][`ISAC_FN3_RANGE]==`ISAC_FN3_BNEZ))    //C.BEQZ or C.BNEZ
                        BranchType[i] = `BRANCH_TYPE_COND;
                    else if(instr[i][`ISAC_FN3_RANGE]==`ISAC_FN3_J)   //C.J
                        BranchType[i] = `BRANCH_TYPE_JMP;
                    else
                        BranchType[i] = `BRANCH_TYPE_NONE;
                end
                else if(instr[i][`ISAC_OP_RANGE]==`ISAC_Q2_OP) begin
                    if( (instr[i][15:12]==4'b1000) && (instr[i][6:2]==0) && (instr[i][`ISAC_RS1_RANGE]!=0) )      //C.JR
                        if( (instr[i][11:7]==`ISA_RA) )      //C.JR as RET
                            BranchType[i] = `BRANCH_TYPE_RET;
                        else
                            BranchType[i] = `BRANCH_TYPE_IJMP;
                    else if( (instr[i][`ISAC_FN3_RANGE]==`ISAC_FN3_100) && (instr[i][12]==1'b1) &&
                        (instr[i][6:2]==0) && (instr[i][`ISAC_RS1_RANGE]==`ISA_RA) )
                        //C.JALR as COROU
                        BranchType[i] = `BRANCH_TYPE_COROU;
                    else if( (instr[i][`ISAC_FN3_RANGE]==`ISAC_FN3_100) && (instr[i][12]==1'b1) &&
                        (instr[i][6:2]==0) && (instr[i][`ISAC_RS1_RANGE]!=0) ) //C.JALR as CALL
                        BranchType[i] = `BRANCH_TYPE_ICALL;
                    else
                        BranchType[i] = `BRANCH_TYPE_NONE;
                end
            end
            else begin  //32 bit instr
                case (instr[i][`ISA_OP_RANGE])    //opcode check
                    `ISA_OP_BRANCH: BranchType[i] = `BRANCH_TYPE_COND;

                    `ISA_OP_JAL: begin
                        if((instr[i][`ISA_RD_RANGE]==`ISA_RA) || (instr[i][`ISA_RD_RANGE]==`ISA_T0))    //rd = x1 or x5
                            BranchType[i] = `BRANCH_TYPE_CALL;
                        else
                            BranchType[i] = `BRANCH_TYPE_JMP;
                    end

                    `ISA_OP_JALR: begin
                        if ( ((instr[i][`ISA_RS1_RANGE]==`ISA_RA) || (instr[i][`ISA_RS1_RANGE]==`ISA_T0)) &&
                             ((instr[i][`ISA_RD_RANGE ]==`ISA_RA) || (instr[i][`ISA_RD_RANGE ]==`ISA_T0))) begin    //rs1=link rd=link

                             if (instr[i][`ISA_RS1_RANGE]==instr[i][`ISA_RD_RANGE])                           //rs1=link, rd=link, rs1=rs2
                                 BranchType[i] = `BRANCH_TYPE_ICALL;
                             else                                                                             //rs1=link, rd=link, rs1!=rs2
                                 BranchType[i] = `BRANCH_TYPE_COROU;
                        end
                        else if((instr[i][`ISA_RS1_RANGE]==`ISA_RA) || (instr[i][`ISA_RS1_RANGE]==`ISA_T0))         //rs1=link, rd!=link
                            BranchType[i] = `BRANCH_TYPE_RET;
                        else if((instr[i][`ISA_RD_RANGE ]==`ISA_RA) || (instr[i][`ISA_RD_RANGE ]==`ISA_T0))         //rs1!=link, rd=link
                            BranchType[i] = `BRANCH_TYPE_ICALL;
                        else                                                                                  //rs1!=link, rd!=link
                            BranchType[i] = `BRANCH_TYPE_IJMP;
                    end

                    default :
                        BranchType[i] = `BRANCH_TYPE_NONE;
                endcase
            end

        end
        else begin
            BranchType[i] = `BRANCH_TYPE_NONE;
        end
    end //for
end //always


//merge individual branchTypes to BranchType_Bus_d
genvar gj;
generate
    for(gj=0;gj<`FETCH_RATE_HW;gj=gj+1) begin
        assign BranchType_Bus_d[(gj*`BRANCH_TYPE__LEN)+:`BRANCH_TYPE__LEN] = BranchType[gj];
    end
endgenerate


//output registering at IF1-IF2 Boundary
always @(posedge clk) begin
    if(rst | Bubble)
        BranchType_Bus <= 0;    //Branch Type = None by default or on bubble
    else if(~Stall)
        BranchType_Bus <= BranchType_Bus_d;
end

`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;

    `ifdef DEBUG_IFU_BQD
        always @(negedge clk) begin
            if(Stall | Bubble) begin
                `ifdef DEBUG_IFU_BQD_STS
                    $display("[%t] IFUBQD@STS##: Stall=%b Bubble=%b", $time,
                        Stall, Bubble);
                `endif
            end
            else begin
                `ifdef DEBUG_IFU_BQD_ENTRY
                    $write("[%t] IFUBQD@ENT##: BType ", $time);
                    for(Di=0; Di<`FETCH_RATE_HW; Di=Di+1) begin
                        $write("%0d=%c ", Di, B2C(BranchType[Di]));
                    end
                    $display("");
                `endif
            end
        end
    `endif
`endif

endmodule

