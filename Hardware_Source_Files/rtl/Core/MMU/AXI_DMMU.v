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
`include "ISA_priv_defines.vh"

(* keep_hierarchy = "yes" *)
module AXI_DMMU
#(
    // Width of Address Bus
    parameter integer C_M_AXI_ADDR_WIDTH    = 64,
    // Width of Data Bus
    parameter integer C_M_AXI_DATA_WIDTH    = 64
)
(
    input  wire                             clk,
    input  wire                             rst,
    ///////////////////////////////////////////////////////////////////////////
    // Port 0 load
    input  wire                             port0_req_valid,
    input  wire [63:0]                      port0_req_vaddr,
    input  wire [2:0]                       port0_req_AccessType,
    input  wire                             port0_req_abort,
    //input port0_is_amo,
    output wire                             port0_resp_done,
    output wire                             port0_resp_ready,
    output wire [55:0]                      port0_resp_paddr,
    output wire                             port0_resp_exception,
    output wire [(`ECAUSE_LEN-1):0]         port0_resp_ecause,
    ///////////////////////////////////////////////////////////////////////////

    // Port 1 store
    input  wire                             port1_req_valid,
    input  wire [63:0]                      port1_req_vaddr,
    input  wire [2:0]                       port1_req_AccessType,
    input  wire                             port1_req_abort,
    output wire                             port1_resp_done,
    output wire                             port1_resp_ready,
    output wire [55:0]                      port1_resp_paddr,
    output wire                             port1_resp_exception,
    output wire [(`ECAUSE_LEN-1):0]         port1_resp_ecause,
    ////////////////////////////////////////////////////////////////////////////

    //information
    input  wire [63:0]                      csr_satp,
    input  wire [1:0]                       csr_status_priv,
    input  wire                             csr_status_mxr,
    input  wire                             csr_status_sum,
    //PMP Config & Addr from CSRs
    input  wire [(8*16)-1:0]                CSR_pmpcfg,     //Consolidated pmpcfg CSRs from CSR Module
    input  wire [(54*16)-1:0]               CSR_pmpaddr,    //Comsolidated pmpaddr CSRs from CSR Module
    input  wire                             en_translation,
    //////////////////////////////////////////////////////////////////////////////

    //controls
    input  wire                             PMA_Check_Enable,
    input  wire                             mmu_flush_req,
    output wire                             mmu_flush_resp_done,
    ///////////////////////////////////////////////////////////////////////////////
    //-------------------------DMMU t0 dcache PTW---------------------------------//
    output wire                             DCache_RdReq_DPTW_Valid,
    output wire [55:0]                      DCache_RdReq_DPTW_Paddr,
    output wire [`DATA_TYPE__LEN-1:0]       DCache_RdReq_DPTW_DataType,
    input wire [63:0]                       DCache_RdResp_DPTW_Data,
    input wire                              DCache_RdResp_DPTW_Done
);

    wire read_resp_error;

    wire [7:0] unconnected_0, unconnected_1, unconnected_2;
    assign DCache_RdReq_DPTW_DataType = `DATA_TYPE_D;

  DTLB_top DTLB_top
  (
        .clk(clk),
        .rst(rst),
        .port0_req_valid(port0_req_valid),
        .port0_req_vaddr(port0_req_vaddr),
        .port0_req_AccessType(port0_req_AccessType),
        .port0_req_abort(port0_req_abort),
        .port0_resp_done(port0_resp_done),
        .port0_resp_ready(port0_resp_ready),
        .port0_resp_paddr({unconnected_0,port0_resp_paddr}),
        .port0_resp_exception(port0_resp_exception),
        .port0_resp_ecause(port0_resp_ecause),

        .port1_req_valid(port1_req_valid),
        .port1_req_vaddr(port1_req_vaddr),
        .port1_req_AccessType(port1_req_AccessType),
        .port1_req_abort(port1_req_abort),
        .port1_resp_done(port1_resp_done),
        .port1_resp_ready(port1_resp_ready),
        .port1_resp_paddr({unconnected_1,port1_resp_paddr}),
        .port1_resp_exception(port1_resp_exception),
        .port1_resp_ecause(port1_resp_ecause),

        .csr_satp(csr_satp),
        .csr_status_priv(csr_status_priv),
        .csr_status_mxr(csr_status_mxr),
        .csr_status_sum(csr_status_sum),
        .en_translation(en_translation),
        .CSR_pmpcfg(CSR_pmpcfg),
        .CSR_pmpaddr(CSR_pmpaddr),

        .PMA_Check_Enable(PMA_Check_Enable),
        .mmu_flush_req(mmu_flush_req),
        .mmu_flush_resp_done(mmu_flush_resp_done),

        .write_data_axi(DCache_RdResp_DPTW_Data),
        .mem_ack(DCache_RdResp_DPTW_Done),
        .tlb_start_burst(DCache_RdReq_DPTW_Valid),
        .tlb_address({unconnected_2,DCache_RdReq_DPTW_Paddr})
    );


endmodule
