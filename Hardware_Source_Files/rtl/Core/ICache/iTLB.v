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
module iTLB(
    input  wire clk,
    input  wire rst,
    input  wire [`PPN_end - `PPN_start:0] VPN, //44-bits
    input  wire re,
    input  wire we,
    input  wire [`TLB_WIDTH-1:0]write_data, // during replacement
    input  wire [4:0]write_address,                    // during replacement
    input  wire itlb_full_flush,
    output reg  [`PPN_end - `PPN_start:0]PPN_tag,
    output reg  TLB_hit,
    output reg  [4:0]LRU_addr_tlb,
    input  wire [1:0]MPP,
    output reg  exception,
    input  wire [3:0]SATP_mode
);

parameter V = 0; //valid bit but this is already checked
parameter M = 2'b11; //M-mode
parameter S = 2'b01; //S-mode
parameter User = 2'b00;  //U-mode
parameter U = 4;
wire [31:0]comp;
reg [(`TLB_WIDTH-1):0]TLB_mem[0:31];
reg [`PPN_end - `PPN_start:0]PPN;
wire hit;
reg [4:0]LRU_addr;
reg [31:0]valid_TLB;
reg exception_mode;

//-------------------------------VALID---------------------------------------------//
 always @(posedge clk) begin
     if(rst | itlb_full_flush) begin
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
        assign comp[t] = re?(valid_TLB[t]&(TLB_mem[t][V] && (TLB_mem[t][`VPN_end : `VPN_start] == VPN[`VPN_end - `VPN_start:0]))):0;
   end
endgenerate


