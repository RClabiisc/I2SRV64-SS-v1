//******************************************************************************
// Copyright (c) 2018 - 2023, Indian Institute of Science, Bangalore.
// All Rights Reserved. See LICENSE for license details.
//------------------------------------------------------------------------------

// Contributors // Manish Kumar(manishkumar5@iisc.ac.in), Shubham Yadav(shubhamyadav@iisc.ac.in)
// Sajin S (sajins@alum.iisc.ac.in, Shubham Sunil Garag (shubhamsunil@alum.iisc.ac.in)
// Anuj Phegade (anujphegade@alum.iisc.ac.in), Deepshikha Gusain (deepshikhag@alum.iisc.ac.in)
// Ronit Patel (ronitpatel@alum.iisc.ac.in), Vishal Kumar (vishalkumar@alum.iisc.ac.in)
// Kuruvilla Varghese (kuru@iisc.ac.in)
//******************************************************************************
`timescale 1 ns / 1 ps

(* keep_hierarchy = "yes" *)
module CLINT_v1_0 #
(
    // Users to add parameters here
    parameter integer C_CLINT_HARTS         = 1,

    // User parameters ends
    // Do not modify the parameters beyond this line

    // Width of S_AXI data bus
    parameter integer C_S_AXI_DATA_WIDTH    = 64,   //32 or 64 CLINT Compliant with both
    // Width of S_AXI address bus
    parameter integer C_S_AXI_ADDR_WIDTH    = 64    //minimum 16 is required
)
(
    // Users to add ports here
    input  wire                                 clk,
    input  wire                                 rst,
    input  wire                                 rt_clk,

    output wire [63:0]                          CLINT_time,
    output wire [C_CLINT_HARTS-1:0]             machine_software_irq_req,
    output wire [C_CLINT_HARTS-1:0]             machine_timer_irq_req,
    // User ports ends

    input  wire [C_S_AXI_ADDR_WIDTH-1:0]        S_AXI_AWADDR,  // Write address (issued by master, acceped by Slave)
    input  wire [2:0]                           S_AXI_AWPROT,  // Write channel Protection type
    input  wire                                 S_AXI_AWVALID, // Write address valid
    output wire                                 S_AXI_AWREADY, // Write address ready
    input  wire [C_S_AXI_DATA_WIDTH-1:0]        S_AXI_WDATA,   // Write data (issued by master, acceped by Slave)
    input  wire [(C_S_AXI_DATA_WIDTH/8)-1:0]    S_AXI_WSTRB,   // Write strobes
    input  wire                                 S_AXI_WVALID,  // Write valid
    output wire                                 S_AXI_WREADY,  // Write ready
    output wire [1:0]                           S_AXI_BRESP,   // Write response
    output wire                                 S_AXI_BVALID,  // Write response valid
    input  wire                                 S_AXI_BREADY,  // Response ready
    input  wire [C_S_AXI_ADDR_WIDTH-1:0]        S_AXI_ARADDR,  // Read address (issued by master, acceped by Slave)
    input  wire [2:0]                           S_AXI_ARPROT,  // Protection type
    input  wire                                 S_AXI_ARVALID, // Read address valid
    output wire                                 S_AXI_ARREADY, // Read address ready
    output wire [C_S_AXI_DATA_WIDTH-1:0]        S_AXI_RDATA,   // Read data (issued by slave)
    output wire [1:0]                           S_AXI_RRESP,   // Read response
    output wire                                 S_AXI_RVALID,  // Read valid
    input  wire                                 S_AXI_RREADY   // Read ready
);

//assign clock for AXI
wire S_AXI_ACLK    = clk;
wire S_AXI_ARESETN = ~rst;

// AXI4LITE signals
reg [C_S_AXI_ADDR_WIDTH-1 : 0]  axi_awaddr;
reg     axi_awready;
reg     axi_wready;
reg [1 : 0]     axi_bresp;
reg     axi_bvalid;
reg [C_S_AXI_ADDR_WIDTH-1 : 0]  axi_araddr;
reg     axi_arready;
reg [C_S_AXI_DATA_WIDTH-1 : 0]  axi_rdata;
reg [1 : 0]     axi_rresp;
reg     axi_rvalid;

// Example-specific design signals
// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
// ADDR_LSB is used for addressing 32/64 bit registers/memories
// ADDR_LSB = 2 for 32 bits (n downto 2)
// ADDR_LSB = 3 for 64 bits (n downto 3)
localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;

//----------------------------------------------
//-- Signals for user logic register space example
//------------------------------------------------
reg         msip    [0:C_CLINT_HARTS-1];
reg [63:0]  mtimecmp[0:C_CLINT_HARTS-1];
reg [63:0]  mtime;

//next values
reg         msip_d      [0:C_CLINT_HARTS-1];
reg [63:0]  mtimecmp_d  [0:C_CLINT_HARTS-1];
reg [63:0]  mtime_d;

//synchronised mtime increment pulse
wire        incr_mtime;

wire     slv_reg_rden;
wire     slv_reg_wren;
wire [C_S_AXI_DATA_WIDTH-1:0]     reg_data_out;
integer  byte_index;
reg  aw_en;

// I/O Connections assignments
assign S_AXI_AWREADY    = axi_awready;
assign S_AXI_WREADY = axi_wready;
assign S_AXI_BRESP  = axi_bresp;
assign S_AXI_BVALID = axi_bvalid;
assign S_AXI_ARREADY    = axi_arready;
assign S_AXI_RDATA  = axi_rdata;
assign S_AXI_RRESP  = axi_rresp;
assign S_AXI_RVALID = axi_rvalid;

// Implement axi_awready generation
// axi_awready is asserted for one S_AXI_ACLK clock cycle when both
// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
// de-asserted when reset is low.
always @(posedge S_AXI_ACLK) begin
    if(S_AXI_ARESETN==1'b0) begin
            axi_awready <= 1'b0;
            aw_en <= 1'b1;
    end
    else begin
        if(~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en) begin
            // slave is ready to accept write address when
            // there is a valid write address and write data
            // on the write address and data bus. This design
            // expects no outstanding transactions.
            axi_awready <= 1'b1;
            aw_en <= 1'b0;
        end
        else if(S_AXI_BREADY && axi_bvalid) begin
            aw_en <= 1'b1;
            axi_awready <= 1'b0;
        end
        else begin
            axi_awready <= 1'b0;
        end
    end
end

// Implement axi_awaddr latching
// This process is used to latch the address when both
// S_AXI_AWVALID and S_AXI_WVALID are valid.
always @(posedge S_AXI_ACLK) begin
    if(S_AXI_ARESETN == 1'b0) begin
        axi_awaddr <= 0;
    end
    else begin
        if(~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en) begin
            // Write Address latching
            axi_awaddr <= S_AXI_AWADDR;
        end
    end
end

// Implement axi_wready generation
// axi_wready is asserted for one S_AXI_ACLK clock cycle when both
// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is
// de-asserted when reset is low.
always @(posedge S_AXI_ACLK) begin
    if(S_AXI_ARESETN == 1'b0) begin
        axi_wready <= 1'b0;
    end
    else begin
        if(~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en) begin
            // slave is ready to accept write data when
            // there is a valid write address and write data
            // on the write address and data bus. This design
            // expects no outstanding transactions.
            axi_wready <= 1'b1;
        end
        else begin
            axi_wready <= 1'b0;
        end
    end
end

// Implement memory mapped register select and write logic generation
// The write data is accepted and written to memory mapped registers when
// axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
// select byte enables of slave registers while writing.
// These registers are cleared when reset (active low) is applied.
// Slave register write enable is asserted when valid address and data are available
// and the slave is ready to accept the write address and write data.
assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

//Register next values process
integer i;
//align strobe as per addr bit 2 and data bus width
wire [7:0]  axi_wstrobe;
wire [63:0] axi_wdata;
generate
    if(C_S_AXI_DATA_WIDTH==32) begin
        assign axi_wstrobe = axi_awaddr[2] ? {S_AXI_WSTRB,4'b0}   : {4'b0,S_AXI_WSTRB};
        assign axi_wdata   = axi_awaddr[2] ? {S_AXI_WDATA, 32'd0} : {32'd0, S_AXI_WDATA};
    end
    else begin
        assign axi_wstrobe = S_AXI_WSTRB;
        assign axi_wdata   = S_AXI_WDATA;
    end
endgenerate
always @(*) begin
    //copy old values
    for(i=0; i<C_CLINT_HARTS; i=i+1) begin
        msip_d[i]     = msip[i];
        mtimecmp_d[i] = mtimecmp[i];
    end

    //update mtime from synchronized rtc_clk (real time clock)
    if(incr_mtime)
        mtime_d = mtime + 64'h1;
    else
        mtime_d = mtime;

    //next value writing logic
    if(slv_reg_wren) begin
        if(axi_awaddr[15:14]==2'b00) begin //0000 + hart => msip
            if((axi_awaddr[13:2]<C_CLINT_HARTS  ) && (axi_wstrobe[0]==1'b1))
                msip_d[axi_awaddr[13:2]  ]  = axi_wdata[0];
            if((axi_awaddr[13:2]<C_CLINT_HARTS-1) && (axi_wstrobe[4]==1'b1))
                msip_d[axi_awaddr[13:2]+1]  = axi_wdata[32];
        end
        else if(axi_awaddr[15:14]==2'b01) begin //4000 + hart => mtimecmp
            if(axi_awaddr[13:3]<C_CLINT_HARTS) begin
                for (byte_index=0; byte_index<8; byte_index=byte_index+1) begin
                    if(axi_wstrobe[byte_index]==1'b1)
                        mtimecmp_d[axi_awaddr[13:3]][(byte_index*8)+:8] = axi_wdata[(byte_index*8)+:8];
                end
            end
        end
        else if(axi_awaddr[15:3]==13'h17FF) begin //bff8 => mtime
            for (byte_index=0; byte_index<8; byte_index=byte_index+1) begin
                if(axi_wstrobe[byte_index]==1'b1)
                    mtime_d[(byte_index*8)+:8] = axi_wdata[(byte_index*8)+:8];
            end
        end
    end
end

//Register writing process
integer j;
always @(posedge S_AXI_ACLK) begin
    if(S_AXI_ARESETN == 1'b0) begin
        for(j=0; j<C_CLINT_HARTS; j=j+1) begin
            msip[j]     <= 1'b0;
            mtimecmp[j] <= 64'hFFFFFFFF_00000000;
        end
        mtime <= 64'h0;
    end
    else begin
        for(j=0; j<C_CLINT_HARTS; j=j+1) begin
            msip[j]     <= msip_d[j];
            mtimecmp[j] <= mtimecmp_d[j];
        end
        mtime <= mtime_d;
    end
end

// Implement write response logic generation
// The write response and response valid signals are asserted by the slave
// when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.
// This marks the acceptance of address and indicates the status of
// write transaction.
always @(posedge S_AXI_ACLK)
begin
    if(S_AXI_ARESETN == 1'b0) begin
        axi_bvalid  <= 0;
        axi_bresp   <= 2'b0;
    end
    else begin
        if(axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID) begin
            // indicates a valid write response is available
            axi_bvalid <= 1'b1;
            axi_bresp  <= 2'b0; // 'OKAY' response
        end                                     // work error responses in future
        else begin
            if(S_AXI_BREADY && axi_bvalid) begin
                //check if bready is asserted while bvalid is high)
                //(there is a possibility that bready is always asserted high)

                axi_bvalid <= 1'b0;
            end
        end
    end
end

// Implement axi_arready generation
// axi_arready is asserted for one S_AXI_ACLK clock cycle when
// S_AXI_ARVALID is asserted. axi_awready is
// de-asserted when reset (active low) is asserted.
// The read address is also latched when S_AXI_ARVALID is
// asserted. axi_araddr is reset to zero on reset assertion.
always @(posedge S_AXI_ACLK)
begin
    if(S_AXI_ARESETN == 1'b0) begin
        axi_arready <= 1'b0;
        axi_araddr  <= {C_S_AXI_ADDR_WIDTH{1'b0}};
    end
    else begin
        if(~axi_arready && S_AXI_ARVALID) begin
            // indicates that the slave has acceped the valid read address
            axi_arready <= 1'b1;
            // Read address latching
            axi_araddr  <= S_AXI_ARADDR;
        end
        else begin
            axi_arready <= 1'b0;
        end
    end
end

// Implement axi_arvalid generation
// axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both
// S_AXI_ARVALID and axi_arready are asserted. The slave registers
// data are available on the axi_rdata bus at this instance. The
// assertion of axi_rvalid marks the validity of read data on the
// bus and axi_rresp indicates the status of read transaction.axi_rvalid
// is deasserted on reset (active low). axi_rresp and axi_rdata are
// cleared to zero on reset (active low).
always @(posedge S_AXI_ACLK)
begin
    if(S_AXI_ARESETN == 1'b0) begin
        axi_rvalid <= 0;
        axi_rresp  <= 0;
    end
    else begin
        if(axi_arready && S_AXI_ARVALID && ~axi_rvalid) begin
            // Valid read data is available at the read data bus
            axi_rvalid <= 1'b1;
            axi_rresp  <= 2'b0; // 'OKAY' response
        end
        else if(axi_rvalid && S_AXI_RREADY) begin
            // Read data is accepted by the master
            axi_rvalid <= 1'b0;
        end
    end
end


// Implement memory mapped register select and read logic generation
// Slave register read enable is asserted when valid address is available
// and the slave is ready to accept the read address.
assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;
reg [63:0] reg_data_out64;
always @(*) begin
    reg_data_out64 = 0;
    // Address decoding for reading registers
    if(axi_araddr[15:14]==2'b00) begin //0000 + hart => msip
        if(axi_araddr[13:2]<C_CLINT_HARTS)
            reg_data_out64[0]  = msip[axi_araddr[13:2]  ];
        if(axi_araddr[13:2]<C_CLINT_HARTS-1)
            reg_data_out64[32] = msip[axi_araddr[13:2]+1];

    end
    else if(axi_araddr[15:14]==2'b01) begin //4000 + hart => mtimecmp
        if(axi_araddr[13:3]<C_CLINT_HARTS) begin
            reg_data_out64 = mtimecmp[axi_araddr[13:3]];
        end
    end
    else if(axi_araddr[15:3]==13'h17FF) begin //bff8 => mtime
        reg_data_out64 = mtime;
    end
end

//shift word as per rd_addr bit2
generate
    if(C_S_AXI_DATA_WIDTH==32)
        assign reg_data_out = axi_araddr[2] ? reg_data_out64[63:32] : reg_data_out64[31:0];
    else
        assign reg_data_out = reg_data_out64;
endgenerate

// Output register or memory read data
always @(posedge S_AXI_ACLK)
begin
    if(S_AXI_ARESETN == 1'b0) begin
        axi_rdata  <= 0;
    end
    else begin
        // When there is a valid read address (S_AXI_ARVALID) with
        // acceptance of read address by the slave (axi_arready),
        // output the read dada
        if(slv_reg_rden) begin
            axi_rdata <= reg_data_out;       // register read data
        end
    end
end

// Add user logic here
/**************************************
*  Timer Interrupt Generation Logic  *
**************************************/
//Timer interrupt is generated when mtime >= mtimecmp for a hart.
genvar gt;
generate
    for(gt=0; gt<C_CLINT_HARTS; gt=gt+1) begin
        assign machine_timer_irq_req[gt] = (mtime >= mtimecmp[gt]);
    end
endgenerate

/*****************************************
*  Software Interrupt Generation Logic  *
*****************************************/
//Software Inerrupt is generated when msip is set.
genvar gs;
generate
    for(gs=0; gs<C_CLINT_HARTS; gs=gs+1) begin
        assign machine_software_irq_req[gs] = msip[gs];
    end
endgenerate

/************************************
*  RT Clk to SysClk Synchronizer  *
************************************/
wire rt_clk_sync;

//synchronise rt_clk to clk domain
//Assumption: period(rt_clk) > period(clk)
xpm_cdc_single
#(
    .DEST_SYNC_FF(2),   // DECIMAL; range: 2-10
    .INIT_SYNC_FF(0),   // DECIMAL; 0=disable simulation init values, 1=enable simulation init values
    .SIM_ASSERT_CHK(0), // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
    .SRC_INPUT_REG(0)   // DECIMAL; 0=do not register input, 1=register input
)
clint_rtclk_sync
(
    .dest_out     (rt_clk_sync  ), // 1-bit output: src_in synchronized to the destination clock domain. This output is registered.
    .dest_clk     (clk          ), // 1-bit input: Clock signal for the destination clock domain.
    .src_clk      (1'b0         ), // 1-bit input: optional; required when SRC_INPUT_REG = 1
    .src_in       (rt_clk       )  // 1-bit input: Input signal to be synchronized to dest_clk domain.
);

//convert synchronised rt_clk level to pulse in "clk" clock domain on rising
//edge of level
reg rt_clk_sync_q;
always @(posedge clk) begin
    if(rst)
        rt_clk_sync_q <= 0;
    else
        rt_clk_sync_q <= rt_clk_sync;
end

assign incr_mtime = (~rt_clk_sync_q) & rt_clk_sync;

//make mtime available as output time
assign CLINT_time = mtime;

// User logic ends


endmodule

