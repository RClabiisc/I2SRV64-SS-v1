
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

module DCache_Module
 #(
    parameter integer Snoop_ReqBus_Width      =64,                    // Snoop Bus width  (Req)       
    parameter integer Snoop_ResultBus_Width   =260,                 // Snoop Result Width  
    parameter integer Cache_Req_width         =322,  
    parameter integer Cache_Resp_Bus_Width    =260,
    parameter CORE_ID                         =2'b00,                    //Indicating Core ID
    
    parameter integer C_M_AXI_PBUS_ADDR_WIDTH = 64,
    parameter integer C_M_AXI_PBUS_DATA_WIDTH = 32,

    parameter integer C_M_AXI_DBUS_ADDR_WIDTH = 64,
    parameter integer C_M_AXI_DBUS_DATA_WIDTH = 64
  )
    
  ( input wire                  clk,
    input wire                  rst,
    
    //DCache-------Control Signals-------------
    input  wire                                 DCache_Enable,
    input  wire                                 DCache_Flush_Req,
    output wire                                 DCache_Flush_Done,
    input  wire                                 DCache_Invalidate_Req,
    output wire                                 DCache_Invalidate_Done,
    
    
    input  wire                                 DCache_Req_Valid,
    input  wire                                 DCache_Req_Type,  //Write or Read Indication 
    input  wire [`DATA_TYPE__LEN-1:0]           DCache_Req_DataType,
    input  wire [55:0]                          DCache_Req_Paddr,
    input  wire [63:0]                          DCache_Req_Wrdata,
    input  wire                                 DCache_Req_Rdabort,
    output wire                                 DCache_Resp_Done,
    output wire                                 DCache_Resp_Ready,
    output wire [63:0]                          DCache_Resp_Rddata, 
    
    //Snooping Related Signals and DCACHE_Output Signals to the SCU
    
    input  wire [Snoop_ReqBus_Width-1:0]        Snoop_Request_Bus,  // From SCU indicating the TAG and BUS transaction currently going on  //Output of the Arbiter connected to all the CAchers
    input  wire                                 Snoop_Request_Bus_Valid,          
  //input  wire                                 Bus_Operation_Valid,   //Signal Indicating Bus operation is valid. This will be assereted whenever Bus Operation is going on
    
    output wire [Snoop_ResultBus_Width-1:0]     Snoop_Result_Bus,   // // Cache Response to the given Snoop request                           
    output  wire                                Snoop_Result_Bus_Valid,
    
    output wire [Cache_Req_width-1:0]           Cache_Request_Bus, // individual bus connected from one cache to the Snoop Control Unit
    output wire                                 Cache_Request_Bus_Valid,
    
    input  wire [Cache_Resp_Bus_Width-1:0]      Cache_Snoop_Resp_Bus, //snoopunit response......    
    input  wire                                 Cache_Snoop_Resp_Valid,
    
    
    // Signals Related to Private Bus need to be added Here..........
    output wire [C_M_AXI_PBUS_ADDR_WIDTH-1:0]   Private_Bus_Address,        //Address Line   
    output wire [C_M_AXI_PBUS_ADDR_WIDTH-1:0]   Private_Bus_Write_Data,     //Data to write    
    input  wire [C_M_AXI_PBUS_ADDR_WIDTH-1:0]   Private_Bus_Read_Data,     //Data from Private Bus
    output wire                                 Private_Bus_Write_Read,     //indicate Private Bus Write or Read
                                                                            //Write-->1 Read--->0                        
    output wire                                 Private_Bus_Start,          // to Start a private Bus transacation
    input  wire                                 Private_Bus_done,           // Indicate Private Bud transaction completed
    input  wire                                 Private_Bus_Busy,            // Indicatet the Private Bus transacation is going on
    output wire                                 Private_Bus_Double,          // Indicate current transaction for load or double is for double
                                                                            // Since private transaction is 32 byte only then two time transcation may happpen
    output wire                                 Private_Bus_read_write      // indicate read or write operation
   
   );                                                                           


//********************************************************************************************************************   
//.....................CACHE PARAMETER DECLARATIONS LIKE MEMDEPTH WIDTH ETC.........................
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  
 
//local parameter definition wrt to Cache structure     
    
localparam MEM_DEPTH = 128;
localparam MEM_DEPTH_LEN = $clog2(MEM_DEPTH);
localparam MEM_DATA_WIDTH = 256;
localparam MEM_TAG_WIDTH = 44;


localparam CACHE_TAG_START = 12;
localparam CACHE_TAG_END   = 55;
localparam CACHE_INDEX_START=5;
localparam CACHE_INDEX_END =11;
localparam CACHE_OFFSET_START=0;
localparam CACHE_OFFSET_END=4;

   
 //----------PORT A SIGNALS OF DATA MEMORY........
 reg  [31:0]                mem_data_wea    [0:3];
 wire [MEM_DATA_WIDTH-1:0]  mem_data_dina;
 wire [MEM_DATA_WIDTH-1:0]  mem_data_douta  [0:3];
 wire [MEM_DEPTH_LEN-1:0]   mem_data_addra;
 
 //---------PORT B Signals of Data Memory
 wire [31:0]                mem_data_web    [0:3];
 wire [MEM_DATA_WIDTH-1:0]  mem_data_dinb ;
 wire [MEM_DATA_WIDTH-1:0]  mem_data_doutb  [0:3];
 wire [MEM_DEPTH_LEN-1:0]   mem_data_addrb;
   
//---------PORT A SIGNALS OF TAG MEMORY...........  
 reg  [3:0]                 mem_tag_wea ;   
 wire [MEM_TAG_WIDTH-1:0]   mem_tag_dina;
 wire [MEM_TAG_WIDTH-1:0]   mem_tag_douta   [0:3];
 wire [MEM_DEPTH_LEN-1:0]   mem_tag_addra;  

//---------PORT B SIGNALS OF TAG MEMORY...........  
 wire [3:0]                 mem_tag_web ;    
 wire [MEM_TAG_WIDTH-1:0]   mem_tag_dinb;    
 wire [MEM_TAG_WIDTH-1:0]   mem_tag_doutb   [0:3];
 wire [MEM_DEPTH_LEN-1:0]   mem_tag_addrb;  
 
 
 // assignment of memory signals-------------------------
 
 // Second port is used by the snooping LOGIC Only.......
 // This port wont write any data into the TAG or DATA...
 // Hence Write enable and input data can be assigned to 0
 // Hence web, dinb of both data and Tag memory is connected to zero
 
 assign mem_tag_web[0] =1'b0;   assign mem_tag_web[1] =1'b0;    assign mem_tag_web[2]=1'b0;     assign mem_tag_web[3]=1'b0; 
 assign mem_data_web[0] =1'b0;  assign mem_data_web[1] =1'b0;   assign mem_data_web[2] =1'b0;   assign mem_data_web[3] =1'b0;

 assign mem_tag_dinb=0; 
 assign mem_data_dinb=0;
  
 
   
// Instantiation of Tag and Data Memory .............
// (Xilinx Parameterized Macro XPM is used) 
genvar gi;
generate 
    for (gi=0; gi<4; gi=gi+1) begin
        xpm_memory_tdpram #(
                            .ADDR_WIDTH_A(MEM_DEPTH_LEN),
                            .ADDR_WIDTH_B(MEM_DEPTH_LEN),
                            .AUTO_SLEEP_TIME(0),
                            .BYTE_WRITE_WIDTH_A(MEM_TAG_WIDTH),
                            .BYTE_WRITE_WIDTH_B(MEM_TAG_WIDTH),
                            .CASCADE_HEIGHT(0),
                            .CLOCKING_MODE("common_clock"),
                            .ECC_MODE("no_ecc"),
                            .MEMORY_INIT_FILE("none"),
                            .MEMORY_INIT_PARAM("0"),
                            .MEMORY_OPTIMIZATION("true"),
                            .MEMORY_PRIMITIVE("block"),
                            .MEMORY_SIZE(MEM_DEPTH*MEM_TAG_WIDTH),
                            .MESSAGE_CONTROL(0),
                            .READ_DATA_WIDTH_A(MEM_TAG_WIDTH),
                            .READ_DATA_WIDTH_B(MEM_TAG_WIDTH),
                            .READ_LATENCY_A(1),
                            .READ_LATENCY_B(1),
                            .READ_RESET_VALUE_A("0"),
                            .READ_RESET_VALUE_B("0"),
                            .RST_MODE_A("SYNC"),
                            .RST_MODE_B("SYNC"),
                            .SIM_ASSERT_CHK(0),
                            .USE_EMBEDDED_CONSTRAINT(0),
                            .USE_MEM_INIT(0),
                            .WAKEUP_TIME("disable_sleep"),
                            .WRITE_DATA_WIDTH_A(MEM_TAG_WIDTH),
                            .WRITE_DATA_WIDTH_B(MEM_TAG_WIDTH),
                            .WRITE_MODE_A("write_first"),
                            .WRITE_MODE_B("write_first")
                        )
                        tag (
                            .dbiterra(),
                            .dbiterrb(),
                            .douta(mem_tag_douta[gi]),
                            .doutb(mem_tag_doutb[gi]),
                            .sbiterra(),
                            .sbiterrb(),
                            .addra(mem_tag_addra),
                            .addrb(mem_tag_addrb),
                            .clka(clk),
                            .clkb(clk),
                            .dina(mem_tag_dina), // this can be checked whether dina multiple signal required or not
                            .dinb(mem_tag_dinb), // this can be checked whether dinb multiple signals are required or not
                            .ena(1'b1),
                            .enb(1'b1),
                            .injectdbiterra(1'b0),
                            .injectdbiterrb(1'b0),
                            .injectsbiterra(1'b0),
                            .injectsbiterrb(1'b0),
                            .regcea(1'b1),
                            .regceb(1'b1),
                            .rsta(rst),
                            .rstb(rst),
                            .sleep(1'b0),
                            .wea(mem_tag_wea[gi]),
                            .web(mem_tag_web[gi])
                        );
        
                        //Data BRAM
                        xpm_memory_tdpram #(
                            .ADDR_WIDTH_A(MEM_DEPTH_LEN),
                            .ADDR_WIDTH_B(MEM_DEPTH_LEN),
                            .AUTO_SLEEP_TIME(0),
                            .BYTE_WRITE_WIDTH_A(8),
                            .BYTE_WRITE_WIDTH_B(8),
                            .CASCADE_HEIGHT(0),
                            .CLOCKING_MODE("common_clock"),
                            .ECC_MODE("no_ecc"),
                            .MEMORY_INIT_FILE("none"),
                            .MEMORY_INIT_PARAM("0"),
                            .MEMORY_OPTIMIZATION("true"),
                            .MEMORY_PRIMITIVE("block"),
                            .MEMORY_SIZE(MEM_DEPTH*MEM_DATA_WIDTH),
                            .MESSAGE_CONTROL(0),
                            .READ_DATA_WIDTH_A(MEM_DATA_WIDTH),
                            .READ_DATA_WIDTH_B(MEM_DATA_WIDTH),
                            .READ_LATENCY_A(1),
                            .READ_LATENCY_B(1),
                            .READ_RESET_VALUE_A("0"),
                            .READ_RESET_VALUE_B("0"),
                            .RST_MODE_A("SYNC"),
                            .RST_MODE_B("SYNC"),
                            .SIM_ASSERT_CHK(0),
                            .USE_EMBEDDED_CONSTRAINT(0),
                            .USE_MEM_INIT(0),
                            .WAKEUP_TIME("disable_sleep"),
                            .WRITE_DATA_WIDTH_A(MEM_DATA_WIDTH),
                            .WRITE_DATA_WIDTH_B(MEM_DATA_WIDTH),
                            .WRITE_MODE_A("write_first"),
                            .WRITE_MODE_B("write_first")
                        )
                        data (
                            .dbiterra(),
                            .dbiterrb(),
                            .douta(mem_data_douta[gi]),
                            .doutb(mem_data_doutb[gi]),
                            .sbiterra(),
                            .sbiterrb(),
                            .addra(mem_data_addra),
                            .addrb(mem_data_addrb),
                            .clka(clk),
                            .clkb(clk),
                            .dina(mem_data_dina),
                            .dinb(mem_data_dinb),
                            .ena(1'b1),
                            .enb(1'b1),
                            .injectdbiterra(1'b0),
                            .injectdbiterrb(1'b0),
                            .injectsbiterra(1'b0),
                            .injectsbiterrb(1'b0),
                            .regcea(1'b1),
                            .regceb(1'b1),
                            .rsta(rst),
                            .rstb(rst),
                            .sleep(1'b0),
                            .wea(mem_data_wea[gi]),
                            .web(mem_data_web[gi])
                        );
    end
endgenerate

///...................Coherance Bit for each Set Seperately..............................
// MESI Bits will be writtern from both side ie Snoop control unit as well as the processor side
/*
ENCODING OF MESI BITS
    Invalid     = "00"  -----> not present in the cache not valid 
    Exclusive   = "01"  -----> only in this cache and valid not modified
    Modified    = "11"  -----> only in this cache but modified   
    Shared      = "10"  -----> shared condition but uptodate


*/
reg [1:0] MESI_WAY0 [0:MEM_DEPTH-1]; reg [1:0] MESI_WAY1 [0:MEM_DEPTH-1];reg [1:0] MESI_WAY2 [0:MEM_DEPTH-1];reg [1:0] MESI_WAY3 [0:MEM_DEPTH-1];
reg MESI_Way0_Wea,MESI_Way1_Wea,MESI_Way2_Wea, MESI_Way3_Wea; //Write Enable Signal
wire MESI_Way0_Web,MESI_Way1_Web,MESI_Way2_Web,MESI_Way3_Web ;
wire [1:0] MESI_dina, MESI_dinb; // Data to be written
reg [1:0]  MESI_Way0_douta,MESI_Way0_doutb, MESI_Way1_douta,MESI_Way1_doutb,MESI_Way2_douta,MESI_Way2_doutb,MESI_Way3_douta,MESI_Way3_doutb;
wire [MEM_DEPTH_LEN-1:0] MESI_RAdda,MESI_RAddb;
wire [MEM_DEPTH_LEN-1:0] MESI_WAdda,MESI_WAddb;
//MESI BIT Write and Read logic;
integer i;
//write Logic..................latency 1 Clock cycle
always @(posedge clk)
begin
    if(rst) begin    
      for( i=0; i<MEM_DEPTH;i=i+1) 
       begin
        MESI_WAY0[i]<=0;
        MESI_WAY1[i]<=0;
        MESI_WAY2[i]<=0;
        MESI_WAY3[i]<=0;
       end
    end 
    else begin
        if(MESI_Way0_Wea==1'b1)
            MESI_WAY0[MESI_WAdda]<=MESI_dina;
            
        if(MESI_Way0_Web==1'b1)
            MESI_WAY0[MESI_WAddb]<=MESI_dinb;
            
        if(MESI_Way1_Wea==1'b1)
            MESI_WAY1[MESI_WAdda]<=MESI_dina;
            
        if(MESI_Way1_Web==1'b1)
            MESI_WAY1[MESI_WAddb]<=MESI_dinb;    
            
            
        if(MESI_Way2_Wea==1'b1)
            MESI_WAY2[MESI_WAdda]<=MESI_dina;
            
        if(MESI_Way2_Web==1'b1)
            MESI_WAY2[MESI_WAddb]<=MESI_dinb;
                    
        if(MESI_Way3_Wea==1'b1)
            MESI_WAY3[MESI_WAdda]<=MESI_dina;
            
        if(MESI_Way3_Web==1'b1)
            MESI_WAY3[MESI_WAddb]<=MESI_dinb;    
    end
end

//Read Logic latency 1 Clock cycle----------------------
always @(posedge clk)
begin 
    if(rst) begin 
       MESI_Way0_douta<=0;
       MESI_Way0_doutb<=0; 
       
       MESI_Way1_douta<=0;
       MESI_Way1_doutb<=0; 
       
       MESI_Way2_douta<=0;
       MESI_Way2_doutb<=0;
       
       MESI_Way3_douta<=0;
       MESI_Way3_doutb<=0;  
    end
    else begin
       MESI_Way0_douta<=MESI_WAY0[MESI_RAdda];
       MESI_Way0_doutb<=MESI_WAY0[MESI_RAddb];
       
       MESI_Way1_douta<=MESI_WAY1[MESI_RAdda];
       MESI_Way1_doutb<=MESI_WAY1[MESI_RAddb];      
       
       MESI_Way2_douta<=MESI_WAY2[MESI_RAdda];
       MESI_Way2_doutb<=MESI_WAY2[MESI_RAddb]; 
       
       MESI_Way3_douta<=MESI_WAY3[MESI_RAdda];
       MESI_Way3_doutb<=MESI_WAY3[MESI_RAddb];     
    end
end 

//*********************************************************************************************************************************************************************************
//*********************************************************************************************************************************************************************************
//*********************************************************************************************************************************************************************************
//............................................ Snooping Logic and Port B Control ..........................................
/*
This portion deals with the PORT B of the Data Cache or Snooping Logic
 Snooping Logic just read the Tag and Data stored in cache but wont write to the tag or data portion 
but MESI bits will be updated based on the conditions 

Snoop_Request_Bus Have Following information
                BUS Transaction Type(4bit)[63:61]     
                                                010  :- BUSREAD        
                                                101  :- BUS UPGRADE    
                                                111  :- BUS READX --BUS Read due to a miss during write 
                                                     :- Not Cacheable Bus transactions to peripeherals (this should not be generating a Snoop_request_valid)
                                                100  :- A Bus operation indicating Peripheral Bus transaction, SCU may not gnerae a valid snoop request even in this case
                                                011  :- A Cache Flush operation from one of the Cache, only modified state only will be written to memory hence
                                                        Snoop Control unit may not generate any valid signal or snoop request (during Replacement)
                                                110  : A  CacheFlush while Flush Operation,Snoop Control unit may not generate any valid signal         
                                                000  : No operation     
                                                      
                
                                                      
                COREID(2bit)             [58:57]     :- indicate from which core the transaction is going on 
                                                         Used to identify whether the transaction is happening in the same Processor
                                        
                Physical Address(56 bit) [55:0]      :- Physical Address of the current bus holding transcation 
                                                        to be used to retrive the data and tag

......................3+56+2(64 bit is used) additional bits can be introduced if required....................................
Assumption here is SCU will assert Snoop_req_valid for once clock cycle, if snoop control valid is asserted by the SCU then the
Dcache can make corresponding changes to the MESI bits.
                                   
                  
*/             

// Stripping Snoop Bus data (Can Customize this later using verilog header file if required)
wire [2:0] Snoop_BusReq_Type        = Snoop_Request_Bus[63:61];
wire [1:0] Snoop_CORE_ID            = Snoop_Request_Bus[58:57];
wire [55:0]Snoop_Physical_Address   = Snoop_Request_Bus[55:0];

//Stripping Tag_Info and Index_info from physical Address

wire [MEM_TAG_WIDTH-1:0] Snoop_Tag  = Snoop_Physical_Address[CACHE_TAG_END:CACHE_TAG_START];
wire [MEM_DEPTH_LEN-1:0] Snoop_Index= Snoop_Physical_Address[CACHE_INDEX_END:CACHE_INDEX_START];


assign MESI_RAddb= Snoop_Index;

assign mem_data_addrb= Snoop_Index;
assign mem_tag_addrb= Snoop_Index;

reg [MEM_TAG_WIDTH-1:0] Snoop_Tag_Reg;
reg Snoop_Req_Valid_Reg, Snoop_Req_Valid_Reg2;

reg [2:0] Snoop_BusReq_Type_Reg;
reg [MEM_TAG_WIDTH-1:0] Snoop_Index_Reg;

reg [1:0] Snoop_COREID_Reg;

always@(posedge clk) 
begin
    if(rst)
    begin
        Snoop_Tag_Reg<=0;
        Snoop_Req_Valid_Reg<=0;
        Snoop_Req_Valid_Reg2<=0;
        Snoop_BusReq_Type_Reg<=0;
        Snoop_Index_Reg<=0;
        Snoop_COREID_Reg<=0;
    end 
    else begin
        Snoop_Tag_Reg<= Snoop_Tag;
        Snoop_Req_Valid_Reg<= Snoop_Request_Bus_Valid;
        Snoop_Req_Valid_Reg2<=Snoop_Req_Valid_Reg;
        Snoop_BusReq_Type_Reg<=Snoop_BusReq_Type;
        Snoop_Index_Reg<=Snoop_Index;
        Snoop_COREID_Reg<=Snoop_CORE_ID;
    end
end
    
//............Comparing The TAGS as Well AS MESI BITS........................

wire [MEM_TAG_WIDTH-1:0]  Snoop_Tag_Dout_Way0 = mem_tag_doutb[0];
wire [MEM_TAG_WIDTH-1:0]  Snoop_Tag_Dout_Way1 = mem_tag_doutb[1];
wire [MEM_TAG_WIDTH-1:0]  Snoop_Tag_Dout_Way2 = mem_tag_doutb[2];
wire [MEM_TAG_WIDTH-1:0]  Snoop_Tag_Dout_Way3 = mem_tag_doutb[3];



wire [3:0] Snoop_Compare_Way;

assign Snoop_Compare_Way[0] = (MESI_Way0_doutb!=2'b00)? ((Snoop_Tag_Reg==Snoop_Tag_Dout_Way0)? 1'b1:1'b0):1'b0;
assign Snoop_Compare_Way[1] = (MESI_Way1_doutb!=2'b00)? ((Snoop_Tag_Reg==Snoop_Tag_Dout_Way1)? 1'b1:1'b0):1'b0;
assign Snoop_Compare_Way[2] = (MESI_Way2_doutb!=2'b00)? ((Snoop_Tag_Reg==Snoop_Tag_Dout_Way2)? 1'b1:1'b0):1'b0;
assign Snoop_Compare_Way[3] = (MESI_Way3_doutb!=2'b00)? ((Snoop_Tag_Reg==Snoop_Tag_Dout_Way3)? 1'b1:1'b0):1'b0;

wire Snoop_Hit          = | Snoop_Compare_Way;


reg [MEM_DATA_WIDTH-1:0] Snoop_Data; // Muxed Data output 
reg [1:0] Snoop_MESI_Dout;




always @(*)
begin
    case (Snoop_Compare_Way)
        4'b0001: begin
                   Snoop_Data =mem_data_doutb[0];
                   Snoop_MESI_Dout=MESI_Way0_doutb;
                 end               
        4'b0010: begin 
                   Snoop_Data =mem_data_doutb[1];
                   Snoop_MESI_Dout=MESI_Way1_doutb;
                   
                 end
        4'b0100: begin
                   Snoop_Data =mem_data_doutb[2];
                   Snoop_MESI_Dout=MESI_Way2_doutb;
                 end
        4'b1000: begin
                   Snoop_Data =mem_data_doutb[3];
                   Snoop_MESI_Dout=MESI_Way3_doutb;
                 end 
        default: begin
                   Snoop_Data =0;       
                   Snoop_MESI_Dout=0; //invalid
                 end
     endcase           
end
/*
----------------MESI Bits change for bus transactions------------------------

Invalid(I)(00)          ----->  BusRd            --------> No change 
                        ----->  BusRdx/BusUpgr   --------> No change
                
                
Exclusive(E)(01)        ------> BusRd            --------> give the data line to the SCU---> modify the current state to Shared(S)
                        ------> BusRdx           --------> give the data line to the SCU---> modify the current state to Invalid(I)
                        ------> Busupgr          --------> Not expecting in this state as the current cache line is exclusive
                
Shared (S)(10)          ------> BusRd            --------> give the date line to SCU, let SCU decide which cache to be used and no change in the MESI Bits
                        ------> BusRdx           --------> give the date line to SCU, let SCU decide which Cache to be used and change the current state to Invalid
                        ------> Busupgr          --------> give 0 dataline to SCU and change the state to invalid
                
Modified(M)(11)         ------> BusRd            --------> provide the data line to SCU and change state to shared and SCU initiate the memory write operation to make memory
                                                           consistent with cache line
                        ------> BusRdx          --------> provide the data line to the SCU and change the state to the Invalid 
             
whatever be the state SCU expect a valid reply from the processor
             
For A Snooping request result will be given with a once clock cycle latency 
Snoop_Request_Bus_Valid is registerd twice, during Snoop_Request_Bus_Valid=1 period Adderess and other details will be stripped and given to memories
by next clock cycle we get the data.....rest are calculated

Snoop_Result_Bus -------------------------------> (260 bits)
                 Snooped_data----> 256 bits [255:0]
                 MESI bits   ----> 2 bits   [257:256]
                 CORE_ID     ----> 2 bits   [259:258]
    
*/
reg Snoop_Change;              //indicate MESI need to be Updated by the Snooping
reg [1:0] Snoop_MESI_WriteData;
reg [MEM_DATA_WIDTH-1:0] Snoop_Result_data_d;

always@(*)
begin 
Snoop_Result_data_d=0;
Snoop_MESI_WriteData=0;
Snoop_Change=0;
    if(Snoop_Req_Valid_Reg && Snoop_Hit && (Snoop_COREID_Reg!=CORE_ID)) begin
        case (Snoop_MESI_Dout)
             2'b01: begin    //.............Exclusive State.................
                        if(Snoop_BusReq_Type_Reg==3'b010) begin //BusRd      
                            Snoop_Result_data_d=Snoop_Data;
                            Snoop_MESI_WriteData=2'b10;  //Changing to Shared
                            Snoop_Change=1'b1;
                        end 
                        else if(Snoop_BusReq_Type_Reg==3'b111) begin // BusRdx
                            Snoop_Result_data_d=Snoop_Data;
                            Snoop_MESI_WriteData=2'b00; // Changing to Invalid
                            Snoop_Change=1'b1;
                        end 
                        else begin          //No Bus Upgrade is expected when there is a hit
                            Snoop_Result_data_d=0;
                            Snoop_MESI_WriteData=2'b00;
                            Snoop_Change=1'b0;                            
                        end 
                   end
            2'b10: begin    // Shared......................................
                        if(Snoop_BusReq_Type_Reg==3'b010) begin //BusRd      
                            Snoop_Result_data_d=Snoop_Data;
                            Snoop_MESI_WriteData=2'b10;  
                            Snoop_Change=1'b0;
                        end 
                        else if(Snoop_BusReq_Type_Reg==3'b111) begin // BusRdx
                            Snoop_Result_data_d=Snoop_Data;
                            Snoop_MESI_WriteData=2'b00; // Changing to Invalid
                            Snoop_Change=1'b1;
                        end 
                        else if(Snoop_BusReq_Type_Reg==3'b101) begin          //No Bus Upgrade is expected when there is a hit
                            Snoop_Result_data_d=0;      // no need to output
                            Snoop_MESI_WriteData=2'b00; //Busupgraion by other caches state changed to invalid
                            Snoop_Change=1'b1;                            
                        end 
                        else begin 
                            Snoop_Result_data_d=0;
                            Snoop_MESI_WriteData=2'b00;
                            Snoop_Change=1'b0; 
                        end
                   end
            2'b11: begin    //Modified State...............................
                       if(Snoop_BusReq_Type_Reg==3'b010) begin //BusRd      
                            Snoop_Result_data_d=Snoop_Data;
                            Snoop_MESI_WriteData=2'b10;  //Changing to Shared
                            Snoop_Change=1'b1;
                        end 
                        else if(Snoop_BusReq_Type_Reg==3'b111) begin // BusRdx
                            Snoop_Result_data_d=Snoop_Data;
                            Snoop_MESI_WriteData=2'b00; // Changing to Invalid
                            Snoop_Change=1'b1;
                        end 
                        else begin          //No Bus Upgrade is expected when there is a hit
                            Snoop_Result_data_d=0;
                            Snoop_MESI_WriteData=2'b00;
                            Snoop_Change=1'b0;                            
                        end      
                   end 
            default:begin
                        Snoop_Result_data_d=0;
                        Snoop_MESI_WriteData=2'b00;
                        Snoop_Change=1'b0;   
                    end
        endcase
    end 
end 

//Registering the response signals to give as Response Bus

reg [MEM_DATA_WIDTH-1:0] Snoop_Result_Bus_Data;
reg [1:0] Snoop_Result_Bus_MESI;

always @(posedge clk)
begin
    if(rst) begin
        Snoop_Result_Bus_Data <=0;
        Snoop_Result_Bus_MESI <=0;
    end
        
    else begin
        if(Snoop_Req_Valid_Reg) begin
           Snoop_Result_Bus_Data <= Snoop_Result_data_d;
           Snoop_Result_Bus_MESI <= Snoop_MESI_Dout;
        end
    end   
end 

// Snoop Result output to SCU------------------------------
assign Snoop_Result_Bus[255:0]      = Snoop_Result_Bus_Data;
assign Snoop_Result_Bus[257:256]    = Snoop_Result_Bus_MESI; 
assign Snoop_Result_Bus[259:258]    = CORE_ID;  
assign Snoop_Result_Bus_Valid       = Snoop_Req_Valid_Reg2 ;


//updation of the Memory (MESI Bits mainly)
assign MESI_dinb = Snoop_MESI_WriteData;

assign MESI_Way0_Web= Snoop_Change && Snoop_Compare_Way[0];
assign MESI_Way1_Web= Snoop_Change && Snoop_Compare_Way[1];
assign MESI_Way2_Web= Snoop_Change && Snoop_Compare_Way[2];
assign MESI_Way3_Web= Snoop_Change && Snoop_Compare_Way[3];
assign MESI_WAddb= Snoop_Index_Reg;

//************************************************************END OF PORTB Control*************************************************************************************************
//*********************************************************************************************************************************************************************************
//*********************************************************************************************************************************************************************************


//*************************************************************PORT A COntrol************************************************************************************************

//Instantiation of PMA PMA is used to identify whether the corresponding request is private request or Cacheable Memory Request or Non Cacheable Memory Request

wire [55:0] PMA_Addr = DCache_Req_Paddr ;// need to change according to the boundary crossover condition
wire Access_Allowed;
wire [`DATA_TYPE__LEN-1:0] AccessType_Bus= DCache_Req_DataType; // Check this 
wire [`PMA_ATTR__LEN-1:0] PMA_Attributes;

PMA 
  #(.PORTS(1))
  DCACHE_PMA 
  (
    .Paddr_Bus  ({8'b0,DCache_Req_Paddr}),
    .PMA_Check_Enable (1'b1),
    .AccessType_Bus(AccessType_Bus),
    .AccessAllowed_Bus(Access_Allowed),
    .PMA_Attributes_Bus(PMA_Attributes) 
  );
  
 // Registered PMA Access Signals and Registering of Signals 
 reg PMA_Access_Allowed_Reg;
 reg  [`PMA_ATTR__LEN-1:0] PMA_Attributes_Reg;

always @(posedge clk)
begin
    if (rst) begin
        PMA_Access_Allowed_Reg<=0;
        PMA_Attributes_Reg<=0; 
    end 
    else begin 
        PMA_Access_Allowed_Reg<=Access_Allowed;
        PMA_Attributes_Reg<=PMA_Attributes;
    end
end 

//Checking Accessibility of Address...one clock cycle latency due to registering 

wire Private_Aceess = (PMA_Attributes_Reg[`PMA_ATTR_CACHEABLE]==`PMA_ATTR_CACHEABLE__FALSE) & (PMA_Attributes_Reg[`PMA_ATTR_BUS]==`PMA_ATTR_BUS__PRIVATE);
wire Cacheable_Access= !(PMA_Attributes_Reg[`PMA_ATTR_CACHEABLE]==`PMA_ATTR_CACHEABLE__FALSE);

/****************************************************************************************************************************** 
Sequence of operation requied for different cases with respect to the address and Cache hit (or different possibility)

Cache Hit               ------> Tag Match and MESI State in (S) (M) or (E)

Cache Boundary Cross    ------> if double and offset is higher than >24
                        ------> if word and offset is higher than >28
                        ------> if hw  and offset is higher than >30

                      if cache boundary is crossed then we need to Access two cache line be accessed
                      and in this case both access may call for bus transaction etc depenidng up on the MESI state of the 
                      each line
                      
                      It is like repeating the same steps again and again (Same Step can be repeated)
                      
In this design Cache flush will be taken care only after the current operation is completed

priority order
-------------> Private Access   -----> No Cache Access and Main Bus Access  ---> initiate Private Bus Access
------------->!Cacheable Access--> Check after Private Access Only ---> No Cache Access but need to Access main bus
------------->Cacheable Access---> 
                                   -----> Boundary Cross           ----> Two Access to Cache as well as the main bus
                                                                   ----> Two times Cycle need to be done
                                   -----> Cache Hit or Miss        ----> ??
                                            ----> Miss             ----> ??
                                                            ----> Replace needed Based on the LRU given by the PLRU ?
                                                            ----> if no Replace then go for allocation  
                                           -----> Hit       -----> do not look in the LRU given way at alll.........
                                                            -----> Just proceed with the Hit way and do your operation
                                                            
                                           ------> Initiate bus transacation if requried
                   .............................
                  ||                           ||                                                   
 Start-------> Compare----> replace-----> Allocation
*////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//-------------------------------- Registering the Input Signals--------------------------------------------------------
reg                                 DCache_Req_Valid_Reg;
reg                                 DCache_Req_Type_Reg;  //Write or Read Indication 
reg [`DATA_TYPE__LEN-1:0]           DCache_Req_DataType_Reg;
reg [55:0]                          DCache_Req_Paddr_Reg;
reg [63:0]                          DCache_Req_Wrdata_Reg;
reg                                 DCache_Req_Rdabort_Reg;

always@(posedge clk)
begin
    if(rst) begin
        DCache_Req_Valid_Reg<=0;
        DCache_Req_Type_Reg<=0;
        DCache_Req_DataType_Reg<=0;
        DCache_Req_Paddr_Reg<=0;
        DCache_Req_Wrdata_Reg<=0;
    end else if(pr_state==START) 
    begin  
        DCache_Req_Valid_Reg<=DCache_Req_Valid;
        DCache_Req_Type_Reg<=DCache_Req_Type;
        DCache_Req_DataType_Reg<=DCache_Req_DataType;
        DCache_Req_Paddr_Reg<=DCache_Req_Paddr;
        DCache_Req_Wrdata_Reg<=DCache_Req_Wrdata;
          
    end
end

always@(posedge clk)
begin 
    if(rst || pr_state==START) begin
        DCache_Req_Rdabort_Reg<=0;
    end else if(DCache_Req_Rdabort)begin
        DCache_Req_Rdabort_Reg<=1'b1;
    end
    
end

//Checking Boundary Cross
wire [4:0]Offset = DCache_Req_Paddr_Reg[4:0];
reg Boundary_Cross;

always @(*)
begin 
Boundary_Cross=0;
    if((DCache_Req_DataType_Reg[1:0]==2'b11) && (Offset>5'b11000)) begin
        Boundary_Cross=1'b1;
    end 
    else if ((DCache_Req_DataType_Reg[1:0]==2'b10) && (Offset>5'b11100)) begin
         Boundary_Cross=1'b1;
    end
    else if ((DCache_Req_DataType_Reg[1:0]==2'b01) && (Offset>5'b11110)) begin 
         Boundary_Cross=1'b1;
    end
    else begin
        Boundary_Cross=1'b0;
    end
end
// Boundary_Cross_Final is only significant if it is Cache Access and  otherwise dont need to check

wire Boundary_Cross_Final=Boundary_Cross && Cacheable_Access; 
                                                                      
                                                                     
//Retrieving PORT A Index and Offset So that it can get the information Cache

wire [55:0]  DCache_Req_Paddr_Cross = DCache_Req_Paddr_Reg + 32 ;  // in the case boundary cross the address is increased by 32     
                                // and it is better to strip the tag and the index from the updated physical address.
                                 

reg Cacheline_Cross_Access; // A signal from the FSM indicating 2nd Cacheline being Accessed.
 
wire [MEM_TAG_WIDTH-1:0] Processor_Req_Tag;    
wire [MEM_DEPTH_LEN-1:0] Processor_Req_Index; 

assign Processor_Req_Tag   = Cacheline_Cross_Access? DCache_Req_Paddr_Cross[CACHE_TAG_END:CACHE_TAG_START]:DCache_Req_Paddr_Reg[CACHE_TAG_END:CACHE_TAG_START];
assign Processor_Req_Index = flush_ongoing?flush_index:(Cacheline_Cross_Access? DCache_Req_Paddr_Cross[CACHE_INDEX_END:CACHE_INDEX_START]:((pr_state==START)?DCache_Req_Paddr[CACHE_INDEX_END:CACHE_INDEX_START]:DCache_Req_Paddr_Reg[CACHE_INDEX_END:CACHE_INDEX_START]));

//Assigning the address to memory 
reg [MEM_DEPTH_LEN-1:0] flush_index;

assign MESI_WAdda       = Processor_Req_Index;
assign MESI_RAdda       = Processor_Req_Index;
assign mem_data_addra   = Processor_Req_Index;
assign mem_tag_addra    = Processor_Req_Index;
assign mem_data_dina    = allocate_line? SCU_Cacheline_Reg:Cache_temp_write_line;
assign mem_tag_dina     = Processor_Req_Tag; // Tag will be written in the case of allocation only.

//................... Calculating the HIT Signals.................\
 wire [3:0] Proc_Cmp_Way;

wire [MEM_TAG_WIDTH-1:0]  Proc_Tag_Dout_Way0 = mem_tag_douta[0];
wire [MEM_TAG_WIDTH-1:0]  Proc_Tag_Dout_Way1 = mem_tag_douta[1];
wire [MEM_TAG_WIDTH-1:0]  Proc_Tag_Dout_Way2 = mem_tag_douta[2];
wire [MEM_TAG_WIDTH-1:0]  Proc_Tag_Dout_Way3 = mem_tag_douta[3];

assign Proc_Cmp_Way[0] = (MESI_Way0_douta!=2'b00)? ((Processor_Req_Tag==Proc_Tag_Dout_Way0)? 1'b1:1'b0):1'b0;
assign Proc_Cmp_Way[1] = (MESI_Way1_douta!=2'b00)? ((Processor_Req_Tag==Proc_Tag_Dout_Way1)? 1'b1:1'b0):1'b0;
assign Proc_Cmp_Way[2] = (MESI_Way2_douta!=2'b00)? ((Processor_Req_Tag==Proc_Tag_Dout_Way2)? 1'b1:1'b0):1'b0;
assign Proc_Cmp_Way[3] = (MESI_Way3_douta!=2'b00)? ((Processor_Req_Tag==Proc_Tag_Dout_Way3)? 1'b1:1'b0):1'b0;

 wire Proc_Hit = |Proc_Cmp_Way;

wire Double_Load_Store= (DCache_Req_DataType_Reg==`DATA_TYPE_D); 
                                                // indicate the transcation is for a double    
                                                // this will be used in the case of a peripheral or private bus trascation 
                                                // Basic bus width is 32 only... Will require 2 transcation for getting 64 width word 
                                                                                        

/**************************************************************************************************************
.......................................Assigning Some Signals Related to Private Bus............................*/
assign Private_Bus_Address          =  DCache_Req_Paddr_Reg ;
assign Private_Bus_Write_Data       =  DCache_Req_Wrdata_Reg;      
assign Private_Bus_Write_Read       =  DCache_Req_Type_Reg ;
assign Private_Bus_Double           =  Double_Load_Store;    
assign Private_Bus_Start            =  Private_Bus_Start_Temp;                                             
                                              

/**Instantiation of PLRU4(Psuedo Least Recently Used ) for replacement ----------------------------------------*/
wire [MEM_DEPTH_LEN-1:0] PLRU_Read_Set, PLRU_Write_Set;
wire [1:0] PLRU_Readway;
reg PLRU_Read_Access, PLRU_Write_Access;
wire [1:0] LRU_Way;


assign PLRU_Read_Set = Processor_Req_Index; // The Index that is being read or written is given as the Read Set
                                           // In first access that is set which is stripped from the address
                                          //  In Second Access that is the address of the next cache liine
assign PLRU_Write_Set= Processor_Req_Index;            

// Signals PLRU_Read_Access and PLRU_Write_Access will be controlled by the FSM
// It should be ensured that read Access and Write acess are assereted at the same time.
assign PLRU_Readway= Processor_Readway;
PLRU4
#(.SETS(128)) DCache_PLRU
(
    .clk(clk),
    .rst(rst),
    .UpdateEn(1'b1),
    .ReadSet(PLRU_Read_Set),
    .ReadWay(PLRU_Readway),
    .ReadAccess(PLRU_Read_Access),
    .WriteSet(PLRU_Write_Set),
    .WriteWay(LRU_Way),
    .WriteAccess(PLRU_Write_Access),
    .LRU_Way(LRU_Way)
);                                             
/*****************************************Selection of Processor MESI and Readline ****************************************/
/**It Should be noted that in a Cache hit Scenario when we a get the information that cache is hit from the comparison 
bits Tag infromation is not significant. But Tag information has importance in two Circumstances
            1) Cache Is hit and MESI bit state is in Shared and It is a write operation --In that Case when we do 
               a Busupgr operation we need to provide the Tag infromation so that other Caches can compare and validate
               
            2) Cache is not hit and we need to replace one of the set, in that case also we need to have Tag information 
               (replace will be done only in the Modified state)
        
 If Cache is hit we take the data, Tag and MESI Bit information from the corresponding Way which is hit other wise we take FROM LRU indicated 
 by the PLRU               
            
*/
reg [MEM_DATA_WIDTH-1:0] Processor_Cacheline; // Muxed Data output 
reg [1:0] Processor_MESI_Dout;
reg [MEM_TAG_WIDTH-1:0] Processor_Tagline;
reg [1:0] Processor_Readway;
reg [1:0] Flush_way;

always@(*)
begin
    if (flush_ongoing) begin
        case(Flush_way)
            2'b00:begin
                    Processor_Cacheline=mem_data_douta[0];
                    Processor_MESI_Dout=MESI_Way0_douta;
                    Processor_Tagline  =mem_tag_douta[0];
                    Processor_Readway  =2'b00;
                  end
                  
            2'b01:begin
                    Processor_Cacheline=mem_data_douta[1];
                    Processor_MESI_Dout=MESI_Way1_douta;
                    Processor_Tagline  =mem_tag_douta[1];
                    Processor_Readway  =2'b01;
                  end
                  
            2'b10:begin
                    Processor_Cacheline=mem_data_douta[2];
                    Processor_MESI_Dout=MESI_Way2_douta;
                    Processor_Tagline  =mem_tag_douta[2];
                    Processor_Readway  =2'b10;
                  end
                  
            2'b11:begin
                    Processor_Cacheline=mem_data_douta[3];
                    Processor_MESI_Dout=MESI_Way3_douta;
                    Processor_Tagline  =mem_tag_douta[3]; 
                    Processor_Readway  =2'b11;    
                  end
            default:begin
                        Processor_Cacheline=0;
                        Processor_MESI_Dout=0;
                        Processor_Tagline  =0; 
                        Processor_Readway  =2'b00;
                    end
            
        endcase
    end else if(Proc_Hit) begin // if Cache_Hit then 
        case(Proc_Cmp_Way) 
            4'b0001: begin
                        Processor_Cacheline=mem_data_douta[0];
                        Processor_MESI_Dout=MESI_Way0_douta;
                        Processor_Tagline  =mem_tag_douta[0];
                        Processor_Readway  =2'b00;
                     end
            4'b0010:begin
                        Processor_Cacheline=mem_data_douta[1];
                        Processor_MESI_Dout=MESI_Way1_douta;
                        Processor_Tagline  =mem_tag_douta[1];
                        Processor_Readway  =2'b01;
                    end
            4'b0100:begin
                        Processor_Cacheline=mem_data_douta[2];
                        Processor_MESI_Dout=MESI_Way2_douta;
                        Processor_Tagline  =mem_tag_douta[2];
                        Processor_Readway  =2'b10;
                    end
            4'b1000:begin
                        Processor_Cacheline=mem_data_douta[3];
                        Processor_MESI_Dout=MESI_Way3_douta;
                        Processor_Tagline  =mem_tag_douta[3]; 
                        Processor_Readway  =2'b11;      
                    end
            default:begin
                        Processor_Cacheline=0;
                        Processor_MESI_Dout=0;
                        Processor_Tagline  =0; 
                        Processor_Readway  =2'b00;
                    end
        endcase   
    end else begin
        case(LRU_Way)
            2'b00: begin
                        Processor_Cacheline=mem_data_douta[0];
                        Processor_MESI_Dout=MESI_Way0_douta;
                        Processor_Tagline  =mem_tag_douta[0];
                        Processor_Readway  =2'b00;
                   end
            2'b01: begin
                        Processor_Cacheline=mem_data_douta[1];
                        Processor_MESI_Dout=MESI_Way1_douta;
                        Processor_Tagline  =mem_tag_douta[1];
                        Processor_Readway  =2'b01;
                        
                   end
            2'b10: begin
                        Processor_Cacheline=mem_data_douta[2];
                        Processor_MESI_Dout=MESI_Way2_douta;
                        Processor_Tagline  =mem_tag_douta[2];
                        Processor_Readway  =2'b10;
                   end
            2'b11: begin
                        Processor_Cacheline=mem_data_douta[3];
                        Processor_MESI_Dout=MESI_Way3_douta;
                        Processor_Tagline  =mem_tag_douta[3];   
                        Processor_Readway  =2'b11;   
                   end
            default:begin
                        Processor_Cacheline=0;
                        Processor_MESI_Dout=0;
                        Processor_Tagline  =0; 
                        Processor_Readway  =2'b00;
                    end
        endcase;
    end
end


/**********************************************Generating Write Enable Mask considering Boundary Crossover********************/
// 31:0 to be used for first cacheline and 63:32 for second cacheline
reg [63:0] store_WE_mask;
integer shift_val;
always @(*) begin 
    shift_val=DCache_Req_Paddr_Reg[4:0];
    case(DCache_Req_DataType_Reg[1:0])
    2'b00:begin                 //store_byte
           store_WE_mask= (64'h01 << shift_val);
          end 
          
    2'b01:begin                 //halfword
           store_WE_mask= (64'h03 << shift_val);
          end 
         
          
    2'b10:begin                 //word
          store_WE_mask= (64'h0F << shift_val);
          end
    
    2'b11:begin                 //double word;
          store_WE_mask= (64'hFF << shift_val);
          end
    default:begin
          store_WE_mask=0;  
          end
    endcase;
end


//Unalligned Store Writedata generation
reg [255:0] Cache_temp_write_line; // A temporary Cacheline generatd from the data to be written to support unalligned store operation
                                   // This temporary Cacheline and Store_WEmask together will do unalligned store operation
always @(*)
begin
    case (DCache_Req_Paddr_Reg[2:0])
    3'b000:begin 
           Cache_temp_write_line={4{DCache_Req_Wrdata_Reg}};
           end
    3'b001:begin 
           Cache_temp_write_line={DCache_Req_Wrdata_Reg[55:0],{3{DCache_Req_Wrdata_Reg}},DCache_Req_Wrdata_Reg[63:56]}; 
           end
    3'b010:begin 
           Cache_temp_write_line={DCache_Req_Wrdata_Reg[47:0],{3{DCache_Req_Wrdata_Reg}},DCache_Req_Wrdata_Reg[63:48]}; 
           end              
    3'b011:begin
           Cache_temp_write_line={DCache_Req_Wrdata_Reg[39:0],{3{DCache_Req_Wrdata_Reg}},DCache_Req_Wrdata_Reg[63:40]};   
           end
    3'b100:begin 
           Cache_temp_write_line={DCache_Req_Wrdata_Reg[31:0],{3{DCache_Req_Wrdata_Reg}},DCache_Req_Wrdata_Reg[63:32]}; 
           end
    3'b101:begin 
           Cache_temp_write_line={DCache_Req_Wrdata_Reg[23:0],{3{DCache_Req_Wrdata_Reg}},DCache_Req_Wrdata_Reg[63:24]};  
           end
    3'b110:begin 
           Cache_temp_write_line={DCache_Req_Wrdata_Reg[15:0],{3{DCache_Req_Wrdata_Reg}},DCache_Req_Wrdata_Reg[63:16]};  
           end
    3'b111:begin 
           Cache_temp_write_line={DCache_Req_Wrdata_Reg[7:0],{3{DCache_Req_Wrdata_Reg}},DCache_Req_Wrdata_Reg[63:8]};  
           end                                
    default:begin
           Cache_temp_write_line={4{DCache_Req_Wrdata_Reg}};
            end 
    endcase
end
//To be noted that, it is possible that when we do an allocation for the purpose of the write operation we can add the data also to the received cacheline from SCU
//and write total modified cacheline directly to the cache totally. But due to the unalligned access and different datatypes present this may lead to lot of combinational circuit
// and in order to avoid this here in case of write operation allocation is written and in next clock cycle only the value to be written will be added


//Unalligned Read_Data Generation: It is to be noted that due to the unalligned access and possibility of the multiple cacheline access we need to have two Cacheline 

wire [255:0] Cache_Temp_Readline; // A temporary signal to be mapped to cacheline or SCU response accordingly 
reg  [63:0]  Cache_Temp_Readdata; // A temporary wire 


assign Cache_Temp_Readline = allocate_line? SCU_Cacheline_Reg:Processor_Cacheline; 

always @(*)
begin 
    case(DCache_Req_Paddr_Reg[4:0])
      5'b00000 : Cache_Temp_Readdata = Cache_Temp_Readline[63:0];
      5'b00001 : Cache_Temp_Readdata = Cache_Temp_Readline[71:8];
      5'b00010 : Cache_Temp_Readdata = Cache_Temp_Readline[79:16];
      5'b00011 : Cache_Temp_Readdata = Cache_Temp_Readline[87:24];
      5'b00100 : Cache_Temp_Readdata = Cache_Temp_Readline[95:32];
      5'b00101 : Cache_Temp_Readdata = Cache_Temp_Readline[103:40];
      5'b00110 : Cache_Temp_Readdata = Cache_Temp_Readline[111:48];
      5'b00111 : Cache_Temp_Readdata = Cache_Temp_Readline[119:56];
      5'b01000 : Cache_Temp_Readdata = Cache_Temp_Readline[127:64];
      5'b01001 : Cache_Temp_Readdata = Cache_Temp_Readline[135:72];
      5'b01010 : Cache_Temp_Readdata = Cache_Temp_Readline[143:80];
      5'b01011 : Cache_Temp_Readdata = Cache_Temp_Readline[151:88];
      5'b01100 : Cache_Temp_Readdata = Cache_Temp_Readline[159:96];
      5'b01101 : Cache_Temp_Readdata = Cache_Temp_Readline[167:104];
      5'b01110 : Cache_Temp_Readdata = Cache_Temp_Readline[175:112];
      5'b01111 : Cache_Temp_Readdata = Cache_Temp_Readline[183:120];
      5'b10000 : Cache_Temp_Readdata = Cache_Temp_Readline[191:128];
      5'b10001 : Cache_Temp_Readdata = Cache_Temp_Readline[199:136];
      5'b10010 : Cache_Temp_Readdata = Cache_Temp_Readline[207:144];
      5'b10011 : Cache_Temp_Readdata = Cache_Temp_Readline[215:152];
      5'b10100 : Cache_Temp_Readdata = Cache_Temp_Readline[223:160];
      5'b10101 : Cache_Temp_Readdata = Cache_Temp_Readline[231:168];
      5'b10110 : Cache_Temp_Readdata = Cache_Temp_Readline[239:176];
      5'b10111 : Cache_Temp_Readdata = Cache_Temp_Readline[247:184];
      5'b11000 : Cache_Temp_Readdata = Cache_Temp_Readline[255:192];
      5'b11001 : Cache_Temp_Readdata = {Cache_Temp_Readline[7:0],Cache_Temp_Readline[255:200]};
      5'b11010 : Cache_Temp_Readdata = {Cache_Temp_Readline[15:0],Cache_Temp_Readline[255:208]};
      5'b11011 : Cache_Temp_Readdata = {Cache_Temp_Readline[23:0],Cache_Temp_Readline[255:216]};
      5'b11100 : Cache_Temp_Readdata = {Cache_Temp_Readline[31:0],Cache_Temp_Readline[255:224]};
      5'b11101 : Cache_Temp_Readdata = {Cache_Temp_Readline[39:0],Cache_Temp_Readline[255:232]};
      5'b11110 : Cache_Temp_Readdata = {Cache_Temp_Readline[47:0],Cache_Temp_Readline[255:240]};
      5'b11111 : Cache_Temp_Readdata = {Cache_Temp_Readline[55:0],Cache_Temp_Readline[255:248]};       
    endcase
end

reg [63:0] Cache_Temp_Readdata_reg;
reg first_cacheline_wen;    // a signal to be asserted from the FSM for storing the first byte from the first cacheline access
// registering Shadow register-----
always @(posedge clk)
begin 
    if(rst) begin
        Cache_Temp_Readdata_reg<=0;
    end 
    else if(first_cacheline_wen) begin
        Cache_Temp_Readdata_reg<=Cache_Temp_Readdata;
    end
end  
//generating the load mask

reg signed [7:0] load_mask; // A intermittent mask signal indicating which all byte to be taken from the second cacheline

always @(*)
begin 
    case(DCache_Req_DataType_Reg[1:0])
        2'b00: load_mask=8'b00000000;                      //store byte no need to take from second cacheline ever
        2'b01: begin                                       //Halfword
               if(DCache_Req_Paddr_Reg[4:0]>5'b11110)begin
               load_mask=8'b11111110;                     // first byte from the first cacheline else from second cacheline
               end else 
               begin
               load_mask=8'b00000000; 
               end
               end
        2'b10: begin                                     //word
               if(DCache_Req_Paddr_Reg[4:0]>5'b11100)begin
               load_mask=$signed(8'b11111000) >>> (DCache_Req_Paddr_Reg[4:0]-29);                     // first byte from the first cacheline else from second cacheline
               end else 
               begin
               load_mask=8'b00000000; 
               end
               end
        2'b11:begin 
               if(DCache_Req_Paddr_Reg[4:0]>5'b11000)begin
               load_mask=$signed(8'b10000000) >>> (DCache_Req_Paddr_Reg[4:0]-25);                     // first byte from the first cacheline else from second cacheline
               end else 
               begin
               load_mask=8'b00000000; 
               end  
               end
         default:begin  
               load_mask=8'b00000000;
               end  
    endcase
end

wire [63:0] Cache_Read_Data_temp1; // A temporary Signal generated for read data
                                // This is a muxed output between Cache_Temp_Readdata_reg and Cache_Temp_Readdata based on loadmask
                                
assign Cache_Read_Data_temp1[7:0]   =(Boundary_Cross==1'b1)?Cache_Temp_Readdata_reg[7:0]:Cache_Temp_Readdata[7:0];
assign Cache_Read_Data_temp1[15:8]  =(Boundary_Cross==1'b1)?((load_mask[1]==1'b1 )? Cache_Temp_Readdata[15:8]:Cache_Temp_Readdata_reg[15:8]):Cache_Temp_Readdata[15:8];
assign Cache_Read_Data_temp1[23:16] =(Boundary_Cross==1'b1)?((load_mask[2]==1'b1)? Cache_Temp_Readdata[23:16]:Cache_Temp_Readdata_reg[23:16]):Cache_Temp_Readdata[23:16];
assign Cache_Read_Data_temp1[31:24] =(Boundary_Cross==1'b1)?((load_mask[3]==1'b1)? Cache_Temp_Readdata[31:24]:Cache_Temp_Readdata_reg[31:24]):Cache_Temp_Readdata[31:24];                                                                                             
assign Cache_Read_Data_temp1[39:32] =(Boundary_Cross==1'b1)?((load_mask[4]==1'b1)? Cache_Temp_Readdata[39:32]:Cache_Temp_Readdata_reg[39:32]):Cache_Temp_Readdata[39:32];
assign Cache_Read_Data_temp1[47:40] =(Boundary_Cross==1'b1)?((load_mask[5]==1'b1)? Cache_Temp_Readdata[47:40]:Cache_Temp_Readdata_reg[47:40]):Cache_Temp_Readdata[47:40];
assign Cache_Read_Data_temp1[55:48] =(Boundary_Cross==1'b1)?((load_mask[6]==1'b1)? Cache_Temp_Readdata[55:48]:Cache_Temp_Readdata_reg[55:48]):Cache_Temp_Readdata[55:48];
assign Cache_Read_Data_temp1[63:56] =(Boundary_Cross==1'b1)?((load_mask[7]==1'b1)? Cache_Temp_Readdata[63:56]:Cache_Temp_Readdata_reg[63:56]):Cache_Temp_Readdata[63:56];


/*********************************Stripping Data from the Cache_Snoop_Resp_Bus*******************************************************
*************************************************************************************************************************************
Cache_Snoop_Resp_Bus contains the answer from the SCU for the request made from the caches
it contains following information

Cache_Snoop_Resp_Bus [255:0]----------->Data[255:0] 
                                    --->In the case of a peripheral operation only [63:0] will be filled with the data        
                     [257:256]--------->COREID this to verified by cache to identify whether the response is valid for particular Cache
                     [259:258]--------->Response Type
                                        00----> Indicate a result for Peripheral transfer
                                        01----> Indicate Cache to Cache transfer
                                                    (to be used to to modify the MESI bits)
                     `                  10----> Indicate A memory transfer, result taken from memory
                                                (Can be changed to Exclusive)
                                        11----> Flush Operation is completed  (Indicate a Flush Operation is completed)
                    ---->Physical Address is not included currently, can be added for additional checks etc
                    ---->currently CORE_ID only used for validataion of Cache */
                     
wire [255:0]    SCU_Cacheline       = Cache_Snoop_Resp_Bus[255:0];
wire [1:0]  SCU_COREID              = Cache_Snoop_Resp_Bus[257:256];
wire [1:0]  SCU_ResponseType        = Cache_Snoop_Resp_Bus[259:258];
// registering the SCU Response if it is valid response for the same Cache

reg [255:0]     SCU_Cacheline_Reg;
reg [1:0]       SCU_COREID_Reg;
reg [1:0]       SCU_ResponeType_Reg;

always @(posedge clk)
begin 
   if(rst || pr_state==START) begin 
    SCU_Cacheline_Reg<=0;
    SCU_COREID_Reg<=0;
    SCU_ResponeType_Reg<=0;
   end
   else if(SCU_COREID==CORE_ID && Cache_Snoop_Resp_Valid )begin  
        SCU_Cacheline_Reg   <=  SCU_Cacheline;
        SCU_COREID_Reg      <=  SCU_COREID;
        SCU_ResponeType_Reg <=  SCU_ResponseType;
   end
end 


//..................FLUSHING LOGIC................................
reg [127:0] Way0_Modified, Way1_Modified, Way2_Modified, Way3_Modified;

integer k;
always @(*)
begin 
    for(k=0;k<128;k=k+1) begin
    Way0_Modified[k]=& MESI_WAY0[k]; 
    Way1_Modified[k]=& MESI_WAY1[k];
    Way2_Modified[k]=& MESI_WAY2[k];
    Way3_Modified[k]=& MESI_WAY3[k];
    end;
end 

wire Way0_flush_skip = |Way0_Modified; // will be one if any of the set is in  modified 
wire Way1_flush_skip = |Way1_Modified;
wire Way2_flush_skip = |Way2_Modified;   
wire Way3_flush_skip = |Way3_Modified;

reg [MEM_DEPTH_LEN-1:0] index_incr;
always @(posedge clk)
begin
    if(rst || pr_state==START)begin
        Flush_way<=2'b00;
        flush_index<=0;    
    end else begin 
        if (incr_way) begin 
            Flush_way<=Flush_way+1;
        end
        if(incr_index) begin
          flush_index<=index_incr;
        end else if (flush_index_rst) begin
           flush_index<=2'b00;
        end
    end
end 

integer z;
reg done;

  always @(*) begin
    index_incr = 0;
    done = 0;
    case (Flush_way)
        2'b00: begin
               for (z=0; z< 128; z=z+1) begin
                    if (Way0_Modified[z] & (!done)) begin
                        index_incr = z;
                        done = 1;
                    end
               end
            end
        2'b01: begin
               for (z=0; z< 128; z=z+1) begin
                    if (Way1_Modified[z] & (!done)) begin
                        index_incr = z;
                        done = 1;
                    end
               end
               end
        2'b10: begin
               for (z=0; z< 128; z=z+1) begin
                    if (Way2_Modified[z] & (!done)) begin
                        index_incr = z;
                        done = 1;
                    end
               end
               end
        2'b11: begin
               for (z=0; z< 128; z=z+1) begin
                    if (Way3_Modified[z] & (!done)) begin
                        index_incr = z;
                        done = 1;
                    end
               end
               end
      default: begin
               index_incr = 0;
               done = 0;
               end
    endcase
  end

//This registerd signals should be used for further activities
/****************************************************************************************************************************** 
Coherence Bits and Action to be taken for processor read or write operations

Invalid    --> Processor Read  -----> Initiate a busrd operation   ---> Get the data from the SCU 
                                                                   ---> Change MESI State to S if Cache to Cache transfer
                                                                   ---> Change MESI State to E if reply from Memory 
                                                                   
           --> Processor Write -----> Initiate a busrdx operation  ---> Get the data from the SCU
                                                                   ---> Change MESI State to M
                                             
Exclusive  -->Verygood State   
           -->Processor Read    -----> Do it and go Man            ---> No need to change MESI
           -->Processor Write   -----> Do it No need of Bus Oper   ---> Change State to Modified
     
           
Shared     -->Processor Read    -----> Do it and go Man            ---> No need of MESI State Change 
           -->Processor Write   -----> Do it and then initiate     ---> Change state to Modified 
                                       Busupgr option 
                                       
Modified   -->Processor Read    -----> Do it and no need Bus       ---> No need of state change 
                                       transaction          
           -->Processor Write   -----> Do it and no need of bus    ---> No need of state change
                                       transaction
*////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////PORT A FSM(Processor Cachec Controller FSM)///////////////////////////////////////////////


//State Declarations
reg [3:0] pr_state, nx_state;
localparam START        = 4'b0000;
localparam COMPARE_1    = 4'b0001;
localparam FLUSH        = 4'b0010; 
localparam BUS_INIT     = 4'b0011;    
localparam SNOOP_WAIT1  = 4'b0100;
localparam Nx_Line_Wait = 4'b0101;
localparam ALLOCATE1    = 4'b0110;
localparam BUS_INIT_WAIT= 4'b0111;
localparam FLUSH_2      = 4'b1000;
localparam FLUSH_2_WAIT = 4'b1001;
 
always @(posedge clk) 
begin
    if(rst)begin 
         pr_state<=START;
    end else 
    begin
         pr_state<=nx_state;
    end 
end 

//Output and control signal logics;
reg  DCache_Ready;                   // Signal Indicating that Dcache is ready for next transaction 
reg  Private_Bus_Start_Temp;         // Signal to Start Private Bus transcation  
reg  DCache_FSM_Done;
reg  Cacheline_Cross_Access_Wen;
reg  allocate_line;                 // Control signal that select between Response from the SCU or Cacheline
reg  [1:0] Processor_MESI_WData;
reg  Processor_MESI_Wen;
reg  [31:0] Processor_Data_Wen;
reg  Processor_Tag_Wen;
reg  [2:0] BUS_OP_Value, BUS_OP_Value_Data;
reg  BUS_OP_Wen;
reg  BUS_op_Valid;                  //temporary signal indicate a valid bus op going on 
reg  Peripheral_Op_Comp;
reg  flush_ongoing;
reg  incr_way;
reg  incr_index;
reg  flush_index_rst;
reg  flush_done;
reg  Keep_BUSOP_High_Wen;
always @(*)
begin 
    DCache_Ready=1'b0;                  //In general 0 value
    Private_Bus_Start_Temp=1'b0;
    DCache_FSM_Done=1'b0;
    Cacheline_Cross_Access_Wen=1'b0;
    PLRU_Read_Access=1'b0;
    PLRU_Write_Access=1'b0;
    first_cacheline_wen=1'b0;
    Processor_MESI_WData =2'b00;
    Processor_MESI_Wen=1'b0;
    Processor_Data_Wen=32'b0;
    Processor_Tag_Wen =1'b0;
    allocate_line=1'b0;
    BUS_OP_Value_Data=0;
    BUS_OP_Wen=0;
    BUS_op_Valid=0;
    Peripheral_Op_Comp=0;
    flush_ongoing=1'b0;
    incr_way=1'b0;
    incr_index=1'b0;
    flush_index_rst=1'b0;
    flush_done=1'b0;
    Keep_BUSOP_High_Wen=1'b0;
    case(pr_state)
        START: 
            begin 
                if (Private_Bus_Busy) begin 
                    nx_state= START;           // Be in Start State itself if Private Bus transaction is going on. 
                end else if(DCache_Flush_Req) begin
                    flush_ongoing=1'b1;
                    nx_state=FLUSH;
                end else if(DCache_Req_Valid) begin
                    DCache_Ready=1'b1;
                    if(DCache_Req_Type) begin         // Write Request 
                        nx_state=COMPARE_1;
                    end else if(!DCache_Req_Type && !DCache_Req_Rdabort)begin // A Read Request and No abort Signal
                        nx_state=COMPARE_1;
                    end else begin
                        nx_state=START;
                    end
                end else begin
                    nx_state = START;
                    DCache_Ready=1'b1;
                end
            end
        COMPARE_1: 
            begin
                if(DCache_Req_Valid_Reg && Private_Aceess) begin  //Valid Request and Private Access
                   if(DCache_Req_Type_Reg || (!DCache_Req_Type_Reg && !DCache_Req_Rdabort)) begin
                        Private_Bus_Start_Temp=1'b1;
                        if(Private_Bus_Busy) begin
                            nx_state=START;
                        end else begin
                            nx_state=COMPARE_1;
                        end
                   end else begin 
                    //   DCache_FSM_Done=1'b1;           //Have a look about this transaction later
                        nx_state =START; 
                   end
                end else if(DCache_Req_Valid_Reg && ((!DCache_Req_Type_Reg && !DCache_Req_Rdabort)||DCache_Req_Type_Reg) && !Cacheable_Access) begin //Valid Request and Non Cacheable peripheral access
                        nx_state =BUS_INIT;                        //We can start bus transcation directly since not cachebale transcation but a peripheral write or read operation    
                        BUS_OP_Wen=1'b1;
                        BUS_OP_Value_Data=3'b100;
                end else if(DCache_Req_Valid_Reg &&((!DCache_Req_Type_Reg && !DCache_Req_Rdabort && !DCache_Req_Rdabort_Reg)||DCache_Req_Type_Reg) )begin
                     if((Snoop_Request_Bus_Valid && Snoop_Tag==Processor_Tagline) || (Snoop_Req_Valid_Reg && (Processor_Tagline==Snoop_Tag_Reg) && Snoop_Hit)) begin // Processor tagline is used in the case of a processor hit it will be same as the recieved address tag other wise it will be the returned value based on the LRU any
                        nx_state = SNOOP_WAIT1;
                     end else begin   
                        if(!Boundary_Cross) begin                 // No boundary_Cross_Best situation ever // Both Hit and Miss to be handled accordingly 
                            if(Proc_Hit) begin                    // Processor Hit Case 
                                if(!DCache_Req_Type_Reg && !DCache_Req_Rdabort) begin      // Read operation and no read abort
                                        PLRU_Read_Access=1'b1;                            // No need to change the MESI bits in case of read and  
                                        DCache_FSM_Done= 1'b1;
                                        nx_state=START;     
                                end else if(DCache_Req_Type_Reg) begin    // Write operation 
                                        if(Processor_MESI_Dout==2'b01 || Processor_MESI_Dout==2'b11) begin // Exclusive or Modified state // No need of BuS operation 
                                            PLRU_Read_Access=1'b1;                                         // Need to modify the MESI Data to Invalid
                                            DCache_FSM_Done=1'b1;
                                            Processor_Data_Wen=store_WE_mask[31:0];
                                            Processor_MESI_Wen=1'b1;
                                            Processor_MESI_WData=2'b11;
                                            nx_state=START;
                                        end else if(Processor_MESI_Dout==2'b10) begin   //Shared State. in this state write shouldn't happen untill the bus is acquired                                
                                            nx_state=BUS_INIT;
                                            BUS_OP_Wen=1'b1;
                                            BUS_OP_Value_Data=3'b101;                  // BUS Upgrade
                                        end else begin
                                            nx_state=START;
                                        end
                                end else begin                        // Read operation but an abort signal asserted  
                                    // DCache_FSM_Done=1'b1;           //Have a look about this transaction later
                                     nx_state =START; 
                                end 
                            end else begin       // processor Miss Case         In case of read or write operation it is same                                                 
                                    // In the case of processor miss we need to check the replacement  whether it has to be written back to memory if it is in modified state.
                                    // else we can directly allocate  in both cases we need to generate the Bus operation 
                                     if(Processor_MESI_Dout==2'b11) begin              //the LRU way is in modified state we need to replace
                                            nx_state=BUS_INIT;
                                            BUS_OP_Wen=1'b1;
                                            BUS_OP_Value_Data=3'b011; //Bus flush Operation due to replacement                                                                         
                                     end else  begin  // Not in modified state hence can directly go for the allocation, In case of read operation need to generate the BUS read operation    
                                                      // In case of wirte operation need to generate a BUSRDx operation 
                                           if(DCache_Req_Type_Reg) begin    // Write Operation 
                                                nx_state=BUS_INIT;
                                                BUS_OP_Wen=1'b1;
                                                BUS_OP_Value_Data=3'b111;  //  BUSRdx Operation
                                           end else begin                        // Read Operation 
                                                nx_state=BUS_INIT;
                                                BUS_OP_Wen=1'b1;
                                                BUS_OP_Value_Data=3'b010;  // BusRead Operation
                                           end                                                   
                                     end 
                            
                            end
                        end else begin                           // Boundary_Cross_Not a good situation two access needed, Hit and miss to be handled accordingly   
                                                                 // 4 Cases, (Hit First Access),(Hit Second Access) (Miss Fist Access) (Miss Second Access)
                            case({Proc_Hit,Cacheline_Cross_Access})
                                2'b00, 2'b01 : begin                               // Cache miss first line access & Cache Miss and Second line Access
                                                    if(Processor_MESI_Dout==2'b11) begin              //the LRU way is in modified state we need to replace
                                                            nx_state=BUS_INIT;
                                                            BUS_OP_Wen=1'b1;
                                                            BUS_OP_Value_Data=3'b011; //Bus flush Operation due to replacement                                                                         
                                                    end else  begin  // Not in modified state hence can directly go for the allocation, In case of read operation need to generate the BUS read operation    
                                                                      // In case of wirte operation need to generate a BUSRDx operation 
                                                           if(DCache_Req_Type_Reg) begin    // Write Operation 
                                                                nx_state=BUS_INIT;
                                                                BUS_OP_Wen=1'b1;
                                                                BUS_OP_Value_Data=3'b111;  //  BUSRdx Operation
                                                           end else begin                        // Read Operation 
                                                                nx_state=BUS_INIT;
                                                                BUS_OP_Wen=1'b1;
                                                                BUS_OP_Value_Data=3'b010;  // BusRead Operation
                                                           end 
                                                    end
                                               end  
                                                                           
                                2'b10 : begin                                     // Cache hit and first access
                                            if(!DCache_Req_Type_Reg && !DCache_Req_Rdabort) begin      // Read operation and no read abort
                                                    PLRU_Read_Access=1'b1;                            // No need to change the MESI bits in case of read and  
                                                    Cacheline_Cross_Access_Wen=1'b1;
                                                    first_cacheline_wen=1'b1;                       // To store the first cacheline to the register
                                                    nx_state=Nx_Line_Wait;     
                                            end else if(DCache_Req_Type_Reg) begin    // Write operation 
                                                    if(Processor_MESI_Dout==2'b01 || Processor_MESI_Dout==2'b11) begin // Exclusive or Modified state // No need of BuS operation 
                                                        PLRU_Read_Access=1'b1;                                         // Need to modify the MESI Data to Modified
                                                        Processor_Data_Wen=store_WE_mask[31:0];
                                                        Processor_MESI_Wen=1'b1;
                                                        Processor_MESI_WData=2'b11;
                                                        Cacheline_Cross_Access_Wen=1'b1;
                                                        first_cacheline_wen=1'b1;                       // To store the first cacheline to the register
                                                        nx_state=Nx_Line_Wait;                                                         
                                                    end else if(Processor_MESI_Dout==2'b10) begin   //Shared State. in this state write shouldn't happen untill the bus is acquired                                
                                                        nx_state=BUS_INIT;
                                                        BUS_OP_Wen=1'b1;
                                                        BUS_OP_Value_Data=3'b101;                  // BUS Upgrade
                                                    end else begin
                                                        nx_state=START;             // Not expecting this                                                               
                                                    end   
                                                    
                                            end else begin
                                                    nx_state=START;
                                                   // DCache_FSM_Done=1'b1;
                                            end          
                                        end             
                                2'b11 : begin                                     // Cache hit and second access
                                            if(!DCache_Req_Type_Reg && !DCache_Req_Rdabort) begin      // Read operation and no read abort
                                                    PLRU_Read_Access=1'b1;                            // No need to change the MESI bits in case of read and  
                                                    nx_state=START;    
                                                    DCache_FSM_Done= 1'b1; 
                                            end else if(DCache_Req_Type_Reg) begin    // Write operation 
                                                    if(Processor_MESI_Dout==2'b01 || Processor_MESI_Dout==2'b11) begin // Exclusive or Modified state // No need of BuS operation 
                                                        PLRU_Read_Access=1'b1;                                         // Need to modify the MESI Data to Modified
                                                        Processor_Data_Wen=store_WE_mask[63:32];
                                                        Processor_MESI_Wen=1'b1;
                                                        Processor_MESI_WData=2'b11;
                                                        DCache_FSM_Done= 1'b1; 
                                                        nx_state=START;                                                         
                                                    end else if(Processor_MESI_Dout==2'b10) begin   //Shared State. in this state write shouldn't happen untill the bus is acquired                                
                                                        nx_state=BUS_INIT;
                                                        BUS_OP_Wen=1'b1;
                                                        BUS_OP_Value_Data=3'b101;                  // BUS Upgrade
                                                    end else begin
                                                        nx_state=START; 
                                                    end   
                                                    
                                            end else begin
                                                    nx_state=START;
                                                   // DCache_FSM_Done=1'b1;
                                            end                             
                                        end
                                 default: begin
                                                nx_state=START;
                                                //DCache_FSM_Done=1'b1; 
                                          end                  
                            endcase           
                        end
                     end              
                end else begin
                       // DCache_FSM_Done=1'b1;          //Have a look about this transaction later 
                        nx_state=START;
                end
            end 
       SNOOP_WAIT1:begin 
                       if(Snoop_Req_Valid_Reg2) begin
                          nx_state=COMPARE_1; 
                       end else begin
                          nx_state=SNOOP_WAIT1; 
                       end
                   end
       Nx_Line_Wait:begin
                       nx_state= COMPARE_1;     
                       if(BUS_OP_Value==3'b111 && Keep_BUSOP_High==1'b1)begin
                        BUS_op_Valid=1'b1; 
                       end
                    end
       BUS_INIT_WAIT:begin
                       nx_state= BUS_INIT; 
                     end 
                    
       BUS_INIT    :begin
                    case(BUS_OP_Value)
                    3'b010,3'b100:              //BUSRd and Peripheral in all these case we can directly initiate the BUS operation and wait for the result to be ready  
                            begin
                              BUS_op_Valid=1'b1;        //Initiating Bus operation as valid signal
                              if(SCU_COREID==CORE_ID && Cache_Snoop_Resp_Valid) begin// indicate a valid result back from SCU unit and corresponding result from the     
                                BUS_op_Valid=1'b0;
                                if(!DCache_Req_Type_Reg && (DCache_Req_Rdabort_Reg||DCache_Req_Rdabort)) begin
                                    nx_state=START;
                                end else begin    
                                    nx_state=ALLOCATE1; // decision with respect to the read or write will in this state only 
                                end                             
                              end else begin
                                nx_state=BUS_INIT;
                              end
                            end
                    3'b111:              //BUSRdx in all these case we can directly initiate the BUS operation and wait for the result to be ready  
                            begin
                              BUS_op_Valid=1'b1;        //Initiating Bus operation as valid signal
                              if(SCU_COREID==CORE_ID && Cache_Snoop_Resp_Valid) begin// indicate a valid result back from SCU unit and corresponding result from the     
                                if(!DCache_Req_Type_Reg && (DCache_Req_Rdabort_Reg||DCache_Req_Rdabort)) begin
                                    nx_state=START;
                                end else begin    
                                    nx_state=ALLOCATE1; // decision with respect to the read or write will in this state only 
                                end                             
                              end else begin
                                nx_state=BUS_INIT;
                              end
                            end       
                            
                            
                    3'b101: begin       //BUS Upgrade operation, if some another processr due to arbitration modify the state of the cacheline to invalid then we shouldn't 
                                        //write to this cacheline, In that case we should proceed replacement and all, Hence we need to check the MESI tag is not getting changed 
                                if(Processor_MESI_Dout!=2'b10) begin //not shared
                                        nx_state=COMPARE_1;           //go back to another check again 
                                end else begin
                                   BUS_op_Valid=1'b1;
                                   if(SCU_COREID==CORE_ID && Cache_Snoop_Resp_Valid) begin// indicate a valid result back from SCU unit      
                                     // Since bus is acquired we can write to the cacheline but need to chech the boundary etc
                                       BUS_op_Valid=1'b0;
                                     if(!Boundary_Cross)begin // No boundary cross then initiate the write and finish the operation 
                                       PLRU_Read_Access=1'b1;                                         // Need to modify the MESI Data to Invalid
                                       DCache_FSM_Done=1'b1;
                                       Processor_Data_Wen=store_WE_mask[31:0];
                                       Processor_MESI_Wen=1'b1;
                                       Processor_MESI_WData=2'b11;
                                       nx_state=START;     
                                     end else begin // Boundary cross, need to check which cacheline is being accesse
                                       if(Cacheline_Cross_Access) begin //second cacheline Access 
                                         PLRU_Read_Access=1'b1;                                         // Need to modify the MESI Data to Invalid
                                         DCache_FSM_Done=1'b1;
                                         Processor_Data_Wen=store_WE_mask[63:32];
                                         Processor_MESI_Wen=1'b1;
                                         Processor_MESI_WData=2'b11;
                                         nx_state=START;  
                                       end else begin
                                         PLRU_Read_Access=1'b1;                                         // Need to modify the MESI Data to Modified
                                         Processor_Data_Wen=store_WE_mask[31:0];
                                         Processor_MESI_Wen=1'b1;
                                         Processor_MESI_WData=2'b11;
                                         Cacheline_Cross_Access_Wen=1'b1;
                                         first_cacheline_wen=1'b1;                       // To store the first cacheline to the register
                                         nx_state=Nx_Line_Wait; 
                                       end                                    
                                     end     
                                   end else begin
                                        nx_state=BUS_INIT;
                                   end  
                                end
                            end         
                    3'b011 :begin   
                            /*Bus replacement, remember that Bus replacement is followed with allocation
                            Here incase during waiting if another processor modify the state of the replacing line to either Shared (read) or Invalid(due to a write option)
                            we can skip the replacement and proceed with the allocation. Hence we need to check whether the MESI States are changed in between 
                            */
                            if(Processor_MESI_Dout!=2'b11) begin // Not modified state
                               nx_state=BUS_INIT_WAIT;
                               BUS_OP_Wen=1'b1;                 // we need to write the Bus allocation
                               if(DCache_Req_Type_Reg) begin   //write operation BUSRDX
                                    BUS_OP_Value_Data=3'b111;                             
                               end else begin                 // Read Operation BUSRD
                                    BUS_OP_Value_Data=3'b010;
                               end 
                            end else begin  // in the modified state only 
                               BUS_op_Valid=1'b1;
                               if(SCU_COREID==CORE_ID && Cache_Snoop_Resp_Valid) begin //replacement is completed can proceed with allocation 
                                   BUS_op_Valid=1'b0; 
                                   Processor_MESI_Wen=1'b1;
                                   Processor_MESI_WData=2'b10;   // Making this cacheline exclusive
                                   if(!DCache_Req_Type_Reg && (DCache_Req_Rdabort_Reg||DCache_Req_Rdabort)) begin                                                
                                       nx_state=START;
                                   end else begin 
                                       nx_state=BUS_INIT_WAIT;
                                       BUS_OP_Wen=1'b1;                 // we need to write the Bus allocation
                                       if(DCache_Req_Type_Reg) begin   //write operation BUSRDX
                                            BUS_OP_Value_Data=3'b111;                             
                                       end else begin                 // Read Operation BUSRD
                                            BUS_OP_Value_Data=3'b010;
                                       end
                                   end                                                  
                               end else begin
                                  nx_state=BUS_INIT; 
                               end 
                            end          
                            end
                     3'b110:begin  //replacement due to a flush operation currently not implemented will do lated now implemented to next state as start
                                flush_ongoing=1'b1;
                                if(Processor_MESI_Dout!=2'b11) begin // Not modified state
                                    nx_state=FLUSH;                 // the set which was supposed to replace was chnage to shared or Invalid by snooping of another bus transcation
                                end else begin 
                                   BUS_op_Valid=1'b1;
                                   if(SCU_COREID==CORE_ID && Cache_Snoop_Resp_Valid) begin //replacement is completed can proceed with allocation 
                                        BUS_op_Valid=1'b0;
                                        Processor_MESI_Wen=1'b1;
                                        Processor_MESI_WData=2'b01;       //make to exclusive as it is on par with memory 
                                        nx_state=FLUSH;                                                    
                                   end else begin
                                        nx_state=BUS_INIT; 
                                   end
                                end
                                  
                            end 
                     default: begin
                                nx_state =START; 
                              end
                    endcase   
                    end                  
       ALLOCATE1: begin   // Can come here BUSRDX, BUSRD and with peripheral access
                  case(BUS_OP_Value)
                  3'b010:begin                                       //BUS read (Need to write to the Cacheline)
                             if(!DCache_Req_Type_Reg && (DCache_Req_Rdabort_Reg||DCache_Req_Rdabort)) begin
                                nx_state=START;
                             end else begin
                                 allocate_line=1'b1;
                                 Processor_Data_Wen=32'hFFFFFFFF;           // all byte need to be written
                                 Processor_Tag_Wen=1'b1;                   // Need to write the tag
                                 PLRU_Write_Access=1'b1;
                                 Processor_MESI_Wen=1'b1;
                                 if(SCU_ResponeType_Reg==2'b01)begin       // A Cache to Cache trasnfer TAg should be written Shared
                                    Processor_MESI_WData=2'b10;
                                 end else if(SCU_ResponeType_Reg==2'b10)begin //A memory transfer...Tag should be written as EXclusive
                                    Processor_MESI_WData=2'b01;
                                 end else begin                              // Not expecting
                                    Processor_MESI_WData=2'b00;
                                 end 
                                 
                                 if(!Boundary_Cross)begin               // no boundary cross only one trasncation end of transacation 
                                     DCache_FSM_Done=1'b1;  
                                     nx_state       =START;
                                 end else begin                        // Boundary  cross need to check first or second transfer 
                                    if(Cacheline_Cross_Access) begin    // Second line then 
                                     DCache_FSM_Done=1'b1;
                                     nx_state       =START;          
                                    end else begin 
                                     Cacheline_Cross_Access_Wen=1'b1;
                                     first_cacheline_wen=1'b1;
                                     nx_state       = Nx_Line_Wait;    
                                    end 
                                 end
                             end
                         end
                  3'b111:begin                                      //BUSReadx  
                         BUS_op_Valid=1'b1;
                         allocate_line=1'b1;                  
                         Processor_Data_Wen=32'hFFFFFFFF;
                         Processor_Tag_Wen=1'b1;
                         Keep_BUSOP_High_Wen=1'b1;
                   //      PLRU_Write_Access=1'b1;
                         Processor_MESI_Wen=1'b1;
                         Processor_MESI_WData=2'b11;    //Putting it as modified already
                         nx_state       = Nx_Line_Wait;  // Actual write again will happen
                         end
                  3'b100:begin
                       //  allocate_line=1'b1; 
                         if(!DCache_Req_Type_Reg && (DCache_Req_Rdabort_Reg||DCache_Req_Rdabort)) begin
                             DCache_FSM_Done=1'b0;
                         end else begin
                             DCache_FSM_Done=1'b1;
                         end 
                         Peripheral_Op_Comp=1'b1;
                         nx_state       =START;  
                         end
                  default:begin
                          DCache_FSM_Done=1'b1;
                          nx_state       =START;
                          end                               
                  endcase
                  end 
        FLUSH  : begin
                 flush_ongoing=1'b1;
                 case(Flush_way) 
                        2'b00: begin
                                    if(!Way0_flush_skip) begin
                                        incr_way=1'b1;
                                        flush_index_rst=1'b1;
                                        nx_state=FLUSH;
                                    end else begin
                                        incr_index=1'b1;
                                        nx_state= FLUSH_2_WAIT;
                                    end
                               end
                        2'b01: begin
                                    if(!Way1_flush_skip) begin
                                        incr_way=1'b1;
                                        flush_index_rst=1'b1;
                                        nx_state=FLUSH;
                                    end else begin
                                        incr_index=1'b1;
                                        nx_state= FLUSH_2_WAIT;
                                    end
                               end
                        2'b10: begin
                                   if(!Way2_flush_skip) begin
                                        incr_way=1'b1;
                                        flush_index_rst=1'b1;
                                        nx_state=FLUSH;
                                   end else begin
                                        incr_index=1'b1;
                                        nx_state= FLUSH_2_WAIT;
                                   end 
                               end
                           
                        2'b11: begin
                                   if(!Way3_flush_skip) begin
                                        incr_way=1'b1;
                                        flush_index_rst=1'b1;
                                        flush_done=1'b1;
                                        nx_state=START;
                                   end else begin
                                        incr_index=1'b1;
                                        nx_state= FLUSH_2_WAIT;
                                   end   
                               end
                        default:begin
                                    nx_state = FLUSH;
                                end
        
                 endcase
                    
                 end
        FLUSH_2_WAIT: begin
                        flush_ongoing=1'b1;
                        nx_state=FLUSH_2;
                      end
        FLUSH_2: begin     
                     flush_ongoing=1'b1;    
                     nx_state =BUS_INIT;                    
                     BUS_OP_Wen=1'b1;
                     BUS_OP_Value_Data=3'b110;   // replacement due to cache replacement operation 
                
                 end   
                  
        default: begin
                    nx_state=START;
                 end           
                    
    endcase
end 


reg Keep_BUSOP_High;

always @(posedge clk)
begin
    if(rst) begin
        Keep_BUSOP_High<=1'b0;
    end else begin 
        Keep_BUSOP_High<=Keep_BUSOP_High_Wen;
    end
end
        

//Cacheline_Cross_Access Register ----Cacheline_Cross_Access Register indicate that second cacheline access is going on 
// if Cacheline_Cross_Access=1 (second cacheline access) else it is first cacheline access
always @(posedge clk)
begin 
    if(rst || nx_state==START) begin
        Cacheline_Cross_Access<=1'b0;
    end else if(Cacheline_Cross_Access_Wen==1'b1) begin
        Cacheline_Cross_Access<=1'b1; 
    end

end
//Registering of Bus operation VAlue----------------------------------
 always @(posedge clk)
 begin
    if(rst || pr_state==START) begin
        BUS_OP_Value<= 3'b000;
    end else if(BUS_OP_Wen) begin
        BUS_OP_Value<=BUS_OP_Value_Data;
    end      
 end



//Mapping the write enable signal to the  corresponding Writeenable signal in the case of hit we should use the compr result in the case of the allocation we should use 
//LRUWay

assign MESI_dina=Processor_MESI_WData;
always @(*)
begin 
MESI_Way0_Wea =1'b0;
MESI_Way1_Wea =1'b0;
MESI_Way2_Wea =1'b0;
MESI_Way3_Wea =1'b0;
mem_data_wea[0]=32'b0;
mem_data_wea[1]=32'b0;
mem_data_wea[2]=32'b0;
mem_data_wea[3]=32'b0;
mem_tag_wea[0]=1'b0;
mem_tag_wea[1]=1'b0;
mem_tag_wea[2]=1'b0;
mem_tag_wea[3]=1'b0;
    
    if(flush_ongoing) begin 
        case(Flush_way)
            2'b00:begin  MESI_Way0_Wea  = Processor_MESI_Wen;    end 
            
            2'b01:begin  MESI_Way1_Wea  = Processor_MESI_Wen;    end 
            
            2'b10:begin  MESI_Way2_Wea  = Processor_MESI_Wen;    end 
            
            2'b11:begin  MESI_Way3_Wea  = Processor_MESI_Wen;    end 
            
            default: begin
                    mem_tag_wea=4'b0;
                    MESI_Way0_Wea =1'b0;
                    MESI_Way1_Wea =1'b0;
                    MESI_Way2_Wea =1'b0;
                    MESI_Way3_Wea =1'b0;
                    mem_data_wea[0]=32'b0;
                    mem_data_wea[1]=32'b0;
                    mem_data_wea[2]=32'b0;
                    mem_data_wea[3]=32'b0;
            end  
        endcase
    end else if(allocate_line) begin // Allocation happen in the case of miss only, then LRUway  need to be used
        case(LRU_Way)
            2'b00:begin
                  MESI_Way0_Wea  =Processor_MESI_Wen;
                  mem_data_wea[0]=Processor_Data_Wen;
                  mem_tag_wea[0] =Processor_Tag_Wen;
                  end  
            2'b01:begin
                  MESI_Way1_Wea  =Processor_MESI_Wen;
                  mem_data_wea[1]=Processor_Data_Wen;
                  mem_tag_wea[1] =Processor_Tag_Wen;  
                  end
            2'b10:begin
                  MESI_Way2_Wea  =Processor_MESI_Wen;
                  mem_data_wea[2]=Processor_Data_Wen;
                  mem_tag_wea[2] =Processor_Tag_Wen;   
                  end
            2'b11:begin
                  MESI_Way3_Wea  =Processor_MESI_Wen;
                  mem_data_wea[3]=Processor_Data_Wen;
                  mem_tag_wea[3] =Processor_Tag_Wen;  
                  end
            default: begin
                    mem_tag_wea=4'b0;
                    MESI_Way0_Wea =1'b0;
                    MESI_Way1_Wea =1'b0;
                    MESI_Way2_Wea =1'b0;
                    MESI_Way3_Wea =1'b0;
                    mem_data_wea[0]=32'b0;
                    mem_data_wea[1]=32'b0;
                    mem_data_wea[2]=32'b0;
                    mem_data_wea[3]=32'b0;
            end  
        endcase  
    end else begin         // in other cases it will be normal 
       case(Proc_Cmp_Way) 
            4'b0001:begin
                    MESI_Way0_Wea  =Processor_MESI_Wen;
                    mem_data_wea[0]=Processor_Data_Wen;
                    mem_tag_wea[0] =Processor_Tag_Wen;
                    end
            4'b0010:begin
                    MESI_Way1_Wea  =Processor_MESI_Wen;
                    mem_data_wea[1]=Processor_Data_Wen;
                    mem_tag_wea[1] =Processor_Tag_Wen;
                    end
            4'b0100:begin
                    MESI_Way2_Wea  =Processor_MESI_Wen;
                    mem_data_wea[2]=Processor_Data_Wen;
                    mem_tag_wea[2] =Processor_Tag_Wen;  
                    end
            4'b1000:begin
                    MESI_Way3_Wea  =Processor_MESI_Wen;
                    mem_data_wea[3]=Processor_Data_Wen;
                    mem_tag_wea[3] =Processor_Tag_Wen; 
                    end
            default: begin
                    mem_tag_wea=4'b0;
                    MESI_Way0_Wea =1'b0;
                    MESI_Way1_Wea =1'b0;
                    MESI_Way2_Wea =1'b0;
                    MESI_Way3_Wea =1'b0;
                    mem_data_wea[0]=32'b0;
                    mem_data_wea[1]=32'b0;
                    mem_data_wea[2]=32'b0;
                    mem_data_wea[3]=32'b0;
            end        
       endcase
    end
end 


/*************************************************************************************************************************************************************************************
//...................................................................Making Cache Request Bus.........................................................................................
Cache Request Bus contains following information 
                       256bits----> Cacheline [255:0]           ------------------> This should contain the Cacheline to be written back to memory in case of replacement 
                                                                ------------------> Only need to take this into account also by taking BUS_OP_Value
                                                                ------------------> This field can contain wrong values especially like bus operation such as Readx and Read etc
                                                                ------------------> This field [63:0] will contain the data to be written to the peripheral in case of peripheral access
                                                                
                       56bits-----> Physical Add/Physical Tag   ------------------>      
                                              [311:256]
                       3bits ----->BUS_OP_122 [314:312]         ------------------> Very important Field in this BUS
                       1bit  ----->Read or write in case of peripheral bus[315]
                                                                ------------------>(not important otherwise can understand from the BUSOP itself )
                       1bit  ----->Double or not [316]          ------------------> (not important in other case also) significant
                       2bit  ----->Burst length                 ------------------> 0 in case of peipheral operaion 3 in case of Cache operation
                       3bit  ----->Data Type                    ------------------>
*/
wire [Cache_Req_width-1:0] Cache_Request_Bus_Temp;
reg  [Cache_Req_width-1:0] Cache_Request_Bus_Temp_Reg;

assign Cache_Request_Bus_Temp[255:0]    = (BUS_OP_Value_Data==3'b100)?{192'b0,DCache_Req_Wrdata_Reg}:Processor_Cacheline;
assign Cache_Request_Bus_Temp[311:256]  = (BUS_OP_Value_Data==3'b011 || BUS_OP_Value_Data==3'b110 )?{Processor_Tagline,Processor_Req_Index,5'b0}:((BUS_OP_Value_Data==3'b100)?DCache_Req_Paddr_Reg:{Processor_Req_Tag,Processor_Req_Index,5'b0});
assign Cache_Request_Bus_Temp[314:312]  = BUS_OP_Value_Data;
assign Cache_Request_Bus_Temp[315]      = DCache_Req_Type_Reg;
assign Cache_Request_Bus_Temp[316]      = Double_Load_Store;
assign Cache_Request_Bus_Temp[318:317]  = (BUS_OP_Value_Data==3'b100)?2'b00:2'b11;
assign Cache_Request_Bus_Temp[321:319]  = DCache_Req_DataType_Reg;


always @(posedge clk)
begin
    if(rst || pr_state==START) begin
        Cache_Request_Bus_Temp_Reg<=0;
    end else if (BUS_OP_Wen) begin
        Cache_Request_Bus_Temp_Reg<=Cache_Request_Bus_Temp;
    end
end

assign Cache_Request_Bus=Cache_Request_Bus_Temp_Reg;
assign Cache_Request_Bus_Valid= BUS_op_Valid;


//***********************************************************************************************************************************************************************
//false output for invalid signal/....Not exactly sure what meant by invalidate in the existing design, Kept as such ...No meaning can be deleted 
//This can be deleted 
reg invalidate_done_temp;
always @(posedge clk)
begin 
    if(rst) begin
        invalidate_done_temp<=0;
    end else begin
        invalidate_done_temp<=DCache_Invalidate_Req;
      end
end

assign DCache_Invalidate_Done=invalidate_done_temp;
assign DCache_Flush_Done     = flush_done;
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////Assigning Output Signals......................................................................................................................................

assign DCache_Resp_Ready    = Private_Bus_Busy ? Private_Bus_done : DCache_Ready;
assign DCache_Resp_Done     = Private_Bus_Busy ? Private_Bus_done : DCache_FSM_Done;
assign DCache_Resp_Ready    = Private_Bus_Busy?  Private_Bus_done : DCache_Ready;


assign Private_Bus_read_write=DCache_Req_Type_Reg;
assign DCache_Resp_Rddata   = (BUS_OP_Value==3'b100)?SCU_Cacheline_Reg[63:0]:(Private_Bus_Busy? Private_Bus_Read_Data: Cache_Read_Data_temp1);



`ifdef DEBUG
    `ifdef DEBUG_DCACHE
        reg[128:0] BUSOP;
        always@(*)
        begin
            case(BUS_OP_Value_Data)
                3'b010: BUSOP="BUSRd";
                3'b101: BUSOP="BUS_UPGRADE";
                3'b111: BUSOP="BUSRDx";
                3'b011: BUSOP="BUS_Replace";
                3'b110: BUSOP="BUS_FLUSH";
                3'b100: BUSOP="BUS_Periph";
                default:BUSOP="NO_Op";
            endcase
        end
        
        reg[128:0] Transaction_Type;
        always @(*) 
        begin
            case(SCU_ResponseType)
                2'b00:  Transaction_Type="Peripheral";
                2'b01:  Transaction_Type="Cache2Cache";
                2'b10:  Transaction_Type="Memory_Tran";
                2'b11:  Transaction_Type="Flush";
            endcase
        end
        
        always@(negedge clk)begin
             if(nx_state==BUS_INIT && pr_state!=BUS_INIT) begin
                $display("[%t] ##CACHE_NEW_BUS_Operation: CORE=%d, BUSOP=%s, Address=%h/%h", $time,CORE_ID,BUSOP,{8'b0, Cache_Request_Bus_Temp[311:256]},{8'b0,DCache_Req_Paddr} );
             end
             if(pr_state==START && nx_state==FLUSH) begin
                $display("[%t] ##CACHE_FLUSH_Initiated:  CORE=%d", $time, CORE_ID);
             end 
             
             if(pr_state==BUS_INIT && SCU_COREID==CORE_ID && Cache_Snoop_Resp_Valid) begin 
                $display("[%t] ##CACHE_DATA_RECEPTION: CORE=%d, Transaction_Type=%s, Cacheline=%h", $time,CORE_ID,Transaction_Type,SCU_Cacheline );
             end
             
             
        end    
        
     `endif
`endif

endmodule

