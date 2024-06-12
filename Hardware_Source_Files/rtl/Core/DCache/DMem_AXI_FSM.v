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
module DMem_AXI_FSM(
    input  wire clk,
    input  wire rst,
    input  wire AccessAllowed_read_reg,
    input  wire AccessAllowed_write_reg,

    //////DCACHE SIGNALS/////////////////DCACHE AND AXI_FSM INTERFACE
    input  wire read_req_abort,
    input  wire write_req_reg,
    input  wire read_req_reg,
 //  input  wire [3:0]nxstate_dcache,

    //---private bus data and address---//
    input  wire [63:0]private_data_write,
    input  wire [31:0]private_address_write,
    output reg  [63:0]private_data_read,
    input  wire [31:0]private_address_read,
    input  wire  is_read_double,
    input  wire  is_write_double,

    output wire mem_ack,
    input  wire start_burst,
    input  wire burst_type, // 1-> write to memory, 0-> read from memory
    input  wire [63:0]axi_address,
    input  wire [255:0]axi_data_write, //cache line to be read/written
    output wire cache_beat,
    output wire [7 : 0] read_index,
    output wire [63:0]axi_data_read_input,

    output reg private_bus_busy,    // use this for done signal
    output reg write_done_private,
    output reg read_done_private,


    //////////------------------AXI FULL----------------------////////////////////AXI FULL BUS AND AXI FSM INTERFACE
    input  wire mem_ack_axi_full,
    output wire start_burst_full,
    output wire burst_type_full,
    output wire [63:0]axi_address_full,
    output wire [255:0]axi_data_write_full, //cache line to be read/written
    input  wire cache_beat_full,
    input  wire [7 : 0] read_index_full,
    input  wire [63:0]axi_data_read_input_full,


    ///////////--------------------AXI LITE-----------------------/////////////////////
    input  wire mem_ack_private,
    output reg  start_burst_private,
    output reg  burst_type_private,
    output wire [31:0]address_write_private,
    output wire [31:0]address_read_private,
    output wire [31:0]data_write_private,
    input  wire [31:0]data_read_input_private
    );

    reg [1:0] prstate, nxstate;
    localparam START = 2'b00;
    localparam PRIVATE_BUS = 2'b01;
    localparam PRIVATE_BUS_DONE = 2'b10;
    localparam AXI_FULL_BUS = 2'b11;
    wire write_private, read_private;
    reg read_pending, write_required;
    reg write_count, read_count;
    wire write_double, read_double;
    reg read_req_abort_reg;

    always @ (posedge clk) begin
        if (rst | (nxstate == START))
            read_req_abort_reg <= 0;
        else if (read_req_abort)
            read_req_abort_reg <= 1;
    end

    always @ (posedge clk) begin
        if (rst | (nxstate== START)) begin
            write_count <= 0;
        end
        else if (write_double & mem_ack_private) begin
            write_count <= write_count + 1;
        end
    end

    always @ (posedge clk) begin
        if (rst | (nxstate== START)) begin
            read_count <= 0;
        end
        else if (read_double & mem_ack_private) begin
            read_count <= read_count + 1;
        end
    end

    //------------The incoming AXI data input to latch first----------//
    always @ (posedge clk) begin
        if (rst) begin
            private_data_read <= 0;
        end
        else if (mem_ack_private) begin
            if (read_count)
                private_data_read[63:32] <= data_read_input_private;
            else
                private_data_read[31:0] <= data_read_input_private;
        end
    end

    always @ (posedge clk) begin
        if (rst || (nxstate== START)) begin
            read_pending <= 0;
        end
        else if (start_burst & read_private) begin
            read_pending <= 1;
        end
    end
    always @ (posedge clk) begin
        if (rst || write_done_private) begin
            write_required <= 0;
        end
        else if (start_burst_private & burst_type_private & write_private) begin
            write_required <= 1;
        end
    end

