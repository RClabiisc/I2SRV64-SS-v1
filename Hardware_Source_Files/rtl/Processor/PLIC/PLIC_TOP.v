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

(* keep_hierarchy = "yes" *)
module PLIC
#(
    parameter integer C_S_AXI_DATA_WIDTH    = 32,
    parameter integer C_S_AXI_ADDR_WIDTH    = 32,
    parameter integer PRIORITY_LEVELS       = 32,
    parameter integer INTERRUPTS            = 8
)
(
    input  wire                                 clk,
    input  wire                                 rst,

    input  wire [31:0]                          global_interrupts,
    output wire [2:0]                           interrupt_notification,

    input  wire [C_S_AXI_ADDR_WIDTH-1:0]        S_AXI_AWADDR,
    input  wire [2:0]                           S_AXI_AWPROT,
    input  wire                                 S_AXI_AWVALID,
    output wire                                 S_AXI_AWREADY,
    input  wire [C_S_AXI_DATA_WIDTH-1:0]        S_AXI_WDATA,
    input  wire [(C_S_AXI_DATA_WIDTH/8)-1:0]    S_AXI_WSTRB,
    input  wire                                 S_AXI_WVALID,
    output wire                                 S_AXI_WREADY,
    output wire [1:0]                           S_AXI_BRESP,
    output wire                                 S_AXI_BVALID,
    input  wire                                 S_AXI_BREADY,
    input  wire [C_S_AXI_ADDR_WIDTH-1:0]        S_AXI_ARADDR,
    input  wire [2:0]                           S_AXI_ARPROT,
    input  wire                                 S_AXI_ARVALID,
    output wire                                 S_AXI_ARREADY,
    output wire [C_S_AXI_DATA_WIDTH-1:0]        S_AXI_RDATA,
    output wire [1:0]                           S_AXI_RRESP,
    output wire                                 S_AXI_RVALID,
    input  wire                                 S_AXI_RREADY
);

wire [31:0] interrupt_pending;
wire [2:0]  interrupt_completion_notif;
wire [31:0] interrupt_completion_ID;
wire [4:0]  interrupt_claim_ID;
wire [2:0]  interrupt_claim_notif;
wire [31:0] interrupt_active_0;
wire [31:0] interrupt_active_1;
wire [31:0] interrupt_active_2;

PLIC_Core
#(
    .PRIORITY_LEVELS(PRIORITY_LEVELS),
    .INTERRUPTS(INTERRUPTS)
)
PLIC
(
    .clk                        (clk                        ),
    .rst                        (rst                        ),
    .global_interrupts          (global_interrupts          ),

    .interrupt_completion_ID    (interrupt_completion_ID    ),
    .interrupt_completion_notif (interrupt_completion_notif ),
    .interrupt_claim_notif      (interrupt_claim_notif      ),
    .interrupt_claim_ID         (interrupt_claim_ID         ),
    .interrupt_active_0         (interrupt_active_0         ),
    .interrupt_active_1         (interrupt_active_1         ),
    .interrupt_active_2         (interrupt_active_2         ),
    .interrupt_pending_reg      (interrupt_pending          ),

    .interrupt_notification     (interrupt_notification     )
);


PLIC_SLAVE_v1_0_S00_AXI
#(
    .PRIORITY_LEVELS(PRIORITY_LEVELS),
    .INTERRUPTS(INTERRUPTS)
)
AXI_LITE_SLAVE_PLIC
(
    .interrupt_pending          (interrupt_pending          ),
    .interrupt_completion_notif (interrupt_completion_notif ),
    .interrupt_completion_ID    (interrupt_completion_ID    ),
    .interrupt_claim_ID         (interrupt_claim_ID         ),
    .interrupt_claim_notif      (interrupt_claim_notif      ),
    .interrupt_active_0         (interrupt_active_0         ),
    .interrupt_active_1         (interrupt_active_1         ),
    .interrupt_active_2         (interrupt_active_2         ),

    .S_AXI_ACLK                 (clk                        ),
    .S_AXI_ARESETN              (~rst                       ),
    .S_AXI_AWADDR               (S_AXI_AWADDR               ),
    .S_AXI_AWPROT               (S_AXI_AWPROT               ),
    .S_AXI_AWVALID              (S_AXI_AWVALID              ),
    .S_AXI_AWREADY              (S_AXI_AWREADY              ),
    .S_AXI_WDATA                (S_AXI_WDATA                ),
    .S_AXI_WSTRB                (S_AXI_WSTRB                ),
    .S_AXI_WVALID               (S_AXI_WVALID               ),
    .S_AXI_WREADY               (S_AXI_WREADY               ),
    .S_AXI_BRESP                (S_AXI_BRESP                ),
    .S_AXI_BVALID               (S_AXI_BVALID               ),
    .S_AXI_BREADY               (S_AXI_BREADY               ),
    .S_AXI_ARADDR               (S_AXI_ARADDR               ),
    .S_AXI_ARPROT               (S_AXI_ARPROT               ),
    .S_AXI_ARVALID              (S_AXI_ARVALID              ),
    .S_AXI_ARREADY              (S_AXI_ARREADY              ),
    .S_AXI_RDATA                (S_AXI_RDATA                ),
    .S_AXI_RRESP                (S_AXI_RRESP                ),
    .S_AXI_RVALID               (S_AXI_RVALID               ),
    .S_AXI_RREADY               (S_AXI_RREADY               )
);


endmodule

