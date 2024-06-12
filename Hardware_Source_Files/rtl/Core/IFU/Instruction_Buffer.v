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

(* keep_hierarchy = "yes" *)
module Instruction_Buffer
#(
    parameter MEM_TYPE    = "xpm",              // "rtl", "xip", "xpm"
    parameter DEPTH       = `IB_DEPTH,          // Depth of fifo
    parameter WIDTH       = `IB_ENTRY_LEN,      // Width of an fifo port
    parameter WRITE_PORTS = `FETCH_RATE_HW,     // No. of Write Ports
    parameter READ_PORTS  = `DECODE_RATE,       // No. of Read Ports
    parameter FWFT_ENABLE = 1                   // 1=> First m entries Fall Through Enable
)
(
    input  wire clk,
    input  wire rst,

    input  wire Flush,                                      //Flushes IB (i.e. resets IB pointers & state)

    input  wire [(WRITE_PORTS*WIDTH)-1:0]   DataIn,         //IB write data input
    input  wire [WRITE_PORTS-1:0]           WriteEnable,    //IB Write Enable (bitwise for each port) 0th Port is added first

    input  wire [$clog2(READ_PORTS)  :0]    ReadEnableCnt,  //No. of data blocks to read from IB
    output wire [(READ_PORTS*WIDTH)-1:0]    DataOut,        //IB read data output

    output wire [$clog2(DEPTH):0]           FreeCnt,        //No. of Free Entries in IB (Range = 0 to DEPTH)
    output wire [$clog2(DEPTH):0]           UsedCnt,        //No. of Used Entries in IB (Range = 0 to DEPTH)
    output reg  [READ_PORTS-1:0]            OutputValidMask //1=>IB ith output is valid
);


//generate parameters
localparam PTR_SIZE     = $clog2(DEPTH)+1;
localparam BANKS        = (READ_PORTS > WRITE_PORTS) ? READ_PORTS : WRITE_PORTS;
localparam BANKS_LEN    = $clog2(BANKS);
localparam MEM_DEPTH    = DEPTH/BANKS;
localparam MEM_ADDR_LEN = $clog2(MEM_DEPTH);    //This is minimum LEN
localparam MEM_WIDTH    = WIDTH;


// Internal Registers
reg  [PTR_SIZE-1 :0]    rd_ptr;
reg  [PTR_SIZE-1 :0]    wr_ptr;
reg  [BANKS_LEN-1:0]    map_rdport_bank[0:READ_PORTS-1];    //see map_rdport_bank_d


//Internal wires (even though data type reg, they are wires)
wire [WIDTH-1:0]        din[0:WRITE_PORTS-1];               //Separate wire for each data input  ports
reg  [WIDTH-1:0]        dout[0:READ_PORTS-1];               //Separate wire for each data output ports
wire [WIDTH-1:0]        bank_dout[0:BANKS-1];               //data output wire for each bank
reg  [MEM_ADDR_LEN-1:0] bank_wr_addr[0:BANKS-1];            //mem write address for each bank
reg  [WIDTH-1:0]        bank_din[0:BANKS-1];                //data input wire for each bank
reg  [MEM_ADDR_LEN-1:0] bank_rd_addr[0:BANKS-1];            //mem read address for each bank
reg                     bank_we[0:BANKS-1];                 //mem write enable for each bank

//mapping between read port and bank(i.e. which read port will receive from which bank (index=rd_port, data=bank)
reg  [BANKS_LEN-1:0]    map_rdport_bank_d[0:READ_PORTS-1];

//mapping between write port and bank i.e. which write port data will go to which bank (index=wr_port, data=bank)
reg  [BANKS_LEN-1:0]    map_wrport_bank_d[0:WRITE_PORTS-1];


//generate separate din & dout wires from data input & data output busses
genvar gi;
generate
    for(gi=0; gi<WRITE_PORTS; gi=gi+1) begin
        assign din[gi] = DataIn[(gi+1)*WIDTH-1:gi*WIDTH];
    end
endgenerate

genvar go;
generate
    for(go=0; go<READ_PORTS; go=go+1) begin
        assign DataOut[(go+1)*WIDTH-1:go*WIDTH] = dout[go];
    end
endgenerate

//Registers for FWTF
reg                     bank_fwd_enable [0:BANKS-1];
reg  [MEM_WIDTH-1:0]    bank_fwd_data   [0:BANKS-1];
wire [MEM_WIDTH-1:0]    bank_dout_premux[0:BANKS-1];

