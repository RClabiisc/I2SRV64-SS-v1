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

(* keep_hierarchy = "yes" *)
module level2pulse
#(
    parameter EDGE                          = "posedge",    //"posedge", "negedge" , "both"
    parameter integer PULSE_ACTIVE_POLARITY = 1,    //1=> Active High Polarity of Output Pulse, 0=> Active High
    parameter integer SYNC                  = 1     //Pulse sync w.r.t clock (latency increases by 1 clk)
)
(
    input  wire clk,
    input  wire rst,

    input  wire level_in,
    output wire pulse_out
);

reg level_q;
always @(posedge clk) begin
    if(rst) begin
        if(EDGE=="posedge")
            level_q <= 1'b1;
        else if(EDGE=="negedge")
            level_q <= 1'b0;
        else
            level_q <= 1'b0;
    end
    else
        level_q <= level_in;
end

generate
    reg level_q_q;
    if(SYNC>0) begin
        always @(posedge clk) begin
            if(rst) begin
                if(EDGE=="posedge")
                    level_q_q <= 1'b1;
                else if(EDGE=="negedge")
                    level_q_q <= 1'b0;
                else
                    level_q_q <= 1'b0;
            end
            else
                level_q_q <= level_q;
        end
    end
endgenerate


generate
    //generate active high pulse
    wire pulse;
    if(SYNC>0) begin
        if(EDGE=="posedge") begin
            assign pulse = ~level_q_q & level_q;
        end
        else if(EDGE=="negedge") begin
            assign pulse = level_q_q & ~level_q;
        end
        else if(EDGE=="both") begin
            assign pulse = level_q_q ^ level_q;
        end
        else begin
            assign pulse = 1'b0;
        end
    end
    else begin
        if(EDGE=="posedge") begin
            assign pulse = ~level_q & level_in;
        end
        else if(EDGE=="negedge") begin
            assign pulse = level_q & ~level_in;
        end
        else if(EDGE=="both") begin
            assign pulse = level_q ^ level_in;
        end
        else begin
            assign pulse = 1'b0;
        end
    end

    //convert according to output polarity
    if(PULSE_ACTIVE_POLARITY==0) begin
        assign pulse_out = ~pulse;
    end
    else begin
        assign pulse_out = pulse;
    end
endgenerate

endmodule

