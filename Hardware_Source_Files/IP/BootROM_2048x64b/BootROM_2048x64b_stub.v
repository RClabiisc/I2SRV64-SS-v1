// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
// Date        : Wed Apr  6 13:52:45 2022
// Host        : rclab-H410M-H running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode synth_stub -rename_top BootROM_2048x64b -prefix
//               BootROM_2048x64b_ BootROM_2048x64b_stub.v
// Design      : BootROM_2048x64b
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx485tffg1761-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2020.1" *)
module BootROM_2048x64b(clka, rsta, ena, addra, douta, clkb, rstb, enb, addrb, 
  doutb, rsta_busy, rstb_busy)
/* synthesis syn_black_box black_box_pad_pin="clka,rsta,ena,addra[31:0],douta[63:0],clkb,rstb,enb,addrb[31:0],doutb[63:0],rsta_busy,rstb_busy" */;
  input clka;
  input rsta;
  input ena;
  input [31:0]addra;
  output [63:0]douta;
  input clkb;
  input rstb;
  input enb;
  input [31:0]addrb;
  output [63:0]doutb;
  output rsta_busy;
  output rstb_busy;
endmodule
