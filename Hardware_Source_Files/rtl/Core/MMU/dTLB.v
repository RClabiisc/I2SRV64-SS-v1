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

(* keep_hierarchy = "yes" *)
module dTLB(
    input  wire clk,
    input  wire rst,
    input  wire [63:0] VPN_1,
    input  wire [63:0] VPN_2,
    input  wire re_1,
    input  wire re_2,
    input  wire we,
    input  wire [`TLB_WIDTH-1:0]write_data, // during replacement
    input  wire [4:0]write_address,                    // during replacement
    input  wire mmu_flush_req,
    input  wire csr_status_mxr,
    input  wire csr_status_sum,
    input  wire [1:0]csr_status_priv,
    output wire  [63:0]physical_address_1,
    output wire  [63:0]physical_address_2,
    output reg  TLB_hit_1,
    output reg  TLB_hit_2,
    output reg  [4:0]LRU_addr_tlb_1,
    output reg  [4:0]LRU_addr_tlb_2,
    output reg  port0_exception_reg,
    output reg  port1_exception_reg,
    input  wire bare_mode_en1,
    input wire bare_mode_en2
);

//parameter V = 0; //valid bit but this is already checked
wire [31:0]comp1,comp2;
reg [(`TLB_WIDTH-1):0]TLB_mem[0:31];
reg [`PPN_end - `PPN_start:0]PPN_1,PPN_2;
wire hit1;
wire hit2;
reg [4:0]LRU_addr_1;
reg [4:0]LRU_addr_2;
reg [31:0]valid_TLB;
reg permission_check_load, permission_check_store;
wire port0_exception, port1_exception;
parameter V = 0;
parameter R = 1;
parameter W = 2;
parameter X = 3;
parameter U = 4;
parameter A = 6;
parameter D = 7;
parameter M = `PRIV_LVL_M; //M-mode
parameter S = `PRIV_LVL_S; //S-mode
parameter User = `PRIV_LVL_U;  //U-mode
parameter VPN_start = 12;
parameter VPN_end = 38;

reg exception_mode_port0, exception_mode_port1;
reg [`PPN_end - `PPN_start:0]PPN_tag_1, PPN_tag_2;

assign physical_address_1 = bare_mode_en1 ? VPN_1 : {8'b0,PPN_tag_1,VPN_1[11:0]};
assign physical_address_2 = bare_mode_en2 ? VPN_2 : {8'b0,PPN_tag_2,VPN_2[11:0]};
//-------------------------------VALID---------------------------------------------//
 always @(posedge clk) begin
     if(rst | mmu_flush_req) begin
         valid_TLB <= 0;
     end
     else begin

         if(we) begin
            valid_TLB[write_address] <= 1;
         end
     end
  end

//---------------------- COMPARING TLB TAGS IN PARALLEL---------------------------//
genvar t;
generate
    for(t=0; t<32; t=t+1) begin
        assign comp1[t] = re_1?(valid_TLB[t] && (TLB_mem[t][`VPN_end : `VPN_start] == VPN_1[VPN_end : VPN_start])):0;
   end
endgenerate

genvar q;
generate
    for(q=0; q<32; q=q+1) begin
        assign comp2[q] = re_2?(valid_TLB[q] && (TLB_mem[q][`VPN_end : `VPN_start] == VPN_2[VPN_end : VPN_start])):0;
   end
endgenerate


//----------------------------------------------- TLB HIT CHECK---------------------------------------------------//

assign hit1 = (comp1!=32'd0) ? 1 : 0;
assign hit2 = (comp2!=32'd0) ? 1 : 0;
assign port0_exception = (!permission_check_load)|| exception_mode_port0;
assign port1_exception = (!permission_check_store)|| exception_mode_port1;

//------------------------------------ READ DATA (there will be atmost 1 match)-----------------------------------//
//integer j;
//always @ (*) begin
//        for(j=0; j<32; j=j+1) begin
//            if (comp[j]==1'b1)
//                PPN = TLB_mem[j][`PPN_end : `PPN_start];
//            else
//                PPN = 0;
//        end
//end


always @ (*) begin
    case (comp1)
        32'h00000001: begin
                      PPN_1 = TLB_mem[0][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd0;
                      ////////////////////////////////////////////////
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[0][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[0][R] == 1 || TLB_mem[0][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[0][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[0][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h00000002: begin
                      PPN_1 = TLB_mem[1][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd1;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[1][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[1][R] == 1 || TLB_mem[1][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[1][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[1][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h00000004: begin
                      PPN_1 = TLB_mem[2][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd2;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[2][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[2][R] == 1 || TLB_mem[2][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[2][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[2][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h00000008: begin
                      PPN_1 = TLB_mem[3][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd3;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[3][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[3][R] == 1 || TLB_mem[3][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[3][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[3][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h00000010: begin
                      PPN_1 = TLB_mem[4][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd4;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[4][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[4][R] == 1 || TLB_mem[4][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[4][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[4][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h00000020: begin
                      PPN_1 = TLB_mem[5][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd5;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[5][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[5][R] == 1 || TLB_mem[5][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[5][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[5][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h00000040: begin
                      PPN_1 = TLB_mem[6][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd6;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[6][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[6][R] == 1 || TLB_mem[6][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[6][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[6][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h00000080: begin
                      PPN_1 = TLB_mem[7][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd7;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[7][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[7][R] == 1 || TLB_mem[7][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[7][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[7][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h00000100: begin
                      PPN_1 = TLB_mem[8][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd8;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[8][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[8][R] == 1 || TLB_mem[8][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[8][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[8][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h00000200: begin
                      PPN_1 = TLB_mem[9][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd9;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[9][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[9][R] == 1 || TLB_mem[9][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[9][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[9][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h00000400: begin
                      PPN_1 = TLB_mem[10][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd10;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[10][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[10][R] == 1 || TLB_mem[10][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[10][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[10][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h00000800: begin
                      PPN_1 = TLB_mem[11][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd11;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[11][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[11][R] == 1 || TLB_mem[11][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[11][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[11][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h00001000: begin
                      PPN_1 = TLB_mem[12][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd12;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[12][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[12][R] == 1 || TLB_mem[12][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[12][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[12][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h00002000: begin
                      PPN_1 = TLB_mem[13][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd13;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[13][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[13][R] == 1 || TLB_mem[13][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[13][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[13][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h00004000: begin
                      PPN_1 = TLB_mem[14][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd14;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[14][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[14][R] == 1 || TLB_mem[14][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[14][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[14][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h00008000: begin
                      PPN_1 = TLB_mem[15][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd15;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[15][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[15][R] == 1 || TLB_mem[15][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[15][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[15][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h00010000: begin
                      PPN_1 = TLB_mem[16][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd16;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[16][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[16][R] == 1 || TLB_mem[16][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[16][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[16][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h00020000: begin
                      PPN_1 = TLB_mem[17][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd17;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[17][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[17][R] == 1 || TLB_mem[17][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[17][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[17][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h00040000: begin
                      PPN_1 = TLB_mem[18][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd18;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[18][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[18][R] == 1 || TLB_mem[18][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[18][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[18][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h00080000: begin
                      PPN_1 = TLB_mem[19][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd19;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[19][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[19][R] == 1 || TLB_mem[19][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[19][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[19][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h00100000: begin
                      PPN_1 = TLB_mem[20][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd20;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[20][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[20][R] == 1 || TLB_mem[20][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[20][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[20][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h00200000: begin
                      PPN_1 = TLB_mem[21][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd21;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[21][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[21][R] == 1 || TLB_mem[21][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[21][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[21][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h00400000: begin
                      PPN_1 = TLB_mem[22][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd22;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[22][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[22][R] == 1 || TLB_mem[22][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[22][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[22][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h00800000: begin
                      PPN_1 = TLB_mem[23][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd23;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[23][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[23][R] == 1 || TLB_mem[23][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[23][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[23][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h01000000: begin
                      PPN_1 = TLB_mem[24][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd24;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[24][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[24][R] == 1 || TLB_mem[24][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[24][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[24][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h02000000: begin
                      PPN_1 = TLB_mem[25][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd25;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[25][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[25][R] == 1 || TLB_mem[25][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[25][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[25][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h04000000: begin
                      PPN_1 = TLB_mem[26][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd26;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[26][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[26][R] == 1 || TLB_mem[26][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[26][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[26][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h08000000: begin
                      PPN_1 = TLB_mem[27][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd27;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[27][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[27][R] == 1 || TLB_mem[27][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[27][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[27][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h10000000: begin
                      PPN_1 = TLB_mem[28][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd28;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[28][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[28][R] == 1 || TLB_mem[28][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[28][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[28][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h20000000: begin
                      PPN_1 = TLB_mem[29][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd29;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[29][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[29][R] == 1 || TLB_mem[29][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[29][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[29][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h40000000: begin
                      PPN_1 = TLB_mem[30][`PPN_end : `PPN_start];
                      LRU_addr_1 = 5'd30;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[30][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[30][R] == 1 || TLB_mem[30][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[30][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[30][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        32'h80000000: begin
                      PPN_1 = TLB_mem[31][`PPN_end : `PPN_start];
                      LRU_addr_1= 5'd31;
                      if (csr_status_mxr == 0) begin
                        if(TLB_mem[31][R] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      else begin
                        if (TLB_mem[31][R] == 1 || TLB_mem[31][X] == 1)
                            permission_check_load = 1;
                        else
                            permission_check_load = 0;
                      end
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[31][U] == 1)
                            exception_mode_port0 = 0;
                        else
                            exception_mode_port0 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[31][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port0 = 1;
                        else // 11,01,00
                            exception_mode_port0 = 0;
                      end
                      else
                        exception_mode_port0 = 0;
                      end
        default     : begin
                      PPN_1 = 37'd0;
                      LRU_addr_1 = 5'd0;
                      permission_check_load = 0;
                      exception_mode_port0 = 0;
                      end
        endcase
end

//-------------------------------------------------------------------------------------------------------//
always @ (*) begin
    case (comp2)
        32'h00000001: begin
                      PPN_2 = TLB_mem[0][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd0;
                      permission_check_store = ((TLB_mem[0][W] == 1) && (TLB_mem[0][R] == 1) && (TLB_mem[0][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[0][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[0][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h00000002: begin
                      PPN_2 = TLB_mem[1][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd1;
                      permission_check_store = ((TLB_mem[1][W] == 1) && (TLB_mem[1][R] == 1) && (TLB_mem[1][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[1][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[1][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h00000004: begin
                      PPN_2 = TLB_mem[2][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd2;
                      permission_check_store = ((TLB_mem[2][W] == 1) && (TLB_mem[2][R] == 1) && (TLB_mem[2][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[2][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[2][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h00000008: begin
                      PPN_2 = TLB_mem[3][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd3;
                      permission_check_store = ((TLB_mem[3][W] == 1) && (TLB_mem[3][R] == 1) && (TLB_mem[3][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[3][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[3][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h00000010: begin
                      PPN_2 = TLB_mem[4][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd4;
                      permission_check_store = ((TLB_mem[4][W] == 1) && (TLB_mem[4][R] == 1) && (TLB_mem[4][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[4][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[4][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h00000020: begin
                      PPN_2 = TLB_mem[5][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd5;
                      permission_check_store = ((TLB_mem[5][W] == 1) && (TLB_mem[5][R] == 1) && (TLB_mem[5][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[5][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[5][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h00000040: begin
                      PPN_2 = TLB_mem[6][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd6;
                      permission_check_store = ((TLB_mem[6][W] == 1) && (TLB_mem[6][R] == 1) && (TLB_mem[6][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[6][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[6][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h00000080: begin
                      PPN_2 = TLB_mem[7][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd7;
                      permission_check_store = ((TLB_mem[7][W]) & (TLB_mem[7][R]) & (TLB_mem[7][D]));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[7][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[7][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h00000100: begin
                      PPN_2 = TLB_mem[8][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd8;
                      permission_check_store = ((TLB_mem[8][W] == 1) && (TLB_mem[8][R] == 1) && (TLB_mem[8][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[8][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[8][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h00000200: begin
                      PPN_2 = TLB_mem[9][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd9;
                      permission_check_store = ((TLB_mem[9][W] == 1) && (TLB_mem[9][R] == 1) && (TLB_mem[9][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[9][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[9][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h00000400: begin
                      PPN_2 = TLB_mem[10][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd10;
                      permission_check_store = ((TLB_mem[10][W] == 1) && (TLB_mem[10][R] == 1) && (TLB_mem[10][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[10][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[10][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h00000800: begin
                      PPN_2 = TLB_mem[11][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd11;
                      permission_check_store = ((TLB_mem[11][W] == 1) && (TLB_mem[11][R] == 1) && (TLB_mem[11][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[11][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[11][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h00001000: begin
                      PPN_2 = TLB_mem[12][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd12;
                      permission_check_store = ((TLB_mem[12][W] == 1) && (TLB_mem[12][R] == 1) && (TLB_mem[12][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[12][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[12][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h00002000: begin
                      PPN_2 = TLB_mem[13][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd13;
                      permission_check_store = ((TLB_mem[13][W] == 1) && (TLB_mem[13][R] == 1) && (TLB_mem[13][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[13][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[13][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;

                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h00004000: begin
                      PPN_2 = TLB_mem[14][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd14;
                      permission_check_store = ((TLB_mem[14][W] == 1) && (TLB_mem[14][R] == 1) && (TLB_mem[14][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[14][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[14][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h00008000: begin
                      PPN_2 = TLB_mem[15][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd15;
                      permission_check_store = ((TLB_mem[15][W] == 1) && (TLB_mem[15][R] == 1) && (TLB_mem[15][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[15][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[15][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h00010000: begin
                      PPN_2 = TLB_mem[16][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd16;
                      permission_check_store = ((TLB_mem[16][W] == 1) && (TLB_mem[16][R] == 1) && (TLB_mem[16][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[16][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[16][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h00020000: begin
                      PPN_2 = TLB_mem[17][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd17;
                      permission_check_store = ((TLB_mem[17][W] == 1) && (TLB_mem[17][R] == 1) && (TLB_mem[17][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[17][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[17][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h00040000: begin
                      PPN_2 = TLB_mem[18][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd18;
                      permission_check_store = ((TLB_mem[18][W] == 1) && (TLB_mem[18][R] == 1) && (TLB_mem[18][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[18][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[18][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h00080000: begin
                      PPN_2 = TLB_mem[19][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd19;
                      permission_check_store = ((TLB_mem[19][W] == 1) && (TLB_mem[19][R] == 1) && (TLB_mem[19][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[19][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[19][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h00100000: begin
                      PPN_2 = TLB_mem[20][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd20;
                      permission_check_store = ((TLB_mem[20][W] == 1) && (TLB_mem[20][R] == 1) && (TLB_mem[20][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[20][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[20][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h00200000: begin
                      PPN_2 = TLB_mem[21][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd21;
                      permission_check_store = ((TLB_mem[21][W] == 1) && (TLB_mem[21][R] == 1) && (TLB_mem[21][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[21][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[21][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h00400000: begin
                      PPN_2 = TLB_mem[22][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd22;
                      permission_check_store = ((TLB_mem[22][W] == 1) && (TLB_mem[22][R] == 1) && (TLB_mem[22][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[22][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[22][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h00800000: begin
                      PPN_2 = TLB_mem[23][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd23;
                      permission_check_store = ((TLB_mem[23][W] == 1) && (TLB_mem[23][R] == 1) && (TLB_mem[23][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[23][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[23][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h01000000: begin
                      PPN_2 = TLB_mem[24][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd24;
                      permission_check_store = ((TLB_mem[24][W] == 1) && (TLB_mem[24][R] == 1) && (TLB_mem[24][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[24][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[24][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h02000000: begin
                      PPN_2 = TLB_mem[25][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd25;
                      permission_check_store = ((TLB_mem[25][W] == 1) && (TLB_mem[25][R] == 1) && (TLB_mem[25][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[25][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[25][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h04000000: begin
                      PPN_2 = TLB_mem[26][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd26;
                      permission_check_store = ((TLB_mem[26][W] == 1) && (TLB_mem[26][R] == 1) && (TLB_mem[26][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[26][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[26][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h08000000: begin
                      PPN_2 = TLB_mem[27][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd27;
                      permission_check_store = ((TLB_mem[27][W] == 1) && (TLB_mem[27][R] == 1) && (TLB_mem[27][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[27][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[27][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h10000000: begin
                      PPN_2 = TLB_mem[28][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd28;
                      permission_check_store = ((TLB_mem[28][W] == 1) && (TLB_mem[28][R] == 1) && (TLB_mem[28][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[28][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[28][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h20000000: begin
                      PPN_2 = TLB_mem[29][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd29;
                      permission_check_store = ((TLB_mem[29][W] == 1) && (TLB_mem[29][R] == 1) && (TLB_mem[29][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[29][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[29][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h40000000: begin
                      PPN_2 = TLB_mem[30][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd30;
                      permission_check_store = ((TLB_mem[30][W] == 1) && (TLB_mem[30][R] == 1) && (TLB_mem[30][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[30][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[30][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        32'h80000000: begin
                      PPN_2 = TLB_mem[31][`PPN_end : `PPN_start];
                      LRU_addr_2 = 5'd31;
                      permission_check_store = ((TLB_mem[31][W] == 1) && (TLB_mem[31][R] == 1) && (TLB_mem[31][D] == 1));
                      /////////////////////////////////////////////////
                      if (csr_status_priv == User) begin
                        if (TLB_mem[31][U] == 1)
                            exception_mode_port1 = 0;
                        else
                            exception_mode_port1 = 1;
                      end
                      else if (csr_status_priv == S) begin
                        if (TLB_mem[31][U] == 1 & csr_status_sum == 0) // 10
                            exception_mode_port1 = 1;
                        else // 11,01,00
                            exception_mode_port1 = 0;
                      end
                      else
                        exception_mode_port1 = 0;
                      end
        default     : begin
                      PPN_2 = 44'd0;
                      LRU_addr_2 = 5'd0;
                      permission_check_store = 0;
                      exception_mode_port1 = 0;
                      end
        endcase
end

//---------------------------------------TLB READ (1CLK LATENCY LIKE CACHE)------------------------------//
always @ (posedge clk) begin
    if (rst) begin
        PPN_tag_1 <= 44'b0;
        TLB_hit_1 <= 1'b0;
        LRU_addr_tlb_1 <= 4'b0;
        port0_exception_reg <= 0;
        end
     else if (re_1) begin
            PPN_tag_1 <= PPN_1;
            TLB_hit_1 <= hit1;
            LRU_addr_tlb_1 <= LRU_addr_1;
            port0_exception_reg <= port0_exception;
      end
//        ///////////////////////LOOK AT THIS---REOMVE??????????/////////////////////////////////
//     else if (we) begin //saving an extra read
//        PPN_tag_1 <= write_data[`PPN_end : `PPN_start];
//        TLB_hit_1 <= 1'b1;
//        LRU_addr_tlb_1 <= write_address;
//        end
     else begin
        PPN_tag_1 <= 44'b0;
        TLB_hit_1 <= 1'b0;
        LRU_addr_tlb_1 <= LRU_addr_1;
        port0_exception_reg <= port0_exception;
     end
end

always @ (posedge clk) begin
    if (rst) begin
        PPN_tag_2 <= 44'b0;
        TLB_hit_2 <= 1'b0;
        LRU_addr_tlb_2 <= 4'b0;
        port1_exception_reg <= 0;
        end
     else if (re_2) begin
            PPN_tag_2 <= PPN_2;
            TLB_hit_2 <= hit2;
            LRU_addr_tlb_2 <= LRU_addr_2;
            port1_exception_reg <= port1_exception;
     end
//     else if (we) begin //saving an extra read
//        PPN_tag_2 <= write_data[`PPN_end : `PPN_start];
//        TLB_hit_2 <= 1'b1;
//        LRU_addr_tlb_2 <= write_address;
//        end
     else begin
        PPN_tag_2 <= 44'b0;
        TLB_hit_2 <= 1'b0;
        LRU_addr_tlb_2 <= LRU_addr_2;
        port1_exception_reg <= port1_exception;
     end
end
// ----------------------------------------------TLB WRITE-----------------------------------------------//
integer i;
always @ (posedge clk) begin
    if (rst) begin
        for(i=0; i<32;i=i+1)
            TLB_mem[i]<=91'b0;
    end
    else begin
        if (we)
            TLB_mem[write_address] <= write_data;
    end
end
endmodule
