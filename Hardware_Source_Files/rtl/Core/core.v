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
`include "regbit_defines.vh"
`include "bus_defines.vh"

(* keep_hierarchy = "yes" *)
module Core
#(
    parameter RESET_PC          = 64'h0,    //initial PC on startup
    parameter platform_irqs     = 1,        //No. of platform level local irqs enabled
    parameter HART_ID           = 0,
    parameter MEM_TYPE          = "xpm"     // "rtl", "xip", "xpm"
)
(
    input  wire clk,
    input  wire rst,

    //Input Interrupt Requests (Level Triggered)
    input  wire                                 irq_NMI,                    //NMI Interrupt Request
    input  wire                                 irq_machine_ext,            //M-Mode External Interrupt Request (From PLIC)
    input  wire                                 irq_machine_timer,          //M-Mode Timer Interrupt Request (From CLINT)
    input  wire                                 irq_machine_soft,           //M-Mode Software Interrupt Request (From CLINT)
    input  wire                                 irq_supervisor_ext,         //S-Mode External Interrupt Request (From PLIC)
    input  wire [platform_irqs-1:0]             irq_local,                  //Plaform Specific Local irqs (exception code >= 16)


    //Input Time From CLINT
    input  wire [`XLEN-1:0]                     CLINT_time,


    //I-Bus (64-bit AXI4 Full Master Bus)
    output wire [3:0]                           M_AXI_IBUS_AWID,
    output wire [`C_AXI_IBUS_ADDR_WIDTH-1:0]    M_AXI_IBUS_AWADDR,
    output wire [7:0]                           M_AXI_IBUS_AWLEN,
    output wire [2:0]                           M_AXI_IBUS_AWSIZE,
    output wire [1:0]                           M_AXI_IBUS_AWBURST,
    output wire                                 M_AXI_IBUS_AWLOCK,
    output wire [3:0]                           M_AXI_IBUS_AWCACHE,
    output wire [2:0]                           M_AXI_IBUS_AWPROT,
    output wire [3:0]                           M_AXI_IBUS_AWQOS,
    output wire                                 M_AXI_IBUS_AWVALID,
    input  wire                                 M_AXI_IBUS_AWREADY,

    output wire [`C_AXI_IBUS_DATA_WIDTH-1:0]    M_AXI_IBUS_WDATA,
    output wire [`C_AXI_IBUS_DATA_WIDTH/8-1:0]  M_AXI_IBUS_WSTRB,
    output wire                                 M_AXI_IBUS_WLAST,
    output wire                                 M_AXI_IBUS_WVALID,
    input  wire                                 M_AXI_IBUS_WREADY,

    input  wire [3:0]                           M_AXI_IBUS_BID,
    input  wire [1:0]                           M_AXI_IBUS_BRESP,
    input  wire                                 M_AXI_IBUS_BVALID,
    output wire                                 M_AXI_IBUS_BREADY,

    output wire [3:0]                           M_AXI_IBUS_ARID,
    output wire [`C_AXI_IBUS_ADDR_WIDTH-1:0]    M_AXI_IBUS_ARADDR,
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
    input  wire [`C_AXI_IBUS_DATA_WIDTH-1:0]    M_AXI_IBUS_RDATA,
    input  wire [1:0]                           M_AXI_IBUS_RRESP,
    input  wire                                 M_AXI_IBUS_RLAST,
    input  wire                                 M_AXI_IBUS_RVALID,
    output wire                                 M_AXI_IBUS_RREADY,


    //D-Bus (64-Bit AXI4 Full Master Bus)
    output wire [3:0]                           M_AXI_DBUS_AWID,
    output wire [`C_AXI_DBUS_ADDR_WIDTH-1:0]    M_AXI_DBUS_AWADDR,
    output wire [7:0]                           M_AXI_DBUS_AWLEN,
    output wire [2:0]                           M_AXI_DBUS_AWSIZE,
    output wire [1:0]                           M_AXI_DBUS_AWBURST,
    output wire                                 M_AXI_DBUS_AWLOCK,
    output wire [3:0]                           M_AXI_DBUS_AWCACHE,
    output wire [2:0]                           M_AXI_DBUS_AWPROT,
    output wire [3:0]                           M_AXI_DBUS_AWQOS,
    output wire                                 M_AXI_DBUS_AWVALID,
    input  wire                                 M_AXI_DBUS_AWREADY,

    output wire [`C_AXI_DBUS_DATA_WIDTH-1:0]    M_AXI_DBUS_WDATA,
    output wire [`C_AXI_DBUS_DATA_WIDTH/8-1:0]  M_AXI_DBUS_WSTRB,
    output wire                                 M_AXI_DBUS_WLAST,
    output wire                                 M_AXI_DBUS_WVALID,
    input  wire                                 M_AXI_DBUS_WREADY,

    input  wire [3:0]                           M_AXI_DBUS_BID,
    input  wire [1:0]                           M_AXI_DBUS_BRESP,
    input  wire                                 M_AXI_DBUS_BVALID,
    output wire                                 M_AXI_DBUS_BREADY,

    output wire [3:0]                           M_AXI_DBUS_ARID,
    output wire [`C_AXI_DBUS_ADDR_WIDTH-1:0]    M_AXI_DBUS_ARADDR,
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
    input  wire [`C_AXI_DBUS_DATA_WIDTH-1:0]    M_AXI_DBUS_RDATA,
    input  wire [1:0]                           M_AXI_DBUS_RRESP,
    input  wire                                 M_AXI_DBUS_RLAST,
    input  wire                                 M_AXI_DBUS_RVALID,
    output wire                                 M_AXI_DBUS_RREADY,


    //Private Bus (32-bit AXI4 lite Bus)
    output wire [`C_AXI_PBUS_ADDR_WIDTH-1:0]    M_AXI_PBUS_AWADDR,
    output wire [2:0]                           M_AXI_PBUS_AWPROT,
    output wire                                 M_AXI_PBUS_AWVALID,
    input  wire                                 M_AXI_PBUS_AWREADY,

    output wire [`C_AXI_PBUS_DATA_WIDTH-1:0]    M_AXI_PBUS_WDATA,
    output wire [`C_AXI_PBUS_DATA_WIDTH/8-1:0]  M_AXI_PBUS_WSTRB,
    output wire                                 M_AXI_PBUS_WVALID,
    input  wire                                 M_AXI_PBUS_WREADY,

    input  wire [1:0]                           M_AXI_PBUS_BRESP,
    input  wire                                 M_AXI_PBUS_BVALID,
    output wire                                 M_AXI_PBUS_BREADY,

    output wire [`C_AXI_PBUS_ADDR_WIDTH-1:0]    M_AXI_PBUS_ARADDR,
    output wire [2:0]                           M_AXI_PBUS_ARPROT,
    output wire                                 M_AXI_PBUS_ARVALID,
    input  wire                                 M_AXI_PBUS_ARREADY,

    input  wire [`C_AXI_PBUS_DATA_WIDTH-1:0]    M_AXI_PBUS_RDATA,
    input  wire [1:0]                           M_AXI_PBUS_RRESP,
    input  wire                                 M_AXI_PBUS_RVALID,
    output wire                                 M_AXI_PBUS_RREADY,


    //Temporary signals
    output wire [`XLEN-1:0]                     RetirePC

);

///////////////////////////////////////////////////////////////////////////////
//Local Configurations


///////////////////////////////////////////////////////////////////////////////
//Local Interconnect Wires

//I-Cache+IMMU
wire                                            ICache_Enable;              //src=SysCtl    dest=I$         :: 1=>Caching is enabled on I-Cache
wire                                            ITLB_Enable;                //src=SysCtl    dest=I$         :: 1=>Enable Caching of PTE in I-TLB
wire                                            ICache_Flush_Req;           //src=SysCtl    dest=I$         :: 1=>Request to Invalidate all I$ Lines
wire                                            ICache_Flush_Done;          //src=SysCtl    dest=I$         :: 1=>I-Cache Flush Request Completed
wire                                            ITLB_Flush_Req;             //src=SysCtl    dest=I$         :: 1=>Request to Invalidate I-TLB Entries
wire [`SATP_ASID_LEN-1:0]                       ITLB_Flush_Req_ASID;        //src=SysCtl    dest=ICache     :: ITLB Partial Flush ASID
wire [`XLEN-1:0]                                ITLB_Flush_Req_Vaddr;       //src=SysCtl    dest=ICache     :: ITLB Partial Flush Vaddr
wire                                            ITLB_Flush_Done;            //src=SysCtl    dest=I$         :: 1=>ITLB Flush Request Completed
wire                                            ICache_Resp_Hit;            //src=I$        dest=IFU        :: 1=>I-Cache is Hit
wire [`ICACHE_LINE_LEN-1:0]                     ICache_Resp_Line;           //src=I$        dest=IFU        :: I-Cache Whole Line
wire [`XLEN-1:0]                                ICache_Req_FetchPC;         //src=IFU       dest=I$         :: I-Cache Fetch PC Address
wire                                            ICache_Resp_Exception;      //src=I$        dest=IFU        :: 1=>Exception in I$ Fetching
wire [`ECAUSE_LEN-1:0]                          ICache_Resp_ECause;         //src=I$        dest=IFU        :: Exception cause

//Frontend+Backend+LSU
wire [(`DECODE_RATE*`IB_ENTRY_LEN)-1:0]         IB_DataOut;                 //src=IFU.IB    dest=EX.Decoder :: IB Peek Data Input
wire [`DECODE_RATE-1:0]                         IB_OutValid;                //src=IFU.IB    dest=EX.Decoder :: i=1 => ith IB output is valid
wire [$clog2(`DECODE_RATE):0]                   IB_RdCnt;                   //src=EX.Dec    dest=IFU.IB     :: No. of instr to read from IB
wire                                            uBTB_Enable;                //src=SysCtl    dest=IFU.uBTB   :: 1=>Enable BTB Cacheing
wire                                            uBTB_RAS_Enable;            //src=SysCtl    dest=IFU.uBTB   :: 1=>Enable Return Address Stack
wire                                            DP_Enable;                  //src=SysCtl    dest=IDU.DP     :: 1=>Enable Branch Direction Prediction
wire [`FUBR_RESULT_LEN-1:0]                     FUBRresp;                   //src=EX.FUBR   dest=*          :: Branch Unit Response
wire [`LSU_REQ_LEN-1:0]                         FU2LSUreq0;                 //src=EX.FULD   dest=LSU        :: Load FU to LSU Bus
wire [`LSU_REQ_LEN-1:0]                         FU2LSUreq1;                 //src=EX.FUST   dest=LSU        :: Store FU to LSU Bus
wire [`LSU_RESP_LEN-1:0]                        LSU2FUresp0;                //src=LSU       dest=EX.FULD    :: LSU to Load FU Bus
wire [`LSU_RESP_LEN-1:0]                        LSU2FUresp1;                //src=LSU       dest=EX.FUST    :: LSU to Store FU Bus
wire [`SYS_REQ_LEN-1:0]                         SYSreq;                     //src=EX.FUSYS  dest=SysCtl     :: SYS FU to SysCtl Req
wire [`SYS_RESP_LEN-1:0]                        SYSresp;                    //src=SysCtl    dest=EX.FUSYS   :: SysCtl to SYS FU Resp
wire [`RETIRE2SYSCTL_LEN-1:0]                   Retire2SysCtl_Bus;          //src=EX.Retire dest=SysCtl     :: Retire to SysCtl Bus
wire                                            SB_Empty;                   //src=LSU.SB    dest=EX         :: 1=>Store Queue is Empty
wire                                            StallTillRetireLock;        //src=EX.Dec    dest=SysCtl     :: 1=>An instr has stalled decoder till it is retired
wire                                            SysCtl_Redirect;            //src=SysCtl    dest=IFU,EX,LSU :: 1=>execption/interrupt/xRET/xCALL redirection
wire                                            SysCtl_Stall;               //src=SysCtl    dest=IFU,EX,LSU :: 1=>Stall Whole Pipeline (IFU, EX, LSU)
wire [`XLEN-1:0]                                SysCtl_RedirectPC;          //src=SysCtl    dest=IFU        :: Target PC when redirect is valid
wire [`RETIRE_RATE-1:0]                         Retire_BranchTaken;         //src=EX.Retire dest=IFU.DP     :: i=1 => ith instr in retire group was taken
wire [`RETIRE_RATE-1:0]                         Retire_BranchMask;          //src=EX.Retire dest=IFU.DP     :: i=1 => ith instr in retire group was branch
wire [(`RETIRE_RATE*`RETIRE2LSU_PORT_LEN)-1:0]  Retire2LSU_Bus;             //src=EX.Retire dest=LSU.SB     :: Publishes Retired Stores to Store Buffer
wire [`AR_REQ_LEN-1:0]                          AR_Req;                     //src=LSU       dest=SysCtl     :: Atomic Reservation Lock Request
wire [`AR_RESP_LEN-1:0]                         AR_Resp;                    //src=SysCtl    dest=LSU        :: Atomic Reservation Lock Response

//D-Cache
wire                                            DCache_Enable;              //src=SysCtl    dest=D$         :: 1=>Caching is enabled on D-Cache
wire                                            DCache_Flush_Req;           //src=SysCtl    dest=D$         :: 1=>Request to Flush Dirty Data to Memory
wire                                            DCache_Flush_Done;          //src=D$        dest=SysCtl     :: 1=>D$ Flush Request Completed
wire                                            DCache_Invalidate_Req;      //src=SysCtl    dest=D$         :: 1=>Request to Invalidate All Cache Lines
wire                                            DCache_Invalidate_Done;     //src=D$        dest=SysCtl     :: 1=>D$ Invalidate Request Completed
wire                                            DCache_WrReq_Valid;         //src=LSU       dest=D$         :: 1=>cache write request is valid
wire [`DATA_TYPE__LEN-1:0]                      DCache_WrReq_DataType;      //src=LSU       dest=D$         :: requested physical addr
wire [`PLEN-1:0]                                DCache_WrReq_Paddr;         //src=LSU       dest=D$         :: Data Type
wire [`XLEN-1:0]                                DCache_WrReq_Data;          //src=LSU       dest=D$         :: data ro write
wire                                            DCache_WrResp_Done;         //src=D$        dest=LSU        :: 1=>cache write request completed
wire                                            DCache_WrResp_Ready;        //src=D$        dest=LSU        :: 1=>Cache Write Port is ready to receive new request

