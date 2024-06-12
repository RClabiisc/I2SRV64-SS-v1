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
module PLRU32_TLB
(
    input wire                    clk,          //
    input wire                    rst,          //

    input wire                    UpdateEn,     // 1=>enable LRU state update

    input wire [4:0]              ReadWay,      // 1=>TLB Way which is hit on read operation
    input wire                    ReadAccess,   // 1=>TLB Read Operation

    input wire [4:0]              WriteWay,     // TLB Way where write operation will happen (if not known already, connect to PLRU_Way output externally)
    input wire                    WriteAccess,  // TLB Write Operation

    output reg [4:0]              LRU_Way       // LRU Way
);

//wires
wire [4:0] AccessWay = ReadAccess ? ReadWay : (WriteAccess ? WriteWay : 0);

//memory instantiation
reg         level0; //1
reg [1:0]   level1; //2
reg [3:0]   level2; //4
reg [7:0]   level3; //8
reg [15:0]  level4; //16

//PLRU update logic
always @(posedge clk) begin
    if(rst) begin
        level0 <= 0;
        level1 <= 0;
        level2 <= 0;
        level3 <= 0;
        level4 <= 0;
    end
    else if(UpdateEn & (ReadAccess | WriteAccess)) begin
        //either read access or write access. if both happens in same clk then do not update states

        case (AccessWay)
            5'd0  : begin level0<=1'b1; level1[0]<=1'b1;  level2[0]<=1'b1;  level3[0]<=1'b1;  level4[ 0]<=1'b1; end
            5'd1  : begin level0<=1'b1; level1[0]<=1'b1;  level2[0]<=1'b1;  level3[0]<=1'b1;  level4[ 0]<=1'b0; end
            5'd2  : begin level0<=1'b1; level1[0]<=1'b1;  level2[0]<=1'b1;  level3[0]<=1'b0;  level4[ 1]<=1'b1; end
            5'd3  : begin level0<=1'b1; level1[0]<=1'b1;  level2[0]<=1'b1;  level3[0]<=1'b0;  level4[ 1]<=1'b0; end
            5'd4  : begin level0<=1'b1; level1[0]<=1'b1;  level2[0]<=1'b0;  level3[1]<=1'b1;  level4[ 2]<=1'b1; end
            5'd5  : begin level0<=1'b1; level1[0]<=1'b1;  level2[0]<=1'b0;  level3[1]<=1'b1;  level4[ 2]<=1'b0; end
            5'd6  : begin level0<=1'b1; level1[0]<=1'b1;  level2[0]<=1'b0;  level3[1]<=1'b0;  level4[ 3]<=1'b1; end
            5'd7  : begin level0<=1'b1; level1[0]<=1'b1;  level2[0]<=1'b0;  level3[1]<=1'b0;  level4[ 3]<=1'b0; end
            5'd8  : begin level0<=1'b1; level1[0]<=1'b0;  level2[1]<=1'b1;  level3[2]<=1'b1;  level4[ 4]<=1'b1; end
            5'd9  : begin level0<=1'b1; level1[0]<=1'b0;  level2[1]<=1'b1;  level3[2]<=1'b1;  level4[ 4]<=1'b0; end
            5'd10 : begin level0<=1'b1; level1[0]<=1'b0;  level2[1]<=1'b1;  level3[2]<=1'b0;  level4[ 5]<=1'b1; end
            5'd11 : begin level0<=1'b1; level1[0]<=1'b0;  level2[1]<=1'b1;  level3[2]<=1'b0;  level4[ 5]<=1'b0; end
            5'd12 : begin level0<=1'b1; level1[0]<=1'b0;  level2[1]<=1'b0;  level3[3]<=1'b1;  level4[ 6]<=1'b1; end
            5'd13 : begin level0<=1'b1; level1[0]<=1'b0;  level2[1]<=1'b0;  level3[3]<=1'b1;  level4[ 6]<=1'b0; end
            5'd14 : begin level0<=1'b1; level1[0]<=1'b0;  level2[1]<=1'b0;  level3[3]<=1'b0;  level4[ 7]<=1'b1; end
            5'd15 : begin level0<=1'b1; level1[0]<=1'b0;  level2[1]<=1'b0;  level3[3]<=1'b0;  level4[ 7]<=1'b0; end
            5'd16 : begin level0<=1'b0; level1[1]<=1'b1;  level2[2]<=1'b1;  level3[4]<=1'b1;  level4[ 8]<=1'b1; end
            5'd17 : begin level0<=1'b0; level1[1]<=1'b1;  level2[2]<=1'b1;  level3[4]<=1'b1;  level4[ 8]<=1'b0; end
            5'd18 : begin level0<=1'b0; level1[1]<=1'b1;  level2[2]<=1'b1;  level3[4]<=1'b0;  level4[ 9]<=1'b1; end
            5'd19 : begin level0<=1'b0; level1[1]<=1'b1;  level2[2]<=1'b1;  level3[4]<=1'b0;  level4[ 9]<=1'b0; end
            5'd20 : begin level0<=1'b0; level1[1]<=1'b1;  level2[2]<=1'b0;  level3[5]<=1'b1;  level4[10]<=1'b1; end
            5'd21 : begin level0<=1'b0; level1[1]<=1'b1;  level2[2]<=1'b0;  level3[5]<=1'b1;  level4[10]<=1'b0; end
            5'd22 : begin level0<=1'b0; level1[1]<=1'b1;  level2[2]<=1'b0;  level3[5]<=1'b0;  level4[11]<=1'b1; end
            5'd23 : begin level0<=1'b0; level1[1]<=1'b1;  level2[2]<=1'b0;  level3[5]<=1'b0;  level4[11]<=1'b0; end
            5'd24 : begin level0<=1'b0; level1[1]<=1'b0;  level2[3]<=1'b1;  level3[6]<=1'b1;  level4[12]<=1'b1; end
            5'd25 : begin level0<=1'b0; level1[1]<=1'b0;  level2[3]<=1'b1;  level3[6]<=1'b1;  level4[12]<=1'b0; end
            5'd26 : begin level0<=1'b0; level1[1]<=1'b0;  level2[3]<=1'b1;  level3[6]<=1'b0;  level4[13]<=1'b1; end
            5'd27 : begin level0<=1'b0; level1[1]<=1'b0;  level2[3]<=1'b1;  level3[6]<=1'b0;  level4[13]<=1'b0; end
            5'd28 : begin level0<=1'b0; level1[1]<=1'b0;  level2[3]<=1'b0;  level3[7]<=1'b1;  level4[14]<=1'b1; end
            5'd29 : begin level0<=1'b0; level1[1]<=1'b0;  level2[3]<=1'b0;  level3[7]<=1'b1;  level4[14]<=1'b0; end
            5'd30 : begin level0<=1'b0; level1[1]<=1'b0;  level2[3]<=1'b0;  level3[7]<=1'b0;  level4[15]<=1'b1; end
            5'd31 : begin level0<=1'b0; level1[1]<=1'b0;  level2[3]<=1'b0;  level3[7]<=1'b0;  level4[15]<=1'b0; end
        endcase
    end
