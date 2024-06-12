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

module DCache
#(
parameter DCACHE_TYPE                     = "default",              //D-Cache Type: "stub", "default"
parameter BASE_ADDRESS                    = 64'h00000000_80000000,  //D-Cache Base Address for stub
parameter MEM_TYPE                        = "xpm",                  // "rtl", "xip", "xpm"
parameter MEMORY_INIT_FILE                = "none",
parameter integer C_M_AXI_PBUS_ADDR_WIDTH = 64,
parameter integer C_M_AXI_PBUS_DATA_WIDTH = 32,

parameter integer C_M_AXI_DBUS_ADDR_WIDTH = 64,
parameter integer C_M_AXI_DBUS_DATA_WIDTH = 64
)
(
input  wire clk,
input  wire rst,

//D-Cache Control Request/Responses
input  wire                                 DCache_Enable,
input  wire                                 DCache_Flush_Req,
output wire                                 DCache_Flush_Done,
input  wire                                 DCache_Invalidate_Req,
output wire                                 DCache_Invalidate_Done,

//Request/Responses to D-Cache Read Port
input  wire                                 DCache_RdReq_Valid,
input  wire [55:0]                          DCache_RdReq_Paddr,
input  wire [`DATA_TYPE__LEN-1:0]           DCache_RdReq_DataType,
input  wire                                 DCache_RdReq_Abort,
output wire                                 DCache_RdResp_Done,
output wire                                 DCache_RdResp_Ready,
output wire [63:0]                          DCache_RdResp_Data,

//Request/Responses to D-Cache Write Por    t
input  wire                                 DCache_WrReq_Valid,
input  wire [`DATA_TYPE__LEN-1:0]           DCache_WrReq_DataType,
input  wire [55:0]                          DCache_WrReq_Paddr,
input  wire [63:0]                          DCache_WrReq_Data,
output wire                                 DCache_WrResp_Done,
output wire                                 DCache_WrResp_Ready,

//AXI4 Full Memory Mapped D-Bus Signals
output wire [3:0]                           M_AXI_DBUS_AWID,
output wire [C_M_AXI_DBUS_ADDR_WIDTH-1:0]   M_AXI_DBUS_AWADDR,
output wire [7:0]                           M_AXI_DBUS_AWLEN,
output wire [2:0]                           M_AXI_DBUS_AWSIZE,
output wire [1:0]                           M_AXI_DBUS_AWBURST,
output wire                                 M_AXI_DBUS_AWLOCK,
output wire [3:0]                           M_AXI_DBUS_AWCACHE,
output wire [2:0]                           M_AXI_DBUS_AWPROT,
output wire [3:0]                           M_AXI_DBUS_AWQOS,
output wire                                 M_AXI_DBUS_AWVALID,
input  wire                                 M_AXI_DBUS_AWREADY,
output wire [C_M_AXI_DBUS_DATA_WIDTH-1:0]   M_AXI_DBUS_WDATA,
output wire [C_M_AXI_DBUS_DATA_WIDTH/8-1:0] M_AXI_DBUS_WSTRB,
output wire                                 M_AXI_DBUS_WLAST,
output wire                                 M_AXI_DBUS_WVALID,
input  wire                                 M_AXI_DBUS_WREADY,
input  wire [3:0]                           M_AXI_DBUS_BID,
input  wire [1:0]                           M_AXI_DBUS_BRESP,
input  wire                                 M_AXI_DBUS_BVALID,
output wire                                 M_AXI_DBUS_BREADY,
output wire [3:0]                           M_AXI_DBUS_ARID,
output wire [C_M_AXI_DBUS_ADDR_WIDTH-1:0]   M_AXI_DBUS_ARADDR,
output wire [7:0]                           M_AXI_DBUS_ARLEN,
output wire [2:0]                           M_AXI_DBUS_ARSIZE,
output wire [1:0]                           M_AXI_DBUS_ARBURST,
output wire                                 M_AXI_DBUS_ARLOCK,
output wire [3:0]                           M_AXI_DBUS_ARCACHE,
output wire [2:0]                           M_AXI_DBUS_ARPROT,
output wire [3:0]                           M_AXI_DBUS_ARQOS,
output wire                                 M_AXI_DBUS_ARVALID,
input  wire                                 M_AXI_DBUS_ARREADY,
input  wire [3:0]                           M_AXI_DBUS_RID,
input  wire [C_M_AXI_DBUS_DATA_WIDTH-1:0]   M_AXI_DBUS_RDATA,
input  wire [1:0]                           M_AXI_DBUS_RRESP,
input  wire                                 M_AXI_DBUS_RLAST,
input  wire                                 M_AXI_DBUS_RVALID,
output wire                                 M_AXI_DBUS_RREADY,

//AXI4 Lite Memory Mapped P-Bus Signals
output wire [C_M_AXI_PBUS_ADDR_WIDTH-1:0]   M_AXI_PBUS_AWADDR,
output wire [2:0]                           M_AXI_PBUS_AWPROT,
output wire                                 M_AXI_PBUS_AWVALID,
input  wire                                 M_AXI_PBUS_AWREADY,
output wire [C_M_AXI_PBUS_DATA_WIDTH-1:0]   M_AXI_PBUS_WDATA,
output wire [C_M_AXI_PBUS_DATA_WIDTH/8-1:0] M_AXI_PBUS_WSTRB,
output wire                                 M_AXI_PBUS_WVALID,
input  wire                                 M_AXI_PBUS_WREADY,
input  wire [1:0]                           M_AXI_PBUS_BRESP,
input  wire                                 M_AXI_PBUS_BVALID,
output wire                                 M_AXI_PBUS_BREADY,
output wire [C_M_AXI_PBUS_ADDR_WIDTH-1:0]   M_AXI_PBUS_ARADDR,
output wire [2:0]                           M_AXI_PBUS_ARPROT,
output wire                                 M_AXI_PBUS_ARVALID,
input  wire                                 M_AXI_PBUS_ARREADY,
input  wire [C_M_AXI_PBUS_DATA_WIDTH-1:0]   M_AXI_PBUS_RDATA,
input  wire [1:0]                           M_AXI_PBUS_RRESP,
input  wire                                 M_AXI_PBUS_RVALID,
output wire                                 M_AXI_PBUS_RREADY

);