//    assign write_double = is_write_double & write_private & burst_type_private;
//    assign read_double = is_read_double & read_private & (!burst_type_private);
//    assign write_private = write_req_reg & AccessAllowed_write_reg;
//    assign read_private = read_req_reg & AccessAllowed_read_reg;
  
  
 assign read_double = is_read_double &read_private_1 & (!burst_type_private);
    assign write_double = is_write_double & write_private_1 & burst_type_private;

 

    assign write_private = write_req_reg & AccessAllowed_write_reg;
    assign read_private = read_req_reg & AccessAllowed_read_reg;
    reg write_private_1,read_private_1;
   always @(posedge clk) begin
       if (rst || write_done_private)
            write_private_1 <= 0;
       else if(AccessAllowed_write_reg)
              write_private_1<=1'b1;
       end

      always @(posedge clk) begin
       if (rst || read_done_private)
            read_private_1 <= 0;
       else if(AccessAllowed_read_reg)
              read_private_1<=1'b1;
       end



  
  
  
  
  
    assign start_burst_full = !private_bus_busy ? start_burst : 0;
    assign burst_type_full = burst_type;
    assign mem_ack = mem_ack_axi_full;
    assign cache_beat = cache_beat_full;
    assign read_index = read_index_full;
    assign axi_data_read_input = axi_data_read_input_full;
    assign axi_address_full = axi_address;
    assign axi_data_write_full = axi_data_write;
    assign address_read_private = read_count ? (private_address_read + 4) : private_address_read;
    assign address_write_private = write_count ? (private_address_write + 4) : private_address_write;
    assign data_write_private = write_count ? private_data_write[63:32] : private_data_write[31:0];

    always @ (posedge clk) begin
        if (rst)
            prstate <= 0;
        else
            prstate <= nxstate;
    end

    always @ (*) begin
        start_burst_private = 0;
        burst_type_private = 0;
        write_done_private = 0;
        read_done_private = 0;
        private_bus_busy = 0;
        case (prstate)
        START:       begin
                     if (start_burst) begin
                         if (write_private) begin
                             start_burst_private = 1;
                             burst_type_private = 1;
                             private_bus_busy = 1;
                             nxstate = PRIVATE_BUS;
                         end
                         else if (read_private) begin
                             start_burst_private = 1;
                             private_bus_busy = 1;
                             nxstate = PRIVATE_BUS;
                         end
                         else begin // its axi full burst
                             nxstate = START;
                         end
                     end
                     else begin
                         nxstate = START;
                     end
                     end
        PRIVATE_BUS: begin
                         private_bus_busy = 1;
                         burst_type_private = write_required;
                         if (mem_ack_private) begin
                            nxstate = PRIVATE_BUS_DONE;
                         end
                         else begin
                            nxstate = PRIVATE_BUS;
                         end
                     end
        PRIVATE_BUS_DONE:begin
                         private_bus_busy = 1;
                         if (write_required) begin //this came for write
                            if (write_count) begin  // Its a DW write and only LSB has been written
                                start_burst_private = 1;
                                burst_type_private = 1;
                                nxstate = PRIVATE_BUS;
                            end
                            else if (read_pending) begin
                                write_done_private = 1;
                                if (read_req_abort_reg) begin
                                    nxstate = START;
                                end
                                else begin
                                    start_burst_private = 1;
                                    nxstate = PRIVATE_BUS;
                                end
                            end
                            else begin
                                nxstate = START;
                                write_done_private = 1;
                            end
                        end
                        else begin// this came for read
                            if (read_req_abort_reg) begin
                                nxstate = START;
                            end
                            else if (read_count) begin
                                start_burst_private = 1;
                                nxstate = PRIVATE_BUS;
                            end
                            else begin
                                nxstate = START;
                                read_done_private = 1;
                            end
                        end
                     end
        AXI_FULL_BUS:begin //we can even delete this state
                     
                        nxstate = START;
                    end 
                    
        default:    begin
                        nxstate = START;
                     end
        endcase
    end
endmodule
