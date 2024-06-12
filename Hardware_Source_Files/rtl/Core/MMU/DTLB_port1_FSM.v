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
module DTLB_port1_FSM(

    // from port1 FSM
    input  wire port0_busy,
    input  wire port0_start, // when port0 in state S0 and tx starting. This is basically for when both ports miss at the same time, but port1 allowed to take over axi.
    // So when port0 wants to start and port0 not busy, port1 will take over and port0 will wait.
    output reg  port1_busy,
    input  wire port1_req_abort,

    input  wire clk,
    input  wire rst,

    // Port 1
    input  wire port1_req_valid,
    input  wire [63:0] port1_req_vaddr,
    output reg  port1_resp_done,
    output reg  port1_resp_exception,
    output reg  [(`ECAUSE_LEN-1):0]port1_resp_ecause,

    //information
    input  wire [63:0] csr_satp,
    input  wire [1:0]                   csr_status_priv,
    //controls
    input  wire mmu_flush_req,
    output reg  mmu_flush_resp_done,

    input  wire [63:0] write_data_axi, // during replacement
    input  wire mem_ack,                 // during replacement
    input  wire tlb_hit_2,
    output reg  tlb_start_burst_port1,
    output reg  [63 : 0]tlb_address,
    output wire [`TLB_WIDTH-1:0]write_data_tlb,
    output wire Port1access,
    output reg  re_2,
    output reg  we,
    input  wire port1_exception,
    input  wire port1_AccessAllowed_PMP,
    input  wire port1_AccessAllowed_PMA,
    output reg  port1_resp_ready,
    input  wire [3:0]SATP_mode,
    input  wire en_translation,
    output reg bare_mode_en2
);

parameter page_number_start = 12;
parameter page_number_end = 38;
parameter V = 0;
parameter R = 1;
parameter W = 2;
parameter X = 3;
parameter U = 4;
parameter A = 6;
parameter D = 7;
parameter M = 2'b11; //M-mode
parameter S = 2'b01; //S-mode
parameter User = 2'b00;  //U-mode
localparam S0 = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;

reg [2:0] prstate;
reg [2:0] nxstate;
parameter i=`ICACHE_LINE_LEN;//256

reg [1:0] count;
reg [`PPN_end - `PPN_start:0]tlb_ppn;
reg [63 : 0] write_data;
reg port1_req_abort_reg;
//----------------------------------------------------FSM---------------------------------------------------------//

always @ (posedge clk) begin
    if (rst) begin
        prstate <= S0;
    end
    else begin
        prstate <= nxstate;
    end
end

always @ (*) begin
    port1_resp_exception = 1'b0;
            tlb_ppn = write_data[`PPN_end:`PPN_start];
            port1_resp_done = 0;
            re_2 = 1'b0;
            we = 1'b0;
            tlb_start_burst_port1 = 1'b0;
            mmu_flush_resp_done = 0;
            port1_busy = 0;
            port1_resp_ecause = `EXC_SPAGE_FAULT;
            port1_resp_ready = 0;
            bare_mode_en2 = 0;
    case (prstate)
        S0: begin
            port1_resp_ready = 1;
            if (mmu_flush_req) begin
                nxstate  = S4;
            end
            else if (port1_req_valid & !port1_req_abort & (!port0_busy)) begin
                if ((SATP_mode == `SATP_MODE__BARE) | (!en_translation)) begin
                    port1_resp_done = 1;
                    bare_mode_en2 = 1;
                    //re_1 = 1'b0;
                    nxstate = S0;
                    if ((!port1_AccessAllowed_PMP) | (!port1_AccessAllowed_PMA)) begin
                        port1_resp_exception = 1'b1;
                        port1_resp_ecause = `EXC_SACCESS_FAULT;
                    end
                end
                else begin
                    re_2 = 1'b1;
                    nxstate = S1;
                end
            end
            else begin
                nxstate = S0;
            end
            end
        S1: begin
            port1_busy = 1;
            if (mmu_flush_req) begin
                nxstate  = S4;
            end
            else if (port1_req_valid & !port1_req_abort) begin
                if(~SV39_Compatible)begin
                    port1_resp_done=1'b1;
                    port1_resp_exception = 1'b1;
                    nxstate  = S0;
                    port1_resp_ecause = `EXC_SPAGE_FAULT;
                end else if (!tlb_hit_2) begin
                    if (port0_start | (!port0_busy)) begin
                        tlb_start_burst_port1 = 1'b1;
                        nxstate  = S2;
                    end
                    else begin
                        nxstate  = S0;
                    end
                end
                else begin //if hit
                   port1_resp_done = 1;
                   if (port1_exception) begin
                        nxstate  = S0;
                        port1_resp_exception = 1'b1;
                        port1_resp_ecause = `EXC_SPAGE_FAULT;
                    end
                    else if ((!port1_AccessAllowed_PMP) | (!port1_AccessAllowed_PMA)) begin
                        nxstate  = S0;
                        port1_resp_exception = 1'b1;
                        port1_resp_ecause = `EXC_SACCESS_FAULT;
                    end
                    else begin
                        nxstate  = S0;
                    end
                 end
            end
            else begin
                nxstate = S0;

            end
            end
        S2: begin
            port1_busy = 1'b1;
            if (mem_ack) begin
                if (mmu_flush_req) begin
                    nxstate = S4;
                end
                else if (port1_req_abort_reg) begin
                    nxstate = S0;
                end
                else begin
                    nxstate = S3;
                end
            end
            else begin
                nxstate = S2;
            end
            end
        S3: begin
            port1_busy = 1;
            // data has come check for leaf entry and exceptions
            // ------------------------------PMA and PMP exceptions check will come here-------------
             if (mmu_flush_req) begin
                nxstate = S4;
             end
             else if (port1_req_abort) begin
                nxstate = S0;
             end
             else begin
             mmu_flush_resp_done = 0;
             if (write_data[V]==0 || (write_data[R]==0 & write_data[W]==1)) begin
                port1_resp_exception = 1'b1;
                port1_resp_done = 1;
                nxstate = S0;
            end
            else begin //PTE is valid
                if (write_data[R]==1 || write_data[X]==1) begin //leaf PTE is found
                    if ((count==2'd2 && write_data[27:10]!=0) || (count==2'd1 && write_data[18:10]!=0)) begin
                    // it is a misaligned superpage
                        port1_resp_exception = 1'b1;
                        port1_resp_done = 1;
                        nxstate = S0;
                    end
                    else begin
                        if (write_data[A]==0) begin
                            port1_resp_exception = 1'b1;
                            port1_resp_done = 1;
                            nxstate = S0;
                        end
                        else begin
                        //-----TRANSLATION IS SUCCESSFULL---//
                            we = 1'b1;
                            nxstate = S0;
                            if (count==2'd2)
                                tlb_ppn = {write_data[53:28],port1_req_vaddr[29:12]};
                            else if (count==2'd1)
                                tlb_ppn = {write_data[53:19],port1_req_vaddr[20:12]};
                            else
                                tlb_ppn = write_data[`PPN_end:`PPN_start];
                        end
                    end
                end
                else begin //this PTE is pointer to next level of page table
                        if (count == 2'd0) begin
                            port1_resp_exception = 1'b1;
                            port1_resp_done = 1;
                            nxstate = S0;
                        end
                        else begin //fetch the next level PTE
                            nxstate  = S2;
                            tlb_start_burst_port1 = 1'b1;
                        end
                end
            end
            end
            end
        S4: begin
            nxstate = S0;
            mmu_flush_resp_done = 1;
            port1_busy = 1;
            end
   default: begin
            nxstate = S0;
            end
    endcase
 end

//----------------------------------------PAGE TABLE ADDRESS------------------------------------------//
 always @ (*) begin
    if (rst)
        tlb_address <= 64'd0;
    else begin
        if (count == 2'd3)
            tlb_address <= {8'b0,csr_satp[43:0],`PAGESIZE'b0}+{52'b0,port1_req_vaddr[38:30],`PTESIZE'b0};
        else if (count == 2'd2)
            tlb_address <= {8'b0,write_data[53:10],`PAGESIZE'b0}+{52'b0,port1_req_vaddr[29:21],`PTESIZE'b0};
        else
            tlb_address <= {8'b0,write_data[53:10],`PAGESIZE'b0}+{52'b0,port1_req_vaddr[20:12],`PTESIZE'b0};
   end
 end

 always @ (posedge clk) begin
    if (rst || (nxstate == S0))
        count <= 2'd3;
    else if(mem_ack)
        count <= count - 1;
 end
//-----------------------------------Latch the write data----------------------------------------------------//

  always @ (posedge clk) begin
    if (rst)
        write_data <= 64'b0;
    else if(mem_ack)
        write_data <= write_data_axi;
 end

    always @ (posedge clk) begin
    if (rst || (nxstate == S0))
        port1_req_abort_reg <= 1'b0;
    else if (port1_req_abort)
        port1_req_abort_reg <= 1'b1;
 end

//--------------------------------------------------LRU signals------------------------------------------//
// always @ (*) begin
//    if (rst) begin
//        Readaccess = 1'b0;
//        end
//    else begin
//        if (icache_hit) begin //check this once again
//            Readaccess = 1'b1;
//        end
//        else begin
//            Readaccess = 1'b0;
//        end
//     end
//end
assign Port1access = port1_resp_done;

assign write_data_tlb = {port1_req_vaddr[page_number_end:page_number_start],10'b0,tlb_ppn,write_data[`PPN_start-1:0]};

//NOTE: we have to write in TLB as soon as we get the ready and valid high. We cannot latch data in the next clock pulse as write_data becomes invalid.
//---------------------------------------------------------------------------------------------------------------//
reg SV39_Compatible;
always @(*)
begin 
   SV39_Compatible =1'b1;
   if((csr_satp[`SATP_MODE_RANGE]== `SATP_MODE__BARE) || csr_status_priv== M) begin 
                SV39_Compatible =1'b1; // as sv39 virtual memory is not enabled checking of address not required.
   end else if (port1_req_vaddr[38]==1'b1) begin 
                SV39_Compatible =&port1_req_vaddr[63:39]; //all bits 39-63 should be 1 in this 
   end else if (port1_req_vaddr[38]==1'b0) begin 
                SV39_Compatible = !(|port1_req_vaddr[63:39]); // all bits 39-63 should be 0 in this case
   end 
end 

endmodule