wire                                 DCache_Req_Valid;
wire                                 DCache_Req_Type;
wire [`DATA_TYPE__LEN-1:0]           DCache_Req_DataType;
wire [55:0]                          DCache_Req_Paddr;
wire [63:0]                          DCache_Req_Wrdata;
wire                                 DCache_Req_Rdabort;
wire                                 DCache_Resp_Done;
wire                                 DCache_Resp_Ready;
wire [63:0]                          DCache_Resp_Rddata; 



localparam Snoop_ReqBus_Width      =64;                    // Snoop Bus width  (Req)       
localparam Cache_Req_width         =322;  
localparam Cache_Resp_Bus_Width    =260;
localparam CORE_ID                 =2'b00;                    //Indicating 

//Snooping Related Signals and DCACHE_Output Signals to the SCU

wire [Snoop_ReqBus_Width-1:0]        Snoop_Request_Bus;  
wire                                 Snoop_Request_Bus_Valid;          

wire [Cache_Req_width-1:0]           Cache_Request_Bus; 
wire                                 Cache_Request_Bus_Valid;

wire [Cache_Resp_Bus_Width-1:0]      Cache_Snoop_Resp_Bus;
wire                                 Cache_Snoop_Resp_Valid;


assign Snoop_Request_Bus=0;
assign Snoop_Request_Bus_Valid=0;


DCache_Arbiter DCache_Arbiter
(
.clk                    (clk),
.rst                    (rst),

.DCache_RdReq_Valid     (DCache_RdReq_Valid),
.DCache_RdReq_Paddr     (DCache_RdReq_Paddr),
.DCache_RdReq_DataType  (DCache_RdReq_DataType),
.DCache_RdReq_Abort     (DCache_RdReq_Abort),
.DCache_RdResp_Done     (DCache_RdResp_Done),
.DCache_RdResp_Ready    (DCache_RdResp_Ready),
.DCache_RdResp_Data     (DCache_RdResp_Data),


.DCache_WrReq_Valid     (DCache_WrReq_Valid),
.DCache_WrReq_DataType  (DCache_WrReq_DataType),
.DCache_WrReq_Paddr     (DCache_WrReq_Paddr),
.DCache_WrReq_Data      (DCache_WrReq_Data),
.DCache_WrResp_Done     (DCache_WrResp_Done),
.DCache_WrResp_Ready    (DCache_WrResp_Ready),


.DCache_Req_Valid       (DCache_Req_Valid),
.DCache_Req_Type        (DCache_Req_Type),
.DCache_Req_DataType    (DCache_Req_DataType),
.DCache_Req_Paddr       (DCache_Req_Paddr),
.DCache_Req_Wrdata      (DCache_Req_Wrdata),
.DCache_Req_Rdabort     (DCache_Req_Rdabort),
.DCache_Resp_Done       (DCache_Resp_Done),
.DCache_Resp_Ready      (DCache_Resp_Ready),
.DCache_Resp_Rddata     (DCache_Resp_Rddata)
);


wire [63:0]   Private_Bus_Address;
wire [63:0]   Private_Bus_Write_Data;
wire [63:0]   Private_Bus_Read_Data;
wire                                 Private_Bus_Write_Read;
wire                                 Private_Bus_Start;
wire                                 Private_Bus_done;
wire                                 Private_Bus_Busy;
wire                                 Private_Bus_Double;
wire                                 Private_Bus_read_write;

DCache_Module
#()
DCACHE
(
.clk                (clk),
.rst                (rst),


.DCache_Enable          (DCache_Enable),
.DCache_Flush_Req       (DCache_Flush_Req),
.DCache_Flush_Done      (DCache_Flush_Done),
.DCache_Invalidate_Req  (DCache_Invalidate_Req),
.DCache_Invalidate_Done (DCache_Invalidate_Done),

.DCache_Req_Valid       (DCache_Req_Valid),
.DCache_Req_Type        (DCache_Req_Type),
.DCache_Req_DataType    (DCache_Req_DataType),
.DCache_Req_Paddr       (DCache_Req_Paddr),
.DCache_Req_Wrdata      (DCache_Req_Wrdata),
.DCache_Req_Rdabort     (DCache_Req_Rdabort),
.DCache_Resp_Done       (DCache_Resp_Done),
.DCache_Resp_Ready      (DCache_Resp_Ready),
.DCache_Resp_Rddata     (DCache_Resp_Rddata),



.Snoop_Request_Bus      (Snoop_Request_Bus),
.Snoop_Request_Bus_Valid(Snoop_Request_Bus_Valid),
// .Bus_Operation_Valid    (Bus_Operation_Valid),

.Snoop_Result_Bus       (),
.Snoop_Result_Bus_Valid (),

.Cache_Request_Bus      (Cache_Request_Bus),
.Cache_Request_Bus_Valid(Cache_Request_Bus_Valid),

.Cache_Snoop_Resp_Bus   (Cache_Snoop_Resp_Bus),
.Cache_Snoop_Resp_Valid (Cache_Snoop_Resp_Valid),
.Private_Bus_Address    (Private_Bus_Address),
.Private_Bus_Write_Data (Private_Bus_Write_Data),
.Private_Bus_Read_Data  (Private_Bus_Read_Data),
.Private_Bus_Write_Read (Private_Bus_Write_Read),

.Private_Bus_Start      (Private_Bus_Start),
.Private_Bus_done       (Private_Bus_done),
.Private_Bus_Busy       (Private_Bus_Busy),
.Private_Bus_Double     (Private_Bus_Double),
.Private_Bus_read_write (Private_Bus_read_write)

// Signals with respect to the AXI Private Bus need to be given
);

///////wrapper Logic----------------------------
wire AccessAllowed_read_reg         =   (Private_Bus_Start && !Private_Bus_read_write)?1'b1:1'b0;
wire AccessAllowed_write_reg        =   (Private_Bus_Start && Private_Bus_read_write)?1'b1:1'b0;
wire read_req_abort                 =   DCache_Req_Rdabort;
wire write_req_reg                  =   (Private_Bus_Start && Private_Bus_read_write)?1'b1:1'b0;
wire read_req_reg                   =   (Private_Bus_Start && !Private_Bus_read_write)?1'b1:1'b0;
wire [63:0] private_data_write      =   Private_Bus_Write_Data;
wire [31:0] private_address_write   =   Private_Bus_Address[31:0];
wire [63:0] private_data_read;
assign Private_Bus_Read_Data        =   private_data_read;
wire [31:0] private_address_read    =   Private_Bus_Address[31:0];
wire is_read_double                 =   Private_Bus_Double;
wire is_write_double                =   Private_Bus_Double;
wire start_burst_full_temp;
wire start_burst                    =   Private_Bus_Start ||  start_burst_full_temp;

// Stripping the Cache_Request_Bus to individual signal 
wire [255:0] Cache_Request_Bus_AXIdata      =Cache_Request_Bus[255:0];
wire [63:0]  Cache_Request_Bus_AXIAddress   =Cache_Request_Bus[311:256];
wire [2:0]   Cache_Request_Bus_Busop_value  =Cache_Request_Bus[314:312];
wire         Cache_Request_Bus_optype       =Cache_Request_Bus[315];
wire         Cache_Request_Bus_double       =Cache_Request_Bus[316];
wire [1:0]   Cache_Request_Bus_burst_length =Cache_Request_Bus[318:317];
wire [2:0]   Cache_Request_Bus_data_type    =Cache_Request_Bus[321:319];

//////////////////////////////////////////////////////////////////////////////
wire            burst_type       = (Cache_Request_Bus_Busop_value==3'b100)?Cache_Request_Bus_optype:((Cache_Request_Bus_Busop_value==3'b110||Cache_Request_Bus_Busop_value==3'b011)?1'b1:1'b0);
wire [63:0]     axi_address      = {8'b0,Cache_Request_Bus_AXIAddress};
wire [255:0]    axi_data_write   = Cache_Request_Bus_AXIdata;
wire [2:0]      data_type        = Cache_Request_Bus_data_type;
wire [2:0]      burst_len_full   = {1'b0,Cache_Request_Bus_burst_length};   

reg Cache_Request_Bus_valid_reg1,Cache_Request_Bus_valid_reg2;
always @(posedge clk)
    begin 
    if(rst) begin
        Cache_Request_Bus_valid_reg1<=1'b0;
        Cache_Request_Bus_valid_reg2<=1'b0;
    end else begin 
        Cache_Request_Bus_valid_reg1<=Cache_Request_Bus_Valid;
        Cache_Request_Bus_valid_reg2<=Cache_Request_Bus_valid_reg1;
    end
 end
 
assign start_burst_full_temp = (Cache_Request_Bus_valid_reg1) && !(Cache_Request_Bus_valid_reg2); 

wire cache_beat;
wire [7 : 0] read_index;
wire [63:0]axi_data_read_input;
wire private_bus_busy;
wire write_done_private;
wire read_done_private;

assign Private_Bus_Busy=private_bus_busy;
assign Private_Bus_done= Private_Bus_read_write?write_done_private:read_done_private;


wire mem_ack_axi_full;
wire start_burst_full;
wire burst_type_full;
wire [63:0]axi_address_full;
wire [255:0]axi_data_write_full;
wire cache_beat_full ;
wire [7 : 0] read_index_full;
wire [63:0]axi_data_read_input_full;
wire mem_ack_private;
wire start_burst_private;
wire burst_type_private;
wire [31:0]address_write_private;
wire [31:0]address_read_private;
wire [31:0]data_write_private;
wire [31:0]data_read_input_private;


wire axi_full_ack;
        
DMem_AXI_FSM AXI_INTERFACE(
        .clk(clk),
        .rst(rst),
        .AccessAllowed_read_reg(AccessAllowed_read_reg),
        .AccessAllowed_write_reg(AccessAllowed_write_reg),
        //DCACHE SIGNALS
        .read_req_abort(read_req_abort),
        .write_req_reg(write_req_reg),
        .read_req_reg(read_req_reg),
    //    .nxstate_dcache(nxstate_dcache),
        .private_data_write(private_data_write),
        .private_address_write(private_address_write),
        .private_data_read(private_data_read),
        .private_address_read(private_address_read),
        .is_read_double(is_read_double),
        .is_write_double(is_write_double),
        .mem_ack(axi_full_ack),
        .start_burst(start_burst),
        .burst_type(burst_type),
        .axi_address(axi_address),
        .axi_data_write(axi_data_write),
        .cache_beat(cache_beat),
        .read_index(read_index),
        .axi_data_read_input(axi_data_read_input),
        .private_bus_busy(private_bus_busy),
        .write_done_private(write_done_private),
        .read_done_private(read_done_private),
        //AXI DBUS
        .mem_ack_axi_full(mem_ack_axi_full),
        .start_burst_full(start_burst_full),
        .burst_type_full(burst_type_full),
        .axi_address_full(axi_address_full),
        .axi_data_write_full(axi_data_write_full),
        .cache_beat_full(cache_beat_full),
        .read_index_full(read_index_full),
        .axi_data_read_input_full(axi_data_read_input_full),
        //AXI LITE
        .mem_ack_private(mem_ack_private),
        .start_burst_private(start_burst_private),
        .burst_type_private(burst_type_private),
        .address_write_private(address_write_private),
        .address_read_private(address_read_private),
        .data_write_private(data_write_private),
        .data_read_input_private(data_read_input_private)
    );

      axi_lite_master_interface_dcache
       #(
           .C_M_AXI_ADDR_WIDTH (C_M_AXI_PBUS_ADDR_WIDTH),
           .C_M_AXI_DATA_WIDTH (C_M_AXI_PBUS_DATA_WIDTH)
       )
       AXI_LITE_BUS
       (
        .mem_done(mem_ack_private),
        .burst_type(burst_type_private),
        .axi_address_read(address_read_private),
        .axi_address_write(address_write_private),
        .axi_data_write(data_write_private),
        .data_read(data_read_input_private),
        .start_burst(start_burst_private),
        .read_resp_error(),
        .write_resp_error(),

        .M_AXI_ACLK    ( clk),
        .M_AXI_ARESETN ( !rst),
        .M_AXI_AWADDR  ( M_AXI_PBUS_AWADDR),
        .M_AXI_AWPROT  ( M_AXI_PBUS_AWPROT),
        .M_AXI_AWVALID ( M_AXI_PBUS_AWVALID),
        .M_AXI_AWREADY ( M_AXI_PBUS_AWREADY),
        .M_AXI_WDATA   ( M_AXI_PBUS_WDATA),
        .M_AXI_WSTRB   ( M_AXI_PBUS_WSTRB),
        .M_AXI_WVALID  ( M_AXI_PBUS_WVALID),
        .M_AXI_WREADY  ( M_AXI_PBUS_WREADY),
        .M_AXI_BRESP   ( M_AXI_PBUS_BRESP),
        .M_AXI_BVALID  ( M_AXI_PBUS_BVALID),
        .M_AXI_BREADY  ( M_AXI_PBUS_BREADY),
        .M_AXI_ARADDR  ( M_AXI_PBUS_ARADDR),
        .M_AXI_ARPROT  ( M_AXI_PBUS_ARPROT),
        .M_AXI_ARVALID ( M_AXI_PBUS_ARVALID),
        .M_AXI_ARREADY ( M_AXI_PBUS_ARREADY),
        .M_AXI_RDATA   ( M_AXI_PBUS_RDATA),
        .M_AXI_RRESP   ( M_AXI_PBUS_RRESP),
        .M_AXI_RVALID  ( M_AXI_PBUS_RVALID),
        .M_AXI_RREADY  ( M_AXI_PBUS_RREADY)
    );
    
    axi_master_interface_dcache
   #(
       .C_M_AXI_ADDR_WIDTH (C_M_AXI_DBUS_ADDR_WIDTH),
       .C_M_AXI_DATA_WIDTH (C_M_AXI_DBUS_DATA_WIDTH)
   )
   AXI_FULL_BUS
   (
        .mem_done(mem_ack_axi_full),
        .burst_type(burst_type_full),
        .axi_address(axi_address_full),
        .burst_len(burst_len_full),
        .data_type(data_type),
        .axi_data_write(axi_data_write_full),
        .data_read(axi_data_read_input_full),
        .start_burst(start_burst_full),
        .read_index(read_index_full),
        .read_resp_error(),
        .write_resp_error(),
        .cache_beat(cache_beat_full),
        .M_AXI_ACLK    ( clk),
        .M_AXI_ARESETN ( !rst),
        .M_AXI_AWID    ( M_AXI_DBUS_AWID),
        .M_AXI_AWADDR  ( M_AXI_DBUS_AWADDR),
        .M_AXI_AWLEN   ( M_AXI_DBUS_AWLEN),
        .M_AXI_AWSIZE  ( M_AXI_DBUS_AWSIZE),
        .M_AXI_AWBURST ( M_AXI_DBUS_AWBURST),
        .M_AXI_AWLOCK  ( M_AXI_DBUS_AWLOCK),
        .M_AXI_AWCACHE ( M_AXI_DBUS_AWCACHE),
        .M_AXI_AWPROT  ( M_AXI_DBUS_AWPROT),
        .M_AXI_AWQOS   ( M_AXI_DBUS_AWQOS),
        .M_AXI_AWVALID ( M_AXI_DBUS_AWVALID),
        .M_AXI_AWREADY ( M_AXI_DBUS_AWREADY),
        .M_AXI_WDATA   ( M_AXI_DBUS_WDATA),
        .M_AXI_WSTRB   ( M_AXI_DBUS_WSTRB),
        .M_AXI_WLAST   ( M_AXI_DBUS_WLAST),
        .M_AXI_WVALID  ( M_AXI_DBUS_WVALID),
        .M_AXI_WREADY  ( M_AXI_DBUS_WREADY),
        .M_AXI_BID     ( M_AXI_DBUS_BID),
        .M_AXI_BRESP   ( M_AXI_DBUS_BRESP),
        .M_AXI_BVALID  ( M_AXI_DBUS_BVALID),
        .M_AXI_BREADY  ( M_AXI_DBUS_BREADY),
        .M_AXI_ARID    ( M_AXI_DBUS_ARID),
        .M_AXI_ARADDR  ( M_AXI_DBUS_ARADDR),
        .M_AXI_ARLEN   ( M_AXI_DBUS_ARLEN),
        .M_AXI_ARSIZE  ( M_AXI_DBUS_ARSIZE),
        .M_AXI_ARBURST ( M_AXI_DBUS_ARBURST),
        .M_AXI_ARLOCK  ( M_AXI_DBUS_ARLOCK),
        .M_AXI_ARCACHE ( M_AXI_DBUS_ARCACHE),
        .M_AXI_ARPROT  ( M_AXI_DBUS_ARPROT),
        .M_AXI_ARQOS   ( M_AXI_DBUS_ARQOS),
        .M_AXI_ARVALID ( M_AXI_DBUS_ARVALID),
        .M_AXI_ARREADY ( M_AXI_DBUS_ARREADY),
        .M_AXI_RID     ( M_AXI_DBUS_RID),
        .M_AXI_RDATA   ( M_AXI_DBUS_RDATA),
        .M_AXI_RRESP   ( M_AXI_DBUS_RRESP),
        .M_AXI_RLAST   ( M_AXI_DBUS_RLAST),
        .M_AXI_RVALID  ( M_AXI_DBUS_RVALID),
        .M_AXI_RREADY  ( M_AXI_DBUS_RREADY)
    );
    
reg [255:0]axi_data_read;

always @ (posedge clk) begin
    if (rst || start_burst)
      axi_data_read <= 256'd0;
    else if (cache_beat) begin
      case (read_index)
        8'd0: axi_data_read[63:0] <= axi_data_read_input;
        8'd1: axi_data_read[127:64] <= axi_data_read_input;
        8'd2: axi_data_read[191:128] <= axi_data_read_input;
        8'd3: axi_data_read[255:192] <= axi_data_read_input;
        default: axi_data_read <= axi_data_read;
      endcase
    end
end
 
reg axi_full_Ack_reg;

always @(posedge clk)
begin
    if(rst)begin
      axi_full_Ack_reg<=0;
    end else begin
      axi_full_Ack_reg<=axi_full_ack;
    end 
end
   
//creating the Cache_Snoop_Resp_Bus
assign Cache_Snoop_Resp_Bus [255:0]         = axi_data_read;
assign Cache_Snoop_Resp_Bus [257:256]       = CORE_ID;
assign Cache_Snoop_Resp_Bus [259:258]       = (Cache_Request_Bus_Busop_value==3'b100)?2'b00:2'b10;

assign Cache_Snoop_Resp_Valid               = axi_full_Ack_reg;


endmodule
