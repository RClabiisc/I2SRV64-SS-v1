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
module PLIC_Gateway
#(
    parameter PRIORITY_LEVELS = 32,
    parameter INTERRUPTS   = 8
)
(
    // Core signals
    input wire clk,
    input wire rst,
    input wire [31:0]global_interrupts,
    input wire [31:0]interrupt_completion_ID, //contains the ID
    input wire interrupt_completion_notif,
    output wire [31:0]interrupt_request
    );

    reg [31:0]interrupt_state;
    integer i;
    wire [4:0]ID;

    assign ID = interrupt_completion_ID[4:0];//  LSB bits

    // When this latch = 0, only then the gateway will forward request to PLIC, else
    always @ (posedge clk) begin
        for (i=0; i<32; i=i+1)
        begin
            if (rst || (interrupt_completion_notif & i==(ID-1))) // if interrupt completed, then again reset this. Now we can again send this request.
                interrupt_state[i] <= 0;
            else if (global_interrupts[i] && i<INTERRUPTS)
                interrupt_state[i] <= 1;  // when a request comes for the first time, this latches, so that from next time, we wait for completion signal before sending request to core
        end
    end

    // When first time request comes, we send request once. The latch is also inititally zero.
    // From next time, we check the latch, if zero, means completed, we can send request again.
    genvar j;
    generate
    for(j=0; j<32;j=j+1)
        begin
            assign interrupt_request[j] = !interrupt_state[j] & global_interrupts[j] & (j<INTERRUPTS); //make sure PLIC latches immediately, otherwise, in case of first request, the interrupt_state latch becomes 1.
        end
    endgenerate

endmodule
