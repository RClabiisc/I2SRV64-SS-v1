// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
// Date        : Wed Mar  2 16:41:35 2022
// Host        : rclab-H410M-H running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/anuj/work_sajin/RISCV/IP/axi64_bram_ctrl_16KiB/axi64_bram_ctrl_16KiB_sim_netlist.v
// Design      : axi64_bram_ctrl_16KiB
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7vx485tffg1761-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "axi64_bram_ctrl_16KiB,axi_bram_ctrl,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "axi_bram_ctrl,Vivado 2020.1" *) 
(* NotValidForBitStream *)
module axi64_bram_ctrl_16KiB
   (s_axi_aclk,
    s_axi_aresetn,
    s_axi_awid,
    s_axi_awaddr,
    s_axi_awlen,
    s_axi_awsize,
    s_axi_awburst,
    s_axi_awlock,
    s_axi_awcache,
    s_axi_awprot,
    s_axi_awvalid,
    s_axi_awready,
    s_axi_wdata,
    s_axi_wstrb,
    s_axi_wlast,
    s_axi_wvalid,
    s_axi_wready,
    s_axi_bid,
    s_axi_bresp,
    s_axi_bvalid,
    s_axi_bready,
    s_axi_arid,
    s_axi_araddr,
    s_axi_arlen,
    s_axi_arsize,
    s_axi_arburst,
    s_axi_arlock,
    s_axi_arcache,
    s_axi_arprot,
    s_axi_arvalid,
    s_axi_arready,
    s_axi_rid,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_rlast,
    s_axi_rvalid,
    s_axi_rready,
    bram_rst_a,
    bram_clk_a,
    bram_en_a,
    bram_we_a,
    bram_addr_a,
    bram_wrdata_a,
    bram_rddata_a,
    bram_rst_b,
    bram_clk_b,
    bram_en_b,
    bram_we_b,
    bram_addr_b,
    bram_wrdata_b,
    bram_rddata_b);
  (* x_interface_info = "xilinx.com:signal:clock:1.0 CLKIF CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME CLKIF, ASSOCIATED_BUSIF S_AXI:S_AXI_CTRL, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, INSERT_VIP 0" *) input s_axi_aclk;
  (* x_interface_info = "xilinx.com:signal:reset:1.0 RSTIF RST" *) (* x_interface_parameter = "XIL_INTERFACENAME RSTIF, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input s_axi_aresetn;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI AWID" *) (* x_interface_parameter = "XIL_INTERFACENAME S_AXI, DATA_WIDTH 64, PROTOCOL AXI4, FREQ_HZ 100000000, ID_WIDTH 4, ADDR_WIDTH 14, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.000, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) input [3:0]s_axi_awid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI AWADDR" *) input [13:0]s_axi_awaddr;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI AWLEN" *) input [7:0]s_axi_awlen;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI AWSIZE" *) input [2:0]s_axi_awsize;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI AWBURST" *) input [1:0]s_axi_awburst;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI AWLOCK" *) input s_axi_awlock;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI AWCACHE" *) input [3:0]s_axi_awcache;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI AWPROT" *) input [2:0]s_axi_awprot;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI AWVALID" *) input s_axi_awvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI AWREADY" *) output s_axi_awready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI WDATA" *) input [63:0]s_axi_wdata;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI WSTRB" *) input [7:0]s_axi_wstrb;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI WLAST" *) input s_axi_wlast;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI WVALID" *) input s_axi_wvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI WREADY" *) output s_axi_wready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI BID" *) output [3:0]s_axi_bid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI BRESP" *) output [1:0]s_axi_bresp;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI BVALID" *) output s_axi_bvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI BREADY" *) input s_axi_bready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI ARID" *) input [3:0]s_axi_arid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI ARADDR" *) input [13:0]s_axi_araddr;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI ARLEN" *) input [7:0]s_axi_arlen;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI ARSIZE" *) input [2:0]s_axi_arsize;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI ARBURST" *) input [1:0]s_axi_arburst;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI ARLOCK" *) input s_axi_arlock;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI ARCACHE" *) input [3:0]s_axi_arcache;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI ARPROT" *) input [2:0]s_axi_arprot;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI ARVALID" *) input s_axi_arvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI ARREADY" *) output s_axi_arready;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI RID" *) output [3:0]s_axi_rid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI RDATA" *) output [63:0]s_axi_rdata;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI RRESP" *) output [1:0]s_axi_rresp;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI RLAST" *) output s_axi_rlast;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI RVALID" *) output s_axi_rvalid;
  (* x_interface_info = "xilinx.com:interface:aximm:1.0 S_AXI RREADY" *) input s_axi_rready;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA RST" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MASTER_TYPE BRAM_CTRL, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, READ_LATENCY 1" *) output bram_rst_a;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) output bram_clk_a;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) output bram_en_a;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) output [7:0]bram_we_a;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) output [13:0]bram_addr_a;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) output [63:0]bram_wrdata_a;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) input [63:0]bram_rddata_a;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB RST" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MASTER_TYPE BRAM_CTRL, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, READ_LATENCY 1" *) output bram_rst_b;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) output bram_clk_b;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB EN" *) output bram_en_b;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB WE" *) output [7:0]bram_we_b;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) output [13:0]bram_addr_b;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN" *) output [63:0]bram_wrdata_b;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) input [63:0]bram_rddata_b;

  wire [13:0]bram_addr_a;
  wire [13:0]bram_addr_b;
  wire bram_clk_a;
  wire bram_clk_b;
  wire bram_en_a;
  wire bram_en_b;
  wire [63:0]bram_rddata_a;
  wire [63:0]bram_rddata_b;
  wire bram_rst_a;
  wire bram_rst_b;
  wire [7:0]bram_we_a;
  wire [7:0]bram_we_b;
  wire [63:0]bram_wrdata_a;
  wire [63:0]bram_wrdata_b;
  wire s_axi_aclk;
  wire [13:0]s_axi_araddr;
  wire [1:0]s_axi_arburst;
  wire [3:0]s_axi_arcache;
  wire s_axi_aresetn;
  wire [3:0]s_axi_arid;
  wire [7:0]s_axi_arlen;
  wire s_axi_arlock;
  wire [2:0]s_axi_arprot;
  wire s_axi_arready;
  wire [2:0]s_axi_arsize;
  wire s_axi_arvalid;
  wire [13:0]s_axi_awaddr;
  wire [1:0]s_axi_awburst;
  wire [3:0]s_axi_awcache;
  wire [3:0]s_axi_awid;
  wire [7:0]s_axi_awlen;
  wire s_axi_awlock;
  wire [2:0]s_axi_awprot;
  wire s_axi_awready;
  wire [2:0]s_axi_awsize;
  wire s_axi_awvalid;
  wire [3:0]s_axi_bid;
  wire s_axi_bready;
  wire [1:0]s_axi_bresp;
  wire s_axi_bvalid;
  wire [63:0]s_axi_rdata;
  wire [3:0]s_axi_rid;
  wire s_axi_rlast;
  wire s_axi_rready;
  wire [1:0]s_axi_rresp;
  wire s_axi_rvalid;
  wire [63:0]s_axi_wdata;
  wire s_axi_wlast;
  wire s_axi_wready;
  wire [7:0]s_axi_wstrb;
  wire s_axi_wvalid;
  wire NLW_U0_ecc_interrupt_UNCONNECTED;
  wire NLW_U0_ecc_ue_UNCONNECTED;
  wire NLW_U0_s_axi_ctrl_arready_UNCONNECTED;
  wire NLW_U0_s_axi_ctrl_awready_UNCONNECTED;
  wire NLW_U0_s_axi_ctrl_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_ctrl_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_ctrl_wready_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_ctrl_bresp_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_ctrl_rdata_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_ctrl_rresp_UNCONNECTED;

  (* C_BRAM_ADDR_WIDTH = "11" *) 
  (* C_BRAM_INST_MODE = "EXTERNAL" *) 
  (* C_ECC = "0" *) 
  (* C_ECC_ONOFF_RESET_VALUE = "0" *) 
  (* C_ECC_TYPE = "0" *) 
  (* C_FAMILY = "virtex7" *) 
  (* C_FAULT_INJECT = "0" *) 
  (* C_MEMORY_DEPTH = "2048" *) 
  (* C_RD_CMD_OPTIMIZATION = "1" *) 
  (* C_READ_LATENCY = "1" *) 
  (* C_SINGLE_PORT_BRAM = "0" *) 
  (* C_S_AXI_ADDR_WIDTH = "14" *) 
  (* C_S_AXI_CTRL_ADDR_WIDTH = "32" *) 
  (* C_S_AXI_CTRL_DATA_WIDTH = "32" *) 
  (* C_S_AXI_DATA_WIDTH = "64" *) 
  (* C_S_AXI_ID_WIDTH = "4" *) 
  (* C_S_AXI_PROTOCOL = "AXI4" *) 
  (* C_S_AXI_SUPPORTS_NARROW_BURST = "0" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  axi64_bram_ctrl_16KiB_axi_bram_ctrl U0
       (.bram_addr_a(bram_addr_a),
        .bram_addr_b(bram_addr_b),
        .bram_clk_a(bram_clk_a),
        .bram_clk_b(bram_clk_b),
        .bram_en_a(bram_en_a),
        .bram_en_b(bram_en_b),
        .bram_rddata_a(bram_rddata_a),
        .bram_rddata_b(bram_rddata_b),
        .bram_rst_a(bram_rst_a),
        .bram_rst_b(bram_rst_b),
        .bram_we_a(bram_we_a),
        .bram_we_b(bram_we_b),
        .bram_wrdata_a(bram_wrdata_a),
        .bram_wrdata_b(bram_wrdata_b),
        .ecc_interrupt(NLW_U0_ecc_interrupt_UNCONNECTED),
        .ecc_ue(NLW_U0_ecc_ue_UNCONNECTED),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_arburst(s_axi_arburst),
        .s_axi_arcache(s_axi_arcache),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_arid(s_axi_arid),
        .s_axi_arlen(s_axi_arlen),
        .s_axi_arlock(s_axi_arlock),
        .s_axi_arprot(s_axi_arprot),
        .s_axi_arready(s_axi_arready),
        .s_axi_arsize(s_axi_arsize),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awburst(s_axi_awburst),
        .s_axi_awcache(s_axi_awcache),
        .s_axi_awid(s_axi_awid),
        .s_axi_awlen(s_axi_awlen),
        .s_axi_awlock(s_axi_awlock),
        .s_axi_awprot(s_axi_awprot),
        .s_axi_awready(s_axi_awready),
        .s_axi_awsize(s_axi_awsize),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bid(s_axi_bid),
        .s_axi_bready(s_axi_bready),
        .s_axi_bresp(s_axi_bresp),
        .s_axi_bvalid(s_axi_bvalid),
        .s_axi_ctrl_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_ctrl_arready(NLW_U0_s_axi_ctrl_arready_UNCONNECTED),
        .s_axi_ctrl_arvalid(1'b0),
        .s_axi_ctrl_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_ctrl_awready(NLW_U0_s_axi_ctrl_awready_UNCONNECTED),
        .s_axi_ctrl_awvalid(1'b0),
        .s_axi_ctrl_bready(1'b0),
        .s_axi_ctrl_bresp(NLW_U0_s_axi_ctrl_bresp_UNCONNECTED[1:0]),
        .s_axi_ctrl_bvalid(NLW_U0_s_axi_ctrl_bvalid_UNCONNECTED),
        .s_axi_ctrl_rdata(NLW_U0_s_axi_ctrl_rdata_UNCONNECTED[31:0]),
        .s_axi_ctrl_rready(1'b0),
        .s_axi_ctrl_rresp(NLW_U0_s_axi_ctrl_rresp_UNCONNECTED[1:0]),
        .s_axi_ctrl_rvalid(NLW_U0_s_axi_ctrl_rvalid_UNCONNECTED),
        .s_axi_ctrl_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_ctrl_wready(NLW_U0_s_axi_ctrl_wready_UNCONNECTED),
        .s_axi_ctrl_wvalid(1'b0),
        .s_axi_rdata(s_axi_rdata),
        .s_axi_rid(s_axi_rid),
        .s_axi_rlast(s_axi_rlast),
        .s_axi_rready(s_axi_rready),
        .s_axi_rresp(s_axi_rresp),
        .s_axi_rvalid(s_axi_rvalid),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wlast(s_axi_wlast),
        .s_axi_wready(s_axi_wready),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid));
endmodule

(* ORIG_REF_NAME = "SRL_FIFO" *) 
module axi64_bram_ctrl_16KiB_SRL_FIFO
   (axi_wr_burst_reg,
    E,
    bid_gets_fifo_load,
    \bvalid_cnt_reg[2] ,
    D,
    \GEN_AW_PIPE_DUAL.axi_awaddr_full_reg ,
    \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1] ,
    \bvalid_cnt_reg[0] ,
    Data_Exists_DFF_0,
    s_axi_aclk,
    bram_addr_ld_en,
    bid_gets_fifo_load_d1,
    Q,
    axi_awaddr_full,
    s_axi_awid,
    bid_gets_fifo_load_d1_reg,
    axi_wr_burst,
    s_axi_wlast,
    wr_data_sm_cs,
    s_axi_wvalid,
    bvalid_cnt,
    s_axi_awvalid,
    s_axi_awready,
    aw_active,
    s_axi_bready,
    \axi_bid_int_reg[0] );
  output axi_wr_burst_reg;
  output [0:0]E;
  output bid_gets_fifo_load;
  output \bvalid_cnt_reg[2] ;
  output [3:0]D;
  output \GEN_AW_PIPE_DUAL.axi_awaddr_full_reg ;
  output \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1] ;
  output \bvalid_cnt_reg[0] ;
  input Data_Exists_DFF_0;
  input s_axi_aclk;
  input bram_addr_ld_en;
  input bid_gets_fifo_load_d1;
  input [3:0]Q;
  input axi_awaddr_full;
  input [3:0]s_axi_awid;
  input bid_gets_fifo_load_d1_reg;
  input axi_wr_burst;
  input s_axi_wlast;
  input [2:0]wr_data_sm_cs;
  input s_axi_wvalid;
  input [2:0]bvalid_cnt;
  input s_axi_awvalid;
  input s_axi_awready;
  input aw_active;
  input s_axi_bready;
  input \axi_bid_int_reg[0] ;

  wire \Addr_Counters[0].FDRE_I_n_0 ;
  wire \Addr_Counters[0].MUXCY_L_I_i_2_n_0 ;
  wire \Addr_Counters[0].MUXCY_L_I_i_3_n_0 ;
  wire \Addr_Counters[0].MUXCY_L_I_i_4_n_0 ;
  wire \Addr_Counters[0].MUXCY_L_I_i_5_n_0 ;
  wire \Addr_Counters[1].FDRE_I_n_0 ;
  wire \Addr_Counters[2].FDRE_I_n_0 ;
  wire \Addr_Counters[3].FDRE_I_n_0 ;
  wire \Addr_Counters[3].XORCY_I_i_1_n_0 ;
  wire [3:0]D;
  wire D_0;
  wire Data_Exists_DFF_0;
  wire Data_Exists_DFF_i_2_n_0;
  wire [0:0]E;
  wire \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1] ;
  wire \GEN_AW_PIPE_DUAL.axi_awaddr_full_reg ;
  wire [3:0]Q;
  wire S;
  wire S0_out;
  wire S1_out;
  wire addr_cy_1;
  wire addr_cy_2;
  wire addr_cy_3;
  wire aw_active;
  wire axi_awaddr_full;
  wire \axi_bid_int[3]_i_4_n_0 ;
  wire \axi_bid_int[3]_i_6_n_0 ;
  wire \axi_bid_int_reg[0] ;
  wire axi_wr_burst;
  wire axi_wr_burst_reg;
  wire [3:0]bid_fifo_ld;
  wire bid_fifo_not_empty;
  wire [3:0]bid_fifo_rd;
  wire bid_gets_fifo_load;
  wire bid_gets_fifo_load_d1;
  wire bid_gets_fifo_load_d1_i_3_n_0;
  wire bid_gets_fifo_load_d1_i_4_n_0;
  wire bid_gets_fifo_load_d1_reg;
  wire bram_addr_ld_en;
  wire [2:0]bvalid_cnt;
  wire \bvalid_cnt_reg[0] ;
  wire \bvalid_cnt_reg[2] ;
  wire s_axi_aclk;
  wire [3:0]s_axi_awid;
  wire s_axi_awready;
  wire s_axi_awvalid;
  wire s_axi_bready;
  wire s_axi_wlast;
  wire s_axi_wvalid;
  wire sum_A_0;
  wire sum_A_1;
  wire sum_A_2;
  wire sum_A_3;
  wire [2:0]wr_data_sm_cs;
  wire [3:3]\NLW_Addr_Counters[0].MUXCY_L_I_CARRY4_CO_UNCONNECTED ;
  wire [3:3]\NLW_Addr_Counters[0].MUXCY_L_I_CARRY4_DI_UNCONNECTED ;

  (* BOX_TYPE = "PRIMITIVE" *) 
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0),
    .IS_R_INVERTED(1'b0)) 
    \Addr_Counters[0].FDRE_I 
       (.C(s_axi_aclk),
        .CE(bid_fifo_not_empty),
        .D(sum_A_3),
        .Q(\Addr_Counters[0].FDRE_I_n_0 ),
        .R(Data_Exists_DFF_0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "MLO" *) 
  (* XILINX_LEGACY_PRIM = "(MUXCY,XORCY)" *) 
  (* XILINX_TRANSFORM_PINMAP = "LO:O" *) 
  CARRY4 \Addr_Counters[0].MUXCY_L_I_CARRY4 
       (.CI(1'b0),
        .CO({\NLW_Addr_Counters[0].MUXCY_L_I_CARRY4_CO_UNCONNECTED [3],addr_cy_1,addr_cy_2,addr_cy_3}),
        .CYINIT(\Addr_Counters[0].MUXCY_L_I_i_2_n_0 ),
        .DI({\NLW_Addr_Counters[0].MUXCY_L_I_CARRY4_DI_UNCONNECTED [3],\Addr_Counters[2].FDRE_I_n_0 ,\Addr_Counters[1].FDRE_I_n_0 ,\Addr_Counters[0].FDRE_I_n_0 }),
        .O({sum_A_0,sum_A_1,sum_A_2,sum_A_3}),
        .S({\Addr_Counters[3].XORCY_I_i_1_n_0 ,S0_out,S1_out,S}));
  LUT6 #(
    .INIT(64'h0000000055A6AAAA)) 
    \Addr_Counters[0].MUXCY_L_I_i_1 
       (.I0(\Addr_Counters[0].FDRE_I_n_0 ),
        .I1(axi_wr_burst_reg),
        .I2(\axi_bid_int[3]_i_4_n_0 ),
        .I3(\Addr_Counters[0].MUXCY_L_I_i_3_n_0 ),
        .I4(bid_fifo_not_empty),
        .I5(\Addr_Counters[0].MUXCY_L_I_i_4_n_0 ),
        .O(S));
  LUT6 #(
    .INIT(64'h80888080AAAAAAAA)) 
    \Addr_Counters[0].MUXCY_L_I_i_2 
       (.I0(bram_addr_ld_en),
        .I1(bid_fifo_not_empty),
        .I2(\Addr_Counters[0].MUXCY_L_I_i_3_n_0 ),
        .I3(\axi_bid_int[3]_i_4_n_0 ),
        .I4(axi_wr_burst_reg),
        .I5(\Addr_Counters[0].MUXCY_L_I_i_5_n_0 ),
        .O(\Addr_Counters[0].MUXCY_L_I_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hEAEAEAEAEAEAEAAA)) 
    \Addr_Counters[0].MUXCY_L_I_i_3 
       (.I0(bid_gets_fifo_load_d1),
        .I1(\axi_bid_int_reg[0] ),
        .I2(s_axi_bready),
        .I3(bvalid_cnt[0]),
        .I4(bvalid_cnt[1]),
        .I5(bvalid_cnt[2]),
        .O(\Addr_Counters[0].MUXCY_L_I_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    \Addr_Counters[0].MUXCY_L_I_i_4 
       (.I0(bram_addr_ld_en),
        .I1(\Addr_Counters[2].FDRE_I_n_0 ),
        .I2(\Addr_Counters[0].FDRE_I_n_0 ),
        .I3(\Addr_Counters[3].FDRE_I_n_0 ),
        .I4(\Addr_Counters[1].FDRE_I_n_0 ),
        .O(\Addr_Counters[0].MUXCY_L_I_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT4 #(
    .INIT(16'h8000)) 
    \Addr_Counters[0].MUXCY_L_I_i_5 
       (.I0(\Addr_Counters[0].FDRE_I_n_0 ),
        .I1(\Addr_Counters[2].FDRE_I_n_0 ),
        .I2(\Addr_Counters[1].FDRE_I_n_0 ),
        .I3(\Addr_Counters[3].FDRE_I_n_0 ),
        .O(\Addr_Counters[0].MUXCY_L_I_i_5_n_0 ));
  (* BOX_TYPE = "PRIMITIVE" *) 
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0),
    .IS_R_INVERTED(1'b0)) 
    \Addr_Counters[1].FDRE_I 
       (.C(s_axi_aclk),
        .CE(bid_fifo_not_empty),
        .D(sum_A_2),
        .Q(\Addr_Counters[1].FDRE_I_n_0 ),
        .R(Data_Exists_DFF_0));
  LUT6 #(
    .INIT(64'h0000000055A6AAAA)) 
    \Addr_Counters[1].MUXCY_L_I_i_1 
       (.I0(\Addr_Counters[1].FDRE_I_n_0 ),
        .I1(axi_wr_burst_reg),
        .I2(\axi_bid_int[3]_i_4_n_0 ),
        .I3(\Addr_Counters[0].MUXCY_L_I_i_3_n_0 ),
        .I4(bid_fifo_not_empty),
        .I5(\Addr_Counters[0].MUXCY_L_I_i_4_n_0 ),
        .O(S1_out));
  (* BOX_TYPE = "PRIMITIVE" *) 
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0),
    .IS_R_INVERTED(1'b0)) 
    \Addr_Counters[2].FDRE_I 
       (.C(s_axi_aclk),
        .CE(bid_fifo_not_empty),
        .D(sum_A_1),
        .Q(\Addr_Counters[2].FDRE_I_n_0 ),
        .R(Data_Exists_DFF_0));
  LUT6 #(
    .INIT(64'h0000000055A6AAAA)) 
    \Addr_Counters[2].MUXCY_L_I_i_1 
       (.I0(\Addr_Counters[2].FDRE_I_n_0 ),
        .I1(axi_wr_burst_reg),
        .I2(\axi_bid_int[3]_i_4_n_0 ),
        .I3(\Addr_Counters[0].MUXCY_L_I_i_3_n_0 ),
        .I4(bid_fifo_not_empty),
        .I5(\Addr_Counters[0].MUXCY_L_I_i_4_n_0 ),
        .O(S0_out));
  (* BOX_TYPE = "PRIMITIVE" *) 
  FDRE #(
    .INIT(1'b0),
    .IS_C_INVERTED(1'b0),
    .IS_D_INVERTED(1'b0),
    .IS_R_INVERTED(1'b0)) 
    \Addr_Counters[3].FDRE_I 
       (.C(s_axi_aclk),
        .CE(bid_fifo_not_empty),
        .D(sum_A_0),
        .Q(\Addr_Counters[3].FDRE_I_n_0 ),
        .R(Data_Exists_DFF_0));
  LUT6 #(
    .INIT(64'h0000000055A6AAAA)) 
    \Addr_Counters[3].XORCY_I_i_1 
       (.I0(\Addr_Counters[3].FDRE_I_n_0 ),
        .I1(axi_wr_burst_reg),
        .I2(\axi_bid_int[3]_i_4_n_0 ),
        .I3(\Addr_Counters[0].MUXCY_L_I_i_3_n_0 ),
        .I4(bid_fifo_not_empty),
        .I5(\Addr_Counters[0].MUXCY_L_I_i_4_n_0 ),
        .O(\Addr_Counters[3].XORCY_I_i_1_n_0 ));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* XILINX_LEGACY_PRIM = "FDR" *) 
  FDRE #(
    .INIT(1'b0)) 
    Data_Exists_DFF
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(D_0),
        .Q(bid_fifo_not_empty),
        .R(Data_Exists_DFF_0));
  LUT6 #(
    .INIT(64'hFFFFFFFF000000A2)) 
    Data_Exists_DFF_i_1
       (.I0(bid_fifo_not_empty),
        .I1(axi_wr_burst_reg),
        .I2(\axi_bid_int[3]_i_4_n_0 ),
        .I3(\bvalid_cnt_reg[2] ),
        .I4(bid_gets_fifo_load_d1),
        .I5(Data_Exists_DFF_i_2_n_0),
        .O(D_0));
  LUT6 #(
    .INIT(64'hAAAAAAABAAAAAAA8)) 
    Data_Exists_DFF_i_2
       (.I0(bid_fifo_not_empty),
        .I1(\Addr_Counters[1].FDRE_I_n_0 ),
        .I2(\Addr_Counters[3].FDRE_I_n_0 ),
        .I3(\Addr_Counters[0].FDRE_I_n_0 ),
        .I4(\Addr_Counters[2].FDRE_I_n_0 ),
        .I5(bram_addr_ld_en),
        .O(Data_Exists_DFF_i_2_n_0));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* srl_bus_name = "U0/\gext_inst.abcv4_0_ext_inst/GEN_AXI4.I_FULL_AXI/I_WR_CHNL/BID_FIFO/FIFO_RAM " *) 
  (* srl_name = "U0/\gext_inst.abcv4_0_ext_inst/GEN_AXI4.I_FULL_AXI/I_WR_CHNL/BID_FIFO/FIFO_RAM[0].SRL16E_I " *) 
  SRL16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \FIFO_RAM[0].SRL16E_I 
       (.A0(\Addr_Counters[0].FDRE_I_n_0 ),
        .A1(\Addr_Counters[1].FDRE_I_n_0 ),
        .A2(\Addr_Counters[2].FDRE_I_n_0 ),
        .A3(\Addr_Counters[3].FDRE_I_n_0 ),
        .CE(\Addr_Counters[0].MUXCY_L_I_i_2_n_0 ),
        .CLK(s_axi_aclk),
        .D(bid_fifo_ld[3]),
        .Q(bid_fifo_rd[3]));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \FIFO_RAM[0].SRL16E_I_i_1 
       (.I0(Q[3]),
        .I1(axi_awaddr_full),
        .I2(s_axi_awid[3]),
        .O(bid_fifo_ld[3]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* srl_bus_name = "U0/\gext_inst.abcv4_0_ext_inst/GEN_AXI4.I_FULL_AXI/I_WR_CHNL/BID_FIFO/FIFO_RAM " *) 
  (* srl_name = "U0/\gext_inst.abcv4_0_ext_inst/GEN_AXI4.I_FULL_AXI/I_WR_CHNL/BID_FIFO/FIFO_RAM[1].SRL16E_I " *) 
  SRL16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \FIFO_RAM[1].SRL16E_I 
       (.A0(\Addr_Counters[0].FDRE_I_n_0 ),
        .A1(\Addr_Counters[1].FDRE_I_n_0 ),
        .A2(\Addr_Counters[2].FDRE_I_n_0 ),
        .A3(\Addr_Counters[3].FDRE_I_n_0 ),
        .CE(\Addr_Counters[0].MUXCY_L_I_i_2_n_0 ),
        .CLK(s_axi_aclk),
        .D(bid_fifo_ld[2]),
        .Q(bid_fifo_rd[2]));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \FIFO_RAM[1].SRL16E_I_i_1 
       (.I0(Q[2]),
        .I1(axi_awaddr_full),
        .I2(s_axi_awid[2]),
        .O(bid_fifo_ld[2]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* srl_bus_name = "U0/\gext_inst.abcv4_0_ext_inst/GEN_AXI4.I_FULL_AXI/I_WR_CHNL/BID_FIFO/FIFO_RAM " *) 
  (* srl_name = "U0/\gext_inst.abcv4_0_ext_inst/GEN_AXI4.I_FULL_AXI/I_WR_CHNL/BID_FIFO/FIFO_RAM[2].SRL16E_I " *) 
  SRL16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \FIFO_RAM[2].SRL16E_I 
       (.A0(\Addr_Counters[0].FDRE_I_n_0 ),
        .A1(\Addr_Counters[1].FDRE_I_n_0 ),
        .A2(\Addr_Counters[2].FDRE_I_n_0 ),
        .A3(\Addr_Counters[3].FDRE_I_n_0 ),
        .CE(\Addr_Counters[0].MUXCY_L_I_i_2_n_0 ),
        .CLK(s_axi_aclk),
        .D(bid_fifo_ld[1]),
        .Q(bid_fifo_rd[1]));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \FIFO_RAM[2].SRL16E_I_i_1 
       (.I0(Q[1]),
        .I1(axi_awaddr_full),
        .I2(s_axi_awid[1]),
        .O(bid_fifo_ld[1]));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* srl_bus_name = "U0/\gext_inst.abcv4_0_ext_inst/GEN_AXI4.I_FULL_AXI/I_WR_CHNL/BID_FIFO/FIFO_RAM " *) 
  (* srl_name = "U0/\gext_inst.abcv4_0_ext_inst/GEN_AXI4.I_FULL_AXI/I_WR_CHNL/BID_FIFO/FIFO_RAM[3].SRL16E_I " *) 
  SRL16E #(
    .INIT(16'h0000),
    .IS_CLK_INVERTED(1'b0)) 
    \FIFO_RAM[3].SRL16E_I 
       (.A0(\Addr_Counters[0].FDRE_I_n_0 ),
        .A1(\Addr_Counters[1].FDRE_I_n_0 ),
        .A2(\Addr_Counters[2].FDRE_I_n_0 ),
        .A3(\Addr_Counters[3].FDRE_I_n_0 ),
        .CE(\Addr_Counters[0].MUXCY_L_I_i_2_n_0 ),
        .CLK(s_axi_aclk),
        .D(bid_fifo_ld[0]),
        .Q(bid_fifo_rd[0]));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \FIFO_RAM[3].SRL16E_I_i_1 
       (.I0(Q[0]),
        .I1(axi_awaddr_full),
        .I2(s_axi_awid[0]),
        .O(bid_fifo_ld[0]));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT4 #(
    .INIT(16'h0200)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_5 
       (.I0(wr_data_sm_cs[1]),
        .I1(wr_data_sm_cs[2]),
        .I2(wr_data_sm_cs[0]),
        .I3(s_axi_wvalid),
        .O(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1] ));
  LUT3 #(
    .INIT(8'hF8)) 
    \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.axi_wdata_full_reg_i_3 
       (.I0(bram_addr_ld_en),
        .I1(axi_awaddr_full),
        .I2(\bvalid_cnt_reg[0] ),
        .O(\GEN_AW_PIPE_DUAL.axi_awaddr_full_reg ));
  LUT6 #(
    .INIT(64'h7F7F7F7F7F000000)) 
    \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.bram_en_int_i_3 
       (.I0(bvalid_cnt[0]),
        .I1(bvalid_cnt[2]),
        .I2(bvalid_cnt[1]),
        .I3(s_axi_awvalid),
        .I4(s_axi_awready),
        .I5(aw_active),
        .O(\bvalid_cnt_reg[0] ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \axi_bid_int[0]_i_1 
       (.I0(Q[0]),
        .I1(axi_awaddr_full),
        .I2(s_axi_awid[0]),
        .I3(bid_gets_fifo_load),
        .I4(bid_fifo_rd[0]),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \axi_bid_int[1]_i_1 
       (.I0(Q[1]),
        .I1(axi_awaddr_full),
        .I2(s_axi_awid[1]),
        .I3(bid_gets_fifo_load),
        .I4(bid_fifo_rd[1]),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \axi_bid_int[2]_i_1 
       (.I0(Q[2]),
        .I1(axi_awaddr_full),
        .I2(s_axi_awid[2]),
        .I3(bid_gets_fifo_load),
        .I4(bid_fifo_rd[2]),
        .O(D[2]));
  LUT6 #(
    .INIT(64'hFFFFFFAEAAAAAAAA)) 
    \axi_bid_int[3]_i_1 
       (.I0(bid_gets_fifo_load),
        .I1(axi_wr_burst_reg),
        .I2(\axi_bid_int[3]_i_4_n_0 ),
        .I3(\bvalid_cnt_reg[2] ),
        .I4(bid_gets_fifo_load_d1),
        .I5(bid_fifo_not_empty),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT5 #(
    .INIT(32'hB8FFB800)) 
    \axi_bid_int[3]_i_2 
       (.I0(Q[3]),
        .I1(axi_awaddr_full),
        .I2(s_axi_awid[3]),
        .I3(bid_gets_fifo_load),
        .I4(bid_fifo_rd[3]),
        .O(D[3]));
  LUT6 #(
    .INIT(64'hFFFFFF1010101010)) 
    \axi_bid_int[3]_i_3 
       (.I0(axi_wr_burst),
        .I1(bid_gets_fifo_load_d1_i_3_n_0),
        .I2(\GEN_AW_PIPE_DUAL.axi_awaddr_full_reg ),
        .I3(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1] ),
        .I4(\axi_bid_int[3]_i_6_n_0 ),
        .I5(s_axi_wlast),
        .O(axi_wr_burst_reg));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT3 #(
    .INIT(8'hFE)) 
    \axi_bid_int[3]_i_4 
       (.I0(bvalid_cnt[0]),
        .I1(bvalid_cnt[1]),
        .I2(bvalid_cnt[2]),
        .O(\axi_bid_int[3]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT5 #(
    .INIT(32'hFE000000)) 
    \axi_bid_int[3]_i_5 
       (.I0(bvalid_cnt[2]),
        .I1(bvalid_cnt[1]),
        .I2(bvalid_cnt[0]),
        .I3(s_axi_bready),
        .I4(\axi_bid_int_reg[0] ),
        .O(\bvalid_cnt_reg[2] ));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT4 #(
    .INIT(16'h1000)) 
    \axi_bid_int[3]_i_6 
       (.I0(wr_data_sm_cs[2]),
        .I1(wr_data_sm_cs[0]),
        .I2(s_axi_wvalid),
        .I3(\bvalid_cnt_reg[0] ),
        .O(\axi_bid_int[3]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'hAAAE000000000000)) 
    bid_gets_fifo_load_d1_i_1
       (.I0(bid_gets_fifo_load_d1_reg),
        .I1(\GEN_AW_PIPE_DUAL.axi_awaddr_full_reg ),
        .I2(bid_gets_fifo_load_d1_i_3_n_0),
        .I3(axi_wr_burst),
        .I4(bid_gets_fifo_load_d1_i_4_n_0),
        .I5(bram_addr_ld_en),
        .O(bid_gets_fifo_load));
  LUT3 #(
    .INIT(8'hFB)) 
    bid_gets_fifo_load_d1_i_3
       (.I0(wr_data_sm_cs[1]),
        .I1(wr_data_sm_cs[0]),
        .I2(wr_data_sm_cs[2]),
        .O(bid_gets_fifo_load_d1_i_3_n_0));
  LUT6 #(
    .INIT(64'h0100000011111111)) 
    bid_gets_fifo_load_d1_i_4
       (.I0(bvalid_cnt[1]),
        .I1(bvalid_cnt[2]),
        .I2(bid_fifo_not_empty),
        .I3(s_axi_bready),
        .I4(\axi_bid_int_reg[0] ),
        .I5(bvalid_cnt[0]),
        .O(bid_gets_fifo_load_d1_i_4_n_0));
endmodule

(* C_BRAM_ADDR_WIDTH = "11" *) (* C_BRAM_INST_MODE = "EXTERNAL" *) (* C_ECC = "0" *) 
(* C_ECC_ONOFF_RESET_VALUE = "0" *) (* C_ECC_TYPE = "0" *) (* C_FAMILY = "virtex7" *) 
(* C_FAULT_INJECT = "0" *) (* C_MEMORY_DEPTH = "2048" *) (* C_RD_CMD_OPTIMIZATION = "1" *) 
(* C_READ_LATENCY = "1" *) (* C_SINGLE_PORT_BRAM = "0" *) (* C_S_AXI_ADDR_WIDTH = "14" *) 
(* C_S_AXI_CTRL_ADDR_WIDTH = "32" *) (* C_S_AXI_CTRL_DATA_WIDTH = "32" *) (* C_S_AXI_DATA_WIDTH = "64" *) 
(* C_S_AXI_ID_WIDTH = "4" *) (* C_S_AXI_PROTOCOL = "AXI4" *) (* C_S_AXI_SUPPORTS_NARROW_BURST = "0" *) 
(* ORIG_REF_NAME = "axi_bram_ctrl" *) (* downgradeipidentifiedwarnings = "yes" *) 
module axi64_bram_ctrl_16KiB_axi_bram_ctrl
   (s_axi_aclk,
    s_axi_aresetn,
    ecc_interrupt,
    ecc_ue,
    s_axi_awid,
    s_axi_awaddr,
    s_axi_awlen,
    s_axi_awsize,
    s_axi_awburst,
    s_axi_awlock,
    s_axi_awcache,
    s_axi_awprot,
    s_axi_awvalid,
    s_axi_awready,
    s_axi_wdata,
    s_axi_wstrb,
    s_axi_wlast,
    s_axi_wvalid,
    s_axi_wready,
    s_axi_bid,
    s_axi_bresp,
    s_axi_bvalid,
    s_axi_bready,
    s_axi_arid,
    s_axi_araddr,
    s_axi_arlen,
    s_axi_arsize,
    s_axi_arburst,
    s_axi_arlock,
    s_axi_arcache,
    s_axi_arprot,
    s_axi_arvalid,
    s_axi_arready,
    s_axi_rid,
    s_axi_rdata,
    s_axi_rresp,
    s_axi_rlast,
    s_axi_rvalid,
    s_axi_rready,
    s_axi_ctrl_awvalid,
    s_axi_ctrl_awready,
    s_axi_ctrl_awaddr,
    s_axi_ctrl_wdata,
    s_axi_ctrl_wvalid,
    s_axi_ctrl_wready,
    s_axi_ctrl_bresp,
    s_axi_ctrl_bvalid,
    s_axi_ctrl_bready,
    s_axi_ctrl_araddr,
    s_axi_ctrl_arvalid,
    s_axi_ctrl_arready,
    s_axi_ctrl_rdata,
    s_axi_ctrl_rresp,
    s_axi_ctrl_rvalid,
    s_axi_ctrl_rready,
    bram_rst_a,
    bram_clk_a,
    bram_en_a,
    bram_we_a,
    bram_addr_a,
    bram_wrdata_a,
    bram_rddata_a,
    bram_rst_b,
    bram_clk_b,
    bram_en_b,
    bram_we_b,
    bram_addr_b,
    bram_wrdata_b,
    bram_rddata_b);
  input s_axi_aclk;
  input s_axi_aresetn;
  output ecc_interrupt;
  output ecc_ue;
  input [3:0]s_axi_awid;
  input [13:0]s_axi_awaddr;
  input [7:0]s_axi_awlen;
  input [2:0]s_axi_awsize;
  input [1:0]s_axi_awburst;
  input s_axi_awlock;
  input [3:0]s_axi_awcache;
  input [2:0]s_axi_awprot;
  input s_axi_awvalid;
  output s_axi_awready;
  input [63:0]s_axi_wdata;
  input [7:0]s_axi_wstrb;
  input s_axi_wlast;
  input s_axi_wvalid;
  output s_axi_wready;
  output [3:0]s_axi_bid;
  output [1:0]s_axi_bresp;
  output s_axi_bvalid;
  input s_axi_bready;
  input [3:0]s_axi_arid;
  input [13:0]s_axi_araddr;
  input [7:0]s_axi_arlen;
  input [2:0]s_axi_arsize;
  input [1:0]s_axi_arburst;
  input s_axi_arlock;
  input [3:0]s_axi_arcache;
  input [2:0]s_axi_arprot;
  input s_axi_arvalid;
  output s_axi_arready;
  output [3:0]s_axi_rid;
  output [63:0]s_axi_rdata;
  output [1:0]s_axi_rresp;
  output s_axi_rlast;
  output s_axi_rvalid;
  input s_axi_rready;
  input s_axi_ctrl_awvalid;
  output s_axi_ctrl_awready;
  input [31:0]s_axi_ctrl_awaddr;
  input [31:0]s_axi_ctrl_wdata;
  input s_axi_ctrl_wvalid;
  output s_axi_ctrl_wready;
  output [1:0]s_axi_ctrl_bresp;
  output s_axi_ctrl_bvalid;
  input s_axi_ctrl_bready;
  input [31:0]s_axi_ctrl_araddr;
  input s_axi_ctrl_arvalid;
  output s_axi_ctrl_arready;
  output [31:0]s_axi_ctrl_rdata;
  output [1:0]s_axi_ctrl_rresp;
  output s_axi_ctrl_rvalid;
  input s_axi_ctrl_rready;
  output bram_rst_a;
  output bram_clk_a;
  output bram_en_a;
  output [7:0]bram_we_a;
  output [13:0]bram_addr_a;
  output [63:0]bram_wrdata_a;
  input [63:0]bram_rddata_a;
  output bram_rst_b;
  output bram_clk_b;
  output bram_en_b;
  output [7:0]bram_we_b;
  output [13:0]bram_addr_b;
  output [63:0]bram_wrdata_b;
  input [63:0]bram_rddata_b;

  wire \<const0> ;
  wire [13:3]\^bram_addr_a ;
  wire [13:3]\^bram_addr_b ;
  wire bram_en_a;
  wire bram_en_b;
  wire [63:0]bram_rddata_b;
  wire bram_rst_b;
  wire [7:0]bram_we_a;
  wire [63:0]bram_wrdata_a;
  wire s_axi_aclk;
  wire [13:0]s_axi_araddr;
  wire [1:0]s_axi_arburst;
  wire s_axi_aresetn;
  wire [3:0]s_axi_arid;
  wire [7:0]s_axi_arlen;
  wire s_axi_arready;
  wire s_axi_arvalid;
  wire [13:0]s_axi_awaddr;
  wire [1:0]s_axi_awburst;
  wire [3:0]s_axi_awid;
  wire [7:0]s_axi_awlen;
  wire s_axi_awready;
  wire s_axi_awvalid;
  wire [3:0]s_axi_bid;
  wire s_axi_bready;
  wire s_axi_bvalid;
  wire [3:0]s_axi_rid;
  wire s_axi_rlast;
  wire s_axi_rready;
  wire s_axi_rvalid;
  wire [63:0]s_axi_wdata;
  wire s_axi_wlast;
  wire s_axi_wready;
  wire [7:0]s_axi_wstrb;
  wire s_axi_wvalid;

  assign bram_addr_a[13:3] = \^bram_addr_a [13:3];
  assign bram_addr_a[2] = \<const0> ;
  assign bram_addr_a[1] = \<const0> ;
  assign bram_addr_a[0] = \<const0> ;
  assign bram_addr_b[13:3] = \^bram_addr_b [13:3];
  assign bram_addr_b[2] = \<const0> ;
  assign bram_addr_b[1] = \<const0> ;
  assign bram_addr_b[0] = \<const0> ;
  assign bram_clk_a = s_axi_aclk;
  assign bram_clk_b = s_axi_aclk;
  assign bram_rst_a = bram_rst_b;
  assign bram_we_b[7] = \<const0> ;
  assign bram_we_b[6] = \<const0> ;
  assign bram_we_b[5] = \<const0> ;
  assign bram_we_b[4] = \<const0> ;
  assign bram_we_b[3] = \<const0> ;
  assign bram_we_b[2] = \<const0> ;
  assign bram_we_b[1] = \<const0> ;
  assign bram_we_b[0] = \<const0> ;
  assign bram_wrdata_b[63] = \<const0> ;
  assign bram_wrdata_b[62] = \<const0> ;
  assign bram_wrdata_b[61] = \<const0> ;
  assign bram_wrdata_b[60] = \<const0> ;
  assign bram_wrdata_b[59] = \<const0> ;
  assign bram_wrdata_b[58] = \<const0> ;
  assign bram_wrdata_b[57] = \<const0> ;
  assign bram_wrdata_b[56] = \<const0> ;
  assign bram_wrdata_b[55] = \<const0> ;
  assign bram_wrdata_b[54] = \<const0> ;
  assign bram_wrdata_b[53] = \<const0> ;
  assign bram_wrdata_b[52] = \<const0> ;
  assign bram_wrdata_b[51] = \<const0> ;
  assign bram_wrdata_b[50] = \<const0> ;
  assign bram_wrdata_b[49] = \<const0> ;
  assign bram_wrdata_b[48] = \<const0> ;
  assign bram_wrdata_b[47] = \<const0> ;
  assign bram_wrdata_b[46] = \<const0> ;
  assign bram_wrdata_b[45] = \<const0> ;
  assign bram_wrdata_b[44] = \<const0> ;
  assign bram_wrdata_b[43] = \<const0> ;
  assign bram_wrdata_b[42] = \<const0> ;
  assign bram_wrdata_b[41] = \<const0> ;
  assign bram_wrdata_b[40] = \<const0> ;
  assign bram_wrdata_b[39] = \<const0> ;
  assign bram_wrdata_b[38] = \<const0> ;
  assign bram_wrdata_b[37] = \<const0> ;
  assign bram_wrdata_b[36] = \<const0> ;
  assign bram_wrdata_b[35] = \<const0> ;
  assign bram_wrdata_b[34] = \<const0> ;
  assign bram_wrdata_b[33] = \<const0> ;
  assign bram_wrdata_b[32] = \<const0> ;
  assign bram_wrdata_b[31] = \<const0> ;
  assign bram_wrdata_b[30] = \<const0> ;
  assign bram_wrdata_b[29] = \<const0> ;
  assign bram_wrdata_b[28] = \<const0> ;
  assign bram_wrdata_b[27] = \<const0> ;
  assign bram_wrdata_b[26] = \<const0> ;
  assign bram_wrdata_b[25] = \<const0> ;
  assign bram_wrdata_b[24] = \<const0> ;
  assign bram_wrdata_b[23] = \<const0> ;
  assign bram_wrdata_b[22] = \<const0> ;
  assign bram_wrdata_b[21] = \<const0> ;
  assign bram_wrdata_b[20] = \<const0> ;
  assign bram_wrdata_b[19] = \<const0> ;
  assign bram_wrdata_b[18] = \<const0> ;
  assign bram_wrdata_b[17] = \<const0> ;
  assign bram_wrdata_b[16] = \<const0> ;
  assign bram_wrdata_b[15] = \<const0> ;
  assign bram_wrdata_b[14] = \<const0> ;
  assign bram_wrdata_b[13] = \<const0> ;
  assign bram_wrdata_b[12] = \<const0> ;
  assign bram_wrdata_b[11] = \<const0> ;
  assign bram_wrdata_b[10] = \<const0> ;
  assign bram_wrdata_b[9] = \<const0> ;
  assign bram_wrdata_b[8] = \<const0> ;
  assign bram_wrdata_b[7] = \<const0> ;
  assign bram_wrdata_b[6] = \<const0> ;
  assign bram_wrdata_b[5] = \<const0> ;
  assign bram_wrdata_b[4] = \<const0> ;
  assign bram_wrdata_b[3] = \<const0> ;
  assign bram_wrdata_b[2] = \<const0> ;
  assign bram_wrdata_b[1] = \<const0> ;
  assign bram_wrdata_b[0] = \<const0> ;
  assign ecc_interrupt = \<const0> ;
  assign ecc_ue = \<const0> ;
  assign s_axi_bresp[1] = \<const0> ;
  assign s_axi_bresp[0] = \<const0> ;
  assign s_axi_ctrl_arready = \<const0> ;
  assign s_axi_ctrl_awready = \<const0> ;
  assign s_axi_ctrl_bresp[1] = \<const0> ;
  assign s_axi_ctrl_bresp[0] = \<const0> ;
  assign s_axi_ctrl_bvalid = \<const0> ;
  assign s_axi_ctrl_rdata[31] = \<const0> ;
  assign s_axi_ctrl_rdata[30] = \<const0> ;
  assign s_axi_ctrl_rdata[29] = \<const0> ;
  assign s_axi_ctrl_rdata[28] = \<const0> ;
  assign s_axi_ctrl_rdata[27] = \<const0> ;
  assign s_axi_ctrl_rdata[26] = \<const0> ;
  assign s_axi_ctrl_rdata[25] = \<const0> ;
  assign s_axi_ctrl_rdata[24] = \<const0> ;
  assign s_axi_ctrl_rdata[23] = \<const0> ;
  assign s_axi_ctrl_rdata[22] = \<const0> ;
  assign s_axi_ctrl_rdata[21] = \<const0> ;
  assign s_axi_ctrl_rdata[20] = \<const0> ;
  assign s_axi_ctrl_rdata[19] = \<const0> ;
  assign s_axi_ctrl_rdata[18] = \<const0> ;
  assign s_axi_ctrl_rdata[17] = \<const0> ;
  assign s_axi_ctrl_rdata[16] = \<const0> ;
  assign s_axi_ctrl_rdata[15] = \<const0> ;
  assign s_axi_ctrl_rdata[14] = \<const0> ;
  assign s_axi_ctrl_rdata[13] = \<const0> ;
  assign s_axi_ctrl_rdata[12] = \<const0> ;
  assign s_axi_ctrl_rdata[11] = \<const0> ;
  assign s_axi_ctrl_rdata[10] = \<const0> ;
  assign s_axi_ctrl_rdata[9] = \<const0> ;
  assign s_axi_ctrl_rdata[8] = \<const0> ;
  assign s_axi_ctrl_rdata[7] = \<const0> ;
  assign s_axi_ctrl_rdata[6] = \<const0> ;
  assign s_axi_ctrl_rdata[5] = \<const0> ;
  assign s_axi_ctrl_rdata[4] = \<const0> ;
  assign s_axi_ctrl_rdata[3] = \<const0> ;
  assign s_axi_ctrl_rdata[2] = \<const0> ;
  assign s_axi_ctrl_rdata[1] = \<const0> ;
  assign s_axi_ctrl_rdata[0] = \<const0> ;
  assign s_axi_ctrl_rresp[1] = \<const0> ;
  assign s_axi_ctrl_rresp[0] = \<const0> ;
  assign s_axi_ctrl_rvalid = \<const0> ;
  assign s_axi_ctrl_wready = \<const0> ;
  assign s_axi_rdata[63:0] = bram_rddata_b;
  assign s_axi_rresp[1] = \<const0> ;
  assign s_axi_rresp[0] = \<const0> ;
  GND GND
       (.G(\<const0> ));
  axi64_bram_ctrl_16KiB_axi_bram_ctrl_top \gext_inst.abcv4_0_ext_inst 
       (.\GEN_RD_CMD_OPT.wrap_addr_assign_reg (\^bram_addr_b [5]),
        .Q(\^bram_addr_a [11:3]),
        .S_AXI_RVALID(s_axi_rvalid),
        .axi_bvalid_int_reg(s_axi_bvalid),
        .bram_addr_a(\^bram_addr_a [13:12]),
        .bram_addr_b({\^bram_addr_b [13:6],\^bram_addr_b [3]}),
        .bram_en_a(bram_en_a),
        .bram_en_b(bram_en_b),
        .bram_we_a(bram_we_a),
        .bram_wrdata_a(bram_wrdata_a),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_araddr(s_axi_araddr[13:3]),
        .s_axi_arburst(s_axi_arburst),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_aresetn_0(bram_rst_b),
        .s_axi_arid(s_axi_arid),
        .s_axi_arlen(s_axi_arlen),
        .s_axi_arready(s_axi_arready),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr(s_axi_awaddr[13:3]),
        .s_axi_awburst(s_axi_awburst),
        .s_axi_awid(s_axi_awid),
        .s_axi_awlen(s_axi_awlen),
        .s_axi_awready(s_axi_awready),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bid(s_axi_bid),
        .s_axi_bready(s_axi_bready),
        .s_axi_rid(s_axi_rid),
        .s_axi_rlast(s_axi_rlast),
        .s_axi_rready(s_axi_rready),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wlast(s_axi_wlast),
        .s_axi_wready(s_axi_wready),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid),
        .\wrap_burst_total_reg_reg[1] (\^bram_addr_b [4]));
endmodule

(* ORIG_REF_NAME = "axi_bram_ctrl_top" *) 
module axi64_bram_ctrl_16KiB_axi_bram_ctrl_top
   (S_AXI_RVALID,
    \GEN_RD_CMD_OPT.wrap_addr_assign_reg ,
    \wrap_burst_total_reg_reg[1] ,
    Q,
    s_axi_aresetn_0,
    bram_addr_a,
    axi_bvalid_int_reg,
    s_axi_bid,
    bram_en_a,
    bram_we_a,
    bram_wrdata_a,
    bram_addr_b,
    s_axi_rid,
    s_axi_awready,
    s_axi_wready,
    bram_en_b,
    s_axi_rlast,
    s_axi_arready,
    s_axi_wvalid,
    s_axi_aresetn,
    s_axi_rready,
    s_axi_arlen,
    s_axi_aclk,
    s_axi_wlast,
    s_axi_awaddr,
    s_axi_bready,
    s_axi_awlen,
    s_axi_awid,
    s_axi_wstrb,
    s_axi_awburst,
    s_axi_wdata,
    s_axi_araddr,
    s_axi_arvalid,
    s_axi_arid,
    s_axi_awvalid,
    s_axi_arburst);
  output S_AXI_RVALID;
  output \GEN_RD_CMD_OPT.wrap_addr_assign_reg ;
  output \wrap_burst_total_reg_reg[1] ;
  output [8:0]Q;
  output s_axi_aresetn_0;
  output [1:0]bram_addr_a;
  output axi_bvalid_int_reg;
  output [3:0]s_axi_bid;
  output bram_en_a;
  output [7:0]bram_we_a;
  output [63:0]bram_wrdata_a;
  output [8:0]bram_addr_b;
  output [3:0]s_axi_rid;
  output s_axi_awready;
  output s_axi_wready;
  output bram_en_b;
  output s_axi_rlast;
  output s_axi_arready;
  input s_axi_wvalid;
  input s_axi_aresetn;
  input s_axi_rready;
  input [7:0]s_axi_arlen;
  input s_axi_aclk;
  input s_axi_wlast;
  input [10:0]s_axi_awaddr;
  input s_axi_bready;
  input [7:0]s_axi_awlen;
  input [3:0]s_axi_awid;
  input [7:0]s_axi_wstrb;
  input [1:0]s_axi_awburst;
  input [63:0]s_axi_wdata;
  input [10:0]s_axi_araddr;
  input s_axi_arvalid;
  input [3:0]s_axi_arid;
  input s_axi_awvalid;
  input [1:0]s_axi_arburst;

  wire \GEN_RD_CMD_OPT.wrap_addr_assign_reg ;
  wire [8:0]Q;
  wire S_AXI_RVALID;
  wire axi_bvalid_int_reg;
  wire [1:0]bram_addr_a;
  wire [8:0]bram_addr_b;
  wire bram_en_a;
  wire bram_en_b;
  wire [7:0]bram_we_a;
  wire [63:0]bram_wrdata_a;
  wire s_axi_aclk;
  wire [10:0]s_axi_araddr;
  wire [1:0]s_axi_arburst;
  wire s_axi_aresetn;
  wire s_axi_aresetn_0;
  wire [3:0]s_axi_arid;
  wire [7:0]s_axi_arlen;
  wire s_axi_arready;
  wire s_axi_arvalid;
  wire [10:0]s_axi_awaddr;
  wire [1:0]s_axi_awburst;
  wire [3:0]s_axi_awid;
  wire [7:0]s_axi_awlen;
  wire s_axi_awready;
  wire s_axi_awvalid;
  wire [3:0]s_axi_bid;
  wire s_axi_bready;
  wire [3:0]s_axi_rid;
  wire s_axi_rlast;
  wire s_axi_rready;
  wire [63:0]s_axi_wdata;
  wire s_axi_wlast;
  wire s_axi_wready;
  wire [7:0]s_axi_wstrb;
  wire s_axi_wvalid;
  wire \wrap_burst_total_reg_reg[1] ;

  axi64_bram_ctrl_16KiB_full_axi \GEN_AXI4.I_FULL_AXI 
       (.BRAM_Addr_A(Q),
        .\GEN_RD_CMD_OPT.wrap_addr_assign_reg (\GEN_RD_CMD_OPT.wrap_addr_assign_reg ),
        .SR(s_axi_aresetn_0),
        .S_AXI_RVALID(S_AXI_RVALID),
        .axi_bvalid_int_reg(axi_bvalid_int_reg),
        .bram_addr_a(bram_addr_a),
        .bram_addr_b(bram_addr_b),
        .bram_en_a(bram_en_a),
        .bram_en_b(bram_en_b),
        .bram_we_a(bram_we_a),
        .bram_wrdata_a(bram_wrdata_a),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_arburst(s_axi_arburst),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_arid(s_axi_arid),
        .s_axi_arlen(s_axi_arlen),
        .s_axi_arready(s_axi_arready),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awburst(s_axi_awburst),
        .s_axi_awid(s_axi_awid),
        .s_axi_awlen(s_axi_awlen),
        .s_axi_awready(s_axi_awready),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bid(s_axi_bid),
        .s_axi_bready(s_axi_bready),
        .s_axi_rid(s_axi_rid),
        .s_axi_rlast(s_axi_rlast),
        .s_axi_rready(s_axi_rready),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wlast(s_axi_wlast),
        .s_axi_wready(s_axi_wready),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid),
        .\wrap_burst_total_reg_reg[1] (\wrap_burst_total_reg_reg[1] ));
endmodule

(* ORIG_REF_NAME = "full_axi" *) 
module axi64_bram_ctrl_16KiB_full_axi
   (S_AXI_RVALID,
    \GEN_RD_CMD_OPT.wrap_addr_assign_reg ,
    \wrap_burst_total_reg_reg[1] ,
    BRAM_Addr_A,
    SR,
    bram_addr_a,
    axi_bvalid_int_reg,
    s_axi_bid,
    bram_en_a,
    bram_we_a,
    bram_wrdata_a,
    bram_addr_b,
    s_axi_rid,
    s_axi_awready,
    s_axi_wready,
    bram_en_b,
    s_axi_rlast,
    s_axi_arready,
    s_axi_wvalid,
    s_axi_aresetn,
    s_axi_rready,
    s_axi_arlen,
    s_axi_aclk,
    s_axi_wlast,
    s_axi_awaddr,
    s_axi_bready,
    s_axi_awlen,
    s_axi_awid,
    s_axi_wstrb,
    s_axi_awburst,
    s_axi_wdata,
    s_axi_araddr,
    s_axi_arvalid,
    s_axi_arid,
    s_axi_awvalid,
    s_axi_arburst);
  output S_AXI_RVALID;
  output \GEN_RD_CMD_OPT.wrap_addr_assign_reg ;
  output \wrap_burst_total_reg_reg[1] ;
  output [8:0]BRAM_Addr_A;
  output [0:0]SR;
  output [1:0]bram_addr_a;
  output axi_bvalid_int_reg;
  output [3:0]s_axi_bid;
  output bram_en_a;
  output [7:0]bram_we_a;
  output [63:0]bram_wrdata_a;
  output [8:0]bram_addr_b;
  output [3:0]s_axi_rid;
  output s_axi_awready;
  output s_axi_wready;
  output bram_en_b;
  output s_axi_rlast;
  output s_axi_arready;
  input s_axi_wvalid;
  input s_axi_aresetn;
  input s_axi_rready;
  input [7:0]s_axi_arlen;
  input s_axi_aclk;
  input s_axi_wlast;
  input [10:0]s_axi_awaddr;
  input s_axi_bready;
  input [7:0]s_axi_awlen;
  input [3:0]s_axi_awid;
  input [7:0]s_axi_wstrb;
  input [1:0]s_axi_awburst;
  input [63:0]s_axi_wdata;
  input [10:0]s_axi_araddr;
  input s_axi_arvalid;
  input [3:0]s_axi_arid;
  input s_axi_awvalid;
  input [1:0]s_axi_arburst;

  wire [8:0]BRAM_Addr_A;
  wire \GEN_RD_CMD_OPT.wrap_addr_assign_reg ;
  wire I_WR_CHNL_n_68;
  wire I_WR_CHNL_n_79;
  wire I_WR_CHNL_n_80;
  wire [0:0]SR;
  wire S_AXI_RVALID;
  wire axi_aresetn_d3;
  wire axi_arready_1st_addr;
  wire axi_bvalid_int_reg;
  wire [1:0]bram_addr_a;
  wire [8:0]bram_addr_b;
  wire bram_en_a;
  wire bram_en_b;
  wire [7:0]bram_we_a;
  wire [63:0]bram_wrdata_a;
  wire s_axi_aclk;
  wire [10:0]s_axi_araddr;
  wire [1:0]s_axi_arburst;
  wire s_axi_aresetn;
  wire [3:0]s_axi_arid;
  wire [7:0]s_axi_arlen;
  wire s_axi_arready;
  wire s_axi_arvalid;
  wire [10:0]s_axi_awaddr;
  wire [1:0]s_axi_awburst;
  wire [3:0]s_axi_awid;
  wire [7:0]s_axi_awlen;
  wire s_axi_awready;
  wire s_axi_awvalid;
  wire [3:0]s_axi_bid;
  wire s_axi_bready;
  wire [3:0]s_axi_rid;
  wire s_axi_rlast;
  wire s_axi_rready;
  wire [63:0]s_axi_wdata;
  wire s_axi_wlast;
  wire s_axi_wready;
  wire [7:0]s_axi_wstrb;
  wire s_axi_wvalid;
  wire \wrap_burst_total_reg_reg[1] ;

  axi64_bram_ctrl_16KiB_rd_chnl I_RD_CHNL
       (.\FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_reg_0 (I_WR_CHNL_n_68),
        .\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.axi_arready_1st_addr_reg_0 (I_WR_CHNL_n_80),
        .\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7]_0 (bram_addr_b[2]),
        .\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8]_0 (bram_addr_b[3]),
        .\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[9]_0 (bram_addr_b[4]),
        .\GEN_RD_CMD_OPT.arlen_reg_reg[1]_0 (I_WR_CHNL_n_79),
        .\GEN_RD_CMD_OPT.axi_rvalid_int_reg_0 (S_AXI_RVALID),
        .\GEN_RD_CMD_OPT.wrap_addr_assign_reg_0 (\GEN_RD_CMD_OPT.wrap_addr_assign_reg ),
        .axi_aresetn_d3(axi_aresetn_d3),
        .axi_arready_1st_addr(axi_arready_1st_addr),
        .bram_addr_b({bram_addr_b[8:5],bram_addr_b[1:0]}),
        .bram_en_b(bram_en_b),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_arburst(s_axi_arburst),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_aresetn_0(SR),
        .s_axi_arid(s_axi_arid),
        .s_axi_arlen(s_axi_arlen),
        .s_axi_arready(s_axi_arready),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_rid(s_axi_rid),
        .s_axi_rlast(s_axi_rlast),
        .s_axi_rready(s_axi_rready),
        .\wrap_burst_total_reg_reg[1] (\wrap_burst_total_reg_reg[1] ));
  axi64_bram_ctrl_16KiB_wr_chnl I_WR_CHNL
       (.\GEN_AWREADY.axi_aresetn_d3_reg_0 (I_WR_CHNL_n_68),
        .\GEN_AWREADY.axi_aresetn_d3_reg_1 (I_WR_CHNL_n_79),
        .Q(BRAM_Addr_A),
        .axi_aresetn_d3(axi_aresetn_d3),
        .axi_arready_1st_addr(axi_arready_1st_addr),
        .axi_bvalid_int_reg_0(axi_bvalid_int_reg),
        .bram_addr_a(bram_addr_a),
        .bram_en_a(bram_en_a),
        .bram_we_a(bram_we_a),
        .bram_wrdata_a(bram_wrdata_a),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_arvalid_0(I_WR_CHNL_n_80),
        .s_axi_awaddr(s_axi_awaddr),
        .s_axi_awburst(s_axi_awburst),
        .s_axi_awid(s_axi_awid),
        .s_axi_awlen(s_axi_awlen),
        .s_axi_awready(s_axi_awready),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bid(s_axi_bid),
        .s_axi_bready(s_axi_bready),
        .s_axi_wdata(s_axi_wdata),
        .s_axi_wlast(s_axi_wlast),
        .s_axi_wready(s_axi_wready),
        .s_axi_wstrb(s_axi_wstrb),
        .s_axi_wvalid(s_axi_wvalid),
        .\wrap_burst_total_reg[0] (SR));
endmodule

(* ORIG_REF_NAME = "rd_chnl" *) 
module axi64_bram_ctrl_16KiB_rd_chnl
   (\GEN_RD_CMD_OPT.axi_rvalid_int_reg_0 ,
    s_axi_aresetn_0,
    axi_arready_1st_addr,
    \GEN_RD_CMD_OPT.wrap_addr_assign_reg_0 ,
    \wrap_burst_total_reg_reg[1] ,
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8]_0 ,
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7]_0 ,
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[9]_0 ,
    bram_addr_b,
    bram_en_b,
    s_axi_rlast,
    s_axi_arready,
    s_axi_rid,
    s_axi_aclk,
    \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_reg_0 ,
    \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.axi_arready_1st_addr_reg_0 ,
    s_axi_rready,
    \GEN_RD_CMD_OPT.arlen_reg_reg[1]_0 ,
    s_axi_arlen,
    s_axi_aresetn,
    s_axi_araddr,
    s_axi_arburst,
    s_axi_arid,
    s_axi_arvalid,
    axi_aresetn_d3);
  output \GEN_RD_CMD_OPT.axi_rvalid_int_reg_0 ;
  output s_axi_aresetn_0;
  output axi_arready_1st_addr;
  output \GEN_RD_CMD_OPT.wrap_addr_assign_reg_0 ;
  output \wrap_burst_total_reg_reg[1] ;
  output \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8]_0 ;
  output \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7]_0 ;
  output \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[9]_0 ;
  output [5:0]bram_addr_b;
  output bram_en_b;
  output s_axi_rlast;
  output s_axi_arready;
  output [3:0]s_axi_rid;
  input s_axi_aclk;
  input \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_reg_0 ;
  input \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.axi_arready_1st_addr_reg_0 ;
  input s_axi_rready;
  input \GEN_RD_CMD_OPT.arlen_reg_reg[1]_0 ;
  input [7:0]s_axi_arlen;
  input s_axi_aresetn;
  input [10:0]s_axi_araddr;
  input [1:0]s_axi_arburst;
  input [3:0]s_axi_arid;
  input s_axi_arvalid;
  input axi_aresetn_d3;

  wire \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_1_n_0 ;
  wire \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_2_n_0 ;
  wire \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_3_n_0 ;
  wire \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_reg_0 ;
  wire \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_1_n_0 ;
  wire \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_2_n_0 ;
  wire \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_3_n_0 ;
  wire \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_4_n_0 ;
  wire \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_5_n_0 ;
  wire \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_2_n_0 ;
  wire \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_3_n_0 ;
  wire \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_4_n_0 ;
  wire \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.axi_arready_1st_addr_reg_0 ;
  wire \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_i_1_n_0 ;
  wire \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_4_n_0 ;
  wire \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[13]_i_1_n_0 ;
  wire \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[13]_i_2_n_0 ;
  wire \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[3]_i_1_n_0 ;
  wire \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[3]_i_2_n_0 ;
  wire \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[6]_i_2_n_0 ;
  wire \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7]_0 ;
  wire \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8]_0 ;
  wire \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[9]_0 ;
  wire \GEN_RD_CMD_OPT.I_WRAP_BRST_n_10 ;
  wire \GEN_RD_CMD_OPT.I_WRAP_BRST_n_11 ;
  wire \GEN_RD_CMD_OPT.I_WRAP_BRST_n_12 ;
  wire \GEN_RD_CMD_OPT.I_WRAP_BRST_n_13 ;
  wire \GEN_RD_CMD_OPT.I_WRAP_BRST_n_2 ;
  wire \GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ;
  wire \GEN_RD_CMD_OPT.I_WRAP_BRST_n_25 ;
  wire \GEN_RD_CMD_OPT.I_WRAP_BRST_n_6 ;
  wire \GEN_RD_CMD_OPT.I_WRAP_BRST_n_7 ;
  wire \GEN_RD_CMD_OPT.I_WRAP_BRST_n_8 ;
  wire \GEN_RD_CMD_OPT.I_WRAP_BRST_n_9 ;
  wire \GEN_RD_CMD_OPT.arburst_reg[0]_i_1_n_0 ;
  wire \GEN_RD_CMD_OPT.arburst_reg[1]_i_1_n_0 ;
  wire \GEN_RD_CMD_OPT.arlen_reg_reg[1]_0 ;
  wire \GEN_RD_CMD_OPT.arsize_reg[0]_i_1_n_0 ;
  wire \GEN_RD_CMD_OPT.arsize_reg[1]_i_1_n_0 ;
  wire \GEN_RD_CMD_OPT.axi_rlast_cmb_reg_i_1_n_0 ;
  wire \GEN_RD_CMD_OPT.axi_rvalid_int_reg_0 ;
  wire \GEN_RD_CMD_OPT.brst_cnt_addr[0]_i_1_n_0 ;
  wire \GEN_RD_CMD_OPT.brst_cnt_addr[1]_i_1_n_0 ;
  wire \GEN_RD_CMD_OPT.brst_cnt_addr[2]_i_1_n_0 ;
  wire \GEN_RD_CMD_OPT.brst_cnt_addr[3]_i_1_n_0 ;
  wire \GEN_RD_CMD_OPT.brst_cnt_addr[4]_i_1_n_0 ;
  wire \GEN_RD_CMD_OPT.brst_cnt_addr[4]_i_2_n_0 ;
  wire \GEN_RD_CMD_OPT.brst_cnt_addr[5]_i_1_n_0 ;
  wire \GEN_RD_CMD_OPT.brst_cnt_addr[6]_i_1_n_0 ;
  wire \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_1_n_0 ;
  wire \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_2_n_0 ;
  wire \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_3_n_0 ;
  wire \GEN_RD_CMD_OPT.brst_cnt_data[4]_i_2_n_0 ;
  wire \GEN_RD_CMD_OPT.brst_cnt_data[7]_i_1_n_0 ;
  wire \GEN_RD_CMD_OPT.brst_cnt_data[7]_i_3_n_0 ;
  wire \GEN_RD_CMD_OPT.wrap_addr_assign_i_3_n_0 ;
  wire \GEN_RD_CMD_OPT.wrap_addr_assign_reg_0 ;
  wire addr_vld_rdy5_out;
  wire [1:0]arburst_reg;
  wire [3:0]arid_reg;
  wire [3:0]arid_temp;
  wire [7:0]arlen_reg;
  wire [7:0]arlen_temp;
  wire [1:0]arsize_reg;
  wire axi_aresetn_d3;
  wire axi_arready_1st_addr;
  wire axi_rlast_cmb_reg;
  wire axi_rvalid_cmb;
  wire [5:0]bram_addr_b;
  wire \bram_addr_b[4]_INST_0_i_2_n_0 ;
  wire \bram_addr_b[5]_INST_0_i_10_n_0 ;
  wire \bram_addr_b[5]_INST_0_i_1_n_0 ;
  wire \bram_addr_b[5]_INST_0_i_6_n_0 ;
  wire \bram_addr_b[6]_INST_0_i_2_n_0 ;
  wire [13:3]bram_addr_int;
  wire bram_en_b;
  wire [7:0]brst_cnt_addr;
  wire [7:0]brst_cnt_data;
  wire [7:0]p_2_in;
  wire rd_active;
  wire rd_active_int2_out;
  wire rd_addr_sm_cs;
  wire rd_cmd_reg;
  wire [1:0]rd_data_sm_cs;
  wire s_axi_aclk;
  wire [10:0]s_axi_araddr;
  wire [1:0]s_axi_arburst;
  wire s_axi_aresetn;
  wire s_axi_aresetn_0;
  wire [3:0]s_axi_arid;
  wire [7:0]s_axi_arlen;
  wire s_axi_arready;
  wire s_axi_arready_INST_0_i_1_n_0;
  wire s_axi_arready_INST_0_i_2_n_0;
  wire s_axi_arvalid;
  wire [3:0]s_axi_rid;
  wire s_axi_rlast;
  wire s_axi_rready;
  wire wrap_addr_assign;
  wire \wrap_burst_total_reg_reg[1] ;

  LUT6 #(
    .INIT(64'hF0FFFFFF22222222)) 
    \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_1 
       (.I0(\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_2_n_0 ),
        .I1(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I2(\FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_2_n_0 ),
        .I3(\GEN_RD_CMD_OPT.axi_rvalid_int_reg_0 ),
        .I4(s_axi_rready),
        .I5(rd_addr_sm_cs),
        .O(\FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hFFFFFFFB)) 
    \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_2 
       (.I0(brst_cnt_addr[3]),
        .I1(brst_cnt_addr[0]),
        .I2(brst_cnt_addr[4]),
        .I3(brst_cnt_addr[7]),
        .I4(\FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_3_n_0 ),
        .O(\FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_2_n_0 ));
  LUT4 #(
    .INIT(16'hFFFE)) 
    \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_3 
       (.I0(brst_cnt_addr[6]),
        .I1(brst_cnt_addr[5]),
        .I2(brst_cnt_addr[1]),
        .I3(brst_cnt_addr[2]),
        .O(\FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_3_n_0 ));
  (* FSM_ENCODED_STATES = "next_addr:1,idle:0" *) 
  FDRE \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_1_n_0 ),
        .Q(rd_addr_sm_cs),
        .R(\FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_reg_0 ));
  LUT5 #(
    .INIT(32'hFF550C0C)) 
    \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_1 
       (.I0(\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_3_n_0 ),
        .I1(\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_2_n_0 ),
        .I2(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I3(rd_data_sm_cs[1]),
        .I4(rd_data_sm_cs[0]),
        .O(\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFFFFFFFFFFEAE)) 
    \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_2 
       (.I0(\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_3_n_0 ),
        .I1(s_axi_arlen[2]),
        .I2(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I3(arlen_reg[2]),
        .I4(arlen_temp[5]),
        .I5(\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_4_n_0 ),
        .O(\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT5 #(
    .INIT(32'hFFFACCFA)) 
    \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_3 
       (.I0(s_axi_arlen[7]),
        .I1(arlen_reg[7]),
        .I2(s_axi_arlen[6]),
        .I3(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I4(arlen_reg[6]),
        .O(\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFFFEFEFFFFAEFEA)) 
    \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_4 
       (.I0(\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_5_n_0 ),
        .I1(arlen_reg[4]),
        .I2(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I3(s_axi_arlen[4]),
        .I4(arlen_reg[0]),
        .I5(s_axi_arlen[0]),
        .O(\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'hFFFACCFA)) 
    \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_5 
       (.I0(s_axi_arlen[3]),
        .I1(arlen_reg[3]),
        .I2(s_axi_arlen[1]),
        .I3(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I4(arlen_reg[1]),
        .O(\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hFA00FAC0FAC0FAC0)) 
    \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_2 
       (.I0(\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_3_n_0 ),
        .I1(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I2(rd_data_sm_cs[1]),
        .I3(rd_data_sm_cs[0]),
        .I4(s_axi_rready),
        .I5(\GEN_RD_CMD_OPT.axi_rvalid_int_reg_0 ),
        .O(\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h00000001)) 
    \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_3 
       (.I0(brst_cnt_data[2]),
        .I1(brst_cnt_data[4]),
        .I2(brst_cnt_data[3]),
        .I3(brst_cnt_data[7]),
        .I4(\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_4_n_0 ),
        .O(\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hFFFDFFFFFFFFFFFF)) 
    \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_4 
       (.I0(brst_cnt_data[0]),
        .I1(brst_cnt_data[1]),
        .I2(brst_cnt_data[5]),
        .I3(brst_cnt_data[6]),
        .I4(s_axi_rready),
        .I5(\GEN_RD_CMD_OPT.axi_rvalid_int_reg_0 ),
        .O(\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_4_n_0 ));
  (* FSM_ENCODED_STATES = "last_data:10,read_data_one:01,idle:00" *) 
  FDRE \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_1_n_0 ),
        .Q(rd_data_sm_cs[0]),
        .R(\FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_reg_0 ));
  (* FSM_ENCODED_STATES = "last_data:10,read_data_one:01,idle:00" *) 
  FDRE \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_2_n_0 ),
        .Q(rd_data_sm_cs[1]),
        .R(\FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_reg_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.axi_arready_1st_addr_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.axi_arready_1st_addr_reg_0 ),
        .Q(axi_arready_1st_addr),
        .R(s_axi_aresetn_0));
  LUT6 #(
    .INIT(64'h55F755F755F70000)) 
    \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_active_i_1 
       (.I0(s_axi_arready_INST_0_i_2_n_0),
        .I1(rd_data_sm_cs[1]),
        .I2(rd_data_sm_cs[0]),
        .I3(axi_rlast_cmb_reg),
        .I4(rd_active),
        .I5(rd_cmd_reg),
        .O(rd_active_int2_out));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_active_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(rd_active_int2_out),
        .Q(rd_active),
        .R(s_axi_aresetn_0));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT5 #(
    .INIT(32'h88FF8880)) 
    \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_i_1 
       (.I0(axi_aresetn_d3),
        .I1(s_axi_arvalid),
        .I2(axi_arready_1st_addr),
        .I3(s_axi_arready_INST_0_i_1_n_0),
        .I4(rd_cmd_reg),
        .O(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_i_1_n_0 ),
        .Q(rd_cmd_reg),
        .R(s_axi_aresetn_0));
  LUT6 #(
    .INIT(64'h5555454555504540)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_4 
       (.I0(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[3]_i_2_n_0 ),
        .I1(arburst_reg[1]),
        .I2(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I3(s_axi_arburst[1]),
        .I4(arburst_reg[0]),
        .I5(s_axi_arburst[0]),
        .O(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hFFF0F0F0F4F4F4F4)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[13]_i_1 
       (.I0(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I1(\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_2_n_0 ),
        .I2(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[13]_i_2_n_0 ),
        .I3(\GEN_RD_CMD_OPT.axi_rvalid_int_reg_0 ),
        .I4(s_axi_rready),
        .I5(rd_addr_sm_cs),
        .O(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[13]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT5 #(
    .INIT(32'h00053305)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[13]_i_2 
       (.I0(s_axi_arburst[0]),
        .I1(arburst_reg[0]),
        .I2(s_axi_arburst[1]),
        .I3(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I4(arburst_reg[1]),
        .O(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[13]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAAAA9A9AAAA59A95)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[3]_i_1 
       (.I0(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[3]_i_2_n_0 ),
        .I1(arburst_reg[1]),
        .I2(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I3(s_axi_arburst[1]),
        .I4(arburst_reg[0]),
        .I5(s_axi_arburst[0]),
        .O(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT4 #(
    .INIT(16'hB0BF)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[3]_i_2 
       (.I0(wrap_addr_assign),
        .I1(bram_addr_int[3]),
        .I2(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I3(s_axi_araddr[0]),
        .O(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[3]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'hB0BF)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[6]_i_2 
       (.I0(wrap_addr_assign),
        .I1(bram_addr_int[6]),
        .I2(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I3(s_axi_araddr[3]),
        .O(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[6]_i_2_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[10] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[13]_i_1_n_0 ),
        .D(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_7 ),
        .Q(bram_addr_int[10]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[11] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[13]_i_1_n_0 ),
        .D(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_6 ),
        .Q(bram_addr_int[11]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[12] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[13]_i_1_n_0 ),
        .D(bram_addr_b[4]),
        .Q(bram_addr_int[12]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[13] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[13]_i_1_n_0 ),
        .D(bram_addr_b[5]),
        .Q(bram_addr_int[13]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[3] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[13]_i_1_n_0 ),
        .D(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[3]_i_1_n_0 ),
        .Q(bram_addr_int[3]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[4] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[13]_i_1_n_0 ),
        .D(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_13 ),
        .Q(bram_addr_int[4]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[5] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[13]_i_1_n_0 ),
        .D(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_12 ),
        .Q(bram_addr_int[5]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[6] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[13]_i_1_n_0 ),
        .D(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_11 ),
        .Q(bram_addr_int[6]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[13]_i_1_n_0 ),
        .D(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_10 ),
        .Q(bram_addr_int[7]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[13]_i_1_n_0 ),
        .D(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_9 ),
        .Q(bram_addr_int[8]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[9] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[13]_i_1_n_0 ),
        .D(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_8 ),
        .Q(bram_addr_int[9]),
        .R(s_axi_aresetn_0));
  axi64_bram_ctrl_16KiB_wrap_brst_rd \GEN_RD_CMD_OPT.I_WRAP_BRST 
       (.D({bram_addr_b[5:4],\GEN_RD_CMD_OPT.I_WRAP_BRST_n_6 ,\GEN_RD_CMD_OPT.I_WRAP_BRST_n_7 ,\GEN_RD_CMD_OPT.I_WRAP_BRST_n_8 ,\GEN_RD_CMD_OPT.I_WRAP_BRST_n_9 ,\GEN_RD_CMD_OPT.I_WRAP_BRST_n_10 ,\GEN_RD_CMD_OPT.I_WRAP_BRST_n_11 ,\GEN_RD_CMD_OPT.I_WRAP_BRST_n_12 ,\GEN_RD_CMD_OPT.I_WRAP_BRST_n_13 }),
        .\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg (\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[4] (\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[13]_i_2_n_0 ),
        .\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[6] (\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[6]_i_2_n_0 ),
        .\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7] (\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7]_0 ),
        .\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7]_0 (\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_4_n_0 ),
        .\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8] (\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8]_0 ),
        .\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[9] (\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[9]_0 ),
        .\GEN_RD_CMD_OPT.arlen_reg_reg[1] (\GEN_RD_CMD_OPT.arlen_reg_reg[1]_0 ),
        .\GEN_RD_CMD_OPT.arlen_reg_reg[1]_0 (axi_arready_1st_addr),
        .\GEN_RD_CMD_OPT.arlen_reg_reg[2] (\GEN_RD_CMD_OPT.axi_rvalid_int_reg_0 ),
        .\GEN_RD_CMD_OPT.arlen_reg_reg[3] (arlen_reg[3:1]),
        .\GEN_RD_CMD_OPT.axi_rvalid_int_reg (\GEN_RD_CMD_OPT.I_WRAP_BRST_n_2 ),
        .\GEN_RD_CMD_OPT.wrap_addr_assign_reg (\GEN_RD_CMD_OPT.wrap_addr_assign_reg_0 ),
        .\GEN_RD_CMD_OPT.wrap_addr_assign_reg_0 (\GEN_RD_CMD_OPT.I_WRAP_BRST_n_25 ),
        .\GEN_RD_CMD_OPT.wrap_addr_assign_reg_1 (\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[3]_i_2_n_0 ),
        .\GEN_RD_CMD_OPT.wrap_addr_assign_reg_2 (\GEN_RD_CMD_OPT.wrap_addr_assign_i_3_n_0 ),
        .Q({bram_addr_int[13:6],bram_addr_int[3]}),
        .SR(s_axi_aresetn_0),
        .addr_vld_rdy5_out(addr_vld_rdy5_out),
        .arlen_temp(arlen_temp[3:1]),
        .axi_aresetn_d3(axi_aresetn_d3),
        .axi_rlast_cmb_reg(axi_rlast_cmb_reg),
        .bram_addr_b(bram_addr_b[3:1]),
        .\bram_addr_b[4] (\bram_addr_b[5]_INST_0_i_6_n_0 ),
        .\bram_addr_b[4]_0 (\bram_addr_b[4]_INST_0_i_2_n_0 ),
        .\bram_addr_b[5] (\bram_addr_b[5]_INST_0_i_1_n_0 ),
        .\bram_addr_b[5]_0 (\bram_addr_b[5]_INST_0_i_10_n_0 ),
        .\bram_addr_b[6] (\bram_addr_b[6]_INST_0_i_2_n_0 ),
        .bram_en_b(bram_en_b),
        .rd_active(rd_active),
        .rd_cmd_reg(rd_cmd_reg),
        .rd_data_sm_cs(rd_data_sm_cs),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_araddr(s_axi_araddr),
        .s_axi_aresetn(s_axi_aresetn),
        .s_axi_arlen(s_axi_arlen[3:0]),
        .s_axi_arvalid(s_axi_arvalid),
        .s_axi_rready(s_axi_rready),
        .wrap_addr_assign(wrap_addr_assign),
        .\wrap_burst_total_reg_reg[1]_0 (\wrap_burst_total_reg_reg[1] ),
        .\wrap_burst_total_reg_reg[1]_1 (arsize_reg));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \GEN_RD_CMD_OPT.arburst_reg[0]_i_1 
       (.I0(arburst_reg[0]),
        .I1(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I2(s_axi_arburst[0]),
        .O(\GEN_RD_CMD_OPT.arburst_reg[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \GEN_RD_CMD_OPT.arburst_reg[1]_i_1 
       (.I0(arburst_reg[1]),
        .I1(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I2(s_axi_arburst[1]),
        .O(\GEN_RD_CMD_OPT.arburst_reg[1]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.arburst_reg_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GEN_RD_CMD_OPT.arburst_reg[0]_i_1_n_0 ),
        .Q(arburst_reg[0]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.arburst_reg_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GEN_RD_CMD_OPT.arburst_reg[1]_i_1_n_0 ),
        .Q(arburst_reg[1]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.arid_reg_reg[0] 
       (.C(s_axi_aclk),
        .CE(addr_vld_rdy5_out),
        .D(s_axi_arid[0]),
        .Q(arid_reg[0]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.arid_reg_reg[1] 
       (.C(s_axi_aclk),
        .CE(addr_vld_rdy5_out),
        .D(s_axi_arid[1]),
        .Q(arid_reg[1]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.arid_reg_reg[2] 
       (.C(s_axi_aclk),
        .CE(addr_vld_rdy5_out),
        .D(s_axi_arid[2]),
        .Q(arid_reg[2]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.arid_reg_reg[3] 
       (.C(s_axi_aclk),
        .CE(addr_vld_rdy5_out),
        .D(s_axi_arid[3]),
        .Q(arid_reg[3]),
        .R(s_axi_aresetn_0));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \GEN_RD_CMD_OPT.arlen_reg[0]_i_1 
       (.I0(arlen_reg[0]),
        .I1(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I2(s_axi_arlen[0]),
        .O(arlen_temp[0]));
  LUT3 #(
    .INIT(8'hB8)) 
    \GEN_RD_CMD_OPT.arlen_reg[4]_i_1 
       (.I0(arlen_reg[4]),
        .I1(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I2(s_axi_arlen[4]),
        .O(arlen_temp[4]));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \GEN_RD_CMD_OPT.arlen_reg[5]_i_1 
       (.I0(arlen_reg[5]),
        .I1(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I2(s_axi_arlen[5]),
        .O(arlen_temp[5]));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \GEN_RD_CMD_OPT.arlen_reg[6]_i_1 
       (.I0(arlen_reg[6]),
        .I1(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I2(s_axi_arlen[6]),
        .O(arlen_temp[6]));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \GEN_RD_CMD_OPT.arlen_reg[7]_i_1 
       (.I0(arlen_reg[7]),
        .I1(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I2(s_axi_arlen[7]),
        .O(arlen_temp[7]));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.arlen_reg_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(arlen_temp[0]),
        .Q(arlen_reg[0]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.arlen_reg_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(arlen_temp[1]),
        .Q(arlen_reg[1]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.arlen_reg_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(arlen_temp[2]),
        .Q(arlen_reg[2]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.arlen_reg_reg[3] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(arlen_temp[3]),
        .Q(arlen_reg[3]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.arlen_reg_reg[4] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(arlen_temp[4]),
        .Q(arlen_reg[4]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.arlen_reg_reg[5] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(arlen_temp[5]),
        .Q(arlen_reg[5]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.arlen_reg_reg[6] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(arlen_temp[6]),
        .Q(arlen_reg[6]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.arlen_reg_reg[7] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(arlen_temp[7]),
        .Q(arlen_reg[7]),
        .R(s_axi_aresetn_0));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \GEN_RD_CMD_OPT.arsize_reg[0]_i_1 
       (.I0(arsize_reg[0]),
        .I1(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .O(\GEN_RD_CMD_OPT.arsize_reg[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT2 #(
    .INIT(4'hB)) 
    \GEN_RD_CMD_OPT.arsize_reg[1]_i_1 
       (.I0(arsize_reg[1]),
        .I1(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .O(\GEN_RD_CMD_OPT.arsize_reg[1]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.arsize_reg_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GEN_RD_CMD_OPT.arsize_reg[0]_i_1_n_0 ),
        .Q(arsize_reg[0]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.arsize_reg_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GEN_RD_CMD_OPT.arsize_reg[1]_i_1_n_0 ),
        .Q(arsize_reg[1]),
        .R(s_axi_aresetn_0));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \GEN_RD_CMD_OPT.axi_rid_int[0]_i_1 
       (.I0(arid_reg[0]),
        .I1(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I2(s_axi_arid[0]),
        .O(arid_temp[0]));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \GEN_RD_CMD_OPT.axi_rid_int[1]_i_1 
       (.I0(arid_reg[1]),
        .I1(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I2(s_axi_arid[1]),
        .O(arid_temp[1]));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \GEN_RD_CMD_OPT.axi_rid_int[2]_i_1 
       (.I0(arid_reg[2]),
        .I1(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I2(s_axi_arid[2]),
        .O(arid_temp[2]));
  LUT5 #(
    .INIT(32'h33335F55)) 
    \GEN_RD_CMD_OPT.axi_rid_int[3]_i_1 
       (.I0(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I1(rd_data_sm_cs[1]),
        .I2(s_axi_rready),
        .I3(\GEN_RD_CMD_OPT.axi_rvalid_int_reg_0 ),
        .I4(rd_data_sm_cs[0]),
        .O(axi_rvalid_cmb));
  LUT3 #(
    .INIT(8'hB8)) 
    \GEN_RD_CMD_OPT.axi_rid_int[3]_i_2 
       (.I0(arid_reg[3]),
        .I1(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I2(s_axi_arid[3]),
        .O(arid_temp[3]));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.axi_rid_int_reg[0] 
       (.C(s_axi_aclk),
        .CE(axi_rvalid_cmb),
        .D(arid_temp[0]),
        .Q(s_axi_rid[0]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.axi_rid_int_reg[1] 
       (.C(s_axi_aclk),
        .CE(axi_rvalid_cmb),
        .D(arid_temp[1]),
        .Q(s_axi_rid[1]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.axi_rid_int_reg[2] 
       (.C(s_axi_aclk),
        .CE(axi_rvalid_cmb),
        .D(arid_temp[2]),
        .Q(s_axi_rid[2]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.axi_rid_int_reg[3] 
       (.C(s_axi_aclk),
        .CE(axi_rvalid_cmb),
        .D(arid_temp[3]),
        .Q(s_axi_rid[3]),
        .R(s_axi_aresetn_0));
  LUT6 #(
    .INIT(64'hCFFFDDDD00001111)) 
    \GEN_RD_CMD_OPT.axi_rlast_cmb_reg_i_1 
       (.I0(\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_2_n_0 ),
        .I1(rd_data_sm_cs[0]),
        .I2(s_axi_rready),
        .I3(\GEN_RD_CMD_OPT.axi_rvalid_int_reg_0 ),
        .I4(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I5(axi_rlast_cmb_reg),
        .O(\GEN_RD_CMD_OPT.axi_rlast_cmb_reg_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.axi_rlast_cmb_reg_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GEN_RD_CMD_OPT.axi_rlast_cmb_reg_i_1_n_0 ),
        .Q(axi_rlast_cmb_reg),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.axi_rvalid_int_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(axi_rvalid_cmb),
        .Q(\GEN_RD_CMD_OPT.axi_rvalid_int_reg_0 ),
        .R(s_axi_aresetn_0));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT3 #(
    .INIT(8'h74)) 
    \GEN_RD_CMD_OPT.brst_cnt_addr[0]_i_1 
       (.I0(brst_cnt_addr[0]),
        .I1(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I2(s_axi_arlen[0]),
        .O(\GEN_RD_CMD_OPT.brst_cnt_addr[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT4 #(
    .INIT(16'h9F90)) 
    \GEN_RD_CMD_OPT.brst_cnt_addr[1]_i_1 
       (.I0(brst_cnt_addr[1]),
        .I1(brst_cnt_addr[0]),
        .I2(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I3(s_axi_arlen[1]),
        .O(\GEN_RD_CMD_OPT.brst_cnt_addr[1]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'hA9FFA900)) 
    \GEN_RD_CMD_OPT.brst_cnt_addr[2]_i_1 
       (.I0(brst_cnt_addr[2]),
        .I1(brst_cnt_addr[0]),
        .I2(brst_cnt_addr[1]),
        .I3(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I4(s_axi_arlen[2]),
        .O(\GEN_RD_CMD_OPT.brst_cnt_addr[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAAA9FFFFAAA90000)) 
    \GEN_RD_CMD_OPT.brst_cnt_addr[3]_i_1 
       (.I0(brst_cnt_addr[3]),
        .I1(brst_cnt_addr[2]),
        .I2(brst_cnt_addr[1]),
        .I3(brst_cnt_addr[0]),
        .I4(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I5(s_axi_arlen[3]),
        .O(\GEN_RD_CMD_OPT.brst_cnt_addr[3]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h6F60)) 
    \GEN_RD_CMD_OPT.brst_cnt_addr[4]_i_1 
       (.I0(brst_cnt_addr[4]),
        .I1(\GEN_RD_CMD_OPT.brst_cnt_addr[4]_i_2_n_0 ),
        .I2(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I3(s_axi_arlen[4]),
        .O(\GEN_RD_CMD_OPT.brst_cnt_addr[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT4 #(
    .INIT(16'h0001)) 
    \GEN_RD_CMD_OPT.brst_cnt_addr[4]_i_2 
       (.I0(brst_cnt_addr[2]),
        .I1(brst_cnt_addr[1]),
        .I2(brst_cnt_addr[0]),
        .I3(brst_cnt_addr[3]),
        .O(\GEN_RD_CMD_OPT.brst_cnt_addr[4]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'h6F60)) 
    \GEN_RD_CMD_OPT.brst_cnt_addr[5]_i_1 
       (.I0(brst_cnt_addr[5]),
        .I1(\GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_3_n_0 ),
        .I2(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I3(s_axi_arlen[5]),
        .O(\GEN_RD_CMD_OPT.brst_cnt_addr[5]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h9AFF9A00)) 
    \GEN_RD_CMD_OPT.brst_cnt_addr[6]_i_1 
       (.I0(brst_cnt_addr[6]),
        .I1(brst_cnt_addr[5]),
        .I2(\GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_3_n_0 ),
        .I3(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I4(s_axi_arlen[6]),
        .O(\GEN_RD_CMD_OPT.brst_cnt_addr[6]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h80FF)) 
    \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_1 
       (.I0(rd_addr_sm_cs),
        .I1(s_axi_rready),
        .I2(\GEN_RD_CMD_OPT.axi_rvalid_int_reg_0 ),
        .I3(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .O(\GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hA9AAFFFFA9AA0000)) 
    \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_2 
       (.I0(brst_cnt_addr[7]),
        .I1(brst_cnt_addr[5]),
        .I2(brst_cnt_addr[6]),
        .I3(\GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_3_n_0 ),
        .I4(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I5(s_axi_arlen[7]),
        .O(\GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_3 
       (.I0(brst_cnt_addr[3]),
        .I1(brst_cnt_addr[0]),
        .I2(brst_cnt_addr[1]),
        .I3(brst_cnt_addr[2]),
        .I4(brst_cnt_addr[4]),
        .O(\GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_3_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.brst_cnt_addr_reg[0] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_1_n_0 ),
        .D(\GEN_RD_CMD_OPT.brst_cnt_addr[0]_i_1_n_0 ),
        .Q(brst_cnt_addr[0]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.brst_cnt_addr_reg[1] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_1_n_0 ),
        .D(\GEN_RD_CMD_OPT.brst_cnt_addr[1]_i_1_n_0 ),
        .Q(brst_cnt_addr[1]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.brst_cnt_addr_reg[2] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_1_n_0 ),
        .D(\GEN_RD_CMD_OPT.brst_cnt_addr[2]_i_1_n_0 ),
        .Q(brst_cnt_addr[2]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.brst_cnt_addr_reg[3] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_1_n_0 ),
        .D(\GEN_RD_CMD_OPT.brst_cnt_addr[3]_i_1_n_0 ),
        .Q(brst_cnt_addr[3]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.brst_cnt_addr_reg[4] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_1_n_0 ),
        .D(\GEN_RD_CMD_OPT.brst_cnt_addr[4]_i_1_n_0 ),
        .Q(brst_cnt_addr[4]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.brst_cnt_addr_reg[5] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_1_n_0 ),
        .D(\GEN_RD_CMD_OPT.brst_cnt_addr[5]_i_1_n_0 ),
        .Q(brst_cnt_addr[5]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.brst_cnt_addr_reg[6] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_1_n_0 ),
        .D(\GEN_RD_CMD_OPT.brst_cnt_addr[6]_i_1_n_0 ),
        .Q(brst_cnt_addr[6]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.brst_cnt_addr_reg[7] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_1_n_0 ),
        .D(\GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_2_n_0 ),
        .Q(brst_cnt_addr[7]),
        .R(s_axi_aresetn_0));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT3 #(
    .INIT(8'h74)) 
    \GEN_RD_CMD_OPT.brst_cnt_data[0]_i_1 
       (.I0(brst_cnt_data[0]),
        .I1(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I2(s_axi_arlen[0]),
        .O(p_2_in[0]));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT4 #(
    .INIT(16'h9F90)) 
    \GEN_RD_CMD_OPT.brst_cnt_data[1]_i_1 
       (.I0(brst_cnt_data[1]),
        .I1(brst_cnt_data[0]),
        .I2(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I3(s_axi_arlen[1]),
        .O(p_2_in[1]));
  LUT5 #(
    .INIT(32'hA9FFA900)) 
    \GEN_RD_CMD_OPT.brst_cnt_data[2]_i_1 
       (.I0(brst_cnt_data[2]),
        .I1(brst_cnt_data[0]),
        .I2(brst_cnt_data[1]),
        .I3(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I4(s_axi_arlen[2]),
        .O(p_2_in[2]));
  LUT6 #(
    .INIT(64'hAAA9FFFFAAA90000)) 
    \GEN_RD_CMD_OPT.brst_cnt_data[3]_i_1 
       (.I0(brst_cnt_data[3]),
        .I1(brst_cnt_data[2]),
        .I2(brst_cnt_data[1]),
        .I3(brst_cnt_data[0]),
        .I4(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I5(s_axi_arlen[3]),
        .O(p_2_in[3]));
  LUT4 #(
    .INIT(16'h9F90)) 
    \GEN_RD_CMD_OPT.brst_cnt_data[4]_i_1 
       (.I0(brst_cnt_data[4]),
        .I1(\GEN_RD_CMD_OPT.brst_cnt_data[4]_i_2_n_0 ),
        .I2(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I3(s_axi_arlen[4]),
        .O(p_2_in[4]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \GEN_RD_CMD_OPT.brst_cnt_data[4]_i_2 
       (.I0(brst_cnt_data[3]),
        .I1(brst_cnt_data[2]),
        .I2(brst_cnt_data[1]),
        .I3(brst_cnt_data[0]),
        .O(\GEN_RD_CMD_OPT.brst_cnt_data[4]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT4 #(
    .INIT(16'h6F60)) 
    \GEN_RD_CMD_OPT.brst_cnt_data[5]_i_1 
       (.I0(brst_cnt_data[5]),
        .I1(\GEN_RD_CMD_OPT.brst_cnt_data[7]_i_3_n_0 ),
        .I2(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I3(s_axi_arlen[5]),
        .O(p_2_in[5]));
  LUT5 #(
    .INIT(32'h9AFF9A00)) 
    \GEN_RD_CMD_OPT.brst_cnt_data[6]_i_1 
       (.I0(brst_cnt_data[6]),
        .I1(brst_cnt_data[5]),
        .I2(\GEN_RD_CMD_OPT.brst_cnt_data[7]_i_3_n_0 ),
        .I3(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I4(s_axi_arlen[6]),
        .O(p_2_in[6]));
  LUT5 #(
    .INIT(32'h2000FFFF)) 
    \GEN_RD_CMD_OPT.brst_cnt_data[7]_i_1 
       (.I0(rd_data_sm_cs[0]),
        .I1(rd_data_sm_cs[1]),
        .I2(s_axi_rready),
        .I3(\GEN_RD_CMD_OPT.axi_rvalid_int_reg_0 ),
        .I4(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .O(\GEN_RD_CMD_OPT.brst_cnt_data[7]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hAAA6FFFFAAA60000)) 
    \GEN_RD_CMD_OPT.brst_cnt_data[7]_i_2 
       (.I0(brst_cnt_data[7]),
        .I1(\GEN_RD_CMD_OPT.brst_cnt_data[7]_i_3_n_0 ),
        .I2(brst_cnt_data[5]),
        .I3(brst_cnt_data[6]),
        .I4(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I5(s_axi_arlen[7]),
        .O(p_2_in[7]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT5 #(
    .INIT(32'h00000001)) 
    \GEN_RD_CMD_OPT.brst_cnt_data[7]_i_3 
       (.I0(brst_cnt_data[4]),
        .I1(brst_cnt_data[0]),
        .I2(brst_cnt_data[1]),
        .I3(brst_cnt_data[2]),
        .I4(brst_cnt_data[3]),
        .O(\GEN_RD_CMD_OPT.brst_cnt_data[7]_i_3_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.brst_cnt_data_reg[0] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.brst_cnt_data[7]_i_1_n_0 ),
        .D(p_2_in[0]),
        .Q(brst_cnt_data[0]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.brst_cnt_data_reg[1] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.brst_cnt_data[7]_i_1_n_0 ),
        .D(p_2_in[1]),
        .Q(brst_cnt_data[1]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.brst_cnt_data_reg[2] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.brst_cnt_data[7]_i_1_n_0 ),
        .D(p_2_in[2]),
        .Q(brst_cnt_data[2]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.brst_cnt_data_reg[3] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.brst_cnt_data[7]_i_1_n_0 ),
        .D(p_2_in[3]),
        .Q(brst_cnt_data[3]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.brst_cnt_data_reg[4] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.brst_cnt_data[7]_i_1_n_0 ),
        .D(p_2_in[4]),
        .Q(brst_cnt_data[4]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.brst_cnt_data_reg[5] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.brst_cnt_data[7]_i_1_n_0 ),
        .D(p_2_in[5]),
        .Q(brst_cnt_data[5]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.brst_cnt_data_reg[6] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.brst_cnt_data[7]_i_1_n_0 ),
        .D(p_2_in[6]),
        .Q(brst_cnt_data[6]),
        .R(s_axi_aresetn_0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.brst_cnt_data_reg[7] 
       (.C(s_axi_aclk),
        .CE(\GEN_RD_CMD_OPT.brst_cnt_data[7]_i_1_n_0 ),
        .D(p_2_in[7]),
        .Q(brst_cnt_data[7]),
        .R(s_axi_aresetn_0));
  LUT6 #(
    .INIT(64'hFF7FFFFFFF7F0F0F)) 
    \GEN_RD_CMD_OPT.wrap_addr_assign_i_3 
       (.I0(arsize_reg[1]),
        .I1(arsize_reg[0]),
        .I2(\GEN_RD_CMD_OPT.arburst_reg[1]_i_1_n_0 ),
        .I3(arburst_reg[0]),
        .I4(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I5(s_axi_arburst[0]),
        .O(\GEN_RD_CMD_OPT.wrap_addr_assign_i_3_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_RD_CMD_OPT.wrap_addr_assign_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_25 ),
        .Q(wrap_addr_assign),
        .R(s_axi_aresetn_0));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT4 #(
    .INIT(16'h22E2)) 
    \bram_addr_b[3]_INST_0 
       (.I0(s_axi_araddr[0]),
        .I1(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I2(bram_addr_int[3]),
        .I3(wrap_addr_assign),
        .O(bram_addr_b[0]));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT4 #(
    .INIT(16'h4F40)) 
    \bram_addr_b[4]_INST_0_i_2 
       (.I0(wrap_addr_assign),
        .I1(bram_addr_int[4]),
        .I2(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I3(s_axi_araddr[1]),
        .O(\bram_addr_b[4]_INST_0_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT4 #(
    .INIT(16'h4F40)) 
    \bram_addr_b[5]_INST_0_i_1 
       (.I0(wrap_addr_assign),
        .I1(bram_addr_int[5]),
        .I2(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I3(s_axi_araddr[2]),
        .O(\bram_addr_b[5]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000000ABABABAA)) 
    \bram_addr_b[5]_INST_0_i_10 
       (.I0(\GEN_RD_CMD_OPT.arlen_reg_reg[1]_0 ),
        .I1(axi_arready_1st_addr),
        .I2(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_2 ),
        .I3(rd_active),
        .I4(rd_cmd_reg),
        .I5(arsize_reg[0]),
        .O(\bram_addr_b[5]_INST_0_i_10_n_0 ));
  LUT5 #(
    .INIT(32'hFFFEFFFF)) 
    \bram_addr_b[5]_INST_0_i_6 
       (.I0(arlen_temp[3]),
        .I1(s_axi_arlen[1]),
        .I2(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I3(s_axi_arlen[2]),
        .I4(s_axi_arlen[0]),
        .O(\bram_addr_b[5]_INST_0_i_6_n_0 ));
  LUT5 #(
    .INIT(32'h00000080)) 
    \bram_addr_b[6]_INST_0_i_2 
       (.I0(arlen_temp[1]),
        .I1(s_axi_arlen[0]),
        .I2(arlen_temp[2]),
        .I3(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I4(arlen_temp[3]),
        .O(\bram_addr_b[6]_INST_0_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT4 #(
    .INIT(16'h880F)) 
    bram_en_b_INST_0
       (.I0(s_axi_rready),
        .I1(\GEN_RD_CMD_OPT.axi_rvalid_int_reg_0 ),
        .I2(\GEN_RD_CMD_OPT.I_WRAP_BRST_n_20 ),
        .I3(rd_addr_sm_cs),
        .O(bram_en_b));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'hA8)) 
    s_axi_arready_INST_0
       (.I0(axi_aresetn_d3),
        .I1(s_axi_arready_INST_0_i_1_n_0),
        .I2(axi_arready_1st_addr),
        .O(s_axi_arready));
  LUT6 #(
    .INIT(64'hF1FFF1F111111111)) 
    s_axi_arready_INST_0_i_1
       (.I0(rd_cmd_reg),
        .I1(rd_active),
        .I2(axi_rlast_cmb_reg),
        .I3(rd_data_sm_cs[0]),
        .I4(rd_data_sm_cs[1]),
        .I5(s_axi_arready_INST_0_i_2_n_0),
        .O(s_axi_arready_INST_0_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT2 #(
    .INIT(4'h8)) 
    s_axi_arready_INST_0_i_2
       (.I0(s_axi_rready),
        .I1(\GEN_RD_CMD_OPT.axi_rvalid_int_reg_0 ),
        .O(s_axi_arready_INST_0_i_2_n_0));
  LUT3 #(
    .INIT(8'hF2)) 
    s_axi_rlast_INST_0
       (.I0(rd_data_sm_cs[1]),
        .I1(rd_data_sm_cs[0]),
        .I2(axi_rlast_cmb_reg),
        .O(s_axi_rlast));
endmodule

(* ORIG_REF_NAME = "wr_chnl" *) 
module axi64_bram_ctrl_16KiB_wr_chnl
   (axi_aresetn_d3,
    bram_en_a,
    bram_wrdata_a,
    axi_bvalid_int_reg_0,
    s_axi_wready,
    \GEN_AWREADY.axi_aresetn_d3_reg_0 ,
    s_axi_awready,
    Q,
    \GEN_AWREADY.axi_aresetn_d3_reg_1 ,
    s_axi_arvalid_0,
    bram_addr_a,
    s_axi_bid,
    bram_we_a,
    \wrap_burst_total_reg[0] ,
    s_axi_aclk,
    s_axi_awaddr,
    s_axi_aresetn,
    s_axi_wdata,
    s_axi_wvalid,
    s_axi_wlast,
    s_axi_awburst,
    s_axi_awvalid,
    s_axi_awid,
    s_axi_bready,
    s_axi_awlen,
    s_axi_arvalid,
    axi_arready_1st_addr,
    s_axi_wstrb);
  output axi_aresetn_d3;
  output bram_en_a;
  output [63:0]bram_wrdata_a;
  output axi_bvalid_int_reg_0;
  output s_axi_wready;
  output \GEN_AWREADY.axi_aresetn_d3_reg_0 ;
  output s_axi_awready;
  output [8:0]Q;
  output \GEN_AWREADY.axi_aresetn_d3_reg_1 ;
  output s_axi_arvalid_0;
  output [1:0]bram_addr_a;
  output [3:0]s_axi_bid;
  output [7:0]bram_we_a;
  input \wrap_burst_total_reg[0] ;
  input s_axi_aclk;
  input [10:0]s_axi_awaddr;
  input s_axi_aresetn;
  input [63:0]s_axi_wdata;
  input s_axi_wvalid;
  input s_axi_wlast;
  input [1:0]s_axi_awburst;
  input s_axi_awvalid;
  input [3:0]s_axi_awid;
  input s_axi_bready;
  input [7:0]s_axi_awlen;
  input s_axi_arvalid;
  input axi_arready_1st_addr;
  input [7:0]s_axi_wstrb;

  wire BID_FIFO_n_0;
  wire BID_FIFO_n_1;
  wire BID_FIFO_n_10;
  wire BID_FIFO_n_3;
  wire BID_FIFO_n_4;
  wire BID_FIFO_n_5;
  wire BID_FIFO_n_6;
  wire BID_FIFO_n_7;
  wire BID_FIFO_n_8;
  wire BID_FIFO_n_9;
  wire \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[0]_i_1_n_0 ;
  wire \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_1_n_0 ;
  wire \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_2_n_0 ;
  wire \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_3_n_0 ;
  wire \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_1_n_0 ;
  wire \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_2_n_0 ;
  wire \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_3_n_0 ;
  wire \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_4_n_0 ;
  wire \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_5_n_0 ;
  wire \GEN_AWREADY.axi_aresetn_d3_reg_0 ;
  wire \GEN_AWREADY.axi_aresetn_d3_reg_1 ;
  wire \GEN_AWREADY.axi_awready_int_i_1_n_0 ;
  wire \GEN_AW_DUAL.aw_active_i_1_n_0 ;
  wire \GEN_AW_DUAL.wr_addr_sm_cs_i_1_n_0 ;
  wire \GEN_AW_PIPE_DUAL.GEN_AWADDR[10].axi_awaddr_pipe_reg ;
  wire \GEN_AW_PIPE_DUAL.GEN_AWADDR[11].axi_awaddr_pipe_reg ;
  wire \GEN_AW_PIPE_DUAL.GEN_AWADDR[12].axi_awaddr_pipe_reg ;
  wire \GEN_AW_PIPE_DUAL.GEN_AWADDR[13].axi_awaddr_pipe_reg ;
  wire \GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe[3]_i_2_n_0 ;
  wire \GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe_reg ;
  wire \GEN_AW_PIPE_DUAL.GEN_AWADDR[4].axi_awaddr_pipe_reg ;
  wire \GEN_AW_PIPE_DUAL.GEN_AWADDR[5].axi_awaddr_pipe_reg ;
  wire \GEN_AW_PIPE_DUAL.GEN_AWADDR[6].axi_awaddr_pipe_reg ;
  wire \GEN_AW_PIPE_DUAL.GEN_AWADDR[7].axi_awaddr_pipe_reg ;
  wire \GEN_AW_PIPE_DUAL.GEN_AWADDR[8].axi_awaddr_pipe_reg ;
  wire \GEN_AW_PIPE_DUAL.GEN_AWADDR[9].axi_awaddr_pipe_reg ;
  wire \GEN_AW_PIPE_DUAL.axi_awaddr_full_i_1_n_0 ;
  wire \GEN_AW_PIPE_DUAL.axi_awburst_pipe_fixed_i_1_n_0 ;
  wire \GEN_AW_PIPE_DUAL.axi_awburst_pipe_fixed_reg_n_0 ;
  wire \GEN_AW_PIPE_DUAL.axi_awlen_pipe_1_or_2_i_2_n_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int[10]_i_3_n_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_3_n_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int[12]_i_1_n_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_1_n_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_2_n_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_3_n_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int[8]_i_3_n_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int[9]_i_2_n_0 ;
  wire \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.axi_wdata_full_reg_i_2_n_0 ;
  wire \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.bram_en_int_i_2_n_0 ;
  wire \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.clr_bram_we_i_2_n_0 ;
  wire \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.delay_aw_active_clr_i_1_n_0 ;
  wire \GEN_WR_NO_ECC.bram_we_int[7]_i_1_n_0 ;
  wire \I_RD_CHNL/axi_aresetn_d1 ;
  wire \I_RD_CHNL/axi_aresetn_d2 ;
  wire \I_RD_CHNL/axi_aresetn_re ;
  wire I_WRAP_BRST_n_0;
  wire I_WRAP_BRST_n_10;
  wire I_WRAP_BRST_n_11;
  wire I_WRAP_BRST_n_14;
  wire I_WRAP_BRST_n_15;
  wire I_WRAP_BRST_n_16;
  wire I_WRAP_BRST_n_17;
  wire I_WRAP_BRST_n_18;
  wire I_WRAP_BRST_n_19;
  wire I_WRAP_BRST_n_2;
  wire I_WRAP_BRST_n_3;
  wire I_WRAP_BRST_n_4;
  wire I_WRAP_BRST_n_5;
  wire I_WRAP_BRST_n_6;
  wire I_WRAP_BRST_n_7;
  wire I_WRAP_BRST_n_8;
  wire I_WRAP_BRST_n_9;
  wire [8:0]Q;
  wire aw_active;
  wire awaddr_pipe_ld24_out;
  wire axi_aresetn_d3;
  wire axi_aresetn_re_reg;
  wire axi_arready_1st_addr;
  wire axi_awaddr_full;
  wire [1:0]axi_awburst_pipe;
  wire [3:0]axi_awid_pipe;
  wire [7:0]axi_awlen_pipe;
  wire axi_awlen_pipe_1_or_2;
  wire axi_awlen_pipe_1_or_20;
  wire [0:0]axi_awsize_pipe;
  wire axi_bvalid_int_i_1_n_0;
  wire axi_bvalid_int_reg_0;
  wire axi_wdata_full_cmb;
  wire axi_wdata_full_reg;
  wire axi_wr_burst;
  wire axi_wr_burst_cmb;
  wire axi_wr_burst_i_1_n_0;
  wire axi_wr_burst_i_3_n_0;
  wire axi_wr_burst_i_4_n_0;
  wire axi_wr_burst_i_5_n_0;
  wire axi_wr_burst_i_6_n_0;
  wire axi_wready_int_mod_i_1_n_0;
  wire bid_gets_fifo_load;
  wire bid_gets_fifo_load_d1;
  wire bid_gets_fifo_load_d1_i_2_n_0;
  wire [1:0]bram_addr_a;
  wire bram_addr_ld_en;
  wire bram_en_a;
  wire bram_en_cmb;
  wire [7:0]bram_we_a;
  wire [63:0]bram_wrdata_a;
  wire [2:0]bvalid_cnt;
  wire \bvalid_cnt[0]_i_1_n_0 ;
  wire \bvalid_cnt[1]_i_1_n_0 ;
  wire \bvalid_cnt[2]_i_1_n_0 ;
  wire clr_bram_we;
  wire clr_bram_we_cmb;
  wire curr_awlen_reg_1_or_2;
  wire curr_awlen_reg_1_or_20;
  wire curr_awlen_reg_1_or_2_i_2_n_0;
  wire curr_fixed_burst_reg;
  wire curr_fixed_burst_reg_i_1_n_0;
  wire curr_fixed_burst_reg_i_2_n_0;
  wire curr_wrap_burst;
  wire curr_wrap_burst_reg;
  wire curr_wrap_burst_reg_i_1_n_0;
  wire delay_aw_active_clr;
  wire delay_aw_active_clr_cmb;
  wire last_data_ack_mod;
  wire last_data_ack_mod0;
  wire [9:8]p_1_in;
  wire s_axi_aclk;
  wire s_axi_aresetn;
  wire s_axi_arvalid;
  wire s_axi_arvalid_0;
  wire [10:0]s_axi_awaddr;
  wire [1:0]s_axi_awburst;
  wire [3:0]s_axi_awid;
  wire [7:0]s_axi_awlen;
  wire s_axi_awready;
  wire s_axi_awvalid;
  wire [3:0]s_axi_bid;
  wire s_axi_bready;
  wire [63:0]s_axi_wdata;
  wire s_axi_wlast;
  wire s_axi_wready;
  wire [7:0]s_axi_wstrb;
  wire s_axi_wvalid;
  wire wr_addr_sm_cs;
  wire [2:0]wr_data_sm_cs;
  wire [0:0]wr_data_sm_ns__0;
  wire \wrap_burst_total_reg[0] ;
  wire wrdata_reg_ld;

  axi64_bram_ctrl_16KiB_SRL_FIFO BID_FIFO
       (.D({BID_FIFO_n_4,BID_FIFO_n_5,BID_FIFO_n_6,BID_FIFO_n_7}),
        .Data_Exists_DFF_0(\wrap_burst_total_reg[0] ),
        .E(BID_FIFO_n_1),
        .\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1] (BID_FIFO_n_9),
        .\GEN_AW_PIPE_DUAL.axi_awaddr_full_reg (BID_FIFO_n_8),
        .Q(axi_awid_pipe),
        .aw_active(aw_active),
        .axi_awaddr_full(axi_awaddr_full),
        .\axi_bid_int_reg[0] (axi_bvalid_int_reg_0),
        .axi_wr_burst(axi_wr_burst),
        .axi_wr_burst_reg(BID_FIFO_n_0),
        .bid_gets_fifo_load(bid_gets_fifo_load),
        .bid_gets_fifo_load_d1(bid_gets_fifo_load_d1),
        .bid_gets_fifo_load_d1_reg(bid_gets_fifo_load_d1_i_2_n_0),
        .bram_addr_ld_en(bram_addr_ld_en),
        .bvalid_cnt(bvalid_cnt),
        .\bvalid_cnt_reg[0] (BID_FIFO_n_10),
        .\bvalid_cnt_reg[2] (BID_FIFO_n_3),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_awid(s_axi_awid),
        .s_axi_awready(s_axi_awready),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_bready(s_axi_bready),
        .s_axi_wlast(s_axi_wlast),
        .s_axi_wvalid(s_axi_wvalid),
        .wr_data_sm_cs(wr_data_sm_cs));
  LUT1 #(
    .INIT(2'h1)) 
    \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_1 
       (.I0(axi_aresetn_d3),
        .O(\GEN_AWREADY.axi_aresetn_d3_reg_0 ));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[0]_i_1 
       (.I0(wr_data_sm_ns__0),
        .I1(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_5_n_0 ),
        .I2(wr_data_sm_cs[0]),
        .O(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF0FAF0F3000A0003)) 
    \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[0]_i_2 
       (.I0(axi_wr_burst_i_3_n_0),
        .I1(BID_FIFO_n_10),
        .I2(wr_data_sm_cs[2]),
        .I3(wr_data_sm_cs[0]),
        .I4(wr_data_sm_cs[1]),
        .I5(s_axi_wvalid),
        .O(wr_data_sm_ns__0));
  LUT6 #(
    .INIT(64'hFF00FFFFFF100000)) 
    \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_1 
       (.I0(wr_data_sm_cs[0]),
        .I1(s_axi_wlast),
        .I2(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_2_n_0 ),
        .I3(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_3_n_0 ),
        .I4(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_5_n_0 ),
        .I5(wr_data_sm_cs[1]),
        .O(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_2 
       (.I0(BID_FIFO_n_10),
        .I1(wr_data_sm_cs[2]),
        .O(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT5 #(
    .INIT(32'h0000FC88)) 
    \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_3 
       (.I0(axi_wr_burst),
        .I1(wr_data_sm_cs[0]),
        .I2(axi_wr_burst_i_3_n_0),
        .I3(wr_data_sm_cs[1]),
        .I4(wr_data_sm_cs[2]),
        .O(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h0FFFFFFF8FFF0000)) 
    \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_1 
       (.I0(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_2_n_0 ),
        .I1(wr_data_sm_cs[1]),
        .I2(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_3_n_0 ),
        .I3(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_4_n_0 ),
        .I4(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_5_n_0 ),
        .I5(wr_data_sm_cs[2]),
        .O(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_2 
       (.I0(wr_data_sm_cs[0]),
        .I1(axi_wr_burst_i_3_n_0),
        .O(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT5 #(
    .INIT(32'hFFFDFFFF)) 
    \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_3 
       (.I0(BID_FIFO_n_10),
        .I1(wr_data_sm_cs[1]),
        .I2(wr_data_sm_cs[0]),
        .I3(wr_data_sm_cs[2]),
        .I4(s_axi_wlast),
        .O(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT4 #(
    .INIT(16'hFFEF)) 
    \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_4 
       (.I0(axi_wr_burst),
        .I1(wr_data_sm_cs[2]),
        .I2(wr_data_sm_cs[0]),
        .I3(wr_data_sm_cs[1]),
        .O(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h000000FFCCC0AACC)) 
    \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_5 
       (.I0(BID_FIFO_n_8),
        .I1(s_axi_wvalid),
        .I2(s_axi_wlast),
        .I3(wr_data_sm_cs[0]),
        .I4(wr_data_sm_cs[1]),
        .I5(wr_data_sm_cs[2]),
        .O(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_5_n_0 ));
  (* FSM_ENCODED_STATES = "brst_wr_data:010,idle:000,w8_awaddr:001,sng_wr_data:100,b2b_w8_wr_data:011" *) 
  FDRE \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[0]_i_1_n_0 ),
        .Q(wr_data_sm_cs[0]),
        .R(\wrap_burst_total_reg[0] ));
  (* FSM_ENCODED_STATES = "brst_wr_data:010,idle:000,w8_awaddr:001,sng_wr_data:100,b2b_w8_wr_data:011" *) 
  FDRE \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_1_n_0 ),
        .Q(wr_data_sm_cs[1]),
        .R(\wrap_burst_total_reg[0] ));
  (* FSM_ENCODED_STATES = "brst_wr_data:010,idle:000,w8_awaddr:001,sng_wr_data:100,b2b_w8_wr_data:011" *) 
  FDRE \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_1_n_0 ),
        .Q(wr_data_sm_cs[2]),
        .R(\wrap_burst_total_reg[0] ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AWREADY.axi_aresetn_d1_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(s_axi_aresetn),
        .Q(\I_RD_CHNL/axi_aresetn_d1 ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AWREADY.axi_aresetn_d2_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\I_RD_CHNL/axi_aresetn_d1 ),
        .Q(\I_RD_CHNL/axi_aresetn_d2 ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AWREADY.axi_aresetn_d3_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\I_RD_CHNL/axi_aresetn_d2 ),
        .Q(axi_aresetn_d3),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \GEN_AWREADY.axi_aresetn_re_reg_i_1 
       (.I0(\I_RD_CHNL/axi_aresetn_d1 ),
        .I1(\I_RD_CHNL/axi_aresetn_d2 ),
        .O(\I_RD_CHNL/axi_aresetn_re ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AWREADY.axi_aresetn_re_reg_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\I_RD_CHNL/axi_aresetn_re ),
        .Q(axi_aresetn_re_reg),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT5 #(
    .INIT(32'hFFD5FFC0)) 
    \GEN_AWREADY.axi_awready_int_i_1 
       (.I0(awaddr_pipe_ld24_out),
        .I1(axi_awaddr_full),
        .I2(bram_addr_ld_en),
        .I3(axi_aresetn_re_reg),
        .I4(s_axi_awready),
        .O(\GEN_AWREADY.axi_awready_int_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AWREADY.axi_awready_int_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GEN_AWREADY.axi_awready_int_i_1_n_0 ),
        .Q(s_axi_awready),
        .R(\wrap_burst_total_reg[0] ));
  LUT6 #(
    .INIT(64'hFFFBFFFFAAAAAAAA)) 
    \GEN_AW_DUAL.aw_active_i_1 
       (.I0(bram_addr_ld_en),
        .I1(wr_data_sm_cs[2]),
        .I2(wr_data_sm_cs[1]),
        .I3(wr_data_sm_cs[0]),
        .I4(delay_aw_active_clr),
        .I5(aw_active),
        .O(\GEN_AW_DUAL.aw_active_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_DUAL.aw_active_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GEN_AW_DUAL.aw_active_i_1_n_0 ),
        .Q(aw_active),
        .R(\GEN_AWREADY.axi_aresetn_d3_reg_0 ));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \GEN_AW_DUAL.last_data_ack_mod_i_1 
       (.I0(s_axi_wready),
        .I1(s_axi_wlast),
        .I2(s_axi_wvalid),
        .O(last_data_ack_mod0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_DUAL.last_data_ack_mod_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(last_data_ack_mod0),
        .Q(last_data_ack_mod),
        .R(\wrap_burst_total_reg[0] ));
  LUT5 #(
    .INIT(32'h00000010)) 
    \GEN_AW_DUAL.wr_addr_sm_cs_i_1 
       (.I0(I_WRAP_BRST_n_16),
        .I1(wr_addr_sm_cs),
        .I2(s_axi_awvalid),
        .I3(axi_awaddr_full),
        .I4(I_WRAP_BRST_n_2),
        .O(\GEN_AW_DUAL.wr_addr_sm_cs_i_1_n_0 ));
  FDRE \GEN_AW_DUAL.wr_addr_sm_cs_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GEN_AW_DUAL.wr_addr_sm_cs_i_1_n_0 ),
        .Q(wr_addr_sm_cs),
        .R(\GEN_AWREADY.axi_aresetn_d3_reg_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[10].axi_awaddr_pipe_reg[10] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awaddr[7]),
        .Q(\GEN_AW_PIPE_DUAL.GEN_AWADDR[10].axi_awaddr_pipe_reg ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[11].axi_awaddr_pipe_reg[11] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awaddr[8]),
        .Q(\GEN_AW_PIPE_DUAL.GEN_AWADDR[11].axi_awaddr_pipe_reg ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[12].axi_awaddr_pipe_reg[12] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awaddr[9]),
        .Q(\GEN_AW_PIPE_DUAL.GEN_AWADDR[12].axi_awaddr_pipe_reg ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[13].axi_awaddr_pipe_reg[13] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awaddr[10]),
        .Q(\GEN_AW_PIPE_DUAL.GEN_AWADDR[13].axi_awaddr_pipe_reg ),
        .R(1'b0));
  LUT4 #(
    .INIT(16'h0800)) 
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe[3]_i_1 
       (.I0(\GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe[3]_i_2_n_0 ),
        .I1(s_axi_awvalid),
        .I2(axi_awaddr_full),
        .I3(axi_aresetn_d3),
        .O(awaddr_pipe_ld24_out));
  LUT6 #(
    .INIT(64'h000000000000FF80)) 
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe[3]_i_2 
       (.I0(bvalid_cnt[1]),
        .I1(bvalid_cnt[2]),
        .I2(bvalid_cnt[0]),
        .I3(aw_active),
        .I4(I_WRAP_BRST_n_16),
        .I5(wr_addr_sm_cs),
        .O(\GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe[3]_i_2_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe_reg[3] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awaddr[0]),
        .Q(\GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe_reg ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[4].axi_awaddr_pipe_reg[4] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awaddr[1]),
        .Q(\GEN_AW_PIPE_DUAL.GEN_AWADDR[4].axi_awaddr_pipe_reg ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[5].axi_awaddr_pipe_reg[5] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awaddr[2]),
        .Q(\GEN_AW_PIPE_DUAL.GEN_AWADDR[5].axi_awaddr_pipe_reg ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[6].axi_awaddr_pipe_reg[6] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awaddr[3]),
        .Q(\GEN_AW_PIPE_DUAL.GEN_AWADDR[6].axi_awaddr_pipe_reg ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[7].axi_awaddr_pipe_reg[7] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awaddr[4]),
        .Q(\GEN_AW_PIPE_DUAL.GEN_AWADDR[7].axi_awaddr_pipe_reg ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[8].axi_awaddr_pipe_reg[8] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awaddr[5]),
        .Q(\GEN_AW_PIPE_DUAL.GEN_AWADDR[8].axi_awaddr_pipe_reg ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[9].axi_awaddr_pipe_reg[9] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awaddr[6]),
        .Q(\GEN_AW_PIPE_DUAL.GEN_AWADDR[9].axi_awaddr_pipe_reg ),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT4 #(
    .INIT(16'h0C88)) 
    \GEN_AW_PIPE_DUAL.axi_awaddr_full_i_1 
       (.I0(awaddr_pipe_ld24_out),
        .I1(s_axi_aresetn),
        .I2(bram_addr_ld_en),
        .I3(axi_awaddr_full),
        .O(\GEN_AW_PIPE_DUAL.axi_awaddr_full_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.axi_awaddr_full_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GEN_AW_PIPE_DUAL.axi_awaddr_full_i_1_n_0 ),
        .Q(axi_awaddr_full),
        .R(1'b0));
  LUT4 #(
    .INIT(16'h03AA)) 
    \GEN_AW_PIPE_DUAL.axi_awburst_pipe_fixed_i_1 
       (.I0(\GEN_AW_PIPE_DUAL.axi_awburst_pipe_fixed_reg_n_0 ),
        .I1(s_axi_awburst[1]),
        .I2(s_axi_awburst[0]),
        .I3(awaddr_pipe_ld24_out),
        .O(\GEN_AW_PIPE_DUAL.axi_awburst_pipe_fixed_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.axi_awburst_pipe_fixed_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GEN_AW_PIPE_DUAL.axi_awburst_pipe_fixed_i_1_n_0 ),
        .Q(\GEN_AW_PIPE_DUAL.axi_awburst_pipe_fixed_reg_n_0 ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.axi_awburst_pipe_reg[0] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awburst[0]),
        .Q(axi_awburst_pipe[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.axi_awburst_pipe_reg[1] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awburst[1]),
        .Q(axi_awburst_pipe[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.axi_awid_pipe_reg[0] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awid[0]),
        .Q(axi_awid_pipe[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.axi_awid_pipe_reg[1] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awid[1]),
        .Q(axi_awid_pipe[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.axi_awid_pipe_reg[2] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awid[2]),
        .Q(axi_awid_pipe[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.axi_awid_pipe_reg[3] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awid[3]),
        .Q(axi_awid_pipe[3]),
        .R(1'b0));
  LUT4 #(
    .INIT(16'h0002)) 
    \GEN_AW_PIPE_DUAL.axi_awlen_pipe_1_or_2_i_1 
       (.I0(\GEN_AW_PIPE_DUAL.axi_awlen_pipe_1_or_2_i_2_n_0 ),
        .I1(s_axi_awlen[2]),
        .I2(s_axi_awlen[1]),
        .I3(s_axi_awlen[3]),
        .O(axi_awlen_pipe_1_or_20));
  LUT4 #(
    .INIT(16'h0001)) 
    \GEN_AW_PIPE_DUAL.axi_awlen_pipe_1_or_2_i_2 
       (.I0(s_axi_awlen[4]),
        .I1(s_axi_awlen[5]),
        .I2(s_axi_awlen[6]),
        .I3(s_axi_awlen[7]),
        .O(\GEN_AW_PIPE_DUAL.axi_awlen_pipe_1_or_2_i_2_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.axi_awlen_pipe_1_or_2_reg 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(axi_awlen_pipe_1_or_20),
        .Q(axi_awlen_pipe_1_or_2),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.axi_awlen_pipe_reg[0] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awlen[0]),
        .Q(axi_awlen_pipe[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.axi_awlen_pipe_reg[1] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awlen[1]),
        .Q(axi_awlen_pipe[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.axi_awlen_pipe_reg[2] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awlen[2]),
        .Q(axi_awlen_pipe[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.axi_awlen_pipe_reg[3] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awlen[3]),
        .Q(axi_awlen_pipe[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.axi_awlen_pipe_reg[4] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awlen[4]),
        .Q(axi_awlen_pipe[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.axi_awlen_pipe_reg[5] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awlen[5]),
        .Q(axi_awlen_pipe[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.axi_awlen_pipe_reg[6] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awlen[6]),
        .Q(axi_awlen_pipe[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.axi_awlen_pipe_reg[7] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(s_axi_awlen[7]),
        .Q(axi_awlen_pipe[7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_AW_PIPE_DUAL.axi_awsize_pipe_reg[0] 
       (.C(s_axi_aclk),
        .CE(awaddr_pipe_ld24_out),
        .D(1'b1),
        .Q(axi_awsize_pipe),
        .R(1'b0));
  LUT5 #(
    .INIT(32'h20000000)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[10]_i_3 
       (.I0(Q[5]),
        .I1(\GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_3_n_0 ),
        .I2(Q[3]),
        .I3(Q[4]),
        .I4(Q[6]),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int[10]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h9555555555555555)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_3 
       (.I0(Q[8]),
        .I1(Q[5]),
        .I2(I_WRAP_BRST_n_14),
        .I3(Q[4]),
        .I4(Q[6]),
        .I5(Q[7]),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT3 #(
    .INIT(8'hE2)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[12]_i_1 
       (.I0(p_1_in[8]),
        .I1(I_WRAP_BRST_n_0),
        .I2(bram_addr_a[0]),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int[12]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00000100FFFFFFFF)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_1 
       (.I0(bram_addr_ld_en),
        .I1(wr_data_sm_cs[0]),
        .I2(wr_data_sm_cs[1]),
        .I3(wr_data_sm_cs[2]),
        .I4(s_axi_wvalid),
        .I5(s_axi_aresetn),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT3 #(
    .INIT(8'hE2)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_2 
       (.I0(p_1_in[9]),
        .I1(I_WRAP_BRST_n_0),
        .I2(bram_addr_a[1]),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT3 #(
    .INIT(8'h7F)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_3 
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(Q[2]),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT5 #(
    .INIT(32'h80000000)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[8]_i_3 
       (.I0(Q[1]),
        .I1(Q[0]),
        .I2(Q[2]),
        .I3(Q[3]),
        .I4(Q[4]),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int[8]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h8000000000000000)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[9]_i_2 
       (.I0(Q[4]),
        .I1(Q[3]),
        .I2(Q[2]),
        .I3(Q[0]),
        .I4(Q[1]),
        .I5(Q[5]),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int[9]_i_2_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[10] 
       (.C(s_axi_aclk),
        .CE(I_WRAP_BRST_n_15),
        .D(I_WRAP_BRST_n_4),
        .Q(Q[7]),
        .R(\GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[11] 
       (.C(s_axi_aclk),
        .CE(I_WRAP_BRST_n_15),
        .D(I_WRAP_BRST_n_3),
        .Q(Q[8]),
        .R(\GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[12] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GEN_DUAL_ADDR_CNT.bram_addr_int[12]_i_1_n_0 ),
        .Q(bram_addr_a[0]),
        .R(\GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[13] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_2_n_0 ),
        .Q(bram_addr_a[1]),
        .R(\GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[3] 
       (.C(s_axi_aclk),
        .CE(I_WRAP_BRST_n_15),
        .D(I_WRAP_BRST_n_11),
        .Q(Q[0]),
        .R(\GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[4] 
       (.C(s_axi_aclk),
        .CE(I_WRAP_BRST_n_15),
        .D(I_WRAP_BRST_n_10),
        .Q(Q[1]),
        .R(\GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[5] 
       (.C(s_axi_aclk),
        .CE(I_WRAP_BRST_n_15),
        .D(I_WRAP_BRST_n_9),
        .Q(Q[2]),
        .R(\GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[6] 
       (.C(s_axi_aclk),
        .CE(I_WRAP_BRST_n_15),
        .D(I_WRAP_BRST_n_8),
        .Q(Q[3]),
        .R(\GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[7] 
       (.C(s_axi_aclk),
        .CE(I_WRAP_BRST_n_15),
        .D(I_WRAP_BRST_n_7),
        .Q(Q[4]),
        .R(\GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[8] 
       (.C(s_axi_aclk),
        .CE(I_WRAP_BRST_n_15),
        .D(I_WRAP_BRST_n_6),
        .Q(Q[5]),
        .R(\GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[9] 
       (.C(s_axi_aclk),
        .CE(I_WRAP_BRST_n_15),
        .D(I_WRAP_BRST_n_5),
        .Q(Q[6]),
        .R(\GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT4 #(
    .INIT(16'h7530)) 
    \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.axi_arready_1st_addr_i_1 
       (.I0(s_axi_arvalid),
        .I1(\I_RD_CHNL/axi_aresetn_d2 ),
        .I2(\I_RD_CHNL/axi_aresetn_d1 ),
        .I3(axi_arready_1st_addr),
        .O(s_axi_arvalid_0));
  LUT2 #(
    .INIT(4'h7)) 
    \GEN_RD_CMD_OPT.arlen_reg[3]_i_3 
       (.I0(axi_aresetn_d3),
        .I1(s_axi_arvalid),
        .O(\GEN_AWREADY.axi_aresetn_d3_reg_1 ));
  LUT6 #(
    .INIT(64'hAAAEEEAEAAAEEEFE)) 
    \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.axi_wdata_full_reg_i_1 
       (.I0(\GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.axi_wdata_full_reg_i_2_n_0 ),
        .I1(axi_wdata_full_reg),
        .I2(wr_data_sm_cs[0]),
        .I3(wr_data_sm_cs[1]),
        .I4(wr_data_sm_cs[2]),
        .I5(BID_FIFO_n_8),
        .O(axi_wdata_full_cmb));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT5 #(
    .INIT(32'h10100010)) 
    \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.axi_wdata_full_reg_i_2 
       (.I0(wr_data_sm_cs[1]),
        .I1(wr_data_sm_cs[0]),
        .I2(s_axi_wvalid),
        .I3(BID_FIFO_n_10),
        .I4(wr_data_sm_cs[2]),
        .O(\GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.axi_wdata_full_reg_i_2_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.axi_wdata_full_reg_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(axi_wdata_full_cmb),
        .Q(axi_wdata_full_reg),
        .R(\wrap_burst_total_reg[0] ));
  LUT6 #(
    .INIT(64'h3300330033302020)) 
    \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.bram_en_int_i_1 
       (.I0(\GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.bram_en_int_i_2_n_0 ),
        .I1(wr_data_sm_cs[2]),
        .I2(wr_data_sm_cs[0]),
        .I3(s_axi_wvalid),
        .I4(BID_FIFO_n_10),
        .I5(wr_data_sm_cs[1]),
        .O(bram_en_cmb));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.bram_en_int_i_2 
       (.I0(axi_awaddr_full),
        .I1(bram_addr_ld_en),
        .O(\GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.bram_en_int_i_2_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.bram_en_int_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(bram_en_cmb),
        .Q(bram_en_a),
        .R(\wrap_burst_total_reg[0] ));
  LUT6 #(
    .INIT(64'h0100FFFF01000100)) 
    \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.clr_bram_we_i_1 
       (.I0(axi_wr_burst),
        .I1(\GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.clr_bram_we_i_2_n_0 ),
        .I2(wr_data_sm_cs[1]),
        .I3(BID_FIFO_n_8),
        .I4(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_3_n_0 ),
        .I5(s_axi_wvalid),
        .O(clr_bram_we_cmb));
  LUT2 #(
    .INIT(4'hB)) 
    \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.clr_bram_we_i_2 
       (.I0(wr_data_sm_cs[2]),
        .I1(wr_data_sm_cs[0]),
        .O(\GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.clr_bram_we_i_2_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.clr_bram_we_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(clr_bram_we_cmb),
        .Q(clr_bram_we),
        .R(\wrap_burst_total_reg[0] ));
  LUT6 #(
    .INIT(64'hAAAAAB88AB88AB88)) 
    \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.delay_aw_active_clr_i_1 
       (.I0(delay_aw_active_clr_cmb),
        .I1(clr_bram_we_cmb),
        .I2(wr_data_sm_cs[2]),
        .I3(delay_aw_active_clr),
        .I4(axi_wr_burst_i_4_n_0),
        .I5(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_2_n_0 ),
        .O(\GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.delay_aw_active_clr_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h00F800FF00F80000)) 
    \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.delay_aw_active_clr_i_2 
       (.I0(bram_addr_ld_en),
        .I1(axi_awaddr_full),
        .I2(BID_FIFO_n_10),
        .I3(wr_data_sm_cs[2]),
        .I4(wr_data_sm_cs[0]),
        .I5(s_axi_wlast),
        .O(delay_aw_active_clr_cmb));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.delay_aw_active_clr_reg 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.delay_aw_active_clr_i_1_n_0 ),
        .Q(delay_aw_active_clr),
        .R(\wrap_burst_total_reg[0] ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[0].bram_wrdata_int_reg[0] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[0]),
        .Q(bram_wrdata_a[0]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[10].bram_wrdata_int_reg[10] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[10]),
        .Q(bram_wrdata_a[10]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[11].bram_wrdata_int_reg[11] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[11]),
        .Q(bram_wrdata_a[11]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[12].bram_wrdata_int_reg[12] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[12]),
        .Q(bram_wrdata_a[12]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[13].bram_wrdata_int_reg[13] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[13]),
        .Q(bram_wrdata_a[13]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[14].bram_wrdata_int_reg[14] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[14]),
        .Q(bram_wrdata_a[14]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[15].bram_wrdata_int_reg[15] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[15]),
        .Q(bram_wrdata_a[15]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[16].bram_wrdata_int_reg[16] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[16]),
        .Q(bram_wrdata_a[16]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[17].bram_wrdata_int_reg[17] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[17]),
        .Q(bram_wrdata_a[17]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[18].bram_wrdata_int_reg[18] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[18]),
        .Q(bram_wrdata_a[18]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[19].bram_wrdata_int_reg[19] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[19]),
        .Q(bram_wrdata_a[19]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[1].bram_wrdata_int_reg[1] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[1]),
        .Q(bram_wrdata_a[1]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[20].bram_wrdata_int_reg[20] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[20]),
        .Q(bram_wrdata_a[20]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[21].bram_wrdata_int_reg[21] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[21]),
        .Q(bram_wrdata_a[21]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[22].bram_wrdata_int_reg[22] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[22]),
        .Q(bram_wrdata_a[22]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[23].bram_wrdata_int_reg[23] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[23]),
        .Q(bram_wrdata_a[23]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[24].bram_wrdata_int_reg[24] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[24]),
        .Q(bram_wrdata_a[24]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[25].bram_wrdata_int_reg[25] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[25]),
        .Q(bram_wrdata_a[25]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[26].bram_wrdata_int_reg[26] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[26]),
        .Q(bram_wrdata_a[26]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[27].bram_wrdata_int_reg[27] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[27]),
        .Q(bram_wrdata_a[27]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[28].bram_wrdata_int_reg[28] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[28]),
        .Q(bram_wrdata_a[28]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[29].bram_wrdata_int_reg[29] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[29]),
        .Q(bram_wrdata_a[29]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[2].bram_wrdata_int_reg[2] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[2]),
        .Q(bram_wrdata_a[2]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[30].bram_wrdata_int_reg[30] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[30]),
        .Q(bram_wrdata_a[30]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[31].bram_wrdata_int_reg[31] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[31]),
        .Q(bram_wrdata_a[31]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[32].bram_wrdata_int_reg[32] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[32]),
        .Q(bram_wrdata_a[32]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[33].bram_wrdata_int_reg[33] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[33]),
        .Q(bram_wrdata_a[33]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[34].bram_wrdata_int_reg[34] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[34]),
        .Q(bram_wrdata_a[34]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[35].bram_wrdata_int_reg[35] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[35]),
        .Q(bram_wrdata_a[35]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[36].bram_wrdata_int_reg[36] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[36]),
        .Q(bram_wrdata_a[36]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[37].bram_wrdata_int_reg[37] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[37]),
        .Q(bram_wrdata_a[37]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[38].bram_wrdata_int_reg[38] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[38]),
        .Q(bram_wrdata_a[38]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[39].bram_wrdata_int_reg[39] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[39]),
        .Q(bram_wrdata_a[39]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[3].bram_wrdata_int_reg[3] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[3]),
        .Q(bram_wrdata_a[3]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[40].bram_wrdata_int_reg[40] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[40]),
        .Q(bram_wrdata_a[40]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[41].bram_wrdata_int_reg[41] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[41]),
        .Q(bram_wrdata_a[41]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[42].bram_wrdata_int_reg[42] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[42]),
        .Q(bram_wrdata_a[42]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[43].bram_wrdata_int_reg[43] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[43]),
        .Q(bram_wrdata_a[43]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[44].bram_wrdata_int_reg[44] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[44]),
        .Q(bram_wrdata_a[44]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[45].bram_wrdata_int_reg[45] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[45]),
        .Q(bram_wrdata_a[45]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[46].bram_wrdata_int_reg[46] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[46]),
        .Q(bram_wrdata_a[46]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[47].bram_wrdata_int_reg[47] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[47]),
        .Q(bram_wrdata_a[47]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[48].bram_wrdata_int_reg[48] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[48]),
        .Q(bram_wrdata_a[48]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[49].bram_wrdata_int_reg[49] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[49]),
        .Q(bram_wrdata_a[49]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[4].bram_wrdata_int_reg[4] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[4]),
        .Q(bram_wrdata_a[4]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[50].bram_wrdata_int_reg[50] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[50]),
        .Q(bram_wrdata_a[50]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[51].bram_wrdata_int_reg[51] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[51]),
        .Q(bram_wrdata_a[51]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[52].bram_wrdata_int_reg[52] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[52]),
        .Q(bram_wrdata_a[52]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[53].bram_wrdata_int_reg[53] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[53]),
        .Q(bram_wrdata_a[53]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[54].bram_wrdata_int_reg[54] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[54]),
        .Q(bram_wrdata_a[54]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[55].bram_wrdata_int_reg[55] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[55]),
        .Q(bram_wrdata_a[55]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[56].bram_wrdata_int_reg[56] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[56]),
        .Q(bram_wrdata_a[56]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[57].bram_wrdata_int_reg[57] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[57]),
        .Q(bram_wrdata_a[57]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[58].bram_wrdata_int_reg[58] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[58]),
        .Q(bram_wrdata_a[58]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[59].bram_wrdata_int_reg[59] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[59]),
        .Q(bram_wrdata_a[59]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[5].bram_wrdata_int_reg[5] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[5]),
        .Q(bram_wrdata_a[5]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[60].bram_wrdata_int_reg[60] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[60]),
        .Q(bram_wrdata_a[60]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[61].bram_wrdata_int_reg[61] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[61]),
        .Q(bram_wrdata_a[61]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[62].bram_wrdata_int_reg[62] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[62]),
        .Q(bram_wrdata_a[62]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[63].bram_wrdata_int_reg[63] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[63]),
        .Q(bram_wrdata_a[63]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[6].bram_wrdata_int_reg[6] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[6]),
        .Q(bram_wrdata_a[6]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[7].bram_wrdata_int_reg[7] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[7]),
        .Q(bram_wrdata_a[7]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[8].bram_wrdata_int_reg[8] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[8]),
        .Q(bram_wrdata_a[8]),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WRDATA[9].bram_wrdata_int_reg[9] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wdata[9]),
        .Q(bram_wrdata_a[9]),
        .R(1'b0));
  LUT6 #(
    .INIT(64'hFD5D0000FFFFFFFF)) 
    \GEN_WR_NO_ECC.bram_we_int[7]_i_1 
       (.I0(s_axi_wvalid),
        .I1(wr_data_sm_cs[0]),
        .I2(wr_data_sm_cs[1]),
        .I3(wr_data_sm_cs[2]),
        .I4(clr_bram_we),
        .I5(s_axi_aresetn),
        .O(\GEN_WR_NO_ECC.bram_we_int[7]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h02A2)) 
    \GEN_WR_NO_ECC.bram_we_int[7]_i_2 
       (.I0(s_axi_wvalid),
        .I1(wr_data_sm_cs[0]),
        .I2(wr_data_sm_cs[1]),
        .I3(wr_data_sm_cs[2]),
        .O(wrdata_reg_ld));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WR_NO_ECC.bram_we_int_reg[0] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wstrb[0]),
        .Q(bram_we_a[0]),
        .R(\GEN_WR_NO_ECC.bram_we_int[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WR_NO_ECC.bram_we_int_reg[1] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wstrb[1]),
        .Q(bram_we_a[1]),
        .R(\GEN_WR_NO_ECC.bram_we_int[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WR_NO_ECC.bram_we_int_reg[2] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wstrb[2]),
        .Q(bram_we_a[2]),
        .R(\GEN_WR_NO_ECC.bram_we_int[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WR_NO_ECC.bram_we_int_reg[3] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wstrb[3]),
        .Q(bram_we_a[3]),
        .R(\GEN_WR_NO_ECC.bram_we_int[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WR_NO_ECC.bram_we_int_reg[4] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wstrb[4]),
        .Q(bram_we_a[4]),
        .R(\GEN_WR_NO_ECC.bram_we_int[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WR_NO_ECC.bram_we_int_reg[5] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wstrb[5]),
        .Q(bram_we_a[5]),
        .R(\GEN_WR_NO_ECC.bram_we_int[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WR_NO_ECC.bram_we_int_reg[6] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wstrb[6]),
        .Q(bram_we_a[6]),
        .R(\GEN_WR_NO_ECC.bram_we_int[7]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \GEN_WR_NO_ECC.bram_we_int_reg[7] 
       (.C(s_axi_aclk),
        .CE(wrdata_reg_ld),
        .D(s_axi_wstrb[7]),
        .Q(bram_we_a[7]),
        .R(\GEN_WR_NO_ECC.bram_we_int[7]_i_1_n_0 ));
  axi64_bram_ctrl_16KiB_wrap_brst I_WRAP_BRST
       (.D({I_WRAP_BRST_n_3,I_WRAP_BRST_n_4,I_WRAP_BRST_n_5,I_WRAP_BRST_n_6,I_WRAP_BRST_n_7,I_WRAP_BRST_n_8,I_WRAP_BRST_n_9,I_WRAP_BRST_n_10,I_WRAP_BRST_n_11}),
        .E(I_WRAP_BRST_n_15),
        .\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1] (I_WRAP_BRST_n_0),
        .\GEN_AW_DUAL.aw_active_reg (I_WRAP_BRST_n_2),
        .\GEN_AW_DUAL.last_data_ack_mod_reg (I_WRAP_BRST_n_16),
        .\GEN_AW_PIPE_DUAL.GEN_AWADDR[10].axi_awaddr_pipe_reg (\GEN_AW_PIPE_DUAL.GEN_AWADDR[10].axi_awaddr_pipe_reg ),
        .\GEN_AW_PIPE_DUAL.GEN_AWADDR[11].axi_awaddr_pipe_reg (\GEN_AW_PIPE_DUAL.GEN_AWADDR[11].axi_awaddr_pipe_reg ),
        .\GEN_AW_PIPE_DUAL.GEN_AWADDR[12].axi_awaddr_pipe_reg (\GEN_AW_PIPE_DUAL.GEN_AWADDR[12].axi_awaddr_pipe_reg ),
        .\GEN_AW_PIPE_DUAL.GEN_AWADDR[13].axi_awaddr_pipe_reg (\GEN_AW_PIPE_DUAL.GEN_AWADDR[13].axi_awaddr_pipe_reg ),
        .\GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe_reg (\GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe_reg ),
        .\GEN_AW_PIPE_DUAL.GEN_AWADDR[4].axi_awaddr_pipe_reg (\GEN_AW_PIPE_DUAL.GEN_AWADDR[4].axi_awaddr_pipe_reg ),
        .\GEN_AW_PIPE_DUAL.GEN_AWADDR[5].axi_awaddr_pipe_reg (\GEN_AW_PIPE_DUAL.GEN_AWADDR[5].axi_awaddr_pipe_reg ),
        .\GEN_AW_PIPE_DUAL.GEN_AWADDR[6].axi_awaddr_pipe_reg (\GEN_AW_PIPE_DUAL.GEN_AWADDR[6].axi_awaddr_pipe_reg ),
        .\GEN_AW_PIPE_DUAL.GEN_AWADDR[7].axi_awaddr_pipe_reg (\GEN_AW_PIPE_DUAL.GEN_AWADDR[7].axi_awaddr_pipe_reg ),
        .\GEN_AW_PIPE_DUAL.GEN_AWADDR[8].axi_awaddr_pipe_reg (\GEN_AW_PIPE_DUAL.GEN_AWADDR[8].axi_awaddr_pipe_reg ),
        .\GEN_AW_PIPE_DUAL.GEN_AWADDR[9].axi_awaddr_pipe_reg (\GEN_AW_PIPE_DUAL.GEN_AWADDR[9].axi_awaddr_pipe_reg ),
        .\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[10] (\GEN_DUAL_ADDR_CNT.bram_addr_int[10]_i_3_n_0 ),
        .\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[11] (\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_3_n_0 ),
        .\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[6] (I_WRAP_BRST_n_14),
        .\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[6]_0 (\GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_3_n_0 ),
        .\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[8] (BID_FIFO_n_9),
        .\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[8]_0 (\GEN_DUAL_ADDR_CNT.bram_addr_int[8]_i_3_n_0 ),
        .\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[9] (\GEN_DUAL_ADDR_CNT.bram_addr_int[9]_i_2_n_0 ),
        .Q(Q[7:0]),
        .aw_active(aw_active),
        .axi_awaddr_full(axi_awaddr_full),
        .axi_awlen_pipe_1_or_2(axi_awlen_pipe_1_or_2),
        .axi_awsize_pipe(axi_awsize_pipe),
        .bram_addr_ld_en(bram_addr_ld_en),
        .bvalid_cnt(bvalid_cnt),
        .curr_awlen_reg_1_or_2(curr_awlen_reg_1_or_2),
        .curr_fixed_burst_reg(curr_fixed_burst_reg),
        .curr_wrap_burst_reg(curr_wrap_burst_reg),
        .last_data_ack_mod(last_data_ack_mod),
        .s_axi_aclk(s_axi_aclk),
        .s_axi_awaddr(s_axi_awaddr),
        .\s_axi_awaddr[13] (p_1_in),
        .s_axi_awlen(s_axi_awlen[3:0]),
        .s_axi_awvalid(s_axi_awvalid),
        .s_axi_awvalid_0(I_WRAP_BRST_n_17),
        .s_axi_awvalid_1(I_WRAP_BRST_n_18),
        .s_axi_awvalid_2(I_WRAP_BRST_n_19),
        .s_axi_wvalid(s_axi_wvalid),
        .\save_init_bram_addr_ld_reg[13]_0 (axi_aresetn_d3),
        .\save_init_bram_addr_ld_reg[13]_1 (\GEN_AW_PIPE_DUAL.axi_awburst_pipe_fixed_reg_n_0 ),
        .wr_addr_sm_cs(wr_addr_sm_cs),
        .wr_data_sm_cs(wr_data_sm_cs),
        .\wrap_burst_total_reg[0]_0 (axi_awlen_pipe[3:0]),
        .\wrap_burst_total_reg[0]_1 (\wrap_burst_total_reg[0] ));
  FDRE #(
    .INIT(1'b0)) 
    \axi_bid_int_reg[0] 
       (.C(s_axi_aclk),
        .CE(BID_FIFO_n_1),
        .D(BID_FIFO_n_7),
        .Q(s_axi_bid[0]),
        .R(\wrap_burst_total_reg[0] ));
  FDRE #(
    .INIT(1'b0)) 
    \axi_bid_int_reg[1] 
       (.C(s_axi_aclk),
        .CE(BID_FIFO_n_1),
        .D(BID_FIFO_n_6),
        .Q(s_axi_bid[1]),
        .R(\wrap_burst_total_reg[0] ));
  FDRE #(
    .INIT(1'b0)) 
    \axi_bid_int_reg[2] 
       (.C(s_axi_aclk),
        .CE(BID_FIFO_n_1),
        .D(BID_FIFO_n_5),
        .Q(s_axi_bid[2]),
        .R(\wrap_burst_total_reg[0] ));
  FDRE #(
    .INIT(1'b0)) 
    \axi_bid_int_reg[3] 
       (.C(s_axi_aclk),
        .CE(BID_FIFO_n_1),
        .D(BID_FIFO_n_4),
        .Q(s_axi_bid[3]),
        .R(\wrap_burst_total_reg[0] ));
  LUT6 #(
    .INIT(64'hCCCCCCC4CCCCCCC0)) 
    axi_bvalid_int_i_1
       (.I0(BID_FIFO_n_3),
        .I1(s_axi_aresetn),
        .I2(BID_FIFO_n_0),
        .I3(bvalid_cnt[2]),
        .I4(bvalid_cnt[1]),
        .I5(bvalid_cnt[0]),
        .O(axi_bvalid_int_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    axi_bvalid_int_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(axi_bvalid_int_i_1_n_0),
        .Q(axi_bvalid_int_reg_0),
        .R(1'b0));
  LUT5 #(
    .INIT(32'hAABFAA80)) 
    axi_wr_burst_i_1
       (.I0(axi_wr_burst_cmb),
        .I1(axi_wr_burst_i_3_n_0),
        .I2(axi_wr_burst_i_4_n_0),
        .I3(axi_wr_burst_i_5_n_0),
        .I4(axi_wr_burst),
        .O(axi_wr_burst_i_1_n_0));
  LUT6 #(
    .INIT(64'h00030003F8FB080B)) 
    axi_wr_burst_i_2
       (.I0(axi_wr_burst_i_3_n_0),
        .I1(wr_data_sm_cs[1]),
        .I2(wr_data_sm_cs[0]),
        .I3(s_axi_wlast),
        .I4(s_axi_wvalid),
        .I5(wr_data_sm_cs[2]),
        .O(axi_wr_burst_cmb));
  LUT6 #(
    .INIT(64'h0100000001000100)) 
    axi_wr_burst_i_3
       (.I0(\GEN_AW_PIPE_DUAL.axi_awburst_pipe_fixed_reg_n_0 ),
        .I1(curr_awlen_reg_1_or_2),
        .I2(axi_awlen_pipe_1_or_2),
        .I3(axi_awaddr_full),
        .I4(bvalid_cnt[0]),
        .I5(axi_wr_burst_i_6_n_0),
        .O(axi_wr_burst_i_3_n_0));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT4 #(
    .INIT(16'h4000)) 
    axi_wr_burst_i_4
       (.I0(wr_data_sm_cs[2]),
        .I1(wr_data_sm_cs[1]),
        .I2(s_axi_wlast),
        .I3(s_axi_wvalid),
        .O(axi_wr_burst_i_4_n_0));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT4 #(
    .INIT(16'h400C)) 
    axi_wr_burst_i_5
       (.I0(wr_data_sm_cs[2]),
        .I1(s_axi_wvalid),
        .I2(wr_data_sm_cs[0]),
        .I3(wr_data_sm_cs[1]),
        .O(axi_wr_burst_i_5_n_0));
  LUT2 #(
    .INIT(4'h8)) 
    axi_wr_burst_i_6
       (.I0(bvalid_cnt[2]),
        .I1(bvalid_cnt[1]),
        .O(axi_wr_burst_i_6_n_0));
  FDRE #(
    .INIT(1'b0)) 
    axi_wr_burst_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(axi_wr_burst_i_1_n_0),
        .Q(axi_wr_burst),
        .R(\wrap_burst_total_reg[0] ));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT2 #(
    .INIT(4'h2)) 
    axi_wready_int_mod_i_1
       (.I0(s_axi_aresetn),
        .I1(axi_wdata_full_cmb),
        .O(axi_wready_int_mod_i_1_n_0));
  FDRE #(
    .INIT(1'b0)) 
    axi_wready_int_mod_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(axi_wready_int_mod_i_1_n_0),
        .Q(s_axi_wready),
        .R(1'b0));
  LUT6 #(
    .INIT(64'h0200020002000000)) 
    bid_gets_fifo_load_d1_i_2
       (.I0(s_axi_wlast),
        .I1(wr_data_sm_cs[2]),
        .I2(wr_data_sm_cs[0]),
        .I3(s_axi_wvalid),
        .I4(BID_FIFO_n_10),
        .I5(wr_data_sm_cs[1]),
        .O(bid_gets_fifo_load_d1_i_2_n_0));
  FDRE #(
    .INIT(1'b0)) 
    bid_gets_fifo_load_d1_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(bid_gets_fifo_load),
        .Q(bid_gets_fifo_load_d1),
        .R(\wrap_burst_total_reg[0] ));
  LUT6 #(
    .INIT(64'hF0000FFF1FFFE000)) 
    \bvalid_cnt[0]_i_1 
       (.I0(bvalid_cnt[2]),
        .I1(bvalid_cnt[1]),
        .I2(s_axi_bready),
        .I3(axi_bvalid_int_reg_0),
        .I4(BID_FIFO_n_0),
        .I5(bvalid_cnt[0]),
        .O(\bvalid_cnt[0]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hD5BF2A40D5BF2A00)) 
    \bvalid_cnt[1]_i_1 
       (.I0(BID_FIFO_n_0),
        .I1(axi_bvalid_int_reg_0),
        .I2(s_axi_bready),
        .I3(bvalid_cnt[0]),
        .I4(bvalid_cnt[1]),
        .I5(bvalid_cnt[2]),
        .O(\bvalid_cnt[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hD5FFFFBF2A000000)) 
    \bvalid_cnt[2]_i_1 
       (.I0(BID_FIFO_n_0),
        .I1(axi_bvalid_int_reg_0),
        .I2(s_axi_bready),
        .I3(bvalid_cnt[0]),
        .I4(bvalid_cnt[1]),
        .I5(bvalid_cnt[2]),
        .O(\bvalid_cnt[2]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \bvalid_cnt_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\bvalid_cnt[0]_i_1_n_0 ),
        .Q(bvalid_cnt[0]),
        .R(\wrap_burst_total_reg[0] ));
  FDRE #(
    .INIT(1'b0)) 
    \bvalid_cnt_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\bvalid_cnt[1]_i_1_n_0 ),
        .Q(bvalid_cnt[1]),
        .R(\wrap_burst_total_reg[0] ));
  FDRE #(
    .INIT(1'b0)) 
    \bvalid_cnt_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(\bvalid_cnt[2]_i_1_n_0 ),
        .Q(bvalid_cnt[2]),
        .R(\wrap_burst_total_reg[0] ));
  LUT6 #(
    .INIT(64'h0000000088888088)) 
    curr_awlen_reg_1_or_2_i_1
       (.I0(I_WRAP_BRST_n_17),
        .I1(I_WRAP_BRST_n_18),
        .I2(axi_awaddr_full),
        .I3(s_axi_awvalid),
        .I4(\GEN_AW_PIPE_DUAL.axi_awlen_pipe_1_or_2_i_2_n_0 ),
        .I5(curr_awlen_reg_1_or_2_i_2_n_0),
        .O(curr_awlen_reg_1_or_20));
  LUT6 #(
    .INIT(64'hDDDDDDDDDDDDDDD5)) 
    curr_awlen_reg_1_or_2_i_2
       (.I0(I_WRAP_BRST_n_19),
        .I1(axi_awaddr_full),
        .I2(axi_awlen_pipe[5]),
        .I3(axi_awlen_pipe[7]),
        .I4(axi_awlen_pipe[4]),
        .I5(axi_awlen_pipe[6]),
        .O(curr_awlen_reg_1_or_2_i_2_n_0));
  FDRE #(
    .INIT(1'b0)) 
    curr_awlen_reg_1_or_2_reg
       (.C(s_axi_aclk),
        .CE(bram_addr_ld_en),
        .D(curr_awlen_reg_1_or_20),
        .Q(curr_awlen_reg_1_or_2),
        .R(\wrap_burst_total_reg[0] ));
  LUT6 #(
    .INIT(64'h1F10FFFF1F100000)) 
    curr_fixed_burst_reg_i_1
       (.I0(axi_awburst_pipe[1]),
        .I1(axi_awburst_pipe[0]),
        .I2(axi_awaddr_full),
        .I3(curr_fixed_burst_reg_i_2_n_0),
        .I4(bram_addr_ld_en),
        .I5(curr_fixed_burst_reg),
        .O(curr_fixed_burst_reg_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT2 #(
    .INIT(4'h1)) 
    curr_fixed_burst_reg_i_2
       (.I0(s_axi_awburst[1]),
        .I1(s_axi_awburst[0]),
        .O(curr_fixed_burst_reg_i_2_n_0));
  FDRE #(
    .INIT(1'b0)) 
    curr_fixed_burst_reg_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(curr_fixed_burst_reg_i_1_n_0),
        .Q(curr_fixed_burst_reg),
        .R(\GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hB8)) 
    curr_wrap_burst_reg_i_1
       (.I0(curr_wrap_burst),
        .I1(bram_addr_ld_en),
        .I2(curr_wrap_burst_reg),
        .O(curr_wrap_burst_reg_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT5 #(
    .INIT(32'h20202F20)) 
    curr_wrap_burst_reg_i_2
       (.I0(axi_awburst_pipe[1]),
        .I1(axi_awburst_pipe[0]),
        .I2(axi_awaddr_full),
        .I3(s_axi_awburst[1]),
        .I4(s_axi_awburst[0]),
        .O(curr_wrap_burst));
  FDRE #(
    .INIT(1'b0)) 
    curr_wrap_burst_reg_reg
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(curr_wrap_burst_reg_i_1_n_0),
        .Q(curr_wrap_burst_reg),
        .R(\GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_1_n_0 ));
endmodule

(* ORIG_REF_NAME = "wrap_brst" *) 
module axi64_bram_ctrl_16KiB_wrap_brst
   (\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1] ,
    bram_addr_ld_en,
    \GEN_AW_DUAL.aw_active_reg ,
    D,
    \s_axi_awaddr[13] ,
    \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[6] ,
    E,
    \GEN_AW_DUAL.last_data_ack_mod_reg ,
    s_axi_awvalid_0,
    s_axi_awvalid_1,
    s_axi_awvalid_2,
    wr_data_sm_cs,
    s_axi_wvalid,
    aw_active,
    bvalid_cnt,
    Q,
    \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[6]_0 ,
    \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[8] ,
    \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[8]_0 ,
    \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[9] ,
    \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[11] ,
    curr_fixed_burst_reg,
    \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[10] ,
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe_reg ,
    s_axi_awaddr,
    axi_awaddr_full,
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[13].axi_awaddr_pipe_reg ,
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[4].axi_awaddr_pipe_reg ,
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[5].axi_awaddr_pipe_reg ,
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[6].axi_awaddr_pipe_reg ,
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[7].axi_awaddr_pipe_reg ,
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[8].axi_awaddr_pipe_reg ,
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[9].axi_awaddr_pipe_reg ,
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[10].axi_awaddr_pipe_reg ,
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[11].axi_awaddr_pipe_reg ,
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[12].axi_awaddr_pipe_reg ,
    \save_init_bram_addr_ld_reg[13]_0 ,
    s_axi_awvalid,
    wr_addr_sm_cs,
    last_data_ack_mod,
    axi_awlen_pipe_1_or_2,
    curr_awlen_reg_1_or_2,
    \save_init_bram_addr_ld_reg[13]_1 ,
    s_axi_awlen,
    \wrap_burst_total_reg[0]_0 ,
    axi_awsize_pipe,
    curr_wrap_burst_reg,
    \wrap_burst_total_reg[0]_1 ,
    s_axi_aclk);
  output \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1] ;
  output bram_addr_ld_en;
  output \GEN_AW_DUAL.aw_active_reg ;
  output [8:0]D;
  output [1:0]\s_axi_awaddr[13] ;
  output \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[6] ;
  output [0:0]E;
  output \GEN_AW_DUAL.last_data_ack_mod_reg ;
  output s_axi_awvalid_0;
  output s_axi_awvalid_1;
  output s_axi_awvalid_2;
  input [2:0]wr_data_sm_cs;
  input s_axi_wvalid;
  input aw_active;
  input [2:0]bvalid_cnt;
  input [7:0]Q;
  input \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[6]_0 ;
  input \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[8] ;
  input \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[8]_0 ;
  input \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[9] ;
  input \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[11] ;
  input curr_fixed_burst_reg;
  input \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[10] ;
  input \GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe_reg ;
  input [10:0]s_axi_awaddr;
  input axi_awaddr_full;
  input \GEN_AW_PIPE_DUAL.GEN_AWADDR[13].axi_awaddr_pipe_reg ;
  input \GEN_AW_PIPE_DUAL.GEN_AWADDR[4].axi_awaddr_pipe_reg ;
  input \GEN_AW_PIPE_DUAL.GEN_AWADDR[5].axi_awaddr_pipe_reg ;
  input \GEN_AW_PIPE_DUAL.GEN_AWADDR[6].axi_awaddr_pipe_reg ;
  input \GEN_AW_PIPE_DUAL.GEN_AWADDR[7].axi_awaddr_pipe_reg ;
  input \GEN_AW_PIPE_DUAL.GEN_AWADDR[8].axi_awaddr_pipe_reg ;
  input \GEN_AW_PIPE_DUAL.GEN_AWADDR[9].axi_awaddr_pipe_reg ;
  input \GEN_AW_PIPE_DUAL.GEN_AWADDR[10].axi_awaddr_pipe_reg ;
  input \GEN_AW_PIPE_DUAL.GEN_AWADDR[11].axi_awaddr_pipe_reg ;
  input \GEN_AW_PIPE_DUAL.GEN_AWADDR[12].axi_awaddr_pipe_reg ;
  input \save_init_bram_addr_ld_reg[13]_0 ;
  input s_axi_awvalid;
  input wr_addr_sm_cs;
  input last_data_ack_mod;
  input axi_awlen_pipe_1_or_2;
  input curr_awlen_reg_1_or_2;
  input \save_init_bram_addr_ld_reg[13]_1 ;
  input [3:0]s_axi_awlen;
  input [3:0]\wrap_burst_total_reg[0]_0 ;
  input [0:0]axi_awsize_pipe;
  input curr_wrap_burst_reg;
  input \wrap_burst_total_reg[0]_1 ;
  input s_axi_aclk;

  wire [8:0]D;
  wire [0:0]E;
  wire \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1] ;
  wire \GEN_AW_DUAL.aw_active_reg ;
  wire \GEN_AW_DUAL.last_data_ack_mod_reg ;
  wire \GEN_AW_PIPE_DUAL.GEN_AWADDR[10].axi_awaddr_pipe_reg ;
  wire \GEN_AW_PIPE_DUAL.GEN_AWADDR[11].axi_awaddr_pipe_reg ;
  wire \GEN_AW_PIPE_DUAL.GEN_AWADDR[12].axi_awaddr_pipe_reg ;
  wire \GEN_AW_PIPE_DUAL.GEN_AWADDR[13].axi_awaddr_pipe_reg ;
  wire \GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe_reg ;
  wire \GEN_AW_PIPE_DUAL.GEN_AWADDR[4].axi_awaddr_pipe_reg ;
  wire \GEN_AW_PIPE_DUAL.GEN_AWADDR[5].axi_awaddr_pipe_reg ;
  wire \GEN_AW_PIPE_DUAL.GEN_AWADDR[6].axi_awaddr_pipe_reg ;
  wire \GEN_AW_PIPE_DUAL.GEN_AWADDR[7].axi_awaddr_pipe_reg ;
  wire \GEN_AW_PIPE_DUAL.GEN_AWADDR[8].axi_awaddr_pipe_reg ;
  wire \GEN_AW_PIPE_DUAL.GEN_AWADDR[9].axi_awaddr_pipe_reg ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int[10]_i_2_n_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int[10]_i_4_n_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_6_n_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_4_n_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_5_n_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_2_n_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_3_n_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_2_n_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_4_n_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int[7]_i_3_n_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int[8]_i_2_n_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int[8]_i_4_n_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int[9]_i_3_n_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int[9]_i_4_n_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[10] ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[11] ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[6] ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[6]_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[8] ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[8]_0 ;
  wire \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[9] ;
  wire [7:0]Q;
  wire aw_active;
  wire axi_awaddr_full;
  wire axi_awlen_pipe_1_or_2;
  wire [0:0]axi_awsize_pipe;
  wire bram_addr_ld_en;
  wire [2:0]bvalid_cnt;
  wire curr_awlen_reg_1_or_2;
  wire curr_fixed_burst_reg;
  wire curr_wrap_burst_reg;
  wire last_data_ack_mod;
  wire [7:0]p_1_in;
  wire s_axi_aclk;
  wire [10:0]s_axi_awaddr;
  wire [1:0]\s_axi_awaddr[13] ;
  wire [3:0]s_axi_awlen;
  wire s_axi_awvalid;
  wire s_axi_awvalid_0;
  wire s_axi_awvalid_1;
  wire s_axi_awvalid_2;
  wire s_axi_wvalid;
  wire \save_init_bram_addr_ld[13]_i_5_n_0 ;
  wire \save_init_bram_addr_ld[5]_i_2_n_0 ;
  wire \save_init_bram_addr_ld[6]_i_2_n_0 ;
  wire \save_init_bram_addr_ld_reg[13]_0 ;
  wire \save_init_bram_addr_ld_reg[13]_1 ;
  wire \save_init_bram_addr_ld_reg_n_0_[10] ;
  wire \save_init_bram_addr_ld_reg_n_0_[11] ;
  wire \save_init_bram_addr_ld_reg_n_0_[12] ;
  wire \save_init_bram_addr_ld_reg_n_0_[13] ;
  wire \save_init_bram_addr_ld_reg_n_0_[4] ;
  wire \save_init_bram_addr_ld_reg_n_0_[5] ;
  wire \save_init_bram_addr_ld_reg_n_0_[6] ;
  wire \save_init_bram_addr_ld_reg_n_0_[7] ;
  wire \save_init_bram_addr_ld_reg_n_0_[8] ;
  wire \save_init_bram_addr_ld_reg_n_0_[9] ;
  wire wr_addr_sm_cs;
  wire [2:0]wr_data_sm_cs;
  wire \wrap_burst_total[0]_i_1_n_0 ;
  wire \wrap_burst_total[0]_i_2_n_0 ;
  wire \wrap_burst_total[1]_i_1_n_0 ;
  wire \wrap_burst_total[1]_i_2_n_0 ;
  wire \wrap_burst_total[2]_i_1_n_0 ;
  wire \wrap_burst_total[2]_i_2_n_0 ;
  wire [3:0]\wrap_burst_total_reg[0]_0 ;
  wire \wrap_burst_total_reg[0]_1 ;
  wire \wrap_burst_total_reg_n_0_[0] ;
  wire \wrap_burst_total_reg_n_0_[1] ;
  wire \wrap_burst_total_reg_n_0_[2] ;

  LUT6 #(
    .INIT(64'hFFFF2EE22EE22EE2)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[10]_i_1 
       (.I0(\GEN_DUAL_ADDR_CNT.bram_addr_int[10]_i_2_n_0 ),
        .I1(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1] ),
        .I2(\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[10] ),
        .I3(Q[7]),
        .I4(\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[8] ),
        .I5(\GEN_DUAL_ADDR_CNT.bram_addr_int[10]_i_4_n_0 ),
        .O(D[7]));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT4 #(
    .INIT(16'h0B08)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[10]_i_2 
       (.I0(\GEN_AW_PIPE_DUAL.GEN_AWADDR[10].axi_awaddr_pipe_reg ),
        .I1(axi_awaddr_full),
        .I2(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0 ),
        .I3(s_axi_awaddr[7]),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int[10]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[10]_i_4 
       (.I0(\save_init_bram_addr_ld_reg_n_0_[10] ),
        .I1(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0 ),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int[10]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h00040000FFFFFFFF)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_1 
       (.I0(curr_fixed_burst_reg),
        .I1(wr_data_sm_cs[1]),
        .I2(wr_data_sm_cs[2]),
        .I3(wr_data_sm_cs[0]),
        .I4(s_axi_wvalid),
        .I5(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1] ),
        .O(E));
  LUT6 #(
    .INIT(64'hD555D555C000FFFF)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_2 
       (.I0(\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[11] ),
        .I1(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0 ),
        .I2(\save_init_bram_addr_ld_reg_n_0_[11] ),
        .I3(\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[8] ),
        .I4(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_6_n_0 ),
        .I5(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1] ),
        .O(D[8]));
  LUT2 #(
    .INIT(4'h1)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4 
       (.I0(bram_addr_ld_en),
        .I1(\GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_4_n_0 ),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT4 #(
    .INIT(16'hF4F7)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_6 
       (.I0(\GEN_AW_PIPE_DUAL.GEN_AWADDR[11].axi_awaddr_pipe_reg ),
        .I1(axi_awaddr_full),
        .I2(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0 ),
        .I3(s_axi_awaddr[8]),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h5555554555555555)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_3 
       (.I0(bram_addr_ld_en),
        .I1(\GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_4_n_0 ),
        .I2(wr_data_sm_cs[1]),
        .I3(wr_data_sm_cs[2]),
        .I4(wr_data_sm_cs[0]),
        .I5(s_axi_wvalid),
        .O(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1] ));
  LUT6 #(
    .INIT(64'h55555155FFFFFFFF)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_4 
       (.I0(\GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_5_n_0 ),
        .I1(\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[6] ),
        .I2(\wrap_burst_total_reg_n_0_[1] ),
        .I3(\wrap_burst_total_reg_n_0_[2] ),
        .I4(\wrap_burst_total_reg_n_0_[0] ),
        .I5(curr_wrap_burst_reg),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h00000000B000C0C0)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_5 
       (.I0(Q[2]),
        .I1(\wrap_burst_total_reg_n_0_[0] ),
        .I2(Q[0]),
        .I3(Q[1]),
        .I4(\wrap_burst_total_reg_n_0_[1] ),
        .I5(\wrap_burst_total_reg_n_0_[2] ),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hAE0CAE0CFF0C0C0C)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[3]_i_1 
       (.I0(\GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe_reg ),
        .I1(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1] ),
        .I2(Q[0]),
        .I3(bram_addr_ld_en),
        .I4(s_axi_awaddr[0]),
        .I5(axi_awaddr_full),
        .O(D[0]));
  LUT6 #(
    .INIT(64'h2FF22FF22222FFFF)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_1 
       (.I0(\GEN_DUAL_ADDR_CNT.bram_addr_int[9]_i_3_n_0 ),
        .I1(\GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_2_n_0 ),
        .I2(Q[1]),
        .I3(Q[0]),
        .I4(\GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_3_n_0 ),
        .I5(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1] ),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT4 #(
    .INIT(16'h37F3)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_2 
       (.I0(\wrap_burst_total_reg_n_0_[0] ),
        .I1(\save_init_bram_addr_ld_reg_n_0_[4] ),
        .I2(\wrap_burst_total_reg_n_0_[1] ),
        .I3(\wrap_burst_total_reg_n_0_[2] ),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT4 #(
    .INIT(16'hF4F7)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_3 
       (.I0(\GEN_AW_PIPE_DUAL.GEN_AWADDR[4].axi_awaddr_pipe_reg ),
        .I1(axi_awaddr_full),
        .I2(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0 ),
        .I3(s_axi_awaddr[1]),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_3_n_0 ));
  LUT5 #(
    .INIT(32'h6AFF6A00)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_1 
       (.I0(Q[2]),
        .I1(Q[0]),
        .I2(Q[1]),
        .I3(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1] ),
        .I4(p_1_in[1]),
        .O(D[2]));
  LUT6 #(
    .INIT(64'hF22FF22F2222FFFF)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_1 
       (.I0(\GEN_DUAL_ADDR_CNT.bram_addr_int[9]_i_3_n_0 ),
        .I1(\GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_2_n_0 ),
        .I2(\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[6]_0 ),
        .I3(Q[3]),
        .I4(\GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_4_n_0 ),
        .I5(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1] ),
        .O(D[3]));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT4 #(
    .INIT(16'h04FF)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_2 
       (.I0(\wrap_burst_total_reg_n_0_[1] ),
        .I1(\wrap_burst_total_reg_n_0_[2] ),
        .I2(\wrap_burst_total_reg_n_0_[0] ),
        .I3(\save_init_bram_addr_ld_reg_n_0_[6] ),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT4 #(
    .INIT(16'hF4F7)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_4 
       (.I0(\GEN_AW_PIPE_DUAL.GEN_AWADDR[6].axi_awaddr_pipe_reg ),
        .I1(axi_awaddr_full),
        .I2(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0 ),
        .I3(s_axi_awaddr[3]),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h8FF88FF88888FFFF)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[7]_i_1 
       (.I0(\save_init_bram_addr_ld_reg_n_0_[7] ),
        .I1(\GEN_DUAL_ADDR_CNT.bram_addr_int[9]_i_3_n_0 ),
        .I2(\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[6] ),
        .I3(Q[4]),
        .I4(\GEN_DUAL_ADDR_CNT.bram_addr_int[7]_i_3_n_0 ),
        .I5(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1] ),
        .O(D[4]));
  LUT4 #(
    .INIT(16'h8000)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[7]_i_2 
       (.I0(Q[3]),
        .I1(Q[2]),
        .I2(Q[0]),
        .I3(Q[1]),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[6] ));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT4 #(
    .INIT(16'hF4F7)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[7]_i_3 
       (.I0(\GEN_AW_PIPE_DUAL.GEN_AWADDR[7].axi_awaddr_pipe_reg ),
        .I1(axi_awaddr_full),
        .I2(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0 ),
        .I3(s_axi_awaddr[4]),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int[7]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h8FF88FF88888FFFF)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[8]_i_1 
       (.I0(\GEN_DUAL_ADDR_CNT.bram_addr_int[8]_i_2_n_0 ),
        .I1(\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[8] ),
        .I2(\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[8]_0 ),
        .I3(Q[5]),
        .I4(\GEN_DUAL_ADDR_CNT.bram_addr_int[8]_i_4_n_0 ),
        .I5(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1] ),
        .O(D[5]));
  LUT2 #(
    .INIT(4'h8)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[8]_i_2 
       (.I0(\save_init_bram_addr_ld_reg_n_0_[8] ),
        .I1(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0 ),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int[8]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT4 #(
    .INIT(16'hF4F7)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[8]_i_4 
       (.I0(\GEN_AW_PIPE_DUAL.GEN_AWADDR[8].axi_awaddr_pipe_reg ),
        .I1(axi_awaddr_full),
        .I2(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0 ),
        .I3(s_axi_awaddr[5]),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int[8]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'hF666F666F000FFFF)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[9]_i_1 
       (.I0(\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[9] ),
        .I1(Q[6]),
        .I2(\save_init_bram_addr_ld_reg_n_0_[9] ),
        .I3(\GEN_DUAL_ADDR_CNT.bram_addr_int[9]_i_3_n_0 ),
        .I4(\GEN_DUAL_ADDR_CNT.bram_addr_int[9]_i_4_n_0 ),
        .I5(\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1] ),
        .O(D[6]));
  LUT5 #(
    .INIT(32'h00080000)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[9]_i_3 
       (.I0(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0 ),
        .I1(s_axi_wvalid),
        .I2(wr_data_sm_cs[0]),
        .I3(wr_data_sm_cs[2]),
        .I4(wr_data_sm_cs[1]),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int[9]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT4 #(
    .INIT(16'hF4F7)) 
    \GEN_DUAL_ADDR_CNT.bram_addr_int[9]_i_4 
       (.I0(\GEN_AW_PIPE_DUAL.GEN_AWADDR[9].axi_awaddr_pipe_reg ),
        .I1(axi_awaddr_full),
        .I2(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0 ),
        .I3(s_axi_awaddr[6]),
        .O(\GEN_DUAL_ADDR_CNT.bram_addr_int[9]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT5 #(
    .INIT(32'hFFE200E2)) 
    \save_init_bram_addr_ld[10]_i_1 
       (.I0(s_axi_awaddr[7]),
        .I1(axi_awaddr_full),
        .I2(\GEN_AW_PIPE_DUAL.GEN_AWADDR[10].axi_awaddr_pipe_reg ),
        .I3(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0 ),
        .I4(\save_init_bram_addr_ld_reg_n_0_[10] ),
        .O(p_1_in[6]));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT5 #(
    .INIT(32'hAFACA0AC)) 
    \save_init_bram_addr_ld[11]_i_1 
       (.I0(\save_init_bram_addr_ld_reg_n_0_[11] ),
        .I1(s_axi_awaddr[8]),
        .I2(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0 ),
        .I3(axi_awaddr_full),
        .I4(\GEN_AW_PIPE_DUAL.GEN_AWADDR[11].axi_awaddr_pipe_reg ),
        .O(p_1_in[7]));
  LUT5 #(
    .INIT(32'hCFC0CACA)) 
    \save_init_bram_addr_ld[12]_i_1 
       (.I0(s_axi_awaddr[9]),
        .I1(\save_init_bram_addr_ld_reg_n_0_[12] ),
        .I2(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0 ),
        .I3(\GEN_AW_PIPE_DUAL.GEN_AWADDR[12].axi_awaddr_pipe_reg ),
        .I4(axi_awaddr_full),
        .O(\s_axi_awaddr[13] [0]));
  LUT6 #(
    .INIT(64'h8888AAA888888888)) 
    \save_init_bram_addr_ld[13]_i_1 
       (.I0(\save_init_bram_addr_ld_reg[13]_0 ),
        .I1(\GEN_AW_DUAL.last_data_ack_mod_reg ),
        .I2(axi_awaddr_full),
        .I3(s_axi_awvalid),
        .I4(wr_addr_sm_cs),
        .I5(\GEN_AW_DUAL.aw_active_reg ),
        .O(bram_addr_ld_en));
  LUT5 #(
    .INIT(32'hCFC0CACA)) 
    \save_init_bram_addr_ld[13]_i_2 
       (.I0(s_axi_awaddr[10]),
        .I1(\save_init_bram_addr_ld_reg_n_0_[13] ),
        .I2(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0 ),
        .I3(\GEN_AW_PIPE_DUAL.GEN_AWADDR[13].axi_awaddr_pipe_reg ),
        .I4(axi_awaddr_full),
        .O(\s_axi_awaddr[13] [1]));
  LUT6 #(
    .INIT(64'h0000000000000040)) 
    \save_init_bram_addr_ld[13]_i_3 
       (.I0(\save_init_bram_addr_ld[13]_i_5_n_0 ),
        .I1(last_data_ack_mod),
        .I2(axi_awaddr_full),
        .I3(axi_awlen_pipe_1_or_2),
        .I4(curr_awlen_reg_1_or_2),
        .I5(\save_init_bram_addr_ld_reg[13]_1 ),
        .O(\GEN_AW_DUAL.last_data_ack_mod_reg ));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT4 #(
    .INIT(16'h1555)) 
    \save_init_bram_addr_ld[13]_i_4 
       (.I0(aw_active),
        .I1(bvalid_cnt[0]),
        .I2(bvalid_cnt[2]),
        .I3(bvalid_cnt[1]),
        .O(\GEN_AW_DUAL.aw_active_reg ));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \save_init_bram_addr_ld[13]_i_5 
       (.I0(bvalid_cnt[1]),
        .I1(bvalid_cnt[2]),
        .I2(bvalid_cnt[0]),
        .O(\save_init_bram_addr_ld[13]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT5 #(
    .INIT(32'h00E2FFE2)) 
    \save_init_bram_addr_ld[4]_i_1 
       (.I0(s_axi_awaddr[1]),
        .I1(axi_awaddr_full),
        .I2(\GEN_AW_PIPE_DUAL.GEN_AWADDR[4].axi_awaddr_pipe_reg ),
        .I3(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0 ),
        .I4(\GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_2_n_0 ),
        .O(p_1_in[0]));
  LUT5 #(
    .INIT(32'h3F0C2E2E)) 
    \save_init_bram_addr_ld[5]_i_1 
       (.I0(s_axi_awaddr[2]),
        .I1(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0 ),
        .I2(\save_init_bram_addr_ld[5]_i_2_n_0 ),
        .I3(\GEN_AW_PIPE_DUAL.GEN_AWADDR[5].axi_awaddr_pipe_reg ),
        .I4(axi_awaddr_full),
        .O(p_1_in[1]));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT4 #(
    .INIT(16'h24FF)) 
    \save_init_bram_addr_ld[5]_i_2 
       (.I0(\wrap_burst_total_reg_n_0_[0] ),
        .I1(\wrap_burst_total_reg_n_0_[2] ),
        .I2(\wrap_burst_total_reg_n_0_[1] ),
        .I3(\save_init_bram_addr_ld_reg_n_0_[5] ),
        .O(\save_init_bram_addr_ld[5]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h44FF44F0440044F0)) 
    \save_init_bram_addr_ld[6]_i_1 
       (.I0(\save_init_bram_addr_ld[6]_i_2_n_0 ),
        .I1(\save_init_bram_addr_ld_reg_n_0_[6] ),
        .I2(s_axi_awaddr[3]),
        .I3(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0 ),
        .I4(axi_awaddr_full),
        .I5(\GEN_AW_PIPE_DUAL.GEN_AWADDR[6].axi_awaddr_pipe_reg ),
        .O(p_1_in[2]));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT3 #(
    .INIT(8'h04)) 
    \save_init_bram_addr_ld[6]_i_2 
       (.I0(\wrap_burst_total_reg_n_0_[0] ),
        .I1(\wrap_burst_total_reg_n_0_[2] ),
        .I2(\wrap_burst_total_reg_n_0_[1] ),
        .O(\save_init_bram_addr_ld[6]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT5 #(
    .INIT(32'hFFE200E2)) 
    \save_init_bram_addr_ld[7]_i_1 
       (.I0(s_axi_awaddr[4]),
        .I1(axi_awaddr_full),
        .I2(\GEN_AW_PIPE_DUAL.GEN_AWADDR[7].axi_awaddr_pipe_reg ),
        .I3(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0 ),
        .I4(\save_init_bram_addr_ld_reg_n_0_[7] ),
        .O(p_1_in[3]));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT5 #(
    .INIT(32'hAFACA0AC)) 
    \save_init_bram_addr_ld[8]_i_1 
       (.I0(\save_init_bram_addr_ld_reg_n_0_[8] ),
        .I1(s_axi_awaddr[5]),
        .I2(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0 ),
        .I3(axi_awaddr_full),
        .I4(\GEN_AW_PIPE_DUAL.GEN_AWADDR[8].axi_awaddr_pipe_reg ),
        .O(p_1_in[4]));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT5 #(
    .INIT(32'hFFE200E2)) 
    \save_init_bram_addr_ld[9]_i_1 
       (.I0(s_axi_awaddr[6]),
        .I1(axi_awaddr_full),
        .I2(\GEN_AW_PIPE_DUAL.GEN_AWADDR[9].axi_awaddr_pipe_reg ),
        .I3(\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0 ),
        .I4(\save_init_bram_addr_ld_reg_n_0_[9] ),
        .O(p_1_in[5]));
  FDRE #(
    .INIT(1'b0)) 
    \save_init_bram_addr_ld_reg[10] 
       (.C(s_axi_aclk),
        .CE(bram_addr_ld_en),
        .D(p_1_in[6]),
        .Q(\save_init_bram_addr_ld_reg_n_0_[10] ),
        .R(\wrap_burst_total_reg[0]_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \save_init_bram_addr_ld_reg[11] 
       (.C(s_axi_aclk),
        .CE(bram_addr_ld_en),
        .D(p_1_in[7]),
        .Q(\save_init_bram_addr_ld_reg_n_0_[11] ),
        .R(\wrap_burst_total_reg[0]_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \save_init_bram_addr_ld_reg[12] 
       (.C(s_axi_aclk),
        .CE(bram_addr_ld_en),
        .D(\s_axi_awaddr[13] [0]),
        .Q(\save_init_bram_addr_ld_reg_n_0_[12] ),
        .R(\wrap_burst_total_reg[0]_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \save_init_bram_addr_ld_reg[13] 
       (.C(s_axi_aclk),
        .CE(bram_addr_ld_en),
        .D(\s_axi_awaddr[13] [1]),
        .Q(\save_init_bram_addr_ld_reg_n_0_[13] ),
        .R(\wrap_burst_total_reg[0]_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \save_init_bram_addr_ld_reg[4] 
       (.C(s_axi_aclk),
        .CE(bram_addr_ld_en),
        .D(p_1_in[0]),
        .Q(\save_init_bram_addr_ld_reg_n_0_[4] ),
        .R(\wrap_burst_total_reg[0]_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \save_init_bram_addr_ld_reg[5] 
       (.C(s_axi_aclk),
        .CE(bram_addr_ld_en),
        .D(p_1_in[1]),
        .Q(\save_init_bram_addr_ld_reg_n_0_[5] ),
        .R(\wrap_burst_total_reg[0]_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \save_init_bram_addr_ld_reg[6] 
       (.C(s_axi_aclk),
        .CE(bram_addr_ld_en),
        .D(p_1_in[2]),
        .Q(\save_init_bram_addr_ld_reg_n_0_[6] ),
        .R(\wrap_burst_total_reg[0]_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \save_init_bram_addr_ld_reg[7] 
       (.C(s_axi_aclk),
        .CE(bram_addr_ld_en),
        .D(p_1_in[3]),
        .Q(\save_init_bram_addr_ld_reg_n_0_[7] ),
        .R(\wrap_burst_total_reg[0]_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \save_init_bram_addr_ld_reg[8] 
       (.C(s_axi_aclk),
        .CE(bram_addr_ld_en),
        .D(p_1_in[4]),
        .Q(\save_init_bram_addr_ld_reg_n_0_[8] ),
        .R(\wrap_burst_total_reg[0]_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \save_init_bram_addr_ld_reg[9] 
       (.C(s_axi_aclk),
        .CE(bram_addr_ld_en),
        .D(p_1_in[5]),
        .Q(\save_init_bram_addr_ld_reg_n_0_[9] ),
        .R(\wrap_burst_total_reg[0]_1 ));
  LUT6 #(
    .INIT(64'h4500004500000010)) 
    \wrap_burst_total[0]_i_1 
       (.I0(\wrap_burst_total[0]_i_2_n_0 ),
        .I1(axi_awsize_pipe),
        .I2(axi_awaddr_full),
        .I3(s_axi_awvalid_0),
        .I4(s_axi_awvalid_1),
        .I5(s_axi_awvalid_2),
        .O(\wrap_burst_total[0]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0F77)) 
    \wrap_burst_total[0]_i_2 
       (.I0(s_axi_awvalid),
        .I1(s_axi_awlen[0]),
        .I2(\wrap_burst_total_reg[0]_0 [0]),
        .I3(axi_awaddr_full),
        .O(\wrap_burst_total[0]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT4 #(
    .INIT(16'h0F77)) 
    \wrap_burst_total[0]_i_3 
       (.I0(s_axi_awvalid),
        .I1(s_axi_awlen[1]),
        .I2(\wrap_burst_total_reg[0]_0 [1]),
        .I3(axi_awaddr_full),
        .O(s_axi_awvalid_0));
  LUT4 #(
    .INIT(16'h0F77)) 
    \wrap_burst_total[0]_i_4 
       (.I0(s_axi_awvalid),
        .I1(s_axi_awlen[2]),
        .I2(\wrap_burst_total_reg[0]_0 [2]),
        .I3(axi_awaddr_full),
        .O(s_axi_awvalid_1));
  LUT4 #(
    .INIT(16'h0F77)) 
    \wrap_burst_total[0]_i_5 
       (.I0(s_axi_awvalid),
        .I1(s_axi_awlen[3]),
        .I2(\wrap_burst_total_reg[0]_0 [3]),
        .I3(axi_awaddr_full),
        .O(s_axi_awvalid_2));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT5 #(
    .INIT(32'hA2808080)) 
    \wrap_burst_total[1]_i_1 
       (.I0(\wrap_burst_total[1]_i_2_n_0 ),
        .I1(axi_awaddr_full),
        .I2(\wrap_burst_total_reg[0]_0 [1]),
        .I3(s_axi_awlen[1]),
        .I4(s_axi_awvalid),
        .O(\wrap_burst_total[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hF088008800000000)) 
    \wrap_burst_total[1]_i_2 
       (.I0(s_axi_awvalid),
        .I1(s_axi_awlen[0]),
        .I2(\wrap_burst_total_reg[0]_0 [0]),
        .I3(axi_awaddr_full),
        .I4(axi_awsize_pipe),
        .I5(s_axi_awvalid_2),
        .O(\wrap_burst_total[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hF088008800000000)) 
    \wrap_burst_total[2]_i_1 
       (.I0(s_axi_awvalid),
        .I1(s_axi_awlen[0]),
        .I2(\wrap_burst_total_reg[0]_0 [0]),
        .I3(axi_awaddr_full),
        .I4(axi_awsize_pipe),
        .I5(\wrap_burst_total[2]_i_2_n_0 ),
        .O(\wrap_burst_total[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000055004040)) 
    \wrap_burst_total[2]_i_2 
       (.I0(s_axi_awvalid_0),
        .I1(s_axi_awvalid),
        .I2(s_axi_awlen[2]),
        .I3(\wrap_burst_total_reg[0]_0 [2]),
        .I4(axi_awaddr_full),
        .I5(s_axi_awvalid_2),
        .O(\wrap_burst_total[2]_i_2_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \wrap_burst_total_reg[0] 
       (.C(s_axi_aclk),
        .CE(bram_addr_ld_en),
        .D(\wrap_burst_total[0]_i_1_n_0 ),
        .Q(\wrap_burst_total_reg_n_0_[0] ),
        .R(\wrap_burst_total_reg[0]_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \wrap_burst_total_reg[1] 
       (.C(s_axi_aclk),
        .CE(bram_addr_ld_en),
        .D(\wrap_burst_total[1]_i_1_n_0 ),
        .Q(\wrap_burst_total_reg_n_0_[1] ),
        .R(\wrap_burst_total_reg[0]_1 ));
  FDRE #(
    .INIT(1'b0)) 
    \wrap_burst_total_reg[2] 
       (.C(s_axi_aclk),
        .CE(bram_addr_ld_en),
        .D(\wrap_burst_total[2]_i_1_n_0 ),
        .Q(\wrap_burst_total_reg_n_0_[2] ),
        .R(\wrap_burst_total_reg[0]_1 ));
endmodule

(* ORIG_REF_NAME = "wrap_brst_rd" *) 
module axi64_bram_ctrl_16KiB_wrap_brst_rd
   (\GEN_RD_CMD_OPT.wrap_addr_assign_reg ,
    \wrap_burst_total_reg_reg[1]_0 ,
    \GEN_RD_CMD_OPT.axi_rvalid_int_reg ,
    SR,
    D,
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8] ,
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7] ,
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[9] ,
    bram_addr_b,
    \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ,
    arlen_temp,
    addr_vld_rdy5_out,
    \GEN_RD_CMD_OPT.wrap_addr_assign_reg_0 ,
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[6] ,
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7]_0 ,
    \GEN_RD_CMD_OPT.arlen_reg_reg[1] ,
    \GEN_RD_CMD_OPT.arlen_reg_reg[1]_0 ,
    rd_active,
    rd_cmd_reg,
    s_axi_arlen,
    s_axi_aresetn,
    s_axi_araddr,
    wrap_addr_assign,
    Q,
    \GEN_RD_CMD_OPT.wrap_addr_assign_reg_1 ,
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[4] ,
    \bram_addr_b[4] ,
    \bram_addr_b[4]_0 ,
    \bram_addr_b[5] ,
    \bram_addr_b[6] ,
    \bram_addr_b[5]_0 ,
    \GEN_RD_CMD_OPT.arlen_reg_reg[3] ,
    \wrap_burst_total_reg_reg[1]_1 ,
    s_axi_arvalid,
    axi_aresetn_d3,
    \GEN_RD_CMD_OPT.arlen_reg_reg[2] ,
    s_axi_rready,
    rd_data_sm_cs,
    axi_rlast_cmb_reg,
    \GEN_RD_CMD_OPT.wrap_addr_assign_reg_2 ,
    bram_en_b,
    s_axi_aclk);
  output \GEN_RD_CMD_OPT.wrap_addr_assign_reg ;
  output \wrap_burst_total_reg_reg[1]_0 ;
  output \GEN_RD_CMD_OPT.axi_rvalid_int_reg ;
  output [0:0]SR;
  output [9:0]D;
  output \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8] ;
  output \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7] ;
  output \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[9] ;
  output [2:0]bram_addr_b;
  output \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ;
  output [2:0]arlen_temp;
  output addr_vld_rdy5_out;
  output \GEN_RD_CMD_OPT.wrap_addr_assign_reg_0 ;
  input \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[6] ;
  input \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7]_0 ;
  input \GEN_RD_CMD_OPT.arlen_reg_reg[1] ;
  input \GEN_RD_CMD_OPT.arlen_reg_reg[1]_0 ;
  input rd_active;
  input rd_cmd_reg;
  input [3:0]s_axi_arlen;
  input s_axi_aresetn;
  input [10:0]s_axi_araddr;
  input wrap_addr_assign;
  input [8:0]Q;
  input \GEN_RD_CMD_OPT.wrap_addr_assign_reg_1 ;
  input \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[4] ;
  input \bram_addr_b[4] ;
  input \bram_addr_b[4]_0 ;
  input \bram_addr_b[5] ;
  input \bram_addr_b[6] ;
  input \bram_addr_b[5]_0 ;
  input [2:0]\GEN_RD_CMD_OPT.arlen_reg_reg[3] ;
  input [1:0]\wrap_burst_total_reg_reg[1]_1 ;
  input s_axi_arvalid;
  input axi_aresetn_d3;
  input \GEN_RD_CMD_OPT.arlen_reg_reg[2] ;
  input s_axi_rready;
  input [1:0]rd_data_sm_cs;
  input axi_rlast_cmb_reg;
  input \GEN_RD_CMD_OPT.wrap_addr_assign_reg_2 ;
  input bram_en_b;
  input s_axi_aclk;

  wire [9:0]D;
  wire \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ;
  wire \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_2_n_0 ;
  wire \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_3_n_0 ;
  wire \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[5]_i_2_n_0 ;
  wire \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[6]_i_3_n_0 ;
  wire \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[4] ;
  wire \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[6] ;
  wire \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7] ;
  wire \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7]_0 ;
  wire \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8] ;
  wire \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[9] ;
  wire \GEN_RD_CMD_OPT.arlen_reg[3]_i_2_n_0 ;
  wire \GEN_RD_CMD_OPT.arlen_reg_reg[1] ;
  wire \GEN_RD_CMD_OPT.arlen_reg_reg[1]_0 ;
  wire \GEN_RD_CMD_OPT.arlen_reg_reg[2] ;
  wire [2:0]\GEN_RD_CMD_OPT.arlen_reg_reg[3] ;
  wire \GEN_RD_CMD_OPT.axi_rvalid_int_reg ;
  wire \GEN_RD_CMD_OPT.wrap_addr_assign_i_2_n_0 ;
  wire \GEN_RD_CMD_OPT.wrap_addr_assign_reg ;
  wire \GEN_RD_CMD_OPT.wrap_addr_assign_reg_0 ;
  wire \GEN_RD_CMD_OPT.wrap_addr_assign_reg_1 ;
  wire \GEN_RD_CMD_OPT.wrap_addr_assign_reg_2 ;
  wire [8:0]Q;
  wire [0:0]SR;
  wire addr_vld_rdy5_out;
  wire [2:0]arlen_temp;
  wire axi_aresetn_d3;
  wire axi_rlast_cmb_reg;
  wire [2:0]bram_addr_b;
  wire \bram_addr_b[4] ;
  wire \bram_addr_b[4]_0 ;
  wire \bram_addr_b[4]_INST_0_i_1_n_0 ;
  wire \bram_addr_b[5] ;
  wire \bram_addr_b[5]_0 ;
  wire \bram_addr_b[5]_INST_0_i_11_n_0 ;
  wire \bram_addr_b[5]_INST_0_i_2_n_0 ;
  wire \bram_addr_b[5]_INST_0_i_5_n_0 ;
  wire \bram_addr_b[5]_INST_0_i_7_n_0 ;
  wire \bram_addr_b[5]_INST_0_i_8_n_0 ;
  wire \bram_addr_b[5]_INST_0_i_9_n_0 ;
  wire \bram_addr_b[6] ;
  wire \bram_addr_b[6]_INST_0_i_1_n_0 ;
  wire bram_en_b;
  wire rd_active;
  wire rd_cmd_reg;
  wire [1:0]rd_data_sm_cs;
  wire s_axi_aclk;
  wire [10:0]s_axi_araddr;
  wire s_axi_aresetn;
  wire [3:0]s_axi_arlen;
  wire s_axi_arvalid;
  wire s_axi_rready;
  wire [13:7]save_init_bram_addr_ld;
  wire [13:4]save_init_bram_addr_ld_reg;
  wire wrap_addr_assign;
  wire [2:0]wrap_burst_total;
  wire [2:0]wrap_burst_total_reg;
  wire \wrap_burst_total_reg[0]_i_2_n_0 ;
  wire \wrap_burst_total_reg[0]_i_3_n_0 ;
  wire \wrap_burst_total_reg[0]_i_4_n_0 ;
  wire \wrap_burst_total_reg_reg[1]_0 ;
  wire [1:0]\wrap_burst_total_reg_reg[1]_1 ;

  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h6AAAAAAA)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[10]_i_1 
       (.I0(bram_addr_b[1]),
        .I1(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8] ),
        .I2(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_2_n_0 ),
        .I3(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7] ),
        .I4(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[9] ),
        .O(D[6]));
  LUT6 #(
    .INIT(64'h6AAAAAAAAAAAAAAA)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_1 
       (.I0(bram_addr_b[2]),
        .I1(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[9] ),
        .I2(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7] ),
        .I3(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_2_n_0 ),
        .I4(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8] ),
        .I5(bram_addr_b[1]),
        .O(D[7]));
  LUT6 #(
    .INIT(64'h2F00000000000000)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_2 
       (.I0(\bram_addr_b[6]_INST_0_i_1_n_0 ),
        .I1(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_3_n_0 ),
        .I2(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[6] ),
        .I3(\GEN_RD_CMD_OPT.wrap_addr_assign_reg ),
        .I4(\wrap_burst_total_reg_reg[1]_0 ),
        .I5(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7]_0 ),
        .O(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h7F)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_3 
       (.I0(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I1(wrap_addr_assign),
        .I2(save_init_bram_addr_ld_reg[6]),
        .O(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'hA9AA9999A9AAAAAA)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[4]_i_1 
       (.I0(\wrap_burst_total_reg_reg[1]_0 ),
        .I1(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[4] ),
        .I2(wrap_addr_assign),
        .I3(Q[0]),
        .I4(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I5(s_axi_araddr[0]),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT2 #(
    .INIT(4'h9)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[5]_i_1 
       (.I0(\GEN_RD_CMD_OPT.wrap_addr_assign_reg ),
        .I1(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[5]_i_2_n_0 ),
        .O(D[1]));
  LUT6 #(
    .INIT(64'hFDFFDDDDFDFFFFFF)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[5]_i_2 
       (.I0(\wrap_burst_total_reg_reg[1]_0 ),
        .I1(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[4] ),
        .I2(wrap_addr_assign),
        .I3(Q[0]),
        .I4(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I5(s_axi_araddr[0]),
        .O(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[5]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h8000FFFF7FFF0000)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[6]_i_1 
       (.I0(\bram_addr_b[6]_INST_0_i_1_n_0 ),
        .I1(save_init_bram_addr_ld_reg[6]),
        .I2(wrap_addr_assign),
        .I3(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I4(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[6] ),
        .I5(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[6]_i_3_n_0 ),
        .O(D[2]));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT4 #(
    .INIT(16'hEFFF)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[6]_i_3 
       (.I0(\GEN_RD_CMD_OPT.wrap_addr_assign_reg_1 ),
        .I1(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[4] ),
        .I2(\wrap_burst_total_reg_reg[1]_0 ),
        .I3(\GEN_RD_CMD_OPT.wrap_addr_assign_reg ),
        .O(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[6]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h30553F55CFAAC0AA)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[7]_i_1 
       (.I0(s_axi_araddr[4]),
        .I1(save_init_bram_addr_ld_reg[7]),
        .I2(wrap_addr_assign),
        .I3(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I4(Q[2]),
        .I5(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_2_n_0 ),
        .O(D[3]));
  LUT3 #(
    .INIT(8'h6A)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[8]_i_1 
       (.I0(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8] ),
        .I1(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_2_n_0 ),
        .I2(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7] ),
        .O(D[4]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h6AAA)) 
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[9]_i_1 
       (.I0(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[9] ),
        .I1(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7] ),
        .I2(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_2_n_0 ),
        .I3(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8] ),
        .O(D[5]));
  LUT6 #(
    .INIT(64'hAAAAFFFEAAAA0002)) 
    \GEN_RD_CMD_OPT.arlen_reg[1]_i_1 
       (.I0(\GEN_RD_CMD_OPT.arlen_reg_reg[3] [0]),
        .I1(\GEN_RD_CMD_OPT.arlen_reg[3]_i_2_n_0 ),
        .I2(\GEN_RD_CMD_OPT.axi_rvalid_int_reg ),
        .I3(\GEN_RD_CMD_OPT.arlen_reg_reg[1]_0 ),
        .I4(\GEN_RD_CMD_OPT.arlen_reg_reg[1] ),
        .I5(s_axi_arlen[1]),
        .O(arlen_temp[0]));
  LUT6 #(
    .INIT(64'hAAAAFFFEAAAA0002)) 
    \GEN_RD_CMD_OPT.arlen_reg[2]_i_1 
       (.I0(\GEN_RD_CMD_OPT.arlen_reg_reg[3] [1]),
        .I1(\GEN_RD_CMD_OPT.arlen_reg[3]_i_2_n_0 ),
        .I2(\GEN_RD_CMD_OPT.axi_rvalid_int_reg ),
        .I3(\GEN_RD_CMD_OPT.arlen_reg_reg[1]_0 ),
        .I4(\GEN_RD_CMD_OPT.arlen_reg_reg[1] ),
        .I5(s_axi_arlen[2]),
        .O(arlen_temp[1]));
  LUT6 #(
    .INIT(64'hAAAAFFFEAAAA0002)) 
    \GEN_RD_CMD_OPT.arlen_reg[3]_i_1 
       (.I0(\GEN_RD_CMD_OPT.arlen_reg_reg[3] [2]),
        .I1(\GEN_RD_CMD_OPT.arlen_reg[3]_i_2_n_0 ),
        .I2(\GEN_RD_CMD_OPT.axi_rvalid_int_reg ),
        .I3(\GEN_RD_CMD_OPT.arlen_reg_reg[1]_0 ),
        .I4(\GEN_RD_CMD_OPT.arlen_reg_reg[1] ),
        .I5(s_axi_arlen[3]),
        .O(arlen_temp[2]));
  LUT2 #(
    .INIT(4'h1)) 
    \GEN_RD_CMD_OPT.arlen_reg[3]_i_2 
       (.I0(rd_active),
        .I1(rd_cmd_reg),
        .O(\GEN_RD_CMD_OPT.arlen_reg[3]_i_2_n_0 ));
  LUT5 #(
    .INIT(32'h02FF0200)) 
    \GEN_RD_CMD_OPT.wrap_addr_assign_i_1 
       (.I0(\GEN_RD_CMD_OPT.wrap_addr_assign_i_2_n_0 ),
        .I1(\GEN_RD_CMD_OPT.wrap_addr_assign_reg_2 ),
        .I2(\GEN_RD_CMD_OPT.wrap_addr_assign_reg_1 ),
        .I3(bram_en_b),
        .I4(wrap_addr_assign),
        .O(\GEN_RD_CMD_OPT.wrap_addr_assign_reg_0 ));
  LUT6 #(
    .INIT(64'h00A000F000FF2000)) 
    \GEN_RD_CMD_OPT.wrap_addr_assign_i_2 
       (.I0(\GEN_RD_CMD_OPT.wrap_addr_assign_reg ),
        .I1(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[6] ),
        .I2(\wrap_burst_total_reg_reg[1]_0 ),
        .I3(wrap_burst_total[2]),
        .I4(wrap_burst_total[0]),
        .I5(wrap_burst_total[1]),
        .O(\GEN_RD_CMD_OPT.wrap_addr_assign_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'hFB3BC808)) 
    \bram_addr_b[10]_INST_0 
       (.I0(Q[5]),
        .I1(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I2(wrap_addr_assign),
        .I3(save_init_bram_addr_ld_reg[10]),
        .I4(s_axi_araddr[7]),
        .O(bram_addr_b[1]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'hFB3BC808)) 
    \bram_addr_b[11]_INST_0 
       (.I0(Q[6]),
        .I1(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I2(wrap_addr_assign),
        .I3(save_init_bram_addr_ld_reg[11]),
        .I4(s_axi_araddr[8]),
        .O(bram_addr_b[2]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'hFB3BC808)) 
    \bram_addr_b[12]_INST_0 
       (.I0(Q[7]),
        .I1(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I2(wrap_addr_assign),
        .I3(save_init_bram_addr_ld_reg[12]),
        .I4(s_axi_araddr[9]),
        .O(D[8]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'hFB3BC808)) 
    \bram_addr_b[13]_INST_0 
       (.I0(Q[8]),
        .I1(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I2(wrap_addr_assign),
        .I3(save_init_bram_addr_ld_reg[13]),
        .I4(s_axi_araddr[10]),
        .O(D[9]));
  LUT6 #(
    .INIT(64'hFFFFFFFFD0D090D0)) 
    \bram_addr_b[4]_INST_0 
       (.I0(wrap_burst_total[1]),
        .I1(wrap_burst_total[2]),
        .I2(\bram_addr_b[4]_INST_0_i_1_n_0 ),
        .I3(\bram_addr_b[4] ),
        .I4(\bram_addr_b[5]_INST_0_i_5_n_0 ),
        .I5(\bram_addr_b[4]_0 ),
        .O(\wrap_burst_total_reg_reg[1]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'h80)) 
    \bram_addr_b[4]_INST_0_i_1 
       (.I0(save_init_bram_addr_ld_reg[4]),
        .I1(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I2(wrap_addr_assign),
        .O(\bram_addr_b[4]_INST_0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hBABBBBABBABBBABB)) 
    \bram_addr_b[5]_INST_0 
       (.I0(\bram_addr_b[5] ),
        .I1(\bram_addr_b[5]_INST_0_i_2_n_0 ),
        .I2(wrap_burst_total[2]),
        .I3(wrap_burst_total[1]),
        .I4(\bram_addr_b[5]_INST_0_i_5_n_0 ),
        .I5(\bram_addr_b[4] ),
        .O(\GEN_RD_CMD_OPT.wrap_addr_assign_reg ));
  LUT6 #(
    .INIT(64'h888A888A888A8888)) 
    \bram_addr_b[5]_INST_0_i_11 
       (.I0(wrap_burst_total_reg[0]),
        .I1(\GEN_RD_CMD_OPT.arlen_reg_reg[1] ),
        .I2(\GEN_RD_CMD_OPT.arlen_reg_reg[1]_0 ),
        .I3(\GEN_RD_CMD_OPT.axi_rvalid_int_reg ),
        .I4(rd_active),
        .I5(rd_cmd_reg),
        .O(\bram_addr_b[5]_INST_0_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'h7F)) 
    \bram_addr_b[5]_INST_0_i_2 
       (.I0(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I1(wrap_addr_assign),
        .I2(save_init_bram_addr_ld_reg[5]),
        .O(\bram_addr_b[5]_INST_0_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hAAAABAAAAAAAAAAA)) 
    \bram_addr_b[5]_INST_0_i_3 
       (.I0(\bram_addr_b[5]_INST_0_i_7_n_0 ),
        .I1(\bram_addr_b[5]_INST_0_i_8_n_0 ),
        .I2(arlen_temp[2]),
        .I3(arlen_temp[1]),
        .I4(\bram_addr_b[5]_INST_0_i_9_n_0 ),
        .I5(arlen_temp[0]),
        .O(wrap_burst_total[2]));
  LUT6 #(
    .INIT(64'hAAAAAAAA03000000)) 
    \bram_addr_b[5]_INST_0_i_4 
       (.I0(wrap_burst_total_reg[1]),
        .I1(arlen_temp[2]),
        .I2(\bram_addr_b[5]_INST_0_i_8_n_0 ),
        .I3(arlen_temp[0]),
        .I4(s_axi_arlen[0]),
        .I5(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .O(wrap_burst_total[1]));
  LUT6 #(
    .INIT(64'hFFFFFFFF00100000)) 
    \bram_addr_b[5]_INST_0_i_5 
       (.I0(arlen_temp[2]),
        .I1(\bram_addr_b[5]_0 ),
        .I2(arlen_temp[1]),
        .I3(\bram_addr_b[5]_INST_0_i_9_n_0 ),
        .I4(arlen_temp[0]),
        .I5(\bram_addr_b[5]_INST_0_i_11_n_0 ),
        .O(\bram_addr_b[5]_INST_0_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h888A888A888A8888)) 
    \bram_addr_b[5]_INST_0_i_7 
       (.I0(wrap_burst_total_reg[2]),
        .I1(\GEN_RD_CMD_OPT.arlen_reg_reg[1] ),
        .I2(\GEN_RD_CMD_OPT.arlen_reg_reg[1]_0 ),
        .I3(\GEN_RD_CMD_OPT.axi_rvalid_int_reg ),
        .I4(rd_active),
        .I5(rd_cmd_reg),
        .O(\bram_addr_b[5]_INST_0_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h7777777700000007)) 
    \bram_addr_b[5]_INST_0_i_8 
       (.I0(\wrap_burst_total_reg_reg[1]_1 [0]),
        .I1(\wrap_burst_total_reg_reg[1]_1 [1]),
        .I2(\GEN_RD_CMD_OPT.arlen_reg[3]_i_2_n_0 ),
        .I3(\GEN_RD_CMD_OPT.axi_rvalid_int_reg ),
        .I4(\GEN_RD_CMD_OPT.arlen_reg_reg[1]_0 ),
        .I5(\GEN_RD_CMD_OPT.arlen_reg_reg[1] ),
        .O(\bram_addr_b[5]_INST_0_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hABABABAAFFFFFFFF)) 
    \bram_addr_b[5]_INST_0_i_9 
       (.I0(\GEN_RD_CMD_OPT.arlen_reg_reg[1] ),
        .I1(\GEN_RD_CMD_OPT.arlen_reg_reg[1]_0 ),
        .I2(\GEN_RD_CMD_OPT.axi_rvalid_int_reg ),
        .I3(rd_active),
        .I4(rd_cmd_reg),
        .I5(s_axi_arlen[0]),
        .O(\bram_addr_b[5]_INST_0_i_9_n_0 ));
  LUT6 #(
    .INIT(64'h8FFF80FF8F008000)) 
    \bram_addr_b[6]_INST_0 
       (.I0(\bram_addr_b[6]_INST_0_i_1_n_0 ),
        .I1(save_init_bram_addr_ld_reg[6]),
        .I2(wrap_addr_assign),
        .I3(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I4(Q[1]),
        .I5(s_axi_araddr[3]),
        .O(bram_addr_b[0]));
  LUT6 #(
    .INIT(64'hFFFFFFFFFDDDFFFF)) 
    \bram_addr_b[6]_INST_0_i_1 
       (.I0(\bram_addr_b[4] ),
        .I1(\bram_addr_b[6] ),
        .I2(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I3(wrap_burst_total_reg[0]),
        .I4(wrap_burst_total[2]),
        .I5(wrap_burst_total[1]),
        .O(\bram_addr_b[6]_INST_0_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'hFB3BC808)) 
    \bram_addr_b[7]_INST_0 
       (.I0(Q[2]),
        .I1(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I2(wrap_addr_assign),
        .I3(save_init_bram_addr_ld_reg[7]),
        .I4(s_axi_araddr[4]),
        .O(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7] ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'hFB3BC808)) 
    \bram_addr_b[8]_INST_0 
       (.I0(Q[3]),
        .I1(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I2(wrap_addr_assign),
        .I3(save_init_bram_addr_ld_reg[8]),
        .I4(s_axi_araddr[5]),
        .O(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8] ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'hFB3BC808)) 
    \bram_addr_b[9]_INST_0 
       (.I0(Q[4]),
        .I1(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I2(wrap_addr_assign),
        .I3(save_init_bram_addr_ld_reg[9]),
        .I4(s_axi_araddr[6]),
        .O(\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[9] ));
  LUT6 #(
    .INIT(64'h000EFFFFFFFFFFFF)) 
    bram_en_b_INST_0_i_1
       (.I0(rd_cmd_reg),
        .I1(rd_active),
        .I2(\GEN_RD_CMD_OPT.axi_rvalid_int_reg ),
        .I3(\GEN_RD_CMD_OPT.arlen_reg_reg[1]_0 ),
        .I4(s_axi_arvalid),
        .I5(axi_aresetn_d3),
        .O(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ));
  LUT5 #(
    .INIT(32'h88880080)) 
    bram_en_b_INST_0_i_2
       (.I0(\GEN_RD_CMD_OPT.arlen_reg_reg[2] ),
        .I1(s_axi_rready),
        .I2(rd_data_sm_cs[1]),
        .I3(rd_data_sm_cs[0]),
        .I4(axi_rlast_cmb_reg),
        .O(\GEN_RD_CMD_OPT.axi_rvalid_int_reg ));
  LUT1 #(
    .INIT(2'h1)) 
    bram_rst_b_INST_0
       (.I0(s_axi_aresetn),
        .O(SR));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \save_init_bram_addr_ld_reg[10]_i_1 
       (.I0(save_init_bram_addr_ld_reg[10]),
        .I1(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I2(s_axi_araddr[7]),
        .O(save_init_bram_addr_ld[10]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \save_init_bram_addr_ld_reg[11]_i_1 
       (.I0(save_init_bram_addr_ld_reg[11]),
        .I1(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I2(s_axi_araddr[8]),
        .O(save_init_bram_addr_ld[11]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \save_init_bram_addr_ld_reg[12]_i_1 
       (.I0(save_init_bram_addr_ld_reg[12]),
        .I1(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I2(s_axi_araddr[9]),
        .O(save_init_bram_addr_ld[12]));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \save_init_bram_addr_ld_reg[13]_i_1 
       (.I0(save_init_bram_addr_ld_reg[13]),
        .I1(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I2(s_axi_araddr[10]),
        .O(save_init_bram_addr_ld[13]));
  LUT1 #(
    .INIT(2'h1)) 
    \save_init_bram_addr_ld_reg[6]_i_1 
       (.I0(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .O(addr_vld_rdy5_out));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \save_init_bram_addr_ld_reg[7]_i_1 
       (.I0(save_init_bram_addr_ld_reg[7]),
        .I1(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I2(s_axi_araddr[4]),
        .O(save_init_bram_addr_ld[7]));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \save_init_bram_addr_ld_reg[8]_i_1 
       (.I0(save_init_bram_addr_ld_reg[8]),
        .I1(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I2(s_axi_araddr[5]),
        .O(save_init_bram_addr_ld[8]));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \save_init_bram_addr_ld_reg[9]_i_1 
       (.I0(save_init_bram_addr_ld_reg[9]),
        .I1(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I2(s_axi_araddr[6]),
        .O(save_init_bram_addr_ld[9]));
  FDRE #(
    .INIT(1'b0)) 
    \save_init_bram_addr_ld_reg_reg[10] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(save_init_bram_addr_ld[10]),
        .Q(save_init_bram_addr_ld_reg[10]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \save_init_bram_addr_ld_reg_reg[11] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(save_init_bram_addr_ld[11]),
        .Q(save_init_bram_addr_ld_reg[11]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \save_init_bram_addr_ld_reg_reg[12] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(save_init_bram_addr_ld[12]),
        .Q(save_init_bram_addr_ld_reg[12]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \save_init_bram_addr_ld_reg_reg[13] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(save_init_bram_addr_ld[13]),
        .Q(save_init_bram_addr_ld_reg[13]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \save_init_bram_addr_ld_reg_reg[4] 
       (.C(s_axi_aclk),
        .CE(addr_vld_rdy5_out),
        .D(s_axi_araddr[1]),
        .Q(save_init_bram_addr_ld_reg[4]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \save_init_bram_addr_ld_reg_reg[5] 
       (.C(s_axi_aclk),
        .CE(addr_vld_rdy5_out),
        .D(s_axi_araddr[2]),
        .Q(save_init_bram_addr_ld_reg[5]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \save_init_bram_addr_ld_reg_reg[6] 
       (.C(s_axi_aclk),
        .CE(addr_vld_rdy5_out),
        .D(s_axi_araddr[3]),
        .Q(save_init_bram_addr_ld_reg[6]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \save_init_bram_addr_ld_reg_reg[7] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(save_init_bram_addr_ld[7]),
        .Q(save_init_bram_addr_ld_reg[7]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \save_init_bram_addr_ld_reg_reg[8] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(save_init_bram_addr_ld[8]),
        .Q(save_init_bram_addr_ld_reg[8]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \save_init_bram_addr_ld_reg_reg[9] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(save_init_bram_addr_ld[9]),
        .Q(save_init_bram_addr_ld_reg[9]),
        .R(SR));
  LUT6 #(
    .INIT(64'h88F888F8FFFF88F8)) 
    \wrap_burst_total_reg[0]_i_1 
       (.I0(wrap_burst_total_reg[0]),
        .I1(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I2(\wrap_burst_total_reg[0]_i_2_n_0 ),
        .I3(\wrap_burst_total_reg[0]_i_3_n_0 ),
        .I4(s_axi_arlen[0]),
        .I5(\wrap_burst_total_reg[0]_i_4_n_0 ),
        .O(wrap_burst_total[0]));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT4 #(
    .INIT(16'h2000)) 
    \wrap_burst_total_reg[0]_i_2 
       (.I0(s_axi_arlen[2]),
        .I1(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I2(s_axi_arlen[0]),
        .I3(s_axi_arlen[1]),
        .O(\wrap_burst_total_reg[0]_i_2_n_0 ));
  LUT4 #(
    .INIT(16'hCFAA)) 
    \wrap_burst_total_reg[0]_i_3 
       (.I0(s_axi_arlen[3]),
        .I1(\GEN_RD_CMD_OPT.arlen_reg_reg[3] [2]),
        .I2(\wrap_burst_total_reg_reg[1]_1 [0]),
        .I3(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .O(\wrap_burst_total_reg[0]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    \wrap_burst_total_reg[0]_i_4 
       (.I0(s_axi_arlen[2]),
        .I1(\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg ),
        .I2(s_axi_arlen[1]),
        .I3(s_axi_arlen[3]),
        .O(\wrap_burst_total_reg[0]_i_4_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \wrap_burst_total_reg_reg[0] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(wrap_burst_total[0]),
        .Q(wrap_burst_total_reg[0]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \wrap_burst_total_reg_reg[1] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(wrap_burst_total[1]),
        .Q(wrap_burst_total_reg[1]),
        .R(SR));
  FDRE #(
    .INIT(1'b0)) 
    \wrap_burst_total_reg_reg[2] 
       (.C(s_axi_aclk),
        .CE(1'b1),
        .D(wrap_burst_total[2]),
        .Q(wrap_burst_total_reg[2]),
        .R(SR));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
