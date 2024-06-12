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
`include "regbit_defines.vh"
`include "bus_defines.vh"

(* keep_hierarchy = "yes" *)
module DP
#(
    parameter MEM_TYPE    = "xpm"               // "rtl", "xip", "xpm"
)
(
    input  wire clk,
    input  wire rst,

    //Control Inputs
    input  wire                         DP_Enable,              //1=>Enable Direction Prediction

    //request inputs
    input  wire [`XLEN-1:0]             FetchPC,                //FetchPC for direction prediction
    input  wire                         Stall,                  //1=>Stall o/p Registers
    input  wire                         Bubble,                 //1=>Flush o/p Registers

    //response outputs
    output reg  [`FETCH_RATE-1:0]       DP_2bc,                 //Direction Predictor 2bc for all bundles indexed by fetchPC
    output reg                          DP_Hit,

    //DP update from Branch (Resolution) Unit
    input  wire [`FUBR_RESULT_LEN-1:0]  FUBRresp,               //Branch (Resolution) Unit Response Bus

    //DP Update from Branch Checker
    input  wire [`BC_RESP_LEN-1:0]      BCresp,                 //BC Response Bus

    //Commit Update Bus
    input  wire [`RETIRE_RATE-1:0]      branch_commit_taken,    //Actual direction of branches commited (in sequence) (lsb => oldest),
    input  wire [`RETIRE_RATE-1:0]      branch_commit_mask,     //branches commited (ith bit==1 => ith retired instruction branch & commited)
    input  wire                         GHR_commit_load         //1=>loads the commit GHR to current GHR (on exeption entry & exit/branch misprediction)
);


//generated Branch (Resolution) wires
wire                            FUBR_Valid              = FUBRresp[`FUBR_RESULT_VALID];
wire [`XLEN-1:0]                FUBR_PC                 = FUBRresp[`FUBR_RESULT_PC];
wire                            FUBR_IsWCBR             = (&FUBR_PC[`FETCHPCL_LEN-1:1]) & ~FUBRresp[`FUBR_RESULT_IS16BIT];
wire [`XLEN-1:0]                FUBR_FetchPC            = FUBR_IsWCBR ? (FUBR_PC+2) : {FUBR_PC[`XLEN-1:`FETCHPCL_LEN],FUBRresp[`FUBR_RESULT_FETCHPCL]};
wire [`FETCH_RATE_HW_LEN-1:0]   FUBR_BranchIndex        = FUBRresp[`FUBR_RESULT_BINDX];
wire [`BRANCH_TYPE__LEN-1:0]    FUBR_BranchType         = FUBRresp[`FUBR_RESULT_BRTYPE];
wire [`XLEN-1:0]                FUBR_BranchTarget       = FUBRresp[`FUBR_RESULT_BRTARGET];
wire                            FUBR_BranchTaken        = FUBRresp[`FUBR_RESULT_BRTAKEN];
wire                            FUBR_Mispredicted       = FUBRresp[`FUBR_RESULT_MISPRED];
wire [1:0]                      FUBR_DP2bc              = FUBRresp[`FUBR_RESULT_DP2BC];

wire                            BC_Update               = 1'b1;//BCresp[`BC_RESP_VALID];
wire [`FETCH_RATE_HW-1:0]       BC_IsBranch             = BCresp[`BC_RESP_BRANCH_MASK];
wire [`FETCH_RATE_HW-1:0]       BC_IsTaken              = BCresp[`BC_RESP_TAKEN_MASK];

//GHR registers
reg  [`DP_GHR_WIDTH-1:0]        GHR, GHR_d;           //current speculative GHR
reg  [`DP_GHR_WIDTH-1:0]        commit_GHR, commit_GHR_d;    //GHR of commited branches
reg  [`DP_GHR_WIDTH-1:0]        resolved_GHR;  //GHR of resolved branches


/************************
*  Internal Functions  *
************************/
function [`DP_GHR_WIDTH-1:0] GHR_Update(input [`DP_GHR_WIDTH-1:0] oldGHR, input BranchTaken);
    begin
        GHR_Update = {oldGHR[`DP_GHR_WIDTH-2:0],BranchTaken};
    end
endfunction

//GHR Hashing Function
function [`DP_PHT_WIDTH-1:0] GShare_Hash(input [`DP_GHR_WIDTH-1:0] GHR, input [`XLEN-1:0] PC);
    begin
        //original GShare_Hash = {(PC[12:8]^GHR), PC[7:1]};
        GShare_Hash = {(PC[11:4]^GHR), PC[3:1]};
    end
endfunction

//2bc Update Function
function [1:0] Update2bc(input [1:0] old2bc, input BranchTaken, input hit);
    begin
        if(hit) begin
            `ifdef DP_2BC_ALGO_PH
                //Fast Learning 2bc FSM (like BTB)
                case(old2bc)
                    2'b00 : Update2bc = (BranchTaken) ? 2'b01 : 2'b00;
                    2'b01 : Update2bc = (BranchTaken) ? 2'b11 : 2'b00;
                    2'b10 : Update2bc = (BranchTaken) ? 2'b11 : 2'b00;
                    2'b11 : Update2bc = (BranchTaken) ? 2'b11 : 2'b10;
                endcase
            `else
                //Normal Counter type 2bc FSM
                if(BranchTaken)
                    Update2bc = (old2bc==2'b11) ? 2'b11 : old2bc+2'b01;
                else
                    Update2bc = (old2bc==2'b00) ? 2'b00 : old2bc-2'b01;
            `endif
        end
        else begin
            //Init 2bc counter as weakly taken when taken and weakly not taken
            //when not taken
            Update2bc = BranchTaken ? 2'b10 : 2'b01;
        end
    end
endfunction

//Direction Predictor internal signals
wire [`DP_PHT_WIDTH-1:0]        PHT_resp_read_index  = GShare_Hash(GHR_d, FetchPC);
wire [(2*`FETCH_RATE_HW)-1:0]   PHT_resp_read_data;

wire [`DP_PHT_WIDTH-1:0]        PHT_upd_read_index;
wire [(2*`FETCH_RATE_HW)-1:0]   PHT_upd_read_data;
reg  [(2*`FETCH_RATE_HW)-1:0]   PHT_upd_write_data;
reg  [`DP_PHT_WIDTH-1:0]        PHT_upd_write_index;
reg                             PHT_upd_write_en;
reg                             PHT_upd_taken;
reg [`FETCH_RATE_HW_LEN-1:0]    PHT_upd_bindx;
reg                             PHT_upd_hit;

reg  DP_Valid[0:(2**`DP_PHT_WIDTH)-1];

