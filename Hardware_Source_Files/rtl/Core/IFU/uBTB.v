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
module uBTB
#(
    parameter MEM_TYPE    = "xpm"               // "rtl", "xip", "xpm"
)
(
    input  wire                             clk,
    input  wire                             rst,

    //Control Inputs
    input  wire                             uBTB_Enable,            //1=>Enable BTB
    input  wire                             uBTB_RAS_Enable,        //1=>Enable RAS

    //requests
    input  wire [`XLEN-1:0]                 FetchPC,                //FetchPC for BTB lookup
    input  wire                             Stall,                  //PLRU Stall + uBTB Stall
    input  wire                             Bubble,                 //uBTB o/p register flush (See Comments in Header)

    //responses to BC
    output reg  [`XLEN-1:0]                 uBTB_TargetPC,          //Branch Target Address
    output reg  [`FETCH_RATE_HW_LEN-1:0]    uBTB_BranchIndex,       //Taken Branch Index (HW offset from FetchPC)
    output reg  [`BRANCH_TYPE__LEN-1:0]     uBTB_BranchType,        //Branch Type of taken branch
    output reg                              uBTB_BranchTaken,       //1=>Branch Taken ny uBTB
    output reg                              uBTB_BTBhit,            //1=>BTB was hit
    output reg  [1:0]                       uBTB_BTB2bc,            //2bc value in BTB Entry
    output reg  [`BTB_WAYS_LEN-1:0]         uBTB_BTBway,            //Way of BTB which was hit
    output reg  [`XLEN-1:0]                 uBTB_RASpeek,           //Value at top of RAS

    //responses to PC Mux
    output wire                             uBTB_Redirect,          //1=>Redirect FetchPC
    output wire [`XLEN-1:0]                 uBTB_NextFetchPC,       //FetchPC Redirect Addr

    //update uBTB after Branch Checker
    input  wire [`BC_RESP_LEN-1:0]          BCresp,                 //Response BUS from Branch Checker Unit

    //update uBTB from Branch (Resolution) Unit
    input  wire [`FUBR_RESULT_LEN-1:0]      FUBRresp                //Response BUS from Branch (Resolution) Unit
);

//local wires for BTB read & write
wire [`BTB_SETS_LEN-1:0]        BTB_ReadAddr = FetchPC[`BTB_ADDR_INDEX];
wire [`BTB_ENTRY_LEN-1:0]       BTB_ReadData_Way[0:`BTB_WAYS-1];
reg  [`BTB_ENTRY_LEN-1:0]       BTB_ReadData;
wire [`BTB_WAYS-1:0]            BTB_Hit_Way;
wire                            BTB_Hit;

reg  [`BTB_WAYS-1:0]            BTB_WriteEn_Way;
reg  [`BTB_SETS_LEN-1:0]        BTB_WriteAddr;
reg  [`BTB_ENTRY_LEN-1:0]       BTB_WriteData;
reg  [`XLEN-1:0]                FetchPC_ForTagCompare;  //1clk cycle delayed FetchPC for tag compare after reading BTB

//local wires for BTB response (actual ooutput is registered)
reg  [`XLEN-1:0]                TargetPC_d;
reg  [`FETCH_RATE_HW_LEN-1:0]   BranchIndex_d;
reg  [`BRANCH_TYPE__LEN-1:0]    BranchType_d;
reg                             BranchTaken_d;
wire                            BTBhit_d;
wire  [1:0]                     BTB2bc_d;
reg   [`BTB_WAYS_LEN-1:0]       BTBway_d;

//extracted local wires from Branch Checker Response BUS
wire [`XLEN-1:0]                BC_PC                   = BCresp[`BC_RESP_PC];
wire                            BC_IsWCBR               = (&BC_PC[`FETCHPCL_LEN-1:1]) & ~BCresp[`BC_RESP_IS16BIT];
wire [`XLEN-1:0]                BC_FetchPC              = BC_IsWCBR ? (BC_PC+2) : {BC_PC[`XLEN-1:`FETCHPCL_LEN],BCresp[`BC_RESP_FETCHPCL]};
wire [`XLEN-1:0]                BC_BranchTarget         = BCresp[`BC_RESP_BRTARGET];
wire [`XLEN-1:0]                BC_PushData             = BCresp[`BC_RESP_PUSH_DATA];
wire [`FETCH_RATE_HW_LEN-1:0]   BC_BranchIndex          = BCresp[`BC_RESP_BINDX];
wire [`BRANCH_TYPE__LEN-1:0]    BC_BranchType           = BCresp[`BC_RESP_BRTYPE];
wire                            BC_BranchTaken          = BCresp[`BC_RESP_BRTAKEN];
wire                            BC_Valid                = BCresp[`BC_RESP_VALID];
wire [1:0]                      BC_BTB2bc               = BCresp[`BC_RESP_BTB2BC];
wire                            BC_BTBhit               = BCresp[`BC_RESP_BTBHIT];
wire [`BTB_WAYS_LEN-1:0]        BC_BTBway               = BCresp[`BC_RESP_BTBWAY];

//extracted local wires from Branch (resolution) Unit Result BUS
wire [`XLEN-1:0]                FUBR_PC                 = FUBRresp[`FUBR_RESULT_PC];
wire                            FUBR_IsWCBR             = (&FUBR_PC[`FETCHPCL_LEN-1:1]) & ~FUBRresp[`FUBR_RESULT_IS16BIT];
wire [`XLEN-1:0]                FUBR_FetchPC            = FUBR_IsWCBR ? (FUBR_PC+2) : {FUBR_PC[`XLEN-1:`FETCHPCL_LEN],FUBRresp[`FUBR_RESULT_FETCHPCL]};
wire [`XLEN-1:0]                FUBR_BranchTarget       = FUBRresp[`FUBR_RESULT_BRTARGET];
wire [`FETCH_RATE_HW_LEN-1:0]   FUBR_BranchIndex        = FUBRresp[`FUBR_RESULT_BINDX];
wire [`BRANCH_TYPE__LEN-1:0]    FUBR_BranchType         = FUBRresp[`FUBR_RESULT_BRTYPE];
wire                            FUBR_BranchTaken        = FUBRresp[`FUBR_RESULT_BRTAKEN];
wire                            FUBR_Valid              = FUBRresp[`FUBR_RESULT_VALID];
wire [1:0]                      FUBR_BTB2bc             = FUBRresp[`FUBR_RESULT_BTB2BC];
wire                            FUBR_BTBhit             = FUBRresp[`FUBR_RESULT_BTBHIT];
wire [`BTB_WAYS_LEN-1:0]        FUBR_BTBway             = FUBRresp[`FUBR_RESULT_BTBWAY];

//RAS wires
reg                             RAS_PushEn;
reg  [`XLEN-1:0]                RAS_PushData;
reg                             RAS_PopEn;
wire [`XLEN-1:0]                RAS_PeekData;
wire                            RAS_empty;

//PLRU wires
wire [`BTB_WAYS_LEN-1:0]        PLRU_ReadWay = BTBway_d;
reg  [`BTB_WAYS_LEN-1:0]        PLRU_WriteWay;
wire [`BTB_WAYS_LEN-1:0]        PLRU_LRUway;
wire [`BTB_SETS_LEN-1:0]        PLRU_ReadSet  = BTB_ReadAddr;
wire [`BTB_SETS_LEN-1:0]        PLRU_WriteSet = BTB_WriteAddr;
wire                            PLRU_UpdateEn = ~Stall;
wire                            PLRU_ReadAccess  = BTB_Hit;
wire                            PLRU_WriteAccess = |BTB_WriteEn_Way;

//Separate Valid Bit as we cannot clear BRAM containts on reset
reg  [`BTB_SETS-1:0]            BTB_ExValid[0:`BTB_WAYS-1];
reg                             BTB_ExValid_Read[0:`BTB_WAYS-1];

//BTB & RAS instantiations
localparam MEM_DEPTH = `BTB_SETS;
localparam MEM_WIDTH = `BTB_ENTRY_LEN;
genvar bb;
generate
    for(bb=0; bb<`BTB_WAYS; bb=bb+1) begin:BTB_way
        //Workarround for BRAM Reset
        always @(posedge clk) begin
            if(rst) begin
                BTB_ExValid[bb] <= 0;
                BTB_ExValid_Read[bb] <= 0;
            end
            else begin
                if(BTB_WriteEn_Way[bb])
                    BTB_ExValid[bb][BTB_WriteAddr]  <= BTB_WriteData[`BTB_ENTRY_VALID];
                BTB_ExValid_Read[bb]                <= BTB_ExValid[bb][BTB_ReadAddr];
            end
        end
        if(MEM_TYPE=="rtl") begin:RTL
            simple_dpram #(.WIDTH(MEM_WIDTH), .DEPTH(MEM_DEPTH), .SYNC_READ(1)) mem
            (
                .clk        (clk                 ),
                .rst        (rst                 ),
                .port0_din  (BTB_WriteData       ),
                .port0_we   (BTB_WriteEn_Way[bb] ),
                .port0_addr (BTB_WriteAddr       ),
                .port1_en   (1'b1                ),
                .port1_addr (BTB_ReadAddr        ),
                .port1_dout (BTB_ReadData_Way[bb])
            );
        end
        else if(MEM_TYPE=="xip") begin:blk
            BTB_bmem_256x127b mem
            (
                .clka  (clk                 ), // input wire clka
                .wea   (BTB_WriteEn_Way[bb] ), // input wire [0 : 0] wea
                .addra (BTB_WriteAddr       ), // input wire [7 : 0] addra
                .dina  (BTB_WriteData       ), // input wire [126 : 0] dina
                .clkb  (clk                 ), // input wire clkb
                .enb   (1'b1                ), // input wire enb
                .addrb (BTB_ReadAddr        ), // input wire [7 : 0] addrb
                .doutb (BTB_ReadData_Way[bb])  // output wire [126 : 0] doutb
            );
        end
        else if(MEM_TYPE=="xpm") begin:xpm
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
           xpmmem (
              .dbiterrb       (                     ),
              .doutb          ( BTB_ReadData_Way[bb]),
              .sbiterrb       (                     ),
              .addra          ( BTB_WriteAddr       ),
              .addrb          ( BTB_ReadAddr        ),
              .clka           ( clk                 ),
              .clkb           ( clk                 ),
              .dina           ( BTB_WriteData       ),
              .ena            ( 1'b1                ),
              .enb            ( 1'b1                ),
              .injectdbiterra ( 1'b0                ),
              .injectsbiterra ( 1'b0                ),
              .regceb         ( 1'b0                ),
              .rstb           ( rst                 ),
              .sleep          ( 1'b0                ),
              .wea            ( BTB_WriteEn_Way[bb] )
          );
        end
    end
endgenerate

RAS #(.DEPTH(`RAS_DEPTH), .MEM_TYPE(MEM_TYPE)) RAS
(
    .clk      (clk         ),
    .rst      (rst         ),
    .Stall    (1'b0        ), //RAS update is not stalled since its update
    .PushEn   (RAS_PushEn  ),
    .PushData (RAS_PushData),
    .PopEn    (RAS_PopEn   ),
    .PeekData (RAS_PeekData),
    .RASempty (RAS_empty   )
);

generate
    if(`BTB_WAYS==4) begin:BTB_4way
        PLRU4 #(.SETS(`BTB_SETS)) PLRU_uBTB
        (
            .clk         (clk             ),
            .rst         (rst             ),
            .UpdateEn    (PLRU_UpdateEn   ),
            .ReadSet     (PLRU_ReadSet    ),
            .ReadWay     (PLRU_ReadWay    ),
            .ReadAccess  (PLRU_ReadAccess ),
            .WriteSet    (PLRU_WriteSet   ),
            .WriteWay    (PLRU_WriteWay   ),
            .WriteAccess (PLRU_WriteAccess),
            .LRU_Way     (PLRU_LRUway     )
        );
    end