wire                                            DCache_RdReq_Load_Valid;    //src=LSU       dest=D$Arb      :: 1=>cache read request is valid
wire [`PLEN-1:0]                                DCache_RdReq_Load_Paddr;    //src=LSU       dest=D$Arb      :: requested physical addr
wire [`DATA_TYPE__LEN-1:0]                      DCache_RdReq_Load_DataType; //src=LSU       dest=D$Arb      :: Data Type
wire                                            DCache_RdReq_Load_Abort;    //src=LSU       dest=D$Arb      :: 1=>Request to Abort Ongoing Request
wire                                            DCache_RdResp_Load_Done;    //src=D$Arb     dest=LSU        :: 1=>cache read request completed
wire                                            DCache_RdResp_Load_Ready;   //src=D$Arb     dest=LSU        :: 1=>Cache Read Port is ready to receive new request
wire [`XLEN-1:0]                                DCache_RdResp_Load_Data;    //src=D$Arb     dest=LSU        :: read data
wire                                            DCache_RdReq_IPTW_Valid;    //src=I$.ITLB   dest=D$Arb      :: 1=>cache read request is valid
wire [`PLEN-1:0]                                DCache_RdReq_IPTW_Paddr;    //src=I$.ITLB   dest=D$Arb      :: requested physical addr
wire [`DATA_TYPE__LEN-1:0]                      DCache_RdReq_IPTW_DataType; //src=I$.ITLB   dest=D$Arb      :: Data Type
wire                                            DCache_RdReq_IPTW_Abort;    //src=I$.ITLB   dest=D$Arb      :: 1=>Request to Abort Ongoing Request
wire                                            DCache_RdResp_IPTW_Done;    //src=D$Arb     dest=I$.ITLB    :: 1=>cache read request completed
wire                                            DCache_RdResp_IPTW_Ready;   //src=D$Arb     dest=I$.ITLB    :: 1=>Cache Read Port is ready to receive new request
wire [`XLEN-1:0]                                DCache_RdResp_IPTW_Data;    //src=D$Arb     dest=I$.ITLB    :: read data
wire                                            DCache_RdReq_DPTW_Valid;    //src=DMMU.DTLB dest=D$         :: 1=>cache read request is valid
wire [`PLEN-1:0]                                DCache_RdReq_DPTW_Paddr;    //src=DMMU.DTLB dest=D$         :: requested physical addr
wire [`DATA_TYPE__LEN-1:0]                      DCache_RdReq_DPTW_DataType; //src=DMMU.DTLB dest=D$         :: Data Type
wire                                            DCache_RdReq_DPTW_Abort;    //src=DMMU.DTLB dest=D$         :: 1=>Request to Abort Ongoing Request
wire                                            DCache_RdResp_DPTW_Done;    //src=D$        dest=DMMU.DTLB  :: 1=>cache read request completed
wire                                            DCache_RdResp_DPTW_Ready;   //src=D$        dest=DMMU.DTLB  :: 1=>Cache Read Port is ready to receive new request
wire [`XLEN-1:0]                                DCache_RdResp_DPTW_Data;    //src=D$        dest=DMMU.DTLB  :: read data
wire                                            DCache_RdReq_Valid;         //src=D$Arb     dest=D$         :: 1=>cache read request is valid
wire [`PLEN-1:0]                                DCache_RdReq_Paddr;         //src=D$Arb     dest=D$         :: requested physical addr
wire [`DATA_TYPE__LEN-1:0]                      DCache_RdReq_DataType;      //src=D$Arb     dest=D$         :: Data Type
wire                                            DCache_RdReq_Abort;         //src=D$Arb     dest=D$         :: 1=>Request to Abort Ongoing Request
wire                                            DCache_RdResp_Done;         //src=D$        dest=D$Arb      :: 1=>cache read request completed
wire                                            DCache_RdResp_Ready;        //src=D$        dest=D$Arb      :: 1=>Cache Read Port is ready to receive new request
wire [`XLEN-1:0]                                DCache_RdResp_Data;         //src=D$        dest=D$Arb      :: read data

