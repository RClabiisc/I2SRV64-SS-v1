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

(* keep_hierarchy = "yes" *)
module ICache
#(
    parameter ICACHE_TYPE                         = "default",                //I-Cache Type: "stub", "default"
    parameter BASE_ADDRESS                        = 64'h00000000_80000000,    //I-Cache Base Address For Stub
    parameter MEM_TYPE                            = "xpm",                    //Memory Type: "rtl", "xip", "xpm"
    parameter MEMORY_INIT_FILE                    = "none",                   //Memory Init File Name for Stub
    parameter integer C_M_AXI_IBUS_ADDR_WIDTH     = 64,
    parameter integer C_M_AXI_IBUS_DATA_WIDTH     = 64
)
(
    input  wire                                 clk,
    input  wire                                 rst,

    input  wire [`XLEN-1:0]                     csr_satp,
    input  wire [`PRIV_LVL__LEN-1:0]            csr_status_priv_lvl,
    input  wire [(16*8)-1:0]                    csr_pmpcfg_array,
    input  wire [(16*54)-1:0]                   csr_pmpaddr_array,

    input  wire                                 ICache_Enable,   //Not used further
    input  wire                                 ITLB_Enable,     // Not used further
    input  wire                                 PMA_Check_Enable,
    input  wire                                 ICache_Flush_Req,
    output reg                                  ICache_Flush_Done,
    input  wire                                 ITLB_Flush_Req,
    input  wire [`SATP_ASID_LEN-1:0]            ITLB_Flush_Req_ASID,
    input  wire [`XLEN-1:0]                     ITLB_Flush_Req_Vaddr,
    output reg                                  ITLB_Flush_Done,

    output wire                                 ICache_Resp_Hit,
    output wire [`ICACHE_LINE_LEN-1:0]          ICache_Resp_Line,
    input  wire [`XLEN-1:0]                     ICache_Req_FetchPC,
    output wire                                 ICache_Resp_Exception,
    output wire [`ECAUSE_LEN-1:0]               ICache_Resp_ECause,

    output wire                                  DCache_RdReq_IPTW_Valid,
    output wire [55:0]                          DCache_RdReq_IPTW_Paddr,
    output wire [`DATA_TYPE__LEN-1:0]           DCache_RdReq_IPTW_DataType,
    input  wire [63:0]                          DCache_RdResp_IPTW_Data,
    input  wire                                 DCache_RdResp_IPTW_Done,

    //AXI4 Full Memory Mapped I-Bus Signals
    output wire [3:0]                           M_AXI_IBUS_AWID,
    output wire [C_M_AXI_IBUS_ADDR_WIDTH-1:0]   M_AXI_IBUS_AWADDR,
    output wire [7:0]                           M_AXI_IBUS_AWLEN,
    output wire [2:0]                           M_AXI_IBUS_AWSIZE,
    output wire [1:0]                           M_AXI_IBUS_AWBURST,
    output wire                                 M_AXI_IBUS_AWLOCK,
    output wire [3:0]                           M_AXI_IBUS_AWCACHE,
    output wire [2:0]                           M_AXI_IBUS_AWPROT,
    output wire [3:0]                           M_AXI_IBUS_AWQOS,
    output wire                                 M_AXI_IBUS_AWVALID,
    input  wire                                 M_AXI_IBUS_AWREADY,

    output wire [C_M_AXI_IBUS_DATA_WIDTH-1:0]   M_AXI_IBUS_WDATA,
    output wire [C_M_AXI_IBUS_DATA_WIDTH/8-1:0] M_AXI_IBUS_WSTRB,
    output wire                                 M_AXI_IBUS_WLAST,
    output wire                                 M_AXI_IBUS_WVALID,
    input  wire                                 M_AXI_IBUS_WREADY,

    input  wire [3:0]                           M_AXI_IBUS_BID,
    input  wire [1:0]                           M_AXI_IBUS_BRESP,
    input  wire                                 M_AXI_IBUS_BVALID,
    output wire                                 M_AXI_IBUS_BREADY,

    output wire [3:0]                           M_AXI_IBUS_ARID,
    output wire [C_M_AXI_IBUS_ADDR_WIDTH-1:0]   M_AXI_IBUS_ARADDR,
    output wire [7:0]                           M_AXI_IBUS_ARLEN,
    output wire [2:0]                           M_AXI_IBUS_ARSIZE,
    output wire [1:0]                           M_AXI_IBUS_ARBURST,
    output wire                                 M_AXI_IBUS_ARLOCK,
    output wire [3:0]                           M_AXI_IBUS_ARCACHE,
    output wire [2:0]                           M_AXI_IBUS_ARPROT,
    output wire [3:0]                           M_AXI_IBUS_ARQOS,
    output wire                                 M_AXI_IBUS_ARVALID,
    input  wire                                 M_AXI_IBUS_ARREADY,

    input  wire [3:0]                           M_AXI_IBUS_RID,
    input  wire [C_M_AXI_IBUS_DATA_WIDTH-1:0]   M_AXI_IBUS_RDATA,
    input  wire [1:0]                           M_AXI_IBUS_RRESP,
    input  wire                                 M_AXI_IBUS_RLAST,
    input  wire                                 M_AXI_IBUS_RVALID,
    output wire                                 M_AXI_IBUS_RREADY
);


