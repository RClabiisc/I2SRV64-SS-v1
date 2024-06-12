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
module DTLB_top
(
    input  wire                         clk,
    input  wire                         rst,
    ///////////////////////////////////////////////////////////////////////////
    // Port 0 load
    input  wire                         port0_req_valid,
    input  wire [63:0]                  port0_req_vaddr,
    input  wire [2:0]                   port0_req_AccessType,
    input  wire                         port0_req_abort,
    output wire                         port0_resp_done,
    output wire                         port0_resp_ready,
    output wire [63:0]                  port0_resp_paddr,
    output wire                         port0_resp_exception,
    output wire [(`ECAUSE_LEN-1):0]     port0_resp_ecause,
    ///////////////////////////////////////////////////////////////////////////

    // Port 1 store
    input  wire                         port1_req_valid,
    input  wire [63:0]                  port1_req_vaddr,
    input  wire [2:0]                   port1_req_AccessType,
    input  wire                         port1_req_abort,
    output wire                         port1_resp_done,
    output wire                         port1_resp_ready,
    output wire [63:0]                  port1_resp_paddr,
    output wire                         port1_resp_exception,
    output wire [(`ECAUSE_LEN-1):0]     port1_resp_ecause,
    ////////////////////////////////////////////////////////////////////////////

    //information
    input  wire [63:0]                  csr_satp,
    input  wire [1:0]                   csr_status_priv,
    input  wire                         csr_status_mxr,
    input  wire                         csr_status_sum,
    //PMP Config & Addr from CSRs
    input  wire [(8*16)-1:0]            CSR_pmpcfg,     //Consolidated pmpcfg CSRs from CSR Module
    input  wire [(54*16)-1:0]           CSR_pmpaddr,    //Comsolidated pmpaddr CSRs from CSR Module
    input  wire                         en_translation,
    //////////////////////////////////////////////////////////////////////////////

    //controls
    input  wire                         PMA_Check_Enable,
    input  wire                         mmu_flush_req,
    output wire                         mmu_flush_resp_done,
    ///////////////////////////////////////////////////////////////////////////////

    input  wire [63:0]                  write_data_axi,
    input  wire                         mem_ack,
    output wire                         tlb_start_burst,
    output wire [63 : 0]                tlb_address
);

parameter i=`ICACHE_LINE_LEN;//256
parameter page_number_start = 12;
parameter page_number_end = 38;
parameter M = `PRIV_LVL_M; //M-mode

wire re_1,re_2;
wire we1,we2,we;
wire Port0access, Port1access, port0_exception, port1_exception;
wire mmu_flush_resp_done_0, mmu_flush_resp_done_1;
wire tlb_hit_1, tlb_hit_2, hit1, hit2;
wire [4:0]LRU_addr_1;
wire [4:0]LRU_addr_2;
wire [4:0]LRU_replace;
wire [`TLB_WIDTH-1:0]write_data_tlb, write_data_tlb_port0, write_data_tlb_port1;
wire [63 : 0] write_data;
wire [63 : 0]tlb_address_port0, tlb_address_port1;

wire tlb_start_burst_port0;
wire tlb_start_burst_port1;
wire port0_busy, port1_busy, port0_start;
wire bare_mode_en1, bare_mode_en2;

wire port0_AccessAllowed_PMP, port1_AccessAllowed_PMP, port0_AccessAllowed_PMA, port1_AccessAllowed_PMA;
assign tlb_start_burst = tlb_start_burst_port0 | tlb_start_burst_port1;
assign write_data_tlb = port1_busy ? write_data_tlb_port1 : write_data_tlb_port0;
assign mmu_flush_resp_done = port1_busy ? mmu_flush_resp_done_1 : mmu_flush_resp_done_0;
assign tlb_address =  (port0_busy | tlb_start_burst_port0)? tlb_address_port0 : tlb_address_port1;

//NOTE: we have to write in TLB as soon as we get the ready and valid high. We cannot latch data in the next clock pulse as write_data becomes invalid.
//---------------------------------------------------------------------------------------------------------------//
DTLB_port0_FSM port0_FSM(

    .port1_busy(port1_busy),
    .port0_start(port0_start),
    .port0_busy(port0_busy),
    .clk(clk),
    .rst(rst),
    .port0_req_valid(port0_req_valid),
    .port0_req_vaddr(port0_req_vaddr),
    .port0_resp_done(port0_resp_done),
    .port0_resp_exception(port0_resp_exception),
    .port0_resp_ecause(port0_resp_ecause),
    .csr_satp(csr_satp),
    .csr_status_priv(csr_status_priv),
    .mmu_flush_req(mmu_flush_req),
    .mmu_flush_resp_done(mmu_flush_resp_done_0),
    .write_data_axi(write_data_axi), // during replacement
    .mem_ack(mem_ack),                 // during replacement
    .tlb_hit_1(tlb_hit_1),
    .tlb_start_burst_port0(tlb_start_burst_port0),
    .tlb_address(tlb_address_port0),
    .write_data_tlb(write_data_tlb_port0),
    .Port0access(Port0access),
    .re_1(re_1),
    .we(we1),
    .port0_exception(port0_exception),
    .port0_AccessAllowed_PMP(port0_AccessAllowed_PMP),
    .port0_AccessAllowed_PMA(port0_AccessAllowed_PMA),
    .port0_resp_ready(port0_resp_ready),
    .port0_req_abort(port0_req_abort),
    .SATP_mode(csr_satp[`SATP_MODE_RANGE]),
    .en_translation(en_translation),
    .bare_mode_en1(bare_mode_en1)
    );

