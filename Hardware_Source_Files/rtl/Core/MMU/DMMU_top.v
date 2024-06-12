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

(* keep_hierarchy = "yes" *)
module DMMU
#(
    parameter DMMU_TYPE                           = "default",                //DMMU Type: "stub", "default"
    parameter MEM_TYPE                            = "xpm",                    //Memory Type: "rtl", "xip", "xpm"
    parameter integer C_M_AXI_DBUS_ADDR_WIDTH     = 64,
    parameter integer C_M_AXI_DBUS_DATA_WIDTH     = 64
)
(
    input  wire clk,
    input  wire rst,

    //DMMU Control Request/Response
    input  wire                                 DTLB_Enable,
    input  wire                                 PMA_Check_Enable,
    input  wire                                 DTLB_Flush_Req,
    input  wire [`SATP_ASID_LEN-1:0]            DTLB_Flush_Req_ASID,
    input  wire [`XLEN-1:0]                     DTLB_Flush_Req_Vaddr,
    output wire                                 DTLB_Flush_Done,

    //D-MMU Information Inputs
    input  wire [`PRIV_LVL__LEN-1:0]            csr_status_priv_lvl,    //Current Priv Level
    input  wire                                 csr_lsu_translateEn,    //Enable Translation for load/store operation
    input  wire                                 csr_status_sum,         //xstatus SUM field
    input  wire                                 csr_status_mxr,         //xstatus MXR field
    input  wire [`XLEN-1:0]                     csr_satp,               //satp csr
    input  wire [(16*8)-1:0]                    csr_pmpcfg_array,       //pmpcfg csr array in bus form
    input  wire [(16*54)-1:0]                   csr_pmpaddr_array,      //pmpaddr csr array in bus form


    //Request/Responses to MMU Port 0
    input  wire                                 MMU_Req0_Valid,
    input  wire [`MEM_ACCESS__LEN-1:0]          MMU_Req0_AccessType,
    input  wire                                 MMU_Req0_IsAtomic,
    input  wire [63:0]                          MMU_Req0_Vaddr,
    input  wire                                 MMU_Req0_Abort,

    output wire                                 MMU_Resp0_Done,
    output wire                                 MMU_Resp0_Ready,
    output wire [55:0]                          MMU_Resp0_Paddr,
    output wire                                 MMU_Resp0_Exception,
    output wire [`ECAUSE_LEN-1:0]               MMU_Resp0_ECause,

    //Request/Responses to MMU Port 1
    input  wire                                 MMU_Req1_Valid,
    input  wire [`MEM_ACCESS__LEN-1:0]          MMU_Req1_AccessType,
    input  wire                                 MMU_Req1_IsAtomic,
    input  wire [63:0]                          MMU_Req1_Vaddr,
    input  wire                                 MMU_Req1_Abort,

    output wire                                 MMU_Resp1_Done,
    output wire                                 MMU_Resp1_Ready,
    output wire [55:0]                          MMU_Resp1_Paddr,
    output wire                                 MMU_Resp1_Exception,
    output wire [`ECAUSE_LEN-1:0]               MMU_Resp1_ECause,

    output wire                                 DCache_RdReq_DPTW_Valid,
    output wire [55:0]                          DCache_RdReq_DPTW_Paddr,
    output wire [`DATA_TYPE__LEN-1:0]           DCache_RdReq_DPTW_DataType,
    input  wire [63:0]                          DCache_RdResp_DPTW_Data,
    input  wire                                 DCache_RdResp_DPTW_Done
);

generate
    if(DMMU_TYPE=="stub") begin: STUB
        //Emulating Vaddr=Paddr with PMA & PMP Check
        assign MMU_Resp0_Ready      = 1'b1;
        assign MMU_Resp0_Paddr      = MMU_Req0_Vaddr[55:0];
        assign MMU_Resp1_Ready      = 1'b1;
        assign MMU_Resp1_Paddr      = MMU_Req1_Vaddr[55:0];

        wire PMP_AccessAllowed0, PMP_AccessAllowed1, PMA_AccessAllowed1, PMA_AccessAllowed0;

        PMP #(.PMP_ENTRIES(`PMP_ENTRIES)) PMP1
        (
            .Paddr         (MMU_Resp0_Paddr     ),
            .Access_Type   (MMU_Req0_AccessType ),
            .Priv_Level    (csr_status_priv_lvl ),
            .CSR_pmpcfg    (csr_pmpcfg_array    ),
            .CSR_pmpaddr   (csr_pmpaddr_array   ),
            .AccessAllowed (PMP_AccessAllowed0  )
        );

        PMP #(.PMP_ENTRIES(`PMP_ENTRIES)) PMP2
        (
            .Paddr         (MMU_Resp1_Paddr     ),
            .Access_Type   (MMU_Req1_AccessType ),
            .Priv_Level    (csr_status_priv_lvl ),
            .CSR_pmpcfg    (csr_pmpcfg_array    ),
            .CSR_pmpaddr   (csr_pmpaddr_array   ),
            .AccessAllowed (PMP_AccessAllowed1  )
        );

        PMA #(.PORTS(2)) PMA
        (
            .Paddr_Bus          ({MMU_Resp1_Paddr,MMU_Resp0_Paddr}          ),
            .PMA_Check_Enable   (1'b1                                       ),
            .AccessType_Bus     ({MMU_Req1_AccessType,MMU_Req0_AccessType}  ),
            .AccessAllowed_Bus  ({PMA_AccessAllowed1, PMA_AccessAllowed0}   ),
            .PMA_Attributes_Bus ()
        );

        reg                     DTLB_Flush_Done_reg;
        reg                     MMU_Resp0_Done_reg, MMU_Resp1_Done_reg;
        reg                     MMU_Resp0_Exception_reg, MMU_Resp1_Exception_reg;
        reg [`ECAUSE_LEN-1:0]   MMU_Resp0_ECause_reg, MMU_Resp1_ECause_reg;

        always @(posedge clk) begin
            if(rst) begin
                MMU_Resp0_Done_reg      <= 0;
                MMU_Resp1_Done_reg      <= 0;
                DTLB_Flush_Done_reg     <= 0;
                MMU_Resp0_Exception_reg <= 0;
                MMU_Resp1_Exception_reg <= 0;
                MMU_Resp0_ECause_reg    <= 0;
                MMU_Resp1_ECause_reg    <= 0;
            end
            else begin
                MMU_Resp0_Done_reg      <= MMU_Req0_Valid;
                MMU_Resp1_Done_reg      <= MMU_Req1_Valid;
                DTLB_Flush_Done_reg     <= DTLB_Flush_Req;

                MMU_Resp0_Exception_reg <= MMU_Req0_Valid & (~PMP_AccessAllowed0 | ~PMA_AccessAllowed0);
                MMU_Resp0_ECause_reg    <= MMU_Req0_AccessType==`MEM_ACCESS_READ ? `EXC_LACCESS_FAULT : `EXC_SACCESS_FAULT;

                MMU_Resp1_Exception_reg <= MMU_Req1_Valid & (~PMP_AccessAllowed1 | ~PMA_AccessAllowed1);
                MMU_Resp1_ECause_reg    <= MMU_Req1_AccessType==`MEM_ACCESS_READ ? `EXC_LACCESS_FAULT : `EXC_SACCESS_FAULT;
            end
        end

        assign MMU_Resp0_Done      = MMU_Resp0_Done_reg;
        assign MMU_Resp1_Done      = MMU_Resp1_Done_reg;
        assign MMU_Resp0_Exception = MMU_Resp0_Exception_reg;
        assign MMU_Resp1_Exception = MMU_Resp1_Exception_reg;
        assign MMU_Resp0_ECause    = MMU_Resp0_ECause_reg;
        assign MMU_Resp1_ECause    = MMU_Resp1_ECause_reg;
        assign DTLB_Flush_Done     = DTLB_Flush_Done_reg;
    end
    else if(DMMU_TYPE=="default") begin: DMMU
        AXI_DMMU
        #(
            .C_M_AXI_ADDR_WIDTH         (C_M_AXI_DBUS_ADDR_WIDTH             ),
            .C_M_AXI_DATA_WIDTH         (C_M_AXI_DBUS_DATA_WIDTH             )
        )
        AXI_DMMU
        (
            .clk                    (clk                        ),
            .rst                    (rst                        ),

            .port0_req_valid        (MMU_Req0_Valid             ),
            .port0_req_vaddr        (MMU_Req0_Vaddr             ),
            .port0_req_AccessType   (MMU_Req0_AccessType        ),
            .port0_req_abort        (MMU_Req0_Abort             ),
            .port0_resp_done        (MMU_Resp0_Done             ),
            .port0_resp_ready       (MMU_Resp0_Ready            ),
            .port0_resp_paddr       (MMU_Resp0_Paddr            ),
            .port0_resp_exception   (MMU_Resp0_Exception        ),
            .port0_resp_ecause      (MMU_Resp0_ECause           ),

            .port1_req_valid        (MMU_Req1_Valid             ),
            .port1_req_vaddr        (MMU_Req1_Vaddr             ),
            .port1_req_AccessType   (MMU_Req1_AccessType        ),
            .port1_req_abort        (MMU_Req1_Abort             ),
            .port1_resp_done        (MMU_Resp1_Done             ),
            .port1_resp_ready       (MMU_Resp1_Ready            ),
            .port1_resp_paddr       (MMU_Resp1_Paddr            ),
            .port1_resp_exception   (MMU_Resp1_Exception        ),
            .port1_resp_ecause      (MMU_Resp1_ECause           ),

            .csr_satp               (csr_satp                   ),
            .csr_status_priv        (csr_status_priv_lvl        ),
            .csr_status_mxr         (csr_status_mxr             ),
            .csr_status_sum         (csr_status_sum             ),
            .CSR_pmpcfg             (csr_pmpcfg_array           ),
            .CSR_pmpaddr            (csr_pmpaddr_array          ),
            .en_translation         (csr_lsu_translateEn        ),

            .PMA_Check_Enable       (PMA_Check_Enable           ),
            .mmu_flush_req          (DTLB_Flush_Req             ),
            .mmu_flush_resp_done    (DTLB_Flush_Done            ),

            .DCache_RdReq_DPTW_Valid    (DCache_RdReq_DPTW_Valid   ),
            .DCache_RdReq_DPTW_Paddr    (DCache_RdReq_DPTW_Paddr   ),
            .DCache_RdReq_DPTW_DataType (DCache_RdReq_DPTW_DataType),
            .DCache_RdResp_DPTW_Data    (DCache_RdResp_DPTW_Data   ),
            .DCache_RdResp_DPTW_Done    (DCache_RdResp_DPTW_Done   )
        );
    end
endgenerate


`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;

    `ifdef DEBUG_MMU
        always @(negedge clk) begin
            if(MMU_Resp0_Done && MMU_Req0_Valid) begin
                $display("[%t] DMMU__@REQ0 : Vaddr=%h Paddr=%h | Ec=%d", $time,
                    MMU_Req0_Vaddr, MMU_Resp0_Paddr, (MMU_Resp0_Exception ? MMU_Resp0_ECause : 1'bx)
                );
            end
            if(MMU_Resp1_Done && MMU_Req1_Valid) begin
                $display("[%t] DMMU__@REQ1 : Vaddr=%h Paddr=%h | Ec=%d", $time,
                    MMU_Req1_Vaddr, MMU_Resp1_Paddr, (MMU_Resp1_Exception ? MMU_Resp1_ECause : 1'bx)
                );
            end
        end
    `endif
`endif


endmodule

