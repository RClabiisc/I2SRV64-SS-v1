// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
// Date        : Mon Mar  7 18:36:09 2022
// Host        : rclab-H410M-H running 64-bit Ubuntu 20.04.3 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/anuj/work_sajin/RISCV/FPGA_Projects/SOC_DRAM_Check_Linux3/SOC_DRAM_Check.srcs/sys_clk_ctrl/ip/sys_clk_ctrl/sys_clk_ctrl_stub.v
// Design      : sys_clk_ctrl
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7vx485tffg1761-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module sys_clk_ctrl(sys_clk, locked, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="sys_clk,locked,clk_in1" */;
  output sys_clk;
  output locked;
  input clk_in1;
endmodule