end

//LRU way output logic
always @*
begin
    casez({level0 , level1 , level2  , level3       , level4})
        {1'b0     , 2'bz0  , 4'bzzz0 , 8'bzzzz_zzz0 , 16'bzzzz_zzzz_zzzz_zzz0} : LRU_Way = 5'd0;
        {1'b0     , 2'bz0  , 4'bzzz0 , 8'bzzzz_zzz0 , 16'bzzzz_zzzz_zzzz_zzz1} : LRU_Way = 5'd1;
        {1'b0     , 2'bz0  , 4'bzzz0 , 8'bzzzz_zzz1 , 16'bzzzz_zzzz_zzzz_zz0z} : LRU_Way = 5'd2;
        {1'b0     , 2'bz0  , 4'bzzz0 , 8'bzzzz_zzz1 , 16'bzzzz_zzzz_zzzz_zz1z} : LRU_Way = 5'd3;
        {1'b0     , 2'bz0  , 4'bzzz1 , 8'bzzzz_zz0z , 16'bzzzz_zzzz_zzzz_z0zz} : LRU_Way = 5'd4;
        {1'b0     , 2'bz0  , 4'bzzz1 , 8'bzzzz_zz0z , 16'bzzzz_zzzz_zzzz_z1zz} : LRU_Way = 5'd5;
        {1'b0     , 2'bz0  , 4'bzzz1 , 8'bzzzz_zz1z , 16'bzzzz_zzzz_zzzz_0zzz} : LRU_Way = 5'd6;
        {1'b0     , 2'bz0  , 4'bzzz1 , 8'bzzzz_zz1z , 16'bzzzz_zzzz_zzzz_1zzz} : LRU_Way = 5'd7;
        {1'b0     , 2'bz1  , 4'bzz0z , 8'bzzzz_z0zz , 16'bzzzz_zzzz_zzz0_zzzz} : LRU_Way = 5'd8;
        {1'b0     , 2'bz1  , 4'bzz0z , 8'bzzzz_z0zz , 16'bzzzz_zzzz_zzz1_zzzz} : LRU_Way = 5'd9;
        {1'b0     , 2'bz1  , 4'bzz0z , 8'bzzzz_z1zz , 16'bzzzz_zzzz_zz0z_zzzz} : LRU_Way = 5'd10;
        {1'b0     , 2'bz1  , 4'bzz0z , 8'bzzzz_z1zz , 16'bzzzz_zzzz_zz1z_zzzz} : LRU_Way = 5'd11;
        {1'b0     , 2'bz1  , 4'bzz1z , 8'bzzzz_0zzz , 16'bzzzz_zzzz_z0zz_zzzz} : LRU_Way = 5'd12;
        {1'b0     , 2'bz1  , 4'bzz1z , 8'bzzzz_0zzz , 16'bzzzz_zzzz_z1zz_zzzz} : LRU_Way = 5'd13;
        {1'b0     , 2'bz1  , 4'bzz1z , 8'bzzzz_1zzz , 16'bzzzz_zzzz_0zzz_zzzz} : LRU_Way = 5'd14;
        {1'b0     , 2'bz1  , 4'bzz1z , 8'bzzzz_1zzz , 16'bzzzz_zzzz_1zzz_zzzz} : LRU_Way = 5'd15;
        {1'b1     , 2'b0z  , 4'bz0zz , 8'bzzz0_zzzz , 16'bzzzz_zzz0_zzzz_zzzz} : LRU_Way = 5'd16;
        {1'b1     , 2'b0z  , 4'bz0zz , 8'bzzz0_zzzz , 16'bzzzz_zzz1_zzzz_zzzz} : LRU_Way = 5'd17;
        {1'b1     , 2'b0z  , 4'bz0zz , 8'bzzz1_zzzz , 16'bzzzz_zz0z_zzzz_zzzz} : LRU_Way = 5'd18;
        {1'b1     , 2'b0z  , 4'bz0zz , 8'bzzz1_zzzz , 16'bzzzz_zz1z_zzzz_zzzz} : LRU_Way = 5'd19;
        {1'b1     , 2'b0z  , 4'bz1zz , 8'bzz0z_zzzz , 16'bzzzz_z0zz_zzzz_zzzz} : LRU_Way = 5'd20;
        {1'b1     , 2'b0z  , 4'bz1zz , 8'bzz0z_zzzz , 16'bzzzz_z1zz_zzzz_zzzz} : LRU_Way = 5'd21;
        {1'b1     , 2'b0z  , 4'bz1zz , 8'bzz1z_zzzz , 16'bzzzz_0zzz_zzzz_zzzz} : LRU_Way = 5'd22;
        {1'b1     , 2'b0z  , 4'bz1zz , 8'bzz1z_zzzz , 16'bzzzz_1zzz_zzzz_zzzz} : LRU_Way = 5'd23;
        {1'b1     , 2'b1z  , 4'b0zzz , 8'bz0zz_zzzz , 16'bzzz0_zzzz_zzzz_zzzz} : LRU_Way = 5'd24;
        {1'b1     , 2'b1z  , 4'b0zzz , 8'bz0zz_zzzz , 16'bzzz1_zzzz_zzzz_zzzz} : LRU_Way = 5'd25;
        {1'b1     , 2'b1z  , 4'b0zzz , 8'bz1zz_zzzz , 16'bzz0z_zzzz_zzzz_zzzz} : LRU_Way = 5'd26;
        {1'b1     , 2'b1z  , 4'b0zzz , 8'bz1zz_zzzz , 16'bzz1z_zzzz_zzzz_zzzz} : LRU_Way = 5'd27;
        {1'b1     , 2'b1z  , 4'b1zzz , 8'b0zzz_zzzz , 16'bz0zz_zzzz_zzzz_zzzz} : LRU_Way = 5'd28;
        {1'b1     , 2'b1z  , 4'b1zzz , 8'b0zzz_zzzz , 16'bz1zz_zzzz_zzzz_zzzz} : LRU_Way = 5'd29;
        {1'b1     , 2'b1z  , 4'b1zzz , 8'b1zzz_zzzz , 16'b0zzz_zzzz_zzzz_zzzz} : LRU_Way = 5'd30;
        {1'b1     , 2'b1z  , 4'b1zzz , 8'b1zzz_zzzz , 16'b1zzz_zzzz_zzzz_zzzz} : LRU_Way = 5'd31;
        default: LRU_Way = 5'd0;
    endcase
end

endmodule
/*  For reference
level0                                                                0
level1                                 0                                                              1
level2                 0                               1                               2                              3
level3         0               1               2               3               4               5               6               7
level4     0       1       2       3       4        5      6       7       8       9       10      11      12      13      14      15
node =   0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17  18  19  20  21  22  23  24  25  26  27  28  29  30  31
*/