//memory instantiations
genvar gj;
generate
    for(gj=0; gj<BANKS; gj=gj+1) begin:IB_bank
        if(MEM_TYPE=="rtl") begin:RTL
            simple_dpram #(.WIDTH(MEM_WIDTH), .DEPTH(MEM_DEPTH), .SYNC_READ(1)) mem
            (
                .clk        ( clk              ) ,
                .rst        ( rst              ) ,
                .port0_din  ( bank_din[gj]     ) ,
                .port0_we   ( bank_we[gj]      ) ,
                .port0_addr ( bank_wr_addr[gj] ) ,
                .port1_en   ( 1'b1             ) ,
                .port1_addr ( bank_rd_addr[gj] ) ,
                .port1_dout ( bank_dout_premux[gj])
            );
        end
        else if(MEM_TYPE=="xip") begin:blk //block mem
            IB_bmem_4x186b mem
            (
                .clka  ( clk              ) ,
                .wea   ( bank_we[gj]      ) ,
                .addra ( bank_wr_addr[gj] ) ,
                .dina  ( bank_din[gj]     ) ,
                .clkb  ( clk              ) ,
                .enb   ( 1'b1             ) ,
                .addrb ( bank_rd_addr[gj] ) ,
                .doutb ( bank_dout_premux[gj])
            );
        end
        else if(MEM_TYPE=="xpm") begin: XPM //XPM Macro
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
              .dbiterrb       (                      ),
              .doutb          ( bank_dout_premux[gj] ),
              .sbiterrb       (                      ),
              .addra          ( bank_wr_addr[gj]     ),
              .addrb          ( bank_rd_addr[gj]     ),
              .clka           ( clk                  ),
              .clkb           ( clk                  ),
              .dina           ( bank_din[gj]         ),
              .ena            ( 1'b1                 ),
              .enb            ( 1'b1                 ),
              .injectdbiterra ( 1'b0                 ),
              .injectsbiterra ( 1'b0                 ),
              .regceb         ( 1'b0                 ),
              .rstb           ( rst                  ),
              .sleep          ( 1'b0                 ),
              .wea            ( bank_we[gj]          )
          );
        end

        always @(posedge clk) begin:internal_fwd_check
            if(rst) begin
                bank_fwd_enable[gj] <= 1'b0;
                bank_fwd_data[gj]   <= {WIDTH{1'b0}};
            end
            else if(bank_we[gj] && (bank_wr_addr[gj]==bank_rd_addr[gj])) begin
                bank_fwd_enable[gj] <= 1'b1;
                bank_fwd_data[gj]   <= bank_din[gj];
            end
            else begin
                bank_fwd_enable[gj] <= 1'b0;
            end
        end

        assign bank_dout[gj] = bank_fwd_enable[gj]==1'b1 ? bank_fwd_data[gj] : bank_dout_premux[gj];

    end
endgenerate

//-----------------------------------------------------------------------------------------------------------------------------------------
//Generate mem_write_addr and mapping between wr_port&bank on IB write using WriteEnable
reg [WRITE_PORTS-1:0] is_used;  //variable (not register)
reg [WRITE_PORTS-1:0] is_done;  //variable (not register)
reg [PTR_SIZE-2:0] wr_addr;     //variable for calculating which addr (includes mem_addr & bank) to write
integer i,j,x;
always @* begin
    is_used = 0;
    is_done = 0;
    for(x=0; x<BANKS; x=x+1)   //default mem_write_addr for each bank
        bank_wr_addr[x] = 0;

    for(i=0; i<WRITE_PORTS; i=i+1) begin          //i=>ith write port
        map_wrport_bank_d[i] = 0;
        wr_addr = 0;
        for(j=0; j<=i; j=j+1) begin             //j=>relative position wrt wr_ptr where to write ith port data

            //write only iff write_enable=1 and relative position j is not already used by preceding port
            if(is_used[j]==0 && WriteEnable[i]==1'b1 && is_done[i]==1'b0) begin
                wr_addr = wr_ptr[PTR_SIZE-2:0]+j;   //calculate write address (mem_wr_addr+bank) combined for relative position j
                is_used[j]=1'b1;                  //mark relative position j as used
                is_done[i]=1'b1;
                bank_wr_addr[wr_addr[BANKS_LEN-1:0]] = wr_addr[PTR_SIZE-2:BANKS_LEN]; //set the mem_write_address for calculated bank
                map_wrport_bank_d[i] = wr_addr[BANKS_LEN-1:0];  //save mapping between ith write port and calculated bank
            end
        end
    end
end


//assign data_input, write_enable to bank using map_wrport_bank_d
integer p,w;
always @* begin
    for(w=0; w<BANKS; w=w+1) begin
        bank_din[w] = 0;
        bank_we[w]  = 0;
    end

    for(p=0; p<WRITE_PORTS; p=p+1) begin
        if(WriteEnable[p]==1'b1) begin
            bank_din[map_wrport_bank_d[p]] = din[p];
            bank_we[map_wrport_bank_d[p]]  = 1'b1;
        end
    end
end


//---------------------------------------------------------------------------------------------------------------------------------------------------
//Generate mem_read_addr and mapping between rd_port&bank on IB read (before clk)
wire [PTR_SIZE-1:0] rd_ptr_ft;
generate
    if(FWFT_ENABLE==1) begin
        assign rd_ptr_ft = rd_ptr + ReadEnableCnt;
    end
    else begin
        assign rd_ptr_ft = rd_ptr;
    end
endgenerate
integer l,y;
reg [PTR_SIZE-2:0] rd_addr;     //variable for calculating which addr (includes mem_addr & bank) to read for each loop iteration
always @* begin
    for(y=0; y<BANKS; y=y+1) begin
        bank_rd_addr[y] = 0;    //default mem_read_addr for each bank
    end

    for(l=0; l<READ_PORTS; l=l+1) begin
        map_rdport_bank_d[l] = 0;
        rd_addr = rd_ptr_ft[PTR_SIZE-2:0]+l;   //calculate read address (mem_rd_addr+bank) combined for l (relative read position w.r.t rd_ptr_ft)
        bank_rd_addr[rd_addr[BANKS_LEN-1:0]] = rd_addr[PTR_SIZE-2:BANKS_LEN];   //set mem_read_addr for calculated bank
        map_rdport_bank_d[l] = rd_addr[BANKS_LEN-1:0];
    end
end

//assign data_output to bank using map_rdport_bank (after clk when data is available at dout of mem)
integer n;
always @* begin
    for(n=0; n<READ_PORTS; n=n+1) begin
        if(FWFT_ENABLE==1)                              //Make Data in all banks visible on out port
            dout[n] = bank_dout[map_rdport_bank[n]];
        else begin                                      //Make only requested data to be visible on out port
            if(n<ReadEnableCnt)
                dout[n] = bank_dout[map_rdport_bank[n]];
            else
                dout[n] = 0;
        end
    end
end


//---------------------------------------------------------------------------------------------------------------------------------------------------
//find number of entries to be written to IB
integer k;
reg [$clog2(WRITE_PORTS):0] wr_cnt;
always @* begin
    wr_cnt = 0;
    for(k=0; k<WRITE_PORTS; k=k+1)
        wr_cnt = wr_cnt + WriteEnable[k];
end


//main IB control block
integer m,mr;
always @(posedge clk) begin
    if(rst | Flush) begin
        rd_ptr <= 0;
        wr_ptr <= 0;
        for(mr=0; mr<READ_PORTS; mr=mr+1)
            map_rdport_bank[mr]<=0;
    end
    else begin
        if(|WriteEnable)
            wr_ptr <= wr_ptr + wr_cnt;

        if(|ReadEnableCnt)
            rd_ptr <= rd_ptr + ReadEnableCnt;

        for(m=0; m<READ_PORTS; m=m+1)
            map_rdport_bank[m] <= map_rdport_bank_d[m];
    end
end


assign UsedCnt = wr_ptr - rd_ptr;
assign FreeCnt = DEPTH - UsedCnt;


//Output valid mask (useful when UsedCnt<READ_PORTS
integer v;
always @* begin
    for(v=0; v<READ_PORTS; v=v+1) begin
        if(v<UsedCnt)
            OutputValidMask[v] = 1'b1;
        else
            OutputValidMask[v] = 1'b0;
    end
end

`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;

    `ifdef DEBUG_IFU_IB
        always @(negedge clk) begin
            if(Flush) begin
                $display("[%t] IFUIB_@STS##: Flush=%b", $time,
                    Flush);
            end
            else begin
                $display("[%t] IFUIB_@STS##: WE=%b FreeCnt=%0d UsedCnt=%0d", $time,
                    WriteEnable, FreeCnt, UsedCnt);
            end
        end
    `endif
`endif

endmodule

