// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
// Date        : Wed Mar  2 16:43:35 2022
// Host        : rclab-H410M-H running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/anuj/work_sajin/RISCV/IP/RAS_dmem_32x64b/RAS_dmem_32x64b_stub.v
// Design      : RAS_dmem_32x64b
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx485tffg1761-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_13,Vivado 2020.1" *)
module RAS_dmem_32x64b(a, d, dpra, clk, we, dpo)
/* synthesis syn_black_box black_box_pad_pin="a[4:0],d[63:0],dpra[4:0],clk,we,dpo[63:0]" */;
  input [4:0]a;
  input [63:0]d;
  input [4:0]dpra;
  input clk;
  input we;
  output [63:0]dpo;
endmodule
