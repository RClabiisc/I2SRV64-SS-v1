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
    module PLIC_SLAVE_v1_0_S00_AXI #
    (
        // Users to add parameters here

        // User parameters ends
        // Do not modify the parameters beyond this line

        // Width of S_AXI data bus
        parameter integer C_S_AXI_DATA_WIDTH    = 32,
        // Width of S_AXI address bus
        parameter integer C_S_AXI_ADDR_WIDTH    = 32,
        parameter  BASE_ADDRESS = 32'b0,
        parameter PRIORITY_LEVELS = 32,
        parameter INTERRUPTS   = 8
    )
    (
        // Users to add ports here
        //input [2:0]privilege_mode,                //CORE
        input wire [31:0]interrupt_pending,       //PLIC
        output wire [2:0]interrupt_completion_notif,   //PLIC
        output wire [31:0]interrupt_completion_ID,//PLIC
        output wire [4:0]interrupt_claim_ID,      //PLIC
        output wire [2:0]interrupt_claim_notif,        //PLIC
        output wire [31:0] interrupt_active_0,      //PLIC
        output wire [31:0] interrupt_active_1,      //PLIC
        output wire [31:0] interrupt_active_2,      //PLIC
       // output wire [31:0]interrupt_claim_ID, -> returned in form of data bus to core.
        // User ports ends
        // Do not modify the ports beyond this line

        // Global Clock Signal
        input wire  S_AXI_ACLK,
        // Global Reset Signal. This Signal is Active LOW
        input wire  S_AXI_ARESETN,
        // Write address (issued by master, acceped by Slave)
        input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
        // Write channel Protection type. This signal indicates the
            // privilege and security level of the transaction, and whether
            // the transaction is a data access or an instruction access.
        input wire [2 : 0] S_AXI_AWPROT,
        // Write address valid. This signal indicates that the master signaling
            // valid write address and control information.
        input wire  S_AXI_AWVALID,
        // Write address ready. This signal indicates that the slave is ready
            // to accept an address and associated control signals.
        output wire  S_AXI_AWREADY,
        // Write data (issued by master, acceped by Slave)
        input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
        // Write strobes. This signal indicates which byte lanes hold
            // valid data. There is one write strobe bit for each eight
            // bits of the write data bus.
        input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
        // Write valid. This signal indicates that valid write
            // data and strobes are available.
        input wire  S_AXI_WVALID,
        // Write ready. This signal indicates that the slave
            // can accept the write data.
        output wire  S_AXI_WREADY,
        // Write response. This signal indicates the status
            // of the write transaction.
        output wire [1 : 0] S_AXI_BRESP,
        // Write response valid. This signal indicates that the channel
            // is signaling a valid write response.
        output wire  S_AXI_BVALID,
        // Response ready. This signal indicates that the master
            // can accept a write response.
        input wire  S_AXI_BREADY,
        // Read address (issued by master, acceped by Slave)
        input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
        // Protection type. This signal indicates the privilege
            // and security level of the transaction, and whether the
            // transaction is a data access or an instruction access.
        input wire [2 : 0] S_AXI_ARPROT,
        // Read address valid. This signal indicates that the channel
            // is signaling valid read address and control information.
        input wire  S_AXI_ARVALID,
        // Read address ready. This signal indicates that the slave is
            // ready to accept an address and associated control signals.
        output wire  S_AXI_ARREADY,
        // Read data (issued by slave)
        output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
        // Read response. This signal indicates the status of the
            // read transfer.
        output wire [1 : 0] S_AXI_RRESP,
        // Read valid. This signal indicates that the channel is
            // signaling the required read data.
        output wire  S_AXI_RVALID,
        // Read ready. This signal indicates that the master can
            // accept the read data and response information.
        input wire  S_AXI_RREADY
    );

    // AXI4LITE signals
    reg [C_S_AXI_ADDR_WIDTH-1 : 0]  axi_awaddr;
    reg     axi_awready;
    reg     axi_wready;
    reg [1 : 0]     axi_bresp;
    reg     axi_bvalid;
    reg [C_S_AXI_ADDR_WIDTH-1 : 0]  axi_araddr;
    reg     axi_arready;
    reg [C_S_AXI_DATA_WIDTH-1 : 0]  axi_rdata;
    reg [1 : 0]     axi_rresp;
    reg     axi_rvalid;

    // Example-specific design signals
    // local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
    // ADDR_LSB is used for addressing 32/64 bit registers/memories
    // ADDR_LSB = 2 for 32 bits (n downto 2)
    // ADDR_LSB = 3 for 64 bits (n downto 3)
    localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
    localparam integer OPT_MEM_ADDR_BITS = 1;
    //----------------------------------------------
    //-- Signals for user logic register space example
    //------------------------------------------------
    //-- Number of Slave Registers 4
    reg     [31:0]      interrupt_priority [31:0];
    reg     [31:0]      largest_priority_0, largest_priority_1, largest_priority_2;
