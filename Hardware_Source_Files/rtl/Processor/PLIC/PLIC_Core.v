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
module PLIC_Core
#(
    parameter INTERRUPTS   = 8,
    parameter PRIORITY_LEVELS = 32
)
(
    input wire clk,
    input wire rst,
    input wire [31:0]global_interrupts,         //GATEWAY, INPUTS

    // To axi slave MODULE signals
    input wire [31:0]interrupt_completion_ID,   //GATEWAY, AXI
    input wire [2:0]interrupt_completion_notif, //GATEWAY, AXI
    input wire [2:0]interrupt_claim_notif,      //AXI
    input wire [4:0]interrupt_claim_ID,         //AXI
    input wire [31:0] interrupt_active_0,       //AXI
    input wire [31:0] interrupt_active_1,       //AXI
    input wire [31:0] interrupt_active_2,       //AXI
    output reg [31:0] interrupt_pending_reg,    //AXI

    // TO core
    output wire [2:0]interrupt_notification               //CORE
    //If the target is a RISC-V hart context, the
    //interrupt notifications arrive on the meip/seip/ueip bits depending on the privilege level of the
    //hart context.
        );

    wire [31:0]interrupt_request;
    reg [2:0]EIP;
//    reg [4:0]interrupt_ID;
//    wire [31:0] interrupt_active;

//    genvar j;
//    generate
//    for(j=0; j<32;j=j+1)
//        begin
//            assign interrupt_active[j] = interrupt_enable[j/32][j % 32] & interrupt_pending[j/32][j % 32] & (interrupt_priority[j]>interrupt_threshold);
//        end
//    endgenerate

//    ///////////////////////////////////////////////////////////////////////////////////////////////
//    //find largest priority
//    integer i;
//    // For same priorirty, smallest ID wins, hence we loop from largest to smallest ID
//    always @ (*) begin
//        interrupt_ID = 0;
//        for (i=31; i>=0 ; i=i-1)
//            begin
//                if (interrupt_active[i] & interrupt_priority [i]>= interrupt_ID)
//                    interrupt_ID = i+1;
//            end
//    end

    //----------------------INTERRUPT PENDING REGISTER------------------------//
    integer k;
    always @ (posedge clk) begin
        interrupt_pending_reg[0] <= 0;
        for (k=1; k<32; k=k+1) begin
            if (rst || ((|interrupt_claim_notif) & (interrupt_claim_ID==k))) begin
                interrupt_pending_reg[k] <= 0;
            end
            else if (interrupt_request[k-1] & k<=INTERRUPTS) begin
                interrupt_pending_reg[k] <= 1'b1;
            end
        end
    end

//    always @ (posedge clk) begin
//    if (rst | interrupt_completion_notif)
//        EIP <= 0;
//    else if (|interrupt_active)
//        EIP <= 1;
//    end

   // assign interrupt_notification = !EIP && (|interrupt_active); // will be high for only 1 cycle
   // making this delay by 1 cycle, so that if the last completed interrupt (highest prioriy it was) is still high, it is updated in the ID field(takes 1 more cycle).
   // So, correct updated ID is sent.
   // So, correct updated ID is sent.
    always @ (posedge clk) begin
    if (rst)
        EIP[0] <= 0;
    else if (|interrupt_active_0)
        EIP[0] <= 1;
    else
        EIP[0] <= 0;
    end
    always @ (posedge clk) begin
    if (rst)
        EIP[1] <= 0;
    else if (|interrupt_active_1)
        EIP[1] <= 1;
    else
        EIP[1] <= 0;
    end
    always @ (posedge clk) begin
    if (rst)
        EIP[2] <= 0;
    else if (|interrupt_active_2)
        EIP[2] <= 1;
    else
        EIP[2] <= 0;
    end

    assign interrupt_notification = EIP;

    PLIC_Gateway
    #(
        .PRIORITY_LEVELS(PRIORITY_LEVELS),
        .INTERRUPTS(INTERRUPTS)
    )
    GATEWAY
    (
     .clk(clk),
     .rst(rst),
     .global_interrupts(global_interrupts),
     .interrupt_completion_ID(interrupt_completion_ID), //contains the ID
     .interrupt_completion_notif(|interrupt_completion_notif),
     .interrupt_request(interrupt_request)
    );

endmodule
