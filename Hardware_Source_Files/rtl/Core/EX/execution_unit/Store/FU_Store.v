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
module FU_Store
(
    input  wire clk,
    input  wire rst,

    input  wire Flush,

    //Branch Mispredition Inputs
    input  wire                         Kill_Enable,
    input  wire [`SPEC_STATES-1:0]      Kill_VKillMask,

    //Inputs from scheduler port (S2E)
    input  wire                         Port_Valid,
    input  wire [`PORT_S2E_LEN-1:0]     Port_S2E,

    //Outputs to scheduler port (E2S)
    output wire                         Ready,

    //Wakeup Bus Outputs
    output reg  [`WAKEUP_RESP_LEN-1:0]  WakeupResp,

    //Result Bus Outputs
    output reg  [`RESULT_LEN-1:0]       ResultBus,

    //Inputs from LSU
    input  wire [`LSU_RESP_LEN-1:0]     LSUrespIn,

    //outputs to LSU
    output wire [`LSU_REQ_LEN-1:0]      LSUreqOut

);

//extract individual wires from Port S2E (Only required Controls)
wire [`UOP_CONTROL_LEN-1:0]     Controls = Port_S2E[`PORT_S2E_CONTROLS];
wire [`DATA_TYPE__LEN-1:0]      DataType = Controls[`UOP_MEM_DATA_TYPE];
wire                            IsAtomic = Controls[`UOP_MEM_IS_ATOMIC];
wire [1:0]                      AmoData  = Controls[`UOP_MEM_AMO_DATA];
wire [`AMO_OP__LEN-1:0]         AmoOp    = Controls[`UOP_MEM_AMO_SUBOP];
wire [`LS_ORDER_TAG_LEN-1:0]    OrderTag = Controls[`UOP_MEM_LSORDERTAG];

wire                            IsAMO    = IsAtomic & ((AmoOp!=`AMO_OP_LR) && (AmoOp!=`AMO_OP_SC));
wire                            IsLR     = IsAtomic & (AmoOp==`AMO_OP_LR);
wire                            IsSC     = IsAtomic & (AmoOp==`AMO_OP_SC);

wire [63:0]                     op1      = Port_S2E[`PORT_S2E_OP1];  //rs1 data here
wire [63:0]                     Imm      = Port_S2E[`PORT_S2E_OP3];  //Immediate here
wire [63:0]                     op2      = Port_S2E[`PORT_S2E_OP2];  //rs2 data here
wire [63:0]                     PC       = Port_S2E[`PORT_S2E_PC];
wire [63:0]                     Vaddr    = op1 + Imm;

