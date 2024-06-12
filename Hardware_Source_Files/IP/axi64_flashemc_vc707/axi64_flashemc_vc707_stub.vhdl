-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
-- Date        : Wed Mar  2 16:41:24 2022
-- Host        : rclab-H410M-H running 64-bit Ubuntu 20.04.3 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/anuj/work_sajin/RISCV/IP/axi64_flashemc_vc707/axi64_flashemc_vc707_stub.vhdl
-- Design      : axi64_flashemc_vc707
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7vx485tffg1761-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity axi64_flashemc_vc707 is
  Port ( 
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    rdclk : in STD_LOGIC;
    s_axi_mem_awid : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_mem_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_mem_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_mem_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_mem_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_mem_awlock : in STD_LOGIC;
    s_axi_mem_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_mem_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_mem_awvalid : in STD_LOGIC;
    s_axi_mem_awready : out STD_LOGIC;
    s_axi_mem_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axi_mem_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_mem_wlast : in STD_LOGIC;
    s_axi_mem_wvalid : in STD_LOGIC;
    s_axi_mem_wready : out STD_LOGIC;
    s_axi_mem_bid : out STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_mem_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_mem_bvalid : out STD_LOGIC;
    s_axi_mem_bready : in STD_LOGIC;
    s_axi_mem_arid : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_mem_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_mem_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_mem_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_mem_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_mem_arlock : in STD_LOGIC;
    s_axi_mem_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_mem_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_mem_arvalid : in STD_LOGIC;
    s_axi_mem_arready : out STD_LOGIC;
    s_axi_mem_rid : out STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_mem_rdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axi_mem_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_mem_rlast : out STD_LOGIC;
    s_axi_mem_rvalid : out STD_LOGIC;
    s_axi_mem_rready : in STD_LOGIC;
    mem_dq_i : in STD_LOGIC_VECTOR ( 15 downto 0 );
    mem_dq_o : out STD_LOGIC_VECTOR ( 15 downto 0 );
    mem_dq_t : out STD_LOGIC_VECTOR ( 15 downto 0 );
    mem_a : out STD_LOGIC_VECTOR ( 31 downto 0 );
    mem_ce : out STD_LOGIC_VECTOR ( 0 to 0 );
    mem_cen : out STD_LOGIC_VECTOR ( 0 to 0 );
    mem_oen : out STD_LOGIC_VECTOR ( 0 to 0 );
    mem_wen : out STD_LOGIC;
    mem_ben : out STD_LOGIC_VECTOR ( 1 downto 0 );
    mem_qwen : out STD_LOGIC_VECTOR ( 1 downto 0 );
    mem_rpn : out STD_LOGIC;
    mem_adv_ldn : out STD_LOGIC;
    mem_lbon : out STD_LOGIC;
    mem_cken : out STD_LOGIC;
    mem_rnw : out STD_LOGIC;
    mem_cre : out STD_LOGIC;
    mem_wait : in STD_LOGIC_VECTOR ( 0 to 0 )
  );

end axi64_flashemc_vc707;

architecture stub of axi64_flashemc_vc707 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "s_axi_aclk,s_axi_aresetn,rdclk,s_axi_mem_awid[3:0],s_axi_mem_awaddr[31:0],s_axi_mem_awlen[7:0],s_axi_mem_awsize[2:0],s_axi_mem_awburst[1:0],s_axi_mem_awlock,s_axi_mem_awcache[3:0],s_axi_mem_awprot[2:0],s_axi_mem_awvalid,s_axi_mem_awready,s_axi_mem_wdata[63:0],s_axi_mem_wstrb[7:0],s_axi_mem_wlast,s_axi_mem_wvalid,s_axi_mem_wready,s_axi_mem_bid[3:0],s_axi_mem_bresp[1:0],s_axi_mem_bvalid,s_axi_mem_bready,s_axi_mem_arid[3:0],s_axi_mem_araddr[31:0],s_axi_mem_arlen[7:0],s_axi_mem_arsize[2:0],s_axi_mem_arburst[1:0],s_axi_mem_arlock,s_axi_mem_arcache[3:0],s_axi_mem_arprot[2:0],s_axi_mem_arvalid,s_axi_mem_arready,s_axi_mem_rid[3:0],s_axi_mem_rdata[63:0],s_axi_mem_rresp[1:0],s_axi_mem_rlast,s_axi_mem_rvalid,s_axi_mem_rready,mem_dq_i[15:0],mem_dq_o[15:0],mem_dq_t[15:0],mem_a[31:0],mem_ce[0:0],mem_cen[0:0],mem_oen[0:0],mem_wen,mem_ben[1:0],mem_qwen[1:0],mem_rpn,mem_adv_ldn,mem_lbon,mem_cken,mem_rnw,mem_cre,mem_wait[0:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "axi_emc,Vivado 2020.1";
begin
end;
