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
`include "ISA_priv_defines.vh"

(* keep_hierarchy = "yes" *)
module FP2INT
(
    input  wire [63:0]  INPUT,
    input  wire         IsDouble,
    input  wire         Is_Unsigned,
    input  wire         IsWord,
    input  wire [2:0]   Rounding_Mode,
    output reg  [63:0]  OUTPUT,
    output reg          INVALID,
    output reg          OVERFLOW,
    output reg          UNDERFLOW

);

wire [7:0] Zero_Exp_SP = {1'b0,{7{1'b1}}};
wire [10:0] Zero_Exp_DP = {1'b0,{10{1'b1}}};

wire sign;
assign sign = IsDouble ? INPUT[63] : INPUT[31];

wire [7:0] exp_SP = INPUT[30:23];
wire [10:0] exp_DP = INPUT[62:52];

wire [23:0] man_SP = {exp_SP!=0,INPUT[22:0]};  //1.M
wire [52:0] man_DP = {exp_DP!=0,INPUT[51:0]};  //1.M

wire INPUT_NaN = IsDouble ? ((&exp_DP) & (|INPUT[51:0])) : ((&exp_SP) & (|INPUT[22:0]));

wire [63:0] Max_Int_Signed_dw  = (sign & ~INPUT_NaN) ? 64'h80000000_00000000 : 64'h7fffffff_ffffffff;
wire [63:0] Max_Int_Unsigned_dw  = (sign & ~INPUT_NaN) ? 64'h00000000_00000000 : 64'hffffffff_ffffffff;
wire [63:0] Max_Int_Signed_w  = (sign & ~INPUT_NaN) ? 64'hFFFFFFFF80000000 : 64'h00000000_7fffffff;
wire [63:0] Max_Int_Unsigned_w  = (sign & ~INPUT_NaN) ? 64'h00000000_00000000 : 64'h00000000_ffffffff;

wire INPUT_zero_SP = INPUT[30:0]==0;
wire INPUT_zero_DP = INPUT[62:0]==0;
wire [10:0] Zero_Exp_DP_1 = IsWord ? (Zero_Exp_DP + 31) : (Zero_Exp_DP + 63) ;
wire [7:0] Zero_Exp_SP_1 = IsWord ? (Zero_Exp_SP + 31) : (Zero_Exp_SP + 63) ;

always @(*) begin
    if (INPUT_NaN == 1'b0) begin
        if(IsDouble==1) begin
            if(Is_Unsigned==1) begin
                OVERFLOW  = sign ?  1'b1 : exp_DP > Zero_Exp_DP_1;
            end
            else begin
                OVERFLOW  = exp_DP > (Zero_Exp_DP_1 - 1);
            end
            UNDERFLOW = exp_DP < Zero_Exp_DP - 1;
        end
        else begin
            if(Is_Unsigned==1) begin
                OVERFLOW  = sign ? 1'b1 : exp_SP > Zero_Exp_SP_1;
            end
            else begin
                OVERFLOW  = exp_SP > (Zero_Exp_SP_1 - 1);
            end
            UNDERFLOW = exp_SP < Zero_Exp_SP - 1;
        end
    end
    else begin
        OVERFLOW  = 1'b0;
        UNDERFLOW = 1'b0;
    end
end

always @(*) begin

    if ((INPUT_NaN == 1'b1) || (OVERFLOW == 1'b1) || (UNDERFLOW == 1'b1)) begin
        INVALID = 1'b1;
    end
    else begin
        INVALID = 1'b0;
    end
end

reg Add_Rounding_Bit_w;
reg Add_Rounding_Bit_dw;

wire [7:0] shift_SP_temp = IsWord ? (31 - (exp_SP - Zero_Exp_SP)) : (63 - (exp_SP - Zero_Exp_SP));
wire [10:0] shift_DP_temp = (63 - (exp_DP - Zero_Exp_DP));
wire [5:0] shift_SP = shift_SP_temp[5:0];
wire [6:0] shift_DP = shift_DP_temp[6:0];

wire [34:0] o1_SP = {man_SP,{8{1'b0}},3'b0} >> shift_SP;
wire [31:0] o2_SP = o1_SP[34:3] + {31'b0,Add_Rounding_Bit_w};

wire [66:0] o1_DP_temp = {man_DP,{11{1'b0}},3'b0} >> shift_DP;//3 extra bits for rounding
wire [34:0] o1_DP = o1_DP_temp[34:0];
wire [31:0] o2_DP = o1_DP[34:3] + {31'b0,Add_Rounding_Bit_w};

wire [66:0] y1_SP = {man_SP,{40{1'b0}},3'b0} >> shift_SP;
wire [63:0] y2_SP = y1_SP[66:3] + {63'b0,Add_Rounding_Bit_dw};

wire [66:0] y1_DP = {man_DP,{11{1'b0}},3'b0} >> shift_DP;
wire [63:0] y2_DP = y1_DP[66:3] + {63'b0,Add_Rounding_Bit_dw};

wire LSB_W = IsDouble ? o1_DP[3] : o1_SP[3];
wire Guard_W = IsDouble ? o1_DP[2] : o1_SP[2];
wire Round_W = IsDouble ? o1_DP[1] : o1_SP[1];
wire Sticky_W = IsDouble ? o1_DP[0] : o1_SP[0];

wire LSB_DW = IsDouble ? y1_DP[3] : y1_SP[3];
wire Guard_DW = IsDouble ? y1_DP[2] : y1_SP[2];
wire Round_DW = IsDouble ? y1_DP[1] : y1_SP[1];
wire Sticky_DW = IsDouble ? y1_DP[0] : y1_SP[0];

always @(*) begin
    case(Rounding_Mode)
        `FCSR_FRM_RNE : begin
                Add_Rounding_Bit_w = Guard_W & (LSB_W | Round_W | Sticky_W);
                Add_Rounding_Bit_dw = Guard_DW & (LSB_DW | Round_DW | Sticky_DW);
                end
        `FCSR_FRM_RTZ  : begin
                Add_Rounding_Bit_w = 1'b0;
                Add_Rounding_Bit_dw = 1'b0;
                end
        `FCSR_FRM_RDN : begin
                Add_Rounding_Bit_w = Is_Unsigned ? 1'b0 : (sign & (Guard_W | Round_W | Sticky_W));
                Add_Rounding_Bit_dw = Is_Unsigned ? 1'b0 : (sign & (Guard_DW | Round_DW | Sticky_DW));
                end
        `FCSR_FRM_RUP : begin
                Add_Rounding_Bit_w = Is_Unsigned ? 1'b0 : ((~sign) & (Guard_DW | Round_DW | Sticky_DW));
                Add_Rounding_Bit_dw = Is_Unsigned ? 1'b0 : ((~sign) & (Guard_DW | Round_DW | Sticky_DW));
                end
        `FCSR_FRM_RMM : begin
                Add_Rounding_Bit_w = Guard_W;
                Add_Rounding_Bit_dw = Guard_DW;
                end
        default: begin
                Add_Rounding_Bit_w = 1'b0;
                Add_Rounding_Bit_dw = 1'b0;
                end
    endcase
