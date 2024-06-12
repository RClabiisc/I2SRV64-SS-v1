-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
-- Date        : Mon Mar  7 18:36:09 2022
-- Host        : rclab-H410M-H running 64-bit Ubuntu 20.04.3 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/anuj/work_sajin/RISCV/FPGA_Projects/SOC_DRAM_Check_Linux3/SOC_DRAM_Check.srcs/sys_clk_ctrl/ip/sys_clk_ctrl/sys_clk_ctrl_stub.vhdl
-- Design      : sys_clk_ctrl
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7vx485tffg1761-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sys_clk_ctrl is
  Port ( 
    sys_clk : out STD_LOGIC;
    locked : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end sys_clk_ctrl;

architecture stub of sys_clk_ctrl is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "sys_clk,locked,clk_in1";
begin
end;
