// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
// Date        : Wed Mar  2 16:40:33 2022
// Host        : rclab-H410M-H running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode synth_stub /home/anuj/work_sajin/RISCV/IP/IB_bmem_4x186b/IB_bmem_4x186b_stub.v
// Design      : IB_bmem_4x186b
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx485tffg1761-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.1" *)
module IB_bmem_4x186b(clka, wea, addra, dina, clkb, enb, addrb, doutb)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[1:0],dina[185:0],clkb,enb,addrb[1:0],doutb[185:0]" */;
  input clka;
  input [0:0]wea;
  input [1:0]addra;
  input [185:0]dina;
  input clkb;
  input enb;
  input [1:0]addrb;
  output [185:0]doutb;
endmodule