//  DECLARED IN PLIC MODULE
//  reg     [C_S_AXI_DATA_WIDTH-1:0]    interrupt_pending; // Bit wise but only 1
    reg     [31:0]      interrupt_enable[2:0]; //Bit wise but 3 for 3 contexts (Mode in a hart) //0-M; 1-S; 2-U//
    reg     [31:0]      interrupt_threshold[2:0];
    reg     [31:0]      interrupt_claim_complete[2:0];
    wire                slv_reg_rden;
    wire                slv_reg_wren;
    reg     [31:0]      reg_data_out;
    integer             byte_index;
    reg                 aw_en;

    // I/O Connections assignments

    assign S_AXI_AWREADY = axi_awready;
    assign S_AXI_WREADY = axi_wready;
    assign S_AXI_BRESP  = axi_bresp;
    assign S_AXI_BVALID = axi_bvalid;
    assign S_AXI_ARREADY = axi_arready;
    assign S_AXI_RDATA  = axi_rdata;
    assign S_AXI_RRESP  = axi_rresp;
    assign S_AXI_RVALID = axi_rvalid;
    // Implement axi_awready generation
    // axi_awready is asserted for one S_AXI_ACLK clock cycle when both
    // S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
    // de-asserted when reset is low.

    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_awready <= 1'b0;
          aw_en <= 1'b1;
        end
      else
        begin
          if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
            begin
              // slave is ready to accept write address when
              // there is a valid write address and write data
              // on the write address and data bus. This design
              // expects no outstanding transactions.
              axi_awready <= 1'b1;
              aw_en <= 1'b0;
            end
            else if (S_AXI_BREADY && axi_bvalid)
                begin
                  aw_en <= 1'b1;
                  axi_awready <= 1'b0;
                end
          else
            begin
              axi_awready <= 1'b0;
            end
        end
    end

    // Implement axi_awaddr latching
    // This process is used to latch the address when both
    // S_AXI_AWVALID and S_AXI_WVALID are valid.

    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_awaddr <= 0;
        end
      else
        begin
          if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
            begin
              // Write Address latching
              axi_awaddr <= S_AXI_AWADDR;
            end
        end
    end

    // Implement axi_wready generation
    // axi_wready is asserted for one S_AXI_ACLK clock cycle when both
    // S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is
    // de-asserted when reset is low.

    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_wready <= 1'b0;
        end
      else
        begin
          if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en )
            begin
              // slave is ready to accept write data when
              // there is a valid write address and write data
              // on the write address and data bus. This design
              // expects no outstanding transactions.
              axi_wready <= 1'b1;
            end
          else
            begin
              axi_wready <= 1'b0;
            end
        end
    end

    // Implement memory mapped register select and write logic generation
    // The write data is accepted and written to memory mapped registers when
    // axi_awready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted. Write strobes are used to
    // select byte enables of slave registers while writing.
    // These registers are cleared when reset (active low) is applied.
    // Slave register write enable is asserted when valid address and data are available
    // and the slave is ready to accept the write address and write data.
    assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

    wire [C_S_AXI_ADDR_WIDTH-1 : 0] reg_addr_w;
    wire [C_S_AXI_ADDR_WIDTH-1 : 0] reg_addr_r;

    assign reg_addr_w = axi_awaddr;
    assign reg_addr_r = axi_araddr;
    //*****************************************************************************************************//
    //*****************************************************************************************************//
    //*****************************************************************************************************//
    ///////////////////////////////////////////////PLIC LOGIC/////////////////////////////////////////////////
    reg [4:0]interrupt_ID_0, interrupt_ID_1, interrupt_ID_2;