endgenerate


//--------------------------------------------------------------------
// uBTB Response Logic
//--------------------------------------------------------------------

//BTB hit logic (no logic for 2bc hit, as BTB hit => 2bc hit)
genvar bh;
generate
    for(bh=0; bh<`BTB_WAYS; bh=bh+1) begin
        assign BTB_Hit_Way[bh] = (BTB_ReadData_Way[bh][`BTB_ENTRY_VALID] == 1'b1) && (BTB_ExValid_Read[bh]==1'b1) &&
                                 (BTB_ReadData_Way[bh][`BTB_ENTRY_FTAG]  == FetchPC_ForTagCompare[`BTB_ADDR_TAG]);
    end
endgenerate

assign BTB_Hit = uBTB_Enable & (|BTB_Hit_Way);  //Override BTB Hit with uBTB Enable.
integer i;
always @*
begin
    BTB_ReadData = 0;
    BTBway_d = 0;
    for(i=0; i<`BTB_WAYS; i=i+1) begin
        if(BTB_Hit_Way[i]) begin
            BTB_ReadData = BTB_ReadData_Way[i];
            BTBway_d = i;
        end
    end
end


//1clk delayed FetchPC for tag comparision after BTB Read
always @(posedge clk) begin
    if(rst)
        FetchPC_ForTagCompare <= 0;
    else
        FetchPC_ForTagCompare <= FetchPC;
end


//uBTB response outputs (to PC redirect)
assign uBTB_NextFetchPC = TargetPC_d;
assign uBTB_Redirect    = BranchTaken_d;
always @(*) begin
    if(BTB_Hit & ~Stall) begin
        TargetPC_d       = BTB_ReadData[`BTB_ENTRY_TARGETPC];
        BranchIndex_d    = BTB_ReadData[`BTB_ENTRY_BINDX];
        BranchType_d     = BTB_ReadData[`BTB_ENTRY_BRTYPE];

        case(BTB_ReadData[`BTB_ENTRY_BRTYPE])
            `BRANCH_TYPE_JMP, `BRANCH_TYPE_IJMP, `BRANCH_TYPE_CALL, `BRANCH_TYPE_ICALL: begin
                //if it is unconditional jump, call or Indirect jump with
                //target addr
                BranchTaken_d    = 1'b1;
            end
            `BRANCH_TYPE_RET: begin
                //if it is Return Instruction
                BranchTaken_d    = ~RAS_empty;  //Do NOT redirect if RAS is empty
                TargetPC_d       = RAS_PeekData;//peek            = data@stacktop
                BranchType_d     = `BRANCH_TYPE_RET;
            end
            `BRANCH_TYPE_COND: begin
                if(BTB_ReadData[`BTB_ENTRY_2BC_MSB]==1'b1) begin //if Taken branch
                    BranchTaken_d    = 1'b1;
                end
                else begin   //Not Taken Branch
                    BranchTaken_d    = 1'b0;
                end
            end
            default: begin
                BranchTaken_d    = 1'b0;
            end
        endcase
    end
    else begin //No entry in BTB
        TargetPC_d       = 0;
        BranchIndex_d    = 0;
        BranchType_d     = `BRANCH_TYPE_NONE;
        BranchTaken_d    = 1'b0;
    end
end


//Register response outputs before giving responses to Branch Checker
assign BTBhit_d = BTB_Hit;
assign BTB2bc_d = BTB_ReadData[`BTB_ENTRY_2BC];
always @(posedge clk)
begin
    if(rst|Bubble) begin
        uBTB_TargetPC    <= 0;
        uBTB_BranchIndex <= 0;
        uBTB_BranchType  <= 0;
        uBTB_BranchTaken <= 0;
        uBTB_BTBhit      <= 0;
        uBTB_BTB2bc      <= 0;
        uBTB_BTBway      <= 0;
        uBTB_RASpeek     <= 0;
    end
    else if(~Stall) begin
        uBTB_TargetPC    <= TargetPC_d;
        uBTB_BranchIndex <= BranchIndex_d;
        uBTB_BranchType  <= BranchType_d;
        uBTB_BranchTaken <= BranchTaken_d;
        uBTB_BTBhit      <= BTBhit_d;
        uBTB_BTB2bc      <= BTB2bc_d;
        uBTB_BTBway      <= BTBway_d;
        uBTB_RASpeek     <= (RAS_empty | ~uBTB_RAS_Enable) ? 64'b0: RAS_PeekData;

    end
end

//--------------------------------------------------------------------
// BTB Update From Branch Checker (BC) & Branch (Resolution) Unit
//--------------------------------------------------------------------

// Since only 1 wr port, more preference to Branch Unit as it is more
// trustworthy (but it can override only if it is updating BTB otherwise
// update from Branch Checker (e.g. RAS related) can happen)
always @*
begin
    BTB_WriteData = 0;
    BTB_WriteEn_Way = 0;
    BTB_WriteAddr = 0;
    RAS_PushEn = 0;
    RAS_PopEn = 0;
    RAS_PushData = 0;
    PLRU_WriteWay = 0;

    if(FUBR_Valid) begin        //Update from Branch (Resolution) Functional Unit
        if(FUBR_BTBhit) begin
            BTB_WriteEn_Way = 0;
            BTB_WriteEn_Way[FUBR_BTBway] = 1;
            PLRU_WriteWay = FUBR_BTBway;
        end
        else begin
            BTB_WriteEn_Way = 0;
            BTB_WriteEn_Way[PLRU_LRUway] = 1;
        end

        BTB_WriteAddr = FUBR_FetchPC[`BTB_ADDR_INDEX];
        BTB_WriteData[`BTB_ENTRY_VALID] = 1'b1;

        case(FUBR_BranchType)
            `BRANCH_TYPE_JMP, `BRANCH_TYPE_IJMP, `BRANCH_TYPE_CALL, `BRANCH_TYPE_ICALL: begin
                BTB_WriteData[`BTB_ENTRY_FTAG] = FUBR_FetchPC[`BTB_ADDR_TAG];
                BTB_WriteData[`BTB_ENTRY_BRTYPE]   = FUBR_BranchType;
                BTB_WriteData[`BTB_ENTRY_BINDX] = FUBR_BranchIndex;
                BTB_WriteData[`BTB_ENTRY_TARGETPC] = FUBR_BranchTarget;
            end

            `BRANCH_TYPE_RET : begin
                BTB_WriteData[`BTB_ENTRY_FTAG] = FUBR_FetchPC[`BTB_ADDR_TAG];
                BTB_WriteData[`BTB_ENTRY_BRTYPE] = `BRANCH_TYPE_RET;
                BTB_WriteData[`BTB_ENTRY_BINDX] = FUBR_BranchIndex;
                // Not needed BTB_WriteData[`BTB_ENTRY_TARGETPC] = FUBR_BranchTarget;
            end

            `BRANCH_TYPE_COND: begin
                BTB_WriteData[`BTB_ENTRY_FTAG] = FUBR_FetchPC[`BTB_ADDR_TAG];
                BTB_WriteData[`BTB_ENTRY_BINDX] = FUBR_BranchIndex;
                BTB_WriteData[`BTB_ENTRY_BRTYPE] = `BRANCH_TYPE_COND;
                BTB_WriteData[`BTB_ENTRY_TARGETPC] = FUBR_BranchTarget;
                case(FUBR_BTB2bc)
                    2'b00: BTB_WriteData[`BTB_ENTRY_2BC] = FUBR_BranchTaken ? 2'b01 : 2'b00;
                    2'b01: BTB_WriteData[`BTB_ENTRY_2BC] = FUBR_BranchTaken ? 2'b11 : 2'b00;
                    2'b10: BTB_WriteData[`BTB_ENTRY_2BC] = FUBR_BranchTaken ? 2'b11 : 2'b00;
                    2'b11: BTB_WriteData[`BTB_ENTRY_2BC] = FUBR_BranchTaken ? 2'b11 : 2'b10;
                endcase
            end

            default: begin
                BTB_WriteData = 0;
                BTB_WriteEn_Way = 0;
                BTB_WriteAddr = 0;
            end
        endcase
    end
    else if(BC_Valid==1'b1) begin
        if(BC_BTBhit) begin
            BTB_WriteEn_Way = 0;
            BTB_WriteEn_Way[BC_BTBway] = 1;
            PLRU_WriteWay = BC_BTBway;
        end
        else begin
            BTB_WriteEn_Way = 0;
            BTB_WriteEn_Way[PLRU_LRUway] = 1;
        end

        BTB_WriteAddr = BC_FetchPC[`BTB_ADDR_INDEX];
        BTB_WriteData[`BTB_ENTRY_VALID] = 1'b1;

        case(BC_BranchType)
            `BRANCH_TYPE_JMP , `BRANCH_TYPE_CALL : begin
                BTB_WriteData[`BTB_ENTRY_FTAG] = BC_FetchPC[`BTB_ADDR_TAG];
                BTB_WriteData[`BTB_ENTRY_BRTYPE]   = BC_BranchType;
                BTB_WriteData[`BTB_ENTRY_BINDX] = BC_BranchIndex;
                BTB_WriteData[`BTB_ENTRY_TARGETPC] = BC_BranchTarget;
            end

            `BRANCH_TYPE_RET : begin
                BTB_WriteData[`BTB_ENTRY_FTAG] = BC_FetchPC[`BTB_ADDR_TAG];
                BTB_WriteData[`BTB_ENTRY_BRTYPE] = `BRANCH_TYPE_RET;
                BTB_WriteData[`BTB_ENTRY_BINDX] = BC_BranchIndex;
                //No need we dont store address for ret instr BTB_WriteData[`BTB_ENTRY_TARGETPC] = BC_BranchTarget;
            end

            `BRANCH_TYPE_COND: begin
                BTB_WriteData[`BTB_ENTRY_FTAG] = BC_FetchPC[`BTB_ADDR_TAG];
                BTB_WriteData[`BTB_ENTRY_BINDX] = BC_BranchIndex;
                BTB_WriteData[`BTB_ENTRY_BRTYPE] = `BRANCH_TYPE_COND;
                BTB_WriteData[`BTB_ENTRY_TARGETPC] = BC_BranchTarget;

                case(BC_BTB2bc)
                    2'b00: BTB_WriteData[`BTB_ENTRY_2BC] = BC_BranchTaken ? 2'b01 : 2'b00;
                    2'b01: BTB_WriteData[`BTB_ENTRY_2BC] = BC_BranchTaken ? 2'b10 : 2'b00;
                    2'b10: BTB_WriteData[`BTB_ENTRY_2BC] = BC_BranchTaken ? 2'b11 : 2'b01;
                    2'b11: BTB_WriteData[`BTB_ENTRY_2BC] = BC_BranchTaken ? 2'b11 : 2'b10;
                endcase
            end

            default: begin
                BTB_WriteData = 0;
                BTB_WriteEn_Way = 0;
                BTB_WriteAddr = 0;
            end
        endcase
    end

    //RAS update from BC => does not matter whether FUBR is updating or not
    //RAS must be updated from BC iff RAS is enabled
    if(BC_Valid==1'b1 && uBTB_RAS_Enable==1'b1) begin
        if(BC_BranchType==`BRANCH_TYPE_CALL || BC_BranchType==`BRANCH_TYPE_ICALL) begin
            RAS_PushEn = 1'b1;
            RAS_PushData = BC_PushData;
        end
        else if(BC_BranchType==`BRANCH_TYPE_RET) begin
            RAS_PopEn = RAS_empty ? 1'b0 : 1'b1;
        end
    end
end

`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;

    `ifdef DEBUG_IFU_UBTB
        always @(negedge clk) begin
            $display("[%t] IFUBTB@RSP##: FPC=%h BTarget=%h Btkn=%b Bidx=%0d BT=%c | BTB: hit=%b 2bc=%b NFA=%h ", $time,
                FetchPC_ForTagCompare, TargetPC_d, BranchTaken_d, BranchIndex_d, B2C(BranchType_d),
                BTBhit_d, BTB2bc_d, uBTB_NextFetchPC);
            if(FUBR_Valid) begin
                $display("[%t] IFUBTB@UPD#F: FPC=%h Bidx=%0d Btype=%c Btkn=%b BTarget=%h | BTB: hit=%b 2bc=%b Way=%0d", $time,
                    FUBR_FetchPC, FUBR_BranchIndex, B2C(FUBR_BranchType), FUBR_BranchTaken, FUBR_BranchTarget,
                    FUBR_BTBhit, BTB_WriteData[`BTB_ENTRY_2BC], FUBR_BTBway);
            end
            else if(BC_Valid) begin
                $display("[%t] IFUBTB@UPD#B: FPC=%h Bidx=%0d Btype=%c Btkn=%b BTarget=%h | BTB: hit=%b 2bc=%b Way=%0d", $time,
                    BC_FetchPC, BC_BranchIndex, B2C(BC_BranchType), BC_BranchTaken, BC_BranchTarget,
                    BC_BTBhit, BTB_WriteData[`BTB_ENTRY_2BC], BC_BTBway);

            end
        end
    `endif
`endif


endmodule