//---------------------------- TLB HIT CHECK--------------------------------------//
assign hit = (comp==32'd0)? 0 : 1;


//------------------ READ DATA (there will be atmost 1 match)-----------------------//
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
    case (comp)
        32'h00000001: begin
                      PPN = TLB_mem[0][`PPN_end : `PPN_start];
                      LRU_addr = 5'd0;
                      if ( MPP == S) begin
                        if (TLB_mem[0][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[0][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h00000002: begin
                      PPN = TLB_mem[1][`PPN_end : `PPN_start];
                      LRU_addr = 5'd1;
                      if ( MPP == S) begin
                        if (TLB_mem[1][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[1][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h00000004: begin
                      PPN = TLB_mem[2][`PPN_end : `PPN_start];
                      LRU_addr = 5'd2;
                      if ( MPP == S) begin
                        if (TLB_mem[2][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[2][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h00000008: begin
                      PPN = TLB_mem[3][`PPN_end : `PPN_start];
                      LRU_addr = 5'd3;
                      if ( MPP == S) begin
                        if (TLB_mem[3][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[3][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h00000010: begin
                      PPN = TLB_mem[4][`PPN_end : `PPN_start];
                      LRU_addr = 5'd4;
                      if ( MPP == S) begin
                        if (TLB_mem[4][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[4][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h00000020: begin
                      PPN = TLB_mem[5][`PPN_end : `PPN_start];
                      LRU_addr = 5'd5;
                      if ( MPP == S) begin
                        if (TLB_mem[5][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[5][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h00000040: begin
                      PPN = TLB_mem[6][`PPN_end : `PPN_start];
                      LRU_addr = 5'd6;
                      if ( MPP == S) begin
                        if (TLB_mem[6][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[6][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h00000080: begin
                      PPN = TLB_mem[7][`PPN_end : `PPN_start];
                      LRU_addr = 5'd7;
                      if ( MPP == S) begin
                        if (TLB_mem[7][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[7][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h00000100: begin
                      PPN = TLB_mem[8][`PPN_end : `PPN_start];
                      LRU_addr = 5'd8;
                      if ( MPP == S) begin
                        if (TLB_mem[8][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[8][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h00000200: begin
                      PPN = TLB_mem[9][`PPN_end : `PPN_start];
                      LRU_addr = 5'd9;
                      if ( MPP == S) begin
                        if (TLB_mem[9][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[9][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h00000400: begin
                      PPN = TLB_mem[10][`PPN_end : `PPN_start];
                      LRU_addr = 5'd10;
                      if ( MPP == S) begin
                        if (TLB_mem[10][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[10][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h00000800: begin
                      PPN = TLB_mem[11][`PPN_end : `PPN_start];
                      LRU_addr = 5'd11;
                      if ( MPP == S) begin
                        if (TLB_mem[11][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[11][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h00001000: begin
                      PPN = TLB_mem[12][`PPN_end : `PPN_start];
                      LRU_addr = 5'd12;
                      if ( MPP == S) begin
                        if (TLB_mem[12][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[12][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h00002000: begin
                      PPN = TLB_mem[13][`PPN_end : `PPN_start];
                      LRU_addr = 5'd13;
                      if ( MPP == S) begin
                        if (TLB_mem[13][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[13][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h00004000: begin
                      PPN = TLB_mem[14][`PPN_end : `PPN_start];
                      LRU_addr = 5'd14;
                      if ( MPP == S) begin
                        if (TLB_mem[14][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[14][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h00008000: begin
                      PPN = TLB_mem[15][`PPN_end : `PPN_start];
                      LRU_addr = 5'd15;
                      if ( MPP == S) begin
                        if (TLB_mem[15][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[15][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h00010000: begin
                      PPN = TLB_mem[16][`PPN_end : `PPN_start];
                      LRU_addr = 5'd16;
                      if ( MPP == S) begin
                        if (TLB_mem[16][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[16][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h00020000: begin
                      PPN = TLB_mem[17][`PPN_end : `PPN_start];
                      LRU_addr = 5'd17;
                      if ( MPP == S) begin
                        if (TLB_mem[17][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[17][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h00040000: begin
                      PPN = TLB_mem[18][`PPN_end : `PPN_start];
                      LRU_addr = 5'd18;
                      if ( MPP == S) begin
                        if (TLB_mem[18][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[18][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h00080000: begin
                      PPN = TLB_mem[19][`PPN_end : `PPN_start];
                      LRU_addr = 5'd19;
                      if ( MPP == S) begin
                        if (TLB_mem[19][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[19][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h00100000: begin
                      PPN = TLB_mem[20][`PPN_end : `PPN_start];
                      LRU_addr = 5'd20;
                      if ( MPP == S) begin
                        if (TLB_mem[20][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[20][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h00200000: begin
                      PPN = TLB_mem[21][`PPN_end : `PPN_start];
                      LRU_addr = 5'd21;
                      if ( MPP == S) begin
                        if (TLB_mem[21][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[21][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h00400000: begin
                      PPN = TLB_mem[22][`PPN_end : `PPN_start];
                      LRU_addr = 5'd22;
                      if ( MPP == S) begin
                        if (TLB_mem[22][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[22][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h00800000: begin
                      PPN = TLB_mem[23][`PPN_end : `PPN_start];
                      LRU_addr = 5'd23;
                      if ( MPP == S) begin
                        if (TLB_mem[23][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[23][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h01000000: begin
                      PPN = TLB_mem[24][`PPN_end : `PPN_start];
                      LRU_addr = 5'd24;
                      if ( MPP == S) begin
                        if (TLB_mem[24][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[24][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h02000000: begin
                      PPN = TLB_mem[25][`PPN_end : `PPN_start];
                      LRU_addr = 5'd25;
                      if ( MPP == S) begin
                        if (TLB_mem[25][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[25][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h04000000: begin
                      PPN = TLB_mem[26][`PPN_end : `PPN_start];
                      LRU_addr = 5'd26;
                      if ( MPP == S) begin
                        if (TLB_mem[26][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[26][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h08000000: begin
                      PPN = TLB_mem[27][`PPN_end : `PPN_start];
                      LRU_addr = 5'd27;
                      if ( MPP == S) begin
                        if (TLB_mem[27][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[27][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h10000000: begin
                      PPN = TLB_mem[28][`PPN_end : `PPN_start];
                      LRU_addr = 5'd28;
                      if ( MPP == S) begin
                        if (TLB_mem[28][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[28][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h20000000: begin
                      PPN = TLB_mem[29][`PPN_end : `PPN_start];
                      LRU_addr = 5'd29;
                      if ( MPP == S) begin
                        if (TLB_mem[29][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[29][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h40000000: begin
                      PPN = TLB_mem[30][`PPN_end : `PPN_start];
                      LRU_addr = 5'd30;
                      if ( MPP == S) begin
                        if (TLB_mem[30][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[30][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        32'h80000000: begin
                      PPN = TLB_mem[31][`PPN_end : `PPN_start];
                      LRU_addr = 5'd31;
                      if ( MPP == S) begin
                        if (TLB_mem[31][U] ==1)
                            exception_mode = 1;
                        else
                            exception_mode = 0;
                      end
                      else if (MPP == User) begin
                         if (TLB_mem[31][U] ==1)
                            exception_mode = 0;
                        else
                            exception_mode = 1;
                      end
                      else // M mode all access
                        exception_mode = 0;
                      end
        default     : begin
                      PPN = 44'd0;
                      LRU_addr = 5'd0;
                      exception_mode = 0;
                      end
        endcase
end
//---------------------------------------TLB READ (1CLK LATENCY LIKE CACHE)------------------------------//
always @ (posedge clk) begin
    if (rst) begin
        PPN_tag <= 44'b0;
        TLB_hit <= 1'b0;
        LRU_addr_tlb <= 5'b0;
        exception <= 0;
     end
     else if (re) begin
        if ((SATP_mode== `SATP_MODE__BARE)||(MPP == M)) begin
            PPN_tag <= VPN;
            TLB_hit <= 1'b1;
            LRU_addr_tlb <= 0;
            exception <= 0;
        end
        else begin
            PPN_tag <= PPN;
            TLB_hit <= hit;
            LRU_addr_tlb <= LRU_addr;
            exception <= exception_mode;
        end
     end
//     else if (we) begin //saving an extra read
//        PPN_tag <= write_data[`PPN_end : `PPN_start];
//        TLB_hit <= 1'b1;
//        LRU_addr_tlb <= write_address;
//        exception <= exception_mode;
//     end
     else begin
        PPN_tag <= 44'b0;
        TLB_hit <= 1'b0;
        LRU_addr_tlb <= LRU_addr;
        exception <= exception_mode;
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