//Branch Misprediction Handling. When branch mispredicted, the instr in
//Execute Unit can be killed if Killmask matches
wire Killed = Kill_Enable & |(Port_S2E[`PORT_S2E_KILLMASK] & Kill_VKillMask);

///////////////////////////////////////////////////////////////////////////////
wire [63:0]                 LSUresp_Data = LSUrespIn[`LSU_RESP_DATA];

reg                         LSUreq_Valid;
reg  [`LSU_OPER__LEN-1:0]   LSUreq_Oper;
reg                         Completed;
reg                         Exception;
reg  [`ECAUSE_LEN-1:0]      ECause;
reg  [`METADATA_LEN-1:0]    MetaData;
reg  [`XLEN-1:0]            ResultData;
reg  [`XLEN-1:0]            StoreData;
reg  [31:0]                 StoreData32;
reg                         LoadData_Enable;
reg                         AMO_State_d;

reg                         AMO_State;
always @(posedge clk) begin
    if(rst)
        AMO_State <= 0;
    else
        AMO_State <= AMO_State_d;
end

reg  [`XLEN-1:0]            LoadData;
always @(posedge clk) begin
    if(rst)
        LoadData <= 0;
    else if(LoadData_Enable)
        LoadData <= LSUrespIn[`LSU_RESP_DATA];
end


always @(*) begin
    //Assign Default Outputs
    LSUreq_Valid    = 1'b0;
    LSUreq_Oper     = 0;
    Completed       = 1'b0;
    Exception       = 1'b0;
    ECause          = 0;
    MetaData        = 0;
    StoreData       = 0;
    ResultData      = 0;
    LoadData_Enable = 0;
    AMO_State_d     = 0;

    if(Port_Valid & Port_S2E[`PORT_S2E_VALID]) begin
        if(!IsAtomic) begin
            //Store Operation
            LSUreq_Valid = 1'b1;
            LSUreq_Oper  = `LSU_OPER_STORE;
            StoreData    = op2;
            if(LSUrespIn[`LSU_RESP_DONE]) begin
                //Store Completed
                Completed = 1'b1;
                if(LSUrespIn[`LSU_RESP_EXCEPTION]) begin
                    //Exception in Store => Send Vaddr as Metadata
                    Exception = 1'b1;
                    ECause    = LSUrespIn[`LSU_RESP_ECAUSE];
                    MetaData  = Vaddr[`METADATA_LEN-1:0];
                end
                else begin
                    //No Exception => Send Store Buffer ID as MetaData
                    Exception                    = 1'b0;
                    MetaData                     = 0;
                    MetaData[`METADATA_STORE_ID] = 1'b1;
                    MetaData[`SB_DEPTH_LEN-1:0]  = LSUresp_Data[`SB_DEPTH_LEN-1:0];
                end
            end
        end
        else if(IsLR) begin
            //Atomic LR Operation
            //check for address alligned to data type
            if( (DataType==`DATA_TYPE_W && Vaddr[1:0]==0) || (DataType==`DATA_TYPE_D && Vaddr[2:0]==0)) begin
                LSUreq_Valid = 1'b1;
                LSUreq_Oper  = `LSU_OPER_AMOLR;
                if(LSUrespIn[`LSU_RESP_DONE]) begin
                    //Atomic LR Completed
                    Completed = 1'b1;
                    if(LSUrespIn[`LSU_RESP_EXCEPTION]) begin
                        //Exception in LR => Send Vaddr as MetaData
                        Exception = 1'b1;
                        ECause    = LSUrespIn[`LSU_RESP_ECAUSE];
                        MetaData  = Vaddr[`METADATA_LEN-1:0];
                    end
                    else begin
                        //No Exception => Send Input Data on Result Bus
                        Exception  = 1'b0;
                        ResultData = LSUresp_Data;
                    end
                end
            end
            else begin
                //Atomic Operation address not alligned to its data type
                Exception   = 1'b1;
                ECause      = `EXC_LADDR_MISALIGN;
                Completed   = 1'b1;
                MetaData    = Vaddr[`METADATA_LEN-1:0];
                AMO_State_d = 0;
            end
        end
        else if(IsSC) begin
            //Atomic SC Operation
            //check for address alligned to data type
            if( (DataType==`DATA_TYPE_W && Vaddr[1:0]==0) || (DataType==`DATA_TYPE_D && Vaddr[2:0]==0)) begin
                LSUreq_Valid = 1'b1;
                LSUreq_Oper  = `LSU_OPER_AMOSC;
                StoreData    = op2;
                if(LSUrespIn[`LSU_RESP_DONE]) begin
                    //Atomic SC Completed
                    Completed = 1'b1;
                    if(LSUrespIn[`LSU_RESP_EXCEPTION]) begin
                        //Exception in SC => Send Vaddr as MetaData
                        Exception = 1'b1;
                        ECause    = LSUrespIn[`LSU_RESP_ECAUSE];
                        MetaData  = Vaddr[`METADATA_LEN-1:0];
                    end
                    else begin
                        //No Exception => Check if Reservation Check failed
                        Exception  = 1'b0;
                        if(LSUresp_Data==(-64'd1)) begin
                            //Reservation Check Failed
                            MetaData   = 0;
                            ResultData = 64'd1;
                        end
                        else begin
                            //Reservation Check Sucessful
                            MetaData                     = 0;
                            MetaData[`METADATA_STORE_ID] = 1'b1;
                            MetaData[`SB_DEPTH_LEN-1:0]  = LSUresp_Data[`SB_DEPTH_LEN-1:0];
                            ResultData = 0;
                        end
                    end
                end
            end
            else begin
                //Atomic Operation address not alligned to its data type
                Exception   = 1'b1;
                ECause      = `EXC_SADDR_MISALIGN;
                Completed   = 1'b1;
                MetaData    = Vaddr[`METADATA_LEN-1:0];
                AMO_State_d = 0;
            end
        end
        else if(IsAMO) begin
            //AMO Operation
            if(AMO_State==1'b0) begin
                //Atomic Load Operation
                //check for address alligned to data type
                if( (DataType==`DATA_TYPE_W && Vaddr[1:0]==0) || (DataType==`DATA_TYPE_D && Vaddr[2:0]==0)) begin
                    LSUreq_Valid = 1'b1;
                    LSUreq_Oper  = `LSU_OPER_AMOLOAD;
                    AMO_State_d  = AMO_State;
                    if(LSUrespIn[`LSU_RESP_DONE]) begin
                        //Atomic Load Completed
                        if(LSUrespIn[`LSU_RESP_EXCEPTION]) begin
                            //Exception in LR => Send Vaddr as MetaData
                            Exception   = 1'b1;
                            ECause      = LSUrespIn[`LSU_RESP_ECAUSE];
                            Completed   = 1'b1;
                            MetaData    = Vaddr[`METADATA_LEN-1:0];
                            AMO_State_d = 0;
                        end
                        else begin
                            //No Exception => Begin 2nd Operation
                            LoadData_Enable = 1'b1;
                            AMO_State_d = 1'b1;
                        end
                    end
                end
                else begin
                    //Atomic Operation address not alligned to its data type
                    Exception   = 1'b1;
                    ECause      = `EXC_SADDR_MISALIGN;
                    Completed   = 1'b1;
                    MetaData    = Vaddr[`METADATA_LEN-1:0];
                    AMO_State_d = 0;
                end
            end
            else begin
                //Atomic Store Operation
                LSUreq_Valid = 1'b1;
                LSUreq_Oper  = `LSU_OPER_AMOSTORE;
                AMO_State_d  = AMO_State;
                //generate data to be written based on AMO Operation & DataType
                if(DataType==`DATA_TYPE_W) begin
                    case(AmoOp)
                        `AMO_OP_SWAP: StoreData32 = op2[31:0];
                        `AMO_OP_ADD : StoreData32 = op2[31:0] + LoadData[31:0];
                        `AMO_OP_XOR : StoreData32 = op2[31:0] ^ LoadData[31:0];
                        `AMO_OP_AND : StoreData32 = op2[31:0] & LoadData[31:0];
                        `AMO_OP_OR  : StoreData32 = op2[31:0] | LoadData[31:0];
                        `AMO_OP_MIN : StoreData32 = (($signed(op2[31:0])<$signed(LoadData[31:0])) ? op2[31:0] : LoadData[31:0]);
                        `AMO_OP_MAX : StoreData32 = (($signed(op2[31:0])<$signed(LoadData[31:0])) ? LoadData[31:0] : op2[31:0]);
                        `AMO_OP_MINU: StoreData32 = ((       (op2[31:0])<       (LoadData[31:0])) ? op2[31:0] : LoadData[31:0]);
                        `AMO_OP_MAXU: StoreData32 = ((       (op2[31:0])<       (LoadData[31:0])) ? LoadData[31:0] : op2[31:0]);
                        default     : StoreData32 = 0;
                    endcase
                    StoreData = {{32{StoreData32[31]}},StoreData32};
                end
                else if(DataType==`DATA_TYPE_D) begin
                    case(AmoOp)
                        `AMO_OP_SWAP: StoreData   = op2;
                        `AMO_OP_ADD : StoreData   = op2 + LoadData;
                        `AMO_OP_XOR : StoreData   = op2 ^ LoadData;
                        `AMO_OP_AND : StoreData   = op2 & LoadData;
                        `AMO_OP_OR  : StoreData   = op2 | LoadData;
                        `AMO_OP_MIN : StoreData   = (($signed(op2)<$signed(LoadData)) ? op2 : LoadData);
                        `AMO_OP_MAX : StoreData   = (($signed(op2)<$signed(LoadData)) ? LoadData : op2);
                        `AMO_OP_MINU: StoreData   = ((       (op2)<       (LoadData)) ? op2 : LoadData);
                        `AMO_OP_MAXU: StoreData   = ((       (op2)<       (LoadData)) ? LoadData : op2);
                        default     : StoreData   = 0;
                    endcase
                end
                else
                    StoreData = 0;
                if(LSUrespIn[`LSU_RESP_DONE]) begin
                    //Atomic Store Completed
                    Completed   = 1'b1;
                    AMO_State_d = 0;
                    if(LSUrespIn[`LSU_RESP_EXCEPTION]) begin
                        //Exception in Store => Send Vaddr as MetaData
                        Exception = 1'b1;
                        MetaData  = Vaddr[`METADATA_LEN-1:0];
                    end
                    else begin
                        Exception = 1'b0;
                        MetaData                     = 0;
                        MetaData[`METADATA_STORE_ID] = 1'b1;
                        MetaData[`SB_DEPTH_LEN-1:0]  = LSUresp_Data[`SB_DEPTH_LEN-1:0];
                        ResultData = LoadData;
                    end
                end
            end
        end
    end
end

assign Ready = ((Port_Valid ? Completed : 1'b1) & LSUrespIn[`LSU_RESP_READY]) | Killed | Flush;


///////////////////////////////////////////////////////////////////////////////

assign LSUreqOut[`LSU_REQ_VALID]        = LSUreq_Valid;
assign LSUreqOut[`LSU_REQ_KILLED]       = Killed | Flush;
assign LSUreqOut[`LSU_REQ_OPER]         = LSUreq_Oper;
assign LSUreqOut[`LSU_REQ_DATA_TYPE]    = DataType;
assign LSUreqOut[`LSU_REQ_KILLMASK]     = Port_S2E[`PORT_S2E_KILLMASK];
assign LSUreqOut[`LSU_REQ_ORDERTAG]     = Controls[`UOP_MEM_LSORDERTAG];
assign LSUreqOut[`LSU_REQ_VADDR]        = Vaddr;
assign LSUreqOut[`LSU_REQ_ST_DATA]      = StoreData;
assign LSUreqOut[`LSU_REQ_AMO_DATA]     = AmoData;


///////////////////////////////////////////////////////////////////////////////
always @* begin
    if(rst | Flush | Killed) begin
        WakeupResp = 0;
        ResultBus  = 0;
    end
    else if(Port_Valid & Completed) begin
        //if Input valid, Response Valid
        //if exception set mtval accordingly
        WakeupResp[`WAKEUP_RESP_VALID]      = 1'b1;
        WakeupResp[`WAKEUP_RESP_PRD_TYPE]   = Port_S2E[`PORT_S2E_PRD_TYPE];
        WakeupResp[`WAKEUP_RESP_PRD]        = Port_S2E[`PORT_S2E_PRD];
        WakeupResp[`WAKEUP_RESP_REG_WE]     = Port_S2E[`PORT_S2E_REG_WE];
        WakeupResp[`WAKEUP_RESP_ROB_INDEX]  = Port_S2E[`PORT_S2E_ROB_INDEX];
        WakeupResp[`WAKEUP_RESP_EXCEPTION]  = Exception;
        WakeupResp[`WAKEUP_RESP_ECAUSE]     = ECause;
        WakeupResp[`WAKEUP_RESP_METADATA]   = MetaData;

        ResultBus[`RESULT_VALID]            = 1'b1;
        ResultBus[`RESULT_REG_WE]           = Port_S2E[`PORT_S2E_REG_WE];
        ResultBus[`RESULT_PRD_TYPE]         = Port_S2E[`PORT_S2E_PRD_TYPE];
        ResultBus[`RESULT_PRD]              = Port_S2E[`PORT_S2E_PRD];
        ResultBus[`RESULT_VALUE]            = ResultData;
    end
    else begin
        WakeupResp = 0;
        ResultBus  = 0;
    end
end

`ifdef DEBUG
    `ifdef DEBUG_CONF
        `include "debug_conf.v"
    `endif
    integer Di;
    `ifdef DEBUG_FU_RESULT
        always @(negedge clk) begin
            if(Killed & Port_Valid) begin
                $display("[%t] RESULT@FUST#: PC=%h ROB=%d | Killed",$time,
                    Port_S2E[`PORT_S2E_PC], Port_S2E[`PORT_S2E_ROB_INDEX]);
            end
            else if(Port_Valid & Completed) begin
                $display("[%t] RESULT@FUST#: PC=%h ROB=%d |%b %s->p%0d=%h | Vaddr=%h SBidx=%0d %c OT=%0d | op1=%h op2=%h",$time,
                    Port_S2E[`PORT_S2E_PC], Port_S2E[`PORT_S2E_ROB_INDEX],
                    Port_S2E[`PORT_S2E_REG_WE], (Port_S2E[`PORT_S2E_REG_WE] ? PrintReg(Dispatch_Unit.ROB.ROB[Port_S2E[`PORT_S2E_ROB_INDEX]][`ROB_UOP_RD],Port_S2E[`PORT_S2E_PRD_TYPE]) : "MEM"),
                        Port_S2E[`PORT_S2E_PRD], (Port_S2E[`PORT_S2E_REG_WE] ? ResultData : Port_S2E[`PORT_S2E_OP2]),
                    Vaddr, MetaData[`SB_DEPTH_LEN-1:0], DT2C(DataType), OrderTag,
                    Port_S2E[`PORT_S2E_OP1], Port_S2E[`PORT_S2E_OP2]);
            end
        end
    `endif
`endif


endmodule

