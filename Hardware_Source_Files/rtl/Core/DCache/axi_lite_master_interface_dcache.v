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
`timescale 1 ns / 1 ps

    (* keep_hierarchy = "yes" *)
    module axi_lite_master_interface_dcache
    #
    (
        // Users to add parameters here

        // User parameters ends
        // Do not modify the parameters beyond this line

        // The master will start generating data from the C_M_START_DATA_VALUE value
        parameter  C_M_START_DATA_VALUE = 64'h00000000,
        // The master requires a target slave base address.
        // The master will initiate read and write transactions on the slave with base address specified here as a parameter.
        parameter  C_M_TARGET_SLAVE_BASE_ADDR   = 64'h00000000,
        // Width of M_AXI address bus.
        // The master generates the read and write addresses of width specified as C_M_AXI_ADDR_WIDTH.
        parameter integer C_M_AXI_ADDR_WIDTH    = 64,
        // Width of M_AXI data bus.
        // The master issues write data and accept read data where the width of the data bus is C_M_AXI_DATA_WIDTH
        parameter integer C_M_AXI_DATA_WIDTH    = 32
    )
    (
        // Users to add ports here
        output wire mem_done,
        input  wire burst_type, // 1-> write to memory, 0-> read from memory
        input  wire [31:0]axi_address_read,
        input  wire [31:0]axi_address_write,
        input  wire [31:0]axi_data_write, //cache line to be read/written
        output wire [31:0]data_read,
        input  wire start_burst,                               // Start read transaction
 //     output wire [63 : 0] data_read,                       // data read from slave
        output wire read_resp_error,                          // flag any read response error
        output wire write_resp_error,

        // User ports ends
        // Do not modify the ports beyond this line


        input wire  M_AXI_ACLK,
        // AXI active low reset signal
        input wire  M_AXI_ARESETN,
        // Master Interface Write Address Channel ports. Write address (issued by master)
        output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_AWADDR,
        // Write channel Protection type.
    // This signal indicates the privilege and security level of the transaction,
    // and whether the transaction is a data access or an instruction access.
        output wire [2 : 0] M_AXI_AWPROT,
        // Write address valid.
    // This signal indicates that the master signaling valid write address and control information.
        output wire  M_AXI_AWVALID,
        // Write address ready.
    // This signal indicates that the slave is ready to accept an address and associated control signals.
        input wire  M_AXI_AWREADY,
        // Master Interface Write Data Channel ports. Write data (issued by master)
        output wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_WDATA,
        // Write strobes.
    // This signal indicates which byte lanes hold valid data.
    // There is one write strobe bit for each eight bits of the write data bus.
        output wire [C_M_AXI_DATA_WIDTH/8-1 : 0] M_AXI_WSTRB,
        // Write valid. This signal indicates that valid write data and strobes are available.
        output wire  M_AXI_WVALID,
        // Write ready. This signal indicates that the slave can accept the write data.
        input wire  M_AXI_WREADY,
        // Master Interface Write Response Channel ports.
    // This signal indicates the status of the write transaction.
        input wire [1 : 0] M_AXI_BRESP,
        // Write response valid.
    // This signal indicates that the channel is signaling a valid write response
        input wire  M_AXI_BVALID,
        // Response ready. This signal indicates that the master can accept a write response.
        output wire  M_AXI_BREADY,
        // Master Interface Read Address Channel ports. Read address (issued by master)
        output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_ARADDR,
        // Protection type.
    // This signal indicates the privilege and security level of the transaction,
    // and whether the transaction is a data access or an instruction access.
        output wire [2 : 0] M_AXI_ARPROT,
        // Read address valid.
    // This signal indicates that the channel is signaling valid read address and control information.
        output wire  M_AXI_ARVALID,
        // Read address ready.
    // This signal indicates that the slave is ready to accept an address and associated control signals.
        input wire  M_AXI_ARREADY,
        // Master Interface Read Data Channel ports. Read data (issued by slave)
        input wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_RDATA,
        // Read response. This signal indicates the status of the read transfer.
        input wire [1 : 0] M_AXI_RRESP,
        // Read valid. This signal indicates that the channel is signaling the required read data.
        input wire  M_AXI_RVALID,
        // Read ready. This signal indicates that the master can accept the read data and response information.
        output wire  M_AXI_RREADY
    );

    // function called clogb2 that returns an integer which has the
    // value of the ceiling of the log base 2

     function integer clogb2 (input integer bit_depth);
         begin
         for(clogb2=0; bit_depth>0; clogb2=clogb2+1)
             bit_depth = bit_depth >> 1;
         end
     endfunction


    // AXI4LITE signals
    //write address valid
    reg     axi_awvalid;
    //write data valid
    reg     axi_wvalid;
    //read address valid
    reg     axi_arvalid;
    //read data acceptance
    reg     axi_rready;
    //write response acceptance
    reg     axi_bready;
    //write address
    reg [C_M_AXI_DATA_WIDTH-1 : 0]  axi_wdata;

    //A pulse to initiate a write transaction
    //index counter to track the number of write transaction issued
    //reg [TRANS_NUM_BITS : 0]  write_index;
    //index counter to track the number of read transaction issued
    //reg [TRANS_NUM_BITS : 0]  read_index;
    //Expected read data used to compare with the read data.
    reg burst_type_reg;


    // I/O Connections assignments

    //Adding the offset address to the base addr of the slave
    assign M_AXI_AWADDR = C_M_TARGET_SLAVE_BASE_ADDR + axi_address_write;
    //AXI 4 write data
    assign M_AXI_WDATA  = axi_data_write;
    assign M_AXI_AWPROT = 3'b000;
    assign M_AXI_AWVALID    = axi_awvalid;
    //Write Data(W)
    assign M_AXI_WVALID = axi_wvalid;
    //Set all byte strobes in this example
    assign M_AXI_WSTRB  = 4'b1111;
    //Write Response (B)
    assign M_AXI_BREADY = axi_bready;
    //Read Address (AR)
    assign M_AXI_ARADDR = C_M_TARGET_SLAVE_BASE_ADDR + axi_address_read;
    assign M_AXI_ARVALID    = axi_arvalid;
    assign M_AXI_ARPROT = 3'b001;
    //Read and Read Response (R)
    assign M_AXI_RREADY = axi_rready;
    assign data_read = M_AXI_RDATA;




    //--------------------
    //Write Address Channel
    //--------------------

    // The purpose of the write address channel is to request the address and
    // command information for the entire transaction.  It is a single beat
    // of information.

    // Note for this example the axi_awvalid/axi_wvalid are asserted at the same
    // time, and then each is deasserted independent from each other.
    // This is a lower-performance, but simplier control scheme.

    // AXI VALID signals must be held active until accepted by the partner.

    // A data transfer is accepted by the slave when a master has
    // VALID data and the slave acknoledges it is also READY. While the master
    // is allowed to generated multiple, back-to-back requests by not
    // deasserting VALID, this design will add rest cycle for
    // simplicity.

    // Since only one outstanding transaction is issued by the user design,
    // there will not be a collision between a new request and an accepted
    // request on the same clock cycle.

      always @(posedge M_AXI_ACLK)
      begin
        //Only VALID signals must be deasserted during reset per AXI spec
        //Consider inverting then registering active-low reset for higher fmax
        if (M_AXI_ARESETN == 0)
          begin
            axi_awvalid <= 1'b0;
          end
          //Signal a new address/data command is available by user logic
        else
          begin
            if ((burst_type & start_burst))
              begin
                axi_awvalid <= 1'b1;
              end
         //Address accepted by interconnect/slave (issue of M_AXI_AWREADY by slave)
            else if (M_AXI_AWREADY && axi_awvalid)
              begin
                axi_awvalid <= 1'b0;
              end
          end
      end



    //--------------------
    //Write Data Channel
    //--------------------

    //The write data channel is for transfering the actual data.
    //The data generation is speific to the example design, and
    //so only the WVALID/WREADY handshake is shown here

       always @(posedge M_AXI_ACLK)
       begin
         if (M_AXI_ARESETN == 0)
           begin
             axi_wvalid <= 1'b0;
           end
         //Signal a new address/data command is available by user logic
         else if ((burst_type & start_burst))
           begin
             axi_wvalid <= 1'b1;
           end
         //Data accepted by interconnect/slave (issue of M_AXI_WREADY by slave)
         else if (M_AXI_WREADY && axi_wvalid)
           begin
            axi_wvalid <= 1'b0;
           end
       end


    //----------------------------
    //Write Response (B) Channel
    //----------------------------

    //The write response channel provides feedback that the write has committed
    //to memory. BREADY will occur after both the data and the write address
    //has arrived and been accepted by the slave, and can guarantee that no
    //other accesses launched afterwards will be able to be reordered before it.

    //The BRESP bit [1] is used indicate any errors from the interconnect or
    //slave for the entire write burst. This example will capture the error.

    //While not necessary per spec, it is advisable to reset READY signals in
    //case of differing reset latencies between master/slave.

      always @(posedge M_AXI_ACLK)
      begin
        if (M_AXI_ARESETN == 0 || (burst_type & start_burst))
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

    //Flag write errors
    assign write_resp_error = (axi_bready & M_AXI_BVALID & M_AXI_BRESP[1]);


    //----------------------------
    //Read Address Channel
    //----------------------------


      // A new axi_arvalid is asserted when there is a valid read address
      // available by the master. start_single_read triggers a new read
      // transaction
      always @(posedge M_AXI_ACLK)
      begin
        if (M_AXI_ARESETN == 0)
          begin
            axi_arvalid <= 1'b0;
          end
        //Signal a new read address command is available by user logic
        else if ((!burst_type & start_burst))
          begin
            axi_arvalid <= 1'b1;
          end
        //RAddress accepted by interconnect/slave (issue of M_AXI_ARREADY by slave)
        else if (M_AXI_ARREADY && axi_arvalid)
          begin
            axi_arvalid <= 1'b0;
          end
        // retain the previous value
      end


    //--------------------------------
    //Read Data (and Response) Channel
    //--------------------------------

    //The Read Data channel returns the results of the read request
    //The master will accept the read data by asserting axi_rready
    //when there is a valid read data available.
    //While not necessary per spec, it is advisable to reset READY signals in
    //case of differing reset latencies between master/slave.

      always @(posedge M_AXI_ACLK)
      begin
        if (M_AXI_ARESETN == 0)
          begin
            axi_rready <= 1'b0;
          end
        // accept/acknowledge rdata/rresp with axi_rready by the master
        // when M_AXI_RVALID is asserted by slave
        else if (M_AXI_RVALID && ~axi_rready)
          begin
            axi_rready <= 1'b1;
          end
        // deassert after one clock cycle
        else if (axi_rready)
          begin
            axi_rready <= 1'b0;
          end
        // retain the previous value
      end

    //Flag write errors
    assign read_resp_error = (axi_rready & M_AXI_RVALID & M_AXI_RRESP[1]);


    always @(posedge M_AXI_ACLK)
      begin
        if (M_AXI_ARESETN == 0)
            burst_type_reg <= 0;
        else
            burst_type_reg <= burst_type;
      end

    assign mem_done = burst_type_reg ? (axi_wvalid && M_AXI_WREADY) : (M_AXI_RVALID && axi_rready);


    endmodule
