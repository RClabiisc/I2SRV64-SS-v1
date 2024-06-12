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
module SysCtl
#(
    parameter RESET_PC          = 64'h0,                                //Reset PC
    parameter platform_max_irqs = 8,                                    //Max. no. of platform level irqs (For wire width)
    parameter platform_irqs     = 0,                                    //No. of platform level irqs enables
    parameter HART_ID           = 0
)
(
    input  wire clk,
    input  wire rst,

    //Input Interrupt Requests (Level Triggered)
    input  wire                             irq_NMI,                    //NMI Interrupt Request

    input  wire                             irq_machine_ext,            //M-Mode External Interrupt Request (From PLIC)
    input  wire                             irq_machine_timer,          //M-Mode Timer Interrupt Request (From CLINT)
    input  wire                             irq_machine_soft,           //M-Mode Software Interrupt Request (From CLINT)
    input  wire                             irq_supervisor_ext,         //S-Mode External Interrupt Request (From PLIC)

    input  wire [platform_max_irqs-1:0]     irq_local,                  //Plaform Specific Local irqs (exception code >= 16)

    //Inputs from Retire Unit
    input  wire [`RETIRE2SYSCTL_LEN-1:0]    Retire2SysCtl_Bus,          //Retire to SysCtl Unit Responses

    //Inputs from EX Backend control logic
    input  wire                             StallTillRetireLock,        //1=> An instr has stalled decoder till it is retired

    //Outputs to Retire Unit
    output reg                              RetireAllowed,              //1=>Retiring of instrs allowed

    //Input/Outputs to System FU
    input  wire [`SYS_REQ_LEN-1:0]          SYSreqIn,                   //System FU to SysCtl Unit Request
    output wire [`SYS_RESP_LEN-1:0]         SYSrespOut,                 //SysCtl Unit to System FU Response

    //Input/Output for Atomic Reservation Locks (from/to LSU)
    input  wire [`AR_REQ_LEN-1:0]           AR_Req,
    output reg  [`AR_RESP_LEN-1:0]          AR_Resp,

    //Instruction Memory Subsystem Control
    output reg                              ICache_Flush_Req,
    input  wire                             ICache_Flush_Done,
    output reg                              ITLB_Flush_Req,
    output reg  [`SATP_ASID_LEN-1:0]        ITLB_Flush_Req_ASID,
    output reg  [`XLEN-1:0]                 ITLB_Flush_Req_Vaddr,
    input  wire                             ITLB_Flush_Done,

    //Data Memory Subsystem Control
    output reg                              DCache_Flush_Req,
    input  wire                             DCache_Flush_Done,
    output reg                              DTLB_Flush_Req,
    output reg  [`SATP_ASID_LEN-1:0]        DTLB_Flush_Req_ASID,
    output reg  [`XLEN-1:0]                 DTLB_Flush_Req_Vaddr,
    input  wire                             DTLB_Flush_Done,

    //Control Outputs
    output reg                              SysCtl_Redirect,
    output reg  [`XLEN-1:0]                 SysCtl_RedirectPC,
    output wire                             SysCtl_Stall,

    //CSR Output Values for other units
    output wire [`PRIV_LVL__LEN-1:0]        csr_status_priv_lvl,    //Current Priv Level
    output wire [`PRIV_LVL__LEN-1:0]        csr_lsu_priv_lvl,       //Current Priv Level for load/store operation
    output reg                              csr_lsu_translateEn,    //Enable Translation for load/store operation
    output wire                             csr_status_sum,         //xstatus SUM field
    output wire                             csr_status_mxr,         //xstatus MXR field
    output wire [`XSTATUS_FS_LEN-1:0]       csr_status_fs,          //FS Bits from xstatus CSR
    output wire [`XLEN-1:0]                 csr_satp_o,             //satp csr
    output wire [`FCSR_FRM_LEN-1:0]         csr_fcsr_frm,
    output wire [(16*8)-1:0]                csr_pmpcfg_array,       //pmpcfg csr array in bus form
    output wire [(16*54)-1:0]               csr_pmpaddr_array,      //pmpaddr csr array in bus form

    //Inputs From CLINT
    input  wire [`XLEN-1:0]                 CLINT_time,

    //Other Control Signals
    output wire                             ICache_Enable,
    output wire                             ITLB_Enable,
    output wire                             uBTB_Enable,
    output wire                             uBTB_RAS_Enable,        //1=>Enable Return Address Stack
    output wire                             DP_Enable,
    output wire                             DCache_Enable,
    output wire                             DTLB_Enable,
    output wire                             PMA_Check_Enable        //1=>Enables PMA Access Check

);
/*****************************************************************************
*                     Extract Input Wires & Local Wires                     *
*****************************************************************************/
wire                            Retire_Exception_Req    = Retire2SysCtl_Bus[`RETIRE2SYSCTL_EXCEPTION];
wire [`ECAUSE_LEN-1:0]          Retire_Exception_Cause  = Retire2SysCtl_Bus[`RETIRE2SYSCTL_ECAUSE];
wire                            Retire_ExcPC_Valid      = Retire2SysCtl_Bus[`RETIRE2SYSCTL_EXC_PC_VALID];
wire [`XLEN-1:0]                Retire_ExcPC            = Retire2SysCtl_Bus[`RETIRE2SYSCTL_EXC_PC];
wire [`XLEN-1:0]                Retire_TrapVal          = Retire2SysCtl_Bus[`RETIRE2SYSCTL_TRAP_VAL];
wire                            Retire_xRET_Req         = Retire2SysCtl_Bus[`RETIRE2SYSCTL_IS_XRET];
wire [`PRIV_LVL__LEN-1:0]       Retire_xRET_Mode        = Retire2SysCtl_Bus[`RETIRE2SYSCTL_RETMODE];
wire                            Retire_PipeFlush_Req    = Retire2SysCtl_Bus[`RETIRE2SYSCTL_IS_FLUSHPIPE];
wire                            Retire_fp_reg_dirty     = Retire2SysCtl_Bus[`RETIRE2SYSCTL_FPU_DIRTY];
wire                            Retire_fcsr_WE          = Retire2SysCtl_Bus[`RETIRE2SYSCTL_FCSR_WE];
wire [`FCSR_FFLAGS_LEN-1:0]     Retire_fcsr_fflags      = Retire2SysCtl_Bus[`RETIRE2SYSCTL_FCSR];
wire [$clog2(`RETIRE_RATE):0]   Retire_RetireCnt        = Retire2SysCtl_Bus[`RETIRE2SYSCTL_RETIRECNT];

wire                            CSR_We                  = SYSreqIn[`SYS_REQ_CSR_WE];
wire                            CSR_Re                  = SYSreqIn[`SYS_REQ_CSR_RE];
wire [`CSR_ADDR_LEN-1:0]        CSR_Addr                = SYSreqIn[`SYS_REQ_CSR_ADDR];
wire [`XLEN-1:0]                CSR_WrData              = SYSreqIn[`SYS_REQ_CSR_DATA];
wire                            Fence_Req               = SYSreqIn[`SYS_REQ_FENCE_REQ];
wire [11:0]                     Fence_Data              = SYSreqIn[`SYS_REQ_FENCE_DATA];
wire                            Fencei_Req              = SYSreqIn[`SYS_REQ_FENCEI_REQ];
wire                            Sfence_Req              = SYSreqIn[`SYS_REQ_SFENCE_REQ];
wire [`XLEN-1:0]                Sfence_ASID             = SYSreqIn[`SYS_REQ_SFENCE_ASID];
wire [`XLEN-1:0]                Sfence_Vaddr            = SYSreqIn[`SYS_REQ_SFENCE_VADDR];
wire [1:0]                      CSR_Addr_Access         = CSR_Addr[`CSR_ACCESS_RANGE];
wire [1:0]                      CSR_Addr_Priv           = CSR_Addr[`CSR_PRIV_RANGE];

wire                            AR_Req_Valid            = AR_Req[`AR_REQ_VALID];
wire                            AR_Req_IsLR             = AR_Req[`AR_REQ_ISLR];
wire                            AR_Req_IsWord           = AR_Req[`AR_REQ_ISWORD];
wire [`PLEN-1:0]                AR_Req_Paddr            = AR_Req[`AR_REQ_PADDR];


//Local Wires
reg                             csr_read_exception, csr_write_exception, csr_privilege_exception;
reg  [`XLEN-1:0]                CSR_RdData;
reg                             fp_fcsr_dirty;
reg                             csr_pipeline_flush_req;

//Convert Level Interrupts (NMI and Local Interrupt) into Pulse
wire irq_NMI_p;
level2pulse #(.EDGE("posedge"),.PULSE_ACTIVE_POLARITY(1),.SYNC(0))
l2p_nmi (.clk(clk),.rst(rst),.level_in(irq_NMI),.pulse_out(irq_NMI_p));

/*****************************************************************************
*                               CSR Registers                               *
*****************************************************************************/
//ISA defined performance counter CSRs
reg  [`XLEN-1:0]    csr_cycle, csr_instret,  csr_cycle_d, csr_instret_d;
reg  [`XLEN-1:0]    csr_mcountinhibit,  csr_mcountinhibit_d;

//Mirrored CSRs
reg  [`XLEN-1:0]    csr_xstatus, csr_xie, csr_xip,  csr_xstatus_d, csr_xie_d, csr_xip_d;

//M-Mode Trap CSRs
reg  [`XLEN-1:0]    csr_medeleg, csr_mideleg,  csr_medeleg_d, csr_mideleg_d;
reg  [`XLEN-1:0]    csr_mtvec, csr_mepc, csr_mcause, csr_mtval,  csr_mtvec_d, csr_mepc_d, csr_mcause_d, csr_mtval_d;
reg  [`XLEN-1:0]    csr_mscratch, csr_mcounteren,  csr_mscratch_d, csr_mcounteren_d;

//PMP CSRs
reg  [`PMPCFG__LEN-1:0]     csr_pmpcfg[0:15],   csr_pmpcfg_d[0:15];
reg  [`XLEN-1:0]            csr_pmpaddr[0:15],  csr_pmpaddr_d[0:15];

//S-Mode Trap CSRs
reg  [`XLEN-1:0]    csr_sscratch, csr_scounteren,  csr_sscratch_d, csr_scounteren_d;
reg  [`XLEN-1:0]    csr_stvec, csr_sepc, csr_scause, csr_stval,  csr_stvec_d, csr_sepc_d, csr_scause_d, csr_stval_d;

//Virtual Memory CSRs
reg  [`XLEN-1:0]    csr_satp,  csr_satp_d;

//U-Mode Common CSRs
reg  [`XLEN-1:0]    csr_fcsr, csr_fcsr_d;

//NOTE: U-Mode Trap CSRs are not present since (N Extension is NOT supported)

//Misc. Non Standard registers
reg  [1:0]          priv_lvl,  priv_lvl_d;

//Custom CSR Registers
reg  [`XLEN-1:0]    csr_cachectl, csr_mmuctl, csr_perfctl, csr_cachectl_d, csr_mmuctl_d, csr_perfctl_d;


/*****************************************************************************
*                   Hart Level Interrupt Controller                          *
*****************************************************************************/
reg                         global_irq_enable;
reg                         trap_valid;

reg [1:0]                   trap_type; //NMI, IRQ, Exc, RET
localparam trap_type__NMI = 2'b11;
localparam trap_type__IRQ = 2'b10;
localparam trap_type__EXC = 2'b00;
localparam trap_type__RET = 2'b01;

reg [`XLEN-1:0]             trap_cause; //similar to xcause
reg [`PRIV_LVL__LEN-1:0]    trap_to_priv_lvl;
reg [`PRIV_LVL__LEN-1:0]    trap_from_priv_lvl;

//Wires for debug probes
(* DONT_TOUCH = "true" *) wire          dbg_trap_valid = trap_valid;
(* DONT_TOUCH = "true" *) wire [1:0]    dbg_trap_type  = trap_type;
(* DONT_TOUCH = "true" *) wire [63:0]   dbg_trap_cause = trap_cause;
(* DONT_TOUCH = "true" *) wire [1:0]    dbg_trap_to_priv_lvl = trap_to_priv_lvl;


//Priority: NMI > Platform Interrupts (..2>1>0) > MEI > MSI > MTI > SEI > SSI > STI > Exceptions > xRET
integer li;
always @(*) begin
    //Global IRQ Enable Check (As all interrupts are to be handled in M Mode.
    //If current priv level is <M then interrupts are always enabled
    //regardless of MIE bit.
    //Interrupt enabled if NOT in M-Mode or if in M-Mode and MIE=1
    if((priv_lvl!=`PRIV_LVL_M) || (priv_lvl==`PRIV_LVL_M && csr_xstatus[`XSTATUS_MIE]))
        global_irq_enable = 1'b1;
    else
        global_irq_enable = 1'b0;


    //Interrupt can be caught by inst only iff instr is available in ROB Peek
    //Entry. Else we can not determine which instruction took the interrupt.
    //So we will have to wait till ROB Peek Entry is valid.
    global_irq_enable = global_irq_enable & Retire_ExcPC_Valid;


    //set default values
    trap_valid         = 1'b0;
    trap_type          = 0;
    trap_cause         = 0;
    trap_to_priv_lvl   = `PRIV_LVL_M;
    trap_from_priv_lvl = priv_lvl;


    //Priority Wise Interrupt/Exception/Return Checking
    if(irq_NMI_p) begin
        trap_valid       = 1'b1;
        trap_type        = trap_type__NMI;
        trap_to_priv_lvl = `PRIV_LVL_M;
    end

    if(trap_valid==1'b0 && csr_xie[`ISA_IRQ_M_EXT]   && (irq_machine_ext | csr_xip[`ISA_IRQ_M_EXT]) && global_irq_enable ) begin
        trap_type                   = trap_type__IRQ;
        trap_cause[`XLEN-1]         = 1'b1;
        trap_cause[`ECAUSE_LEN-1:0] = `ISA_IRQ_M_EXT;

        if(csr_mideleg[`ISA_IRQ_M_EXT]) begin   //check if interrupt delegated to S-Mode.
            //check for avoiding delegation of trap from higher priv level to lower
            if((csr_xstatus[`XSTATUS_SIE] && priv_lvl==`PRIV_LVL_S) || (priv_lvl==`PRIV_LVL_U)) begin
                trap_valid         = 1'b1;
                trap_to_priv_lvl   = `PRIV_LVL_S;
            end
        end else begin
                trap_valid         = 1'b1;
                trap_to_priv_lvl   = `PRIV_LVL_M;
        end
    end

    if(trap_valid==1'b0 && csr_xie[`ISA_IRQ_M_SOFT]  && (irq_machine_soft | csr_xip[`ISA_IRQ_M_SOFT]) && global_irq_enable ) begin
        trap_type                   = trap_type__IRQ;
        trap_cause[`XLEN-1]         = 1'b1;
        trap_cause[`ECAUSE_LEN-1:0] = `ISA_IRQ_M_SOFT;

        if(csr_mideleg[`ISA_IRQ_M_SOFT]) begin  //check if interrupt delegated to S-Mode.
            //check for avoiding delegation of trap from higher priv level to lower
            if((csr_xstatus[`XSTATUS_SIE] && priv_lvl==`PRIV_LVL_S) || (priv_lvl==`PRIV_LVL_U)) begin
                trap_valid         = 1'b1;
                trap_to_priv_lvl   = `PRIV_LVL_S;
            end
        end else begin
                trap_valid         = 1'b1;
                trap_to_priv_lvl   = `PRIV_LVL_M;
        end
    end

    if(trap_valid==1'b0 && csr_xie[`ISA_IRQ_M_TIMER] && (irq_machine_timer | csr_xip[`ISA_IRQ_M_TIMER]) && global_irq_enable ) begin
        trap_type                   = trap_type__IRQ;
        trap_cause[`XLEN-1]         = 1'b1;
        trap_cause[`ECAUSE_LEN-1:0] = `ISA_IRQ_M_TIMER;

        if(csr_mideleg[`ISA_IRQ_M_TIMER]) begin //check if interrupt delegated to S-Mode.
            //check for avoiding delegation of trap from higher priv level to lower
            if((csr_xstatus[`XSTATUS_SIE] && priv_lvl==`PRIV_LVL_S) || (priv_lvl==`PRIV_LVL_U)) begin
                trap_valid         = 1'b1;
                trap_to_priv_lvl   = `PRIV_LVL_S;
            end
        end else begin
                trap_valid         = 1'b1;
                trap_to_priv_lvl   = `PRIV_LVL_M;
        end
    end

    if(trap_valid==1'b0 && csr_xie[`ISA_IRQ_S_EXT] && csr_xip[`ISA_IRQ_S_EXT] && global_irq_enable && StallTillRetireLock==1'b0) begin
        //Since SEI can be set by software also, the instruction which caused
        //to trigger SEI interrupt should retire first. Then we can service
        //interrupt, otherwise interrupt will become imprecise as we are not
        //converting interrupts to exceptions.
        trap_type                   = trap_type__IRQ;
        trap_cause[`XLEN-1]         = 1'b1;
        trap_cause[`ECAUSE_LEN-1:0] = `ISA_IRQ_S_EXT;

        if(csr_mideleg[`ISA_IRQ_S_EXT]) begin   //check if interrupt delegated to S-Mode.
            //check for avoiding delegation of trap from higher priv level to lower
            if((csr_xstatus[`XSTATUS_SIE] && priv_lvl==`PRIV_LVL_S) || (priv_lvl==`PRIV_LVL_U)) begin
                trap_valid         = 1'b1;
                trap_to_priv_lvl   = `PRIV_LVL_S;
            end
        end else begin
                trap_valid         = 1'b1;
                trap_to_priv_lvl   = `PRIV_LVL_M;
        end
    end

    if(trap_valid==1'b0 && csr_xie[`ISA_IRQ_S_SOFT]  && csr_xip[`ISA_IRQ_S_SOFT] && global_irq_enable && StallTillRetireLock==1'b0) begin
        //Since SSI is set by software only, the instruction which caused
        //to trigger SSI interrupt should retire first. Then we can service
        //interrupt, otherwise interrupt will become imprecise as we are not
        //converting interrupts to exceptions.
        trap_type                   = trap_type__IRQ;
        trap_cause[`XLEN-1]         = 1'b1;
        trap_cause[`ECAUSE_LEN-1:0] = `ISA_IRQ_S_SOFT;

        if(csr_mideleg[`ISA_IRQ_S_SOFT]) begin  //check if interrupt delegated to S-Mode.
            //check for avoiding delegation of trap from higher priv level to lower
            if((csr_xstatus[`XSTATUS_SIE] && priv_lvl==`PRIV_LVL_S) || (priv_lvl==`PRIV_LVL_U)) begin
                trap_valid         = 1'b1;
                trap_to_priv_lvl   = `PRIV_LVL_S;
            end
        end else begin
                trap_valid         = 1'b1;
                trap_to_priv_lvl   = `PRIV_LVL_M;
        end
    end

    if(trap_valid==1'b0 && csr_xie[`ISA_IRQ_S_TIMER] && csr_xip[`ISA_IRQ_S_TIMER] && global_irq_enable && StallTillRetireLock==1'b0) begin
        //Since STI is set by software only, the instruction which caused
        //to trigger STI interrupt should retire first. Then we can service
        //interrupt, otherwise interrupt will become imprecise as we are not
        //converting interrupts to exceptions.
        trap_type                   = trap_type__IRQ;
        trap_cause[`XLEN-1]         = 1'b1;
        trap_cause[`ECAUSE_LEN-1:0] = `ISA_IRQ_S_TIMER;

        if(csr_mideleg[`ISA_IRQ_S_TIMER]) begin //check if interrupt delegated to S-Mode.
            //check for avoiding delegation of trap from higher priv level to lower
            if((csr_xstatus[`XSTATUS_SIE] && priv_lvl==`PRIV_LVL_S) || (priv_lvl==`PRIV_LVL_U)) begin
                trap_valid         = 1'b1;
                trap_to_priv_lvl   = `PRIV_LVL_S;
            end
        end else begin
                trap_valid         = 1'b1;
                trap_to_priv_lvl   = `PRIV_LVL_M;
        end
    end

    if(trap_valid==1'b0 && (|irq_local) && global_irq_enable) begin
        for(li=0; li<platform_irqs; li=li+1) begin
            if(irq_local[li] && csr_xie[16+li]) begin
                trap_valid          = 1'b1;
                trap_type           = trap_type__IRQ;
                trap_cause          = 16 + li;
                trap_cause[`XLEN-1] = 1'b1;
                trap_to_priv_lvl    = `PRIV_LVL_M;
            end
        end
    end

    if(trap_valid==1'b0 && Retire_Exception_Req) begin
        trap_valid                  = 1'b1;
        trap_type                   = trap_type__EXC;
        trap_cause[`XLEN-1]         = 1'b0;
        trap_cause[`ECAUSE_LEN-1:0] = Retire_Exception_Cause;

        //check if exception is delegated to S-Mode
        if(csr_medeleg[Retire_Exception_Cause]) begin
            //traps never transition from more priv. to less priv.
            //So if current mode = M then trap to M mode instead of S Mode
            if(priv_lvl==`PRIV_LVL_M)
                trap_to_priv_lvl = `PRIV_LVL_M;
            else
                trap_to_priv_lvl = `PRIV_LVL_S;
        end
    end

    if(trap_valid==1'b0 && Retire_xRET_Req) begin
        trap_valid         = 1'b1;
        trap_type          = trap_type__RET;
        trap_from_priv_lvl = Retire_xRET_Mode;
    end
end

/*****************************************************************************
*                             PC Redirect Logic                              *
*****************************************************************************/
reg [`XLEN-1:0] trap_vector_baseaddr;
always @(*) begin
    //set default values
    SysCtl_Redirect   = 1'b0;
    SysCtl_RedirectPC = 0;
    RetireAllowed     = 1'b1;
    trap_vector_baseaddr = 0;

    if(trap_valid) begin
        //Request from SysCtl to all units for redirect
        SysCtl_Redirect = 1'b1;

        //Set target trap vector address based on trap_to_priv_lvl
        if(trap_to_priv_lvl==`PRIV_LVL_S)
            trap_vector_baseaddr = {csr_stvec[`XLEN-1:2], 2'b00};
        else
            trap_vector_baseaddr = {csr_mtvec[`XLEN-1:2], 2'b00};

        case(trap_type)
            trap_type__IRQ: begin
                //depending on *tvec mode modify Redirect Address
                if( (trap_to_priv_lvl==`PRIV_LVL_M && csr_mtvec[`XTVEC_MODE_RANGE]==`XTVEC_MODE__VECTORED) ||
                    (trap_to_priv_lvl==`PRIV_LVL_S && csr_stvec[`XTVEC_MODE_RANGE]==`XTVEC_MODE__VECTORED) )
                    SysCtl_RedirectPC = trap_vector_baseaddr + (trap_cause<<2);
                else
                    SysCtl_RedirectPC = trap_vector_baseaddr;
                //Do Not Retire any instruction in Retire Group, as the cause
                //of redirect is interrupt (async)
                RetireAllowed = 1'b0;
            end

            trap_type__EXC: begin
                //All Exceptions traps to base address only
                SysCtl_RedirectPC = trap_vector_baseaddr;
                //Since redirect is caused by Exception. We should retire
                //instr only if exception is an environment call
                if( trap_cause[`ECAUSE_LEN-1:0]==`EXC_ECALL_UMODE ||
                    trap_cause[`ECAUSE_LEN-1:0]==`EXC_ECALL_SMODE ||
                    trap_cause[`ECAUSE_LEN-1:0]==`EXC_ECALL_MMODE)
                    RetireAllowed = 1'b1;
                else
                    RetireAllowed = 1'b0;
            end

            trap_type__RET: begin
                if(trap_from_priv_lvl==`PRIV_LVL_S)
                    SysCtl_RedirectPC = csr_sepc;
                else
                    SysCtl_RedirectPC = csr_mepc;
                //Since Redirect is due to RET, So retire the RET instr
                RetireAllowed = 1'b1;
            end

            trap_type__NMI: begin
                SysCtl_RedirectPC = `NMI_PC;
                RetireAllowed     = 1'b0;
            end
        endcase
    end
    else if(Retire_PipeFlush_Req) begin
        //Redirect PC to next instruction
        //NOTE: As of now only system instructions can request pipeline flush
        //And all system instructions are 32-bit (except C.EBREAK, anyhow it
        //will generate exception). So Redirect address is Exception PC + 4
        SysCtl_Redirect   = 1'b1;
        SysCtl_RedirectPC = Retire_ExcPC+4;

        //Retire the instruction which requested Pipeline Flush
        RetireAllowed = 1'b1;
    end
end


/*****************************************************************************
*                          CSR Read/Write Process                           *
*****************************************************************************/
//CSR Privilege Violation check
always @(*) begin
    //Match Current Privilege level and Minimum Priv Level of CSR (from CSR
    //Address)
    if( (priv_lvl & CSR_Addr_Priv)!= CSR_Addr_Priv)
        csr_privilege_exception = 1'b1;
    else
        csr_privilege_exception = 1'b0;

    //check for accessiblity of high performance monitor (HPM) counters to
    //an priv level
    if(CSR_Addr[11:5]==7'h60) begin //for counter address range between C00 to C1F
        if(priv_lvl==`PRIV_LVL_U)
            csr_privilege_exception = ~csr_mcounteren[{1'b0,CSR_Addr[4:0]}] & ~csr_scounteren[{1'b0,CSR_Addr[4:0]}];
        else if(priv_lvl==`PRIV_LVL_S)
            csr_privilege_exception = ~csr_mcounteren[{1'b0,CSR_Addr[4:0]}];
        else
            csr_privilege_exception = 1'b0;
    end
end

//CSR Read Process
always @(*) begin
    csr_read_exception = 1'b0;
    CSR_RdData         = 0;
    if(CSR_Re & !csr_privilege_exception) begin
        case(CSR_Addr)
            `CSR_FFLAGS        : begin
                if(csr_xstatus[`XSTATUS_FS]==`XSTATUS_FS__OFF)
                    csr_read_exception = 1'b1;
                else
                    CSR_RdData[`FCSR_FFLAGS_LEN-1:0] = csr_fcsr[`FCSR_FFLAGS_RANGE];
            end

            `CSR_FRM           : begin
                if(csr_xstatus[`XSTATUS_FS]==`XSTATUS_FS__OFF)
                    csr_read_exception = 1'b1;
                else
                    CSR_RdData[`FCSR_FRM_LEN-1:0] = csr_fcsr[`FCSR_FRM_RANGE];
            end

            `CSR_FCSR          : begin
                if(csr_xstatus[`XSTATUS_FS]==`XSTATUS_FS__OFF)
                    csr_read_exception = 1'b1;
                else
                    CSR_RdData = csr_fcsr;
            end

            `CSR_CYCLE         : CSR_RdData = csr_cycle;
            `CSR_TIME          : CSR_RdData = CLINT_time;
            `CSR_INSTRET       : CSR_RdData = csr_instret;

            `CSR_SSTATUS       : CSR_RdData = csr_xstatus & `OOO_XSTATUS_S_RD_MASK;
            `CSR_SIE           : CSR_RdData = csr_xie & csr_mideleg;
            `CSR_STVEC         : CSR_RdData = csr_stvec;
            `CSR_SCOUNTEREN    : CSR_RdData = csr_scounteren;
            `CSR_SSCRATCH      : CSR_RdData = csr_sscratch;
            `CSR_SEPC          : CSR_RdData = csr_sepc;
            `CSR_SCAUSE        : CSR_RdData = csr_scause;
            `CSR_STVAL         : CSR_RdData = csr_stval;
            `CSR_SIP           : begin
                CSR_RdData = csr_xip & csr_mideleg;
                if(!CSR_We)
                    CSR_RdData[`ISA_IRQ_S_EXT] = CSR_RdData[`ISA_IRQ_S_EXT] | (irq_supervisor_ext & csr_mideleg[`ISA_IRQ_S_EXT]);
            end

            `CSR_SATP          : begin
                if(csr_xstatus[`XSTATUS_TVM]==1'b1 && priv_lvl==`PRIV_LVL_S)
                    csr_read_exception = 1'b1;
                else
                    CSR_RdData = csr_satp;
            end

            `CSR_MVENDORID     : CSR_RdData = `OOO_VENDOR_ID;
            `CSR_MARCHID       : CSR_RdData = `OOO_ARCH_ID;
            `CSR_MIMPID        : CSR_RdData = `OOO_IMPL_ID;
            `CSR_MHARTID       : CSR_RdData = HART_ID;

            `CSR_MSTATUS       : CSR_RdData = csr_xstatus & `OOO_XSTATUS_M_RD_MASK;
            `CSR_MISA          : CSR_RdData = `OOO_MISA;
            `CSR_MEDELEG       : CSR_RdData = csr_medeleg;
            `CSR_MIDELEG       : CSR_RdData = csr_mideleg;
            `CSR_MIE           : CSR_RdData = csr_xie & `OOO_XIE_M_RD_MASK;
            `CSR_MTVEC         : CSR_RdData = csr_mtvec;
            `CSR_MCOUNTEREN    : CSR_RdData = csr_mcounteren;

            `CSR_MSCRATCH      : CSR_RdData = csr_mscratch;
            `CSR_MEPC          : CSR_RdData = csr_mepc;
            `CSR_MCAUSE        : CSR_RdData = csr_mcause;
            `CSR_MTVAL         : CSR_RdData = csr_mtval;
            `CSR_MIP           : begin
                CSR_RdData = csr_xip & `OOO_XIP_M_RD_MASK;
                if(!CSR_We)
                    CSR_RdData[`ISA_IRQ_S_EXT] = CSR_RdData[`ISA_IRQ_S_EXT] | irq_supervisor_ext;
            end

            `CSR_PMPCFG0       : CSR_RdData = {csr_pmpcfg[ 7],csr_pmpcfg[ 6],csr_pmpcfg[ 5],csr_pmpcfg[ 4],csr_pmpcfg[ 3],csr_pmpcfg[ 2],csr_pmpcfg[1],csr_pmpcfg[0]};
            `CSR_PMPCFG2       : CSR_RdData = {csr_pmpcfg[15],csr_pmpcfg[14],csr_pmpcfg[13],csr_pmpcfg[12],csr_pmpcfg[11],csr_pmpcfg[10],csr_pmpcfg[9],csr_pmpcfg[8]};

            `CSR_PMPADDR0      : CSR_RdData = csr_pmpaddr[0];
            `CSR_PMPADDR1      : CSR_RdData = csr_pmpaddr[1];
            `CSR_PMPADDR2      : CSR_RdData = csr_pmpaddr[2];
            `CSR_PMPADDR3      : CSR_RdData = csr_pmpaddr[3];
            `CSR_PMPADDR4      : CSR_RdData = csr_pmpaddr[4];
            `CSR_PMPADDR5      : CSR_RdData = csr_pmpaddr[5];
            `CSR_PMPADDR6      : CSR_RdData = csr_pmpaddr[6];
            `CSR_PMPADDR7      : CSR_RdData = csr_pmpaddr[7];
            `CSR_PMPADDR8      : CSR_RdData = csr_pmpaddr[8];
            `CSR_PMPADDR9      : CSR_RdData = csr_pmpaddr[9];
            `CSR_PMPADDR10     : CSR_RdData = csr_pmpaddr[10];
            `CSR_PMPADDR11     : CSR_RdData = csr_pmpaddr[11];
            `CSR_PMPADDR12     : CSR_RdData = csr_pmpaddr[12];
            `CSR_PMPADDR13     : CSR_RdData = csr_pmpaddr[13];
            `CSR_PMPADDR14     : CSR_RdData = csr_pmpaddr[14];
            `CSR_PMPADDR15     : CSR_RdData = csr_pmpaddr[15];

            `CSR_MCOUNTINHIBIT : CSR_RdData = csr_mcountinhibit;
            `CSR_MCYCLE        : CSR_RdData = csr_cycle;
            `CSR_MINSTRET      : CSR_RdData = csr_instret;

            //Other perf related CSRs
            `CSR_MHPMCOUNTER3,  `CSR_HPMCOUNTER3  : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER4,  `CSR_HPMCOUNTER4  : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER5,  `CSR_HPMCOUNTER5  : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER6,  `CSR_HPMCOUNTER6  : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER7,  `CSR_HPMCOUNTER7  : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER8,  `CSR_HPMCOUNTER8  : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER9,  `CSR_HPMCOUNTER9  : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER10, `CSR_HPMCOUNTER10 : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER11, `CSR_HPMCOUNTER11 : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER12, `CSR_HPMCOUNTER12 : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER13, `CSR_HPMCOUNTER13 : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER14, `CSR_HPMCOUNTER14 : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER15, `CSR_HPMCOUNTER15 : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER16, `CSR_HPMCOUNTER16 : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER17, `CSR_HPMCOUNTER17 : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER18, `CSR_HPMCOUNTER18 : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER19, `CSR_HPMCOUNTER19 : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER20, `CSR_HPMCOUNTER20 : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER21, `CSR_HPMCOUNTER21 : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER22, `CSR_HPMCOUNTER22 : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER23, `CSR_HPMCOUNTER23 : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER24, `CSR_HPMCOUNTER24 : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER25, `CSR_HPMCOUNTER25 : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER26, `CSR_HPMCOUNTER26 : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER27, `CSR_HPMCOUNTER27 : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER28, `CSR_HPMCOUNTER28 : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER29, `CSR_HPMCOUNTER29 : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER30, `CSR_HPMCOUNTER30 : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMCOUNTER31, `CSR_HPMCOUNTER31 : CSR_RdData = 0; //NOT Implemented

            `CSR_MHPMEVENT3    : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT4    : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT5    : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT6    : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT7    : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT8    : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT9    : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT10   : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT11   : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT12   : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT13   : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT14   : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT15   : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT16   : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT17   : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT18   : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT19   : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT20   : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT21   : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT22   : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT23   : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT24   : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT25   : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT26   : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT27   : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT28   : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT29   : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT30   : CSR_RdData = 0; //NOT Implemented
            `CSR_MHPMEVENT31   : CSR_RdData = 0; //NOT Implemented

            `CSR_TSELECT       : CSR_RdData = 0; //Debug Spec/Mode not implemented
            `CSR_TDATA1        : CSR_RdData = 0; //Debug Spec/Mode not implemented
            `CSR_TDATA2        : CSR_RdData = 0; //Debug Spec/Mode not implemented
            `CSR_TDATA3        : CSR_RdData = 0; //Debug Spec/Mode not implemented

            //Custom CSRs
            `CSR_CACHECTL      : CSR_RdData = csr_cachectl;
            `CSR_MMUCTL        : CSR_RdData = csr_mmuctl;
            `CSR_PERFCTL       : CSR_RdData = csr_perfctl;

            default            : csr_read_exception = 1'b1;
        endcase
    end
end


/* Cases when Pipeline is flush is done when instr is commited.
*   csr write to satp => fetched instrs are stale => flush pipeline
*   csr write to pmpcfg or pmpaddr => fetched instructions can be invalid => flush pipeline
*   csr write to custom csrs (e.g. cache disable/dtlb disable etc) => flush pipeline
*/
//CSR Write Process
integer pmp;
integer lip;
always @(*) begin
    csr_write_exception    = 1'b0;
    fp_fcsr_dirty          = 1'b0;
    csr_pipeline_flush_req = 1'b0;

    //Assign Default Next State Values
    csr_cycle_d         = csr_cycle;
    csr_instret_d       = csr_instret;
    csr_mcountinhibit_d = csr_mcountinhibit;

    csr_xstatus_d       = csr_xstatus;
    csr_xie_d           = csr_xie;
    csr_xip_d           = csr_xip;

    csr_medeleg_d       = csr_medeleg;
    csr_mideleg_d       = csr_mideleg;
    csr_mtvec_d         = csr_mtvec;
    csr_mepc_d          = csr_mepc;
    csr_mcause_d        = csr_mcause;
    csr_mtval_d         = csr_mtval;
    csr_mscratch_d      = csr_mscratch;
    csr_mcounteren_d    = csr_mcounteren;

    csr_sscratch_d      = csr_sscratch;
    csr_scounteren_d    = csr_scounteren;
    csr_stvec_d         = csr_stvec;
    csr_sepc_d          = csr_sepc;
    csr_scause_d        = csr_scause;
    csr_stval_d         = csr_stval;
    csr_satp_d          = csr_satp;

    csr_fcsr_d          = csr_fcsr;
    priv_lvl_d          = priv_lvl;

    //custom CSRs
    csr_cachectl_d      = csr_cachectl;
    csr_mmuctl_d        = csr_mmuctl;
    csr_perfctl_d       = csr_perfctl;

    for(pmp=0; pmp<16; pmp=pmp+1) begin
        csr_pmpcfg_d[pmp]  = csr_pmpcfg[pmp];
        csr_pmpaddr_d[pmp] = csr_pmpaddr[pmp];
    end

    //default Perf Counters Update (cycle, instret only)
    if(!csr_mcountinhibit[`HPM_CYCLE])
        csr_cycle_d     = csr_cycle     + 1;

    if(!csr_mcountinhibit[`HPM_INSTRET])
        csr_instret_d   = csr_instret   + Retire_RetireCnt;

    //fcsr writing logic
    if(Retire_fcsr_WE)
        csr_fcsr_d[`FCSR_FFLAGS_RANGE] = Retire_fcsr_fflags;

    /***********************
    *  CSR Writing Logic  *
    ***********************/
    if(CSR_We & !csr_privilege_exception) begin
        case(CSR_Addr)
            `CSR_FFLAGS        : begin
                if(csr_xstatus[`XSTATUS_FS]==`XSTATUS_FS__OFF)
                    csr_write_exception = 1'b1;
                else begin
                    fp_fcsr_dirty = 1'b1;
                    csr_fcsr_d[`FCSR_FFLAGS_RANGE] = CSR_WrData[`FCSR_FFLAGS_LEN-1:0];
                end
            end

            `CSR_FRM           : begin
                if(csr_xstatus[`XSTATUS_FS]==`XSTATUS_FS__OFF)
                    csr_write_exception = 1'b1;
                else begin
                    fp_fcsr_dirty = 1'b1;
                    csr_fcsr_d[`FCSR_FRM_RANGE] = CSR_WrData[`FCSR_FRM_LEN-1:0];
                end
            end

            `CSR_FCSR          : begin
                if(csr_xstatus[`XSTATUS_FS]==`XSTATUS_FS__OFF)
                    csr_write_exception = 1'b1;
                else begin
                    fp_fcsr_dirty = 1'b1;
                    csr_fcsr_d[`FCSR_LEN-1:0] = CSR_WrData[`FCSR_LEN-1:0];
                end
            end

            `CSR_CYCLE         : csr_write_exception = 1'b1;    //RO CSR
            `CSR_TIME          : csr_write_exception = 1'b1;    //RO CSR
            `CSR_INSTRET       : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER3   : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER4   : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER5   : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER6   : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER7   : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER8   : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER9   : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER10  : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER11  : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER12  : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER13  : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER14  : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER15  : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER16  : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER17  : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER18  : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER19  : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER20  : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER21  : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER22  : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER23  : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER24  : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER25  : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER26  : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER27  : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER28  : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER29  : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER30  : csr_write_exception = 1'b1;    //RO CSR
            `CSR_HPMCOUNTER31  : csr_write_exception = 1'b1;    //RO CSR

            `CSR_SSTATUS       : begin
                //Modify only those fields which are allowed in XSTATUS Write
                //Mask for S Mode
                csr_xstatus_d = (csr_xstatus & ~(`OOO_XSTATUS_S_WR_MASK)) | (CSR_WrData & `OOO_XSTATUS_S_WR_MASK);
            end

            `CSR_SIE           : begin
                //Modify only those bits which are delegated to S-Mode from M-Mode
                csr_xie_d = (csr_xie & ~csr_mideleg) | (CSR_WrData & csr_mideleg);
            end

            `CSR_STVEC         : csr_stvec_d = {CSR_WrData[`XLEN-1:2],1'b0,CSR_WrData[0]};
            `CSR_SCOUNTEREN    : csr_scounteren_d = {32'b0, CSR_WrData[31:0]};
            `CSR_SSCRATCH      : csr_sscratch_d = CSR_WrData;
            `CSR_SEPC          : csr_sepc_d = {CSR_WrData[`XLEN-1:1],1'b0};
            `CSR_SCAUSE        : csr_scause_d = CSR_WrData;
            `CSR_STVAL         : csr_stval_d = CSR_WrData;
            `CSR_SIP           : begin
                //only implemented bits and iff delegeted from M to S mode can be written
                csr_xip_d = (csr_xip & ~(csr_mideleg & `OOO_XIP_S_WR_MASK)) | (CSR_WrData & (csr_mideleg & `OOO_XIP_S_WR_MASK));
            end

            `CSR_SATP          : begin
                if(priv_lvl==`PRIV_LVL_S && csr_xstatus[`XSTATUS_TVM]==1'b1)
                    csr_write_exception = 1'b1;
                else if((CSR_WrData[`SATP_MODE_RANGE]==`SATP_MODE__BARE) || (CSR_WrData[`SATP_MODE_RANGE]==`SATP_MODE__SV39) ) begin
                    csr_satp_d = CSR_WrData;
                    csr_pipeline_flush_req = 1'b1;
                end
            end

            `CSR_MVENDORID     : csr_write_exception = 1'b1; //RO CSR
            `CSR_MARCHID       : csr_write_exception = 1'b1; //RO CSR
            `CSR_MIMPID        : csr_write_exception = 1'b1; //RO CSR
            `CSR_MHARTID       : csr_write_exception = 1'b1; //RO CSR

            `CSR_MSTATUS       : begin
                csr_xstatus_d = CSR_WrData & `OOO_XSTATUS_M_WR_MASK;
            end

            `CSR_MISA          : ;  //NOTE: MISA is NOT Writable in Implemetation

            `CSR_MEDELEG       : begin
                csr_medeleg_d = (csr_medeleg & ~(`OOO_MEDELEG_MASK)) | (CSR_WrData & `OOO_MEDELEG_MASK);
            end

            `CSR_MIDELEG       : begin
                csr_mideleg_d = (csr_mideleg & ~(`OOO_MIDELEG_MASK)) | (CSR_WrData & `OOO_MIDELEG_MASK);
            end

            `CSR_MIE           : begin
                csr_xie_d = (csr_xie & ~(`OOO_XIE_M_WR_MASK)) | (CSR_WrData & `OOO_XIE_M_WR_MASK);
            end

            `CSR_MTVEC         : csr_mtvec_d = {CSR_WrData[`XLEN-1:2],1'b0,CSR_WrData[0]};
            `CSR_MCOUNTEREN    : csr_mcounteren_d = CSR_WrData;

            `CSR_MSCRATCH      : csr_mscratch_d = CSR_WrData;
            `CSR_MEPC          : csr_mepc_d = {CSR_WrData[`XLEN-1:1],1'b0};
            `CSR_MCAUSE        : csr_mcause_d = CSR_WrData;
            `CSR_MTVAL         : csr_mtval_d = CSR_WrData;

            `CSR_MIP           : begin
                //only implemented bits can be written
                csr_xip_d = (csr_xip & ~(`OOO_XIP_M_WR_MASK)) | (CSR_WrData & `OOO_XIP_M_WR_MASK);
            end

            `CSR_PMPCFG0       : begin
                //Do not update if entry is locked
                for(pmp=0; pmp<8; pmp=pmp+1) begin
                    if(csr_pmpcfg[pmp][`PMPCFG_LOCK]==1'b0)
                        csr_pmpcfg_d[pmp] = CSR_WrData[pmp*`PMPCFG__LEN+:`PMPCFG__LEN];
                end
                csr_pipeline_flush_req = 1'b1;
            end

            `CSR_PMPCFG2       : begin
                //Do not update if entry is locked
                for(pmp=0; pmp<8; pmp=pmp+1) begin
                    if(csr_pmpcfg[pmp][`PMPCFG_LOCK]==1'b0)
                        csr_pmpcfg_d[pmp] = CSR_WrData[pmp*`PMPCFG__LEN+:`PMPCFG__LEN];
                end
                csr_pipeline_flush_req = 1'b1;
            end

            //Do Not update ith entry if it is locked or next entry is TOR & Locked
            `CSR_PMPADDR0      : begin
                if( !(csr_pmpcfg[ 0][`PMPCFG_LOCK] || (csr_pmpcfg[ 1][`PMPCFG_LOCK] & csr_pmpcfg[ 1][`PMPCFG_ADDRMODE]==`PMPCFG_ADDRMODE__TOR) ) ) begin
                    csr_pmpaddr_d[ 0]      = CSR_WrData;
                    csr_pipeline_flush_req = 1'b1;
                end
            end
            `CSR_PMPADDR1      : begin
                if( !(csr_pmpcfg[ 1][`PMPCFG_LOCK] || (csr_pmpcfg[ 2][`PMPCFG_LOCK] & csr_pmpcfg[ 2][`PMPCFG_ADDRMODE]==`PMPCFG_ADDRMODE__TOR) ) ) begin
                    csr_pmpaddr_d[ 1]      = CSR_WrData;
                    csr_pipeline_flush_req = 1'b1;
                end
            end
            `CSR_PMPADDR2      : begin
                if( !(csr_pmpcfg[ 2][`PMPCFG_LOCK] || (csr_pmpcfg[ 3][`PMPCFG_LOCK] & csr_pmpcfg[ 3][`PMPCFG_ADDRMODE]==`PMPCFG_ADDRMODE__TOR) ) ) begin
                    csr_pmpaddr_d[ 2]      = CSR_WrData;
                    csr_pipeline_flush_req = 1'b1;
                end
            end
            `CSR_PMPADDR3      : begin
                if( !(csr_pmpcfg[ 3][`PMPCFG_LOCK] || (csr_pmpcfg[ 4][`PMPCFG_LOCK] & csr_pmpcfg[ 4][`PMPCFG_ADDRMODE]==`PMPCFG_ADDRMODE__TOR) ) ) begin
                    csr_pmpaddr_d[ 3]      = CSR_WrData;
                    csr_pipeline_flush_req = 1'b1;
                end
            end
            `CSR_PMPADDR4      : begin
                if( !(csr_pmpcfg[ 4][`PMPCFG_LOCK] || (csr_pmpcfg[ 5][`PMPCFG_LOCK] & csr_pmpcfg[ 5][`PMPCFG_ADDRMODE]==`PMPCFG_ADDRMODE__TOR) ) ) begin
                    csr_pmpaddr_d[ 4]      = CSR_WrData;
                    csr_pipeline_flush_req = 1'b1;
                end
            end
            `CSR_PMPADDR5      : begin
                if( !(csr_pmpcfg[ 5][`PMPCFG_LOCK] || (csr_pmpcfg[ 6][`PMPCFG_LOCK] & csr_pmpcfg[ 6][`PMPCFG_ADDRMODE]==`PMPCFG_ADDRMODE__TOR) ) ) begin
                    csr_pmpaddr_d[ 5]      = CSR_WrData;
                    csr_pipeline_flush_req = 1'b1;
                end
            end
            `CSR_PMPADDR6      : begin
                if( !(csr_pmpcfg[ 6][`PMPCFG_LOCK] || (csr_pmpcfg[ 7][`PMPCFG_LOCK] & csr_pmpcfg[ 7][`PMPCFG_ADDRMODE]==`PMPCFG_ADDRMODE__TOR) ) ) begin
                    csr_pmpaddr_d[ 6]      = CSR_WrData;
                    csr_pipeline_flush_req = 1'b1;
                end
            end
            `CSR_PMPADDR7      : begin
                if( !(csr_pmpcfg[ 7][`PMPCFG_LOCK] || (csr_pmpcfg[ 8][`PMPCFG_LOCK] & csr_pmpcfg[ 8][`PMPCFG_ADDRMODE]==`PMPCFG_ADDRMODE__TOR) ) ) begin
                    csr_pmpaddr_d[ 7]      = CSR_WrData;
                    csr_pipeline_flush_req = 1'b1;
                end
            end
            `CSR_PMPADDR8      : begin
                if( !(csr_pmpcfg[ 8][`PMPCFG_LOCK] || (csr_pmpcfg[ 9][`PMPCFG_LOCK] & csr_pmpcfg[ 9][`PMPCFG_ADDRMODE]==`PMPCFG_ADDRMODE__TOR) ) ) begin
                    csr_pmpaddr_d[ 8]      = CSR_WrData;
                    csr_pipeline_flush_req = 1'b1;
                end
            end
            `CSR_PMPADDR9      : begin
                if( !(csr_pmpcfg[ 9][`PMPCFG_LOCK] || (csr_pmpcfg[10][`PMPCFG_LOCK] & csr_pmpcfg[10][`PMPCFG_ADDRMODE]==`PMPCFG_ADDRMODE__TOR) ) ) begin
                    csr_pmpaddr_d[ 9]      = CSR_WrData;
                    csr_pipeline_flush_req = 1'b1;
                end
            end
            `CSR_PMPADDR10     : begin
                if( !(csr_pmpcfg[10][`PMPCFG_LOCK] || (csr_pmpcfg[11][`PMPCFG_LOCK] & csr_pmpcfg[11][`PMPCFG_ADDRMODE]==`PMPCFG_ADDRMODE__TOR) ) ) begin
                    csr_pmpaddr_d[10]      = CSR_WrData;
                    csr_pipeline_flush_req = 1'b1;
                end
            end
            `CSR_PMPADDR11     : begin
                if( !(csr_pmpcfg[11][`PMPCFG_LOCK] || (csr_pmpcfg[12][`PMPCFG_LOCK] & csr_pmpcfg[12][`PMPCFG_ADDRMODE]==`PMPCFG_ADDRMODE__TOR) ) ) begin
                    csr_pmpaddr_d[11]      = CSR_WrData;
                    csr_pipeline_flush_req = 1'b1;
                end
            end
            `CSR_PMPADDR12     : begin
                if( !(csr_pmpcfg[12][`PMPCFG_LOCK] || (csr_pmpcfg[13][`PMPCFG_LOCK] & csr_pmpcfg[13][`PMPCFG_ADDRMODE]==`PMPCFG_ADDRMODE__TOR) ) ) begin
                    csr_pmpaddr_d[12]      = CSR_WrData;
                    csr_pipeline_flush_req = 1'b1;
                end
            end
            `CSR_PMPADDR13     : begin
                if( !(csr_pmpcfg[13][`PMPCFG_LOCK] || (csr_pmpcfg[14][`PMPCFG_LOCK] & csr_pmpcfg[14][`PMPCFG_ADDRMODE]==`PMPCFG_ADDRMODE__TOR) ) ) begin
                    csr_pmpaddr_d[13]      = CSR_WrData;
                    csr_pipeline_flush_req = 1'b1;
                end
            end
            `CSR_PMPADDR14     : begin
                if( !(csr_pmpcfg[14][`PMPCFG_LOCK] || (csr_pmpcfg[15][`PMPCFG_LOCK] & csr_pmpcfg[15][`PMPCFG_ADDRMODE]==`PMPCFG_ADDRMODE__TOR) ) ) begin
                    csr_pmpaddr_d[14]      = CSR_WrData;
                    csr_pipeline_flush_req = 1'b1;
                end
            end
            `CSR_PMPADDR15     : begin
                if( !(csr_pmpcfg[15][`PMPCFG_LOCK]                                                                                             ) ) begin
                    csr_pmpaddr_d[15]      = CSR_WrData;
                    csr_pipeline_flush_req = 1'b1;
                end
            end

            `CSR_MCOUNTINHIBIT : csr_mcountinhibit_d = {32'b0, 29'b0, CSR_WrData[2], 1'b0, CSR_WrData[0]}; //No Perf Counter Implemented
            `CSR_MCYCLE        : csr_cycle_d = CSR_WrData;
            `CSR_MINSTRET      : csr_instret_d = CSR_WrData;

            //Other perf rel
            `CSR_MHPMCOUNTER3  : ;  //NOT Implemented
            `CSR_MHPMCOUNTER4  : ;  //NOT Implemented
            `CSR_MHPMCOUNTER5  : ;  //NOT Implemented
            `CSR_MHPMCOUNTER6  : ;  //NOT Implemented
            `CSR_MHPMCOUNTER7  : ;  //NOT Implemented
            `CSR_MHPMCOUNTER8  : ;  //NOT Implemented
            `CSR_MHPMCOUNTER9  : ;  //NOT Implemented
            `CSR_MHPMCOUNTER10 : ;  //NOT Implemented
            `CSR_MHPMCOUNTER11 : ;  //NOT Implemented
            `CSR_MHPMCOUNTER12 : ;  //NOT Implemented
            `CSR_MHPMCOUNTER13 : ;  //NOT Implemented
            `CSR_MHPMCOUNTER14 : ;  //NOT Implemented
            `CSR_MHPMCOUNTER15 : ;  //NOT Implemented
            `CSR_MHPMCOUNTER16 : ;  //NOT Implemented
            `CSR_MHPMCOUNTER17 : ;  //NOT Implemented
            `CSR_MHPMCOUNTER18 : ;  //NOT Implemented
            `CSR_MHPMCOUNTER19 : ;  //NOT Implemented
            `CSR_MHPMCOUNTER20 : ;  //NOT Implemented
            `CSR_MHPMCOUNTER21 : ;  //NOT Implemented
            `CSR_MHPMCOUNTER22 : ;  //NOT Implemented
            `CSR_MHPMCOUNTER23 : ;  //NOT Implemented
            `CSR_MHPMCOUNTER24 : ;  //NOT Implemented
            `CSR_MHPMCOUNTER25 : ;  //NOT Implemented
            `CSR_MHPMCOUNTER26 : ;  //NOT Implemented
            `CSR_MHPMCOUNTER27 : ;  //NOT Implemented
            `CSR_MHPMCOUNTER28 : ;  //NOT Implemented
            `CSR_MHPMCOUNTER29 : ;  //NOT Implemented
            `CSR_MHPMCOUNTER30 : ;  //NOT Implemented
            `CSR_MHPMCOUNTER31 : ;  //NOT Implemented

            `CSR_MHPMEVENT3    : ;  //NOT Implemented
            `CSR_MHPMEVENT4    : ;  //NOT Implemented
            `CSR_MHPMEVENT5    : ;  //NOT Implemented
            `CSR_MHPMEVENT6    : ;  //NOT Implemented
            `CSR_MHPMEVENT7    : ;  //NOT Implemented
            `CSR_MHPMEVENT8    : ;  //NOT Implemented
            `CSR_MHPMEVENT9    : ;  //NOT Implemented
            `CSR_MHPMEVENT10   : ;  //NOT Implemented
            `CSR_MHPMEVENT11   : ;  //NOT Implemented
            `CSR_MHPMEVENT12   : ;  //NOT Implemented
            `CSR_MHPMEVENT13   : ;  //NOT Implemented
            `CSR_MHPMEVENT14   : ;  //NOT Implemented
            `CSR_MHPMEVENT15   : ;  //NOT Implemented
            `CSR_MHPMEVENT16   : ;  //NOT Implemented
            `CSR_MHPMEVENT17   : ;  //NOT Implemented
            `CSR_MHPMEVENT18   : ;  //NOT Implemented
            `CSR_MHPMEVENT19   : ;  //NOT Implemented
            `CSR_MHPMEVENT20   : ;  //NOT Implemented
            `CSR_MHPMEVENT21   : ;  //NOT Implemented
            `CSR_MHPMEVENT22   : ;  //NOT Implemented
            `CSR_MHPMEVENT23   : ;  //NOT Implemented
            `CSR_MHPMEVENT24   : ;  //NOT Implemented
            `CSR_MHPMEVENT25   : ;  //NOT Implemented
            `CSR_MHPMEVENT26   : ;  //NOT Implemented
            `CSR_MHPMEVENT27   : ;  //NOT Implemented
            `CSR_MHPMEVENT28   : ;  //NOT Implemented
            `CSR_MHPMEVENT29   : ;  //NOT Implemented
            `CSR_MHPMEVENT30   : ;  //NOT Implemented
            `CSR_MHPMEVENT31   : ;  //NOT Implemented

            `CSR_TSELECT       : ;  //Debug Spec/Mode not implemented
            `CSR_TDATA1        : ;  //Debug Spec/Mode not implemented
            `CSR_TDATA2        : ;  //Debug Spec/Mode not implemented
            `CSR_TDATA3        : ;  //Debug Spec/Mode not implemented

            //Custom CSRs
            `CSR_CACHECTL      : csr_cachectl_d = CSR_WrData;
            `CSR_MMUCTL        : csr_mmuctl_d   = CSR_WrData;
            `CSR_PERFCTL       : csr_perfctl_d  = CSR_WrData;

            default            : csr_write_exception = 1'b1;
        endcase
    end

    /***********************************
    *  Set Default Overriding Values   *
    ***********************************/
    //Fixed UXL & SXL to 64 (Can not be changed)
    csr_xstatus_d[`XSTATUS_UXL] = `XSTATUS_XLEN__64;
    csr_xstatus_d[`XSTATUS_SXL] = `XSTATUS_XLEN__64;

    //Assign FS field to dirty if modified
    if(fp_fcsr_dirty | Retire_fp_reg_dirty)
        csr_xstatus_d[`XSTATUS_FS] = `XSTATUS_FS__DIRTY;

    //Assign RO field XS & SD in xstatus
    csr_xstatus_d[`XSTATUS_XS]  = `XSTATUS_XS__OFF;
    csr_xstatus_d[`XSTATUS_SD]  = (csr_xstatus_d[`XSTATUS_FS]==`XSTATUS_FS__DIRTY) | (csr_xstatus_d[`XSTATUS_XS]==`XSTATUS_XS__DIRTY);

    //Update Interrupt Pending Bits if not set explicitely by csr write
    csr_xip_d[`ISA_IRQ_M_EXT]   = irq_machine_ext;  //MEIP is RO
    csr_xip_d[`ISA_IRQ_M_SOFT]  = irq_machine_soft; //MSIP Cannot be changed by writing to mip
    csr_xip_d[`ISA_IRQ_M_TIMER] = irq_machine_timer;//MTIP is RO
    csr_xip_d[`ISA_IRQ_S_EXT]   = csr_xip_d[`ISA_IRQ_S_EXT] | irq_supervisor_ext; //intr pending can be set by software or from input request

    for(lip=0; lip<platform_irqs; lip=lip+1)
        csr_xip_d[16+lip] = irq_local[lip];

    /********************************************
    *  Interrupt/Exception/Trap/RET Processing  *
    ********************************************/
    if(trap_valid) begin
        case(trap_type)
            trap_type__IRQ, trap_type__EXC: begin
                if(trap_to_priv_lvl==`PRIV_LVL_S) begin //trap to supervisor mode due to delegation
                    csr_xstatus_d[`XSTATUS_SIE]   = 1'b0;
                    csr_xstatus_d[`XSTATUS_SPIE]  = csr_xstatus[`XSTATUS_SIE];
                    csr_xstatus_d[`XSTATUS_SPP]   = priv_lvl[0];

                    csr_scause_d                  = trap_cause;
                    csr_sepc_d                    = Retire_ExcPC;
                    csr_stval_d                   = Retire_TrapVal;
                    priv_lvl_d                    = `PRIV_LVL_S;
                end
                else begin //trap to Machine Mode
                    csr_xstatus_d[`XSTATUS_MIE]   = 1'b0;
                    csr_xstatus_d[`XSTATUS_MPIE]  = csr_xstatus[`XSTATUS_MIE];
                    csr_xstatus_d[`XSTATUS_MPP]   = priv_lvl;

                    csr_mcause_d                  = trap_cause;
                    csr_mepc_d                    = Retire_ExcPC;
                    csr_mtval_d                   = Retire_TrapVal;
                    priv_lvl_d                    = `PRIV_LVL_M;
                end
            end

            trap_type__RET: begin
                if(Retire_xRET_Mode==`PRIV_LVL_S) begin //SRET
                    csr_xstatus_d[`XSTATUS_SIE]  = csr_xstatus[`XSTATUS_SPIE];
                    csr_xstatus_d[`XSTATUS_SPP]  = 1'b0; //LSB of `PRIV_LVL_U
                    csr_xstatus_d[`XSTATUS_SPIE] = 1'b1;
                    priv_lvl_d                   = {1'b0, csr_xstatus[`XSTATUS_SPP]};
                end
                else begin //MRET
                    csr_xstatus_d[`XSTATUS_MIE]  = csr_xstatus[`XSTATUS_MPIE];
                    csr_xstatus_d[`XSTATUS_MPP]  = `PRIV_LVL_U;
                    csr_xstatus_d[`XSTATUS_MPIE] = 1'b1;
                    priv_lvl_d                   = csr_xstatus[`XSTATUS_MPP];
                end
                //NOTE: URET is NOT Supported as N-Extension is NOT
                //supported
            end
            trap_type__NMI: begin
                //NMI Traps to M-Mode with predefined target.
                //NOTE: ===NON Standard Implementation===
                //If no instruction is available to receive NMI trap, it
                //will consider that RESET_PC as instr that was intrupted.
                //So on return it will continue execution from there.
                csr_mcause_d                  = 0;
                csr_mepc_d                    = Retire_ExcPC_Valid ? Retire_ExcPC : RESET_PC;
                csr_mtval_d                   = 0;
                priv_lvl_d                    = `PRIV_LVL_M;
            end
        endcase
    end

    /****************************
    *  Misc xstatus Overrides   *
    ****************************/
end


//CSR Exception Logic
//generate invalid instruction exception if read/write exception or access
//exception in csr
wire                    csr_exception = csr_read_exception | csr_write_exception | csr_privilege_exception;
wire [`ECAUSE_LEN-1:0]  csr_ecause    = `EXC_ILLEGAL_INSTR;


/*****************************************************************************
*                      Wait For Interrupt (WFI) Logic                       *
*****************************************************************************/
//NOTE: WFI is implemented as NOP Hence Pipeline is NOT Stalled. Otherwise
//SysCtl can stall IFU, EX, LSU by asserting SysCtl_Stall
assign SysCtl_Stall = 1'b0;


/*****************************************************************************
*                        Atomic Reservation Control                          *
*****************************************************************************/
//Reservation Address Registers
reg [`PLEN-1:0] Atomic_Reservation_Paddr;
reg             Atomic_Reservation_Word;
reg             Atomic_Reservation_Valid;

//Atomic Reservation reserving Process
always @(posedge clk) begin
    if(rst) begin
        Atomic_Reservation_Paddr <= 0;
        Atomic_Reservation_Word  <= 0;
        Atomic_Reservation_Valid <= 0;
    end
    else if(AR_Req_Valid && AR_Req_IsLR) begin
        //Load Reserved Request => Mark Reservation as Valid with Paddr and
        //Data Width
        Atomic_Reservation_Valid <= 1'b1;
        Atomic_Reservation_Paddr <= AR_Req_Paddr;
        Atomic_Reservation_Word  <= AR_Req_IsWord;
    end
    else if(AR_Req_Valid && !AR_Req_IsLR) begin
        //Store Conditional Request => Regardless of Sucess or Failure
        //invalidate the reservation
        Atomic_Reservation_Valid <= 1'b0;
    end
end

//Atomic Reservation Checking Process
always @(*) begin
    //assign Default Values
    AR_Resp[`AR_RESP_DONE       ] = 1'b0;
    AR_Resp[`AR_RESP_RESERVATION] = 1'b0;

    if(AR_Req_Valid && !AR_Req_IsLR) begin
        AR_Resp[`AR_RESP_DONE] = 1'b1;
        //Reservation check Succeeds if
        //1. Reservation is valid
        //2. Paddr Matches
        //3. Data Type Matches
        if(Atomic_Reservation_Valid && (Atomic_Reservation_Paddr==AR_Req_Paddr) && (Atomic_Reservation_Word==AR_Req_IsWord) )
            AR_Resp[`AR_RESP_RESERVATION] = 1'b1;
        else
            AR_Resp[`AR_RESP_RESERVATION] = 1'b0;
    end
end


/*****************************************************************************
*                           Fences Control Logic                            *
*****************************************************************************/
/* "Fence" means all specified memory transactions must be visible to other
* harts when fence is excuted. So fence on single core can be implemented by
* flushing dcache and pipeline. Due to "wait_till_empty" flag in uOP for
* fence, when fence executes store buffer is already empty. So flushing dcache
* will make all memory updates visible to all others harts/cores.
  For write through cache, flushing is not required but ordering needs to be followed.
*/

/* "fence.i" means explicite synchroniszation between Instruction and Data
* memory. In Hybrid Howard architechture, instruction and data memory are
* virtually separated and emulated by I & D cache. In order to sync them, both
* should be flushed to main memory and invalidated. dcache flushing is
* required to as icache is not coherent with dcache and dcache flushing
* ensures consistancy between dcache and memory.This is costliest instr.
*/

/* "sfence.vma" means flushing of stale Page Table entries in TLB. So TLB
* flushing is required
*/

localparam state_idle     = 3'b000;
localparam state_busyI    = 3'b001;
localparam state_busyD    = 3'b010;
localparam state_done     = 3'b011;
localparam state_bothbusy = 3'b100;

//FSM Registers
reg [2:0]   fence_state, fence_state_d;
reg [2:0]   sfence_state, sfence_state_d;
reg [2:0]   fencei_state, fencei_state_d;

//FSM Outputs
reg         Fence_Done;
reg         Sfence_Done;
reg         Fencei_Done;

//FSM Flip Flop Process
always @(posedge clk) begin
    if(rst) begin
        fence_state   <= state_idle;
        fencei_state  <= state_idle;
        sfence_state  <= state_idle;
    end
    else begin
        fence_state   <= fence_state_d;
        sfence_state  <= sfence_state_d;
        fencei_state  <= fencei_state_d;
    end
end

//FSM Combo Process (combines all fences as two different fence can generate
//same requests, but two fence request can not be present at once. Hence
//single seq process is used.
always @(*) begin
    //assign default values
    DCache_Flush_Req        = 1'b0;
    ICache_Flush_Req        = 1'b0;
    DTLB_Flush_Req          = 1'b0;
    DTLB_Flush_Req_ASID     = Sfence_ASID[`SATP_ASID_LEN-1:0];
    DTLB_Flush_Req_Vaddr    = Sfence_Vaddr;
    ITLB_Flush_Req          = 1'b0;
    ITLB_Flush_Req_ASID     = Sfence_ASID[`SATP_ASID_LEN-1:0];
    ITLB_Flush_Req_Vaddr    = Sfence_Vaddr;
    Fence_Done              = 1'b0;
    Fencei_Done             = 1'b0;
    Sfence_Done             = 1'b0;

    //FSM for FENCE
    fence_state_d = fence_state;
    case(fence_state)
        state_idle: begin
            if(Fence_Req) begin
                //NOTE: Fence Does Not Implies DCache Flush Always.
                //NOTE: Atleast for single core Fence With
                //1. PW=1 : Mem Store complete before Fence, anyways ensured
                //by WAIT_TILL_EMPTY
                //2. PI=1, PR=1 : IO/Mem Load before Fence must be done, anyways it is
                //done by WAIT_TILL_EMPTY flag on all system instructions
                //3. PO=1 : as IOs are not cached, just empty store buffer is
                //sufficient for this, and it is taken care by WAIT_TILL_EMPTY
                //NOTE: So for single core, fence need not imply cache flush.
                //But for sake of simplicity, we will implement
                //fence iorw,xxxx as cache flush
                if(Fence_Data[(27-20):(24-20)]==4'b1111) begin
                    DCache_Flush_Req = 1'b1;
                    fence_state_d    = state_busyD;
                end
                else begin
                    fence_state_d    = state_done;
                end
            end
        end
        state_busyD: begin
            DCache_Flush_Req = 1'b1;
            if(DCache_Flush_Done)
                fence_state_d = state_done;
        end
        state_done: begin
            Fence_Done    = 1'b1;
            fence_state_d = state_idle;
        end
        default: fence_state_d = state_idle;
    endcase

    //FSM For SFENCE.VMA
    sfence_state_d = sfence_state;
    case(sfence_state)
        state_idle: begin
            if(Sfence_Req) begin
                DTLB_Flush_Req  = 1'b1;
                ITLB_Flush_Req  = 1'b1;
                sfence_state_d  = state_bothbusy;
            end
        end
        state_bothbusy: begin
            DTLB_Flush_Req = 1'b1;
            ITLB_Flush_Req = 1'b1;
            if(DTLB_Flush_Done && ITLB_Flush_Done)
                sfence_state_d = state_done;
            else if(DTLB_Flush_Done)
                sfence_state_d = state_busyI;
            else if(ITLB_Flush_Done)
                sfence_state_d = state_busyD;
        end
        state_busyI: begin
            DTLB_Flush_Req = 1'b0;
            ITLB_Flush_Req = 1'b1;
            if(ITLB_Flush_Done)
                sfence_state_d = state_done;
        end
        state_busyD: begin
            DTLB_Flush_Req = 1'b1;
            ITLB_Flush_Req = 1'b0;
            if(DTLB_Flush_Done)
                sfence_state_d = state_done;
        end
        state_done: begin
            Sfence_Done    = 1'b1;
            sfence_state_d = state_idle;
        end
        default: sfence_state_d = state_idle;
    endcase

    //FSM for FENCE.I
    fencei_state_d = fencei_state;
    case(fencei_state)
        state_idle: begin
            if(Fencei_Req) begin
                ICache_Flush_Req = 1'b1;
                DCache_Flush_Req = 1'b1;
                fencei_state_d   = state_bothbusy;
            end
        end
        state_bothbusy: begin
            ICache_Flush_Req = 1'b1;
            DCache_Flush_Req = 1'b1;
            if(ICache_Flush_Done && DCache_Flush_Done)
                fencei_state_d = state_done;
            else if(ICache_Flush_Done)
                fencei_state_d = state_busyD;
            else if(DCache_Flush_Done)
                fencei_state_d = state_busyI;
        end
        state_busyI: begin
            ICache_Flush_Req = 1'b1;
            DCache_Flush_Req = 1'b0;
            if(ICache_Flush_Done)
                fencei_state_d = state_done;
        end
        state_busyD: begin
            ICache_Flush_Req = 1'b0;
            DCache_Flush_Req = 1'b1;
            if(DCache_Flush_Done)
                fencei_state_d = state_done;
        end
        state_done: begin
            Fencei_Done    = 1'b1;
            fencei_state_d = state_idle;
        end
        default: fencei_state_d = state_idle;
    endcase
end


/*****************************************************************************
*                          CSR Register Assignment                           *
*****************************************************************************/
integer i;
always @(posedge clk) begin
    if(rst) begin
        csr_cycle         <= 0;
        csr_instret       <= 0;
        csr_mcountinhibit <= 0;

        csr_xstatus       <= 64'h0000000a_00000000; //SXL=64bit UXL=64bit

        csr_xie           <= 0;
        csr_xip           <= 0;

        csr_medeleg       <= 0;
        csr_mideleg       <= 0;
        csr_mtvec         <= 0;
        csr_mepc          <= 0;
        csr_mcause        <= 0;
        csr_mtval         <= 0;
        csr_mscratch      <= 0;
        csr_mcounteren    <= 0;

        csr_sscratch      <= 0;
        csr_scounteren    <= 0;
        csr_stvec         <= 0;
        csr_sepc          <= 0;
        csr_scause        <= 0;
        csr_stval         <= 0;
        csr_satp          <= 0;

        csr_fcsr          <= 0;

        priv_lvl          <= `PRIV_LVL_M;

        for(i=0; i<16; i=i+1) begin
            csr_pmpcfg[i] <= 0;
            csr_pmpaddr[i]<= 0;
        end

        //Custom CSRs
        csr_cachectl      <= 64'h3; //Enable I$, D$
        csr_mmuctl        <= 64'h7; //Enable ITLB, DTLB, PMA
        csr_perfctl       <= 64'h7; //Enable uBTB, RAS, uBTB

    end
    else begin
        csr_cycle         <= csr_cycle_d;
        csr_instret       <= csr_instret_d;
        csr_mcountinhibit <= csr_mcountinhibit_d;

        csr_xstatus       <= csr_xstatus_d;
        csr_xie           <= csr_xie_d;
        csr_xip           <= csr_xip_d;

        csr_medeleg       <= csr_medeleg_d;
        csr_mideleg       <= csr_mideleg_d;
        csr_mtvec         <= csr_mtvec_d;
        csr_mepc          <= csr_mepc_d;
        csr_mcause        <= csr_mcause_d;
        csr_mtval         <= csr_mtval_d;
        csr_mscratch      <= csr_mscratch_d;
        csr_mcounteren    <= csr_mcounteren_d;

        csr_sscratch      <= csr_sscratch_d;
        csr_scounteren    <= csr_scounteren_d;
        csr_stvec         <= csr_stvec_d;
        csr_sepc          <= csr_sepc_d;
        csr_scause        <= csr_scause_d;
        csr_stval         <= csr_stval_d;
        csr_satp          <= csr_satp_d;

        csr_fcsr          <= csr_fcsr_d;
        priv_lvl          <= priv_lvl_d;

        for(i=0; i<16; i=i+1) begin
            if(i<`PMP_ENTRIES) begin
                csr_pmpcfg[i]  <= csr_pmpcfg_d[i];
                csr_pmpaddr[i] <= {10'b0, csr_pmpaddr_d[i][`PMPADDR__LEN-1:0]};
            end
            else begin
                csr_pmpcfg[i]  <= 0;
                csr_pmpaddr[i] <= 0;
            end
        end

        //Custom CSRs
        csr_cachectl      <= csr_cachectl_d;
        csr_mmuctl        <= csr_mmuctl_d;
        csr_perfctl       <= csr_perfctl_d;

    end
end

//LSU Translation Enable Resister
always @(*) begin
    if(rst)
        csr_lsu_translateEn = 1'b0;
    else if(csr_xstatus[`XSTATUS_MPRV] & (csr_satp[`SATP_MODE_RANGE]==`SATP_MODE__SV39) & (csr_xstatus[`XSTATUS_MPP]!=`PRIV_LVL_M))
        csr_lsu_translateEn = 1'b1;
    else
        csr_lsu_translateEn = (csr_satp[`SATP_MODE_RANGE]==`SATP_MODE__SV39) && (priv_lvl!=`PRIV_LVL_M);
end

/*****************************************************************************
*                               Outputs Wires                                *
*****************************************************************************/
assign csr_status_sum      = csr_xstatus[`XSTATUS_SUM];
assign csr_status_mxr      = csr_xstatus[`XSTATUS_MXR];
assign csr_status_fs       = csr_xstatus[`XSTATUS_FS];
assign csr_status_priv_lvl = priv_lvl_d;
assign csr_lsu_priv_lvl    = csr_xstatus[`XSTATUS_MPRV] ? csr_xstatus[`XSTATUS_MPP] : priv_lvl;
assign csr_satp_o          = csr_satp;
assign csr_fcsr_frm        = csr_fcsr[`FCSR_FRM_RANGE];

//Custom CSR Outputs
assign ICache_Enable       = csr_cachectl[`CACHECTL_ICACHE_EN];
assign DCache_Enable       = csr_cachectl[`CACHECTL_DCACHE_EN];
assign ITLB_Enable         = csr_mmuctl[`MMUCTL_ITLB_EN];
assign DTLB_Enable         = csr_mmuctl[`MMUCTL_DTLB_EN];
assign PMA_Check_Enable    = csr_mmuctl[`MMUCTL_PMA_CHECK_EN];
assign uBTB_Enable         = csr_perfctl[`PERFCTL_UBTB_EN];
assign uBTB_RAS_Enable     = csr_perfctl[`PERFCTL_RAS_EN];
assign DP_Enable           = csr_perfctl[`PERFCTL_DP_EN];

genvar gpmp;
generate
    for(gpmp=0; gpmp<16; gpmp=gpmp+1) begin
        assign csr_pmpcfg_array[gpmp*`PMPCFG__LEN+:`PMPCFG__LEN] = csr_pmpcfg[gpmp];
        assign csr_pmpaddr_array[gpmp*`PMPADDR__LEN+:`PMPADDR__LEN] = csr_pmpaddr[gpmp][`PMPADDR__LEN-1:0];
    end
endgenerate

assign SYSrespOut[`SYS_RESP_CSR_RDDATA]  = CSR_RdData;
assign SYSrespOut[`SYS_RESP_FENCE_DONE]  = Fence_Done;
assign SYSrespOut[`SYS_RESP_SFENCE_DONE] = Sfence_Done;
assign SYSrespOut[`SYS_RESP_FENCEI_DONE] = Fencei_Done;
assign SYSrespOut[`SYS_RESP_EXCEPTION]   = csr_exception;
assign SYSrespOut[`SYS_RESP_ECAUSE]      = csr_ecause;
assign SYSrespOut[`SYS_RESP_PIPEFLUSH]   = csr_pipeline_flush_req;
assign SYSrespOut[`SYS_RESP_PRIV_LVL]    = priv_lvl;
assign SYSrespOut[`SYS_RESP_STATUS_TSR]  = csr_xstatus[`XSTATUS_TSR];
assign SYSrespOut[`SYS_RESP_STATUS_TW]   = csr_xstatus[`XSTATUS_TW];
assign SYSrespOut[`SYS_RESP_STATUS_TVM]  = csr_xstatus[`XSTATUS_TVM];


`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;
    reg [(10*8)-1:0] MetaStr = "<>";
    `ifdef DEBUG_SYSCTL
        always @(negedge clk) begin
            if(trap_valid) begin
                if(trap_type==trap_type__NMI) begin
                    $display("[%t] SYSCTL@#####: exception interrupt NMI, epc=%h",$time,
                        Retire_ExcPC
                    );
                end
                else if(trap_type==trap_type__IRQ) begin
                    $display("[%t] SYSCTL@#####: exception interrupt #%0d, epc=%h",$time,
                        trap_cause[`ECAUSE_LEN-1:0], Retire_ExcPC
                    );
                end
                else if(trap_type==trap_type__EXC) begin
                    $display("[%t] SYSCTL@#####: exception %0s, epc=%h",$time,
                        PrintEcauseStr(trap_cause[`ECAUSE_LEN-1:0]), Retire_ExcPC
                    );
                    if( (trap_cause[`ECAUSE_LEN-1:0]!=`EXC_ECALL_UMODE) &&
                        (trap_cause[`ECAUSE_LEN-1:0]!=`EXC_ECALL_SMODE) &&
                        (trap_cause[`ECAUSE_LEN-1:0]!=`EXC_ECALL_MMODE) ) begin
                        $display("[%t] SYSCTL@#####:           tval=%h",$time,
                            Retire_TrapVal
                        );
                    end
                end
            end
        end
    `endif
`endif



endmodule