/*******************Local Parameter modes definition ***************************/
localparam Machine_Mode = 2'b11;
localparam Super_Mode   = 2'b01;
localparam User_Mode    = 2'b00;


localparam Cache_offset_end=0;
localparam Cache_offset_start=4;
localparam Cache_Index_end=5;
localparam Cache_Index_start=11;
localparam Cache_tag_start = 55;
localparam Cache_tag_end = 12;
localparam Cacheline_tag_start=`ICACHE_TAG_WIDTH + `ICACHE_LINE_LEN - 1;
localparam Cacheline_tag_end  = `ICACHE_LINE_LEN;

//PTE 

localparam V=0;
localparam R=1;
localparam W=2;
localparam X=3;
localparam U=4;
localparam G=5;
localparam A=6;
localparam D=7;

/***************** ICache and I TLB subsystem **********************************/
/* ICache consist of 4 way set associative cache and associated valid bit, Valid bit 
is created using seperate register 
Both I Cache as well as the Valid bit is having one cycle latency
As page size is 4Kb, page offset bits are 12 bit. This is same in both virtual and physical
address, Hence I Cache data can be read same time as TLB data is accessed.
Virually Indexed physically tagged Cache
*/



localparam MEM_DEPTH = 128;
localparam MEM_WIDTH = `ICACHE_TAG_WIDTH + `ICACHE_LINE_LEN;  //300

wire [MEM_WIDTH-1:0] ICache_Dout[0:3]   ;      // Output from each of the Caches
wire [$clog2(MEM_DEPTH)-1:0] ICache_Addr;     //
wire [MEM_WIDTH-1:0] ICache_Din         ;     // Physical Tag (44 bit) + data (26bits)
reg [3:0]           ICache_Wen         ;


assign ICache_Din = {Physical_PageNum,ICache_Axi_Read_Data};

assign ICache_Addr=(pr_state==IDLE)?ICache_Req_FetchPC[Cache_Index_start:Cache_Index_end]:FetchPC_Reg[Cache_Index_start:Cache_Index_end];

genvar gi;
generate
    for (gi=0; gi<4; gi=gi+1) begin
    
            xpm_memory_spram #(
            .ADDR_WIDTH_A        ($clog2( MEM_DEPTH) ),
            .AUTO_SLEEP_TIME     (0                  ),
            .BYTE_WRITE_WIDTH_A  (MEM_WIDTH          ),
            .CASCADE_HEIGHT      (0                  ),
            .ECC_MODE            ("no_ecc"           ),
            .MEMORY_INIT_FILE    ("none"             ),
            .MEMORY_INIT_PARAM   ("0"                ),
            .MEMORY_OPTIMIZATION ("true"             ),
            .MEMORY_PRIMITIVE    ("block"            ),
            .MEMORY_SIZE         (MEM_DEPTH*MEM_WIDTH),
            .MESSAGE_CONTROL     (0                  ),
            .READ_DATA_WIDTH_A   (MEM_WIDTH          ),
            .READ_LATENCY_A      (1                  ),
            .READ_RESET_VALUE_A  ("0"                ),
            .RST_MODE_A          ("SYNC"             ),
            .SIM_ASSERT_CHK      (0                  ),
            .USE_MEM_INIT        (0                  ),
            .WAKEUP_TIME         ("disable_sleep"    ),
            .WRITE_DATA_WIDTH_A  (MEM_WIDTH          ),
            .WRITE_MODE_A        ("write_first"      )
        )
        mem (
            .dbiterra       (                ),
            .douta          (ICache_Dout[gi] ),
            .sbiterra       (                ),
            .addra          (ICache_Addr     ),
            .clka           (clk             ),
            .dina           (ICache_Din      ),
            .ena            (1'b1            ),
            .injectdbiterra (1'b0            ),
            .injectsbiterra (1'b0            ),
            .regcea         (1'b1            ),
            .rsta           (rst             ),
            .sleep          (1'b0            ),
            .wea            (ICache_Wen[gi]  )
        );   
    end
endgenerate

// 4 Way Valid Bit; Both read and write latency is set to 1 clock cycle;
 
reg [MEM_DEPTH-1:0]         ICache_Valid_Way0,  ICache_Valid_Way1 , ICache_Valid_Way2, ICache_Valid_Way3;
wire [$clog2(MEM_DEPTH)-1:0 ]ICache_Valid_WAddr, ICache_Valid_RAddr;
reg ICache_Valid_Wen0,  ICache_Valid_Wen1,  ICache_Valid_Wen2,  ICache_Valid_Wen3;
reg ICache_Valid_dout0, ICache_Valid_dout1, ICache_Valid_dout2,  ICache_Valid_dout3;

wire ICache_Valid_din=1'b1; //generally valid bit change is from 0 to 1 only; 
                           // 1 to 0 happens only in the case a flush is happening 
                          //  Flush is provided seperately as reset condition

//Write to Valid bit

assign ICache_Valid_WAddr=ICache_Addr;
assign ICache_Valid_RAddr=ICache_Addr;

always @(posedge clk) 
begin 
    if(rst || ICache_Flush_Req) begin 
        ICache_Valid_Way0 <= 0;
        ICache_Valid_Way1 <= 0;
        ICache_Valid_Way2 <= 0;
        ICache_Valid_Way3 <= 0;
    end 
    else begin 
        if (ICache_Valid_Wen0) begin 
            ICache_Valid_Way0[ICache_Valid_WAddr]= ICache_Valid_din;
        end
        
        if (ICache_Valid_Wen1) begin 
            ICache_Valid_Way1[ICache_Valid_WAddr]= ICache_Valid_din;
        end
        
        if (ICache_Valid_Wen2) begin 
            ICache_Valid_Way2[ICache_Valid_WAddr]= ICache_Valid_din;
        end
        
        if (ICache_Valid_Wen3) begin 
            ICache_Valid_Way3[ICache_Valid_WAddr]= ICache_Valid_din;
        end
    end
end

// Read Latency of Valid bit

always @(posedge clk)
begin 
    if(rst || ICache_Flush_Req) begin 
        ICache_Valid_dout0<=0;
        ICache_Valid_dout1<=0;
        ICache_Valid_dout2<=0;
        ICache_Valid_dout3<=0;    
    end else begin 
        ICache_Valid_dout0<=ICache_Valid_Way0[ICache_Valid_RAddr];
        ICache_Valid_dout1<=ICache_Valid_Way1[ICache_Valid_RAddr];
        ICache_Valid_dout2<=ICache_Valid_Way2[ICache_Valid_RAddr];
        ICache_Valid_dout3<=ICache_Valid_Way3[ICache_Valid_RAddr];
    end
end 


//Instantiation of PLRU for I Cache, We need to choose which way is getting replaced
wire [$clog2(MEM_DEPTH)-1:0 ] ICache_PLRU_Read_Set, ICache_PLRU_Write_Set;
reg PLRU_Read_Access, PLRU_Write_Access;
wire [1:0] PLRU_ReadWay, PLRU_Way;

assign ICache_PLRU_Read_Set =ICache_Addr;
assign ICache_PLRU_Write_Set=ICache_Addr;

assign  PLRU_ReadWay=ICache_Read_way;
PLRU4 #(.SETS(128)) ICachePLRU4
(
    .clk(clk),
    .rst(rst),
    .UpdateEn(1'b1),
    .ReadSet(ICache_PLRU_Read_Set),      // Cache set number being read
    .ReadWay(PLRU_ReadWay),      // 1=>Cache Way which is hit on read operation
    .ReadAccess(PLRU_Read_Access),   // 1=>Cache Read Operation
    .WriteSet(ICache_PLRU_Write_Set),     // Cache set number for cache write operation
    .WriteWay(PLRU_Way),     // Cache Way where write operation will happen (if not known already, connect to PLRU_Way output externally)
    .WriteAccess(PLRU_Write_Access),  // Cacge Write Operation
    .LRU_Way(PLRU_Way)       // LRU Way
);
/******************************Instantiation of the AXI Master Interface**************/

reg           ICache_Axi_start_burst;
wire  [7:0]   ICache_Axi_burst_len; 
wire  [63:0]  ICache_Axi_read_address;
wire  [7:0]   ICache_Axi_read_index;
wire  [63:0]  ICache_Axi_data_read;
wire          ICache_Axi_mem_done;
wire          ICache_Axi_cache_beat;
wire          ICache_Axi_read_resp_error;

assign ICache_Axi_burst_len=8'd3; 
assign ICache_Axi_read_address={8'b0,Physical_PageNum,FetchPC_Reg[11:5],5'b0};

axi_master_interface_1
#(
    .C_M_AXI_ADDR_WIDTH         (C_M_AXI_IBUS_ADDR_WIDTH        ),
    .C_M_AXI_DATA_WIDTH         (C_M_AXI_IBUS_DATA_WIDTH        )
)
AXI_M_IBUS
(
        .start_burst(ICache_Axi_start_burst),
        .burst_len(ICache_Axi_burst_len),                           // burst len  (= 4 for icache) (= 1 for itlb)
        .read_address(ICache_Axi_read_address),                     // physical address in case of cache miss , virtual address in case of tlb miss
        .data_read(ICache_Axi_data_read),
        .read_index(ICache_Axi_read_index),
        .mem_done(ICache_Axi_mem_done),
        .read_resp_error(ICache_Axi_read_resp_error),
        .cache_beat(ICache_Axi_cache_beat),
        .M_AXI_ACLK(clk),
        .M_AXI_ARESETN(!rst),
        .M_AXI_AWID(M_AXI_IBUS_AWID),
        .M_AXI_AWADDR(M_AXI_IBUS_AWADDR),
        .M_AXI_AWLEN(M_AXI_IBUS_AWLEN),
        .M_AXI_AWSIZE(M_AXI_IBUS_AWSIZE),
        .M_AXI_AWBURST(M_AXI_IBUS_AWBURST),
        .M_AXI_AWLOCK(M_AXI_IBUS_AWLOCK),
        .M_AXI_AWCACHE(M_AXI_IBUS_AWCACHE),
        .M_AXI_AWPROT(M_AXI_IBUS_AWPROT),
        .M_AXI_AWQOS(M_AXI_IBUS_AWQOS),
        .M_AXI_AWVALID(M_AXI_IBUS_AWVALID),
        .M_AXI_AWREADY(M_AXI_IBUS_AWREADY),
        .M_AXI_WDATA(M_AXI_IBUS_WDATA),
        .M_AXI_WSTRB(M_AXI_IBUS_WSTRB),
        .M_AXI_WLAST(M_AXI_IBUS_WLAST),
        .M_AXI_WVALID(M_AXI_IBUS_WVALID),
        .M_AXI_WREADY(M_AXI_IBUS_WREADY),
        .M_AXI_BID(M_AXI_IBUS_BID),
        .M_AXI_BRESP(M_AXI_IBUS_BRESP),
        .M_AXI_BVALID(M_AXI_IBUS_BVALID),
        .M_AXI_BREADY(M_AXI_IBUS_BREADY),
        .M_AXI_ARID(M_AXI_IBUS_ARID),
        .M_AXI_ARADDR(M_AXI_IBUS_ARADDR),
        .M_AXI_ARLEN(M_AXI_IBUS_ARLEN),
        .M_AXI_ARSIZE(M_AXI_IBUS_ARSIZE),
        .M_AXI_ARBURST(M_AXI_IBUS_ARBURST),
        .M_AXI_ARLOCK(M_AXI_IBUS_ARLOCK),
        .M_AXI_ARCACHE(M_AXI_IBUS_ARCACHE),
        .M_AXI_ARPROT(M_AXI_IBUS_ARPROT),
        .M_AXI_ARQOS(M_AXI_IBUS_ARQOS),
        .M_AXI_ARVALID(M_AXI_IBUS_ARVALID),
        .M_AXI_ARREADY(M_AXI_IBUS_ARREADY),
        .M_AXI_RID(M_AXI_IBUS_RID),
        .M_AXI_RDATA(M_AXI_IBUS_RDATA),
        .M_AXI_RRESP(M_AXI_IBUS_RRESP),
        .M_AXI_RLAST(M_AXI_IBUS_RLAST),
        .M_AXI_RVALID(M_AXI_IBUS_RVALID),
        .M_AXI_RREADY(M_AXI_IBUS_RREADY)
    );
 
reg [255:0] ICache_Axi_Read_Data;   
  
always @ (posedge clk) begin
if (rst || ICache_Axi_start_burst)
    ICache_Axi_Read_Data = 256'd0;
else if (ICache_Axi_cache_beat) begin
    case (ICache_Axi_read_index)
        7'd0: ICache_Axi_Read_Data[63:0] = ICache_Axi_data_read;
        7'd1: ICache_Axi_Read_Data[127:64] = ICache_Axi_data_read;
        7'd2: ICache_Axi_Read_Data[191:128] = ICache_Axi_data_read;
        7'd3: ICache_Axi_Read_Data[255:192] = ICache_Axi_data_read;
        default: ICache_Axi_Read_Data = ICache_Axi_Read_Data;
  endcase
end
end
/**********************TLB initialization*********************************************/
wire [43:0]  Virtual_PageNum;
reg  TLB_Ren, TLB_Wen;
wire [`TLB_WIDTH-1:0] TLB_Write_Data;
wire [4:0] TLB_Write_Addr,TLB_Read_Address;
wire TLB_HIT;
wire [43:0]  Physical_PageNum;
wire TLB_Exception;
reg  TLB_Read_Access;