DTLB_port1_FSM port1_FSM(

    .port0_busy(port0_busy),
    .port0_start(port0_start),
    .port1_busy(port1_busy),
    .clk(clk),
    .rst(rst),
    .port1_req_valid(port1_req_valid),
    .port1_req_vaddr(port1_req_vaddr),
    .port1_resp_done(port1_resp_done),
    .port1_resp_exception(port1_resp_exception),
    .port1_resp_ecause(port1_resp_ecause),
    .csr_satp(csr_satp),
    .csr_status_priv(csr_status_priv),
    .mmu_flush_req(mmu_flush_req),
    .mmu_flush_resp_done(mmu_flush_resp_done_1),
    .write_data_axi(write_data_axi), // during replacement
    .mem_ack(mem_ack),                 // during replacement
    .tlb_hit_2(tlb_hit_2),
    .tlb_start_burst_port1(tlb_start_burst_port1),
    .tlb_address(tlb_address_port1),
    .write_data_tlb(write_data_tlb_port1),
    .Port1access(Port1access),
    .re_2(re_2),
    .we(we2),
    .port1_exception(port1_exception),
    .port1_AccessAllowed_PMP(port1_AccessAllowed_PMP),
    .port1_AccessAllowed_PMA(port1_AccessAllowed_PMA),
    .port1_resp_ready(port1_resp_ready),
    .port1_req_abort(port1_req_abort),
    .SATP_mode(csr_satp[`SATP_MODE_RANGE]),
    .en_translation(en_translation),
    .bare_mode_en2(bare_mode_en2)
    );



PLRU32_TLB PLRU_DTLB
(
    .clk(clk),
    .rst(rst),
    .UpdateEn(csr_satp[`SATP_MODE_RANGE]==`SATP_MODE__BARE ? 1'b0 : 1'b1),
    .ReadWay(LRU_addr_1),
    .ReadAccess(Port0access),
    .WriteWay(LRU_addr_2),
    .WriteAccess(Port1access),
    .LRU_Way(LRU_replace)
);

dTLB tlb_memory(
    .clk(clk),
    .rst(rst),
    .VPN_1(port0_req_vaddr),
    .VPN_2(port1_req_vaddr),
    .re_1(re_1),
    .re_2(re_2),
    .we(port1_busy ? we2 : we1),
    .write_data(write_data_tlb),
    .write_address(LRU_replace),
    .csr_status_mxr(csr_status_mxr),
    .csr_status_sum(csr_status_sum),
    .csr_status_priv(csr_status_priv),
    .physical_address_1(port0_resp_paddr),
    .physical_address_2(port1_resp_paddr),
    .TLB_hit_1(tlb_hit_1),
    .TLB_hit_2(tlb_hit_2),
//    .hit1(hit1),
//    .hit2(hit2),
    .LRU_addr_tlb_1(LRU_addr_1),
    .LRU_addr_tlb_2(LRU_addr_2),
    .mmu_flush_req(mmu_flush_req),
    .port0_exception_reg(port0_exception),
    .port1_exception_reg(port1_exception),
    .bare_mode_en1(bare_mode_en1),
    .bare_mode_en2(bare_mode_en2)
    );



    
   PMP #() 
   port0_PMP(
    .Paddr(port0_resp_paddr[55:0]),
    .Access_Type(port0_req_AccessType),
    .Priv_Level(csr_status_priv),
    .CSR_pmpcfg(CSR_pmpcfg),
    .CSR_pmpaddr(CSR_pmpaddr),
    .AccessAllowed(port0_AccessAllowed_PMP)
  );

    PMP #() 
    port1_PMP(
    .Paddr(port1_resp_paddr[55:0]),
    .Access_Type(port1_req_AccessType),
    .Priv_Level(csr_status_priv),
    .CSR_pmpcfg(CSR_pmpcfg),
    .CSR_pmpaddr(CSR_pmpaddr),
    .AccessAllowed(port1_AccessAllowed_PMP)
  );

  PMA #(.PORTS(2)) DMMU_PMA
 (
   .Paddr_Bus({port1_resp_paddr,port0_resp_paddr}),
   .PMA_Check_Enable(PMA_Check_Enable),
   .AccessType_Bus({port1_req_AccessType,port0_req_AccessType}),
   .AccessAllowed_Bus({port1_AccessAllowed_PMA, port0_AccessAllowed_PMA}),
   .PMA_Attributes_Bus()
);
endmodule
