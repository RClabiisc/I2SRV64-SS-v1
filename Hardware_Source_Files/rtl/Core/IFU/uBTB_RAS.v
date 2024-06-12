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
module RAS
#(
    parameter DEPTH       = `RAS_DEPTH,
    parameter MEM_TYPE    = "xpm"               // "rtl", "xip", "xpm"
)
(
    input  wire                 clk,        //clk
    input  wire                 rst,        //rst
    input  wire                 Stall,      //1=>stall everything (do not update anything)

    input  wire                 PushEn,     //1=>Push Enable
    input  wire [`XLEN-1:0]     PushData,   //Data to be pushed

    input  wire                 PopEn,      //1=>Pop Enable

    output wire [`XLEN-1:0]     PeekData,   //Peek Data (Data pointed by stack top) (invalid when RAS is empty)
    output reg                  RASempty    //1=>RAS is empty
);

//RAS Pointers
reg  [$clog2(DEPTH)-1:0] TOS, TOS_next;
reg  [$clog2(DEPTH)-1:0] BOS, BOS_next;
wire [$clog2(DEPTH)-1:0] WritePtr = TOS+1;


//RAS Memory instantiation
localparam MEM_DEPTH = DEPTH;
localparam MEM_WIDTH = `XLEN;
generate
    if(MEM_TYPE=="rtl") begin:RTL
        simple_dpram #(.WIDTH(MEM_WIDTH), .DEPTH(MEM_DEPTH), .SYNC_READ(0)) RAS_mem
        (
            .clk        (clk       ),
            .rst        (rst       ),
            .port0_din  (PushData  ),
            .port0_we   (PushEn    ),
            .port0_addr (WritePtr  ),
            .port1_en   (1'b1      ),
            .port1_addr (TOS       ),
            .port1_dout (PeekData  )
        );
    end
    else if(MEM_TYPE=="xip") begin:dist
        RAS_dmem_32x64b RAS_mem
        (
            .a    ( WritePtr ) , // input wire [4 : 0] a
            .d    ( PushData ) , // input wire [63 : 0] d
            .dpra ( TOS      ) , // input wire [4 : 0] dpra
            .clk  ( clk      ) , // input wire clk
            .we   ( PushEn   ) , // input wire we
            .dpo  ( PeekData )   // output wire [63 : 0] dpo
        );
    end
    else if(MEM_TYPE=="xpm") begin: XPM
        // xpm_memory_sdpram: Simple Dual Port RAM
        // Simple Dual Port RAM (Distributed Memory) Depth=MEM_DEPTH Width=MEM_WIDTH
        xpm_memory_sdpram #(
          .ADDR_WIDTH_A            ( $clog2(MEM_DEPTH)  ), // DECIMAL
          .ADDR_WIDTH_B            ( $clog2(MEM_DEPTH)  ), // DECIMAL
          .AUTO_SLEEP_TIME         ( 0                  ), // DECIMAL
          .BYTE_WRITE_WIDTH_A      ( MEM_WIDTH          ), // DECIMAL
          .CASCADE_HEIGHT          ( 0                  ), // DECIMAL
          .CLOCKING_MODE           ( "common_clock"     ), // String
          .ECC_MODE                ( "no_ecc"           ), // String
          .MEMORY_INIT_FILE        ( "none"             ), // String
          .MEMORY_INIT_PARAM       ( "0"                ), // String
          .MEMORY_OPTIMIZATION     ( "true"             ), // String
          .MEMORY_PRIMITIVE        ( "distributed"      ), // String
          .MEMORY_SIZE             ( MEM_DEPTH*MEM_WIDTH), // DECIMAL
          .MESSAGE_CONTROL         ( 0                  ), // DECIMAL
          .READ_DATA_WIDTH_B       ( MEM_WIDTH          ), // DECIMAL
          .READ_LATENCY_B          ( 0                  ), // DECIMAL
          .READ_RESET_VALUE_B      ( "0"                ), // String
          .RST_MODE_A              ( "SYNC"             ), // String
          .RST_MODE_B              ( "SYNC"             ), // String
          .SIM_ASSERT_CHK          ( 0                  ), // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
          .USE_EMBEDDED_CONSTRAINT ( 0                  ), // DECIMAL
          .USE_MEM_INIT            ( 0                  ), // DECIMAL
          .WAKEUP_TIME             ( "disable_sleep"    ), // String
          .WRITE_DATA_WIDTH_A      ( MEM_WIDTH          ), // DECIMAL
          .WRITE_MODE_B            ( "read_first"       )  // String
        )
        xpmmem (
          .dbiterrb       (                     ),
          .doutb          ( PeekData            ),
          .sbiterrb       (                     ),
          .addra          ( WritePtr            ),
          .addrb          ( TOS                 ),
          .clka           ( clk                 ),
          .clkb           ( clk                 ),
          .dina           ( PushData            ),
          .ena            ( 1'b1                ),
          .enb            ( 1'b1                ),
          .injectdbiterra ( 1'b0                ),
          .injectsbiterra ( 1'b0                ),
          .regceb         ( 1'b0                ),
          .rstb           ( rst                 ),
          .sleep          ( 1'b0                ),
          .wea            ( PushEn              )
        );
    end
endgenerate

reg  RAS_we;
reg  RASempty_next;


//TOS ptr & empty logic
always @(posedge clk) begin
    if(rst) begin
        TOS <= -1;
        RASempty <= 1;
    end
    else if(~Stall) begin
        TOS <= TOS_next;
        RASempty <= RASempty_next;
    end
end


//BOS logic
always @(posedge clk) begin
    if(rst)
        BOS <= 0;
    else if(PushEn && BOS==(WritePtr+1) && ~Stall)
        BOS <= BOS+1;
end


//Push Pop Logic
always @*
begin
    if(~Stall) begin
        if(PushEn==1 && PopEn==0) begin
            RAS_we = 1'b1;
            TOS_next = TOS+1;
            RASempty_next = 1'b0;
        end
        else if(PushEn==0 && PopEn==1) begin
            RAS_we = 0;
            TOS_next = TOS-1;
            if(TOS==BOS)
                RASempty_next=1'b1;
            else
                RASempty_next=1'b0;
        end
        else if(PushEn==1 && PopEn==1) begin
            RAS_we = 1'b1;
            TOS_next = TOS;
            RASempty_next = RASempty;
        end
        else begin
            RAS_we=0;
            TOS_next=TOS;
            RASempty_next=RASempty;
        end
    end
    else begin
        RAS_we=0;
        TOS_next=TOS;
        RASempty_next=RASempty;
    end
end


endmodule