assign Virtual_PageNum=(pr_state==IDLE)?ICache_Req_FetchPC[55:12] :FetchPC_Reg[55:12];

iTLB tlb_memory(
    .clk(clk),
    .rst(rst),
    .VPN(Virtual_PageNum),
    .re(TLB_Ren),
    .we(TLB_Wen),
    .write_data(TLB_Write_Data),                    // during replacement
    .write_address(TLB_Write_Addr),                    // during replacement
    .PPN_tag(Physical_PageNum),
    .TLB_hit(TLB_HIT),
    .LRU_addr_tlb(TLB_Read_Address),
    .itlb_full_flush(ITLB_Flush_Req),
    .MPP(csr_status_priv_lvl),
    .exception(TLB_Exception),
    .SATP_mode(csr_satp[`SATP_MODE_RANGE])
    );

PLRU32_TLB LRUtlb(
    .clk(clk),
    .rst(rst),
    .UpdateEn(1'b1),
    .ReadWay(TLB_Read_Address),
    .ReadAccess(TLB_Read_Access),
    .WriteWay(5'd0),    // change by sajin from 5'd0 to LRU_replace
    .WriteAccess(1'b0), // change by sajin from 0 to we
    .LRU_Way(TLB_Write_Addr)
);


  wire [63:0] PMA_PADDR ={8'b0,Physical_PageNum,FetchPC_Reg[11:0]};
  wire PMA_Access_Allowed, PMP_Access_Allowed;
  wire [55:0] PMP_PADDR ={Physical_PageNum,FetchPC_Reg[11:0]};

  PMA #(.PORTS(1)) PMA_itlb
  (.Paddr_Bus(PMA_PADDR),
   .PMA_Check_Enable(PMA_Check_Enable),
   .AccessType_Bus(`MEM_ACCESS_EXECUTE),
   .AccessAllowed_Bus(PMA_Access_Allowed),
   .PMA_Attributes_Bus()
   );

   PMP #() 
   
     port_PMP(   // PMP changed to 0
    .Paddr(PMP_PADDR),
    .Access_Type(`MEM_ACCESS_EXECUTE),
    .Priv_Level(csr_status_priv_lvl),
    .CSR_pmpcfg(csr_pmpcfg_array),
    .CSR_pmpaddr(csr_pmpaddr_array),
    .AccessAllowed(PMP_Access_Allowed)
  );
  
  
  
 /***************************Logic for address tanslation and  Cache Control ********************/
 localparam IDLE=4'b0000;
 localparam START=4'b0001;
 localparam ICACHE_ITLB_COMPARE=4'b0010;
 localparam TLB1 =4'b0011;
 localparam TLB2 =4'b0100;
 localparam ICache1=4'b1000;
 localparam ICache2=4'b1001;
 localparam ICACHE_ITLB_FLUSH  =4'b1010;
  
 reg [3:0] pr_state,nx_state;
 
 reg ICache_Wen_Temp;
 
 reg  [(`ECAUSE_LEN-1):0]         Exception_cause;
 reg  Instr_Exception;
 reg  ICache_Read_Success;
 reg TLB_PTE_read_start;
 always @(posedge clk) 
 begin 
    if(rst) begin 
        pr_state<=IDLE;
        FetchPC<= 0;
    end else begin
        pr_state<=nx_state;
        FetchPC<= ICache_Req_FetchPC; 
    end
 end 
  
  
  always@(*)
  begin 
    TLB_PTE_entry=PTE_Read_data[`PPN_end:`PPN_start];
    ICache_Flush_Done=1'b0;
    ITLB_Flush_Done  =1'b0;
    ICache_Wen_Temp=0;
    PLRU_Read_Access=0;
    PLRU_Write_Access=0;
    ICache_Axi_start_burst=0;
    TLB_Ren=1'b1;  //TLB read is enabled defaultly 
    TLB_Wen=0;
    TLB_Read_Access=0;
    Instr_Exception=1'b0;
    Exception_cause=`EXC_IPAGE_FAULT;
    ICache_Read_Success=1'b0;
    TLB_PTE_read_start=1'b0;
    case (pr_state)   
       IDLE:begin  
                if(ITLB_Flush_Req || ICache_Flush_Req) begin
                    nx_state=ICACHE_ITLB_FLUSH;
                end else begin 
                    nx_state=ICACHE_ITLB_COMPARE;
                end 
            end
            
       START: 
        /*
           In this state we just provide the registered FetchPC to the Cache and TLB, as read latency is the ouput will be available by next clock cycle and 
           comparison output will be ready. in case Fetch PC input is changed by this time we go back to IDLE state and register the Fetch PC one more time
        */  
            begin   
                    if(ITLB_Flush_Req || ICache_Flush_Req) begin 
                        nx_state=ICACHE_ITLB_FLUSH;
                    end else if(~FetchPC_not_change)begin
                    /* Fetch PC changed, No need to proceed the operation for this one */
                        nx_state=IDLE;
                    end else begin
                        nx_state=ICACHE_ITLB_COMPARE;
                    end
            end
            
       ICACHE_ITLB_COMPARE:
            /* In this state we compare signals like TLB Hit, ICache Hit and take approproate decisions
                -----> Check whether Fetch PC is change by this time or not----> then do not take any action just return to IDLE state;
                -----> Check Virtual Address compatible to SV39           -----> if not generate exception and return 
                -----> Check ITLB hit or not                              -----> if not start TLB page walk 
                               ---> If TLB hit--> Check excpetion or permission--->if prsent raise exception and return
                               ---> if TLB hit and no exception then  Check ICache if hit provide output signal and then return to IDLE state else initiate I-Cache read
            */  
            begin
                 if(ITLB_Flush_Req || ICache_Flush_Req) begin 
                        nx_state=ICACHE_ITLB_FLUSH;
                 end else if(~FetchPC_not_change)begin
                    /* Fetch PC changed, No need to proceed the operation for this one */
                        nx_state=IDLE;
                 end else if(~Fetch_PC_SV39_Compatible)begin // Virtual address given is not compatible to SV39
                        Instr_Exception = 1'b1;
                        Exception_cause = `EXC_IPAGE_FAULT;
                        nx_state=IDLE;
                 end else begin
                        if(~TLB_HIT) begin 
                            // Not TLB Hit; We need to do the Page table walk
                            TLB_PTE_read_start=1'b1;
                            nx_state=TLB1;                                                
                        end else begin 
                        //TLB is a hit; check for exception; if no exception then check ICache hit and proceed
                            if(TLB_Exception)begin
                                Instr_Exception=1'b1;
                                Exception_cause = `EXC_IPAGE_FAULT;
                                nx_state=IDLE;
                            end else if((!PMP_Access_Allowed)|| (!PMA_Access_Allowed)) begin
                                Instr_Exception=1'b1;
                                Exception_cause = `EXC_IACCESS_FAULT;
                                nx_state=IDLE;
                            end else begin// No exception or Access problem Can check ICache hit or not now.
                                if(~ICache_hit) begin //No Cache Hit    
                                    ICache_Axi_start_burst=1'b1;                     
                                    nx_state=ICache1;
                                end else begin 
                                // Cache was a hit && TLB also hit; Success 
                                    nx_state=IDLE;
                                    ICache_Read_Success=1'b1;
                                    PLRU_Read_Access=1'b1;
                                    TLB_Read_Access=1'b1;                                   
                                end
                            end 
                        end                        
                 end
            end        
        
       ICACHE_ITLB_FLUSH:
            begin
                if(ITLB_Flush_Req) begin
                    ITLB_Flush_Done=1'b1;    
                end
                if(ICache_Flush_Req) begin
                    ICache_Flush_Done=1'b1;
                end
                nx_state<=IDLE;
            end
            
       TLB1:
            //wait for reply, once you get reply
            begin
                if(DCache_RdResp_IPTW_Done==1'b1) begin     
                    if(ITLB_Flush_Req || ICache_Flush_Req) begin 
                        nx_state=ICACHE_ITLB_FLUSH;
                    end else if(~FetchPC_not_change) begin 
                        nx_state=IDLE;
                    end else begin
                        nx_state=TLB2;
                    end                    
                end else begin
                    nx_state=TLB1;
                end
            
            end
       
       TLB2: begin
                if(ITLB_Flush_Req || ICache_Flush_Req) begin 
                        nx_state=ICACHE_ITLB_FLUSH;
                end else if(~FetchPC_not_change) begin 
                        nx_state=IDLE;
                end else begin
                    // Checking the PTE Entry read from the D-Cache          
                    if(PTE_Read_data[V]==1'b0 || (PTE_Read_data[R]==1'b0 && PTE_Read_data[W]==1'b1)) begin
                       //not a valid PTE
                       Instr_Exception=1'b1;
                       Exception_cause = `EXC_IPAGE_FAULT;
                       nx_state=IDLE;
                    end else begin
                       //Valid PTE
                       if(PTE_Read_data[R] || PTE_Read_data[X]) begin 
                            //Leaf Pointer
                            if(PTE_Read_data[X]==1'b0) begin 
                                    // No Execution permission
                                Instr_Exception=1'b1;
                                Exception_cause = `EXC_IPAGE_FAULT;
                                nx_state=IDLE;            
                            end else begin
                                   // Execute Permission
                                if((count==2'b10 && PTE_Read_data[27:10]!=0)|| (count==2'b01 && PTE_Read_data[18:10]!=0)) begin
                                   //misaligned super page
                                    Instr_Exception=1'b1;
                                    Exception_cause = `EXC_IPAGE_FAULT;
                                    nx_state=IDLE; 
                                end else begin
                                    //not a misaligned superpage
                                    if(PTE_Read_data[A]==1'b0) begin
                                        //---A is 0--
                                        Instr_Exception=1'b1;
                                        Exception_cause = `EXC_IPAGE_FAULT;
                                        nx_state=IDLE; 
                                    end else begin
                                        // Translation is successfull
                                        case(count)
                                            2'b00: TLB_PTE_entry=PTE_Read_data[`PPN_end:`PPN_start];
                                            2'b01: TLB_PTE_entry={PTE_Read_data[53:19],FetchPC_Reg[20:12]};
                                            2'b10: TLB_PTE_entry={PTE_Read_data[53:28],FetchPC_Reg[29:12]};
                                            default:TLB_PTE_entry=PTE_Read_data[`PPN_end:`PPN_start];
                                        endcase
                                        TLB_Wen=1'b1;    
                                        nx_state=START;
                                    end                                    
                                end   
                            end   
                       end else begin
                           //Pointer to next PTE 
                           if(count==2'b00) begin
                               Instr_Exception=1'b1;
                               Exception_cause = `EXC_IPAGE_FAULT;
                               nx_state=IDLE;   
                           end else begin
                               TLB_PTE_read_start=1'b1;
                               nx_state=TLB1;   
                           end 
                       end
                    end   
                end    
             end
             
       ICache1:
            begin
               if(ICache_Axi_mem_done) begin
                    //memory transaction completed 
                    if(ITLB_Flush_Req || ICache_Flush_Req) begin 
                        nx_state=ICACHE_ITLB_FLUSH;
                    end else if(~FetchPC_not_change) begin 
                        nx_state=IDLE;
                    end else begin
                        nx_state=ICache2;
                    end                  
               end else begin
                    // Memory Transaction progressing 
                    nx_state=ICache1;
               end
            end
            
       ICache2:
            begin
                if(ITLB_Flush_Req || ICache_Flush_Req) begin 
                    nx_state=ICACHE_ITLB_FLUSH;
                end else if(~FetchPC_not_change) begin 
                    nx_state=IDLE;
                end else begin
                    ICache_Wen_Temp=1'b1;
                    nx_state=START;
                end         
            end  
           
       default:
            begin
             nx_state=IDLE;
            end
            
    endcase;
  end
  
  
  
  //.......Registering FetchPC when moving from the IDLE to next state............ 
reg [63:0] FetchPC_Reg;
reg [63:0] FetchPC;
always @(posedge clk) 
begin 
    if(rst) begin
        FetchPC_Reg <= 0;
    end else if (pr_state==IDLE) begin
        FetchPC_Reg<= ICache_Req_FetchPC;    
    end
end  

/* Comparing Fetch_PC_Reg and ICache_Req_FetchPC if they are equal it means fetch_pc is not redirected
   by the IFU hence the result can be outputted    
*/
wire FetchPC_not_change=(FetchPC_Reg==FetchPC); /* to be used in states after IDLE only 
                            if not one current execution can be avoided and proceeded to IDLE state
                            for new FetchPC operation no hit or exception should be generated;*/
                            
/*checking virtual address is correct or not, as per the SV39 Virual memory system bit-63-39 of the FetchPC 
should be same */
reg Fetch_PC_SV39_Compatible;

always @(*)
begin 
   Fetch_PC_SV39_Compatible =1'b1;
   if((csr_satp[`SATP_MODE_RANGE]== `SATP_MODE__BARE) || csr_status_priv_lvl== Machine_Mode) begin 
                Fetch_PC_SV39_Compatible =1'b1; // as sv39 virtual memory is not enabled checking of address not required.
   end else if (FetchPC_Reg[38]==1'b1) begin 
                Fetch_PC_SV39_Compatible =&FetchPC_Reg[63:39]; //all bits 39-63 should be 1 in this 
   end else if (FetchPC_Reg[38]==1'b0) begin 
                Fetch_PC_SV39_Compatible = !(|FetchPC_Reg[63:39]); // all bits 39-63 should be 0 in this case
   end 
end 

/***********************TLB PTE address calculation***********************************************/
reg [1:0] count;
reg [63:0] PTE_ADDRESS;

always@(posedge clk) 
begin
    if(rst || pr_state==IDLE)begin
        count<=2'b11;
    end else if(pr_state==TLB1 && DCache_RdResp_IPTW_Done ) begin 
        count<=count-1;
    end 
end

always @(*)
begin 
   if(count==2'b11) begin
        PTE_ADDRESS = {8'b0,csr_satp[43:0],FetchPC_Reg[38:30],3'b0};
   end else if (count==2'b10) begin
        PTE_ADDRESS = {8'b0,PTE_Read_data[53:10],FetchPC_Reg[29:21],3'b0};
   end else begin
        PTE_ADDRESS = {8'b0,PTE_Read_data[53:10],FetchPC_Reg[20:12],3'b0};
   end
end

/***********************Calculating I-Cache Hit **************************************************/
/* I-Cache hit will be used only if ITLB is hit **************************************************/
wire [3:0] ICache_Comp;
wire ICache_hit;

assign ICache_Comp[0]= (ICache_Valid_dout0 && (ICache_Dout[0][Cacheline_tag_start:Cacheline_tag_end]==Physical_PageNum))?1'b1:1'b0;
assign ICache_Comp[1]= (ICache_Valid_dout1 && (ICache_Dout[1][Cacheline_tag_start:Cacheline_tag_end]==Physical_PageNum))?1'b1:1'b0;
assign ICache_Comp[2]= (ICache_Valid_dout2 && (ICache_Dout[2][Cacheline_tag_start:Cacheline_tag_end]==Physical_PageNum))?1'b1:1'b0;
assign ICache_Comp[3]= (ICache_Valid_dout3 && (ICache_Dout[3][Cacheline_tag_start:Cacheline_tag_end]==Physical_PageNum))?1'b1:1'b0;


assign ICache_hit = TLB_HIT? ( | ICache_Comp) :1'b0; // I Cache hit will ensure that the TLB is hit

reg [255:0] ICache_Line;
reg [1:0]   ICache_Read_way;

always @(*)
begin 
    case (ICache_Comp)
        4'b0001:
                begin
                  ICache_Line    = ICache_Dout[0];
                  ICache_Read_way= 2'b00;
                end
        4'b0010:
                begin
                  ICache_Line    = ICache_Dout[1];
                  ICache_Read_way= 2'b01;
                end
        4'b0100:
                begin
                  ICache_Line    = ICache_Dout[2];
                  ICache_Read_way= 2'b10;
                end
        4'b1000:
                begin
                  ICache_Line    = ICache_Dout[3];
                  ICache_Read_way= 2'b11;
                end
        default:
                begin
                    ICache_Line     =0;
                    ICache_Read_way =0;
                end
    endcase
end

always @(*)
begin 
    case(PLRU_Way)
        2'b00:begin
                ICache_Valid_Wen0=ICache_Wen_Temp;
                ICache_Wen[0]    =ICache_Wen_Temp;
              end
              
        2'b01:begin
                ICache_Valid_Wen1=ICache_Wen_Temp;
                ICache_Wen[1]    =ICache_Wen_Temp;
              end
        
        2'b10:begin
                ICache_Valid_Wen2=ICache_Wen_Temp;
                ICache_Wen[2]    =ICache_Wen_Temp;
              end
              
        2'b11:begin
                ICache_Valid_Wen3=ICache_Wen_Temp;
                ICache_Wen[3]    =ICache_Wen_Temp;
              end
        
        default:
              begin
                  ICache_Valid_Wen0=1'b0; ICache_Valid_Wen1=1'b0; ICache_Valid_Wen2=1'b0; ICache_Valid_Wen3=1'b0;
                  ICache_Wen[0]=1'b0;     ICache_Wen[1]=1'b0;     ICache_Wen[2]=1'b0;     ICache_Wen[3]=1'b0;   
              end
    endcase
end 

//*********************TLB -DCache request signals mapping **************************************//

reg [63:0]  PTE_Read_data;
always @(posedge clk) 
begin
    if(rst) begin 
        PTE_Read_data<=0;
    end else if (DCache_RdResp_IPTW_Done) begin
        PTE_Read_data<=DCache_RdResp_IPTW_Data;
    end
end
reg[43:0] TLB_PTE_entry; // to be calculated properly based on page walk 
assign TLB_Write_Data= {FetchPC_Reg[38:12],10'b0,TLB_PTE_entry,PTE_Read_data[`PPN_start-1:0]};

/**************************Output Mapping**********************************************************/

assign ICache_Resp_Line             = ICache_Line;
assign ICache_Resp_Hit              = ICache_Read_Success;
assign ICache_Resp_Exception        = Instr_Exception;
assign ICache_Resp_ECause           = Exception_cause;


assign DCache_RdReq_IPTW_Paddr      = PTE_ADDRESS;
assign DCache_RdReq_IPTW_DataType   = `DATA_TYPE_D;
assign DCache_RdReq_IPTW_Valid      = TLB_PTE_read_start;

endmodule