//PHT Memory Instantiation
localparam MEM_DEPTH = 2**`DP_PHT_WIDTH;
localparam MEM_WIDTH = 2*`FETCH_RATE_HW;
integer gev;
generate
    always @(posedge clk) begin
        if(rst) begin
            for(gev=0; gev<MEM_DEPTH; gev=gev+1)
                DP_Valid[gev] <= 1'b0;
        end
        else if(PHT_upd_write_en)
            DP_Valid[PHT_upd_write_index] <= 1'b1;
    end

    if(MEM_TYPE=="rtl") begin:RTL
        simple_dpram #(.WIDTH(MEM_WIDTH),.DEPTH(MEM_DEPTH),.SYNC_READ(1)) mem_resp
        (
            .clk        ( clk                   ),
            .rst        ( rst                   ),
            .port0_din  ( PHT_upd_write_data    ),
            .port0_we   ( PHT_upd_write_en      ),
            .port0_addr ( PHT_upd_write_index   ),
            .port1_en   ( 1'b1                  ),
            .port1_addr ( PHT_resp_read_index   ),
            .port1_dout ( PHT_resp_read_data    )
        );
        simple_dpram #(.WIDTH(MEM_WIDTH),.DEPTH(MEM_DEPTH),.SYNC_READ(1)) mem_upd
        (
            .clk        ( clk                   ),
            .rst        ( rst                   ),
            .port0_din  ( PHT_upd_write_data    ),
            .port0_we   ( PHT_upd_write_en      ),
            .port0_addr ( PHT_upd_write_index   ),
            .port1_en   ( 1'b1                  ),
            .port1_addr ( PHT_upd_read_index    ),
            .port1_dout ( PHT_upd_read_data     )
        );
    end
    else if(MEM_TYPE=="xip") begin:blk
        PHT_bmem_4096x16b mem_resp
        (
            .clka  ( clk                    ), // input wire clka
            .wea   ( PHT_upd_write_en       ), // input wire [0 : 0] wea
            .addra ( PHT_upd_write_index    ), // input wire [11 : 0] addra
            .dina  ( PHT_upd_write_data     ), // input wire [1 : 0] dina
            .clkb  ( clk                    ), // input wire clkb
            .enb   ( 1'b1                   ), // input wire enb
            .addrb ( PHT_resp_read_index    ), // input wire [11 : 0] addrb
            .doutb ( PHT_resp_read_data     )  // output wire [1 : 0] doutb
        );
        PHT_bmem_4096x16b mem_upd
        (
            .clka  ( clk                    ), // input wire clka
            .wea   ( PHT_upd_write_en       ), // input wire [0 : 0] wea
            .addra ( PHT_upd_write_index    ), // input wire [11 : 0] addra
            .dina  ( PHT_upd_write_data     ), // input wire [15: 0] dina
            .clkb  ( clk                    ), // input wire clkb
            .enb   ( 1'b1                   ), // input wire enb
            .addrb ( PHT_upd_read_index     ), // input wire [11 : 0] addrb
            .doutb ( PHT_upd_read_data      )  // output wire [15: 0] doutb
        );
    end
    else if(MEM_TYPE=="xpm") begin: XPM
       // xpm_memory_sdpram: Simple Dual Port RAM
       // Simple Dual Port RAM (Block Memory) Depth=MEM_DEPTH Width=MEM_WIDTH
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
            .MEMORY_PRIMITIVE        ( "block"            ), // String
            .MEMORY_SIZE             ( MEM_DEPTH*MEM_WIDTH), // DECIMAL
            .MESSAGE_CONTROL         ( 0                  ), // DECIMAL
            .READ_DATA_WIDTH_B       ( MEM_WIDTH          ), // DECIMAL
            .READ_LATENCY_B          ( 1                  ), // DECIMAL
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
       mem_resp
       (
            .dbiterrb       (                       ),
            .doutb          ( PHT_resp_read_data    ),
            .sbiterrb       (                       ),
            .addra          ( PHT_upd_write_index   ),
            .addrb          ( PHT_resp_read_index   ),
            .clka           ( clk                   ),
            .clkb           ( clk                   ),
            .dina           ( PHT_upd_write_data    ),
            .ena            ( 1'b1                  ),
            .enb            ( 1'b1                  ),
            .injectdbiterra ( 1'b0                  ),
            .injectsbiterra ( 1'b0                  ),
            .regceb         ( 1'b0                  ),
            .rstb           ( rst                   ),
            .sleep          ( 1'b0                  ),
            .wea            ( PHT_upd_write_en      )
        );

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
            .MEMORY_PRIMITIVE        ( "block"            ), // String
            .MEMORY_SIZE             ( MEM_DEPTH*MEM_WIDTH), // DECIMAL
            .MESSAGE_CONTROL         ( 0                  ), // DECIMAL
            .READ_DATA_WIDTH_B       ( MEM_WIDTH          ), // DECIMAL
            .READ_LATENCY_B          ( 1                  ), // DECIMAL
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
       mem_upd
       (
            .dbiterrb       (                     ),
            .doutb          ( PHT_upd_read_data   ),
            .sbiterrb       (                     ),
            .addra          ( PHT_upd_write_index ),
            .addrb          ( PHT_upd_read_index  ),
            .clka           ( clk                 ),
            .clkb           ( clk                 ),
            .dina           ( PHT_upd_write_data  ),
            .ena            ( 1'b1                ),
            .enb            ( 1'b1                ),
            .injectdbiterra ( 1'b0                ),
            .injectsbiterra ( 1'b0                ),
            .regceb         ( 1'b0                ),
            .rstb           ( rst                 ),
            .sleep          ( 1'b0                ),
            .wea            ( PHT_upd_write_en    )
      );
    end
endgenerate


//Current (Speculative) GHR Update
integer gu;
always @(*) begin
    if(rst)
        GHR_d = 0;
    else if(GHR_commit_load)
        GHR_d = commit_GHR;
    else if(FUBR_Valid && (FUBR_BranchType==`BRANCH_TYPE_COND) && FUBR_Mispredicted)
        GHR_d = GHR_Update(resolved_GHR,FUBR_BranchTaken);
    else if(BC_Update) begin
        GHR_d = GHR;
        for(gu=0; gu<`FETCH_RATE_HW; gu=gu+1) begin
            if(BC_IsBranch[gu])
                GHR_d = GHR_Update(GHR_d, BC_IsTaken[gu]);
        end
    end
    else
        GHR_d = GHR;
end

always @(posedge clk) begin
    if(rst)
        GHR <= 0;
    else
        GHR <= GHR_d;
end


//commit GHR update
integer gc;
always @(*) begin
    commit_GHR_d = commit_GHR;
    for(gc=0; gc<`RETIRE_RATE; gc=gc+1) begin
        if(branch_commit_mask[gc])
            commit_GHR_d = {commit_GHR[`DP_GHR_WIDTH-2:0], branch_commit_taken[gc]};
    end
end
always @(posedge clk) begin
    if(rst)
        commit_GHR <= 0;
    else
        commit_GHR <= commit_GHR_d;
end


//resolved GHR Update
always @(posedge clk) begin
    if(rst)
        resolved_GHR <= 0;
    else if(FUBR_Valid && FUBR_BranchType==`BRANCH_TYPE_COND)
        resolved_GHR <= {resolved_GHR[`DP_GHR_WIDTH-2:0], FUBR_BranchTaken};
end


//Direction Predictor responses
always @(*) begin
    if(DP_Enable) begin
        DP_2bc = PHT_resp_read_data;
    end
    else
        DP_2bc = 0;
end
always @(posedge clk) begin
    if(rst)
        DP_Hit <= 0;
    else
        DP_Hit <= DP_Valid[PHT_resp_read_index];
end


//Direction Predictor Update
//in cycle 1, old data from PHT is read and in cycle 2 it is written in PHT
//after modification
//cycle 1 flops
assign PHT_upd_read_index = GShare_Hash(resolved_GHR, FUBR_FetchPC);
wire PHT_upd_read_hit = DP_Valid[PHT_upd_read_index];
always @(posedge clk) begin
    if(rst) begin
        PHT_upd_write_en    <= 0;
        PHT_upd_write_index <= 0;
        PHT_upd_taken       <= 0;
        PHT_upd_bindx       <= 0;
        PHT_upd_hit         <= 0;
    end
    else if(FUBR_Valid && FUBR_BranchType==`BRANCH_TYPE_COND) begin
        PHT_upd_write_en    <= 1'b1;
        PHT_upd_write_index <= PHT_upd_read_index;
        PHT_upd_taken       <= FUBR_BranchTaken;
        PHT_upd_bindx       <= FUBR_BranchIndex;
        PHT_upd_hit         <= PHT_upd_read_hit;
    end
    else begin
        PHT_upd_write_en    <= 0;
    end
end

//PHT Update Data using OLD data read from PHT and saved update response from
//FUBR
always @(*) begin
    //set read data as it is
    PHT_upd_write_data                       = PHT_upd_read_data;
    PHT_upd_write_data[(2*PHT_upd_bindx)+:2] = Update2bc(PHT_upd_read_data[(2*PHT_upd_bindx)+:2],PHT_upd_taken,PHT_upd_hit);
end

`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;

    `ifdef DEBUG_IFU_DP
        reg [`XLEN-1:0] DFetchPC, DFUBR_FetchPC;
        reg [`DP_PHT_WIDTH-1:0] DPHT_read_index;
        reg [`BRANCH_TYPE__LEN-1:0] DFUBR_BranchType;
        reg [`DP_PHT_WIDTH-1:0] DPHT_resp_read_index;
        reg [1:0] DFUBR_DP2bc;
        reg [`DP_GHR_WIDTH-1:0] Dresolved_GHR;
        always @(posedge clk) begin
            DFetchPC <= FetchPC;
            DPHT_read_index <= PHT_resp_read_index;
            DFUBR_FetchPC <= FUBR_FetchPC;
            DFUBR_BranchType <= FUBR_BranchType;
            DFUBR_DP2bc <= FUBR_DP2bc;
            Dresolved_GHR <= resolved_GHR;
        end

        always @(negedge clk) begin
            //Print after reading DP data
            $display("[%t] IFUDP_@RSP##: FPC=%h | PHT=%0d GHR=%b |%b DP=%b", $time,
                DFetchPC,
                DPHT_read_index, GHR,
                DP_Hit,
                PHT_resp_read_data
            );

            if(PHT_upd_write_en) begin
                //print in 2nd clock, while writing to PHT (after reading)
                $display("[%t] IFUDP_@UPD##: FPC=%h Bidx=%0d Btype=%c Btkn=%b | 2bc DP=%b FUBR=%b Upd=%b | UPD:PHT=%0d GHR=%b", $time,
                    DFUBR_FetchPC, PHT_upd_bindx, B2C(DFUBR_BranchType), PHT_upd_taken,
                    PHT_upd_read_data[(2*PHT_upd_bindx)+:2], DFUBR_DP2bc, PHT_upd_write_data[(2*PHT_upd_bindx)+:2],
                    PHT_upd_write_index, Dresolved_GHR
                );
            end
        end
    `endif
`endif


endmodule