//    wire [31:0] interrupt_enable_current;
//    wire [31:0] interrupt_threshold_current;
//    wire [31:0] interrupt_claim_complete_current;

//    assign interrupt_enable_current = (privilege_mode==2'b0) ? interrupt_enable[0] : (privilege_mode==2'b1 ? interrupt_enable[1] : interrupt_enable[2]);
//    assign interrupt_threshold_current = (privilege_mode==2'b0) ? interrupt_threshold[0] : (privilege_mode==2'b1 ? interrupt_threshold[1] : interrupt_threshold[2]);
//    assign interrupt_claim_complete_current = (privilege_mode==2'b0) ? interrupt_claim_complete[0] : (privilege_mode==2'b1 ? interrupt_claim_complete[1] : interrupt_claim_complete[2]);

    assign interrupt_completion_notif[0] = slv_reg_wren && (reg_addr_w[23:0]==24'h200004);
    assign interrupt_completion_notif[1] = slv_reg_wren && (reg_addr_w[23:0]==24'h201004);
    assign interrupt_completion_notif[2] = slv_reg_wren && (reg_addr_w[23:0]==24'h202004);
    assign interrupt_completion_ID = S_AXI_WDATA;

    assign interrupt_claim_notif[0] = (axi_rvalid & S_AXI_RREADY) && (reg_addr_r[23:0]==24'h200004);
    assign interrupt_claim_notif[1] = (axi_rvalid & S_AXI_RREADY) && (reg_addr_r[23:0]==24'h201004);
    assign interrupt_claim_notif[2] = (axi_rvalid & S_AXI_RREADY) && (reg_addr_r[23:0]==24'h202004);
    assign interrupt_claim_ID = S_AXI_RDATA; //should go at same time as claim_notif.

    assign interrupt_active_0[0] = 0;
    assign interrupt_active_1[0] = 0;
    assign interrupt_active_2[0] = 0;

    genvar j;
    generate
    for(j=1; j<32;j=j+1)
        begin
            assign interrupt_active_0[j] = interrupt_enable[0][j % 32] & interrupt_pending[j % 32] & (interrupt_priority[j][$clog2(PRIORITY_LEVELS):0]>interrupt_threshold[0][$clog2(PRIORITY_LEVELS):0]) & (interrupt_priority[j][$clog2(PRIORITY_LEVELS):0]!=0) & (j<=INTERRUPTS);
            assign interrupt_active_1[j] = interrupt_enable[1][j % 32] & interrupt_pending[j % 32] & (interrupt_priority[j][$clog2(PRIORITY_LEVELS):0]>interrupt_threshold[1][$clog2(PRIORITY_LEVELS):0]) & (interrupt_priority[j][$clog2(PRIORITY_LEVELS):0]!=0) & (j<=INTERRUPTS);
            assign interrupt_active_2[j] = interrupt_enable[2][j % 32] & interrupt_pending[j % 32] & (interrupt_priority[j][$clog2(PRIORITY_LEVELS):0]>interrupt_threshold[2][$clog2(PRIORITY_LEVELS):0]) & (interrupt_priority[j][$clog2(PRIORITY_LEVELS):0]!=0) & (j<=INTERRUPTS);
        end
    endgenerate

    ///////////////////////////////////////////////////////////////////////////////////////////////
    //find largest priority

    integer i;
    // For same priorirty, smallest ID wins, hence we loop from largest to smallest ID
    always @ (*) begin
        interrupt_ID_0 = 0; // if none active, then it should return 0.
        largest_priority_0[$clog2(PRIORITY_LEVELS):0] = interrupt_priority [31][$clog2(PRIORITY_LEVELS):0];
        for (i=30; i>0 ; i=i-1)
            begin
                if (interrupt_active_0[i] & (interrupt_priority[i][$clog2(PRIORITY_LEVELS):0]>= largest_priority_0[$clog2(PRIORITY_LEVELS):0]) & (i<=INTERRUPTS)) begin
                    interrupt_ID_0 = i;
                    largest_priority_0[$clog2(PRIORITY_LEVELS):0] = interrupt_priority[i][$clog2(PRIORITY_LEVELS):0];
                end
            end
    end

    integer d;
    // For same priorirty, smallest ID wins, hence we loop from largest to smallest ID
    always @ (*) begin
        interrupt_ID_1 = 0; // if none active, then it should return 0.
        largest_priority_1[$clog2(PRIORITY_LEVELS):0] = interrupt_priority [31][$clog2(PRIORITY_LEVELS):0];
        for (d=30; d>0 ; d=d-1)
            begin
                if (interrupt_active_1[d] & (interrupt_priority[d][$clog2(PRIORITY_LEVELS):0]>= largest_priority_1[$clog2(PRIORITY_LEVELS):0]) & (d<=INTERRUPTS)) begin
                    interrupt_ID_1 = d;
                    largest_priority_1[$clog2(PRIORITY_LEVELS):0] = interrupt_priority[d][$clog2(PRIORITY_LEVELS):0];
                end
            end
    end

    integer e;
    // For same priorirty, smallest ID wins, hence we loop from largest to smallest ID
    always @ (*) begin
        interrupt_ID_2 = 0; // if none active, then it should return 0.
        largest_priority_2[$clog2(PRIORITY_LEVELS):0] = interrupt_priority [31][$clog2(PRIORITY_LEVELS):0];
        for (e=30; e>0 ; e=e-1)
            begin
                if (interrupt_active_2[e] & (interrupt_priority[e][$clog2(PRIORITY_LEVELS):0]>= largest_priority_2[$clog2(PRIORITY_LEVELS):0]) & (e<=INTERRUPTS)) begin
                    interrupt_ID_2 = e;
                    largest_priority_2[$clog2(PRIORITY_LEVELS):0] = interrupt_priority[e][$clog2(PRIORITY_LEVELS):0];
                end
            end
    end
    //
    //On receiving a claim message, the PLIC core will atomically determine the ID of the highest-priority pending interrupt for the target and then clear down the corresponding source's IP bit.
    // If claim request comes in cycle 1 and a new high priority interrupt also comes in this cycle, then PLIC won't be abe to send request for this.



    ///////////////////////////////CLAIM COMPLETE IN SEPARATE LOGIC///////////////////////////////////////////
    // Because PLIC needs to keep writing the highest priority pending interrupt to this register
    // so that core can directly read the register.

    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
            interrupt_claim_complete[0] <= 0;
            interrupt_claim_complete[1] <= 0;
            interrupt_claim_complete[2] <= 0;
          end
      else if (slv_reg_wren)
          begin
            case ( reg_addr_w[23:0])
              24'h200004:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_claim_complete[0][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h201004:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_claim_complete[1][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h202004:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_claim_complete[2][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               default : begin
                        interrupt_claim_complete[0] <= interrupt_claim_complete[0];
                        interrupt_claim_complete[1] <= interrupt_claim_complete[1];
                        interrupt_claim_complete[2] <= interrupt_claim_complete[2];
                        end
            endcase
          end
      else begin
            interrupt_claim_complete[0] <= {interrupt_claim_complete[0][31:5],interrupt_ID_0};
            interrupt_claim_complete[1] <= {interrupt_claim_complete[1][31:5],interrupt_ID_1};
            interrupt_claim_complete[2] <= {interrupt_claim_complete[2][31:5],interrupt_ID_2};
      end
    end

    //////////////////////////////////////////////////////////////////////////////////////////////////////////
    //*****************************************************************************************************//
    //*****************************************************************************************************//

    integer m;
    integer n;
    integer k,l;

    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          for (m=0; m< 32; m=m+1) begin
               interrupt_priority[m] <= 0;
          end
          for (n=0; n<=2; n=n+1) begin
               interrupt_enable[n] <= 0;
               interrupt_threshold[n] <= 0;
          end
        end
      else begin
        if (slv_reg_wren)
          begin
            case ( reg_addr_w[23:0])
              24'h000000:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[0][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h000004:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[1][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h000008:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[2][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h00000C:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[3][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h000010:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[4][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h000014:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[5][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h000018:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[6][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h00001C:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[7][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h000020:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[8][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h000024:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[9][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h000028:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[10][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h00002C:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[11][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h000030:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[12][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h000034:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[13][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h000038:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[14][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h00003C:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[15][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h000040:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[16][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h000044:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[17][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h000048:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[18][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h00004C:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[19][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h000050:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[20][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h000054:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[21][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h000058:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[22][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h00005C:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[23][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h000060:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[24][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h000064:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[25][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h000068:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[26][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h00006C:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[27][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h000070:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[28][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h000074:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[29][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h000078:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[30][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h00007C:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_priority[31][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h002000:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_enable[0][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h002080:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_enable[1][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h002100:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_enable[2][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h200000:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_threshold[0][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
               24'h201000:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_threshold[1][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end
                24'h202000:
                for ( byte_index = 0; byte_index <= (C_S_AXI_DATA_WIDTH/8)-1; byte_index = byte_index+1 )
                  if ( S_AXI_WSTRB[byte_index] == 1 ) begin
                    // Respective byte enables are asserted as per write strobes
                    // Slave register 0
                    interrupt_threshold[2][(byte_index*8) +: 8] <= S_AXI_WDATA[(byte_index*8) +: 8];
                  end

              default : begin
                        for (k=0; k< 32; k=k+1) begin
                           interrupt_priority[k] <= interrupt_priority[k];
                        end
                        for (l=0; l<=2; l=l+1) begin
                           interrupt_enable[l] <= interrupt_enable[l];
                           interrupt_threshold[l] <= interrupt_threshold[l];
                        end
                        end
            endcase
            interrupt_enable[0][0] <= 0;
            interrupt_enable[1][0] <= 0;
            interrupt_enable[2][0] <= 0;
          end
      end
    end

    // Implement write response logic generation
    // The write response and response valid signals are asserted by the slave
    // when axi_wready, S_AXI_WVALID, axi_wready and S_AXI_WVALID are asserted.
    // This marks the acceptance of address and indicates the status of
    // write transaction.

    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_bvalid  <= 0;
          axi_bresp   <= 2'b0;
        end
      else
        begin
          if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
            begin
              // indicates a valid write response is available
              axi_bvalid <= 1'b1;
              axi_bresp  <= 2'b0; // 'OKAY' response
            end                   // work error responses in future
          else
            begin
              if (S_AXI_BREADY && axi_bvalid)
                //check if bready is asserted while bvalid is high)
                //(there is a possibility that bready is always asserted high)
                begin
                  axi_bvalid <= 1'b0;
                end
            end
        end
    end

    // Implement axi_arready generation
    // axi_arready is asserted for one S_AXI_ACLK clock cycle when
    // S_AXI_ARVALID is asserted. axi_awready is
    // de-asserted when reset (active low) is asserted.
    // The read address is also latched when S_AXI_ARVALID is
    // asserted. axi_araddr is reset to zero on reset assertion.

    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_arready <= 1'b0;
          axi_araddr  <= 32'b0;
        end
      else
        begin
          if (~axi_arready && S_AXI_ARVALID)
            begin
              // indicates that the slave has acceped the valid read address
              axi_arready <= 1'b1;
              // Read address latching
              axi_araddr  <= S_AXI_ARADDR;
            end
          else
            begin
              axi_arready <= 1'b0;
            end
        end
    end

    // Implement axi_arvalid generation
    // axi_rvalid is asserted for one S_AXI_ACLK clock cycle when both
    // S_AXI_ARVALID and axi_arready are asserted. The slave registers
    // data are available on the axi_rdata bus at this instance. The
    // assertion of axi_rvalid marks the validity of read data on the
    // bus and axi_rresp indicates the status of read transaction.axi_rvalid
    // is deasserted on reset (active low). axi_rresp and axi_rdata are
    // cleared to zero on reset (active low).
    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_rvalid <= 0;
          axi_rresp  <= 0;
        end
      else
        begin
          if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
            begin
              // Valid read data is available at the read data bus
              axi_rvalid <= 1'b1;
              axi_rresp  <= 2'b0; // 'OKAY' response
            end
          else if (axi_rvalid && S_AXI_RREADY)
            begin
              // Read data is accepted by the master
              axi_rvalid <= 1'b0;
            end
        end
    end

    // Implement memory mapped register select and read logic generation
    // Slave register read enable is asserted when valid address is available
    // and the slave is ready to accept the read address.
    assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;

    always @(*)
    begin
          // Address decoding for reading registers
          case ( reg_addr_r[23:0] )
               24'h000000: reg_data_out <= interrupt_priority[0];
               24'h000004: reg_data_out <= interrupt_priority[1];
               24'h000008: reg_data_out <= interrupt_priority[2];
               24'h00000C: reg_data_out <= interrupt_priority[3];
               24'h000010: reg_data_out <= interrupt_priority[4];
               24'h000014: reg_data_out <= interrupt_priority[5];
               24'h000018: reg_data_out <= interrupt_priority[6];
               24'h00001C: reg_data_out <= interrupt_priority[7];
               24'h000020: reg_data_out <= interrupt_priority[8];
               24'h000024: reg_data_out <= interrupt_priority[9];
               24'h000028: reg_data_out <= interrupt_priority[10];
               24'h00002C: reg_data_out <= interrupt_priority[11];
               24'h000030: reg_data_out <= interrupt_priority[12];
               24'h000034: reg_data_out <= interrupt_priority[13];
               24'h000038: reg_data_out <= interrupt_priority[14];
               24'h00003C: reg_data_out <= interrupt_priority[15];
               24'h000040: reg_data_out <= interrupt_priority[16];
               24'h000044: reg_data_out <= interrupt_priority[17];
               24'h000048: reg_data_out <= interrupt_priority[18];
               24'h00004C: reg_data_out <= interrupt_priority[19];
               24'h000050: reg_data_out <= interrupt_priority[20];
               24'h000054: reg_data_out <= interrupt_priority[21];
               24'h000058: reg_data_out <= interrupt_priority[22];
               24'h00005C: reg_data_out <= interrupt_priority[23];
               24'h000060: reg_data_out <= interrupt_priority[24];
               24'h000064: reg_data_out <= interrupt_priority[25];
               24'h000068: reg_data_out <= interrupt_priority[26];
               24'h00006C: reg_data_out <= interrupt_priority[27];
               24'h000070: reg_data_out <= interrupt_priority[28];
               24'h000074: reg_data_out <= interrupt_priority[29];
               24'h000078: reg_data_out <= interrupt_priority[30];
               24'h00007C: reg_data_out <= interrupt_priority[31];
               24'h001000: reg_data_out <= interrupt_pending;
               24'h002000: reg_data_out <= interrupt_enable[0];
               24'h002080: reg_data_out <= interrupt_enable[1];
               24'h002100: reg_data_out <= interrupt_enable[2];
               24'h200000: reg_data_out <= interrupt_threshold[0];
               24'h200004: reg_data_out <= interrupt_claim_complete[0];
               24'h201000: reg_data_out <= interrupt_threshold[1];
               24'h201004: reg_data_out <= interrupt_claim_complete[1];
               24'h202000: reg_data_out <= interrupt_threshold[2];
               24'h202004: reg_data_out <= interrupt_claim_complete[2];
               default : reg_data_out <= 0;
          endcase
    end

    // Output register or memory read data
    always @( posedge S_AXI_ACLK )
    begin
      if ( S_AXI_ARESETN == 1'b0 )
        begin
          axi_rdata  <= 0;
        end
      else
        begin
          // When there is a valid read address (S_AXI_ARVALID) with
          // acceptance of read address by the slave (axi_arready),
          // output the read dada
          if (slv_reg_rden)
            begin
              axi_rdata <= reg_data_out;     // register read data
            end
        end
    end

    // Add user logic here

    // User logic ends

    endmodule
