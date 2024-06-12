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
    module axi_master_interface_dcache #
    (

        // Base address of targeted slave
        parameter  C_M_TARGET_SLAVE_BASE_ADDR   = 64'h0,
        // Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
        parameter integer C_M_AXI_BURST_LEN = 4,

        // Width of Address Bus
        parameter integer C_M_AXI_ADDR_WIDTH    = 64,
        // Width of Data Bus
        parameter integer C_M_AXI_DATA_WIDTH    = 64
    )
    (
        output wire mem_done,
        input  wire burst_type, // 1-> write to memory, 0-> read from memory
        input  wire [63:0]axi_address,
        input  wire [255:0]axi_data_write, //cache line to be read/written
        output reg [63:0]data_read,
        input  wire start_burst,                               // Start read transaction
 //     output wire [63 : 0] data_read,                       // data read from slave
        output reg [7 : 0] read_index,                        // data read index
        output wire read_resp_error,                          // flag any read response error
        output wire write_resp_error,
        output wire cache_beat,                               // when valid data comes during cache replacement
        input  wire [2:0]burst_len,
        input  wire [2:0]data_type,

        input  wire  M_AXI_ACLK,                               // Global Clock Signal.
        input  wire  M_AXI_ARESETN,                            // Global Reset Singal. This Signal is Active Low

        // --------------------------------------Write address channel signals-----------------------------------------------//
        output wire [3 : 0] M_AXI_AWID,                       // Master Interface Write Address ID
        output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_AWADDR,  // Master Interface Write Address
        output wire [7 : 0] M_AXI_AWLEN,                      // Burst length
        output wire [2 : 0] M_AXI_AWSIZE,                     // Burst size. This signal indicates the size of each transfer in the burst
        output wire [1 : 0] M_AXI_AWBURST,                    // Burst type
        output wire  M_AXI_AWLOCK,                            // Lock type
        output wire [3 : 0] M_AXI_AWCACHE,                    // Memory type
        output wire [2 : 0] M_AXI_AWPROT,                     // Protection type. This signal indicates the privilege and security level of the transaction, and whether the transaction is a data access or an instruction access
        output wire [3 : 0] M_AXI_AWQOS,                      // Quality of Service, QoS identifier sent for each write transaction.

        output wire  M_AXI_AWVALID,                           // Write address valid
        input  wire  M_AXI_AWREADY,                            // Write address ready

        // --------------------------------------Write data channel signals-----------------------------------------------//
        output wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_WDATA,   // Master Interface Write Data.
        output wire [C_M_AXI_DATA_WIDTH/8-1 : 0] M_AXI_WSTRB, // Write strobes. This signal indicates which byte lanes hold valid data. There is one write strobe bit for each eight bits of the write data bus
        output wire  M_AXI_WLAST,                             // Write last indicates the last transfer in a write burst.

        output wire  M_AXI_WVALID,                            // Write valid
        input  wire  M_AXI_WREADY,                             // Write ready indicates that the slave can accept the write data.

        // --------------------------------------Write response  channel signals-----------------------------------------------//
        input  wire [3 : 0] M_AXI_BID,
        input  wire [1 : 0] M_AXI_BRESP,                       // Write response

        input  wire  M_AXI_BVALID,                             // Write response valid
        output wire  M_AXI_BREADY,                            // Response ready indicates that the master can accept a write response.

        // --------------------------------------Read address channel signals-----------------------------------------------//
        output wire [3 : 0] M_AXI_ARID,
        output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_ARADDR,  // Read address indicates the initial address of a read burst transaction.
        output wire [7 : 0] M_AXI_ARLEN,                      // Burst length
        output wire [2 : 0] M_AXI_ARSIZE,                     // Burst size
        output wire [1 : 0] M_AXI_ARBURST,                    // Burst type
        output wire  M_AXI_ARLOCK,
        output wire [3 : 0] M_AXI_ARCACHE,
        output wire [2 : 0] M_AXI_ARPROT,
        output wire [3 : 0] M_AXI_ARQOS,

        output wire  M_AXI_ARVALID,
        input  wire  M_AXI_ARREADY,

        // --------------------------------------Read data channel signals-----------------------------------------------//
        input  wire [3 : 0] M_AXI_RID,
        input  wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_RDATA,
        input  wire [1 : 0] M_AXI_RRESP,
        input  wire  M_AXI_RLAST,

        input  wire  M_AXI_RVALID,
        output wire  M_AXI_RREADY
    );







    reg     axi_awvalid;
    reg [C_M_AXI_DATA_WIDTH-1 : 0]  axi_wdata;
    reg     axi_wlast;
    reg     axi_wvalid;
    reg     axi_bready;
    reg     axi_arvalid;
    reg     axi_rready;
    reg    [7:0]write_index;
    reg     burst_type_reg;
    wire    [7:0]burst_length = {5'b0, burst_len};
    reg    [C_M_AXI_DATA_WIDTH/8-1 : 0]my_strobe;
    reg     [2:0] my_awsize;

    wire [63:0]axi_write_address;
    wire [63:0]axi_read_data;

    always @(*) begin
    if (burst_length == 0) begin
        case(data_type)
                    `DATA_TYPE_B: my_awsize=3'b000;
                    `DATA_TYPE_H: my_awsize=3'b001;
                    `DATA_TYPE_W: my_awsize=3'b010;
                    `DATA_TYPE_D: my_awsize=3'b011;
                    default: my_awsize=3'b011;
        endcase
     end
     else

        my_awsize = 3'b011;

    end
/////////////////////////////////////////////////////////////////////////////////////////////////
    always @(*) begin
    if (burst_length == 0) begin
        case(data_type)
                    `DATA_TYPE_B: my_strobe=(8'b0000_0001)<<axi_address[2:0];
                    `DATA_TYPE_H: my_strobe=(8'b0000_0011)<<{axi_address[2:1],1'b0};
                    `DATA_TYPE_W: my_strobe=(8'b0000_1111)<<{axi_address[2],2'b00};
                    `DATA_TYPE_D: my_strobe=8'b1111_1111;
                    default: my_strobe=8'b11111111;
        endcase
     end
     else

        my_strobe = 8'b11111111;

    end

    always @(*) begin
        if (burst_length == 0) begin
            data_read = 0;
            case(data_type)
                `DATA_TYPE_B,`DATA_TYPE_BU: data_read[7:0]  = axi_read_data>>{axi_address[2:0],3'b000};
                `DATA_TYPE_H,`DATA_TYPE_HU: data_read[15:0] = axi_read_data>>{axi_address[2:1],4'b0000};
                `DATA_TYPE_W,`DATA_TYPE_WU: data_read[31:0] = axi_read_data>>{axi_address[2],  5'b0000};
                `DATA_TYPE_D:               data_read       = axi_read_data;
                default:                    data_read       = 0;
            endcase
        end
        else begin
            data_read = axi_read_data;
        end
   end

//    assign axi_write_address = burst_length == 0 ? {axi_address[63:3],3'b000} : axi_address;
    assign M_AXI_AWID   = 4'd1;
    //The AXI address is a concatenation of the target base address + active offset range
    assign M_AXI_AWADDR = C_M_TARGET_SLAVE_BASE_ADDR + axi_address;
    assign M_AXI_AWLEN  = burst_length;
    assign M_AXI_AWSIZE = my_awsize;
    //INCR burst type is usually used, except for keyhole bursts (as our burst size is 8 bytes (64 bits) increament will be addr + 8 in each transfer)
    assign M_AXI_AWBURST    = 2'b01;
    assign M_AXI_AWLOCK = 1'b0;
    assign M_AXI_AWCACHE    = 4'b0000; ///////????????????????????CONFIRM ONCE???????????????????????????????/////////
    assign M_AXI_AWPROT = 3'b100; // 1 is for instruction access
    assign M_AXI_AWQOS  = 4'h0;
    //assign M_AXI_AWUSER   = 'b1; ??????????CHECK IF USER SIGNAL NEEDS TO BE USED
    assign M_AXI_AWVALID    = axi_awvalid;
    assign M_AXI_WDATA  = axi_wdata;
    assign M_AXI_WSTRB  = my_strobe;
    assign M_AXI_WLAST  = axi_wlast;
    //assign M_AXI_WUSER    = 'b0;
    assign M_AXI_WVALID = axi_wvalid;
    assign M_AXI_BREADY = axi_bready;
    assign M_AXI_ARID   = 4'd1;
    assign M_AXI_ARADDR = C_M_TARGET_SLAVE_BASE_ADDR + axi_address;
    assign M_AXI_ARLEN  = burst_length;
    assign M_AXI_ARSIZE = my_awsize; //$clogb2((C_M_AXI_DATA_WIDTH/8)-1); see burst size encoding table
    assign M_AXI_ARBURST    = 2'b01;
    assign M_AXI_ARLOCK = 1'b0;
    assign M_AXI_ARCACHE    = 4'b0000;///////????????????????????CONFIRM ONCE???????????????????????????????/////////
    assign M_AXI_ARPROT = 3'h0;
    assign M_AXI_ARQOS  = 4'h0;
    //assign M_AXI_ARUSER   = 'b1;
    assign M_AXI_ARVALID    = axi_arvalid;
    assign M_AXI_RREADY = axi_rready;
    assign axi_read_data = M_AXI_RDATA;





    //--------------------
    //Write Address Channel
    //--------------------

    // The purpose of the write address channel is to request the address and
    // command information for the entire transaction.  It is a single beat
    // of information.

    // The AXI4 Write address channel in this example will continue to initiate
    // write commands as fast as it is allowed by the slave/interconnect.
    // The address will be incremented on each accepted address transaction,
    // by burst_size_byte to point to the next address.


    always @(posedge M_AXI_ACLK)
      begin

        if (M_AXI_ARESETN == 0 )
          begin
            axi_awvalid <= 1'b0;
          end
        // If previously not valid and start_burst signal comes from icache, start the transaction
        else if (~axi_awvalid && (burst_type & start_burst))
          begin
            axi_awvalid <= 1'b1;
          end
        else if (M_AXI_AWREADY && axi_awvalid)  //ARVALID must remain asserted until the rising clock edge after the slave asserts the ARREADY signal.
          begin
            axi_awvalid <= 1'b0;
          end
        else
          axi_awvalid <= axi_awvalid;
     end


    //--------------------
    //Write Data Channel
    //--------------------

    //The write data will continually try to push write data across the interface.

    //The amount of data accepted will depend on the AXI slave and the AXI
    //Interconnect settings, such as if there are FIFOs enabled in interconnect.

    //Note that there is no explicit timing relationship to the write address channel.
    //The write channel has its own throttling flag, separate from the AW channel.

    //Synchronization between the channels must be determined by the user.

    //The simpliest but lowest performance would be to only issue one address write
    //and write data burst at a time.

    //In this example they are kept in sync by using the same address increment
    //and burst sizes. Then the AW and W channels have their transactions measured
    //with threshold counters as part of the user logic, to make sure neither
    //channel gets too far ahead of each other.

    //Forward movement occurs when the write channel is valid and ready

        // Burst length counter. This signal will be sent to icache to latch the data
      always @(posedge M_AXI_ACLK)
      begin
        if (M_AXI_ARESETN == 0 || (burst_type & start_burst))
          begin
            write_index <= 0;
          end
        else begin
           if (axi_wvalid && M_AXI_WREADY && (write_index != burst_length))      //valid and ready, means we can latch this data
               write_index <= write_index + 1;
           else
               write_index <= write_index;
             end
      end


    // WVALID logic, similar to the axi_awvalid always block above
      always @(posedge M_AXI_ACLK)
      begin
        if (M_AXI_ARESETN == 0)
          begin
            axi_wvalid <= 1'b0;
          end
        // If previously not valid, start next transaction
        else if (~axi_wvalid && (burst_type & start_burst))
          begin
            axi_wvalid <= 1'b1;
          end
        /* If WREADY and too many writes, throttle WVALID
        Once asserted, VALIDs cannot be deasserted, so WVALID
        must wait until burst is complete with WLAST */
        else if (axi_wvalid && M_AXI_WREADY && axi_wlast)
          axi_wvalid <= 1'b0;
        else
          axi_wvalid <= axi_wvalid;
      end


    //WLAST generation on the MSB of a counter underflow
    // WVALID logic, similar to the axi_awvalid always block above
      always @(posedge M_AXI_ACLK)
      begin
        if (M_AXI_ARESETN == 0 || (burst_type & start_burst) )
          begin
            axi_wlast <= 1'b0;
          end
        // axi_wlast is asserted when the write index
        // count reaches the penultimate count to synchronize
        // with the last write data when write_index is b1111
        // else if (&(write_index[C_TRANSACTIONS_NUM-1:1])&& ~write_index[0] && wnext)
        else if (((write_index == burst_length-1 && burst_length >= 1) && axi_wvalid && M_AXI_WREADY) || (burst_length== 0 ))
          begin
            axi_wlast <= 1'b1;
          end
        // Deassrt axi_wlast when the last write data has been
        // accepted by the slave with a valid response
        else if (axi_wvalid && M_AXI_WREADY)
          axi_wlast <= 1'b0;
        else if (axi_wlast && burst_length== 0)
          axi_wlast <= 1'b0;
        else
          axi_wlast <= axi_wlast;
      end


    /* Burst length counter. Uses extra counter register bit to indicate terminal
     count to reduce decode logic */
      always @(posedge M_AXI_ACLK)
      begin
        if (M_AXI_ARESETN == 0 || (burst_type & start_burst))
          begin
            write_index <= 0;
          end
        else if (axi_wvalid && M_AXI_WREADY && (write_index != burst_length))
          begin
            write_index <= write_index + 1;
          end
        else
          write_index <= write_index;
      end


    /* Write Data Generator
     Data pattern is only a simple incrementing count from 0 for each burst  */
//    always @(posedge M_AXI_ACLK)
//    begin
//      if (M_AXI_ARESETN == 0 )
//         axi_wdata <= 0;
//      else if (burst_type & start_burst)
//        axi_wdata <= axi_data_write[63:0];
//      //else if (wnext && axi_wlast)
//      //  axi_wdata <= 'b0;
//      else if (axi_wvalid && M_AXI_WREADY) begin
//        case (write_index)
//             7'd0: axi_wdata = axi_data_write[127:64];
//             7'd1: axi_wdata = axi_data_write[191:128];
//             7'd2: axi_wdata = axi_data_write[255:192];
//             7'd3: axi_wdata = axi_data_write[255:192];
//             default: axi_wdata = axi_wdata;
//      endcase
//      end
//      else
//        axi_wdata <= axi_wdata;
//      end
      always @(*)
      begin
        
            if (burst_length==0) begin
                axi_wdata = 64'b0;
                case(data_type)
                `DATA_TYPE_B,`DATA_TYPE_BU: axi_wdata = {56'b0,axi_data_write[ 7:0]}<<{axi_address[2:0],3'b000};
                `DATA_TYPE_H,`DATA_TYPE_HU: axi_wdata = {48'b0,axi_data_write[15:0]}<<{axi_address[2:1],4'b0000};
                `DATA_TYPE_W,`DATA_TYPE_WU: axi_wdata = {32'b0,axi_data_write[31:0]}<<{axi_address[2],  5'b0000};
                `DATA_TYPE_D:               axi_wdata = axi_data_write[63:0];
                default:                    axi_wdata = 0;
                endcase
            end
            else begin
            case (write_index)
                 8'd0: axi_wdata = axi_data_write[63:0];
                 8'd1: axi_wdata = axi_data_write[127:64];
                 8'd2: axi_wdata = axi_data_write[191:128];
                 8'd3: axi_wdata = axi_data_write[255:192];
                 default: axi_wdata = 0;
            endcase
          end
        end


    //----------------------------
    //Write Response (B) Channel
    //----------------------------

    //The write response channel provides feedback that the write has committed
    //to memory. BREADY will occur when all of the data and the write address
    //has arrived and been accepted by the slave.

    //The write issuance (number of outstanding write addresses) is started by
    //the Address Write transfer, and is completed by a BREADY/BRESP.

    //While negating BREADY will eventually throttle the AWREADY signal,
    //it is best not to throttle the whole data channel this way.

    //The BRESP bit [1] is used indicate any errors from the interconnect or
    //slave for the entire write burst. This example will capture the error
    //into the ERROR output.

      always @(posedge M_AXI_ACLK)
      begin
        if (M_AXI_ARESETN == 0 || (burst_type & start_burst) )
          begin
            axi_bready <= 1'b0;
          end
        // accept/acknowledge bresp with axi_bready by the master
        // when M_AXI_BVALID is asserted by slave
        else if (M_AXI_BVALID && ~axi_bready)
          begin
            axi_bready <= 1'b1;
          end
        // deassert after one clock cycle
        else if (axi_bready)
          begin
            axi_bready <= 1'b0;
          end
        // retain the previous value
        else
          axi_bready <= axi_bready;
      end


    //Flag any write response errors
      assign write_resp_error = axi_bready & M_AXI_BVALID & M_AXI_BRESP[1];




    //------------------------------------------------------------------------------------------------------------------------------------//
    //                                               Read Address Channel                                                                 //
    // The start address of the burst will be sent. The burst is INCR type.                                                               //
    //------------------------------------------------------------------------------------------------------------------------------------//


      always @(posedge M_AXI_ACLK)
      begin

        if (M_AXI_ARESETN == 0 )
          begin
            axi_arvalid <= 1'b0;
          end
        // If previously not valid and start_burst signal comes from icache, start the transaction
        else if (~axi_arvalid && (!burst_type & start_burst))
          begin
            axi_arvalid <= 1'b1;
          end
        else if (M_AXI_ARREADY && axi_arvalid)  //ARVALID must remain asserted until the rising clock edge after the slave asserts the ARREADY signal.
          begin
            axi_arvalid <= 1'b0;
          end
        else
          axi_arvalid <= axi_arvalid;
      end


    // Read address already assigned. Slave will latch it when it sees ARREADY AND ARVALID high.






    //------------------------------------------------------------------------------------------------------------------------------------//
    //                                               Read Data Channel                                                                    //
    // Data from slave is received and sent to icache unit.                                                                               //
    //------------------------------------------------------------------------------------------------------------------------------------//


    // Burst length counter. This signal will be sent to icache to latch the data
      always @(posedge M_AXI_ACLK)
      begin
        if (M_AXI_ARESETN == 0 || (!burst_type & start_burst))
          begin
            read_index <= 0;
          end
        else
           if (M_AXI_RVALID && axi_rready && (read_index != burst_length))      //valid and ready, means we can latch this data
               read_index <= read_index + 1;
           else
               read_index <= read_index;

      end

      assign cache_beat = burst_type_reg ?  M_AXI_WREADY & axi_wvalid : M_AXI_RVALID & axi_rready;
    /*
     The Read Data channel returns the results of the read request

     */
            always @(posedge M_AXI_ACLK)
      begin
        if (M_AXI_ARESETN == 0)
          begin
            axi_rready <= 1'b0;
          end
        else if (~axi_rready & M_AXI_RVALID)
          begin
            axi_rready <= 1'b1;
          end
        else if (M_AXI_RVALID && M_AXI_RLAST && axi_rready) // When last transfer
          begin
            axi_rready <= 1'b0;
          end
      end


    //Flag any read response errors
      assign read_resp_error = axi_rready & M_AXI_RVALID & M_AXI_RRESP[1];  //SLVERR and DECERR error

     //Last read completion
     //NOTE: we have to write in TLB as soon as we get the ready and valid high. We cannot latch data in the next clock pulse as ata becomes invalid.
     always @(posedge M_AXI_ACLK)
      begin
        if (M_AXI_ARESETN == 0)
            burst_type_reg <= 0;
        else if (start_burst)
            burst_type_reg <= burst_type;
      end

     assign mem_done = burst_type_reg ? (axi_wvalid && M_AXI_WREADY && (write_index == burst_length) && axi_wlast) : (M_AXI_RVALID && axi_rready && (read_index == burst_length) && M_AXI_RLAST);


endmodule