//DMMU
wire                                            DTLB_Enable;                //src=SysCtl    dest=DMMU       :: 1=>Enable caching of PTE in D-TLB
wire                                            DTLB_Flush_Req;             //src=SysCtl    dest=DMMU       :: 1=>DTLB Flush Request
wire [`SATP_ASID_LEN-1:0]                       DTLB_Flush_Req_ASID;        //src=SysCtl    dest=DMMU       :: DTLB Partial Flush ASID
wire [`XLEN-1:0]                                DTLB_Flush_Req_Vaddr;       //src=SysCtl    dest=DMMU       :: DTLB Partial Flush Vaddr
wire                                            DTLB_Flush_Done;            //src=DMMU      dest=SysCtl     :: 1=>DTLB Flush Completed
wire                                            DMMU_Req0_Valid;            //src=LSU       dest=DMMU       :: 1=>request valid
wire [`MEM_ACCESS__LEN-1:0]                     DMMU_Req0_AccessType;       //src=LSU       dest=DMMU       :: Memory Access Type
wire                                            DMMU_Req0_IsAtomic;         //src=LSU       dest=DMMU       :: 1=>request is atomic
wire [`XLEN-1:0]                                DMMU_Req0_Vaddr;            //src=LSU       dest=DMMU       :: virtual addr
wire                                            DMMU_Req0_Abort;            //src=LSU       dest=DMMU       :: 1=>Abort ongoing request
wire                                            DMMU_Resp0_Done;            //src=DMMU      dest=LSU        :: 1=>translation request completed
wire                                            DMMU_Resp0_Ready;           //src=DMMU      dest=LSU        :: 1=>MMU Port0 is ready for new request
wire [`PLEN-1:0]                                DMMU_Resp0_Paddr;           //src=DMMU      dest=LSU        :: physical addr
wire                                            DMMU_Resp0_Exception;       //src=DMMU      dest=LSU        :: 1=>exception in translation
wire [`ECAUSE_LEN-1:0]                          DMMU_Resp0_ECause;          //src=DMMU      dest=LSU        :: Exception Cause
wire                                            DMMU_Req1_Valid;            //src=LSU       dest=DMMU       :: 1=>request valid
wire [`MEM_ACCESS__LEN-1:0]                     DMMU_Req1_AccessType;       //src=LSU       dest=DMMU       :: Memory Access Type
wire                                            DMMU_Req1_IsAtomic;         //src=LSU       dest=DMMU       :: 1=>request is atomic
wire [`XLEN-1:0]                                DMMU_Req1_Vaddr;            //src=LSU       dest=DMMU       :: virtual addr
wire                                            DMMU_Req1_Abort;            //src=LSU       dest=DMMU       :: 1=>Abort ongoing request
wire                                            DMMU_Resp1_Done;            //src=DMMU      dest=LSU        :: 1=>translation request completed
wire                                            DMMU_Resp1_Ready;           //src=DMMU      dest=LSU        :: 1=>MMU Port0 is ready for new request
wire [`PLEN-1:0]                                DMMU_Resp1_Paddr;           //src=DMMU      dest=LSU        :: physical addr
wire                                            DMMU_Resp1_Exception;       //src=DMMU      dest=LSU        :: 1=>exception in translation
wire [`ECAUSE_LEN-1:0]                          DMMU_Resp1_ECause;          //src=DMMU      dest=LSU        :: Exception Cause

