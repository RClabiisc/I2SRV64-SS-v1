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
module DCache_Arbiter
#( 
    parameter   PORTS=2

  )
 (
    input wire      clk,
    input wire      rst,
    
    //--Dcache Read Port Signals--------
    input  wire                                 DCache_RdReq_Valid,
    input  wire [55:0]                          DCache_RdReq_Paddr,
    input  wire [`DATA_TYPE__LEN-1:0]           DCache_RdReq_DataType,
    input  wire                                 DCache_RdReq_Abort,
    output wire                                 DCache_RdResp_Done,
    output wire                                 DCache_RdResp_Ready,
    output wire [63:0]                          DCache_RdResp_Data,
    
    
    //---DCache Write Port Signals-------
    input  wire                                 DCache_WrReq_Valid,
    input  wire [`DATA_TYPE__LEN-1:0]           DCache_WrReq_DataType,
    input  wire [55:0]                          DCache_WrReq_Paddr,
    input  wire [63:0]                          DCache_WrReq_Data,
    output wire                                 DCache_WrResp_Done,
    output wire                                 DCache_WrResp_Ready,
    
    //ARBITER PORTS Signals--------------
    output wire                                 DCache_Req_Valid,
    output wire                                 DCache_Req_Type,  //Write or Read Indication 
    output wire [`DATA_TYPE__LEN-1:0]           DCache_Req_DataType,
    output wire [55:0]                          DCache_Req_Paddr,
    output wire [63:0]                          DCache_Req_Wrdata,
    output wire                                 DCache_Req_Rdabort,
    input  wire                                 DCache_Resp_Done,
    input  wire                                 DCache_Resp_Ready,
    input  wire [63:0]                          DCache_Resp_Rddata                   
    
    
  );
  
  
  reg [1:0]             req_pending;                        // Signal indicating a request is pending, Bit 0 --> Read Port Bit1--> Write Port
  reg                   Active_Req, Active_Req_d;           // Signal indicating which is the current active arbiter output 
  reg                   arbiter_busy,arbiter_busy_d;        // indicate that the arbiter is busy now-----------------
  reg                   last_valid, last_valid_d;           // register the last active port              
  
  always @(posedge clk)
  begin 
    if(rst) begin 
        req_pending<=0;
    end else begin  
        if(Active_Req==1 && DCache_Resp_Done) //checking whether the write port is the active and then done make invalid req
            req_pending[1]<=1'b0;             //write port checks
        else if(DCache_WrReq_Valid)
            req_pending[1]<=1'b1;
            
        if((Active_Req==0 && (DCache_Resp_Done ||DCache_RdReq_Abort ))|| (DCache_RdReq_Abort) ) //checking whether the read port is the active and then done make invalid req
            req_pending[0]<=1'b0;             // read port checks
        else if(DCache_RdReq_Valid)
            req_pending[0]<=1'b1;    
        
    end
  end   
  
  
  always @(*)begin 
    last_valid_d=last_valid;
    if(arbiter_busy)begin
       if(DCache_Resp_Done || (Active_Req==0 && DCache_RdReq_Abort)) begin //request completed or in case of read request aborted
            arbiter_busy_d=1'b0;
            Active_Req_d=Active_Req;
       end 
       else begin       // Request going on
            arbiter_busy_d=arbiter_busy;
            Active_Req_d = Active_Req;
       end
    end 
    else begin //no transaction is going on     
           arbiter_busy_d=1'b0;
           Active_Req_d = Active_Req;
           last_valid_d=last_valid;
           if(DCache_Resp_Ready) begin 
                case(req_pending)
                    2'b00:begin  // if both are not registered ready based on the priority given by last valid and input valid signals the decision is taken
                        if(last_valid)begin //if last arbitered is one then priority for read port is given
                            if(DCache_RdReq_Valid && !DCache_RdReq_Abort) begin
                               last_valid_d=1'b0;
                               Active_Req_d=1'b0;
                               arbiter_busy_d=1'b1;
                            end else if(DCache_WrReq_Valid) begin
                               last_valid_d=1'b1;
                               Active_Req_d=1'b1;
                               arbiter_busy_d=1'b1;
                            end else begin
                               last_valid_d=last_valid;
                               Active_Req_d=Active_Req;
                               arbiter_busy_d=1'b0;
                            end
                        end else begin  // if last arbitered is 0 then priority for write port is given
                            if(DCache_WrReq_Valid) begin
                               last_valid_d=1'b1;
                               Active_Req_d=1'b1;
                               arbiter_busy_d=1'b1;
                            end else if(DCache_RdReq_Valid && !DCache_RdReq_Abort) begin
                               last_valid_d=1'b0;
                               Active_Req_d=1'b0;
                               arbiter_busy_d=1'b1;
                            end else begin
                               last_valid_d=last_valid;
                               Active_Req_d=Active_Req;
                               arbiter_busy_d=1'b0;
                            end                                 
                         end   
                         end   
                    2'b01:begin    // already registered with one port hence go with that
                          if(!DCache_RdReq_Abort) begin 
                            last_valid_d=1'b0;
                            Active_Req_d=1'b0;
                            arbiter_busy_d=1'b1;
                          end
                          end
                    2'b10:begin // already registered
                          last_valid_d=1'b1;
                          Active_Req_d=1'b1;
                          arbiter_busy_d=1'b1;
                          end
                    2'b11:begin // both valid hence last arbited is checked for deciding the priority if last arbited is one then priority for read port or vice versa
                          if(last_valid && !DCache_RdReq_Abort)begin  
                            last_valid_d=1'b0;
                            Active_Req_d=1'b0;
                            arbiter_busy_d=1'b1;
                          end 
                          else begin
                            last_valid_d=1'b1;
                            Active_Req_d=1'b1;
                            arbiter_busy_d=1'b1;
                          end  
                          end
                   default:begin  
                         last_valid_d=last_valid;
                         Active_Req_d=Active_Req;
                         arbiter_busy_d=1'b0;                    
                         end   
                endcase
           end
    end 
  end 
  
  always @(posedge clk) // registering the signals or flipflops
  begin
    if(rst) begin
      Active_Req<=1'b0;
      last_valid<=1'b0;
      arbiter_busy<=1'b0;
    end else begin
      Active_Req<= Active_Req_d;
      last_valid<=last_valid_d;
      arbiter_busy<=arbiter_busy_d;
    end  
  end
  
  //Routing the signals to the arbiter output based on the signal Active_Req_d or Active_req
  //Active_req_d is used so that one clock cycle delay can be avoided in net path
  //Active_req_d wont change once once channels is selected in the arbiter output and it is valid
  //hence switching based on the active_req_d wont be an issue
  
  
  assign DCache_Req_Paddr= Active_Req_d ? DCache_WrReq_Paddr:DCache_RdReq_Paddr;
  
  assign DCache_Req_DataType= Active_Req_d ? DCache_WrReq_DataType: DCache_RdReq_DataType;
  
  assign DCache_Req_Rdabort = (arbiter_busy && (Active_Req==0)) ? DCache_RdReq_Abort:1'b0; 
  
  assign DCache_Req_Wrdata  = DCache_WrReq_Data;
  
  assign DCache_Req_Type    = Active_Req_d ? 1'b1 : 1'b0;  // 1==> write operation 0===> read operation // need to check whether Active_Req_d or Active_Req to be used
  
  assign DCache_Req_Valid   = (!rst &&( arbiter_busy)) ? 1'b1: 1'b0;
  
  assign DCache_RdResp_Ready = DCache_Resp_Ready;  // Ready Signals can be directly mapped......
  
  assign DCache_WrResp_Ready = DCache_Resp_Ready; // Ready Signal can be directly mapped.........
  
  assign DCache_RdResp_Data  = DCache_Resp_Rddata; // This will be used along with Done signal Mapping wont be an issue i guess
  
  assign DCache_RdResp_Done  = Active_Req? 1'b0: DCache_Resp_Done; //if an active request is going on then mapped to Dcache_Resp_Done ( in read port Active_Req==>0)
  
  assign DCache_WrResp_Done  = Active_Req?  DCache_Resp_Done:1'b0; // if an acive request is going on write port then mapped to DCache_resp_done signal                                                                                    
  
  
//  reg  DCache_Resp_Ready_reg;
//  reg  DCache_Resp_Done_reg;
//  reg  [63:0] DCache_Resp_Rddata_Reg;
  
//  always @(posedge clk)
//  begin 
//  if(rst) begin
//    DCache_Resp_Ready_reg<=1'b0;
//    DCache_Resp_Done_reg<=1'b0;
//    DCache_Resp_Rddata_Reg<=0;
//  end else begin
//    DCache_Resp_Ready_reg<=DCache_Resp_Ready;
//    DCache_Resp_Done_reg<=DCache_Resp_Done;
//    DCache_Resp_Rddata_Reg<=DCache_Resp_Rddata;
//  end 
  
//  end
  
  
endmodule