end



always @(*) begin
    if (IsDouble == 1) begin
        if (UNDERFLOW | INPUT_zero_DP) begin
            OUTPUT = 0;
        end
        else if (OVERFLOW | INPUT_NaN) begin
            if(Is_Unsigned == 1) begin
                if (IsWord)
                    OUTPUT = Max_Int_Unsigned_w;
                else
                    OUTPUT = Max_Int_Unsigned_dw;
            end
            else begin
                if (IsWord)
                    OUTPUT = Max_Int_Signed_w;
                else
                    OUTPUT = Max_Int_Signed_dw;
            end
        end
        else if (exp_DP==Zero_Exp_DP-1) begin
            OUTPUT = 0;
        end
        else begin
            //For RV64, FCVT.W[U].D sign-extends the 32-bit result.
            if(Is_Unsigned==1) begin
                if (IsWord) begin
                    OUTPUT = {32'b0,o2_DP};
                end
                else begin
                    OUTPUT = y2_DP;
                end
            end
            else begin
                if (IsWord) begin
                    OUTPUT = sign ? {{32{1'b1}},-o2_DP} : {32'b0,o2_DP};
                end
                else begin
                    OUTPUT = sign ? -y2_DP : y2_DP;
                end
            end
        end
    end
    else begin
        if (UNDERFLOW | INPUT_zero_SP)
            OUTPUT = 0;
        else if (OVERFLOW | INPUT_NaN) begin
            if(Is_Unsigned == 1) begin
                if (IsWord)
                    OUTPUT = Max_Int_Unsigned_w;
                else
                    OUTPUT = Max_Int_Unsigned_dw;
            end
            else begin
                if (IsWord)
                    OUTPUT = Max_Int_Signed_w;
                else
                    OUTPUT = Max_Int_Signed_dw;
            end
        end
        else if (exp_SP==Zero_Exp_SP-1) begin
            OUTPUT = 0;
        end
        else begin
            //For XLEN> 32, FCVT.W[U].S sign-extends the 32-bit
            //result to the destination register width
            if(Is_Unsigned==1) begin
                if (IsWord) begin
                    OUTPUT = {32'b0,o2_SP};
                end
                else begin
                    OUTPUT = y2_SP;
                end
            end
            else begin
                if (IsWord) begin
                    OUTPUT = sign ? {{32{1'b1}},-o2_SP} : {32'b0,o2_SP};
                end
                else begin
                    OUTPUT = sign ? -y2_SP : y2_SP;
                end
            end
        end
    end
end

endmodule