//SysCtl
wire [`PRIV_LVL__LEN-1:0]                       csr_status_priv_lvl;        //src=SysCtl    dest=I$         :: Current Priv Level
wire [`PRIV_LVL__LEN-1:0]                       csr_lsu_priv_lvl;           //src=SysCtl    dest=DMMU       :: Current Priv Level for load/store operation
wire                                            csr_lsu_translateEn;        //src=SysCtl    dest=DMMU       :: Enable Translation for load/store operation
wire                                            csr_status_sum;             //src=SysCtl    dest=DMMU       :: xstatus SUM field
wire                                            csr_status_mxr;             //src=SysCtl    dest=DMMU       :: xstatus MXR field
wire [`XLEN-1:0]                                csr_satp;                   //src=SysCtl    dest=DMMU,I$    :: satp csr
wire [`FCSR_FRM_LEN-1:0]                        csr_fcsr_frm;               //src=SysCtl    dest=EX         :: Floating Point rounding Mode
wire [`XSTATUS_FS_LEN-1:0]                      csr_status_fs;              //src=SysCtl    dest=EX.decoder :: FS Bits from xstatus CSR
wire [(16*8)-1:0]                               csr_pmpcfg_array;           //src=SysCtl    dest=DMMU,i$    :: pmpcfg csr array in bus form
wire [(16*54)-1:0]                              csr_pmpaddr_array;          //src=SysCtl    dest=DMMU,i$    :: pmpaddr csr array in bus form
wire                                            PMA_Check_Enable;           //src=SysCtl    dest=DMMU,i$    :: PMA Access Check Enable
wire                                            RetireAllowed;              //src=SysCtl    dest=Retire     :: 1=>Retiring of Instrs is allowed

///////////////////////////////////////////////////////////////////////////////
//Instantiation of Submodules


//Instruction Fetch Unit (IFU) [Frontend]
IFU
#(
    .RESET_PC                   (RESET_PC                   ),
    .MEM_TYPE                   (MEM_TYPE                   )
)
IFU
(
    .clk                        (clk                        ),
    .rst                        (rst                        ),

    .IFU_Stall                  (SysCtl_Stall               ),

    .ICache_Resp_Hit            (ICache_Resp_Hit            ),
    .ICache_Resp_Line           (ICache_Resp_Line           ),
    .ICache_Resp_Exception      (ICache_Resp_Exception      ),
    .ICache_Resp_ECause         (ICache_Resp_ECause         ),
    .ICache_Req_FetchPC         (ICache_Req_FetchPC         ),

    .IB_RdCnt                   (IB_RdCnt                   ),

    .FUBRresp                   (FUBRresp                   ),

    .Retire_BranchTaken         (Retire_BranchTaken         ),
    .Retire_BranchMask          (Retire_BranchMask          ),

    .SysCtl_Redirect            (SysCtl_Redirect            ),
    .SysCtl_RedirectPC          (SysCtl_RedirectPC          ),

    .uBTB_Enable                (uBTB_Enable                ),
    .uBTB_RAS_Enable            (uBTB_RAS_Enable            ),
    .DP_Enable                  (DP_Enable                  ),

    .IB_DataOut                 (IB_DataOut                 ),
    .IB_OutValid                (IB_OutValid                )
);


//I-Cache
ICache
#(
    .ICACHE_TYPE                ("default"                  ),
    .MEM_TYPE                   (MEM_TYPE                   ),
    .C_M_AXI_IBUS_ADDR_WIDTH    (`C_AXI_IBUS_ADDR_WIDTH     ),
    .C_M_AXI_IBUS_DATA_WIDTH    (`C_AXI_IBUS_DATA_WIDTH     )
)
ICache
(
    .clk                        (clk                        ),
    .rst                        (rst                        ),

    .csr_satp                   (csr_satp                   ),
    .csr_status_priv_lvl        (csr_status_priv_lvl        ),
    .csr_pmpcfg_array           (csr_pmpcfg_array           ),
    .csr_pmpaddr_array          (csr_pmpaddr_array          ),

    .ICache_Enable              (ICache_Enable              ),
    .ITLB_Enable                (ITLB_Enable                ),
    .PMA_Check_Enable           (PMA_Check_Enable           ),
    .ICache_Flush_Req           (ICache_Flush_Req           ),
    .ICache_Flush_Done          (ICache_Flush_Done          ),
    .ITLB_Flush_Req             (ITLB_Flush_Req             ),
    .ITLB_Flush_Req_ASID        (ITLB_Flush_Req_ASID        ),
    .ITLB_Flush_Req_Vaddr       (ITLB_Flush_Req_Vaddr       ),
    .ITLB_Flush_Done            (ITLB_Flush_Done            ),

    .ICache_Resp_Hit            (ICache_Resp_Hit            ),
    .ICache_Resp_Line           (ICache_Resp_Line           ),
    .ICache_Req_FetchPC         (ICache_Req_FetchPC         ),
    .ICache_Resp_Exception      (ICache_Resp_Exception      ),
    .ICache_Resp_ECause         (ICache_Resp_ECause         ),

    .DCache_RdReq_IPTW_Valid    (DCache_RdReq_IPTW_Valid    ),
    .DCache_RdReq_IPTW_Paddr    (DCache_RdReq_IPTW_Paddr    ),
    .DCache_RdReq_IPTW_DataType (DCache_RdReq_IPTW_DataType ),
    .DCache_RdResp_IPTW_Data    (DCache_RdResp_IPTW_Data    ),
    .DCache_RdResp_IPTW_Done    (DCache_RdResp_IPTW_Done    ),

    .M_AXI_IBUS_AWID            (M_AXI_IBUS_AWID            ),
    .M_AXI_IBUS_AWADDR          (M_AXI_IBUS_AWADDR          ),
    .M_AXI_IBUS_AWLEN           (M_AXI_IBUS_AWLEN           ),
    .M_AXI_IBUS_AWSIZE          (M_AXI_IBUS_AWSIZE          ),
    .M_AXI_IBUS_AWBURST         (M_AXI_IBUS_AWBURST         ),
    .M_AXI_IBUS_AWLOCK          (M_AXI_IBUS_AWLOCK          ),
    .M_AXI_IBUS_AWCACHE         (M_AXI_IBUS_AWCACHE         ),
    .M_AXI_IBUS_AWPROT          (M_AXI_IBUS_AWPROT          ),
    .M_AXI_IBUS_AWQOS           (M_AXI_IBUS_AWQOS           ),
    .M_AXI_IBUS_AWVALID         (M_AXI_IBUS_AWVALID         ),
    .M_AXI_IBUS_AWREADY         (M_AXI_IBUS_AWREADY         ),

    .M_AXI_IBUS_WDATA           (M_AXI_IBUS_WDATA           ),
    .M_AXI_IBUS_WSTRB           (M_AXI_IBUS_WSTRB           ),
    .M_AXI_IBUS_WLAST           (M_AXI_IBUS_WLAST           ),
    .M_AXI_IBUS_WVALID          (M_AXI_IBUS_WVALID          ),
    .M_AXI_IBUS_WREADY          (M_AXI_IBUS_WREADY          ),

    .M_AXI_IBUS_BID             (M_AXI_IBUS_BID             ),
    .M_AXI_IBUS_BRESP           (M_AXI_IBUS_BRESP           ),
    .M_AXI_IBUS_BVALID          (M_AXI_IBUS_BVALID          ),
    .M_AXI_IBUS_BREADY          (M_AXI_IBUS_BREADY          ),

    .M_AXI_IBUS_ARID            (M_AXI_IBUS_ARID            ),
    .M_AXI_IBUS_ARADDR          (M_AXI_IBUS_ARADDR          ),
    .M_AXI_IBUS_ARLEN           (M_AXI_IBUS_ARLEN           ),
    .M_AXI_IBUS_ARSIZE          (M_AXI_IBUS_ARSIZE          ),
    .M_AXI_IBUS_ARBURST         (M_AXI_IBUS_ARBURST         ),
    .M_AXI_IBUS_ARLOCK          (M_AXI_IBUS_ARLOCK          ),
    .M_AXI_IBUS_ARCACHE         (M_AXI_IBUS_ARCACHE         ),
    .M_AXI_IBUS_ARPROT          (M_AXI_IBUS_ARPROT          ),
    .M_AXI_IBUS_ARQOS           (M_AXI_IBUS_ARQOS           ),
    .M_AXI_IBUS_ARVALID         (M_AXI_IBUS_ARVALID         ),
    .M_AXI_IBUS_ARREADY         (M_AXI_IBUS_ARREADY         ),

    .M_AXI_IBUS_RID             (M_AXI_IBUS_RID             ),
    .M_AXI_IBUS_RDATA           (M_AXI_IBUS_RDATA           ),
    .M_AXI_IBUS_RRESP           (M_AXI_IBUS_RRESP           ),
    .M_AXI_IBUS_RLAST           (M_AXI_IBUS_RLAST           ),
    .M_AXI_IBUS_RVALID          (M_AXI_IBUS_RVALID          ),
    .M_AXI_IBUS_RREADY          (M_AXI_IBUS_RREADY          )
);

//Execution [Backend]
EX EX
(
    .clk                        (clk                        ),
    .rst                        (rst                        ),

    .EX_Stall                   (SysCtl_Stall               ),
    .EX_Flush                   (SysCtl_Redirect            ),

    .IB_DataOut                 (IB_DataOut                 ),
    .IB_OutValid                (IB_OutValid                ),
    .IB_RdCnt                   (IB_RdCnt                   ),

    .Retire_BranchTaken         (Retire_BranchTaken         ),
    .Retire_BranchMask          (Retire_BranchMask          ),

    .FUBRresp                   (FUBRresp                   ),

    .SB_Empty                   (SB_Empty                   ),
    .LSU2Load                   (LSU2FUresp0                ),
    .LSU2Store                  (LSU2FUresp1                ),
    .Load2LSU                   (FU2LSUreq0                 ),
    .Store2LSU                  (FU2LSUreq1                 ),
    .Retire2LSU_Bus             (Retire2LSU_Bus             ),

    .StallTillRetireLock        (StallTillRetireLock        ),
    .SYSrespIn                  (SYSresp                    ),
    .RetireAllowed              (RetireAllowed              ),
    .csr_fcsr_frm               (csr_fcsr_frm               ),
    .csr_status_fs              (csr_status_fs              ),
    .SYSreqOut                  (SYSreq                     ),
    .Retire2SysCtl_Bus          (Retire2SysCtl_Bus          ),

    .RetirePC                   (RetirePC                   )
);


//Load-Store Unit (LSU)
LSU LSU
(
    .clk                        (clk                        ),
    .rst                        (rst                        ),

    .Stall                      (SysCtl_Stall               ),
    .Exception_Flush            (SysCtl_Redirect            ),

    .FUBRresp                   (FUBRresp                   ),

    .FU2LSUreq0                 (FU2LSUreq0                 ),
    .LSU2FUresp0                (LSU2FUresp0                ),
    .FU2LSUreq1                 (FU2LSUreq1                 ),
    .LSU2FUresp1                (LSU2FUresp1                ),

    .DCache_RdResp_Done         (DCache_RdResp_Load_Done    ),
    .DCache_RdResp_Ready        (DCache_RdResp_Load_Ready   ),
    .DCache_RdResp_Data         (DCache_RdResp_Load_Data    ),
    .DCache_RdReq_Valid         (DCache_RdReq_Load_Valid    ),
    .DCache_RdReq_Paddr         (DCache_RdReq_Load_Paddr    ),
    .DCache_RdReq_DataType      (DCache_RdReq_Load_DataType ),
    .DCache_RdReq_Abort         (DCache_RdReq_Load_Abort    ),

    .DCache_WrResp_Done         (DCache_WrResp_Done         ),
    .DCache_WrResp_Ready        (DCache_WrResp_Ready        ),
    .DCache_WrReq_Valid         (DCache_WrReq_Valid         ),
    .DCache_WrReq_DataType      (DCache_WrReq_DataType      ),
    .DCache_WrReq_Paddr         (DCache_WrReq_Paddr         ),
    .DCache_WrReq_Data          (DCache_WrReq_Data          ),

    .MMU_Req0_Valid             (DMMU_Req0_Valid            ),
    .MMU_Req0_AccessType        (DMMU_Req0_AccessType       ),
    .MMU_Req0_IsAtomic          (DMMU_Req0_IsAtomic         ),
    .MMU_Req0_Vaddr             (DMMU_Req0_Vaddr            ),
    .MMU_Req0_Abort             (DMMU_Req0_Abort            ),
    .MMU_Resp0_Done             (DMMU_Resp0_Done            ),
    .MMU_Resp0_Ready            (DMMU_Resp0_Ready           ),
    .MMU_Resp0_Paddr            (DMMU_Resp0_Paddr           ),
    .MMU_Resp0_Exception        (DMMU_Resp0_Exception       ),
    .MMU_Resp0_ECause           (DMMU_Resp0_ECause          ),

    .MMU_Req1_Valid             (DMMU_Req1_Valid            ),
    .MMU_Req1_AccessType        (DMMU_Req1_AccessType       ),
    .MMU_Req1_IsAtomic          (DMMU_Req1_IsAtomic         ),
    .MMU_Req1_Vaddr             (DMMU_Req1_Vaddr            ),
    .MMU_Req1_Abort             (DMMU_Req1_Abort            ),
    .MMU_Resp1_Done             (DMMU_Resp1_Done            ),
    .MMU_Resp1_Ready            (DMMU_Resp1_Ready           ),
    .MMU_Resp1_Paddr            (DMMU_Resp1_Paddr           ),
    .MMU_Resp1_Exception        (DMMU_Resp1_Exception       ),
    .MMU_Resp1_ECause           (DMMU_Resp1_ECause          ),

    .Retire2LSU_Bus             (Retire2LSU_Bus             ),
    .SB_Empty                   (SB_Empty                   ),

    .AR_Resp                    (AR_Resp                    ),
    .AR_Req                     (AR_Req                     )
);


//System Control Unit (SysCtl)
SysCtl
#(
    .RESET_PC                   (RESET_PC                   ),
    .platform_max_irqs          (platform_irqs              ),
    .platform_irqs              (platform_irqs              ),
    .HART_ID                    (HART_ID                    )
)
SysCtl
(
    .clk                        (clk                        ),
    .rst                        (rst                        ),

    .irq_NMI                    (irq_NMI                    ),
    .irq_machine_ext            (irq_machine_ext            ),
    .irq_machine_timer          (irq_machine_timer          ),
    .irq_machine_soft           (irq_machine_soft           ),
    .irq_supervisor_ext         (irq_supervisor_ext         ),
    .irq_local                  (irq_local                  ),

    .Retire2SysCtl_Bus          (Retire2SysCtl_Bus          ),
    .StallTillRetireLock        (StallTillRetireLock        ),

    .RetireAllowed              (RetireAllowed              ),

    .SYSreqIn                   (SYSreq                     ),
    .SYSrespOut                 (SYSresp                    ),

    .AR_Req                     (AR_Req                     ),
    .AR_Resp                    (AR_Resp                    ),

    .ICache_Flush_Req           (ICache_Flush_Req           ),
    .ICache_Flush_Done          (ICache_Flush_Done          ),
    .ITLB_Flush_Req             (ITLB_Flush_Req             ),
    .ITLB_Flush_Req_ASID        (ITLB_Flush_Req_ASID        ),
    .ITLB_Flush_Req_Vaddr       (ITLB_Flush_Req_Vaddr       ),
    .ITLB_Flush_Done            (ITLB_Flush_Done            ),
    .DCache_Flush_Req           (DCache_Flush_Req           ),
    .DCache_Flush_Done          (DCache_Flush_Done          ),
    .DTLB_Flush_Req             (DTLB_Flush_Req             ),
    .DTLB_Flush_Req_ASID        (DTLB_Flush_Req_ASID        ),
    .DTLB_Flush_Req_Vaddr       (DTLB_Flush_Req_Vaddr       ),
    .DTLB_Flush_Done            (DTLB_Flush_Done            ),

    .SysCtl_Redirect            (SysCtl_Redirect            ),
    .SysCtl_RedirectPC          (SysCtl_RedirectPC          ),
    .SysCtl_Stall               (SysCtl_Stall               ),

    .csr_status_priv_lvl        (csr_status_priv_lvl        ),
    .csr_lsu_priv_lvl           (csr_lsu_priv_lvl           ),
    .csr_lsu_translateEn        (csr_lsu_translateEn        ),
    .csr_status_sum             (csr_status_sum             ),
    .csr_status_fs              (csr_status_fs              ),
    .csr_status_mxr             (csr_status_mxr             ),
    .csr_satp_o                 (csr_satp                   ),
    .csr_fcsr_frm               (csr_fcsr_frm               ),
    .csr_pmpcfg_array           (csr_pmpcfg_array           ),
    .csr_pmpaddr_array          (csr_pmpaddr_array          ),

    .CLINT_time                 (CLINT_time                 ),

    .ICache_Enable              (ICache_Enable              ),
    .ITLB_Enable                (ITLB_Enable                ),
    .uBTB_Enable                (uBTB_Enable                ),
    .uBTB_RAS_Enable            (uBTB_RAS_Enable            ),
    .DP_Enable                  (DP_Enable                  ),
    .DCache_Enable              (DCache_Enable              ),
    .DTLB_Enable                (DTLB_Enable                ),
    .PMA_Check_Enable           (PMA_Check_Enable           )

);


//D-Cache
DCache
#(
    .DCACHE_TYPE                ("default"                  ),
    .MEM_TYPE                   (MEM_TYPE                   ),
    .C_M_AXI_PBUS_ADDR_WIDTH    (`C_AXI_PBUS_ADDR_WIDTH     ),
    .C_M_AXI_PBUS_DATA_WIDTH    (`C_AXI_PBUS_DATA_WIDTH     ),
    .C_M_AXI_DBUS_ADDR_WIDTH    (`C_AXI_DBUS_ADDR_WIDTH     ),
    .C_M_AXI_DBUS_DATA_WIDTH    (`C_AXI_DBUS_DATA_WIDTH     )
)
DCache
(
    .clk                        (clk                        ),
    .rst                        (rst                        ),

    .DCache_Enable              (DCache_Enable              ),
    .DCache_Flush_Req           (DCache_Flush_Req           ),
    .DCache_Flush_Done          (DCache_Flush_Done          ),
    .DCache_Invalidate_Req      (DCache_Invalidate_Req      ),
    .DCache_Invalidate_Done     (DCache_Invalidate_Done     ),

    .DCache_RdReq_Valid         (DCache_RdReq_Valid         ),
    .DCache_RdReq_Paddr         (DCache_RdReq_Paddr         ),
    .DCache_RdReq_DataType      (DCache_RdReq_DataType      ),
    .DCache_RdReq_Abort         (DCache_RdReq_Abort         ),
    .DCache_RdResp_Done         (DCache_RdResp_Done         ),
    .DCache_RdResp_Ready        (DCache_RdResp_Ready        ),
    .DCache_RdResp_Data         (DCache_RdResp_Data         ),

    .DCache_WrReq_Valid         (DCache_WrReq_Valid         ),
    .DCache_WrReq_DataType      (DCache_WrReq_DataType      ),
    .DCache_WrReq_Paddr         (DCache_WrReq_Paddr         ),
    .DCache_WrReq_Data          (DCache_WrReq_Data          ),
    .DCache_WrResp_Done         (DCache_WrResp_Done         ),
    .DCache_WrResp_Ready        (DCache_WrResp_Ready        ),

    .M_AXI_DBUS_AWID            (M_AXI_DBUS_AWID            ),
    .M_AXI_DBUS_AWADDR          (M_AXI_DBUS_AWADDR          ),
    .M_AXI_DBUS_AWLEN           (M_AXI_DBUS_AWLEN           ),
    .M_AXI_DBUS_AWSIZE          (M_AXI_DBUS_AWSIZE          ),
    .M_AXI_DBUS_AWBURST         (M_AXI_DBUS_AWBURST         ),
    .M_AXI_DBUS_AWLOCK          (M_AXI_DBUS_AWLOCK          ),
    .M_AXI_DBUS_AWCACHE         (M_AXI_DBUS_AWCACHE         ),
    .M_AXI_DBUS_AWPROT          (M_AXI_DBUS_AWPROT          ),
    .M_AXI_DBUS_AWQOS           (M_AXI_DBUS_AWQOS           ),
    .M_AXI_DBUS_AWVALID         (M_AXI_DBUS_AWVALID         ),
    .M_AXI_DBUS_AWREADY         (M_AXI_DBUS_AWREADY         ),
    .M_AXI_DBUS_WDATA           (M_AXI_DBUS_WDATA           ),
    .M_AXI_DBUS_WSTRB           (M_AXI_DBUS_WSTRB           ),
    .M_AXI_DBUS_WLAST           (M_AXI_DBUS_WLAST           ),
    .M_AXI_DBUS_WVALID          (M_AXI_DBUS_WVALID          ),
    .M_AXI_DBUS_WREADY          (M_AXI_DBUS_WREADY          ),
    .M_AXI_DBUS_BID             (M_AXI_DBUS_BID             ),
    .M_AXI_DBUS_BRESP           (M_AXI_DBUS_BRESP           ),
    .M_AXI_DBUS_BVALID          (M_AXI_DBUS_BVALID          ),
    .M_AXI_DBUS_BREADY          (M_AXI_DBUS_BREADY          ),
    .M_AXI_DBUS_ARID            (M_AXI_DBUS_ARID            ),
    .M_AXI_DBUS_ARADDR          (M_AXI_DBUS_ARADDR          ),
    .M_AXI_DBUS_ARLEN           (M_AXI_DBUS_ARLEN           ),
    .M_AXI_DBUS_ARSIZE          (M_AXI_DBUS_ARSIZE          ),
    .M_AXI_DBUS_ARBURST         (M_AXI_DBUS_ARBURST         ),
    .M_AXI_DBUS_ARLOCK          (M_AXI_DBUS_ARLOCK          ),
    .M_AXI_DBUS_ARCACHE         (M_AXI_DBUS_ARCACHE         ),
    .M_AXI_DBUS_ARPROT          (M_AXI_DBUS_ARPROT          ),
    .M_AXI_DBUS_ARQOS           (M_AXI_DBUS_ARQOS           ),
    .M_AXI_DBUS_ARVALID         (M_AXI_DBUS_ARVALID         ),
    .M_AXI_DBUS_ARREADY         (M_AXI_DBUS_ARREADY         ),
    .M_AXI_DBUS_RID             (M_AXI_DBUS_RID             ),
    .M_AXI_DBUS_RDATA           (M_AXI_DBUS_RDATA           ),
    .M_AXI_DBUS_RRESP           (M_AXI_DBUS_RRESP           ),
    .M_AXI_DBUS_RLAST           (M_AXI_DBUS_RLAST           ),
    .M_AXI_DBUS_RVALID          (M_AXI_DBUS_RVALID          ),
    .M_AXI_DBUS_RREADY          (M_AXI_DBUS_RREADY          ),

    .M_AXI_PBUS_AWADDR          (M_AXI_PBUS_AWADDR          ),
    .M_AXI_PBUS_AWPROT          (M_AXI_PBUS_AWPROT          ),
    .M_AXI_PBUS_AWVALID         (M_AXI_PBUS_AWVALID         ),
    .M_AXI_PBUS_AWREADY         (M_AXI_PBUS_AWREADY         ),
    .M_AXI_PBUS_WDATA           (M_AXI_PBUS_WDATA           ),
    .M_AXI_PBUS_WSTRB           (M_AXI_PBUS_WSTRB           ),
    .M_AXI_PBUS_WVALID          (M_AXI_PBUS_WVALID          ),
    .M_AXI_PBUS_WREADY          (M_AXI_PBUS_WREADY          ),
    .M_AXI_PBUS_BRESP           (M_AXI_PBUS_BRESP           ),
    .M_AXI_PBUS_BVALID          (M_AXI_PBUS_BVALID          ),
    .M_AXI_PBUS_BREADY          (M_AXI_PBUS_BREADY          ),
    .M_AXI_PBUS_ARADDR          (M_AXI_PBUS_ARADDR          ),
    .M_AXI_PBUS_ARPROT          (M_AXI_PBUS_ARPROT          ),
    .M_AXI_PBUS_ARVALID         (M_AXI_PBUS_ARVALID         ),
    .M_AXI_PBUS_ARREADY         (M_AXI_PBUS_ARREADY         ),
    .M_AXI_PBUS_RDATA           (M_AXI_PBUS_RDATA           ),
    .M_AXI_PBUS_RRESP           (M_AXI_PBUS_RRESP           ),
    .M_AXI_PBUS_RVALID          (M_AXI_PBUS_RVALID          ),
    .M_AXI_PBUS_RREADY          (M_AXI_PBUS_RREADY          )
);


//D-MMU
DMMU
#(
    .DMMU_TYPE                  ("default"                  ),
    .MEM_TYPE                   (MEM_TYPE                   ),
    .C_M_AXI_DBUS_ADDR_WIDTH    (`C_AXI_DBUS_ADDR_WIDTH     ),
    .C_M_AXI_DBUS_DATA_WIDTH    (`C_AXI_DBUS_DATA_WIDTH     )
)
DMMU
(
    .clk                        (clk                        ),
    .rst                        (rst                        ),

    .DTLB_Enable                (DTLB_Enable                ),
    .PMA_Check_Enable           (PMA_Check_Enable           ),
    .DTLB_Flush_Req             (DTLB_Flush_Req             ),
    .DTLB_Flush_Req_ASID        (DTLB_Flush_Req_ASID        ),
    .DTLB_Flush_Req_Vaddr       (DTLB_Flush_Req_Vaddr       ),
    .DTLB_Flush_Done            (DTLB_Flush_Done            ),

    .csr_status_priv_lvl        (csr_lsu_priv_lvl           ),
    .csr_lsu_translateEn        (csr_lsu_translateEn        ),
    .csr_status_sum             (csr_status_sum             ),
    .csr_status_mxr             (csr_status_mxr             ),
    .csr_satp                   (csr_satp                   ),
    .csr_pmpcfg_array           (csr_pmpcfg_array           ),
    .csr_pmpaddr_array          (csr_pmpaddr_array          ),

    .DCache_RdReq_DPTW_Valid    (DCache_RdReq_DPTW_Valid    ),
    .DCache_RdReq_DPTW_Paddr    (DCache_RdReq_DPTW_Paddr    ),
    .DCache_RdReq_DPTW_DataType (DCache_RdReq_DPTW_DataType ),
    .DCache_RdResp_DPTW_Data    (DCache_RdResp_DPTW_Data    ),
    .DCache_RdResp_DPTW_Done    (DCache_RdResp_DPTW_Done    ),

    .MMU_Req0_Valid             (DMMU_Req0_Valid            ),
    .MMU_Req0_AccessType        (DMMU_Req0_AccessType       ),
    .MMU_Req0_IsAtomic          (DMMU_Req0_IsAtomic         ),
    .MMU_Req0_Vaddr             (DMMU_Req0_Vaddr            ),
    .MMU_Req0_Abort             (DMMU_Req0_Abort            ),
    .MMU_Resp0_Done             (DMMU_Resp0_Done            ),
    .MMU_Resp0_Ready            (DMMU_Resp0_Ready           ),
    .MMU_Resp0_Paddr            (DMMU_Resp0_Paddr           ),
    .MMU_Resp0_Exception        (DMMU_Resp0_Exception       ),
    .MMU_Resp0_ECause           (DMMU_Resp0_ECause          ),

    .MMU_Req1_Valid             (DMMU_Req1_Valid            ),
    .MMU_Req1_AccessType        (DMMU_Req1_AccessType       ),
    .MMU_Req1_IsAtomic          (DMMU_Req1_IsAtomic         ),
    .MMU_Req1_Vaddr             (DMMU_Req1_Vaddr            ),
    .MMU_Req1_Abort             (DMMU_Req1_Abort            ),
    .MMU_Resp1_Done             (DMMU_Resp1_Done            ),
    .MMU_Resp1_Ready            (DMMU_Resp1_Ready           ),
    .MMU_Resp1_Paddr            (DMMU_Resp1_Paddr           ),
    .MMU_Resp1_Exception        (DMMU_Resp1_Exception       ),
    .MMU_Resp1_ECause           (DMMU_Resp1_ECause          )

);

//DCache Read Request Arbiter
//Higest Priority : 2 = ITLB PTW
//                  1 = DTLB PTW
//Lowest Priority : 0 = LSU Load
simple_arbiter
#(
    .PORTS                      (3                          ),
    .ADDR_WIDTH                 (`PLEN                      ),
    .DATA_WIDTH                 (`XLEN                      ),
    .DATA_TYPE_WIDTH            (`DATA_TYPE__LEN            )
)
DCache_Read_Arbiter
(
    .clk                        (clk                        ),
    .rst                        (rst                        ),

    .InReq0_Valid               (DCache_RdReq_Load_Valid    ),
    .InReq0_Addr                (DCache_RdReq_Load_Paddr    ),
    .InReq0_DataType            (DCache_RdReq_Load_DataType ),
    .InReq0_Abort               (DCache_RdReq_Load_Abort    ),
    .InResp0_Done               (DCache_RdResp_Load_Done    ),
    .InResp0_Ready              (DCache_RdResp_Load_Ready   ),
    .InResp0_Data               (DCache_RdResp_Load_Data    ),

    .InReq1_Valid               (DCache_RdReq_DPTW_Valid    ),
    .InReq1_Addr                (DCache_RdReq_DPTW_Paddr    ),
    .InReq1_DataType            (DCache_RdReq_DPTW_DataType ),
    .InReq1_Abort               (1'b0                       ),
    .InResp1_Done               (DCache_RdResp_DPTW_Done    ),
    .InResp1_Ready              (                           ),
    .InResp1_Data               (DCache_RdResp_DPTW_Data    ),

    .InReq2_Valid               (DCache_RdReq_IPTW_Valid    ),
    .InReq2_Addr                (DCache_RdReq_IPTW_Paddr    ),
    .InReq2_DataType            (DCache_RdReq_IPTW_DataType ),
    .InReq2_Abort               (1'b0                       ),
    .InResp2_Done               (DCache_RdResp_IPTW_Done    ),
    .InResp2_Ready              (                           ),
    .InResp2_Data               (DCache_RdResp_IPTW_Data    ),

    .OutReq_Valid               (DCache_RdReq_Valid         ),
    .OutReq_Addr                (DCache_RdReq_Paddr         ),
    .OutReq_DataType            (DCache_RdReq_DataType      ),
    .OutReq_Abort               (DCache_RdReq_Abort         ),
    .OutResp_Done               (DCache_RdResp_Done         ),
    .OutResp_Ready              (DCache_RdResp_Ready        ),
    .OutResp_Data               (DCache_RdResp_Data         )
);


endmodule

