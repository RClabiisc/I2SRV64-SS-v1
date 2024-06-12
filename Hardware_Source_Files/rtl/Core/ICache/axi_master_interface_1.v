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

    (* keep_hierarchy = "yes" *)
    module axi_master_interface_1 #
    (

        // Base address of targeted slave
        parameter  C_M_TARGET_SLAVE_BASE_ADDR   = 64'h0,
        // Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
        //parameter integer C_M_AXI_BURST_LEN   = 4,

        // Width of Address Bus
        parameter integer C_M_AXI_ADDR_WIDTH    = 64,
        // Width of Data Bus
        parameter integer C_M_AXI_DATA_WIDTH    = 64
    )
    (
        input wire start_burst,                               // Start read transaction
        input wire  [7 : 0] burst_len,                        // burst len  (= 4 for icache) (= 1 for itlb)
        input wire [63 : 0] read_address,                     // physical address in case of cache miss , virtual address in case of tlb miss
        output wire [63 : 0] data_read,                       // data read from slave
        output reg [7 : 0] read_index,                        // data read index
        output wire  mem_done,                                 // transaction complete
        output wire read_resp_error,                          // flag any read response error
        output wire cache_beat,                               // when valid data comes during cache replacement


        input wire  M_AXI_ACLK,                               // Global Clock Signal.
        input wire  M_AXI_ARESETN,                            // Global Reset Singal. This Signal is Active Low

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
        input wire  M_AXI_AWREADY,                            // Write address ready

        // --------------------------------------Write data channel signals-----------------------------------------------//
        output wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_WDATA,   // Master Interface Write Data.
        output wire [C_M_AXI_DATA_WIDTH/8-1 : 0] M_AXI_WSTRB, // Write strobes. This signal indicates which byte lanes hold valid data. There is one write strobe bit for each eight bits of the write data bus
        output wire  M_AXI_WLAST,                             // Write last indicates the last transfer in a write burst.

        output wire  M_AXI_WVALID,                            // Write valid
        input wire  M_AXI_WREADY,                             // Write ready indicates that the slave can accept the write data.

        // --------------------------------------Write response  channel signals-----------------------------------------------//
        input wire [3 : 0] M_AXI_BID,
        input wire [1 : 0] M_AXI_BRESP,                       // Write response

        input wire  M_AXI_BVALID,                             // Write response valid
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
        input wire  M_AXI_ARREADY,

        // --------------------------------------Read data channel signals-----------------------------------------------//
        input wire [3 : 0] M_AXI_RID,
        input wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_RDATA,
        input wire [1 : 0] M_AXI_RRESP,
        input wire  M_AXI_RLAST,

        input wire  M_AXI_RVALID,
        output wire  M_AXI_RREADY
    );







    reg     axi_awvalid;
    reg [C_M_AXI_DATA_WIDTH-1 : 0]  axi_wdata;
    reg     axi_wlast;
    reg     axi_wvalid;
    reg     axi_bready;
    reg     axi_arvalid;
    reg     axi_rready;
    wire  write_resp_error;







    assign M_AXI_AWID   = 4'b0;
    //The AXI address is a concatenation of the target base address + active offset range
    assign M_AXI_AWADDR = C_M_TARGET_SLAVE_BASE_ADDR;
    assign M_AXI_AWLEN  = burst_len;
    assign M_AXI_AWSIZE = $clog2((C_M_AXI_DATA_WIDTH/8)-1);
    //INCR burst type is usually used, except for keyhole bursts (as our burst size is 8 bytes (64 bits) increament will be addr + 8 in each transfer)
    assign M_AXI_AWBURST    = 2'b01;
    assign M_AXI_AWLOCK = 1'b0;
    assign M_AXI_AWCACHE    = 4'b0000; ///////????????????????????CONFIRM ONCE???????????????????????????????/////////
    assign M_AXI_AWPROT = 3'b100; // 1 is for instruction access
    assign M_AXI_AWQOS  = 4'h0;
    //assign M_AXI_AWUSER   = 'b1; ??????????CHECK IF USER SIGNAL NEEDS TO BE USED
    assign M_AXI_AWVALID    = axi_awvalid;
    assign M_AXI_WDATA  = axi_wdata;
    assign M_AXI_WSTRB  = {(C_M_AXI_DATA_WIDTH/8){1'b1}}; //All bursts are complete and aligned
    assign M_AXI_WLAST  = axi_wlast;
    //assign M_AXI_WUSER    = 'b0;
    assign M_AXI_WVALID = axi_wvalid;
    assign M_AXI_BREADY = axi_bready;
    assign M_AXI_ARID   = 4'b0;
    assign M_AXI_ARADDR = C_M_TARGET_SLAVE_BASE_ADDR + read_address;
    assign M_AXI_ARLEN  = burst_len;
    assign M_AXI_ARSIZE = 3'b011; //$clogb2((C_M_AXI_DATA_WIDTH/8)-1); see burst size encoding table
    assign M_AXI_ARBURST    = 2'b01;
    assign M_AXI_ARLOCK = 1'b0;
    assign M_AXI_ARCACHE    = 4'b0000;///////????????????????????CONFIRM ONCE???????????????????????????????/////////
    assign M_AXI_ARPROT = 3'h0;
    assign M_AXI_ARQOS  = 4'h0;
    //assign M_AXI_ARUSER   = 'b1;
    assign M_AXI_ARVALID    = axi_arvalid;
    assign M_AXI_RREADY = axi_rready;
    assign data_read = M_AXI_RDATA;




    //------------------------------------------------------------------------------------------------------------------------------------//
    //                                               Write Address Channel                                                                //
    // In case of icache, writes to memory are not required hence we assert all signals 0                                                 //
    //------------------------------------------------------------------------------------------------------------------------------------//


      always @(posedge M_AXI_ACLK)
      begin

        if (M_AXI_ARESETN == 0)
          begin
            axi_awvalid <= 1'b0;
          end
      end





    //------------------------------------------------------------------------------------------------------------------------------------//
    //                                               Write Data Channel                                                                //
    // In case of icache, writes to memory are not required hence we assert all signals 0                                                 //
    //------------------------------------------------------------------------------------------------------------------------------------//




      always @(posedge M_AXI_ACLK)
      begin
        if (M_AXI_ARESETN == 0)
          begin
            axi_wvalid <= 1'b0;
            axi_wlast <= 1'b0;
          end

      end



      always @(posedge M_AXI_ACLK)
      begin
        if (M_AXI_ARESETN == 0)
          axi_wdata <= 'b0;
      end


    //------------------------------------------------------------------------------------------------------------------------------------//
    //                                               Write response Channel                                                                //
    // In case of icache, writes to memory are not required hence we assert all signals 0                                                 //
    //------------------------------------------------------------------------------------------------------------------------------------//



      always @(posedge M_AXI_ACLK)
      begin
        if (M_AXI_ARESETN == 0)
          begin
            axi_bready <= 1'b0;
          end
      end


    //Flag any write response errors
      assign write_resp_error = axi_bready & M_AXI_BVALID & M_AXI_BRESP[1];  //SLVERR and DECERR erros


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
        else if (~axi_arvalid && start_burst)
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
        if (M_AXI_ARESETN == 0 || start_burst)
          begin
            read_index <= 0;
          end
        else
           if (burst_len ==0) //TLB case
             begin
               if (M_AXI_RVALID && axi_rready)
                 read_index <= 1;
               else
                 read_index <= read_index;
             end
           else               //icache case when burst len = 4
             begin
               if (M_AXI_RVALID && axi_rready && (read_index != (burst_len)))      //valid and ready, means we can latch this data
                   read_index <= read_index + 1;
               else
                 read_index <= read_index;
             end
      end

      assign cache_beat = M_AXI_RVALID && axi_rready;
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
     assign mem_done = (burst_len ==0) ? (M_AXI_RVALID && M_AXI_RLAST && axi_rready) : (M_AXI_RVALID && axi_rready && (read_index == (burst_len)) && M_AXI_RLAST);

endmodule
