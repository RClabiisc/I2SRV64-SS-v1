-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
-- Date        : Wed Mar  2 16:41:13 2022
-- Host        : rclab-H410M-H running 64-bit Ubuntu 20.04.3 LTS
-- Command     : write_vhdl -force -mode funcsim
--               /home/anuj/work_sajin/RISCV/IP/axi64_bram_ctrl_64KiB/axi64_bram_ctrl_64KiB_sim_netlist.vhdl
-- Design      : axi64_bram_ctrl_64KiB
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7vx485tffg1761-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axi64_bram_ctrl_64KiB_SRL_FIFO is
  port (
    \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1]\ : out STD_LOGIC;
    E : out STD_LOGIC_VECTOR ( 0 to 0 );
    bid_gets_fifo_load : out STD_LOGIC;
    \bvalid_cnt_reg[2]\ : out STD_LOGIC;
    D : out STD_LOGIC_VECTOR ( 3 downto 0 );
    axi_wr_burst_reg : out STD_LOGIC;
    \GEN_AW_PIPE_DUAL.axi_awaddr_full_reg\ : out STD_LOGIC;
    \bvalid_cnt_reg[0]\ : out STD_LOGIC;
    Data_Exists_DFF_0 : in STD_LOGIC;
    s_axi_aclk : in STD_LOGIC;
    bram_addr_ld_en : in STD_LOGIC;
    bvalid_cnt : in STD_LOGIC_VECTOR ( 2 downto 0 );
    bid_gets_fifo_load_d1 : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 3 downto 0 );
    axi_awaddr_full : in STD_LOGIC;
    s_axi_awid : in STD_LOGIC_VECTOR ( 3 downto 0 );
    bid_gets_fifo_load_d1_reg : in STD_LOGIC;
    bid_gets_fifo_load_d1_reg_0 : in STD_LOGIC;
    bid_gets_fifo_load_d1_reg_1 : in STD_LOGIC;
    axi_wr_burst : in STD_LOGIC;
    wr_data_sm_cs : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_wlast : in STD_LOGIC;
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : in STD_LOGIC;
    aw_active : in STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    \axi_bid_int_reg[0]\ : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of axi64_bram_ctrl_64KiB_SRL_FIFO : entity is "SRL_FIFO";
end axi64_bram_ctrl_64KiB_SRL_FIFO;

architecture STRUCTURE of axi64_bram_ctrl_64KiB_SRL_FIFO is
  signal \Addr_Counters[0].FDRE_I_n_0\ : STD_LOGIC;
  signal \Addr_Counters[0].MUXCY_L_I_i_2_n_0\ : STD_LOGIC;
  signal \Addr_Counters[0].MUXCY_L_I_i_3_n_0\ : STD_LOGIC;
  signal \Addr_Counters[0].MUXCY_L_I_i_4_n_0\ : STD_LOGIC;
  signal \Addr_Counters[0].MUXCY_L_I_i_5_n_0\ : STD_LOGIC;
  signal \Addr_Counters[1].FDRE_I_n_0\ : STD_LOGIC;
  signal \Addr_Counters[2].FDRE_I_n_0\ : STD_LOGIC;
  signal \Addr_Counters[3].FDRE_I_n_0\ : STD_LOGIC;
  signal \Addr_Counters[3].XORCY_I_i_1_n_0\ : STD_LOGIC;
  signal D_0 : STD_LOGIC;
  signal Data_Exists_DFF_i_2_n_0 : STD_LOGIC;
  signal \^fsm_sequential_gen_wdata_sm_no_ecc_dual_reg_wready.wr_data_sm_cs_reg[1]\ : STD_LOGIC;
  signal \^gen_aw_pipe_dual.axi_awaddr_full_reg\ : STD_LOGIC;
  signal S : STD_LOGIC;
  signal S0_out : STD_LOGIC;
  signal S1_out : STD_LOGIC;
  signal addr_cy_1 : STD_LOGIC;
  signal addr_cy_2 : STD_LOGIC;
  signal addr_cy_3 : STD_LOGIC;
  signal \axi_bid_int[3]_i_3_n_0\ : STD_LOGIC;
  signal \axi_bid_int[3]_i_6_n_0\ : STD_LOGIC;
  signal \^axi_wr_burst_reg\ : STD_LOGIC;
  signal bid_fifo_ld : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal bid_fifo_not_empty : STD_LOGIC;
  signal bid_fifo_rd : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \^bid_gets_fifo_load\ : STD_LOGIC;
  signal bid_gets_fifo_load_d1_i_4_n_0 : STD_LOGIC;
  signal \^bvalid_cnt_reg[0]\ : STD_LOGIC;
  signal \^bvalid_cnt_reg[2]\ : STD_LOGIC;
  signal sum_A_0 : STD_LOGIC;
  signal sum_A_1 : STD_LOGIC;
  signal sum_A_2 : STD_LOGIC;
  signal sum_A_3 : STD_LOGIC;
  signal \NLW_Addr_Counters[0].MUXCY_L_I_CARRY4_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  signal \NLW_Addr_Counters[0].MUXCY_L_I_CARRY4_DI_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 to 3 );
  attribute BOX_TYPE : string;
  attribute BOX_TYPE of \Addr_Counters[0].FDRE_I\ : label is "PRIMITIVE";
  attribute BOX_TYPE of \Addr_Counters[0].MUXCY_L_I_CARRY4\ : label is "PRIMITIVE";
  attribute OPT_MODIFIED : string;
  attribute OPT_MODIFIED of \Addr_Counters[0].MUXCY_L_I_CARRY4\ : label is "MLO";
  attribute XILINX_LEGACY_PRIM : string;
  attribute XILINX_LEGACY_PRIM of \Addr_Counters[0].MUXCY_L_I_CARRY4\ : label is "(MUXCY,XORCY)";
  attribute XILINX_TRANSFORM_PINMAP : string;
  attribute XILINX_TRANSFORM_PINMAP of \Addr_Counters[0].MUXCY_L_I_CARRY4\ : label is "LO:O";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \Addr_Counters[0].MUXCY_L_I_i_4\ : label is "soft_lutpair33";
  attribute SOFT_HLUTNM of \Addr_Counters[0].MUXCY_L_I_i_5\ : label is "soft_lutpair33";
  attribute BOX_TYPE of \Addr_Counters[1].FDRE_I\ : label is "PRIMITIVE";
  attribute BOX_TYPE of \Addr_Counters[2].FDRE_I\ : label is "PRIMITIVE";
  attribute BOX_TYPE of \Addr_Counters[3].FDRE_I\ : label is "PRIMITIVE";
  attribute BOX_TYPE of Data_Exists_DFF : label is "PRIMITIVE";
  attribute XILINX_LEGACY_PRIM of Data_Exists_DFF : label is "FDR";
  attribute BOX_TYPE of \FIFO_RAM[0].SRL16E_I\ : label is "PRIMITIVE";
  attribute srl_bus_name : string;
  attribute srl_bus_name of \FIFO_RAM[0].SRL16E_I\ : label is "U0/\gext_inst.abcv4_0_ext_inst/GEN_AXI4.I_FULL_AXI/I_WR_CHNL/BID_FIFO/FIFO_RAM ";
  attribute srl_name : string;
  attribute srl_name of \FIFO_RAM[0].SRL16E_I\ : label is "U0/\gext_inst.abcv4_0_ext_inst/GEN_AXI4.I_FULL_AXI/I_WR_CHNL/BID_FIFO/FIFO_RAM[0].SRL16E_I ";
  attribute SOFT_HLUTNM of \FIFO_RAM[0].SRL16E_I_i_1\ : label is "soft_lutpair34";
  attribute BOX_TYPE of \FIFO_RAM[1].SRL16E_I\ : label is "PRIMITIVE";
  attribute srl_bus_name of \FIFO_RAM[1].SRL16E_I\ : label is "U0/\gext_inst.abcv4_0_ext_inst/GEN_AXI4.I_FULL_AXI/I_WR_CHNL/BID_FIFO/FIFO_RAM ";
  attribute srl_name of \FIFO_RAM[1].SRL16E_I\ : label is "U0/\gext_inst.abcv4_0_ext_inst/GEN_AXI4.I_FULL_AXI/I_WR_CHNL/BID_FIFO/FIFO_RAM[1].SRL16E_I ";
  attribute SOFT_HLUTNM of \FIFO_RAM[1].SRL16E_I_i_1\ : label is "soft_lutpair35";
  attribute BOX_TYPE of \FIFO_RAM[2].SRL16E_I\ : label is "PRIMITIVE";
  attribute srl_bus_name of \FIFO_RAM[2].SRL16E_I\ : label is "U0/\gext_inst.abcv4_0_ext_inst/GEN_AXI4.I_FULL_AXI/I_WR_CHNL/BID_FIFO/FIFO_RAM ";
  attribute srl_name of \FIFO_RAM[2].SRL16E_I\ : label is "U0/\gext_inst.abcv4_0_ext_inst/GEN_AXI4.I_FULL_AXI/I_WR_CHNL/BID_FIFO/FIFO_RAM[2].SRL16E_I ";
  attribute SOFT_HLUTNM of \FIFO_RAM[2].SRL16E_I_i_1\ : label is "soft_lutpair36";
  attribute BOX_TYPE of \FIFO_RAM[3].SRL16E_I\ : label is "PRIMITIVE";
  attribute srl_bus_name of \FIFO_RAM[3].SRL16E_I\ : label is "U0/\gext_inst.abcv4_0_ext_inst/GEN_AXI4.I_FULL_AXI/I_WR_CHNL/BID_FIFO/FIFO_RAM ";
  attribute srl_name of \FIFO_RAM[3].SRL16E_I\ : label is "U0/\gext_inst.abcv4_0_ext_inst/GEN_AXI4.I_FULL_AXI/I_WR_CHNL/BID_FIFO/FIFO_RAM[3].SRL16E_I ";
  attribute SOFT_HLUTNM of \FIFO_RAM[3].SRL16E_I_i_1\ : label is "soft_lutpair37";
  attribute SOFT_HLUTNM of \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_4\ : label is "soft_lutpair39";
  attribute SOFT_HLUTNM of \axi_bid_int[0]_i_1\ : label is "soft_lutpair37";
  attribute SOFT_HLUTNM of \axi_bid_int[1]_i_1\ : label is "soft_lutpair36";
  attribute SOFT_HLUTNM of \axi_bid_int[2]_i_1\ : label is "soft_lutpair35";
  attribute SOFT_HLUTNM of \axi_bid_int[3]_i_2\ : label is "soft_lutpair34";
  attribute SOFT_HLUTNM of \axi_bid_int[3]_i_3\ : label is "soft_lutpair38";
  attribute SOFT_HLUTNM of \axi_bid_int[3]_i_5\ : label is "soft_lutpair38";
  attribute SOFT_HLUTNM of \axi_bid_int[3]_i_6\ : label is "soft_lutpair39";
begin
  \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1]\ <= \^fsm_sequential_gen_wdata_sm_no_ecc_dual_reg_wready.wr_data_sm_cs_reg[1]\;
  \GEN_AW_PIPE_DUAL.axi_awaddr_full_reg\ <= \^gen_aw_pipe_dual.axi_awaddr_full_reg\;
  axi_wr_burst_reg <= \^axi_wr_burst_reg\;
  bid_gets_fifo_load <= \^bid_gets_fifo_load\;
  \bvalid_cnt_reg[0]\ <= \^bvalid_cnt_reg[0]\;
  \bvalid_cnt_reg[2]\ <= \^bvalid_cnt_reg[2]\;
\Addr_Counters[0].FDRE_I\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0',
      IS_C_INVERTED => '0',
      IS_D_INVERTED => '0',
      IS_R_INVERTED => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => bid_fifo_not_empty,
      D => sum_A_3,
      Q => \Addr_Counters[0].FDRE_I_n_0\,
      R => Data_Exists_DFF_0
    );
\Addr_Counters[0].MUXCY_L_I_CARRY4\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \NLW_Addr_Counters[0].MUXCY_L_I_CARRY4_CO_UNCONNECTED\(3),
      CO(2) => addr_cy_1,
      CO(1) => addr_cy_2,
      CO(0) => addr_cy_3,
      CYINIT => \Addr_Counters[0].MUXCY_L_I_i_2_n_0\,
      DI(3) => \NLW_Addr_Counters[0].MUXCY_L_I_CARRY4_DI_UNCONNECTED\(3),
      DI(2) => \Addr_Counters[2].FDRE_I_n_0\,
      DI(1) => \Addr_Counters[1].FDRE_I_n_0\,
      DI(0) => \Addr_Counters[0].FDRE_I_n_0\,
      O(3) => sum_A_0,
      O(2) => sum_A_1,
      O(1) => sum_A_2,
      O(0) => sum_A_3,
      S(3) => \Addr_Counters[3].XORCY_I_i_1_n_0\,
      S(2) => S0_out,
      S(1) => S1_out,
      S(0) => S
    );
\Addr_Counters[0].MUXCY_L_I_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000556AAAAA"
    )
        port map (
      I0 => \Addr_Counters[0].FDRE_I_n_0\,
      I1 => \axi_bid_int[3]_i_3_n_0\,
      I2 => \^fsm_sequential_gen_wdata_sm_no_ecc_dual_reg_wready.wr_data_sm_cs_reg[1]\,
      I3 => \Addr_Counters[0].MUXCY_L_I_i_3_n_0\,
      I4 => bid_fifo_not_empty,
      I5 => \Addr_Counters[0].MUXCY_L_I_i_4_n_0\,
      O => S
    );
\Addr_Counters[0].MUXCY_L_I_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"88808080AAAAAAAA"
    )
        port map (
      I0 => bram_addr_ld_en,
      I1 => bid_fifo_not_empty,
      I2 => \Addr_Counters[0].MUXCY_L_I_i_3_n_0\,
      I3 => \^fsm_sequential_gen_wdata_sm_no_ecc_dual_reg_wready.wr_data_sm_cs_reg[1]\,
      I4 => \axi_bid_int[3]_i_3_n_0\,
      I5 => \Addr_Counters[0].MUXCY_L_I_i_5_n_0\,
      O => \Addr_Counters[0].MUXCY_L_I_i_2_n_0\
    );
\Addr_Counters[0].MUXCY_L_I_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EAEAEAEAEAEAEAAA"
    )
        port map (
      I0 => bid_gets_fifo_load_d1,
      I1 => \axi_bid_int_reg[0]\,
      I2 => s_axi_bready,
      I3 => bvalid_cnt(0),
      I4 => bvalid_cnt(1),
      I5 => bvalid_cnt(2),
      O => \Addr_Counters[0].MUXCY_L_I_i_3_n_0\
    );
\Addr_Counters[0].MUXCY_L_I_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000001"
    )
        port map (
      I0 => bram_addr_ld_en,
      I1 => \Addr_Counters[2].FDRE_I_n_0\,
      I2 => \Addr_Counters[0].FDRE_I_n_0\,
      I3 => \Addr_Counters[3].FDRE_I_n_0\,
      I4 => \Addr_Counters[1].FDRE_I_n_0\,
      O => \Addr_Counters[0].MUXCY_L_I_i_4_n_0\
    );
\Addr_Counters[0].MUXCY_L_I_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8000"
    )
        port map (
      I0 => \Addr_Counters[0].FDRE_I_n_0\,
      I1 => \Addr_Counters[2].FDRE_I_n_0\,
      I2 => \Addr_Counters[1].FDRE_I_n_0\,
      I3 => \Addr_Counters[3].FDRE_I_n_0\,
      O => \Addr_Counters[0].MUXCY_L_I_i_5_n_0\
    );
\Addr_Counters[1].FDRE_I\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0',
      IS_C_INVERTED => '0',
      IS_D_INVERTED => '0',
      IS_R_INVERTED => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => bid_fifo_not_empty,
      D => sum_A_2,
      Q => \Addr_Counters[1].FDRE_I_n_0\,
      R => Data_Exists_DFF_0
    );
\Addr_Counters[1].MUXCY_L_I_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000556AAAAA"
    )
        port map (
      I0 => \Addr_Counters[1].FDRE_I_n_0\,
      I1 => \axi_bid_int[3]_i_3_n_0\,
      I2 => \^fsm_sequential_gen_wdata_sm_no_ecc_dual_reg_wready.wr_data_sm_cs_reg[1]\,
      I3 => \Addr_Counters[0].MUXCY_L_I_i_3_n_0\,
      I4 => bid_fifo_not_empty,
      I5 => \Addr_Counters[0].MUXCY_L_I_i_4_n_0\,
      O => S1_out
    );
\Addr_Counters[2].FDRE_I\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0',
      IS_C_INVERTED => '0',
      IS_D_INVERTED => '0',
      IS_R_INVERTED => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => bid_fifo_not_empty,
      D => sum_A_1,
      Q => \Addr_Counters[2].FDRE_I_n_0\,
      R => Data_Exists_DFF_0
    );
\Addr_Counters[2].MUXCY_L_I_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000556AAAAA"
    )
        port map (
      I0 => \Addr_Counters[2].FDRE_I_n_0\,
      I1 => \axi_bid_int[3]_i_3_n_0\,
      I2 => \^fsm_sequential_gen_wdata_sm_no_ecc_dual_reg_wready.wr_data_sm_cs_reg[1]\,
      I3 => \Addr_Counters[0].MUXCY_L_I_i_3_n_0\,
      I4 => bid_fifo_not_empty,
      I5 => \Addr_Counters[0].MUXCY_L_I_i_4_n_0\,
      O => S0_out
    );
\Addr_Counters[3].FDRE_I\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0',
      IS_C_INVERTED => '0',
      IS_D_INVERTED => '0',
      IS_R_INVERTED => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => bid_fifo_not_empty,
      D => sum_A_0,
      Q => \Addr_Counters[3].FDRE_I_n_0\,
      R => Data_Exists_DFF_0
    );
\Addr_Counters[3].XORCY_I_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000556AAAAA"
    )
        port map (
      I0 => \Addr_Counters[3].FDRE_I_n_0\,
      I1 => \axi_bid_int[3]_i_3_n_0\,
      I2 => \^fsm_sequential_gen_wdata_sm_no_ecc_dual_reg_wready.wr_data_sm_cs_reg[1]\,
      I3 => \Addr_Counters[0].MUXCY_L_I_i_3_n_0\,
      I4 => bid_fifo_not_empty,
      I5 => \Addr_Counters[0].MUXCY_L_I_i_4_n_0\,
      O => \Addr_Counters[3].XORCY_I_i_1_n_0\
    );
Data_Exists_DFF: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => D_0,
      Q => bid_fifo_not_empty,
      R => Data_Exists_DFF_0
    );
Data_Exists_DFF_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF0000002A"
    )
        port map (
      I0 => bid_fifo_not_empty,
      I1 => \axi_bid_int[3]_i_3_n_0\,
      I2 => \^fsm_sequential_gen_wdata_sm_no_ecc_dual_reg_wready.wr_data_sm_cs_reg[1]\,
      I3 => \^bvalid_cnt_reg[2]\,
      I4 => bid_gets_fifo_load_d1,
      I5 => Data_Exists_DFF_i_2_n_0,
      O => D_0
    );
Data_Exists_DFF_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAABAAAAAAA8"
    )
        port map (
      I0 => bid_fifo_not_empty,
      I1 => \Addr_Counters[1].FDRE_I_n_0\,
      I2 => \Addr_Counters[3].FDRE_I_n_0\,
      I3 => \Addr_Counters[0].FDRE_I_n_0\,
      I4 => \Addr_Counters[2].FDRE_I_n_0\,
      I5 => bram_addr_ld_en,
      O => Data_Exists_DFF_i_2_n_0
    );
\FIFO_RAM[0].SRL16E_I\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000",
      IS_CLK_INVERTED => '0'
    )
        port map (
      A0 => \Addr_Counters[0].FDRE_I_n_0\,
      A1 => \Addr_Counters[1].FDRE_I_n_0\,
      A2 => \Addr_Counters[2].FDRE_I_n_0\,
      A3 => \Addr_Counters[3].FDRE_I_n_0\,
      CE => \Addr_Counters[0].MUXCY_L_I_i_2_n_0\,
      CLK => s_axi_aclk,
      D => bid_fifo_ld(3),
      Q => bid_fifo_rd(3)
    );
\FIFO_RAM[0].SRL16E_I_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Q(3),
      I1 => axi_awaddr_full,
      I2 => s_axi_awid(3),
      O => bid_fifo_ld(3)
    );
\FIFO_RAM[1].SRL16E_I\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000",
      IS_CLK_INVERTED => '0'
    )
        port map (
      A0 => \Addr_Counters[0].FDRE_I_n_0\,
      A1 => \Addr_Counters[1].FDRE_I_n_0\,
      A2 => \Addr_Counters[2].FDRE_I_n_0\,
      A3 => \Addr_Counters[3].FDRE_I_n_0\,
      CE => \Addr_Counters[0].MUXCY_L_I_i_2_n_0\,
      CLK => s_axi_aclk,
      D => bid_fifo_ld(2),
      Q => bid_fifo_rd(2)
    );
\FIFO_RAM[1].SRL16E_I_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Q(2),
      I1 => axi_awaddr_full,
      I2 => s_axi_awid(2),
      O => bid_fifo_ld(2)
    );
\FIFO_RAM[2].SRL16E_I\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000",
      IS_CLK_INVERTED => '0'
    )
        port map (
      A0 => \Addr_Counters[0].FDRE_I_n_0\,
      A1 => \Addr_Counters[1].FDRE_I_n_0\,
      A2 => \Addr_Counters[2].FDRE_I_n_0\,
      A3 => \Addr_Counters[3].FDRE_I_n_0\,
      CE => \Addr_Counters[0].MUXCY_L_I_i_2_n_0\,
      CLK => s_axi_aclk,
      D => bid_fifo_ld(1),
      Q => bid_fifo_rd(1)
    );
\FIFO_RAM[2].SRL16E_I_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Q(1),
      I1 => axi_awaddr_full,
      I2 => s_axi_awid(1),
      O => bid_fifo_ld(1)
    );
\FIFO_RAM[3].SRL16E_I\: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"0000",
      IS_CLK_INVERTED => '0'
    )
        port map (
      A0 => \Addr_Counters[0].FDRE_I_n_0\,
      A1 => \Addr_Counters[1].FDRE_I_n_0\,
      A2 => \Addr_Counters[2].FDRE_I_n_0\,
      A3 => \Addr_Counters[3].FDRE_I_n_0\,
      CE => \Addr_Counters[0].MUXCY_L_I_i_2_n_0\,
      CLK => s_axi_aclk,
      D => bid_fifo_ld(0),
      Q => bid_fifo_rd(0)
    );
\FIFO_RAM[3].SRL16E_I_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => Q(0),
      I1 => axi_awaddr_full,
      I2 => s_axi_awid(0),
      O => bid_fifo_ld(0)
    );
\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFEF"
    )
        port map (
      I0 => axi_wr_burst,
      I1 => wr_data_sm_cs(2),
      I2 => wr_data_sm_cs(0),
      I3 => wr_data_sm_cs(1),
      O => \^axi_wr_burst_reg\
    );
\GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.bram_en_int_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => axi_awaddr_full,
      I1 => bram_addr_ld_en,
      O => \^gen_aw_pipe_dual.axi_awaddr_full_reg\
    );
\GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.bram_en_int_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7F7F7F7F7F000000"
    )
        port map (
      I0 => bvalid_cnt(0),
      I1 => bvalid_cnt(2),
      I2 => bvalid_cnt(1),
      I3 => s_axi_awvalid,
      I4 => s_axi_awready,
      I5 => aw_active,
      O => \^bvalid_cnt_reg[0]\
    );
\axi_bid_int[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8FFB800"
    )
        port map (
      I0 => Q(0),
      I1 => axi_awaddr_full,
      I2 => s_axi_awid(0),
      I3 => \^bid_gets_fifo_load\,
      I4 => bid_fifo_rd(0),
      O => D(0)
    );
\axi_bid_int[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8FFB800"
    )
        port map (
      I0 => Q(1),
      I1 => axi_awaddr_full,
      I2 => s_axi_awid(1),
      I3 => \^bid_gets_fifo_load\,
      I4 => bid_fifo_rd(1),
      O => D(1)
    );
\axi_bid_int[2]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8FFB800"
    )
        port map (
      I0 => Q(2),
      I1 => axi_awaddr_full,
      I2 => s_axi_awid(2),
      I3 => \^bid_gets_fifo_load\,
      I4 => bid_fifo_rd(2),
      O => D(2)
    );
\axi_bid_int[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFEAAAAAAAAA"
    )
        port map (
      I0 => \^bid_gets_fifo_load\,
      I1 => \axi_bid_int[3]_i_3_n_0\,
      I2 => \^fsm_sequential_gen_wdata_sm_no_ecc_dual_reg_wready.wr_data_sm_cs_reg[1]\,
      I3 => \^bvalid_cnt_reg[2]\,
      I4 => bid_gets_fifo_load_d1,
      I5 => bid_fifo_not_empty,
      O => E(0)
    );
\axi_bid_int[3]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8FFB800"
    )
        port map (
      I0 => Q(3),
      I1 => axi_awaddr_full,
      I2 => s_axi_awid(3),
      I3 => \^bid_gets_fifo_load\,
      I4 => bid_fifo_rd(3),
      O => D(3)
    );
\axi_bid_int[3]_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"01"
    )
        port map (
      I0 => bvalid_cnt(0),
      I1 => bvalid_cnt(1),
      I2 => bvalid_cnt(2),
      O => \axi_bid_int[3]_i_3_n_0\
    );
\axi_bid_int[3]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFF4554455445544"
    )
        port map (
      I0 => \^axi_wr_burst_reg\,
      I1 => \^gen_aw_pipe_dual.axi_awaddr_full_reg\,
      I2 => wr_data_sm_cs(1),
      I3 => \^bvalid_cnt_reg[0]\,
      I4 => \axi_bid_int[3]_i_6_n_0\,
      I5 => s_axi_wlast,
      O => \^fsm_sequential_gen_wdata_sm_no_ecc_dual_reg_wready.wr_data_sm_cs_reg[1]\
    );
\axi_bid_int[3]_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FE000000"
    )
        port map (
      I0 => bvalid_cnt(2),
      I1 => bvalid_cnt(1),
      I2 => bvalid_cnt(0),
      I3 => s_axi_bready,
      I4 => \axi_bid_int_reg[0]\,
      O => \^bvalid_cnt_reg[2]\
    );
\axi_bid_int[3]_i_6\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"02"
    )
        port map (
      I0 => s_axi_wvalid,
      I1 => wr_data_sm_cs(0),
      I2 => wr_data_sm_cs(2),
      O => \axi_bid_int[3]_i_6_n_0\
    );
bid_gets_fifo_load_d1_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAE000000000000"
    )
        port map (
      I0 => bid_gets_fifo_load_d1_reg,
      I1 => bid_gets_fifo_load_d1_reg_0,
      I2 => bid_gets_fifo_load_d1_reg_1,
      I3 => axi_wr_burst,
      I4 => bid_gets_fifo_load_d1_i_4_n_0,
      I5 => bram_addr_ld_en,
      O => \^bid_gets_fifo_load\
    );
bid_gets_fifo_load_d1_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0100000011111111"
    )
        port map (
      I0 => bvalid_cnt(1),
      I1 => bvalid_cnt(2),
      I2 => bid_fifo_not_empty,
      I3 => s_axi_bready,
      I4 => \axi_bid_int_reg[0]\,
      I5 => bvalid_cnt(0),
      O => bid_gets_fifo_load_d1_i_4_n_0
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axi64_bram_ctrl_64KiB_wrap_brst is
  port (
    bram_addr_ld_en : out STD_LOGIC;
    \GEN_AW_DUAL.aw_active_reg\ : out STD_LOGIC;
    D : out STD_LOGIC_VECTOR ( 12 downto 0 );
    \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[6]\ : out STD_LOGIC;
    E : out STD_LOGIC_VECTOR ( 1 downto 0 );
    \GEN_AW_DUAL.last_data_ack_mod_reg\ : out STD_LOGIC;
    s_axi_awvalid_0 : out STD_LOGIC;
    s_axi_awvalid_1 : out STD_LOGIC;
    s_axi_awvalid_2 : out STD_LOGIC;
    wr_data_sm_cs : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_wvalid : in STD_LOGIC;
    aw_active : in STD_LOGIC;
    bvalid_cnt : in STD_LOGIC_VECTOR ( 2 downto 0 );
    Q : in STD_LOGIC_VECTOR ( 7 downto 0 );
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[4].axi_awaddr_pipe_reg\ : in STD_LOGIC;
    \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[5]\ : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 12 downto 0 );
    \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[6]_0\ : in STD_LOGIC;
    \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[10]\ : in STD_LOGIC;
    curr_fixed_burst_reg : in STD_LOGIC;
    \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[11]\ : in STD_LOGIC;
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[11].axi_awaddr_pipe_reg\ : in STD_LOGIC;
    axi_awaddr_full : in STD_LOGIC;
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe_reg\ : in STD_LOGIC;
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[15].axi_awaddr_pipe_reg\ : in STD_LOGIC;
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[5].axi_awaddr_pipe_reg\ : in STD_LOGIC;
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[6].axi_awaddr_pipe_reg\ : in STD_LOGIC;
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[7].axi_awaddr_pipe_reg\ : in STD_LOGIC;
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[8].axi_awaddr_pipe_reg\ : in STD_LOGIC;
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[9].axi_awaddr_pipe_reg\ : in STD_LOGIC;
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[10].axi_awaddr_pipe_reg\ : in STD_LOGIC;
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[12].axi_awaddr_pipe_reg\ : in STD_LOGIC;
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[13].axi_awaddr_pipe_reg\ : in STD_LOGIC;
    \GEN_AW_PIPE_DUAL.GEN_AWADDR[14].axi_awaddr_pipe_reg\ : in STD_LOGIC;
    \save_init_bram_addr_ld_reg[15]_0\ : in STD_LOGIC;
    s_axi_awvalid : in STD_LOGIC;
    wr_addr_sm_cs : in STD_LOGIC;
    last_data_ack_mod : in STD_LOGIC;
    axi_awlen_pipe_1_or_2 : in STD_LOGIC;
    curr_awlen_reg_1_or_2 : in STD_LOGIC;
    \save_init_bram_addr_ld_reg[15]_1\ : in STD_LOGIC;
    s_axi_awlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \wrap_burst_total_reg[0]_0\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    axi_awsize_pipe : in STD_LOGIC_VECTOR ( 0 to 0 );
    curr_wrap_burst_reg : in STD_LOGIC;
    \wrap_burst_total_reg[0]_1\ : in STD_LOGIC;
    s_axi_aclk : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of axi64_bram_ctrl_64KiB_wrap_brst : entity is "wrap_brst";
end axi64_bram_ctrl_64KiB_wrap_brst;

architecture STRUCTURE of axi64_bram_ctrl_64KiB_wrap_brst is
  signal \^d\ : STD_LOGIC_VECTOR ( 12 downto 0 );
  signal \^gen_aw_dual.aw_active_reg\ : STD_LOGIC;
  signal \^gen_aw_dual.last_data_ack_mod_reg\ : STD_LOGIC;
  signal \GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_3_n_0\ : STD_LOGIC;
  signal \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_4_n_0\ : STD_LOGIC;
  signal \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5_n_0\ : STD_LOGIC;
  signal \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_6_n_0\ : STD_LOGIC;
  signal \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_7_n_0\ : STD_LOGIC;
  signal \GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_2_n_0\ : STD_LOGIC;
  signal \GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_3_n_0\ : STD_LOGIC;
  signal \GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_4_n_0\ : STD_LOGIC;
  signal \GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_3_n_0\ : STD_LOGIC;
  signal \GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_4_n_0\ : STD_LOGIC;
  signal \GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_5_n_0\ : STD_LOGIC;
  signal \GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_6_n_0\ : STD_LOGIC;
  signal \GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_3_n_0\ : STD_LOGIC;
  signal \GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_4_n_0\ : STD_LOGIC;
  signal \^gen_dual_addr_cnt.bram_addr_int_reg[6]\ : STD_LOGIC;
  signal \^bram_addr_ld_en\ : STD_LOGIC;
  signal p_1_in : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal \^s_axi_awvalid_0\ : STD_LOGIC;
  signal \^s_axi_awvalid_1\ : STD_LOGIC;
  signal \^s_axi_awvalid_2\ : STD_LOGIC;
  signal \save_init_bram_addr_ld[15]_i_4_n_0\ : STD_LOGIC;
  signal \save_init_bram_addr_ld[4]_i_2_n_0\ : STD_LOGIC;
  signal \save_init_bram_addr_ld[5]_i_2_n_0\ : STD_LOGIC;
  signal \save_init_bram_addr_ld_reg_n_0_[10]\ : STD_LOGIC;
  signal \save_init_bram_addr_ld_reg_n_0_[11]\ : STD_LOGIC;
  signal \save_init_bram_addr_ld_reg_n_0_[12]\ : STD_LOGIC;
  signal \save_init_bram_addr_ld_reg_n_0_[13]\ : STD_LOGIC;
  signal \save_init_bram_addr_ld_reg_n_0_[14]\ : STD_LOGIC;
  signal \save_init_bram_addr_ld_reg_n_0_[15]\ : STD_LOGIC;
  signal \save_init_bram_addr_ld_reg_n_0_[4]\ : STD_LOGIC;
  signal \save_init_bram_addr_ld_reg_n_0_[5]\ : STD_LOGIC;
  signal \save_init_bram_addr_ld_reg_n_0_[6]\ : STD_LOGIC;
  signal \save_init_bram_addr_ld_reg_n_0_[7]\ : STD_LOGIC;
  signal \save_init_bram_addr_ld_reg_n_0_[8]\ : STD_LOGIC;
  signal \save_init_bram_addr_ld_reg_n_0_[9]\ : STD_LOGIC;
  signal \wrap_burst_total[0]_i_1_n_0\ : STD_LOGIC;
  signal \wrap_burst_total[0]_i_2_n_0\ : STD_LOGIC;
  signal \wrap_burst_total[1]_i_1_n_0\ : STD_LOGIC;
  signal \wrap_burst_total[1]_i_2_n_0\ : STD_LOGIC;
  signal \wrap_burst_total[2]_i_1_n_0\ : STD_LOGIC;
  signal \wrap_burst_total[2]_i_2_n_0\ : STD_LOGIC;
  signal \wrap_burst_total_reg_n_0_[0]\ : STD_LOGIC;
  signal \wrap_burst_total_reg_n_0_[1]\ : STD_LOGIC;
  signal \wrap_burst_total_reg_n_0_[2]\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_3\ : label is "soft_lutpair45";
  attribute SOFT_HLUTNM of \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_2\ : label is "soft_lutpair40";
  attribute SOFT_HLUTNM of \GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_2\ : label is "soft_lutpair41";
  attribute SOFT_HLUTNM of \GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_4\ : label is "soft_lutpair48";
  attribute SOFT_HLUTNM of \GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_3\ : label is "soft_lutpair42";
  attribute SOFT_HLUTNM of \GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_5\ : label is "soft_lutpair44";
  attribute SOFT_HLUTNM of \GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_6\ : label is "soft_lutpair48";
  attribute SOFT_HLUTNM of \GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_3\ : label is "soft_lutpair43";
  attribute SOFT_HLUTNM of \GEN_DUAL_ADDR_CNT.bram_addr_int[8]_i_1\ : label is "soft_lutpair40";
  attribute SOFT_HLUTNM of \save_init_bram_addr_ld[11]_i_1\ : label is "soft_lutpair45";
  attribute SOFT_HLUTNM of \save_init_bram_addr_ld[15]_i_3\ : label is "soft_lutpair47";
  attribute SOFT_HLUTNM of \save_init_bram_addr_ld[15]_i_4\ : label is "soft_lutpair47";
  attribute SOFT_HLUTNM of \save_init_bram_addr_ld[4]_i_1\ : label is "soft_lutpair41";
  attribute SOFT_HLUTNM of \save_init_bram_addr_ld[4]_i_2\ : label is "soft_lutpair43";
  attribute SOFT_HLUTNM of \save_init_bram_addr_ld[5]_i_1\ : label is "soft_lutpair42";
  attribute SOFT_HLUTNM of \save_init_bram_addr_ld[5]_i_2\ : label is "soft_lutpair44";
  attribute SOFT_HLUTNM of \wrap_burst_total[0]_i_3\ : label is "soft_lutpair46";
  attribute SOFT_HLUTNM of \wrap_burst_total[1]_i_1\ : label is "soft_lutpair46";
begin
  D(12 downto 0) <= \^d\(12 downto 0);
  \GEN_AW_DUAL.aw_active_reg\ <= \^gen_aw_dual.aw_active_reg\;
  \GEN_AW_DUAL.last_data_ack_mod_reg\ <= \^gen_aw_dual.last_data_ack_mod_reg\;
  \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[6]\ <= \^gen_dual_addr_cnt.bram_addr_int_reg[6]\;
  bram_addr_ld_en <= \^bram_addr_ld_en\;
  s_axi_awvalid_0 <= \^s_axi_awvalid_0\;
  s_axi_awvalid_1 <= \^s_axi_awvalid_1\;
  s_axi_awvalid_2 <= \^s_axi_awvalid_2\;
\GEN_DUAL_ADDR_CNT.bram_addr_int[10]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AFF6A00"
    )
        port map (
      I0 => Q(7),
      I1 => \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[10]\,
      I2 => Q(6),
      I3 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_4_n_0\,
      I4 => p_1_in(6),
      O => \^d\(7)
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00040000FFFFFFFF"
    )
        port map (
      I0 => curr_fixed_burst_reg,
      I1 => wr_data_sm_cs(1),
      I2 => wr_data_sm_cs(2),
      I3 => wr_data_sm_cs(0),
      I4 => s_axi_wvalid,
      I5 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_4_n_0\,
      O => E(0)
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF2E2E2E2E2E2E2E"
    )
        port map (
      I0 => \GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_3_n_0\,
      I1 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_4_n_0\,
      I2 => \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[11]\,
      I3 => \GEN_AW_PIPE_DUAL.GEN_AWADDR[11].axi_awaddr_pipe_reg\,
      I4 => \^bram_addr_ld_en\,
      I5 => axi_awaddr_full,
      O => \^d\(8)
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F404"
    )
        port map (
      I0 => axi_awaddr_full,
      I1 => s_axi_awaddr(8),
      I2 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5_n_0\,
      I3 => \save_init_bram_addr_ld_reg_n_0_[11]\,
      O => \GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_3_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[12]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FAFC0A0C"
    )
        port map (
      I0 => \GEN_AW_PIPE_DUAL.GEN_AWADDR[12].axi_awaddr_pipe_reg\,
      I1 => s_axi_awaddr(9),
      I2 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5_n_0\,
      I3 => axi_awaddr_full,
      I4 => \save_init_bram_addr_ld_reg_n_0_[12]\,
      O => \^d\(9)
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[13]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"CFC0CACA"
    )
        port map (
      I0 => s_axi_awaddr(10),
      I1 => \save_init_bram_addr_ld_reg_n_0_[13]\,
      I2 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5_n_0\,
      I3 => \GEN_AW_PIPE_DUAL.GEN_AWADDR[13].axi_awaddr_pipe_reg\,
      I4 => axi_awaddr_full,
      O => \^d\(10)
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[14]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"CFC0CACA"
    )
        port map (
      I0 => s_axi_awaddr(11),
      I1 => \save_init_bram_addr_ld_reg_n_0_[14]\,
      I2 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5_n_0\,
      I3 => \GEN_AW_PIPE_DUAL.GEN_AWADDR[14].axi_awaddr_pipe_reg\,
      I4 => axi_awaddr_full,
      O => \^d\(11)
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_4_n_0\,
      O => E(1)
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"CFC0CACA"
    )
        port map (
      I0 => s_axi_awaddr(12),
      I1 => \save_init_bram_addr_ld_reg_n_0_[15]\,
      I2 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5_n_0\,
      I3 => \GEN_AW_PIPE_DUAL.GEN_AWADDR[15].axi_awaddr_pipe_reg\,
      I4 => axi_awaddr_full,
      O => \^d\(12)
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5555554555555555"
    )
        port map (
      I0 => \^bram_addr_ld_en\,
      I1 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_6_n_0\,
      I2 => wr_data_sm_cs(1),
      I3 => wr_data_sm_cs(2),
      I4 => wr_data_sm_cs(0),
      I5 => s_axi_wvalid,
      O => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_4_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^bram_addr_ld_en\,
      I1 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_6_n_0\,
      O => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFDF0000FFFFFFFF"
    )
        port map (
      I0 => \^gen_dual_addr_cnt.bram_addr_int_reg[6]\,
      I1 => \wrap_burst_total_reg_n_0_[0]\,
      I2 => \wrap_burst_total_reg_n_0_[2]\,
      I3 => \wrap_burst_total_reg_n_0_[1]\,
      I4 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_7_n_0\,
      I5 => curr_wrap_burst_reg,
      O => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_6_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFF4FFF3F3F"
    )
        port map (
      I0 => Q(2),
      I1 => \wrap_burst_total_reg_n_0_[0]\,
      I2 => Q(0),
      I3 => Q(1),
      I4 => \wrap_burst_total_reg_n_0_[1]\,
      I5 => \wrap_burst_total_reg_n_0_[2]\,
      O => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_7_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F4F4F4444444F444"
    )
        port map (
      I0 => Q(0),
      I1 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_4_n_0\,
      I2 => \^bram_addr_ld_en\,
      I3 => s_axi_awaddr(0),
      I4 => axi_awaddr_full,
      I5 => \GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe_reg\,
      O => \^d\(0)
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6F6F6F6F606F6060"
    )
        port map (
      I0 => Q(0),
      I1 => Q(1),
      I2 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_4_n_0\,
      I3 => \GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_2_n_0\,
      I4 => \GEN_AW_PIPE_DUAL.GEN_AWADDR[4].axi_awaddr_pipe_reg\,
      I5 => \GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_3_n_0\,
      O => \^d\(1)
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5_n_0\,
      I1 => axi_awaddr_full,
      O => \GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_2_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"040400FF04040000"
    )
        port map (
      I0 => \GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_4_n_0\,
      I1 => \save_init_bram_addr_ld_reg_n_0_[4]\,
      I2 => \GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_6_n_0\,
      I3 => axi_awaddr_full,
      I4 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5_n_0\,
      I5 => s_axi_awaddr(1),
      O => \GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_3_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \wrap_burst_total_reg_n_0_[1]\,
      I1 => \wrap_burst_total_reg_n_0_[2]\,
      O => \GEN_DUAL_ADDR_CNT.bram_addr_int[4]_i_4_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9F9F9F9F909F9090"
    )
        port map (
      I0 => Q(2),
      I1 => \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[5]\,
      I2 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_4_n_0\,
      I3 => \GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_3_n_0\,
      I4 => s_axi_awaddr(2),
      I5 => \GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_4_n_0\,
      O => \^d\(2)
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_3\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => axi_awaddr_full,
      I1 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5_n_0\,
      O => \GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_3_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00880F88"
    )
        port map (
      I0 => axi_awaddr_full,
      I1 => \GEN_AW_PIPE_DUAL.GEN_AWADDR[5].axi_awaddr_pipe_reg\,
      I2 => \GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_5_n_0\,
      I3 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5_n_0\,
      I4 => \GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_6_n_0\,
      O => \GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_4_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"5D55"
    )
        port map (
      I0 => \save_init_bram_addr_ld_reg_n_0_[5]\,
      I1 => \wrap_burst_total_reg_n_0_[1]\,
      I2 => \wrap_burst_total_reg_n_0_[2]\,
      I3 => \wrap_burst_total_reg_n_0_[0]\,
      O => \GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_5_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_6\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"04"
    )
        port map (
      I0 => \wrap_burst_total_reg_n_0_[1]\,
      I1 => \wrap_burst_total_reg_n_0_[2]\,
      I2 => \wrap_burst_total_reg_n_0_[0]\,
      O => \GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_6_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9F9F9F9F9F909090"
    )
        port map (
      I0 => \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[6]_0\,
      I1 => Q(3),
      I2 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_4_n_0\,
      I3 => \GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_3_n_0\,
      I4 => \save_init_bram_addr_ld_reg_n_0_[6]\,
      I5 => \GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_4_n_0\,
      O => \^d\(3)
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"AA8A"
    )
        port map (
      I0 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5_n_0\,
      I1 => \wrap_burst_total_reg_n_0_[0]\,
      I2 => \wrap_burst_total_reg_n_0_[2]\,
      I3 => \wrap_burst_total_reg_n_0_[1]\,
      O => \GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_3_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0B08"
    )
        port map (
      I0 => \GEN_AW_PIPE_DUAL.GEN_AWADDR[6].axi_awaddr_pipe_reg\,
      I1 => axi_awaddr_full,
      I2 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5_n_0\,
      I3 => s_axi_awaddr(3),
      O => \GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_4_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[7]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6F60"
    )
        port map (
      I0 => Q(4),
      I1 => \^gen_dual_addr_cnt.bram_addr_int_reg[6]\,
      I2 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_4_n_0\,
      I3 => p_1_in(3),
      O => \^d\(4)
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[8]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AFF6A00"
    )
        port map (
      I0 => Q(5),
      I1 => \^gen_dual_addr_cnt.bram_addr_int_reg[6]\,
      I2 => Q(4),
      I3 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_4_n_0\,
      I4 => p_1_in(4),
      O => \^d\(5)
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[9]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6AAAFFFF6AAA0000"
    )
        port map (
      I0 => Q(6),
      I1 => Q(4),
      I2 => \^gen_dual_addr_cnt.bram_addr_int_reg[6]\,
      I3 => Q(5),
      I4 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_4_n_0\,
      I5 => p_1_in(5),
      O => \^d\(6)
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[9]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8000"
    )
        port map (
      I0 => Q(3),
      I1 => Q(2),
      I2 => Q(0),
      I3 => Q(1),
      O => \^gen_dual_addr_cnt.bram_addr_int_reg[6]\
    );
\save_init_bram_addr_ld[10]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFCA00CA"
    )
        port map (
      I0 => s_axi_awaddr(7),
      I1 => \GEN_AW_PIPE_DUAL.GEN_AWADDR[10].axi_awaddr_pipe_reg\,
      I2 => axi_awaddr_full,
      I3 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5_n_0\,
      I4 => \save_init_bram_addr_ld_reg_n_0_[10]\,
      O => p_1_in(6)
    );
\save_init_bram_addr_ld[11]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AFACA0AC"
    )
        port map (
      I0 => \save_init_bram_addr_ld_reg_n_0_[11]\,
      I1 => s_axi_awaddr(8),
      I2 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5_n_0\,
      I3 => axi_awaddr_full,
      I4 => \GEN_AW_PIPE_DUAL.GEN_AWADDR[11].axi_awaddr_pipe_reg\,
      O => p_1_in(7)
    );
\save_init_bram_addr_ld[15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8888AAA888888888"
    )
        port map (
      I0 => \save_init_bram_addr_ld_reg[15]_0\,
      I1 => \^gen_aw_dual.last_data_ack_mod_reg\,
      I2 => axi_awaddr_full,
      I3 => s_axi_awvalid,
      I4 => wr_addr_sm_cs,
      I5 => \^gen_aw_dual.aw_active_reg\,
      O => \^bram_addr_ld_en\
    );
\save_init_bram_addr_ld[15]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000040"
    )
        port map (
      I0 => \save_init_bram_addr_ld[15]_i_4_n_0\,
      I1 => last_data_ack_mod,
      I2 => axi_awaddr_full,
      I3 => axi_awlen_pipe_1_or_2,
      I4 => curr_awlen_reg_1_or_2,
      I5 => \save_init_bram_addr_ld_reg[15]_1\,
      O => \^gen_aw_dual.last_data_ack_mod_reg\
    );
\save_init_bram_addr_ld[15]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"1555"
    )
        port map (
      I0 => aw_active,
      I1 => bvalid_cnt(0),
      I2 => bvalid_cnt(2),
      I3 => bvalid_cnt(1),
      O => \^gen_aw_dual.aw_active_reg\
    );
\save_init_bram_addr_ld[15]_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => bvalid_cnt(1),
      I1 => bvalid_cnt(2),
      I2 => bvalid_cnt(0),
      O => \save_init_bram_addr_ld[15]_i_4_n_0\
    );
\save_init_bram_addr_ld[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFF0A0C"
    )
        port map (
      I0 => \GEN_AW_PIPE_DUAL.GEN_AWADDR[4].axi_awaddr_pipe_reg\,
      I1 => s_axi_awaddr(1),
      I2 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5_n_0\,
      I3 => axi_awaddr_full,
      I4 => \save_init_bram_addr_ld[4]_i_2_n_0\,
      O => p_1_in(0)
    );
\save_init_bram_addr_ld[4]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"C08000C0"
    )
        port map (
      I0 => \wrap_burst_total_reg_n_0_[0]\,
      I1 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5_n_0\,
      I2 => \save_init_bram_addr_ld_reg_n_0_[4]\,
      I3 => \wrap_burst_total_reg_n_0_[1]\,
      I4 => \wrap_burst_total_reg_n_0_[2]\,
      O => \save_init_bram_addr_ld[4]_i_2_n_0\
    );
\save_init_bram_addr_ld[5]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"CCCCFCEE"
    )
        port map (
      I0 => s_axi_awaddr(2),
      I1 => \save_init_bram_addr_ld[5]_i_2_n_0\,
      I2 => \GEN_AW_PIPE_DUAL.GEN_AWADDR[5].axi_awaddr_pipe_reg\,
      I3 => axi_awaddr_full,
      I4 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5_n_0\,
      O => p_1_in(1)
    );
\save_init_bram_addr_ld[5]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A28A0000"
    )
        port map (
      I0 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5_n_0\,
      I1 => \wrap_burst_total_reg_n_0_[0]\,
      I2 => \wrap_burst_total_reg_n_0_[2]\,
      I3 => \wrap_burst_total_reg_n_0_[1]\,
      I4 => \save_init_bram_addr_ld_reg_n_0_[5]\,
      O => \save_init_bram_addr_ld[5]_i_2_n_0\
    );
\save_init_bram_addr_ld[6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"88FF88F8888888F8"
    )
        port map (
      I0 => \GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_3_n_0\,
      I1 => \save_init_bram_addr_ld_reg_n_0_[6]\,
      I2 => s_axi_awaddr(3),
      I3 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5_n_0\,
      I4 => axi_awaddr_full,
      I5 => \GEN_AW_PIPE_DUAL.GEN_AWADDR[6].axi_awaddr_pipe_reg\,
      O => p_1_in(2)
    );
\save_init_bram_addr_ld[7]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"CFC0CACA"
    )
        port map (
      I0 => s_axi_awaddr(4),
      I1 => \save_init_bram_addr_ld_reg_n_0_[7]\,
      I2 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5_n_0\,
      I3 => \GEN_AW_PIPE_DUAL.GEN_AWADDR[7].axi_awaddr_pipe_reg\,
      I4 => axi_awaddr_full,
      O => p_1_in(3)
    );
\save_init_bram_addr_ld[8]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FAFC0A0C"
    )
        port map (
      I0 => \GEN_AW_PIPE_DUAL.GEN_AWADDR[8].axi_awaddr_pipe_reg\,
      I1 => s_axi_awaddr(5),
      I2 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5_n_0\,
      I3 => axi_awaddr_full,
      I4 => \save_init_bram_addr_ld_reg_n_0_[8]\,
      O => p_1_in(4)
    );
\save_init_bram_addr_ld[9]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"CFC0CACA"
    )
        port map (
      I0 => s_axi_awaddr(6),
      I1 => \save_init_bram_addr_ld_reg_n_0_[9]\,
      I2 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_5_n_0\,
      I3 => \GEN_AW_PIPE_DUAL.GEN_AWADDR[9].axi_awaddr_pipe_reg\,
      I4 => axi_awaddr_full,
      O => p_1_in(5)
    );
\save_init_bram_addr_ld_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \^bram_addr_ld_en\,
      D => p_1_in(6),
      Q => \save_init_bram_addr_ld_reg_n_0_[10]\,
      R => \wrap_burst_total_reg[0]_1\
    );
\save_init_bram_addr_ld_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \^bram_addr_ld_en\,
      D => p_1_in(7),
      Q => \save_init_bram_addr_ld_reg_n_0_[11]\,
      R => \wrap_burst_total_reg[0]_1\
    );
\save_init_bram_addr_ld_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \^bram_addr_ld_en\,
      D => \^d\(9),
      Q => \save_init_bram_addr_ld_reg_n_0_[12]\,
      R => \wrap_burst_total_reg[0]_1\
    );
\save_init_bram_addr_ld_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \^bram_addr_ld_en\,
      D => \^d\(10),
      Q => \save_init_bram_addr_ld_reg_n_0_[13]\,
      R => \wrap_burst_total_reg[0]_1\
    );
\save_init_bram_addr_ld_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \^bram_addr_ld_en\,
      D => \^d\(11),
      Q => \save_init_bram_addr_ld_reg_n_0_[14]\,
      R => \wrap_burst_total_reg[0]_1\
    );
\save_init_bram_addr_ld_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \^bram_addr_ld_en\,
      D => \^d\(12),
      Q => \save_init_bram_addr_ld_reg_n_0_[15]\,
      R => \wrap_burst_total_reg[0]_1\
    );
\save_init_bram_addr_ld_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \^bram_addr_ld_en\,
      D => p_1_in(0),
      Q => \save_init_bram_addr_ld_reg_n_0_[4]\,
      R => \wrap_burst_total_reg[0]_1\
    );
\save_init_bram_addr_ld_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \^bram_addr_ld_en\,
      D => p_1_in(1),
      Q => \save_init_bram_addr_ld_reg_n_0_[5]\,
      R => \wrap_burst_total_reg[0]_1\
    );
\save_init_bram_addr_ld_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \^bram_addr_ld_en\,
      D => p_1_in(2),
      Q => \save_init_bram_addr_ld_reg_n_0_[6]\,
      R => \wrap_burst_total_reg[0]_1\
    );
\save_init_bram_addr_ld_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \^bram_addr_ld_en\,
      D => p_1_in(3),
      Q => \save_init_bram_addr_ld_reg_n_0_[7]\,
      R => \wrap_burst_total_reg[0]_1\
    );
\save_init_bram_addr_ld_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \^bram_addr_ld_en\,
      D => p_1_in(4),
      Q => \save_init_bram_addr_ld_reg_n_0_[8]\,
      R => \wrap_burst_total_reg[0]_1\
    );
\save_init_bram_addr_ld_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \^bram_addr_ld_en\,
      D => p_1_in(5),
      Q => \save_init_bram_addr_ld_reg_n_0_[9]\,
      R => \wrap_burst_total_reg[0]_1\
    );
\wrap_burst_total[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"4500004500000010"
    )
        port map (
      I0 => \wrap_burst_total[0]_i_2_n_0\,
      I1 => axi_awsize_pipe(0),
      I2 => axi_awaddr_full,
      I3 => \^s_axi_awvalid_0\,
      I4 => \^s_axi_awvalid_1\,
      I5 => \^s_axi_awvalid_2\,
      O => \wrap_burst_total[0]_i_1_n_0\
    );
\wrap_burst_total[0]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0F77"
    )
        port map (
      I0 => s_axi_awvalid,
      I1 => s_axi_awlen(0),
      I2 => \wrap_burst_total_reg[0]_0\(0),
      I3 => axi_awaddr_full,
      O => \wrap_burst_total[0]_i_2_n_0\
    );
\wrap_burst_total[0]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0F77"
    )
        port map (
      I0 => s_axi_awvalid,
      I1 => s_axi_awlen(1),
      I2 => \wrap_burst_total_reg[0]_0\(1),
      I3 => axi_awaddr_full,
      O => \^s_axi_awvalid_0\
    );
\wrap_burst_total[0]_i_4\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0F77"
    )
        port map (
      I0 => s_axi_awvalid,
      I1 => s_axi_awlen(2),
      I2 => \wrap_burst_total_reg[0]_0\(2),
      I3 => axi_awaddr_full,
      O => \^s_axi_awvalid_1\
    );
\wrap_burst_total[0]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0F77"
    )
        port map (
      I0 => s_axi_awvalid,
      I1 => s_axi_awlen(3),
      I2 => \wrap_burst_total_reg[0]_0\(3),
      I3 => axi_awaddr_full,
      O => \^s_axi_awvalid_2\
    );
\wrap_burst_total[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A2808080"
    )
        port map (
      I0 => \wrap_burst_total[1]_i_2_n_0\,
      I1 => axi_awaddr_full,
      I2 => \wrap_burst_total_reg[0]_0\(1),
      I3 => s_axi_awlen(1),
      I4 => s_axi_awvalid,
      O => \wrap_burst_total[1]_i_1_n_0\
    );
\wrap_burst_total[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F088008800000000"
    )
        port map (
      I0 => s_axi_awvalid,
      I1 => s_axi_awlen(0),
      I2 => \wrap_burst_total_reg[0]_0\(0),
      I3 => axi_awaddr_full,
      I4 => axi_awsize_pipe(0),
      I5 => \^s_axi_awvalid_2\,
      O => \wrap_burst_total[1]_i_2_n_0\
    );
\wrap_burst_total[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F088008800000000"
    )
        port map (
      I0 => s_axi_awvalid,
      I1 => s_axi_awlen(0),
      I2 => \wrap_burst_total_reg[0]_0\(0),
      I3 => axi_awaddr_full,
      I4 => axi_awsize_pipe(0),
      I5 => \wrap_burst_total[2]_i_2_n_0\,
      O => \wrap_burst_total[2]_i_1_n_0\
    );
\wrap_burst_total[2]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000055004040"
    )
        port map (
      I0 => \^s_axi_awvalid_0\,
      I1 => s_axi_awvalid,
      I2 => s_axi_awlen(2),
      I3 => \wrap_burst_total_reg[0]_0\(2),
      I4 => axi_awaddr_full,
      I5 => \^s_axi_awvalid_2\,
      O => \wrap_burst_total[2]_i_2_n_0\
    );
\wrap_burst_total_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \^bram_addr_ld_en\,
      D => \wrap_burst_total[0]_i_1_n_0\,
      Q => \wrap_burst_total_reg_n_0_[0]\,
      R => \wrap_burst_total_reg[0]_1\
    );
\wrap_burst_total_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \^bram_addr_ld_en\,
      D => \wrap_burst_total[1]_i_1_n_0\,
      Q => \wrap_burst_total_reg_n_0_[1]\,
      R => \wrap_burst_total_reg[0]_1\
    );
\wrap_burst_total_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \^bram_addr_ld_en\,
      D => \wrap_burst_total[2]_i_1_n_0\,
      Q => \wrap_burst_total_reg_n_0_[2]\,
      R => \wrap_burst_total_reg[0]_1\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axi64_bram_ctrl_64KiB_wrap_brst_rd is
  port (
    \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg\ : out STD_LOGIC;
    D : out STD_LOGIC_VECTOR ( 11 downto 0 );
    SR : out STD_LOGIC_VECTOR ( 0 to 0 );
    \GEN_RD_CMD_OPT.wrap_addr_assign_reg\ : out STD_LOGIC;
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[9]\ : out STD_LOGIC;
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8]\ : out STD_LOGIC;
    bram_addr_b : out STD_LOGIC_VECTOR ( 4 downto 0 );
    \GEN_RD_CMD_OPT.arlen_reg_reg[3]\ : out STD_LOGIC;
    \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_active_reg\ : out STD_LOGIC;
    \GEN_RD_CMD_OPT.axi_rvalid_int_reg\ : out STD_LOGIC;
    addr_vld_rdy5_out : out STD_LOGIC;
    \GEN_RD_CMD_OPT.wrap_addr_assign_reg_0\ : out STD_LOGIC;
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[4]\ : in STD_LOGIC;
    wrap_addr_assign : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 10 downto 0 );
    s_axi_araddr : in STD_LOGIC_VECTOR ( 12 downto 0 );
    s_axi_aresetn : in STD_LOGIC;
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7]\ : in STD_LOGIC;
    \GEN_RD_CMD_OPT.wrap_addr_assign_reg_1\ : in STD_LOGIC;
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7]_0\ : in STD_LOGIC;
    \bram_addr_b[5]\ : in STD_LOGIC;
    bram_addr_b_4_sp_1 : in STD_LOGIC;
    \bram_addr_b[5]_0\ : in STD_LOGIC;
    s_axi_arlen : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \bram_addr_b[5]_1\ : in STD_LOGIC;
    \bram_addr_b[5]_2\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    \wrap_burst_total_reg_reg[2]_0\ : in STD_LOGIC_VECTOR ( 1 downto 0 );
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8]_0\ : in STD_LOGIC;
    \wrap_burst_total_reg_reg[2]_1\ : in STD_LOGIC;
    rd_cmd_reg : in STD_LOGIC;
    rd_active : in STD_LOGIC;
    s_axi_arvalid : in STD_LOGIC;
    axi_aresetn_d3 : in STD_LOGIC;
    \bram_addr_b[5]_INST_0_i_8\ : in STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    rd_data_sm_cs : in STD_LOGIC_VECTOR ( 1 downto 0 );
    axi_rlast_cmb_reg : in STD_LOGIC;
    \GEN_RD_CMD_OPT.wrap_addr_assign_reg_2\ : in STD_LOGIC;
    bram_en_b : in STD_LOGIC;
    s_axi_aclk : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of axi64_bram_ctrl_64KiB_wrap_brst_rd : entity is "wrap_brst_rd";
end axi64_bram_ctrl_64KiB_wrap_brst_rd;

architecture STRUCTURE of axi64_bram_ctrl_64KiB_wrap_brst_rd is
  signal \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_active_reg\ : STD_LOGIC;
  signal \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_2_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_3_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_4_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[5]_i_2_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[7]_i_2_n_0\ : STD_LOGIC;
  signal \^gen_rd_cmd_opt.gen_wo_narrow.bram_addr_int_reg[8]\ : STD_LOGIC;
  signal \^gen_rd_cmd_opt.gen_wo_narrow.bram_addr_int_reg[9]\ : STD_LOGIC;
  signal \^gen_rd_cmd_opt.arlen_reg_reg[3]\ : STD_LOGIC;
  signal \^gen_rd_cmd_opt.axi_rvalid_int_reg\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.wrap_addr_assign_i_2_n_0\ : STD_LOGIC;
  signal \^gen_rd_cmd_opt.wrap_addr_assign_reg\ : STD_LOGIC;
  signal \^sr\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \^addr_vld_rdy5_out\ : STD_LOGIC;
  signal \^bram_addr_b\ : STD_LOGIC_VECTOR ( 4 downto 0 );
  signal \bram_addr_b[4]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \bram_addr_b[4]_INST_0_i_2_n_0\ : STD_LOGIC;
  signal \bram_addr_b[5]_INST_0_i_2_n_0\ : STD_LOGIC;
  signal \bram_addr_b[5]_INST_0_i_6_n_0\ : STD_LOGIC;
  signal \bram_addr_b[5]_INST_0_i_7_n_0\ : STD_LOGIC;
  signal \bram_addr_b[6]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \bram_addr_b[6]_INST_0_i_2_n_0\ : STD_LOGIC;
  signal \bram_addr_b[6]_INST_0_i_3_n_0\ : STD_LOGIC;
  signal \bram_addr_b[6]_INST_0_i_4_n_0\ : STD_LOGIC;
  signal bram_addr_b_4_sn_1 : STD_LOGIC;
  signal save_init_bram_addr_ld : STD_LOGIC_VECTOR ( 15 downto 7 );
  signal save_init_bram_addr_ld_reg : STD_LOGIC_VECTOR ( 15 downto 4 );
  signal wrap_burst_total : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal wrap_burst_total_reg : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \wrap_burst_total_reg[0]_i_2_n_0\ : STD_LOGIC;
  signal \wrap_burst_total_reg[0]_i_3_n_0\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[10]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_4\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[7]_i_2\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \bram_addr_b[10]_INST_0\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \bram_addr_b[11]_INST_0\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \bram_addr_b[12]_INST_0\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \bram_addr_b[13]_INST_0\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \bram_addr_b[14]_INST_0\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \bram_addr_b[15]_INST_0\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \bram_addr_b[4]_INST_0\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \bram_addr_b[4]_INST_0_i_2\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \bram_addr_b[6]_INST_0_i_2\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \bram_addr_b[6]_INST_0_i_3\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \bram_addr_b[6]_INST_0_i_4\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \bram_addr_b[7]_INST_0\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \bram_addr_b[8]_INST_0\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \bram_addr_b[9]_INST_0\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \save_init_bram_addr_ld_reg[10]_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \save_init_bram_addr_ld_reg[11]_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \save_init_bram_addr_ld_reg[12]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \save_init_bram_addr_ld_reg[13]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \save_init_bram_addr_ld_reg[14]_i_1\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \save_init_bram_addr_ld_reg[15]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \save_init_bram_addr_ld_reg[7]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \save_init_bram_addr_ld_reg[8]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \save_init_bram_addr_ld_reg[9]_i_1\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \wrap_burst_total_reg[0]_i_3\ : label is "soft_lutpair12";
begin
  \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_active_reg\ <= \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_active_reg\;
  \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg\ <= \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\;
  \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8]\ <= \^gen_rd_cmd_opt.gen_wo_narrow.bram_addr_int_reg[8]\;
  \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[9]\ <= \^gen_rd_cmd_opt.gen_wo_narrow.bram_addr_int_reg[9]\;
  \GEN_RD_CMD_OPT.arlen_reg_reg[3]\ <= \^gen_rd_cmd_opt.arlen_reg_reg[3]\;
  \GEN_RD_CMD_OPT.axi_rvalid_int_reg\ <= \^gen_rd_cmd_opt.axi_rvalid_int_reg\;
  \GEN_RD_CMD_OPT.wrap_addr_assign_reg\ <= \^gen_rd_cmd_opt.wrap_addr_assign_reg\;
  SR(0) <= \^sr\(0);
  addr_vld_rdy5_out <= \^addr_vld_rdy5_out\;
  bram_addr_b(4 downto 0) <= \^bram_addr_b\(4 downto 0);
  bram_addr_b_4_sn_1 <= bram_addr_b_4_sp_1;
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[10]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6AAA"
    )
        port map (
      I0 => \^bram_addr_b\(3),
      I1 => \^gen_rd_cmd_opt.gen_wo_narrow.bram_addr_int_reg[8]\,
      I2 => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_2_n_0\,
      I3 => \^gen_rd_cmd_opt.gen_wo_narrow.bram_addr_int_reg[9]\,
      O => D(6)
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"6AAAAAAA"
    )
        port map (
      I0 => \^bram_addr_b\(4),
      I1 => \^gen_rd_cmd_opt.gen_wo_narrow.bram_addr_int_reg[9]\,
      I2 => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_2_n_0\,
      I3 => \^gen_rd_cmd_opt.gen_wo_narrow.bram_addr_int_reg[8]\,
      I4 => \^bram_addr_b\(3),
      O => D(7)
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000020000"
    )
        port map (
      I0 => \^bram_addr_b\(2),
      I1 => \GEN_RD_CMD_OPT.wrap_addr_assign_reg_1\,
      I2 => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[4]\,
      I3 => \bram_addr_b[4]_INST_0_i_1_n_0\,
      I4 => \^gen_rd_cmd_opt.wrap_addr_assign_reg\,
      I5 => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_3_n_0\,
      O => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_2_n_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"88888A8888888888"
    )
        port map (
      I0 => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7]\,
      I1 => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_4_n_0\,
      I2 => \bram_addr_b[5]_INST_0_i_2_n_0\,
      I3 => \bram_addr_b[5]\,
      I4 => wrap_burst_total(1),
      I5 => wrap_burst_total(2),
      O => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_3_n_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"7F"
    )
        port map (
      I0 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I1 => wrap_addr_assign,
      I2 => save_init_bram_addr_ld_reg(6),
      O => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_4_n_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5655666656555555"
    )
        port map (
      I0 => \bram_addr_b[4]_INST_0_i_1_n_0\,
      I1 => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[4]\,
      I2 => wrap_addr_assign,
      I3 => Q(0),
      I4 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I5 => s_axi_araddr(0),
      O => D(0)
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[5]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"9"
    )
        port map (
      I0 => \^gen_rd_cmd_opt.wrap_addr_assign_reg\,
      I1 => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[5]_i_2_n_0\,
      O => D(1)
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[5]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FEFFEEEEFEFFFFFF"
    )
        port map (
      I0 => \bram_addr_b[4]_INST_0_i_1_n_0\,
      I1 => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[4]\,
      I2 => wrap_addr_assign,
      I3 => Q(0),
      I4 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I5 => s_axi_araddr(0),
      O => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[5]_i_2_n_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000FFFF7FFF0000"
    )
        port map (
      I0 => \bram_addr_b[6]_INST_0_i_1_n_0\,
      I1 => save_init_bram_addr_ld_reg(6),
      I2 => wrap_addr_assign,
      I3 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I4 => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7]\,
      I5 => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[7]_i_2_n_0\,
      O => D(2)
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A999A9A9A9A9A9A9"
    )
        port map (
      I0 => \^bram_addr_b\(2),
      I1 => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[7]_i_2_n_0\,
      I2 => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7]\,
      I3 => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7]_0\,
      I4 => save_init_bram_addr_ld_reg(6),
      I5 => \bram_addr_b[6]_INST_0_i_1_n_0\,
      O => D(3)
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[7]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FEFF"
    )
        port map (
      I0 => \GEN_RD_CMD_OPT.wrap_addr_assign_reg_1\,
      I1 => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[4]\,
      I2 => \bram_addr_b[4]_INST_0_i_1_n_0\,
      I3 => \^gen_rd_cmd_opt.wrap_addr_assign_reg\,
      O => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[7]_i_2_n_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[8]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"30553F55CFAAC0AA"
    )
        port map (
      I0 => s_axi_araddr(5),
      I1 => save_init_bram_addr_ld_reg(8),
      I2 => wrap_addr_assign,
      I3 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I4 => Q(3),
      I5 => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_2_n_0\,
      O => D(4)
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[9]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"6A"
    )
        port map (
      I0 => \^gen_rd_cmd_opt.gen_wo_narrow.bram_addr_int_reg[9]\,
      I1 => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[11]_i_2_n_0\,
      I2 => \^gen_rd_cmd_opt.gen_wo_narrow.bram_addr_int_reg[8]\,
      O => D(5)
    );
\GEN_RD_CMD_OPT.wrap_addr_assign_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"02FF0200"
    )
        port map (
      I0 => \GEN_RD_CMD_OPT.wrap_addr_assign_i_2_n_0\,
      I1 => \GEN_RD_CMD_OPT.wrap_addr_assign_reg_2\,
      I2 => \GEN_RD_CMD_OPT.wrap_addr_assign_reg_1\,
      I3 => bram_en_b,
      I4 => wrap_addr_assign,
      O => \GEN_RD_CMD_OPT.wrap_addr_assign_reg_0\
    );
\GEN_RD_CMD_OPT.wrap_addr_assign_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000F0A020000FF"
    )
        port map (
      I0 => \^gen_rd_cmd_opt.wrap_addr_assign_reg\,
      I1 => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7]\,
      I2 => \bram_addr_b[4]_INST_0_i_1_n_0\,
      I3 => \wrap_burst_total_reg[0]_i_2_n_0\,
      I4 => wrap_burst_total(2),
      I5 => wrap_burst_total(1),
      O => \GEN_RD_CMD_OPT.wrap_addr_assign_i_2_n_0\
    );
\bram_addr_b[10]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FB3BC808"
    )
        port map (
      I0 => Q(5),
      I1 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I2 => wrap_addr_assign,
      I3 => save_init_bram_addr_ld_reg(10),
      I4 => s_axi_araddr(7),
      O => \^bram_addr_b\(3)
    );
\bram_addr_b[11]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FB3BC808"
    )
        port map (
      I0 => Q(6),
      I1 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I2 => wrap_addr_assign,
      I3 => save_init_bram_addr_ld_reg(11),
      I4 => s_axi_araddr(8),
      O => \^bram_addr_b\(4)
    );
\bram_addr_b[12]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FB3BC808"
    )
        port map (
      I0 => Q(7),
      I1 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I2 => wrap_addr_assign,
      I3 => save_init_bram_addr_ld_reg(12),
      I4 => s_axi_araddr(9),
      O => D(8)
    );
\bram_addr_b[13]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FB3BC808"
    )
        port map (
      I0 => Q(8),
      I1 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I2 => wrap_addr_assign,
      I3 => save_init_bram_addr_ld_reg(13),
      I4 => s_axi_araddr(10),
      O => D(9)
    );
\bram_addr_b[14]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FB3BC808"
    )
        port map (
      I0 => Q(9),
      I1 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I2 => wrap_addr_assign,
      I3 => save_init_bram_addr_ld_reg(14),
      I4 => s_axi_araddr(11),
      O => D(10)
    );
\bram_addr_b[15]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FB3BC808"
    )
        port map (
      I0 => Q(10),
      I1 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I2 => wrap_addr_assign,
      I3 => save_init_bram_addr_ld_reg(15),
      I4 => s_axi_araddr(12),
      O => D(11)
    );
\bram_addr_b[4]_INST_0\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \bram_addr_b[4]_INST_0_i_1_n_0\,
      O => \^bram_addr_b\(0)
    );
\bram_addr_b[4]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFFF04F0"
    )
        port map (
      I0 => \bram_addr_b[5]_INST_0_i_2_n_0\,
      I1 => \bram_addr_b[5]\,
      I2 => wrap_burst_total(1),
      I3 => wrap_burst_total(2),
      I4 => \bram_addr_b[4]_INST_0_i_2_n_0\,
      I5 => bram_addr_b_4_sn_1,
      O => \bram_addr_b[4]_INST_0_i_1_n_0\
    );
\bram_addr_b[4]_INST_0_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"7F"
    )
        port map (
      I0 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I1 => wrap_addr_assign,
      I2 => save_init_bram_addr_ld_reg(4),
      O => \bram_addr_b[4]_INST_0_i_2_n_0\
    );
\bram_addr_b[5]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAAAAFFEFBAFF"
    )
        port map (
      I0 => \bram_addr_b[5]_0\,
      I1 => \bram_addr_b[5]_INST_0_i_2_n_0\,
      I2 => \bram_addr_b[5]\,
      I3 => wrap_burst_total(1),
      I4 => wrap_burst_total(2),
      I5 => \bram_addr_b[5]_INST_0_i_6_n_0\,
      O => \^gen_rd_cmd_opt.wrap_addr_assign_reg\
    );
\bram_addr_b[5]_INST_0_i_10\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => rd_active,
      I1 => rd_cmd_reg,
      O => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_active_reg\
    );
\bram_addr_b[5]_INST_0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF101010001010"
    )
        port map (
      I0 => \bram_addr_b[5]_INST_0_i_7_n_0\,
      I1 => \bram_addr_b[5]_1\,
      I2 => \^gen_rd_cmd_opt.arlen_reg_reg[3]\,
      I3 => \bram_addr_b[5]_2\(0),
      I4 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I5 => wrap_burst_total_reg(0),
      O => \bram_addr_b[5]_INST_0_i_2_n_0\
    );
\bram_addr_b[5]_INST_0_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FF080008"
    )
        port map (
      I0 => s_axi_arlen(1),
      I1 => s_axi_arlen(0),
      I2 => s_axi_arlen(3),
      I3 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I4 => wrap_burst_total_reg(1),
      O => wrap_burst_total(1)
    );
\bram_addr_b[5]_INST_0_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AA00AA00AA30AA00"
    )
        port map (
      I0 => wrap_burst_total_reg(2),
      I1 => \bram_addr_b[5]_INST_0_i_7_n_0\,
      I2 => s_axi_arlen(0),
      I3 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I4 => s_axi_arlen(1),
      I5 => \^gen_rd_cmd_opt.arlen_reg_reg[3]\,
      O => wrap_burst_total(2)
    );
\bram_addr_b[5]_INST_0_i_6\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"7F"
    )
        port map (
      I0 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I1 => wrap_addr_assign,
      I2 => save_init_bram_addr_ld_reg(5),
      O => \bram_addr_b[5]_INST_0_i_6_n_0\
    );
\bram_addr_b[5]_INST_0_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"555500015555FFFD"
    )
        port map (
      I0 => \wrap_burst_total_reg_reg[2]_0\(0),
      I1 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_active_reg\,
      I2 => \^gen_rd_cmd_opt.axi_rvalid_int_reg\,
      I3 => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8]_0\,
      I4 => \wrap_burst_total_reg_reg[2]_1\,
      I5 => s_axi_arlen(2),
      O => \bram_addr_b[5]_INST_0_i_7_n_0\
    );
\bram_addr_b[5]_INST_0_i_9\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"555500015555FFFD"
    )
        port map (
      I0 => \wrap_burst_total_reg_reg[2]_0\(1),
      I1 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_active_reg\,
      I2 => \^gen_rd_cmd_opt.axi_rvalid_int_reg\,
      I3 => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8]_0\,
      I4 => \wrap_burst_total_reg_reg[2]_1\,
      I5 => s_axi_arlen(3),
      O => \^gen_rd_cmd_opt.arlen_reg_reg[3]\
    );
\bram_addr_b[6]_INST_0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8FFF80FF8F008000"
    )
        port map (
      I0 => \bram_addr_b[6]_INST_0_i_1_n_0\,
      I1 => save_init_bram_addr_ld_reg(6),
      I2 => wrap_addr_assign,
      I3 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I4 => Q(1),
      I5 => s_axi_araddr(3),
      O => \^bram_addr_b\(1)
    );
\bram_addr_b[6]_INST_0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFF4FFFFFFFFFF"
    )
        port map (
      I0 => \bram_addr_b[6]_INST_0_i_2_n_0\,
      I1 => \bram_addr_b[6]_INST_0_i_3_n_0\,
      I2 => \bram_addr_b[6]_INST_0_i_4_n_0\,
      I3 => \bram_addr_b[5]\,
      I4 => wrap_burst_total(1),
      I5 => wrap_burst_total(2),
      O => \bram_addr_b[6]_INST_0_i_1_n_0\
    );
\bram_addr_b[6]_INST_0_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"F7FF"
    )
        port map (
      I0 => s_axi_arlen(2),
      I1 => s_axi_arlen(0),
      I2 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I3 => s_axi_arlen(1),
      O => \bram_addr_b[6]_INST_0_i_2_n_0\
    );
\bram_addr_b[6]_INST_0_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"3055"
    )
        port map (
      I0 => s_axi_arlen(3),
      I1 => \wrap_burst_total_reg_reg[2]_0\(1),
      I2 => \bram_addr_b[5]_2\(0),
      I3 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      O => \bram_addr_b[6]_INST_0_i_3_n_0\
    );
\bram_addr_b[6]_INST_0_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => wrap_burst_total_reg(0),
      I1 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      O => \bram_addr_b[6]_INST_0_i_4_n_0\
    );
\bram_addr_b[7]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FB3BC808"
    )
        port map (
      I0 => Q(2),
      I1 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I2 => wrap_addr_assign,
      I3 => save_init_bram_addr_ld_reg(7),
      I4 => s_axi_araddr(4),
      O => \^bram_addr_b\(2)
    );
\bram_addr_b[8]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FB3BC808"
    )
        port map (
      I0 => Q(3),
      I1 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I2 => wrap_addr_assign,
      I3 => save_init_bram_addr_ld_reg(8),
      I4 => s_axi_araddr(5),
      O => \^gen_rd_cmd_opt.gen_wo_narrow.bram_addr_int_reg[8]\
    );
\bram_addr_b[9]_INST_0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FB3BC808"
    )
        port map (
      I0 => Q(4),
      I1 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I2 => wrap_addr_assign,
      I3 => save_init_bram_addr_ld_reg(9),
      I4 => s_axi_araddr(6),
      O => \^gen_rd_cmd_opt.gen_wo_narrow.bram_addr_int_reg[9]\
    );
bram_en_b_INST_0_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000EFFFFFFFFFFFF"
    )
        port map (
      I0 => rd_cmd_reg,
      I1 => rd_active,
      I2 => \^gen_rd_cmd_opt.axi_rvalid_int_reg\,
      I3 => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8]_0\,
      I4 => s_axi_arvalid,
      I5 => axi_aresetn_d3,
      O => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\
    );
bram_en_b_INST_0_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"88880080"
    )
        port map (
      I0 => \bram_addr_b[5]_INST_0_i_8\,
      I1 => s_axi_rready,
      I2 => rd_data_sm_cs(1),
      I3 => rd_data_sm_cs(0),
      I4 => axi_rlast_cmb_reg,
      O => \^gen_rd_cmd_opt.axi_rvalid_int_reg\
    );
bram_rst_b_INST_0: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => s_axi_aresetn,
      O => \^sr\(0)
    );
\save_init_bram_addr_ld_reg[10]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => save_init_bram_addr_ld_reg(10),
      I1 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I2 => s_axi_araddr(7),
      O => save_init_bram_addr_ld(10)
    );
\save_init_bram_addr_ld_reg[11]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => save_init_bram_addr_ld_reg(11),
      I1 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I2 => s_axi_araddr(8),
      O => save_init_bram_addr_ld(11)
    );
\save_init_bram_addr_ld_reg[12]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => save_init_bram_addr_ld_reg(12),
      I1 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I2 => s_axi_araddr(9),
      O => save_init_bram_addr_ld(12)
    );
\save_init_bram_addr_ld_reg[13]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => save_init_bram_addr_ld_reg(13),
      I1 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I2 => s_axi_araddr(10),
      O => save_init_bram_addr_ld(13)
    );
\save_init_bram_addr_ld_reg[14]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => save_init_bram_addr_ld_reg(14),
      I1 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I2 => s_axi_araddr(11),
      O => save_init_bram_addr_ld(14)
    );
\save_init_bram_addr_ld_reg[15]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => save_init_bram_addr_ld_reg(15),
      I1 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I2 => s_axi_araddr(12),
      O => save_init_bram_addr_ld(15)
    );
\save_init_bram_addr_ld_reg[6]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      O => \^addr_vld_rdy5_out\
    );
\save_init_bram_addr_ld_reg[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => save_init_bram_addr_ld_reg(7),
      I1 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I2 => s_axi_araddr(4),
      O => save_init_bram_addr_ld(7)
    );
\save_init_bram_addr_ld_reg[8]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => save_init_bram_addr_ld_reg(8),
      I1 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I2 => s_axi_araddr(5),
      O => save_init_bram_addr_ld(8)
    );
\save_init_bram_addr_ld_reg[9]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => save_init_bram_addr_ld_reg(9),
      I1 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I2 => s_axi_araddr(6),
      O => save_init_bram_addr_ld(9)
    );
\save_init_bram_addr_ld_reg_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => save_init_bram_addr_ld(10),
      Q => save_init_bram_addr_ld_reg(10),
      R => \^sr\(0)
    );
\save_init_bram_addr_ld_reg_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => save_init_bram_addr_ld(11),
      Q => save_init_bram_addr_ld_reg(11),
      R => \^sr\(0)
    );
\save_init_bram_addr_ld_reg_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => save_init_bram_addr_ld(12),
      Q => save_init_bram_addr_ld_reg(12),
      R => \^sr\(0)
    );
\save_init_bram_addr_ld_reg_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => save_init_bram_addr_ld(13),
      Q => save_init_bram_addr_ld_reg(13),
      R => \^sr\(0)
    );
\save_init_bram_addr_ld_reg_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => save_init_bram_addr_ld(14),
      Q => save_init_bram_addr_ld_reg(14),
      R => \^sr\(0)
    );
\save_init_bram_addr_ld_reg_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => save_init_bram_addr_ld(15),
      Q => save_init_bram_addr_ld_reg(15),
      R => \^sr\(0)
    );
\save_init_bram_addr_ld_reg_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \^addr_vld_rdy5_out\,
      D => s_axi_araddr(1),
      Q => save_init_bram_addr_ld_reg(4),
      R => \^sr\(0)
    );
\save_init_bram_addr_ld_reg_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \^addr_vld_rdy5_out\,
      D => s_axi_araddr(2),
      Q => save_init_bram_addr_ld_reg(5),
      R => \^sr\(0)
    );
\save_init_bram_addr_ld_reg_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \^addr_vld_rdy5_out\,
      D => s_axi_araddr(3),
      Q => save_init_bram_addr_ld_reg(6),
      R => \^sr\(0)
    );
\save_init_bram_addr_ld_reg_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => save_init_bram_addr_ld(7),
      Q => save_init_bram_addr_ld_reg(7),
      R => \^sr\(0)
    );
\save_init_bram_addr_ld_reg_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => save_init_bram_addr_ld(8),
      Q => save_init_bram_addr_ld_reg(8),
      R => \^sr\(0)
    );
\save_init_bram_addr_ld_reg_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => save_init_bram_addr_ld(9),
      Q => save_init_bram_addr_ld_reg(9),
      R => \^sr\(0)
    );
\wrap_burst_total_reg[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \wrap_burst_total_reg[0]_i_2_n_0\,
      O => wrap_burst_total(0)
    );
\wrap_burst_total_reg[0]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0777077700000777"
    )
        port map (
      I0 => \wrap_burst_total_reg[0]_i_3_n_0\,
      I1 => s_axi_arlen(0),
      I2 => wrap_burst_total_reg(0),
      I3 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I4 => \bram_addr_b[6]_INST_0_i_3_n_0\,
      I5 => \bram_addr_b[6]_INST_0_i_2_n_0\,
      O => \wrap_burst_total_reg[0]_i_2_n_0\
    );
\wrap_burst_total_reg[0]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => s_axi_arlen(2),
      I1 => \^gen_rd_cmd_opt.gen_rdaddr_sm_norl.rd_cmd_reg_reg\,
      I2 => s_axi_arlen(3),
      I3 => s_axi_arlen(1),
      O => \wrap_burst_total_reg[0]_i_3_n_0\
    );
\wrap_burst_total_reg_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => wrap_burst_total(0),
      Q => wrap_burst_total_reg(0),
      R => \^sr\(0)
    );
\wrap_burst_total_reg_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => wrap_burst_total(1),
      Q => wrap_burst_total_reg(1),
      R => \^sr\(0)
    );
\wrap_burst_total_reg_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => wrap_burst_total(2),
      Q => wrap_burst_total_reg(2),
      R => \^sr\(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axi64_bram_ctrl_64KiB_rd_chnl is
  port (
    \GEN_RD_CMD_OPT.axi_rvalid_int_reg_0\ : out STD_LOGIC;
    s_axi_aresetn_0 : out STD_LOGIC;
    axi_arready_1st_addr : out STD_LOGIC;
    \GEN_RD_CMD_OPT.wrap_addr_assign_reg_0\ : out STD_LOGIC;
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[9]_0\ : out STD_LOGIC;
    \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8]_0\ : out STD_LOGIC;
    bram_addr_b : out STD_LOGIC_VECTOR ( 9 downto 0 );
    bram_en_b : out STD_LOGIC;
    s_axi_rlast : out STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rid : out STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_aclk : in STD_LOGIC;
    \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_reg_0\ : in STD_LOGIC;
    \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.axi_arready_1st_addr_reg_0\ : in STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 12 downto 0 );
    s_axi_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_aresetn : in STD_LOGIC;
    \wrap_burst_total_reg_reg[2]\ : in STD_LOGIC;
    s_axi_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_arid : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    axi_aresetn_d3 : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of axi64_bram_ctrl_64KiB_rd_chnl : entity is "rd_chnl";
end axi64_bram_ctrl_64KiB_rd_chnl;

architecture STRUCTURE of axi64_bram_ctrl_64KiB_rd_chnl is
  signal \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_1_n_0\ : STD_LOGIC;
  signal \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_2_n_0\ : STD_LOGIC;
  signal \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_3_n_0\ : STD_LOGIC;
  signal \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_2_n_0\ : STD_LOGIC;
  signal \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_3_n_0\ : STD_LOGIC;
  signal \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_4_n_0\ : STD_LOGIC;
  signal \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_5_n_0\ : STD_LOGIC;
  signal \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_2_n_0\ : STD_LOGIC;
  signal \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_3_n_0\ : STD_LOGIC;
  signal \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_4_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_i_1_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[15]_i_1_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[15]_i_2_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[3]_i_1_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[3]_i_2_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[7]_i_3_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[7]_i_4_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.I_WRAP_BRST_n_10\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.I_WRAP_BRST_n_11\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.I_WRAP_BRST_n_12\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.I_WRAP_BRST_n_22\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.I_WRAP_BRST_n_23\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.I_WRAP_BRST_n_24\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.I_WRAP_BRST_n_26\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.I_WRAP_BRST_n_5\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.I_WRAP_BRST_n_6\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.I_WRAP_BRST_n_7\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.I_WRAP_BRST_n_8\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.I_WRAP_BRST_n_9\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.arburst_reg[0]_i_1_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.arburst_reg[1]_i_1_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.arsize_reg[0]_i_1_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.arsize_reg[1]_i_1_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.axi_rlast_cmb_reg_i_1_n_0\ : STD_LOGIC;
  signal \^gen_rd_cmd_opt.axi_rvalid_int_reg_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.brst_cnt_addr[0]_i_1_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.brst_cnt_addr[1]_i_1_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.brst_cnt_addr[2]_i_1_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.brst_cnt_addr[3]_i_1_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.brst_cnt_addr[4]_i_1_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.brst_cnt_addr[4]_i_2_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.brst_cnt_addr[5]_i_1_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.brst_cnt_addr[6]_i_1_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_1_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_2_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_3_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.brst_cnt_data[4]_i_2_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.brst_cnt_data[7]_i_1_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.brst_cnt_data[7]_i_3_n_0\ : STD_LOGIC;
  signal \GEN_RD_CMD_OPT.wrap_addr_assign_i_3_n_0\ : STD_LOGIC;
  signal addr_vld_rdy5_out : STD_LOGIC;
  signal arburst_reg : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal arid_reg : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal arid_temp : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal arlen_reg : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal arlen_temp : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal arsize_reg : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \^axi_arready_1st_addr\ : STD_LOGIC;
  signal axi_rlast_cmb_reg : STD_LOGIC;
  signal axi_rvalid_cmb : STD_LOGIC;
  signal \^bram_addr_b\ : STD_LOGIC_VECTOR ( 9 downto 0 );
  signal \bram_addr_b[4]_INST_0_i_3_n_0\ : STD_LOGIC;
  signal \bram_addr_b[5]_INST_0_i_1_n_0\ : STD_LOGIC;
  signal \bram_addr_b[5]_INST_0_i_3_n_0\ : STD_LOGIC;
  signal \bram_addr_b[5]_INST_0_i_8_n_0\ : STD_LOGIC;
  signal bram_addr_int : STD_LOGIC_VECTOR ( 15 downto 3 );
  signal \^bram_en_b\ : STD_LOGIC;
  signal brst_cnt_addr : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal brst_cnt_data : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal p_2_in : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal rd_active : STD_LOGIC;
  signal rd_active_int2_out : STD_LOGIC;
  signal rd_addr_sm_cs : STD_LOGIC;
  signal rd_cmd_reg : STD_LOGIC;
  signal rd_data_sm_cs : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal \^s_axi_aresetn_0\ : STD_LOGIC;
  signal s_axi_arready_INST_0_i_1_n_0 : STD_LOGIC;
  signal s_axi_arready_INST_0_i_2_n_0 : STD_LOGIC;
  signal wrap_addr_assign : STD_LOGIC;
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_reg\ : label is "next_addr:1,idle:0";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_3\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_5\ : label is "soft_lutpair14";
  attribute FSM_ENCODED_STATES of \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs_reg[0]\ : label is "last_data:10,read_data_one:01,idle:00";
  attribute FSM_ENCODED_STATES of \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs_reg[1]\ : label is "last_data:10,read_data_one:01,idle:00";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_i_1\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[15]_i_2\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[3]_i_2\ : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[7]_i_3\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[7]_i_4\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.arburst_reg[0]_i_1\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.arburst_reg[1]_i_1\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.arlen_reg[0]_i_1\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.arlen_reg[1]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.arlen_reg[2]_i_1\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.arlen_reg[3]_i_1\ : label is "soft_lutpair31";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.arlen_reg[4]_i_1\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.arlen_reg[5]_i_1\ : label is "soft_lutpair25";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.arlen_reg[6]_i_1\ : label is "soft_lutpair31";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.arlen_reg[7]_i_1\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.arsize_reg[0]_i_1\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.arsize_reg[1]_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.axi_rid_int[0]_i_1\ : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.axi_rid_int[1]_i_1\ : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.axi_rid_int[2]_i_1\ : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.axi_rid_int[3]_i_2\ : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.brst_cnt_addr[0]_i_1\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.brst_cnt_addr[1]_i_1\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.brst_cnt_addr[4]_i_2\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_3\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.brst_cnt_data[0]_i_1\ : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.brst_cnt_data[1]_i_1\ : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.brst_cnt_data[4]_i_2\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.brst_cnt_data[5]_i_1\ : label is "soft_lutpair25";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.brst_cnt_data[7]_i_3\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \bram_addr_b[3]_INST_0\ : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of \bram_addr_b[4]_INST_0_i_3\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \bram_addr_b[5]_INST_0_i_1\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of bram_en_b_INST_0 : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of s_axi_arready_INST_0 : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of s_axi_arready_INST_0_i_2 : label is "soft_lutpair24";
begin
  \GEN_RD_CMD_OPT.axi_rvalid_int_reg_0\ <= \^gen_rd_cmd_opt.axi_rvalid_int_reg_0\;
  axi_arready_1st_addr <= \^axi_arready_1st_addr\;
  bram_addr_b(9 downto 0) <= \^bram_addr_b\(9 downto 0);
  bram_en_b <= \^bram_en_b\;
  s_axi_aresetn_0 <= \^s_axi_aresetn_0\;
\FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0FFFFFF22222222"
    )
        port map (
      I0 => \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_2_n_0\,
      I1 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I2 => \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_2_n_0\,
      I3 => \^gen_rd_cmd_opt.axi_rvalid_int_reg_0\,
      I4 => s_axi_rready,
      I5 => rd_addr_sm_cs,
      O => \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_1_n_0\
    );
\FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFFFB"
    )
        port map (
      I0 => brst_cnt_addr(3),
      I1 => brst_cnt_addr(0),
      I2 => brst_cnt_addr(4),
      I3 => brst_cnt_addr(7),
      I4 => \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_3_n_0\,
      O => \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_2_n_0\
    );
\FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => brst_cnt_addr(6),
      I1 => brst_cnt_addr(5),
      I2 => brst_cnt_addr(1),
      I3 => brst_cnt_addr(2),
      O => \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_3_n_0\
    );
\FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_reg\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_i_1_n_0\,
      Q => rd_addr_sm_cs,
      R => \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_reg_0\
    );
\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FF550C0C"
    )
        port map (
      I0 => \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_3_n_0\,
      I1 => \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_2_n_0\,
      I2 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I3 => rd_data_sm_cs(1),
      I4 => rd_data_sm_cs(0),
      O => \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_1_n_0\
    );
\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFFFFEEEFE"
    )
        port map (
      I0 => \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_3_n_0\,
      I1 => arlen_temp(5),
      I2 => s_axi_arlen(2),
      I3 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I4 => arlen_reg(2),
      I5 => \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_4_n_0\,
      O => \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_2_n_0\
    );
\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFACCFA"
    )
        port map (
      I0 => s_axi_arlen(7),
      I1 => arlen_reg(7),
      I2 => s_axi_arlen(6),
      I3 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I4 => arlen_reg(6),
      O => \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_3_n_0\
    );
\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFEFEFFFFAEFEA"
    )
        port map (
      I0 => \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_5_n_0\,
      I1 => arlen_reg(4),
      I2 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I3 => s_axi_arlen(4),
      I4 => arlen_reg(0),
      I5 => s_axi_arlen(0),
      O => \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_4_n_0\
    );
\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFACCFA"
    )
        port map (
      I0 => s_axi_arlen(1),
      I1 => arlen_reg(1),
      I2 => s_axi_arlen(3),
      I3 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I4 => arlen_reg(3),
      O => \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_5_n_0\
    );
\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FA00FAC0FAC0FAC0"
    )
        port map (
      I0 => \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_3_n_0\,
      I1 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I2 => rd_data_sm_cs(1),
      I3 => rd_data_sm_cs(0),
      I4 => s_axi_rready,
      I5 => \^gen_rd_cmd_opt.axi_rvalid_int_reg_0\,
      O => \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_2_n_0\
    );
\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000001"
    )
        port map (
      I0 => brst_cnt_data(2),
      I1 => brst_cnt_data(4),
      I2 => brst_cnt_data(3),
      I3 => brst_cnt_data(7),
      I4 => \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_4_n_0\,
      O => \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_3_n_0\
    );
\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFDFFFFFFFFFFFF"
    )
        port map (
      I0 => brst_cnt_data(0),
      I1 => brst_cnt_data(1),
      I2 => brst_cnt_data(5),
      I3 => brst_cnt_data(6),
      I4 => s_axi_rready,
      I5 => \^gen_rd_cmd_opt.axi_rvalid_int_reg_0\,
      O => \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_4_n_0\
    );
\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_1_n_0\,
      Q => rd_data_sm_cs(0),
      R => \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_reg_0\
    );
\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_2_n_0\,
      Q => rd_data_sm_cs(1),
      R => \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_reg_0\
    );
\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.axi_arready_1st_addr_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.axi_arready_1st_addr_reg_0\,
      Q => \^axi_arready_1st_addr\,
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_active_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"55F755F755F70000"
    )
        port map (
      I0 => s_axi_arready_INST_0_i_2_n_0,
      I1 => rd_data_sm_cs(1),
      I2 => rd_data_sm_cs(0),
      I3 => axi_rlast_cmb_reg,
      I4 => rd_active,
      I5 => rd_cmd_reg,
      O => rd_active_int2_out
    );
\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_active_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => rd_active_int2_out,
      Q => rd_active,
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"88FF8880"
    )
        port map (
      I0 => axi_aresetn_d3,
      I1 => s_axi_arvalid,
      I2 => \^axi_arready_1st_addr\,
      I3 => s_axi_arready_INST_0_i_1_n_0,
      I4 => rd_cmd_reg,
      O => \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_i_1_n_0\
    );
\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_i_1_n_0\,
      Q => rd_cmd_reg,
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFF0F0F0F4F4F4F4"
    )
        port map (
      I0 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I1 => \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_2_n_0\,
      I2 => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[15]_i_2_n_0\,
      I3 => \^gen_rd_cmd_opt.axi_rvalid_int_reg_0\,
      I4 => s_axi_rready,
      I5 => rd_addr_sm_cs,
      O => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[15]_i_1_n_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[15]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00053305"
    )
        port map (
      I0 => s_axi_arburst(0),
      I1 => arburst_reg(0),
      I2 => s_axi_arburst(1),
      I3 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I4 => arburst_reg(1),
      O => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[15]_i_2_n_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAA9A9AAAA59A95"
    )
        port map (
      I0 => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[3]_i_2_n_0\,
      I1 => arburst_reg(1),
      I2 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I3 => s_axi_arburst(1),
      I4 => arburst_reg(0),
      I5 => s_axi_arburst(0),
      O => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[3]_i_1_n_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[3]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B0BF"
    )
        port map (
      I0 => wrap_addr_assign,
      I1 => bram_addr_int(3),
      I2 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I3 => s_axi_araddr(0),
      O => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[3]_i_2_n_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[7]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B0BF"
    )
        port map (
      I0 => wrap_addr_assign,
      I1 => bram_addr_int(6),
      I2 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I3 => s_axi_araddr(3),
      O => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[7]_i_3_n_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[7]_i_4\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => wrap_addr_assign,
      I1 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      O => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[7]_i_4_n_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[15]_i_1_n_0\,
      D => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_6\,
      Q => bram_addr_int(10),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[15]_i_1_n_0\,
      D => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_5\,
      Q => bram_addr_int(11),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[15]_i_1_n_0\,
      D => \^bram_addr_b\(6),
      Q => bram_addr_int(12),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[15]_i_1_n_0\,
      D => \^bram_addr_b\(7),
      Q => bram_addr_int(13),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[15]_i_1_n_0\,
      D => \^bram_addr_b\(8),
      Q => bram_addr_int(14),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[15]_i_1_n_0\,
      D => \^bram_addr_b\(9),
      Q => bram_addr_int(15),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[15]_i_1_n_0\,
      D => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[3]_i_1_n_0\,
      Q => bram_addr_int(3),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[15]_i_1_n_0\,
      D => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_12\,
      Q => bram_addr_int(4),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[15]_i_1_n_0\,
      D => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_11\,
      Q => bram_addr_int(5),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[15]_i_1_n_0\,
      D => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_10\,
      Q => bram_addr_int(6),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[15]_i_1_n_0\,
      D => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_9\,
      Q => bram_addr_int(7),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[15]_i_1_n_0\,
      D => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_8\,
      Q => bram_addr_int(8),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[15]_i_1_n_0\,
      D => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_7\,
      Q => bram_addr_int(9),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.I_WRAP_BRST\: entity work.axi64_bram_ctrl_64KiB_wrap_brst_rd
     port map (
      D(11 downto 8) => \^bram_addr_b\(9 downto 6),
      D(7) => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_5\,
      D(6) => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_6\,
      D(5) => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_7\,
      D(4) => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_8\,
      D(3) => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_9\,
      D(2) => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_10\,
      D(1) => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_11\,
      D(0) => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_12\,
      \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_active_reg\ => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_23\,
      \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.rd_cmd_reg_reg\ => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[4]\ => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[15]_i_2_n_0\,
      \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7]\ => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[7]_i_3_n_0\,
      \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[7]_0\ => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[7]_i_4_n_0\,
      \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8]\ => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8]_0\,
      \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8]_0\ => \^axi_arready_1st_addr\,
      \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[9]\ => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[9]_0\,
      \GEN_RD_CMD_OPT.arlen_reg_reg[3]\ => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_22\,
      \GEN_RD_CMD_OPT.axi_rvalid_int_reg\ => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_24\,
      \GEN_RD_CMD_OPT.wrap_addr_assign_reg\ => \GEN_RD_CMD_OPT.wrap_addr_assign_reg_0\,
      \GEN_RD_CMD_OPT.wrap_addr_assign_reg_0\ => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_26\,
      \GEN_RD_CMD_OPT.wrap_addr_assign_reg_1\ => \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int[3]_i_2_n_0\,
      \GEN_RD_CMD_OPT.wrap_addr_assign_reg_2\ => \GEN_RD_CMD_OPT.wrap_addr_assign_i_3_n_0\,
      Q(10 downto 1) => bram_addr_int(15 downto 6),
      Q(0) => bram_addr_int(3),
      SR(0) => \^s_axi_aresetn_0\,
      addr_vld_rdy5_out => addr_vld_rdy5_out,
      axi_aresetn_d3 => axi_aresetn_d3,
      axi_rlast_cmb_reg => axi_rlast_cmb_reg,
      bram_addr_b(4 downto 0) => \^bram_addr_b\(5 downto 1),
      \bram_addr_b[5]\ => \bram_addr_b[5]_INST_0_i_3_n_0\,
      \bram_addr_b[5]_0\ => \bram_addr_b[5]_INST_0_i_1_n_0\,
      \bram_addr_b[5]_1\ => \bram_addr_b[5]_INST_0_i_8_n_0\,
      \bram_addr_b[5]_2\(0) => arsize_reg(0),
      \bram_addr_b[5]_INST_0_i_8\ => \^gen_rd_cmd_opt.axi_rvalid_int_reg_0\,
      bram_addr_b_4_sp_1 => \bram_addr_b[4]_INST_0_i_3_n_0\,
      bram_en_b => \^bram_en_b\,
      rd_active => rd_active,
      rd_cmd_reg => rd_cmd_reg,
      rd_data_sm_cs(1 downto 0) => rd_data_sm_cs(1 downto 0),
      s_axi_aclk => s_axi_aclk,
      s_axi_araddr(12 downto 0) => s_axi_araddr(12 downto 0),
      s_axi_aresetn => s_axi_aresetn,
      s_axi_arlen(3 downto 0) => s_axi_arlen(3 downto 0),
      s_axi_arvalid => s_axi_arvalid,
      s_axi_rready => s_axi_rready,
      wrap_addr_assign => wrap_addr_assign,
      \wrap_burst_total_reg_reg[2]_0\(1 downto 0) => arlen_reg(3 downto 2),
      \wrap_burst_total_reg_reg[2]_1\ => \wrap_burst_total_reg_reg[2]\
    );
\GEN_RD_CMD_OPT.arburst_reg[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => arburst_reg(0),
      I1 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I2 => s_axi_arburst(0),
      O => \GEN_RD_CMD_OPT.arburst_reg[0]_i_1_n_0\
    );
\GEN_RD_CMD_OPT.arburst_reg[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => arburst_reg(1),
      I1 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I2 => s_axi_arburst(1),
      O => \GEN_RD_CMD_OPT.arburst_reg[1]_i_1_n_0\
    );
\GEN_RD_CMD_OPT.arburst_reg_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \GEN_RD_CMD_OPT.arburst_reg[0]_i_1_n_0\,
      Q => arburst_reg(0),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.arburst_reg_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \GEN_RD_CMD_OPT.arburst_reg[1]_i_1_n_0\,
      Q => arburst_reg(1),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.arid_reg_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => addr_vld_rdy5_out,
      D => s_axi_arid(0),
      Q => arid_reg(0),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.arid_reg_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => addr_vld_rdy5_out,
      D => s_axi_arid(1),
      Q => arid_reg(1),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.arid_reg_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => addr_vld_rdy5_out,
      D => s_axi_arid(2),
      Q => arid_reg(2),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.arid_reg_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => addr_vld_rdy5_out,
      D => s_axi_arid(3),
      Q => arid_reg(3),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.arlen_reg[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => arlen_reg(0),
      I1 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I2 => s_axi_arlen(0),
      O => arlen_temp(0)
    );
\GEN_RD_CMD_OPT.arlen_reg[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => arlen_reg(1),
      I1 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I2 => s_axi_arlen(1),
      O => arlen_temp(1)
    );
\GEN_RD_CMD_OPT.arlen_reg[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E2"
    )
        port map (
      I0 => s_axi_arlen(2),
      I1 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I2 => arlen_reg(2),
      O => arlen_temp(2)
    );
\GEN_RD_CMD_OPT.arlen_reg[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E2"
    )
        port map (
      I0 => s_axi_arlen(3),
      I1 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I2 => arlen_reg(3),
      O => arlen_temp(3)
    );
\GEN_RD_CMD_OPT.arlen_reg[4]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => arlen_reg(4),
      I1 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I2 => s_axi_arlen(4),
      O => arlen_temp(4)
    );
\GEN_RD_CMD_OPT.arlen_reg[5]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => arlen_reg(5),
      I1 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I2 => s_axi_arlen(5),
      O => arlen_temp(5)
    );
\GEN_RD_CMD_OPT.arlen_reg[6]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => arlen_reg(6),
      I1 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I2 => s_axi_arlen(6),
      O => arlen_temp(6)
    );
\GEN_RD_CMD_OPT.arlen_reg[7]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => arlen_reg(7),
      I1 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I2 => s_axi_arlen(7),
      O => arlen_temp(7)
    );
\GEN_RD_CMD_OPT.arlen_reg_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => arlen_temp(0),
      Q => arlen_reg(0),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.arlen_reg_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => arlen_temp(1),
      Q => arlen_reg(1),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.arlen_reg_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => arlen_temp(2),
      Q => arlen_reg(2),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.arlen_reg_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => arlen_temp(3),
      Q => arlen_reg(3),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.arlen_reg_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => arlen_temp(4),
      Q => arlen_reg(4),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.arlen_reg_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => arlen_temp(5),
      Q => arlen_reg(5),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.arlen_reg_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => arlen_temp(6),
      Q => arlen_reg(6),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.arlen_reg_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => arlen_temp(7),
      Q => arlen_reg(7),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.arsize_reg[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => arsize_reg(0),
      I1 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      O => \GEN_RD_CMD_OPT.arsize_reg[0]_i_1_n_0\
    );
\GEN_RD_CMD_OPT.arsize_reg[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => arsize_reg(1),
      I1 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      O => \GEN_RD_CMD_OPT.arsize_reg[1]_i_1_n_0\
    );
\GEN_RD_CMD_OPT.arsize_reg_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \GEN_RD_CMD_OPT.arsize_reg[0]_i_1_n_0\,
      Q => arsize_reg(0),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.arsize_reg_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \GEN_RD_CMD_OPT.arsize_reg[1]_i_1_n_0\,
      Q => arsize_reg(1),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.axi_rid_int[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => arid_reg(0),
      I1 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I2 => s_axi_arid(0),
      O => arid_temp(0)
    );
\GEN_RD_CMD_OPT.axi_rid_int[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => arid_reg(1),
      I1 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I2 => s_axi_arid(1),
      O => arid_temp(1)
    );
\GEN_RD_CMD_OPT.axi_rid_int[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => arid_reg(2),
      I1 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I2 => s_axi_arid(2),
      O => arid_temp(2)
    );
\GEN_RD_CMD_OPT.axi_rid_int[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"33335F55"
    )
        port map (
      I0 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I1 => rd_data_sm_cs(1),
      I2 => s_axi_rready,
      I3 => \^gen_rd_cmd_opt.axi_rvalid_int_reg_0\,
      I4 => rd_data_sm_cs(0),
      O => axi_rvalid_cmb
    );
\GEN_RD_CMD_OPT.axi_rid_int[3]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => arid_reg(3),
      I1 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I2 => s_axi_arid(3),
      O => arid_temp(3)
    );
\GEN_RD_CMD_OPT.axi_rid_int_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => axi_rvalid_cmb,
      D => arid_temp(0),
      Q => s_axi_rid(0),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.axi_rid_int_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => axi_rvalid_cmb,
      D => arid_temp(1),
      Q => s_axi_rid(1),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.axi_rid_int_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => axi_rvalid_cmb,
      D => arid_temp(2),
      Q => s_axi_rid(2),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.axi_rid_int_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => axi_rvalid_cmb,
      D => arid_temp(3),
      Q => s_axi_rid(3),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.axi_rlast_cmb_reg_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CFFFDDDD00001111"
    )
        port map (
      I0 => \FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[0]_i_2_n_0\,
      I1 => rd_data_sm_cs(0),
      I2 => s_axi_rready,
      I3 => \^gen_rd_cmd_opt.axi_rvalid_int_reg_0\,
      I4 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I5 => axi_rlast_cmb_reg,
      O => \GEN_RD_CMD_OPT.axi_rlast_cmb_reg_i_1_n_0\
    );
\GEN_RD_CMD_OPT.axi_rlast_cmb_reg_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \GEN_RD_CMD_OPT.axi_rlast_cmb_reg_i_1_n_0\,
      Q => axi_rlast_cmb_reg,
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.axi_rvalid_int_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => axi_rvalid_cmb,
      Q => \^gen_rd_cmd_opt.axi_rvalid_int_reg_0\,
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_addr[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"74"
    )
        port map (
      I0 => brst_cnt_addr(0),
      I1 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I2 => s_axi_arlen(0),
      O => \GEN_RD_CMD_OPT.brst_cnt_addr[0]_i_1_n_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_addr[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9F90"
    )
        port map (
      I0 => brst_cnt_addr(1),
      I1 => brst_cnt_addr(0),
      I2 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I3 => s_axi_arlen(1),
      O => \GEN_RD_CMD_OPT.brst_cnt_addr[1]_i_1_n_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_addr[2]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A9FFA900"
    )
        port map (
      I0 => brst_cnt_addr(2),
      I1 => brst_cnt_addr(0),
      I2 => brst_cnt_addr(1),
      I3 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I4 => s_axi_arlen(2),
      O => \GEN_RD_CMD_OPT.brst_cnt_addr[2]_i_1_n_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_addr[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAA9FFFFAAA90000"
    )
        port map (
      I0 => brst_cnt_addr(3),
      I1 => brst_cnt_addr(2),
      I2 => brst_cnt_addr(1),
      I3 => brst_cnt_addr(0),
      I4 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I5 => s_axi_arlen(3),
      O => \GEN_RD_CMD_OPT.brst_cnt_addr[3]_i_1_n_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_addr[4]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6F60"
    )
        port map (
      I0 => brst_cnt_addr(4),
      I1 => \GEN_RD_CMD_OPT.brst_cnt_addr[4]_i_2_n_0\,
      I2 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I3 => s_axi_arlen(4),
      O => \GEN_RD_CMD_OPT.brst_cnt_addr[4]_i_1_n_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_addr[4]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => brst_cnt_addr(2),
      I1 => brst_cnt_addr(1),
      I2 => brst_cnt_addr(0),
      I3 => brst_cnt_addr(3),
      O => \GEN_RD_CMD_OPT.brst_cnt_addr[4]_i_2_n_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_addr[5]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6F60"
    )
        port map (
      I0 => brst_cnt_addr(5),
      I1 => \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_3_n_0\,
      I2 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I3 => s_axi_arlen(5),
      O => \GEN_RD_CMD_OPT.brst_cnt_addr[5]_i_1_n_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_addr[6]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"9AFF9A00"
    )
        port map (
      I0 => brst_cnt_addr(6),
      I1 => brst_cnt_addr(5),
      I2 => \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_3_n_0\,
      I3 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I4 => s_axi_arlen(6),
      O => \GEN_RD_CMD_OPT.brst_cnt_addr[6]_i_1_n_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"80FF"
    )
        port map (
      I0 => rd_addr_sm_cs,
      I1 => s_axi_rready,
      I2 => \^gen_rd_cmd_opt.axi_rvalid_int_reg_0\,
      I3 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      O => \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_1_n_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A9AAFFFFA9AA0000"
    )
        port map (
      I0 => brst_cnt_addr(7),
      I1 => brst_cnt_addr(5),
      I2 => brst_cnt_addr(6),
      I3 => \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_3_n_0\,
      I4 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I5 => s_axi_arlen(7),
      O => \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_2_n_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000001"
    )
        port map (
      I0 => brst_cnt_addr(3),
      I1 => brst_cnt_addr(0),
      I2 => brst_cnt_addr(1),
      I3 => brst_cnt_addr(2),
      I4 => brst_cnt_addr(4),
      O => \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_3_n_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_addr_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_1_n_0\,
      D => \GEN_RD_CMD_OPT.brst_cnt_addr[0]_i_1_n_0\,
      Q => brst_cnt_addr(0),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_addr_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_1_n_0\,
      D => \GEN_RD_CMD_OPT.brst_cnt_addr[1]_i_1_n_0\,
      Q => brst_cnt_addr(1),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_addr_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_1_n_0\,
      D => \GEN_RD_CMD_OPT.brst_cnt_addr[2]_i_1_n_0\,
      Q => brst_cnt_addr(2),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_addr_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_1_n_0\,
      D => \GEN_RD_CMD_OPT.brst_cnt_addr[3]_i_1_n_0\,
      Q => brst_cnt_addr(3),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_addr_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_1_n_0\,
      D => \GEN_RD_CMD_OPT.brst_cnt_addr[4]_i_1_n_0\,
      Q => brst_cnt_addr(4),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_addr_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_1_n_0\,
      D => \GEN_RD_CMD_OPT.brst_cnt_addr[5]_i_1_n_0\,
      Q => brst_cnt_addr(5),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_addr_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_1_n_0\,
      D => \GEN_RD_CMD_OPT.brst_cnt_addr[6]_i_1_n_0\,
      Q => brst_cnt_addr(6),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_addr_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_1_n_0\,
      D => \GEN_RD_CMD_OPT.brst_cnt_addr[7]_i_2_n_0\,
      Q => brst_cnt_addr(7),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_data[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"74"
    )
        port map (
      I0 => brst_cnt_data(0),
      I1 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I2 => s_axi_arlen(0),
      O => p_2_in(0)
    );
\GEN_RD_CMD_OPT.brst_cnt_data[1]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9F90"
    )
        port map (
      I0 => brst_cnt_data(1),
      I1 => brst_cnt_data(0),
      I2 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I3 => s_axi_arlen(1),
      O => p_2_in(1)
    );
\GEN_RD_CMD_OPT.brst_cnt_data[2]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"A9FFA900"
    )
        port map (
      I0 => brst_cnt_data(2),
      I1 => brst_cnt_data(0),
      I2 => brst_cnt_data(1),
      I3 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I4 => s_axi_arlen(2),
      O => p_2_in(2)
    );
\GEN_RD_CMD_OPT.brst_cnt_data[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAA9FFFFAAA90000"
    )
        port map (
      I0 => brst_cnt_data(3),
      I1 => brst_cnt_data(2),
      I2 => brst_cnt_data(1),
      I3 => brst_cnt_data(0),
      I4 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I5 => s_axi_arlen(3),
      O => p_2_in(3)
    );
\GEN_RD_CMD_OPT.brst_cnt_data[4]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9F90"
    )
        port map (
      I0 => brst_cnt_data(4),
      I1 => \GEN_RD_CMD_OPT.brst_cnt_data[4]_i_2_n_0\,
      I2 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I3 => s_axi_arlen(4),
      O => p_2_in(4)
    );
\GEN_RD_CMD_OPT.brst_cnt_data[4]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFE"
    )
        port map (
      I0 => brst_cnt_data(3),
      I1 => brst_cnt_data(2),
      I2 => brst_cnt_data(1),
      I3 => brst_cnt_data(0),
      O => \GEN_RD_CMD_OPT.brst_cnt_data[4]_i_2_n_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_data[5]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"6F60"
    )
        port map (
      I0 => brst_cnt_data(5),
      I1 => \GEN_RD_CMD_OPT.brst_cnt_data[7]_i_3_n_0\,
      I2 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I3 => s_axi_arlen(5),
      O => p_2_in(5)
    );
\GEN_RD_CMD_OPT.brst_cnt_data[6]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"9AFF9A00"
    )
        port map (
      I0 => brst_cnt_data(6),
      I1 => brst_cnt_data(5),
      I2 => \GEN_RD_CMD_OPT.brst_cnt_data[7]_i_3_n_0\,
      I3 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I4 => s_axi_arlen(6),
      O => p_2_in(6)
    );
\GEN_RD_CMD_OPT.brst_cnt_data[7]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"2000FFFF"
    )
        port map (
      I0 => rd_data_sm_cs(0),
      I1 => rd_data_sm_cs(1),
      I2 => s_axi_rready,
      I3 => \^gen_rd_cmd_opt.axi_rvalid_int_reg_0\,
      I4 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      O => \GEN_RD_CMD_OPT.brst_cnt_data[7]_i_1_n_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_data[7]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAA6FFFFAAA60000"
    )
        port map (
      I0 => brst_cnt_data(7),
      I1 => \GEN_RD_CMD_OPT.brst_cnt_data[7]_i_3_n_0\,
      I2 => brst_cnt_data(5),
      I3 => brst_cnt_data(6),
      I4 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I5 => s_axi_arlen(7),
      O => p_2_in(7)
    );
\GEN_RD_CMD_OPT.brst_cnt_data[7]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000001"
    )
        port map (
      I0 => brst_cnt_data(4),
      I1 => brst_cnt_data(0),
      I2 => brst_cnt_data(1),
      I3 => brst_cnt_data(2),
      I4 => brst_cnt_data(3),
      O => \GEN_RD_CMD_OPT.brst_cnt_data[7]_i_3_n_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_data_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.brst_cnt_data[7]_i_1_n_0\,
      D => p_2_in(0),
      Q => brst_cnt_data(0),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_data_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.brst_cnt_data[7]_i_1_n_0\,
      D => p_2_in(1),
      Q => brst_cnt_data(1),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_data_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.brst_cnt_data[7]_i_1_n_0\,
      D => p_2_in(2),
      Q => brst_cnt_data(2),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_data_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.brst_cnt_data[7]_i_1_n_0\,
      D => p_2_in(3),
      Q => brst_cnt_data(3),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_data_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.brst_cnt_data[7]_i_1_n_0\,
      D => p_2_in(4),
      Q => brst_cnt_data(4),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_data_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.brst_cnt_data[7]_i_1_n_0\,
      D => p_2_in(5),
      Q => brst_cnt_data(5),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_data_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.brst_cnt_data[7]_i_1_n_0\,
      D => p_2_in(6),
      Q => brst_cnt_data(6),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.brst_cnt_data_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => \GEN_RD_CMD_OPT.brst_cnt_data[7]_i_1_n_0\,
      D => p_2_in(7),
      Q => brst_cnt_data(7),
      R => \^s_axi_aresetn_0\
    );
\GEN_RD_CMD_OPT.wrap_addr_assign_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF7FFFFFFF7F0F0F"
    )
        port map (
      I0 => arsize_reg(1),
      I1 => arsize_reg(0),
      I2 => \GEN_RD_CMD_OPT.arburst_reg[1]_i_1_n_0\,
      I3 => arburst_reg(0),
      I4 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I5 => s_axi_arburst(0),
      O => \GEN_RD_CMD_OPT.wrap_addr_assign_i_3_n_0\
    );
\GEN_RD_CMD_OPT.wrap_addr_assign_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_26\,
      Q => wrap_addr_assign,
      R => \^s_axi_aresetn_0\
    );
\bram_addr_b[3]_INST_0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"22E2"
    )
        port map (
      I0 => s_axi_araddr(0),
      I1 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I2 => bram_addr_int(3),
      I3 => wrap_addr_assign,
      O => \^bram_addr_b\(0)
    );
\bram_addr_b[4]_INST_0_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4F40"
    )
        port map (
      I0 => wrap_addr_assign,
      I1 => bram_addr_int(4),
      I2 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I3 => s_axi_araddr(1),
      O => \bram_addr_b[4]_INST_0_i_3_n_0\
    );
\bram_addr_b[5]_INST_0_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4F40"
    )
        port map (
      I0 => wrap_addr_assign,
      I1 => bram_addr_int(5),
      I2 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I3 => s_axi_araddr(2),
      O => \bram_addr_b[5]_INST_0_i_1_n_0\
    );
\bram_addr_b[5]_INST_0_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFFFDFF"
    )
        port map (
      I0 => s_axi_arlen(0),
      I1 => s_axi_arlen(1),
      I2 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I3 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_22\,
      I4 => s_axi_arlen(2),
      O => \bram_addr_b[5]_INST_0_i_3_n_0\
    );
\bram_addr_b[5]_INST_0_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF5557FFFFFFFF"
    )
        port map (
      I0 => s_axi_arlen(1),
      I1 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_23\,
      I2 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_24\,
      I3 => \^axi_arready_1st_addr\,
      I4 => \wrap_burst_total_reg_reg[2]\,
      I5 => s_axi_arlen(0),
      O => \bram_addr_b[5]_INST_0_i_8_n_0\
    );
bram_en_b_INST_0: unisim.vcomponents.LUT4
    generic map(
      INIT => X"880F"
    )
        port map (
      I0 => s_axi_rready,
      I1 => \^gen_rd_cmd_opt.axi_rvalid_int_reg_0\,
      I2 => \GEN_RD_CMD_OPT.I_WRAP_BRST_n_0\,
      I3 => rd_addr_sm_cs,
      O => \^bram_en_b\
    );
s_axi_arready_INST_0: unisim.vcomponents.LUT3
    generic map(
      INIT => X"A8"
    )
        port map (
      I0 => axi_aresetn_d3,
      I1 => s_axi_arready_INST_0_i_1_n_0,
      I2 => \^axi_arready_1st_addr\,
      O => s_axi_arready
    );
s_axi_arready_INST_0_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F1FFF1F111111111"
    )
        port map (
      I0 => rd_cmd_reg,
      I1 => rd_active,
      I2 => axi_rlast_cmb_reg,
      I3 => rd_data_sm_cs(0),
      I4 => rd_data_sm_cs(1),
      I5 => s_axi_arready_INST_0_i_2_n_0,
      O => s_axi_arready_INST_0_i_1_n_0
    );
s_axi_arready_INST_0_i_2: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => s_axi_rready,
      I1 => \^gen_rd_cmd_opt.axi_rvalid_int_reg_0\,
      O => s_axi_arready_INST_0_i_2_n_0
    );
s_axi_rlast_INST_0: unisim.vcomponents.LUT3
    generic map(
      INIT => X"F2"
    )
        port map (
      I0 => rd_data_sm_cs(1),
      I1 => rd_data_sm_cs(0),
      I2 => axi_rlast_cmb_reg,
      O => s_axi_rlast
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axi64_bram_ctrl_64KiB_wr_chnl is
  port (
    axi_aresetn_d3 : out STD_LOGIC;
    bram_en_a : out STD_LOGIC;
    bram_wrdata_a : out STD_LOGIC_VECTOR ( 63 downto 0 );
    axi_bvalid_int_reg_0 : out STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    \GEN_AWREADY.axi_aresetn_d3_reg_0\ : out STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 12 downto 0 );
    \GEN_AWREADY.axi_aresetn_d3_reg_1\ : out STD_LOGIC;
    s_axi_arvalid_0 : out STD_LOGIC;
    s_axi_bid : out STD_LOGIC_VECTOR ( 3 downto 0 );
    bram_we_a : out STD_LOGIC_VECTOR ( 7 downto 0 );
    \wrap_burst_total_reg[0]\ : in STD_LOGIC;
    s_axi_aclk : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 12 downto 0 );
    s_axi_aresetn : in STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wlast : in STD_LOGIC;
    s_axi_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awid : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_bready : in STD_LOGIC;
    s_axi_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    axi_arready_1st_addr : in STD_LOGIC;
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of axi64_bram_ctrl_64KiB_wr_chnl : entity is "wr_chnl";
end axi64_bram_ctrl_64KiB_wr_chnl;

architecture STRUCTURE of axi64_bram_ctrl_64KiB_wr_chnl is
  signal BID_FIFO_n_0 : STD_LOGIC;
  signal BID_FIFO_n_1 : STD_LOGIC;
  signal BID_FIFO_n_10 : STD_LOGIC;
  signal BID_FIFO_n_3 : STD_LOGIC;
  signal BID_FIFO_n_4 : STD_LOGIC;
  signal BID_FIFO_n_5 : STD_LOGIC;
  signal BID_FIFO_n_6 : STD_LOGIC;
  signal BID_FIFO_n_7 : STD_LOGIC;
  signal BID_FIFO_n_8 : STD_LOGIC;
  signal BID_FIFO_n_9 : STD_LOGIC;
  signal \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[0]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_2_n_0\ : STD_LOGIC;
  signal \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_3_n_0\ : STD_LOGIC;
  signal \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_1_n_0\ : STD_LOGIC;
  signal \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_2_n_0\ : STD_LOGIC;
  signal \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_3_n_0\ : STD_LOGIC;
  signal \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_5_n_0\ : STD_LOGIC;
  signal \^gen_awready.axi_aresetn_d3_reg_0\ : STD_LOGIC;
  signal \GEN_AWREADY.axi_awready_int_i_1_n_0\ : STD_LOGIC;
  signal \GEN_AW_DUAL.aw_active_i_1_n_0\ : STD_LOGIC;
  signal \GEN_AW_DUAL.wr_addr_sm_cs_i_1_n_0\ : STD_LOGIC;
  signal \GEN_AW_PIPE_DUAL.GEN_AWADDR[10].axi_awaddr_pipe_reg\ : STD_LOGIC;
  signal \GEN_AW_PIPE_DUAL.GEN_AWADDR[11].axi_awaddr_pipe_reg\ : STD_LOGIC;
  signal \GEN_AW_PIPE_DUAL.GEN_AWADDR[12].axi_awaddr_pipe_reg\ : STD_LOGIC;
  signal \GEN_AW_PIPE_DUAL.GEN_AWADDR[13].axi_awaddr_pipe_reg\ : STD_LOGIC;
  signal \GEN_AW_PIPE_DUAL.GEN_AWADDR[14].axi_awaddr_pipe_reg\ : STD_LOGIC;
  signal \GEN_AW_PIPE_DUAL.GEN_AWADDR[15].axi_awaddr_pipe_reg\ : STD_LOGIC;
  signal \GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe[3]_i_2_n_0\ : STD_LOGIC;
  signal \GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe_reg\ : STD_LOGIC;
  signal \GEN_AW_PIPE_DUAL.GEN_AWADDR[4].axi_awaddr_pipe_reg\ : STD_LOGIC;
  signal \GEN_AW_PIPE_DUAL.GEN_AWADDR[5].axi_awaddr_pipe_reg\ : STD_LOGIC;
  signal \GEN_AW_PIPE_DUAL.GEN_AWADDR[6].axi_awaddr_pipe_reg\ : STD_LOGIC;
  signal \GEN_AW_PIPE_DUAL.GEN_AWADDR[7].axi_awaddr_pipe_reg\ : STD_LOGIC;
  signal \GEN_AW_PIPE_DUAL.GEN_AWADDR[8].axi_awaddr_pipe_reg\ : STD_LOGIC;
  signal \GEN_AW_PIPE_DUAL.GEN_AWADDR[9].axi_awaddr_pipe_reg\ : STD_LOGIC;
  signal \GEN_AW_PIPE_DUAL.axi_awaddr_full_i_1_n_0\ : STD_LOGIC;
  signal \GEN_AW_PIPE_DUAL.axi_awburst_pipe_fixed_i_1_n_0\ : STD_LOGIC;
  signal \GEN_AW_PIPE_DUAL.axi_awburst_pipe_fixed_reg_n_0\ : STD_LOGIC;
  signal \GEN_AW_PIPE_DUAL.axi_awlen_pipe_1_or_2_i_2_n_0\ : STD_LOGIC;
  signal \GEN_DUAL_ADDR_CNT.bram_addr_int[10]_i_2_n_0\ : STD_LOGIC;
  signal \GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0\ : STD_LOGIC;
  signal \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_1_n_0\ : STD_LOGIC;
  signal \GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_2_n_0\ : STD_LOGIC;
  signal \GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_2_n_0\ : STD_LOGIC;
  signal \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.axi_wdata_full_reg_i_2_n_0\ : STD_LOGIC;
  signal \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.axi_wdata_full_reg_i_3_n_0\ : STD_LOGIC;
  signal \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.clr_bram_we_i_2_n_0\ : STD_LOGIC;
  signal \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.delay_aw_active_clr_i_1_n_0\ : STD_LOGIC;
  signal \GEN_WR_NO_ECC.bram_we_int[7]_i_1_n_0\ : STD_LOGIC;
  signal \I_RD_CHNL/axi_aresetn_d1\ : STD_LOGIC;
  signal \I_RD_CHNL/axi_aresetn_d2\ : STD_LOGIC;
  signal \I_RD_CHNL/axi_aresetn_re\ : STD_LOGIC;
  signal I_WRAP_BRST_n_1 : STD_LOGIC;
  signal I_WRAP_BRST_n_10 : STD_LOGIC;
  signal I_WRAP_BRST_n_11 : STD_LOGIC;
  signal I_WRAP_BRST_n_12 : STD_LOGIC;
  signal I_WRAP_BRST_n_13 : STD_LOGIC;
  signal I_WRAP_BRST_n_14 : STD_LOGIC;
  signal I_WRAP_BRST_n_15 : STD_LOGIC;
  signal I_WRAP_BRST_n_17 : STD_LOGIC;
  signal I_WRAP_BRST_n_18 : STD_LOGIC;
  signal I_WRAP_BRST_n_19 : STD_LOGIC;
  signal I_WRAP_BRST_n_20 : STD_LOGIC;
  signal I_WRAP_BRST_n_21 : STD_LOGIC;
  signal I_WRAP_BRST_n_6 : STD_LOGIC;
  signal I_WRAP_BRST_n_7 : STD_LOGIC;
  signal I_WRAP_BRST_n_8 : STD_LOGIC;
  signal I_WRAP_BRST_n_9 : STD_LOGIC;
  signal \^q\ : STD_LOGIC_VECTOR ( 12 downto 0 );
  signal aw_active : STD_LOGIC;
  signal awaddr_pipe_ld24_out : STD_LOGIC;
  signal \^axi_aresetn_d3\ : STD_LOGIC;
  signal axi_aresetn_re_reg : STD_LOGIC;
  signal axi_awaddr_full : STD_LOGIC;
  signal axi_awburst_pipe : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal axi_awid_pipe : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal axi_awlen_pipe : STD_LOGIC_VECTOR ( 7 downto 0 );
  signal axi_awlen_pipe_1_or_2 : STD_LOGIC;
  signal axi_awlen_pipe_1_or_20 : STD_LOGIC;
  signal axi_awsize_pipe : STD_LOGIC_VECTOR ( 0 to 0 );
  signal axi_bvalid_int_i_1_n_0 : STD_LOGIC;
  signal \^axi_bvalid_int_reg_0\ : STD_LOGIC;
  signal axi_wdata_full_cmb : STD_LOGIC;
  signal axi_wdata_full_reg : STD_LOGIC;
  signal axi_wr_burst : STD_LOGIC;
  signal axi_wr_burst_cmb : STD_LOGIC;
  signal axi_wr_burst_i_1_n_0 : STD_LOGIC;
  signal axi_wr_burst_i_3_n_0 : STD_LOGIC;
  signal axi_wr_burst_i_4_n_0 : STD_LOGIC;
  signal axi_wr_burst_i_5_n_0 : STD_LOGIC;
  signal axi_wr_burst_i_6_n_0 : STD_LOGIC;
  signal axi_wready_int_mod_i_1_n_0 : STD_LOGIC;
  signal bid_gets_fifo_load : STD_LOGIC;
  signal bid_gets_fifo_load_d1 : STD_LOGIC;
  signal bid_gets_fifo_load_d1_i_2_n_0 : STD_LOGIC;
  signal bid_gets_fifo_load_d1_i_3_n_0 : STD_LOGIC;
  signal bram_addr_ld_en : STD_LOGIC;
  signal bram_addr_ld_en_mod : STD_LOGIC;
  signal bram_en_cmb : STD_LOGIC;
  signal bvalid_cnt : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \bvalid_cnt[0]_i_1_n_0\ : STD_LOGIC;
  signal \bvalid_cnt[1]_i_1_n_0\ : STD_LOGIC;
  signal \bvalid_cnt[2]_i_1_n_0\ : STD_LOGIC;
  signal clr_bram_we : STD_LOGIC;
  signal clr_bram_we_cmb : STD_LOGIC;
  signal curr_awlen_reg_1_or_2 : STD_LOGIC;
  signal curr_awlen_reg_1_or_20 : STD_LOGIC;
  signal curr_awlen_reg_1_or_2_i_2_n_0 : STD_LOGIC;
  signal curr_fixed_burst : STD_LOGIC;
  signal curr_fixed_burst_reg : STD_LOGIC;
  signal curr_fixed_burst_reg_i_1_n_0 : STD_LOGIC;
  signal curr_wrap_burst : STD_LOGIC;
  signal curr_wrap_burst_reg : STD_LOGIC;
  signal curr_wrap_burst_reg_i_1_n_0 : STD_LOGIC;
  signal delay_aw_active_clr : STD_LOGIC;
  signal delay_aw_active_clr_cmb : STD_LOGIC;
  signal last_data_ack_mod : STD_LOGIC;
  signal last_data_ack_mod0 : STD_LOGIC;
  signal p_1_in : STD_LOGIC_VECTOR ( 11 downto 8 );
  signal \^s_axi_awready\ : STD_LOGIC;
  signal \^s_axi_wready\ : STD_LOGIC;
  signal wr_addr_sm_cs : STD_LOGIC;
  signal wr_data_sm_cs : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \wr_data_sm_ns__0\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal wrdata_reg_ld : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[0]_i_1\ : label is "soft_lutpair56";
  attribute SOFT_HLUTNM of \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_3\ : label is "soft_lutpair51";
  attribute SOFT_HLUTNM of \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_2\ : label is "soft_lutpair51";
  attribute SOFT_HLUTNM of \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_3\ : label is "soft_lutpair49";
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[0]\ : label is "brst_wr_data:010,idle:000,w8_awaddr:001,sng_wr_data:100,b2b_w8_wr_data:011";
  attribute FSM_ENCODED_STATES of \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1]\ : label is "brst_wr_data:010,idle:000,w8_awaddr:001,sng_wr_data:100,b2b_w8_wr_data:011";
  attribute FSM_ENCODED_STATES of \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[2]\ : label is "brst_wr_data:010,idle:000,w8_awaddr:001,sng_wr_data:100,b2b_w8_wr_data:011";
  attribute SOFT_HLUTNM of \GEN_AWREADY.axi_aresetn_re_reg_i_1\ : label is "soft_lutpair55";
  attribute SOFT_HLUTNM of \GEN_AW_DUAL.last_data_ack_mod_i_1\ : label is "soft_lutpair54";
  attribute SOFT_HLUTNM of \GEN_AW_PIPE_DUAL.axi_awaddr_full_i_1\ : label is "soft_lutpair53";
  attribute SOFT_HLUTNM of \GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_2\ : label is "soft_lutpair57";
  attribute SOFT_HLUTNM of \GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_2\ : label is "soft_lutpair57";
  attribute SOFT_HLUTNM of \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.axi_arready_1st_addr_i_1\ : label is "soft_lutpair55";
  attribute SOFT_HLUTNM of \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.axi_wdata_full_reg_i_2\ : label is "soft_lutpair50";
  attribute SOFT_HLUTNM of \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.axi_wdata_full_reg_i_3\ : label is "soft_lutpair53";
  attribute SOFT_HLUTNM of \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.clr_bram_we_i_2\ : label is "soft_lutpair56";
  attribute SOFT_HLUTNM of axi_wr_burst_i_4 : label is "soft_lutpair54";
  attribute SOFT_HLUTNM of axi_wr_burst_i_5 : label is "soft_lutpair50";
  attribute SOFT_HLUTNM of bid_gets_fifo_load_d1_i_3 : label is "soft_lutpair49";
  attribute SOFT_HLUTNM of curr_fixed_burst_reg_i_2 : label is "soft_lutpair52";
  attribute SOFT_HLUTNM of curr_wrap_burst_reg_i_2 : label is "soft_lutpair52";
begin
  \GEN_AWREADY.axi_aresetn_d3_reg_0\ <= \^gen_awready.axi_aresetn_d3_reg_0\;
  Q(12 downto 0) <= \^q\(12 downto 0);
  axi_aresetn_d3 <= \^axi_aresetn_d3\;
  axi_bvalid_int_reg_0 <= \^axi_bvalid_int_reg_0\;
  s_axi_awready <= \^s_axi_awready\;
  s_axi_wready <= \^s_axi_wready\;
BID_FIFO: entity work.axi64_bram_ctrl_64KiB_SRL_FIFO
     port map (
      D(3) => BID_FIFO_n_4,
      D(2) => BID_FIFO_n_5,
      D(1) => BID_FIFO_n_6,
      D(0) => BID_FIFO_n_7,
      Data_Exists_DFF_0 => \wrap_burst_total_reg[0]\,
      E(0) => BID_FIFO_n_1,
      \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1]\ => BID_FIFO_n_0,
      \GEN_AW_PIPE_DUAL.axi_awaddr_full_reg\ => BID_FIFO_n_9,
      Q(3 downto 0) => axi_awid_pipe(3 downto 0),
      aw_active => aw_active,
      axi_awaddr_full => axi_awaddr_full,
      \axi_bid_int_reg[0]\ => \^axi_bvalid_int_reg_0\,
      axi_wr_burst => axi_wr_burst,
      axi_wr_burst_reg => BID_FIFO_n_8,
      bid_gets_fifo_load => bid_gets_fifo_load,
      bid_gets_fifo_load_d1 => bid_gets_fifo_load_d1,
      bid_gets_fifo_load_d1_reg => bid_gets_fifo_load_d1_i_2_n_0,
      bid_gets_fifo_load_d1_reg_0 => \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.axi_wdata_full_reg_i_3_n_0\,
      bid_gets_fifo_load_d1_reg_1 => bid_gets_fifo_load_d1_i_3_n_0,
      bram_addr_ld_en => bram_addr_ld_en,
      bvalid_cnt(2 downto 0) => bvalid_cnt(2 downto 0),
      \bvalid_cnt_reg[0]\ => BID_FIFO_n_10,
      \bvalid_cnt_reg[2]\ => BID_FIFO_n_3,
      s_axi_aclk => s_axi_aclk,
      s_axi_awid(3 downto 0) => s_axi_awid(3 downto 0),
      s_axi_awready => \^s_axi_awready\,
      s_axi_awvalid => s_axi_awvalid,
      s_axi_bready => s_axi_bready,
      s_axi_wlast => s_axi_wlast,
      s_axi_wvalid => s_axi_wvalid,
      wr_data_sm_cs(2 downto 0) => wr_data_sm_cs(2 downto 0)
    );
\FSM_sequential_GEN_RD_CMD_OPT.rd_data_sm_cs[1]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^axi_aresetn_d3\,
      O => \^gen_awready.axi_aresetn_d3_reg_0\
    );
\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \wr_data_sm_ns__0\(0),
      I1 => \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_5_n_0\,
      I2 => wr_data_sm_cs(0),
      O => \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[0]_i_1_n_0\
    );
\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[0]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0FAF0F3000A0003"
    )
        port map (
      I0 => axi_wr_burst_i_3_n_0,
      I1 => BID_FIFO_n_10,
      I2 => wr_data_sm_cs(2),
      I3 => wr_data_sm_cs(0),
      I4 => wr_data_sm_cs(1),
      I5 => s_axi_wvalid,
      O => \wr_data_sm_ns__0\(0)
    );
\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF00FFFFFF100000"
    )
        port map (
      I0 => wr_data_sm_cs(0),
      I1 => s_axi_wlast,
      I2 => \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_2_n_0\,
      I3 => \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_3_n_0\,
      I4 => \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_5_n_0\,
      I5 => wr_data_sm_cs(1),
      O => \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_1_n_0\
    );
\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => BID_FIFO_n_10,
      I1 => wr_data_sm_cs(2),
      O => \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_2_n_0\
    );
\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000FC88"
    )
        port map (
      I0 => axi_wr_burst,
      I1 => wr_data_sm_cs(0),
      I2 => axi_wr_burst_i_3_n_0,
      I3 => wr_data_sm_cs(1),
      I4 => wr_data_sm_cs(2),
      O => \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_3_n_0\
    );
\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0FFFFFFF8FFF0000"
    )
        port map (
      I0 => \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_2_n_0\,
      I1 => wr_data_sm_cs(1),
      I2 => \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_3_n_0\,
      I3 => BID_FIFO_n_8,
      I4 => \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_5_n_0\,
      I5 => wr_data_sm_cs(2),
      O => \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_1_n_0\
    );
\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => wr_data_sm_cs(0),
      I1 => axi_wr_burst_i_3_n_0,
      O => \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_2_n_0\
    );
\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFFDFFFF"
    )
        port map (
      I0 => BID_FIFO_n_10,
      I1 => wr_data_sm_cs(1),
      I2 => wr_data_sm_cs(0),
      I3 => wr_data_sm_cs(2),
      I4 => s_axi_wlast,
      O => \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_3_n_0\
    );
\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000FFCCC0AACC"
    )
        port map (
      I0 => \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.axi_wdata_full_reg_i_3_n_0\,
      I1 => s_axi_wvalid,
      I2 => s_axi_wlast,
      I3 => wr_data_sm_cs(0),
      I4 => wr_data_sm_cs(1),
      I5 => wr_data_sm_cs(2),
      O => \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_5_n_0\
    );
\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[0]_i_1_n_0\,
      Q => wr_data_sm_cs(0),
      R => \wrap_burst_total_reg[0]\
    );
\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[1]_i_1_n_0\,
      Q => wr_data_sm_cs(1),
      R => \wrap_burst_total_reg[0]\
    );
\FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_1_n_0\,
      Q => wr_data_sm_cs(2),
      R => \wrap_burst_total_reg[0]\
    );
\GEN_AWREADY.axi_aresetn_d1_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => s_axi_aresetn,
      Q => \I_RD_CHNL/axi_aresetn_d1\,
      R => '0'
    );
\GEN_AWREADY.axi_aresetn_d2_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \I_RD_CHNL/axi_aresetn_d1\,
      Q => \I_RD_CHNL/axi_aresetn_d2\,
      R => '0'
    );
\GEN_AWREADY.axi_aresetn_d3_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \I_RD_CHNL/axi_aresetn_d2\,
      Q => \^axi_aresetn_d3\,
      R => '0'
    );
\GEN_AWREADY.axi_aresetn_re_reg_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \I_RD_CHNL/axi_aresetn_d1\,
      I1 => \I_RD_CHNL/axi_aresetn_d2\,
      O => \I_RD_CHNL/axi_aresetn_re\
    );
\GEN_AWREADY.axi_aresetn_re_reg_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \I_RD_CHNL/axi_aresetn_re\,
      Q => axi_aresetn_re_reg,
      R => '0'
    );
\GEN_AWREADY.axi_awready_int_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFD5FFC0"
    )
        port map (
      I0 => awaddr_pipe_ld24_out,
      I1 => axi_awaddr_full,
      I2 => bram_addr_ld_en,
      I3 => axi_aresetn_re_reg,
      I4 => \^s_axi_awready\,
      O => \GEN_AWREADY.axi_awready_int_i_1_n_0\
    );
\GEN_AWREADY.axi_awready_int_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \GEN_AWREADY.axi_awready_int_i_1_n_0\,
      Q => \^s_axi_awready\,
      R => \wrap_burst_total_reg[0]\
    );
\GEN_AW_DUAL.aw_active_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFBFFFFAAAAAAAA"
    )
        port map (
      I0 => bram_addr_ld_en,
      I1 => wr_data_sm_cs(2),
      I2 => wr_data_sm_cs(1),
      I3 => wr_data_sm_cs(0),
      I4 => delay_aw_active_clr,
      I5 => aw_active,
      O => \GEN_AW_DUAL.aw_active_i_1_n_0\
    );
\GEN_AW_DUAL.aw_active_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \GEN_AW_DUAL.aw_active_i_1_n_0\,
      Q => aw_active,
      R => \^gen_awready.axi_aresetn_d3_reg_0\
    );
\GEN_AW_DUAL.last_data_ack_mod_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"80"
    )
        port map (
      I0 => \^s_axi_wready\,
      I1 => s_axi_wlast,
      I2 => s_axi_wvalid,
      O => last_data_ack_mod0
    );
\GEN_AW_DUAL.last_data_ack_mod_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => last_data_ack_mod0,
      Q => last_data_ack_mod,
      R => \wrap_burst_total_reg[0]\
    );
\GEN_AW_DUAL.wr_addr_sm_cs_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00000010"
    )
        port map (
      I0 => I_WRAP_BRST_n_18,
      I1 => wr_addr_sm_cs,
      I2 => s_axi_awvalid,
      I3 => axi_awaddr_full,
      I4 => I_WRAP_BRST_n_1,
      O => \GEN_AW_DUAL.wr_addr_sm_cs_i_1_n_0\
    );
\GEN_AW_DUAL.wr_addr_sm_cs_reg\: unisim.vcomponents.FDRE
     port map (
      C => s_axi_aclk,
      CE => '1',
      D => \GEN_AW_DUAL.wr_addr_sm_cs_i_1_n_0\,
      Q => wr_addr_sm_cs,
      R => \^gen_awready.axi_aresetn_d3_reg_0\
    );
\GEN_AW_PIPE_DUAL.GEN_AWADDR[10].axi_awaddr_pipe_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awaddr(7),
      Q => \GEN_AW_PIPE_DUAL.GEN_AWADDR[10].axi_awaddr_pipe_reg\,
      R => '0'
    );
\GEN_AW_PIPE_DUAL.GEN_AWADDR[11].axi_awaddr_pipe_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awaddr(8),
      Q => \GEN_AW_PIPE_DUAL.GEN_AWADDR[11].axi_awaddr_pipe_reg\,
      R => '0'
    );
\GEN_AW_PIPE_DUAL.GEN_AWADDR[12].axi_awaddr_pipe_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awaddr(9),
      Q => \GEN_AW_PIPE_DUAL.GEN_AWADDR[12].axi_awaddr_pipe_reg\,
      R => '0'
    );
\GEN_AW_PIPE_DUAL.GEN_AWADDR[13].axi_awaddr_pipe_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awaddr(10),
      Q => \GEN_AW_PIPE_DUAL.GEN_AWADDR[13].axi_awaddr_pipe_reg\,
      R => '0'
    );
\GEN_AW_PIPE_DUAL.GEN_AWADDR[14].axi_awaddr_pipe_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awaddr(11),
      Q => \GEN_AW_PIPE_DUAL.GEN_AWADDR[14].axi_awaddr_pipe_reg\,
      R => '0'
    );
\GEN_AW_PIPE_DUAL.GEN_AWADDR[15].axi_awaddr_pipe_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awaddr(12),
      Q => \GEN_AW_PIPE_DUAL.GEN_AWADDR[15].axi_awaddr_pipe_reg\,
      R => '0'
    );
\GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0800"
    )
        port map (
      I0 => \GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe[3]_i_2_n_0\,
      I1 => s_axi_awvalid,
      I2 => axi_awaddr_full,
      I3 => \^axi_aresetn_d3\,
      O => awaddr_pipe_ld24_out
    );
\GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe[3]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"000000000000FF80"
    )
        port map (
      I0 => bvalid_cnt(1),
      I1 => bvalid_cnt(2),
      I2 => bvalid_cnt(0),
      I3 => aw_active,
      I4 => I_WRAP_BRST_n_18,
      I5 => wr_addr_sm_cs,
      O => \GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe[3]_i_2_n_0\
    );
\GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awaddr(0),
      Q => \GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe_reg\,
      R => '0'
    );
\GEN_AW_PIPE_DUAL.GEN_AWADDR[4].axi_awaddr_pipe_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awaddr(1),
      Q => \GEN_AW_PIPE_DUAL.GEN_AWADDR[4].axi_awaddr_pipe_reg\,
      R => '0'
    );
\GEN_AW_PIPE_DUAL.GEN_AWADDR[5].axi_awaddr_pipe_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awaddr(2),
      Q => \GEN_AW_PIPE_DUAL.GEN_AWADDR[5].axi_awaddr_pipe_reg\,
      R => '0'
    );
\GEN_AW_PIPE_DUAL.GEN_AWADDR[6].axi_awaddr_pipe_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awaddr(3),
      Q => \GEN_AW_PIPE_DUAL.GEN_AWADDR[6].axi_awaddr_pipe_reg\,
      R => '0'
    );
\GEN_AW_PIPE_DUAL.GEN_AWADDR[7].axi_awaddr_pipe_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awaddr(4),
      Q => \GEN_AW_PIPE_DUAL.GEN_AWADDR[7].axi_awaddr_pipe_reg\,
      R => '0'
    );
\GEN_AW_PIPE_DUAL.GEN_AWADDR[8].axi_awaddr_pipe_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awaddr(5),
      Q => \GEN_AW_PIPE_DUAL.GEN_AWADDR[8].axi_awaddr_pipe_reg\,
      R => '0'
    );
\GEN_AW_PIPE_DUAL.GEN_AWADDR[9].axi_awaddr_pipe_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awaddr(6),
      Q => \GEN_AW_PIPE_DUAL.GEN_AWADDR[9].axi_awaddr_pipe_reg\,
      R => '0'
    );
\GEN_AW_PIPE_DUAL.axi_awaddr_full_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0C88"
    )
        port map (
      I0 => awaddr_pipe_ld24_out,
      I1 => s_axi_aresetn,
      I2 => bram_addr_ld_en,
      I3 => axi_awaddr_full,
      O => \GEN_AW_PIPE_DUAL.axi_awaddr_full_i_1_n_0\
    );
\GEN_AW_PIPE_DUAL.axi_awaddr_full_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \GEN_AW_PIPE_DUAL.axi_awaddr_full_i_1_n_0\,
      Q => axi_awaddr_full,
      R => '0'
    );
\GEN_AW_PIPE_DUAL.axi_awburst_pipe_fixed_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"03AA"
    )
        port map (
      I0 => \GEN_AW_PIPE_DUAL.axi_awburst_pipe_fixed_reg_n_0\,
      I1 => s_axi_awburst(1),
      I2 => s_axi_awburst(0),
      I3 => awaddr_pipe_ld24_out,
      O => \GEN_AW_PIPE_DUAL.axi_awburst_pipe_fixed_i_1_n_0\
    );
\GEN_AW_PIPE_DUAL.axi_awburst_pipe_fixed_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \GEN_AW_PIPE_DUAL.axi_awburst_pipe_fixed_i_1_n_0\,
      Q => \GEN_AW_PIPE_DUAL.axi_awburst_pipe_fixed_reg_n_0\,
      R => '0'
    );
\GEN_AW_PIPE_DUAL.axi_awburst_pipe_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awburst(0),
      Q => axi_awburst_pipe(0),
      R => '0'
    );
\GEN_AW_PIPE_DUAL.axi_awburst_pipe_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awburst(1),
      Q => axi_awburst_pipe(1),
      R => '0'
    );
\GEN_AW_PIPE_DUAL.axi_awid_pipe_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awid(0),
      Q => axi_awid_pipe(0),
      R => '0'
    );
\GEN_AW_PIPE_DUAL.axi_awid_pipe_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awid(1),
      Q => axi_awid_pipe(1),
      R => '0'
    );
\GEN_AW_PIPE_DUAL.axi_awid_pipe_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awid(2),
      Q => axi_awid_pipe(2),
      R => '0'
    );
\GEN_AW_PIPE_DUAL.axi_awid_pipe_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awid(3),
      Q => axi_awid_pipe(3),
      R => '0'
    );
\GEN_AW_PIPE_DUAL.axi_awlen_pipe_1_or_2_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0002"
    )
        port map (
      I0 => \GEN_AW_PIPE_DUAL.axi_awlen_pipe_1_or_2_i_2_n_0\,
      I1 => s_axi_awlen(2),
      I2 => s_axi_awlen(1),
      I3 => s_axi_awlen(3),
      O => axi_awlen_pipe_1_or_20
    );
\GEN_AW_PIPE_DUAL.axi_awlen_pipe_1_or_2_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0001"
    )
        port map (
      I0 => s_axi_awlen(4),
      I1 => s_axi_awlen(5),
      I2 => s_axi_awlen(6),
      I3 => s_axi_awlen(7),
      O => \GEN_AW_PIPE_DUAL.axi_awlen_pipe_1_or_2_i_2_n_0\
    );
\GEN_AW_PIPE_DUAL.axi_awlen_pipe_1_or_2_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => axi_awlen_pipe_1_or_20,
      Q => axi_awlen_pipe_1_or_2,
      R => '0'
    );
\GEN_AW_PIPE_DUAL.axi_awlen_pipe_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awlen(0),
      Q => axi_awlen_pipe(0),
      R => '0'
    );
\GEN_AW_PIPE_DUAL.axi_awlen_pipe_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awlen(1),
      Q => axi_awlen_pipe(1),
      R => '0'
    );
\GEN_AW_PIPE_DUAL.axi_awlen_pipe_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awlen(2),
      Q => axi_awlen_pipe(2),
      R => '0'
    );
\GEN_AW_PIPE_DUAL.axi_awlen_pipe_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awlen(3),
      Q => axi_awlen_pipe(3),
      R => '0'
    );
\GEN_AW_PIPE_DUAL.axi_awlen_pipe_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awlen(4),
      Q => axi_awlen_pipe(4),
      R => '0'
    );
\GEN_AW_PIPE_DUAL.axi_awlen_pipe_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awlen(5),
      Q => axi_awlen_pipe(5),
      R => '0'
    );
\GEN_AW_PIPE_DUAL.axi_awlen_pipe_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awlen(6),
      Q => axi_awlen_pipe(6),
      R => '0'
    );
\GEN_AW_PIPE_DUAL.axi_awlen_pipe_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => s_axi_awlen(7),
      Q => axi_awlen_pipe(7),
      R => '0'
    );
\GEN_AW_PIPE_DUAL.axi_awsize_pipe_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => awaddr_pipe_ld24_out,
      D => '1',
      Q => axi_awsize_pipe(0),
      R => '0'
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[10]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000000000000000"
    )
        port map (
      I0 => \^q\(5),
      I1 => \^q\(3),
      I2 => \^q\(2),
      I3 => \^q\(0),
      I4 => \^q\(1),
      I5 => \^q\(4),
      O => \GEN_DUAL_ADDR_CNT.bram_addr_int[10]_i_2_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9555555555555555"
    )
        port map (
      I0 => \^q\(8),
      I1 => \^q\(6),
      I2 => \^q\(4),
      I3 => I_WRAP_BRST_n_15,
      I4 => \^q\(5),
      I5 => \^q\(7),
      O => \GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000100FFFFFFFF"
    )
        port map (
      I0 => bram_addr_ld_en,
      I1 => wr_data_sm_cs(0),
      I2 => wr_data_sm_cs(1),
      I3 => wr_data_sm_cs(2),
      I4 => s_axi_wvalid,
      I5 => s_axi_aresetn,
      O => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_1_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => \^q\(0),
      I1 => \^q\(1),
      O => \GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_2_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"7F"
    )
        port map (
      I0 => \^q\(1),
      I1 => \^q\(0),
      I2 => \^q\(2),
      O => \GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_2_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => I_WRAP_BRST_n_17,
      D => I_WRAP_BRST_n_7,
      Q => \^q\(7),
      R => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_1_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => I_WRAP_BRST_n_17,
      D => I_WRAP_BRST_n_6,
      Q => \^q\(8),
      R => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_1_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => bram_addr_ld_en_mod,
      D => p_1_in(8),
      Q => \^q\(9),
      R => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_1_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => bram_addr_ld_en_mod,
      D => p_1_in(9),
      Q => \^q\(10),
      R => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_1_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => bram_addr_ld_en_mod,
      D => p_1_in(10),
      Q => \^q\(11),
      R => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_1_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => bram_addr_ld_en_mod,
      D => p_1_in(11),
      Q => \^q\(12),
      R => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_1_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => I_WRAP_BRST_n_17,
      D => I_WRAP_BRST_n_14,
      Q => \^q\(0),
      R => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_1_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => I_WRAP_BRST_n_17,
      D => I_WRAP_BRST_n_13,
      Q => \^q\(1),
      R => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_1_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => I_WRAP_BRST_n_17,
      D => I_WRAP_BRST_n_12,
      Q => \^q\(2),
      R => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_1_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => I_WRAP_BRST_n_17,
      D => I_WRAP_BRST_n_11,
      Q => \^q\(3),
      R => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_1_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => I_WRAP_BRST_n_17,
      D => I_WRAP_BRST_n_10,
      Q => \^q\(4),
      R => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_1_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => I_WRAP_BRST_n_17,
      D => I_WRAP_BRST_n_9,
      Q => \^q\(5),
      R => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_1_n_0\
    );
\GEN_DUAL_ADDR_CNT.bram_addr_int_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => I_WRAP_BRST_n_17,
      D => I_WRAP_BRST_n_8,
      Q => \^q\(6),
      R => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_1_n_0\
    );
\GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.axi_arready_1st_addr_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7530"
    )
        port map (
      I0 => s_axi_arvalid,
      I1 => \I_RD_CHNL/axi_aresetn_d2\,
      I2 => \I_RD_CHNL/axi_aresetn_d1\,
      I3 => axi_arready_1st_addr,
      O => s_axi_arvalid_0
    );
\GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.axi_wdata_full_reg_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAEEEAEAAAEEEFE"
    )
        port map (
      I0 => \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.axi_wdata_full_reg_i_2_n_0\,
      I1 => axi_wdata_full_reg,
      I2 => wr_data_sm_cs(0),
      I3 => wr_data_sm_cs(1),
      I4 => wr_data_sm_cs(2),
      I5 => \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.axi_wdata_full_reg_i_3_n_0\,
      O => axi_wdata_full_cmb
    );
\GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.axi_wdata_full_reg_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"10100010"
    )
        port map (
      I0 => wr_data_sm_cs(1),
      I1 => wr_data_sm_cs(0),
      I2 => s_axi_wvalid,
      I3 => BID_FIFO_n_10,
      I4 => wr_data_sm_cs(2),
      O => \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.axi_wdata_full_reg_i_2_n_0\
    );
\GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.axi_wdata_full_reg_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"F8"
    )
        port map (
      I0 => bram_addr_ld_en,
      I1 => axi_awaddr_full,
      I2 => BID_FIFO_n_10,
      O => \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.axi_wdata_full_reg_i_3_n_0\
    );
\GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.axi_wdata_full_reg_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => axi_wdata_full_cmb,
      Q => axi_wdata_full_reg,
      R => \wrap_burst_total_reg[0]\
    );
\GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.bram_en_int_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"3300330033302020"
    )
        port map (
      I0 => BID_FIFO_n_9,
      I1 => wr_data_sm_cs(2),
      I2 => wr_data_sm_cs(0),
      I3 => s_axi_wvalid,
      I4 => BID_FIFO_n_10,
      I5 => wr_data_sm_cs(1),
      O => bram_en_cmb
    );
\GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.bram_en_int_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => bram_en_cmb,
      Q => bram_en_a,
      R => \wrap_burst_total_reg[0]\
    );
\GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.clr_bram_we_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0100FFFF01000100"
    )
        port map (
      I0 => axi_wr_burst,
      I1 => \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.clr_bram_we_i_2_n_0\,
      I2 => wr_data_sm_cs(1),
      I3 => \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.axi_wdata_full_reg_i_3_n_0\,
      I4 => \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_3_n_0\,
      I5 => s_axi_wvalid,
      O => clr_bram_we_cmb
    );
\GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.clr_bram_we_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"B"
    )
        port map (
      I0 => wr_data_sm_cs(2),
      I1 => wr_data_sm_cs(0),
      O => \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.clr_bram_we_i_2_n_0\
    );
\GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.clr_bram_we_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => clr_bram_we_cmb,
      Q => clr_bram_we,
      R => \wrap_burst_total_reg[0]\
    );
\GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.delay_aw_active_clr_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AAAAAB88AB88AB88"
    )
        port map (
      I0 => delay_aw_active_clr_cmb,
      I1 => clr_bram_we_cmb,
      I2 => wr_data_sm_cs(2),
      I3 => delay_aw_active_clr,
      I4 => axi_wr_burst_i_4_n_0,
      I5 => \FSM_sequential_GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.wr_data_sm_cs[2]_i_2_n_0\,
      O => \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.delay_aw_active_clr_i_1_n_0\
    );
\GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.delay_aw_active_clr_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00F800FF00F80000"
    )
        port map (
      I0 => bram_addr_ld_en,
      I1 => axi_awaddr_full,
      I2 => BID_FIFO_n_10,
      I3 => wr_data_sm_cs(2),
      I4 => wr_data_sm_cs(0),
      I5 => s_axi_wlast,
      O => delay_aw_active_clr_cmb
    );
\GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.delay_aw_active_clr_reg\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \GEN_WDATA_SM_NO_ECC_DUAL_REG_WREADY.delay_aw_active_clr_i_1_n_0\,
      Q => delay_aw_active_clr,
      R => \wrap_burst_total_reg[0]\
    );
\GEN_WRDATA[0].bram_wrdata_int_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(0),
      Q => bram_wrdata_a(0),
      R => '0'
    );
\GEN_WRDATA[10].bram_wrdata_int_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(10),
      Q => bram_wrdata_a(10),
      R => '0'
    );
\GEN_WRDATA[11].bram_wrdata_int_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(11),
      Q => bram_wrdata_a(11),
      R => '0'
    );
\GEN_WRDATA[12].bram_wrdata_int_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(12),
      Q => bram_wrdata_a(12),
      R => '0'
    );
\GEN_WRDATA[13].bram_wrdata_int_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(13),
      Q => bram_wrdata_a(13),
      R => '0'
    );
\GEN_WRDATA[14].bram_wrdata_int_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(14),
      Q => bram_wrdata_a(14),
      R => '0'
    );
\GEN_WRDATA[15].bram_wrdata_int_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(15),
      Q => bram_wrdata_a(15),
      R => '0'
    );
\GEN_WRDATA[16].bram_wrdata_int_reg[16]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(16),
      Q => bram_wrdata_a(16),
      R => '0'
    );
\GEN_WRDATA[17].bram_wrdata_int_reg[17]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(17),
      Q => bram_wrdata_a(17),
      R => '0'
    );
\GEN_WRDATA[18].bram_wrdata_int_reg[18]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(18),
      Q => bram_wrdata_a(18),
      R => '0'
    );
\GEN_WRDATA[19].bram_wrdata_int_reg[19]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(19),
      Q => bram_wrdata_a(19),
      R => '0'
    );
\GEN_WRDATA[1].bram_wrdata_int_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(1),
      Q => bram_wrdata_a(1),
      R => '0'
    );
\GEN_WRDATA[20].bram_wrdata_int_reg[20]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(20),
      Q => bram_wrdata_a(20),
      R => '0'
    );
\GEN_WRDATA[21].bram_wrdata_int_reg[21]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(21),
      Q => bram_wrdata_a(21),
      R => '0'
    );
\GEN_WRDATA[22].bram_wrdata_int_reg[22]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(22),
      Q => bram_wrdata_a(22),
      R => '0'
    );
\GEN_WRDATA[23].bram_wrdata_int_reg[23]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(23),
      Q => bram_wrdata_a(23),
      R => '0'
    );
\GEN_WRDATA[24].bram_wrdata_int_reg[24]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(24),
      Q => bram_wrdata_a(24),
      R => '0'
    );
\GEN_WRDATA[25].bram_wrdata_int_reg[25]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(25),
      Q => bram_wrdata_a(25),
      R => '0'
    );
\GEN_WRDATA[26].bram_wrdata_int_reg[26]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(26),
      Q => bram_wrdata_a(26),
      R => '0'
    );
\GEN_WRDATA[27].bram_wrdata_int_reg[27]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(27),
      Q => bram_wrdata_a(27),
      R => '0'
    );
\GEN_WRDATA[28].bram_wrdata_int_reg[28]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(28),
      Q => bram_wrdata_a(28),
      R => '0'
    );
\GEN_WRDATA[29].bram_wrdata_int_reg[29]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(29),
      Q => bram_wrdata_a(29),
      R => '0'
    );
\GEN_WRDATA[2].bram_wrdata_int_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(2),
      Q => bram_wrdata_a(2),
      R => '0'
    );
\GEN_WRDATA[30].bram_wrdata_int_reg[30]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(30),
      Q => bram_wrdata_a(30),
      R => '0'
    );
\GEN_WRDATA[31].bram_wrdata_int_reg[31]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(31),
      Q => bram_wrdata_a(31),
      R => '0'
    );
\GEN_WRDATA[32].bram_wrdata_int_reg[32]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(32),
      Q => bram_wrdata_a(32),
      R => '0'
    );
\GEN_WRDATA[33].bram_wrdata_int_reg[33]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(33),
      Q => bram_wrdata_a(33),
      R => '0'
    );
\GEN_WRDATA[34].bram_wrdata_int_reg[34]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(34),
      Q => bram_wrdata_a(34),
      R => '0'
    );
\GEN_WRDATA[35].bram_wrdata_int_reg[35]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(35),
      Q => bram_wrdata_a(35),
      R => '0'
    );
\GEN_WRDATA[36].bram_wrdata_int_reg[36]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(36),
      Q => bram_wrdata_a(36),
      R => '0'
    );
\GEN_WRDATA[37].bram_wrdata_int_reg[37]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(37),
      Q => bram_wrdata_a(37),
      R => '0'
    );
\GEN_WRDATA[38].bram_wrdata_int_reg[38]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(38),
      Q => bram_wrdata_a(38),
      R => '0'
    );
\GEN_WRDATA[39].bram_wrdata_int_reg[39]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(39),
      Q => bram_wrdata_a(39),
      R => '0'
    );
\GEN_WRDATA[3].bram_wrdata_int_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(3),
      Q => bram_wrdata_a(3),
      R => '0'
    );
\GEN_WRDATA[40].bram_wrdata_int_reg[40]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(40),
      Q => bram_wrdata_a(40),
      R => '0'
    );
\GEN_WRDATA[41].bram_wrdata_int_reg[41]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(41),
      Q => bram_wrdata_a(41),
      R => '0'
    );
\GEN_WRDATA[42].bram_wrdata_int_reg[42]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(42),
      Q => bram_wrdata_a(42),
      R => '0'
    );
\GEN_WRDATA[43].bram_wrdata_int_reg[43]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(43),
      Q => bram_wrdata_a(43),
      R => '0'
    );
\GEN_WRDATA[44].bram_wrdata_int_reg[44]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(44),
      Q => bram_wrdata_a(44),
      R => '0'
    );
\GEN_WRDATA[45].bram_wrdata_int_reg[45]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(45),
      Q => bram_wrdata_a(45),
      R => '0'
    );
\GEN_WRDATA[46].bram_wrdata_int_reg[46]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(46),
      Q => bram_wrdata_a(46),
      R => '0'
    );
\GEN_WRDATA[47].bram_wrdata_int_reg[47]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(47),
      Q => bram_wrdata_a(47),
      R => '0'
    );
\GEN_WRDATA[48].bram_wrdata_int_reg[48]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(48),
      Q => bram_wrdata_a(48),
      R => '0'
    );
\GEN_WRDATA[49].bram_wrdata_int_reg[49]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(49),
      Q => bram_wrdata_a(49),
      R => '0'
    );
\GEN_WRDATA[4].bram_wrdata_int_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(4),
      Q => bram_wrdata_a(4),
      R => '0'
    );
\GEN_WRDATA[50].bram_wrdata_int_reg[50]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(50),
      Q => bram_wrdata_a(50),
      R => '0'
    );
\GEN_WRDATA[51].bram_wrdata_int_reg[51]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(51),
      Q => bram_wrdata_a(51),
      R => '0'
    );
\GEN_WRDATA[52].bram_wrdata_int_reg[52]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(52),
      Q => bram_wrdata_a(52),
      R => '0'
    );
\GEN_WRDATA[53].bram_wrdata_int_reg[53]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(53),
      Q => bram_wrdata_a(53),
      R => '0'
    );
\GEN_WRDATA[54].bram_wrdata_int_reg[54]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(54),
      Q => bram_wrdata_a(54),
      R => '0'
    );
\GEN_WRDATA[55].bram_wrdata_int_reg[55]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(55),
      Q => bram_wrdata_a(55),
      R => '0'
    );
\GEN_WRDATA[56].bram_wrdata_int_reg[56]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(56),
      Q => bram_wrdata_a(56),
      R => '0'
    );
\GEN_WRDATA[57].bram_wrdata_int_reg[57]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(57),
      Q => bram_wrdata_a(57),
      R => '0'
    );
\GEN_WRDATA[58].bram_wrdata_int_reg[58]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(58),
      Q => bram_wrdata_a(58),
      R => '0'
    );
\GEN_WRDATA[59].bram_wrdata_int_reg[59]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(59),
      Q => bram_wrdata_a(59),
      R => '0'
    );
\GEN_WRDATA[5].bram_wrdata_int_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(5),
      Q => bram_wrdata_a(5),
      R => '0'
    );
\GEN_WRDATA[60].bram_wrdata_int_reg[60]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(60),
      Q => bram_wrdata_a(60),
      R => '0'
    );
\GEN_WRDATA[61].bram_wrdata_int_reg[61]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(61),
      Q => bram_wrdata_a(61),
      R => '0'
    );
\GEN_WRDATA[62].bram_wrdata_int_reg[62]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(62),
      Q => bram_wrdata_a(62),
      R => '0'
    );
\GEN_WRDATA[63].bram_wrdata_int_reg[63]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(63),
      Q => bram_wrdata_a(63),
      R => '0'
    );
\GEN_WRDATA[6].bram_wrdata_int_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(6),
      Q => bram_wrdata_a(6),
      R => '0'
    );
\GEN_WRDATA[7].bram_wrdata_int_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(7),
      Q => bram_wrdata_a(7),
      R => '0'
    );
\GEN_WRDATA[8].bram_wrdata_int_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(8),
      Q => bram_wrdata_a(8),
      R => '0'
    );
\GEN_WRDATA[9].bram_wrdata_int_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wdata(9),
      Q => bram_wrdata_a(9),
      R => '0'
    );
\GEN_WR_NO_ECC.bram_we_int[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FD5D0000FFFFFFFF"
    )
        port map (
      I0 => s_axi_wvalid,
      I1 => wr_data_sm_cs(0),
      I2 => wr_data_sm_cs(1),
      I3 => wr_data_sm_cs(2),
      I4 => clr_bram_we,
      I5 => s_axi_aresetn,
      O => \GEN_WR_NO_ECC.bram_we_int[7]_i_1_n_0\
    );
\GEN_WR_NO_ECC.bram_we_int[7]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"02A2"
    )
        port map (
      I0 => s_axi_wvalid,
      I1 => wr_data_sm_cs(0),
      I2 => wr_data_sm_cs(1),
      I3 => wr_data_sm_cs(2),
      O => wrdata_reg_ld
    );
\GEN_WR_NO_ECC.bram_we_int_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wstrb(0),
      Q => bram_we_a(0),
      R => \GEN_WR_NO_ECC.bram_we_int[7]_i_1_n_0\
    );
\GEN_WR_NO_ECC.bram_we_int_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wstrb(1),
      Q => bram_we_a(1),
      R => \GEN_WR_NO_ECC.bram_we_int[7]_i_1_n_0\
    );
\GEN_WR_NO_ECC.bram_we_int_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wstrb(2),
      Q => bram_we_a(2),
      R => \GEN_WR_NO_ECC.bram_we_int[7]_i_1_n_0\
    );
\GEN_WR_NO_ECC.bram_we_int_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wstrb(3),
      Q => bram_we_a(3),
      R => \GEN_WR_NO_ECC.bram_we_int[7]_i_1_n_0\
    );
\GEN_WR_NO_ECC.bram_we_int_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wstrb(4),
      Q => bram_we_a(4),
      R => \GEN_WR_NO_ECC.bram_we_int[7]_i_1_n_0\
    );
\GEN_WR_NO_ECC.bram_we_int_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wstrb(5),
      Q => bram_we_a(5),
      R => \GEN_WR_NO_ECC.bram_we_int[7]_i_1_n_0\
    );
\GEN_WR_NO_ECC.bram_we_int_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wstrb(6),
      Q => bram_we_a(6),
      R => \GEN_WR_NO_ECC.bram_we_int[7]_i_1_n_0\
    );
\GEN_WR_NO_ECC.bram_we_int_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => wrdata_reg_ld,
      D => s_axi_wstrb(7),
      Q => bram_we_a(7),
      R => \GEN_WR_NO_ECC.bram_we_int[7]_i_1_n_0\
    );
I_WRAP_BRST: entity work.axi64_bram_ctrl_64KiB_wrap_brst
     port map (
      D(12 downto 9) => p_1_in(11 downto 8),
      D(8) => I_WRAP_BRST_n_6,
      D(7) => I_WRAP_BRST_n_7,
      D(6) => I_WRAP_BRST_n_8,
      D(5) => I_WRAP_BRST_n_9,
      D(4) => I_WRAP_BRST_n_10,
      D(3) => I_WRAP_BRST_n_11,
      D(2) => I_WRAP_BRST_n_12,
      D(1) => I_WRAP_BRST_n_13,
      D(0) => I_WRAP_BRST_n_14,
      E(1) => bram_addr_ld_en_mod,
      E(0) => I_WRAP_BRST_n_17,
      \GEN_AW_DUAL.aw_active_reg\ => I_WRAP_BRST_n_1,
      \GEN_AW_DUAL.last_data_ack_mod_reg\ => I_WRAP_BRST_n_18,
      \GEN_AW_PIPE_DUAL.GEN_AWADDR[10].axi_awaddr_pipe_reg\ => \GEN_AW_PIPE_DUAL.GEN_AWADDR[10].axi_awaddr_pipe_reg\,
      \GEN_AW_PIPE_DUAL.GEN_AWADDR[11].axi_awaddr_pipe_reg\ => \GEN_AW_PIPE_DUAL.GEN_AWADDR[11].axi_awaddr_pipe_reg\,
      \GEN_AW_PIPE_DUAL.GEN_AWADDR[12].axi_awaddr_pipe_reg\ => \GEN_AW_PIPE_DUAL.GEN_AWADDR[12].axi_awaddr_pipe_reg\,
      \GEN_AW_PIPE_DUAL.GEN_AWADDR[13].axi_awaddr_pipe_reg\ => \GEN_AW_PIPE_DUAL.GEN_AWADDR[13].axi_awaddr_pipe_reg\,
      \GEN_AW_PIPE_DUAL.GEN_AWADDR[14].axi_awaddr_pipe_reg\ => \GEN_AW_PIPE_DUAL.GEN_AWADDR[14].axi_awaddr_pipe_reg\,
      \GEN_AW_PIPE_DUAL.GEN_AWADDR[15].axi_awaddr_pipe_reg\ => \GEN_AW_PIPE_DUAL.GEN_AWADDR[15].axi_awaddr_pipe_reg\,
      \GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe_reg\ => \GEN_AW_PIPE_DUAL.GEN_AWADDR[3].axi_awaddr_pipe_reg\,
      \GEN_AW_PIPE_DUAL.GEN_AWADDR[4].axi_awaddr_pipe_reg\ => \GEN_AW_PIPE_DUAL.GEN_AWADDR[4].axi_awaddr_pipe_reg\,
      \GEN_AW_PIPE_DUAL.GEN_AWADDR[5].axi_awaddr_pipe_reg\ => \GEN_AW_PIPE_DUAL.GEN_AWADDR[5].axi_awaddr_pipe_reg\,
      \GEN_AW_PIPE_DUAL.GEN_AWADDR[6].axi_awaddr_pipe_reg\ => \GEN_AW_PIPE_DUAL.GEN_AWADDR[6].axi_awaddr_pipe_reg\,
      \GEN_AW_PIPE_DUAL.GEN_AWADDR[7].axi_awaddr_pipe_reg\ => \GEN_AW_PIPE_DUAL.GEN_AWADDR[7].axi_awaddr_pipe_reg\,
      \GEN_AW_PIPE_DUAL.GEN_AWADDR[8].axi_awaddr_pipe_reg\ => \GEN_AW_PIPE_DUAL.GEN_AWADDR[8].axi_awaddr_pipe_reg\,
      \GEN_AW_PIPE_DUAL.GEN_AWADDR[9].axi_awaddr_pipe_reg\ => \GEN_AW_PIPE_DUAL.GEN_AWADDR[9].axi_awaddr_pipe_reg\,
      \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[10]\ => \GEN_DUAL_ADDR_CNT.bram_addr_int[10]_i_2_n_0\,
      \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[11]\ => \GEN_DUAL_ADDR_CNT.bram_addr_int[11]_i_4_n_0\,
      \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[5]\ => \GEN_DUAL_ADDR_CNT.bram_addr_int[5]_i_2_n_0\,
      \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[6]\ => I_WRAP_BRST_n_15,
      \GEN_DUAL_ADDR_CNT.bram_addr_int_reg[6]_0\ => \GEN_DUAL_ADDR_CNT.bram_addr_int[6]_i_2_n_0\,
      Q(7 downto 0) => \^q\(7 downto 0),
      aw_active => aw_active,
      axi_awaddr_full => axi_awaddr_full,
      axi_awlen_pipe_1_or_2 => axi_awlen_pipe_1_or_2,
      axi_awsize_pipe(0) => axi_awsize_pipe(0),
      bram_addr_ld_en => bram_addr_ld_en,
      bvalid_cnt(2 downto 0) => bvalid_cnt(2 downto 0),
      curr_awlen_reg_1_or_2 => curr_awlen_reg_1_or_2,
      curr_fixed_burst_reg => curr_fixed_burst_reg,
      curr_wrap_burst_reg => curr_wrap_burst_reg,
      last_data_ack_mod => last_data_ack_mod,
      s_axi_aclk => s_axi_aclk,
      s_axi_awaddr(12 downto 0) => s_axi_awaddr(12 downto 0),
      s_axi_awlen(3 downto 0) => s_axi_awlen(3 downto 0),
      s_axi_awvalid => s_axi_awvalid,
      s_axi_awvalid_0 => I_WRAP_BRST_n_19,
      s_axi_awvalid_1 => I_WRAP_BRST_n_20,
      s_axi_awvalid_2 => I_WRAP_BRST_n_21,
      s_axi_wvalid => s_axi_wvalid,
      \save_init_bram_addr_ld_reg[15]_0\ => \^axi_aresetn_d3\,
      \save_init_bram_addr_ld_reg[15]_1\ => \GEN_AW_PIPE_DUAL.axi_awburst_pipe_fixed_reg_n_0\,
      wr_addr_sm_cs => wr_addr_sm_cs,
      wr_data_sm_cs(2 downto 0) => wr_data_sm_cs(2 downto 0),
      \wrap_burst_total_reg[0]_0\(3 downto 0) => axi_awlen_pipe(3 downto 0),
      \wrap_burst_total_reg[0]_1\ => \wrap_burst_total_reg[0]\
    );
\axi_bid_int_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => BID_FIFO_n_1,
      D => BID_FIFO_n_7,
      Q => s_axi_bid(0),
      R => \wrap_burst_total_reg[0]\
    );
\axi_bid_int_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => BID_FIFO_n_1,
      D => BID_FIFO_n_6,
      Q => s_axi_bid(1),
      R => \wrap_burst_total_reg[0]\
    );
\axi_bid_int_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => BID_FIFO_n_1,
      D => BID_FIFO_n_5,
      Q => s_axi_bid(2),
      R => \wrap_burst_total_reg[0]\
    );
\axi_bid_int_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => BID_FIFO_n_1,
      D => BID_FIFO_n_4,
      Q => s_axi_bid(3),
      R => \wrap_burst_total_reg[0]\
    );
axi_bvalid_int_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"CCCCCCCCCCC4CCC0"
    )
        port map (
      I0 => BID_FIFO_n_3,
      I1 => s_axi_aresetn,
      I2 => bvalid_cnt(2),
      I3 => bvalid_cnt(1),
      I4 => bvalid_cnt(0),
      I5 => BID_FIFO_n_0,
      O => axi_bvalid_int_i_1_n_0
    );
axi_bvalid_int_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => axi_bvalid_int_i_1_n_0,
      Q => \^axi_bvalid_int_reg_0\,
      R => '0'
    );
axi_wr_burst_i_1: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AABFAA80"
    )
        port map (
      I0 => axi_wr_burst_cmb,
      I1 => axi_wr_burst_i_3_n_0,
      I2 => axi_wr_burst_i_4_n_0,
      I3 => axi_wr_burst_i_5_n_0,
      I4 => axi_wr_burst,
      O => axi_wr_burst_i_1_n_0
    );
axi_wr_burst_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00030003F8FB080B"
    )
        port map (
      I0 => axi_wr_burst_i_3_n_0,
      I1 => wr_data_sm_cs(1),
      I2 => wr_data_sm_cs(0),
      I3 => s_axi_wlast,
      I4 => s_axi_wvalid,
      I5 => wr_data_sm_cs(2),
      O => axi_wr_burst_cmb
    );
axi_wr_burst_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0100000001000100"
    )
        port map (
      I0 => \GEN_AW_PIPE_DUAL.axi_awburst_pipe_fixed_reg_n_0\,
      I1 => curr_awlen_reg_1_or_2,
      I2 => axi_awlen_pipe_1_or_2,
      I3 => axi_awaddr_full,
      I4 => bvalid_cnt(0),
      I5 => axi_wr_burst_i_6_n_0,
      O => axi_wr_burst_i_3_n_0
    );
axi_wr_burst_i_4: unisim.vcomponents.LUT4
    generic map(
      INIT => X"4000"
    )
        port map (
      I0 => wr_data_sm_cs(2),
      I1 => wr_data_sm_cs(1),
      I2 => s_axi_wlast,
      I3 => s_axi_wvalid,
      O => axi_wr_burst_i_4_n_0
    );
axi_wr_burst_i_5: unisim.vcomponents.LUT4
    generic map(
      INIT => X"400C"
    )
        port map (
      I0 => wr_data_sm_cs(2),
      I1 => s_axi_wvalid,
      I2 => wr_data_sm_cs(0),
      I3 => wr_data_sm_cs(1),
      O => axi_wr_burst_i_5_n_0
    );
axi_wr_burst_i_6: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => bvalid_cnt(2),
      I1 => bvalid_cnt(1),
      O => axi_wr_burst_i_6_n_0
    );
axi_wr_burst_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => axi_wr_burst_i_1_n_0,
      Q => axi_wr_burst,
      R => \wrap_burst_total_reg[0]\
    );
axi_wready_int_mod_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => s_axi_aresetn,
      I1 => axi_wdata_full_cmb,
      O => axi_wready_int_mod_i_1_n_0
    );
axi_wready_int_mod_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => axi_wready_int_mod_i_1_n_0,
      Q => \^s_axi_wready\,
      R => '0'
    );
bid_gets_fifo_load_d1_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0200020002000000"
    )
        port map (
      I0 => s_axi_wlast,
      I1 => wr_data_sm_cs(2),
      I2 => wr_data_sm_cs(0),
      I3 => s_axi_wvalid,
      I4 => BID_FIFO_n_10,
      I5 => wr_data_sm_cs(1),
      O => bid_gets_fifo_load_d1_i_2_n_0
    );
bid_gets_fifo_load_d1_i_3: unisim.vcomponents.LUT3
    generic map(
      INIT => X"FB"
    )
        port map (
      I0 => wr_data_sm_cs(1),
      I1 => wr_data_sm_cs(0),
      I2 => wr_data_sm_cs(2),
      O => bid_gets_fifo_load_d1_i_3_n_0
    );
bid_gets_fifo_load_d1_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => bid_gets_fifo_load,
      Q => bid_gets_fifo_load_d1,
      R => \wrap_burst_total_reg[0]\
    );
\bram_addr_b[5]_INST_0_i_11\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"7"
    )
        port map (
      I0 => \^axi_aresetn_d3\,
      I1 => s_axi_arvalid,
      O => \GEN_AWREADY.axi_aresetn_d3_reg_1\
    );
\bvalid_cnt[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0000FFF1FFFE000"
    )
        port map (
      I0 => bvalid_cnt(2),
      I1 => bvalid_cnt(1),
      I2 => s_axi_bready,
      I3 => \^axi_bvalid_int_reg_0\,
      I4 => BID_FIFO_n_0,
      I5 => bvalid_cnt(0),
      O => \bvalid_cnt[0]_i_1_n_0\
    );
\bvalid_cnt[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"D5BF2A40D5BF2A00"
    )
        port map (
      I0 => BID_FIFO_n_0,
      I1 => \^axi_bvalid_int_reg_0\,
      I2 => s_axi_bready,
      I3 => bvalid_cnt(0),
      I4 => bvalid_cnt(1),
      I5 => bvalid_cnt(2),
      O => \bvalid_cnt[1]_i_1_n_0\
    );
\bvalid_cnt[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"D5FFFFBF2A000000"
    )
        port map (
      I0 => BID_FIFO_n_0,
      I1 => \^axi_bvalid_int_reg_0\,
      I2 => s_axi_bready,
      I3 => bvalid_cnt(0),
      I4 => bvalid_cnt(1),
      I5 => bvalid_cnt(2),
      O => \bvalid_cnt[2]_i_1_n_0\
    );
\bvalid_cnt_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \bvalid_cnt[0]_i_1_n_0\,
      Q => bvalid_cnt(0),
      R => \wrap_burst_total_reg[0]\
    );
\bvalid_cnt_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \bvalid_cnt[1]_i_1_n_0\,
      Q => bvalid_cnt(1),
      R => \wrap_burst_total_reg[0]\
    );
\bvalid_cnt_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => \bvalid_cnt[2]_i_1_n_0\,
      Q => bvalid_cnt(2),
      R => \wrap_burst_total_reg[0]\
    );
curr_awlen_reg_1_or_2_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000088888088"
    )
        port map (
      I0 => I_WRAP_BRST_n_19,
      I1 => I_WRAP_BRST_n_20,
      I2 => axi_awaddr_full,
      I3 => s_axi_awvalid,
      I4 => \GEN_AW_PIPE_DUAL.axi_awlen_pipe_1_or_2_i_2_n_0\,
      I5 => curr_awlen_reg_1_or_2_i_2_n_0,
      O => curr_awlen_reg_1_or_20
    );
curr_awlen_reg_1_or_2_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"DDDDDDDDDDDDDDD5"
    )
        port map (
      I0 => I_WRAP_BRST_n_21,
      I1 => axi_awaddr_full,
      I2 => axi_awlen_pipe(5),
      I3 => axi_awlen_pipe(7),
      I4 => axi_awlen_pipe(4),
      I5 => axi_awlen_pipe(6),
      O => curr_awlen_reg_1_or_2_i_2_n_0
    );
curr_awlen_reg_1_or_2_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => bram_addr_ld_en,
      D => curr_awlen_reg_1_or_20,
      Q => curr_awlen_reg_1_or_2,
      R => \wrap_burst_total_reg[0]\
    );
curr_fixed_burst_reg_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"00E2"
    )
        port map (
      I0 => curr_fixed_burst_reg,
      I1 => bram_addr_ld_en,
      I2 => curr_fixed_burst,
      I3 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_1_n_0\,
      O => curr_fixed_burst_reg_i_1_n_0
    );
curr_fixed_burst_reg_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"1010101F"
    )
        port map (
      I0 => axi_awburst_pipe(1),
      I1 => axi_awburst_pipe(0),
      I2 => axi_awaddr_full,
      I3 => s_axi_awburst(1),
      I4 => s_axi_awburst(0),
      O => curr_fixed_burst
    );
curr_fixed_burst_reg_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => curr_fixed_burst_reg_i_1_n_0,
      Q => curr_fixed_burst_reg,
      R => '0'
    );
curr_wrap_burst_reg_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"00E2"
    )
        port map (
      I0 => curr_wrap_burst_reg,
      I1 => bram_addr_ld_en,
      I2 => curr_wrap_burst,
      I3 => \GEN_DUAL_ADDR_CNT.bram_addr_int[15]_i_1_n_0\,
      O => curr_wrap_burst_reg_i_1_n_0
    );
curr_wrap_burst_reg_i_2: unisim.vcomponents.LUT5
    generic map(
      INIT => X"20202F20"
    )
        port map (
      I0 => axi_awburst_pipe(1),
      I1 => axi_awburst_pipe(0),
      I2 => axi_awaddr_full,
      I3 => s_axi_awburst(1),
      I4 => s_axi_awburst(0),
      O => curr_wrap_burst
    );
curr_wrap_burst_reg_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => s_axi_aclk,
      CE => '1',
      D => curr_wrap_burst_reg_i_1_n_0,
      Q => curr_wrap_burst_reg,
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axi64_bram_ctrl_64KiB_full_axi is
  port (
    S_AXI_RVALID : out STD_LOGIC;
    SR : out STD_LOGIC_VECTOR ( 0 to 0 );
    bram_addr_a : out STD_LOGIC_VECTOR ( 12 downto 0 );
    axi_bvalid_int_reg : out STD_LOGIC;
    s_axi_bid : out STD_LOGIC_VECTOR ( 3 downto 0 );
    bram_en_a : out STD_LOGIC;
    bram_we_a : out STD_LOGIC_VECTOR ( 7 downto 0 );
    bram_wrdata_a : out STD_LOGIC_VECTOR ( 63 downto 0 );
    bram_addr_b : out STD_LOGIC_VECTOR ( 12 downto 0 );
    s_axi_rid : out STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awready : out STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    bram_en_b : out STD_LOGIC;
    s_axi_rlast : out STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 12 downto 0 );
    s_axi_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_aclk : in STD_LOGIC;
    s_axi_wlast : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 12 downto 0 );
    s_axi_bready : in STD_LOGIC;
    s_axi_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_awid : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arid : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of axi64_bram_ctrl_64KiB_full_axi : entity is "full_axi";
end axi64_bram_ctrl_64KiB_full_axi;

architecture STRUCTURE of axi64_bram_ctrl_64KiB_full_axi is
  signal I_WR_CHNL_n_68 : STD_LOGIC;
  signal I_WR_CHNL_n_83 : STD_LOGIC;
  signal I_WR_CHNL_n_84 : STD_LOGIC;
  signal \^sr\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal axi_aresetn_d3 : STD_LOGIC;
  signal axi_arready_1st_addr : STD_LOGIC;
begin
  SR(0) <= \^sr\(0);
I_RD_CHNL: entity work.axi64_bram_ctrl_64KiB_rd_chnl
     port map (
      \FSM_sequential_GEN_RD_CMD_OPT.rd_addr_sm_cs_reg_0\ => I_WR_CHNL_n_68,
      \GEN_RD_CMD_OPT.GEN_RDADDR_SM_NORL.axi_arready_1st_addr_reg_0\ => I_WR_CHNL_n_84,
      \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[8]_0\ => bram_addr_b(5),
      \GEN_RD_CMD_OPT.GEN_WO_NARROW.bram_addr_int_reg[9]_0\ => bram_addr_b(6),
      \GEN_RD_CMD_OPT.axi_rvalid_int_reg_0\ => S_AXI_RVALID,
      \GEN_RD_CMD_OPT.wrap_addr_assign_reg_0\ => bram_addr_b(2),
      axi_aresetn_d3 => axi_aresetn_d3,
      axi_arready_1st_addr => axi_arready_1st_addr,
      bram_addr_b(9 downto 4) => bram_addr_b(12 downto 7),
      bram_addr_b(3 downto 2) => bram_addr_b(4 downto 3),
      bram_addr_b(1 downto 0) => bram_addr_b(1 downto 0),
      bram_en_b => bram_en_b,
      s_axi_aclk => s_axi_aclk,
      s_axi_araddr(12 downto 0) => s_axi_araddr(12 downto 0),
      s_axi_arburst(1 downto 0) => s_axi_arburst(1 downto 0),
      s_axi_aresetn => s_axi_aresetn,
      s_axi_aresetn_0 => \^sr\(0),
      s_axi_arid(3 downto 0) => s_axi_arid(3 downto 0),
      s_axi_arlen(7 downto 0) => s_axi_arlen(7 downto 0),
      s_axi_arready => s_axi_arready,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_rid(3 downto 0) => s_axi_rid(3 downto 0),
      s_axi_rlast => s_axi_rlast,
      s_axi_rready => s_axi_rready,
      \wrap_burst_total_reg_reg[2]\ => I_WR_CHNL_n_83
    );
I_WR_CHNL: entity work.axi64_bram_ctrl_64KiB_wr_chnl
     port map (
      \GEN_AWREADY.axi_aresetn_d3_reg_0\ => I_WR_CHNL_n_68,
      \GEN_AWREADY.axi_aresetn_d3_reg_1\ => I_WR_CHNL_n_83,
      Q(12 downto 0) => bram_addr_a(12 downto 0),
      axi_aresetn_d3 => axi_aresetn_d3,
      axi_arready_1st_addr => axi_arready_1st_addr,
      axi_bvalid_int_reg_0 => axi_bvalid_int_reg,
      bram_en_a => bram_en_a,
      bram_we_a(7 downto 0) => bram_we_a(7 downto 0),
      bram_wrdata_a(63 downto 0) => bram_wrdata_a(63 downto 0),
      s_axi_aclk => s_axi_aclk,
      s_axi_aresetn => s_axi_aresetn,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_arvalid_0 => I_WR_CHNL_n_84,
      s_axi_awaddr(12 downto 0) => s_axi_awaddr(12 downto 0),
      s_axi_awburst(1 downto 0) => s_axi_awburst(1 downto 0),
      s_axi_awid(3 downto 0) => s_axi_awid(3 downto 0),
      s_axi_awlen(7 downto 0) => s_axi_awlen(7 downto 0),
      s_axi_awready => s_axi_awready,
      s_axi_awvalid => s_axi_awvalid,
      s_axi_bid(3 downto 0) => s_axi_bid(3 downto 0),
      s_axi_bready => s_axi_bready,
      s_axi_wdata(63 downto 0) => s_axi_wdata(63 downto 0),
      s_axi_wlast => s_axi_wlast,
      s_axi_wready => s_axi_wready,
      s_axi_wstrb(7 downto 0) => s_axi_wstrb(7 downto 0),
      s_axi_wvalid => s_axi_wvalid,
      \wrap_burst_total_reg[0]\ => \^sr\(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axi64_bram_ctrl_64KiB_axi_bram_ctrl_top is
  port (
    S_AXI_RVALID : out STD_LOGIC;
    s_axi_aresetn_0 : out STD_LOGIC;
    bram_addr_a : out STD_LOGIC_VECTOR ( 12 downto 0 );
    axi_bvalid_int_reg : out STD_LOGIC;
    s_axi_bid : out STD_LOGIC_VECTOR ( 3 downto 0 );
    bram_en_a : out STD_LOGIC;
    bram_we_a : out STD_LOGIC_VECTOR ( 7 downto 0 );
    bram_wrdata_a : out STD_LOGIC_VECTOR ( 63 downto 0 );
    bram_addr_b : out STD_LOGIC_VECTOR ( 12 downto 0 );
    s_axi_rid : out STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awready : out STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    bram_en_b : out STD_LOGIC;
    s_axi_rlast : out STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    s_axi_araddr : in STD_LOGIC_VECTOR ( 12 downto 0 );
    s_axi_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_aclk : in STD_LOGIC;
    s_axi_wlast : in STD_LOGIC;
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 12 downto 0 );
    s_axi_bready : in STD_LOGIC;
    s_axi_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_awid : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arid : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of axi64_bram_ctrl_64KiB_axi_bram_ctrl_top : entity is "axi_bram_ctrl_top";
end axi64_bram_ctrl_64KiB_axi_bram_ctrl_top;

architecture STRUCTURE of axi64_bram_ctrl_64KiB_axi_bram_ctrl_top is
begin
\GEN_AXI4.I_FULL_AXI\: entity work.axi64_bram_ctrl_64KiB_full_axi
     port map (
      SR(0) => s_axi_aresetn_0,
      S_AXI_RVALID => S_AXI_RVALID,
      axi_bvalid_int_reg => axi_bvalid_int_reg,
      bram_addr_a(12 downto 0) => bram_addr_a(12 downto 0),
      bram_addr_b(12 downto 0) => bram_addr_b(12 downto 0),
      bram_en_a => bram_en_a,
      bram_en_b => bram_en_b,
      bram_we_a(7 downto 0) => bram_we_a(7 downto 0),
      bram_wrdata_a(63 downto 0) => bram_wrdata_a(63 downto 0),
      s_axi_aclk => s_axi_aclk,
      s_axi_araddr(12 downto 0) => s_axi_araddr(12 downto 0),
      s_axi_arburst(1 downto 0) => s_axi_arburst(1 downto 0),
      s_axi_aresetn => s_axi_aresetn,
      s_axi_arid(3 downto 0) => s_axi_arid(3 downto 0),
      s_axi_arlen(7 downto 0) => s_axi_arlen(7 downto 0),
      s_axi_arready => s_axi_arready,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_awaddr(12 downto 0) => s_axi_awaddr(12 downto 0),
      s_axi_awburst(1 downto 0) => s_axi_awburst(1 downto 0),
      s_axi_awid(3 downto 0) => s_axi_awid(3 downto 0),
      s_axi_awlen(7 downto 0) => s_axi_awlen(7 downto 0),
      s_axi_awready => s_axi_awready,
      s_axi_awvalid => s_axi_awvalid,
      s_axi_bid(3 downto 0) => s_axi_bid(3 downto 0),
      s_axi_bready => s_axi_bready,
      s_axi_rid(3 downto 0) => s_axi_rid(3 downto 0),
      s_axi_rlast => s_axi_rlast,
      s_axi_rready => s_axi_rready,
      s_axi_wdata(63 downto 0) => s_axi_wdata(63 downto 0),
      s_axi_wlast => s_axi_wlast,
      s_axi_wready => s_axi_wready,
      s_axi_wstrb(7 downto 0) => s_axi_wstrb(7 downto 0),
      s_axi_wvalid => s_axi_wvalid
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axi64_bram_ctrl_64KiB_axi_bram_ctrl is
  port (
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    ecc_interrupt : out STD_LOGIC;
    ecc_ue : out STD_LOGIC;
    s_axi_awid : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axi_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_awlock : in STD_LOGIC;
    s_axi_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_wlast : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bid : out STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_arid : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_araddr : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axi_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_arlock : in STD_LOGIC;
    s_axi_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rid : out STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_rdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rlast : out STD_LOGIC;
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    s_axi_ctrl_awvalid : in STD_LOGIC;
    s_axi_ctrl_awready : out STD_LOGIC;
    s_axi_ctrl_awaddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_ctrl_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_ctrl_wvalid : in STD_LOGIC;
    s_axi_ctrl_wready : out STD_LOGIC;
    s_axi_ctrl_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_ctrl_bvalid : out STD_LOGIC;
    s_axi_ctrl_bready : in STD_LOGIC;
    s_axi_ctrl_araddr : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_ctrl_arvalid : in STD_LOGIC;
    s_axi_ctrl_arready : out STD_LOGIC;
    s_axi_ctrl_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s_axi_ctrl_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_ctrl_rvalid : out STD_LOGIC;
    s_axi_ctrl_rready : in STD_LOGIC;
    bram_rst_a : out STD_LOGIC;
    bram_clk_a : out STD_LOGIC;
    bram_en_a : out STD_LOGIC;
    bram_we_a : out STD_LOGIC_VECTOR ( 7 downto 0 );
    bram_addr_a : out STD_LOGIC_VECTOR ( 15 downto 0 );
    bram_wrdata_a : out STD_LOGIC_VECTOR ( 63 downto 0 );
    bram_rddata_a : in STD_LOGIC_VECTOR ( 63 downto 0 );
    bram_rst_b : out STD_LOGIC;
    bram_clk_b : out STD_LOGIC;
    bram_en_b : out STD_LOGIC;
    bram_we_b : out STD_LOGIC_VECTOR ( 7 downto 0 );
    bram_addr_b : out STD_LOGIC_VECTOR ( 15 downto 0 );
    bram_wrdata_b : out STD_LOGIC_VECTOR ( 63 downto 0 );
    bram_rddata_b : in STD_LOGIC_VECTOR ( 63 downto 0 )
  );
  attribute C_BRAM_ADDR_WIDTH : integer;
  attribute C_BRAM_ADDR_WIDTH of axi64_bram_ctrl_64KiB_axi_bram_ctrl : entity is 13;
  attribute C_BRAM_INST_MODE : string;
  attribute C_BRAM_INST_MODE of axi64_bram_ctrl_64KiB_axi_bram_ctrl : entity is "EXTERNAL";
  attribute C_ECC : integer;
  attribute C_ECC of axi64_bram_ctrl_64KiB_axi_bram_ctrl : entity is 0;
  attribute C_ECC_ONOFF_RESET_VALUE : integer;
  attribute C_ECC_ONOFF_RESET_VALUE of axi64_bram_ctrl_64KiB_axi_bram_ctrl : entity is 0;
  attribute C_ECC_TYPE : integer;
  attribute C_ECC_TYPE of axi64_bram_ctrl_64KiB_axi_bram_ctrl : entity is 0;
  attribute C_FAMILY : string;
  attribute C_FAMILY of axi64_bram_ctrl_64KiB_axi_bram_ctrl : entity is "virtex7";
  attribute C_FAULT_INJECT : integer;
  attribute C_FAULT_INJECT of axi64_bram_ctrl_64KiB_axi_bram_ctrl : entity is 0;
  attribute C_MEMORY_DEPTH : integer;
  attribute C_MEMORY_DEPTH of axi64_bram_ctrl_64KiB_axi_bram_ctrl : entity is 8192;
  attribute C_RD_CMD_OPTIMIZATION : integer;
  attribute C_RD_CMD_OPTIMIZATION of axi64_bram_ctrl_64KiB_axi_bram_ctrl : entity is 1;
  attribute C_READ_LATENCY : integer;
  attribute C_READ_LATENCY of axi64_bram_ctrl_64KiB_axi_bram_ctrl : entity is 1;
  attribute C_SINGLE_PORT_BRAM : integer;
  attribute C_SINGLE_PORT_BRAM of axi64_bram_ctrl_64KiB_axi_bram_ctrl : entity is 0;
  attribute C_S_AXI_ADDR_WIDTH : integer;
  attribute C_S_AXI_ADDR_WIDTH of axi64_bram_ctrl_64KiB_axi_bram_ctrl : entity is 16;
  attribute C_S_AXI_CTRL_ADDR_WIDTH : integer;
  attribute C_S_AXI_CTRL_ADDR_WIDTH of axi64_bram_ctrl_64KiB_axi_bram_ctrl : entity is 32;
  attribute C_S_AXI_CTRL_DATA_WIDTH : integer;
  attribute C_S_AXI_CTRL_DATA_WIDTH of axi64_bram_ctrl_64KiB_axi_bram_ctrl : entity is 32;
  attribute C_S_AXI_DATA_WIDTH : integer;
  attribute C_S_AXI_DATA_WIDTH of axi64_bram_ctrl_64KiB_axi_bram_ctrl : entity is 64;
  attribute C_S_AXI_ID_WIDTH : integer;
  attribute C_S_AXI_ID_WIDTH of axi64_bram_ctrl_64KiB_axi_bram_ctrl : entity is 4;
  attribute C_S_AXI_PROTOCOL : string;
  attribute C_S_AXI_PROTOCOL of axi64_bram_ctrl_64KiB_axi_bram_ctrl : entity is "AXI4";
  attribute C_S_AXI_SUPPORTS_NARROW_BURST : integer;
  attribute C_S_AXI_SUPPORTS_NARROW_BURST of axi64_bram_ctrl_64KiB_axi_bram_ctrl : entity is 0;
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of axi64_bram_ctrl_64KiB_axi_bram_ctrl : entity is "axi_bram_ctrl";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of axi64_bram_ctrl_64KiB_axi_bram_ctrl : entity is "yes";
end axi64_bram_ctrl_64KiB_axi_bram_ctrl;

architecture STRUCTURE of axi64_bram_ctrl_64KiB_axi_bram_ctrl is
  signal \<const0>\ : STD_LOGIC;
  signal \^bram_addr_a\ : STD_LOGIC_VECTOR ( 15 downto 3 );
  signal \^bram_addr_b\ : STD_LOGIC_VECTOR ( 15 downto 3 );
  signal \^bram_rddata_b\ : STD_LOGIC_VECTOR ( 63 downto 0 );
  signal \^bram_rst_b\ : STD_LOGIC;
  signal \^s_axi_aclk\ : STD_LOGIC;
begin
  \^bram_rddata_b\(63 downto 0) <= bram_rddata_b(63 downto 0);
  \^s_axi_aclk\ <= s_axi_aclk;
  bram_addr_a(15 downto 3) <= \^bram_addr_a\(15 downto 3);
  bram_addr_a(2) <= \<const0>\;
  bram_addr_a(1) <= \<const0>\;
  bram_addr_a(0) <= \<const0>\;
  bram_addr_b(15 downto 3) <= \^bram_addr_b\(15 downto 3);
  bram_addr_b(2) <= \<const0>\;
  bram_addr_b(1) <= \<const0>\;
  bram_addr_b(0) <= \<const0>\;
  bram_clk_a <= \^s_axi_aclk\;
  bram_clk_b <= \^s_axi_aclk\;
  bram_rst_a <= \^bram_rst_b\;
  bram_rst_b <= \^bram_rst_b\;
  bram_we_b(7) <= \<const0>\;
  bram_we_b(6) <= \<const0>\;
  bram_we_b(5) <= \<const0>\;
  bram_we_b(4) <= \<const0>\;
  bram_we_b(3) <= \<const0>\;
  bram_we_b(2) <= \<const0>\;
  bram_we_b(1) <= \<const0>\;
  bram_we_b(0) <= \<const0>\;
  bram_wrdata_b(63) <= \<const0>\;
  bram_wrdata_b(62) <= \<const0>\;
  bram_wrdata_b(61) <= \<const0>\;
  bram_wrdata_b(60) <= \<const0>\;
  bram_wrdata_b(59) <= \<const0>\;
  bram_wrdata_b(58) <= \<const0>\;
  bram_wrdata_b(57) <= \<const0>\;
  bram_wrdata_b(56) <= \<const0>\;
  bram_wrdata_b(55) <= \<const0>\;
  bram_wrdata_b(54) <= \<const0>\;
  bram_wrdata_b(53) <= \<const0>\;
  bram_wrdata_b(52) <= \<const0>\;
  bram_wrdata_b(51) <= \<const0>\;
  bram_wrdata_b(50) <= \<const0>\;
  bram_wrdata_b(49) <= \<const0>\;
  bram_wrdata_b(48) <= \<const0>\;
  bram_wrdata_b(47) <= \<const0>\;
  bram_wrdata_b(46) <= \<const0>\;
  bram_wrdata_b(45) <= \<const0>\;
  bram_wrdata_b(44) <= \<const0>\;
  bram_wrdata_b(43) <= \<const0>\;
  bram_wrdata_b(42) <= \<const0>\;
  bram_wrdata_b(41) <= \<const0>\;
  bram_wrdata_b(40) <= \<const0>\;
  bram_wrdata_b(39) <= \<const0>\;
  bram_wrdata_b(38) <= \<const0>\;
  bram_wrdata_b(37) <= \<const0>\;
  bram_wrdata_b(36) <= \<const0>\;
  bram_wrdata_b(35) <= \<const0>\;
  bram_wrdata_b(34) <= \<const0>\;
  bram_wrdata_b(33) <= \<const0>\;
  bram_wrdata_b(32) <= \<const0>\;
  bram_wrdata_b(31) <= \<const0>\;
  bram_wrdata_b(30) <= \<const0>\;
  bram_wrdata_b(29) <= \<const0>\;
  bram_wrdata_b(28) <= \<const0>\;
  bram_wrdata_b(27) <= \<const0>\;
  bram_wrdata_b(26) <= \<const0>\;
  bram_wrdata_b(25) <= \<const0>\;
  bram_wrdata_b(24) <= \<const0>\;
  bram_wrdata_b(23) <= \<const0>\;
  bram_wrdata_b(22) <= \<const0>\;
  bram_wrdata_b(21) <= \<const0>\;
  bram_wrdata_b(20) <= \<const0>\;
  bram_wrdata_b(19) <= \<const0>\;
  bram_wrdata_b(18) <= \<const0>\;
  bram_wrdata_b(17) <= \<const0>\;
  bram_wrdata_b(16) <= \<const0>\;
  bram_wrdata_b(15) <= \<const0>\;
  bram_wrdata_b(14) <= \<const0>\;
  bram_wrdata_b(13) <= \<const0>\;
  bram_wrdata_b(12) <= \<const0>\;
  bram_wrdata_b(11) <= \<const0>\;
  bram_wrdata_b(10) <= \<const0>\;
  bram_wrdata_b(9) <= \<const0>\;
  bram_wrdata_b(8) <= \<const0>\;
  bram_wrdata_b(7) <= \<const0>\;
  bram_wrdata_b(6) <= \<const0>\;
  bram_wrdata_b(5) <= \<const0>\;
  bram_wrdata_b(4) <= \<const0>\;
  bram_wrdata_b(3) <= \<const0>\;
  bram_wrdata_b(2) <= \<const0>\;
  bram_wrdata_b(1) <= \<const0>\;
  bram_wrdata_b(0) <= \<const0>\;
  ecc_interrupt <= \<const0>\;
  ecc_ue <= \<const0>\;
  s_axi_bresp(1) <= \<const0>\;
  s_axi_bresp(0) <= \<const0>\;
  s_axi_ctrl_arready <= \<const0>\;
  s_axi_ctrl_awready <= \<const0>\;
  s_axi_ctrl_bresp(1) <= \<const0>\;
  s_axi_ctrl_bresp(0) <= \<const0>\;
  s_axi_ctrl_bvalid <= \<const0>\;
  s_axi_ctrl_rdata(31) <= \<const0>\;
  s_axi_ctrl_rdata(30) <= \<const0>\;
  s_axi_ctrl_rdata(29) <= \<const0>\;
  s_axi_ctrl_rdata(28) <= \<const0>\;
  s_axi_ctrl_rdata(27) <= \<const0>\;
  s_axi_ctrl_rdata(26) <= \<const0>\;
  s_axi_ctrl_rdata(25) <= \<const0>\;
  s_axi_ctrl_rdata(24) <= \<const0>\;
  s_axi_ctrl_rdata(23) <= \<const0>\;
  s_axi_ctrl_rdata(22) <= \<const0>\;
  s_axi_ctrl_rdata(21) <= \<const0>\;
  s_axi_ctrl_rdata(20) <= \<const0>\;
  s_axi_ctrl_rdata(19) <= \<const0>\;
  s_axi_ctrl_rdata(18) <= \<const0>\;
  s_axi_ctrl_rdata(17) <= \<const0>\;
  s_axi_ctrl_rdata(16) <= \<const0>\;
  s_axi_ctrl_rdata(15) <= \<const0>\;
  s_axi_ctrl_rdata(14) <= \<const0>\;
  s_axi_ctrl_rdata(13) <= \<const0>\;
  s_axi_ctrl_rdata(12) <= \<const0>\;
  s_axi_ctrl_rdata(11) <= \<const0>\;
  s_axi_ctrl_rdata(10) <= \<const0>\;
  s_axi_ctrl_rdata(9) <= \<const0>\;
  s_axi_ctrl_rdata(8) <= \<const0>\;
  s_axi_ctrl_rdata(7) <= \<const0>\;
  s_axi_ctrl_rdata(6) <= \<const0>\;
  s_axi_ctrl_rdata(5) <= \<const0>\;
  s_axi_ctrl_rdata(4) <= \<const0>\;
  s_axi_ctrl_rdata(3) <= \<const0>\;
  s_axi_ctrl_rdata(2) <= \<const0>\;
  s_axi_ctrl_rdata(1) <= \<const0>\;
  s_axi_ctrl_rdata(0) <= \<const0>\;
  s_axi_ctrl_rresp(1) <= \<const0>\;
  s_axi_ctrl_rresp(0) <= \<const0>\;
  s_axi_ctrl_rvalid <= \<const0>\;
  s_axi_ctrl_wready <= \<const0>\;
  s_axi_rdata(63 downto 0) <= \^bram_rddata_b\(63 downto 0);
  s_axi_rresp(1) <= \<const0>\;
  s_axi_rresp(0) <= \<const0>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
\gext_inst.abcv4_0_ext_inst\: entity work.axi64_bram_ctrl_64KiB_axi_bram_ctrl_top
     port map (
      S_AXI_RVALID => s_axi_rvalid,
      axi_bvalid_int_reg => s_axi_bvalid,
      bram_addr_a(12 downto 0) => \^bram_addr_a\(15 downto 3),
      bram_addr_b(12 downto 0) => \^bram_addr_b\(15 downto 3),
      bram_en_a => bram_en_a,
      bram_en_b => bram_en_b,
      bram_we_a(7 downto 0) => bram_we_a(7 downto 0),
      bram_wrdata_a(63 downto 0) => bram_wrdata_a(63 downto 0),
      s_axi_aclk => \^s_axi_aclk\,
      s_axi_araddr(12 downto 0) => s_axi_araddr(15 downto 3),
      s_axi_arburst(1 downto 0) => s_axi_arburst(1 downto 0),
      s_axi_aresetn => s_axi_aresetn,
      s_axi_aresetn_0 => \^bram_rst_b\,
      s_axi_arid(3 downto 0) => s_axi_arid(3 downto 0),
      s_axi_arlen(7 downto 0) => s_axi_arlen(7 downto 0),
      s_axi_arready => s_axi_arready,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_awaddr(12 downto 0) => s_axi_awaddr(15 downto 3),
      s_axi_awburst(1 downto 0) => s_axi_awburst(1 downto 0),
      s_axi_awid(3 downto 0) => s_axi_awid(3 downto 0),
      s_axi_awlen(7 downto 0) => s_axi_awlen(7 downto 0),
      s_axi_awready => s_axi_awready,
      s_axi_awvalid => s_axi_awvalid,
      s_axi_bid(3 downto 0) => s_axi_bid(3 downto 0),
      s_axi_bready => s_axi_bready,
      s_axi_rid(3 downto 0) => s_axi_rid(3 downto 0),
      s_axi_rlast => s_axi_rlast,
      s_axi_rready => s_axi_rready,
      s_axi_wdata(63 downto 0) => s_axi_wdata(63 downto 0),
      s_axi_wlast => s_axi_wlast,
      s_axi_wready => s_axi_wready,
      s_axi_wstrb(7 downto 0) => s_axi_wstrb(7 downto 0),
      s_axi_wvalid => s_axi_wvalid
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity axi64_bram_ctrl_64KiB is
  port (
    s_axi_aclk : in STD_LOGIC;
    s_axi_aresetn : in STD_LOGIC;
    s_axi_awid : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awaddr : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axi_awlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_awsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_awlock : in STD_LOGIC;
    s_axi_awcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_awvalid : in STD_LOGIC;
    s_axi_awready : out STD_LOGIC;
    s_axi_wdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axi_wstrb : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_wlast : in STD_LOGIC;
    s_axi_wvalid : in STD_LOGIC;
    s_axi_wready : out STD_LOGIC;
    s_axi_bid : out STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_bvalid : out STD_LOGIC;
    s_axi_bready : in STD_LOGIC;
    s_axi_arid : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_araddr : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s_axi_arlen : in STD_LOGIC_VECTOR ( 7 downto 0 );
    s_axi_arsize : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arburst : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_arlock : in STD_LOGIC;
    s_axi_arcache : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s_axi_arvalid : in STD_LOGIC;
    s_axi_arready : out STD_LOGIC;
    s_axi_rid : out STD_LOGIC_VECTOR ( 3 downto 0 );
    s_axi_rdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
    s_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s_axi_rlast : out STD_LOGIC;
    s_axi_rvalid : out STD_LOGIC;
    s_axi_rready : in STD_LOGIC;
    bram_rst_a : out STD_LOGIC;
    bram_clk_a : out STD_LOGIC;
    bram_en_a : out STD_LOGIC;
    bram_we_a : out STD_LOGIC_VECTOR ( 7 downto 0 );
    bram_addr_a : out STD_LOGIC_VECTOR ( 15 downto 0 );
    bram_wrdata_a : out STD_LOGIC_VECTOR ( 63 downto 0 );
    bram_rddata_a : in STD_LOGIC_VECTOR ( 63 downto 0 );
    bram_rst_b : out STD_LOGIC;
    bram_clk_b : out STD_LOGIC;
    bram_en_b : out STD_LOGIC;
    bram_we_b : out STD_LOGIC_VECTOR ( 7 downto 0 );
    bram_addr_b : out STD_LOGIC_VECTOR ( 15 downto 0 );
    bram_wrdata_b : out STD_LOGIC_VECTOR ( 63 downto 0 );
    bram_rddata_b : in STD_LOGIC_VECTOR ( 63 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of axi64_bram_ctrl_64KiB : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of axi64_bram_ctrl_64KiB : entity is "axi64_bram_ctrl_64KiB,axi_bram_ctrl,{}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of axi64_bram_ctrl_64KiB : entity is "yes";
  attribute x_core_info : string;
  attribute x_core_info of axi64_bram_ctrl_64KiB : entity is "axi_bram_ctrl,Vivado 2020.1";
end axi64_bram_ctrl_64KiB;

architecture STRUCTURE of axi64_bram_ctrl_64KiB is
  signal NLW_U0_ecc_interrupt_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_ecc_ue_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_ctrl_arready_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_ctrl_awready_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_ctrl_bvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_ctrl_rvalid_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_ctrl_wready_UNCONNECTED : STD_LOGIC;
  signal NLW_U0_s_axi_ctrl_bresp_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  signal NLW_U0_s_axi_ctrl_rdata_UNCONNECTED : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal NLW_U0_s_axi_ctrl_rresp_UNCONNECTED : STD_LOGIC_VECTOR ( 1 downto 0 );
  attribute C_BRAM_ADDR_WIDTH : integer;
  attribute C_BRAM_ADDR_WIDTH of U0 : label is 13;
  attribute C_BRAM_INST_MODE : string;
  attribute C_BRAM_INST_MODE of U0 : label is "EXTERNAL";
  attribute C_ECC : integer;
  attribute C_ECC of U0 : label is 0;
  attribute C_ECC_ONOFF_RESET_VALUE : integer;
  attribute C_ECC_ONOFF_RESET_VALUE of U0 : label is 0;
  attribute C_ECC_TYPE : integer;
  attribute C_ECC_TYPE of U0 : label is 0;
  attribute C_FAMILY : string;
  attribute C_FAMILY of U0 : label is "virtex7";
  attribute C_FAULT_INJECT : integer;
  attribute C_FAULT_INJECT of U0 : label is 0;
  attribute C_MEMORY_DEPTH : integer;
  attribute C_MEMORY_DEPTH of U0 : label is 8192;
  attribute C_RD_CMD_OPTIMIZATION : integer;
  attribute C_RD_CMD_OPTIMIZATION of U0 : label is 1;
  attribute C_READ_LATENCY : integer;
  attribute C_READ_LATENCY of U0 : label is 1;
  attribute C_SINGLE_PORT_BRAM : integer;
  attribute C_SINGLE_PORT_BRAM of U0 : label is 0;
  attribute C_S_AXI_ADDR_WIDTH : integer;
  attribute C_S_AXI_ADDR_WIDTH of U0 : label is 16;
  attribute C_S_AXI_CTRL_ADDR_WIDTH : integer;
  attribute C_S_AXI_CTRL_ADDR_WIDTH of U0 : label is 32;
  attribute C_S_AXI_CTRL_DATA_WIDTH : integer;
  attribute C_S_AXI_CTRL_DATA_WIDTH of U0 : label is 32;
  attribute C_S_AXI_DATA_WIDTH : integer;
  attribute C_S_AXI_DATA_WIDTH of U0 : label is 64;
  attribute C_S_AXI_ID_WIDTH : integer;
  attribute C_S_AXI_ID_WIDTH of U0 : label is 4;
  attribute C_S_AXI_PROTOCOL : string;
  attribute C_S_AXI_PROTOCOL of U0 : label is "AXI4";
  attribute C_S_AXI_SUPPORTS_NARROW_BURST : integer;
  attribute C_S_AXI_SUPPORTS_NARROW_BURST of U0 : label is 0;
  attribute downgradeipidentifiedwarnings of U0 : label is "yes";
  attribute x_interface_info : string;
  attribute x_interface_info of bram_clk_a : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK";
  attribute x_interface_info of bram_clk_b : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK";
  attribute x_interface_info of bram_en_a : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTA EN";
  attribute x_interface_info of bram_en_b : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTB EN";
  attribute x_interface_info of bram_rst_a : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTA RST";
  attribute x_interface_parameter : string;
  attribute x_interface_parameter of bram_rst_a : signal is "XIL_INTERFACENAME BRAM_PORTA, MASTER_TYPE BRAM_CTRL, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, READ_LATENCY 1";
  attribute x_interface_info of bram_rst_b : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTB RST";
  attribute x_interface_parameter of bram_rst_b : signal is "XIL_INTERFACENAME BRAM_PORTB, MASTER_TYPE BRAM_CTRL, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, READ_LATENCY 1";
  attribute x_interface_info of s_axi_aclk : signal is "xilinx.com:signal:clock:1.0 CLKIF CLK";
  attribute x_interface_parameter of s_axi_aclk : signal is "XIL_INTERFACENAME CLKIF, ASSOCIATED_BUSIF S_AXI:S_AXI_CTRL, ASSOCIATED_RESET s_axi_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, INSERT_VIP 0";
  attribute x_interface_info of s_axi_aresetn : signal is "xilinx.com:signal:reset:1.0 RSTIF RST";
  attribute x_interface_parameter of s_axi_aresetn : signal is "XIL_INTERFACENAME RSTIF, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute x_interface_info of s_axi_arlock : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARLOCK";
  attribute x_interface_info of s_axi_arready : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARREADY";
  attribute x_interface_info of s_axi_arvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARVALID";
  attribute x_interface_info of s_axi_awlock : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWLOCK";
  attribute x_interface_info of s_axi_awready : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWREADY";
  attribute x_interface_info of s_axi_awvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWVALID";
  attribute x_interface_info of s_axi_bready : signal is "xilinx.com:interface:aximm:1.0 S_AXI BREADY";
  attribute x_interface_info of s_axi_bvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI BVALID";
  attribute x_interface_info of s_axi_rlast : signal is "xilinx.com:interface:aximm:1.0 S_AXI RLAST";
  attribute x_interface_info of s_axi_rready : signal is "xilinx.com:interface:aximm:1.0 S_AXI RREADY";
  attribute x_interface_info of s_axi_rvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI RVALID";
  attribute x_interface_info of s_axi_wlast : signal is "xilinx.com:interface:aximm:1.0 S_AXI WLAST";
  attribute x_interface_info of s_axi_wready : signal is "xilinx.com:interface:aximm:1.0 S_AXI WREADY";
  attribute x_interface_info of s_axi_wvalid : signal is "xilinx.com:interface:aximm:1.0 S_AXI WVALID";
  attribute x_interface_info of bram_addr_a : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR";
  attribute x_interface_info of bram_addr_b : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR";
  attribute x_interface_info of bram_rddata_a : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT";
  attribute x_interface_info of bram_rddata_b : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT";
  attribute x_interface_info of bram_we_a : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTA WE";
  attribute x_interface_info of bram_we_b : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTB WE";
  attribute x_interface_info of bram_wrdata_a : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN";
  attribute x_interface_info of bram_wrdata_b : signal is "xilinx.com:interface:bram:1.0 BRAM_PORTB DIN";
  attribute x_interface_info of s_axi_araddr : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARADDR";
  attribute x_interface_info of s_axi_arburst : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARBURST";
  attribute x_interface_info of s_axi_arcache : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARCACHE";
  attribute x_interface_info of s_axi_arid : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARID";
  attribute x_interface_info of s_axi_arlen : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARLEN";
  attribute x_interface_info of s_axi_arprot : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARPROT";
  attribute x_interface_info of s_axi_arsize : signal is "xilinx.com:interface:aximm:1.0 S_AXI ARSIZE";
  attribute x_interface_info of s_axi_awaddr : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWADDR";
  attribute x_interface_info of s_axi_awburst : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWBURST";
  attribute x_interface_info of s_axi_awcache : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWCACHE";
  attribute x_interface_info of s_axi_awid : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWID";
  attribute x_interface_parameter of s_axi_awid : signal is "XIL_INTERFACENAME S_AXI, DATA_WIDTH 64, PROTOCOL AXI4, FREQ_HZ 100000000, ID_WIDTH 4, ADDR_WIDTH 16, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 1, HAS_LOCK 1, HAS_PROT 1, HAS_CACHE 1, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, SUPPORTS_NARROW_BURST 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 256, PHASE 0.000, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute x_interface_info of s_axi_awlen : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWLEN";
  attribute x_interface_info of s_axi_awprot : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWPROT";
  attribute x_interface_info of s_axi_awsize : signal is "xilinx.com:interface:aximm:1.0 S_AXI AWSIZE";
  attribute x_interface_info of s_axi_bid : signal is "xilinx.com:interface:aximm:1.0 S_AXI BID";
  attribute x_interface_info of s_axi_bresp : signal is "xilinx.com:interface:aximm:1.0 S_AXI BRESP";
  attribute x_interface_info of s_axi_rdata : signal is "xilinx.com:interface:aximm:1.0 S_AXI RDATA";
  attribute x_interface_info of s_axi_rid : signal is "xilinx.com:interface:aximm:1.0 S_AXI RID";
  attribute x_interface_info of s_axi_rresp : signal is "xilinx.com:interface:aximm:1.0 S_AXI RRESP";
  attribute x_interface_info of s_axi_wdata : signal is "xilinx.com:interface:aximm:1.0 S_AXI WDATA";
  attribute x_interface_info of s_axi_wstrb : signal is "xilinx.com:interface:aximm:1.0 S_AXI WSTRB";
begin
U0: entity work.axi64_bram_ctrl_64KiB_axi_bram_ctrl
     port map (
      bram_addr_a(15 downto 0) => bram_addr_a(15 downto 0),
      bram_addr_b(15 downto 0) => bram_addr_b(15 downto 0),
      bram_clk_a => bram_clk_a,
      bram_clk_b => bram_clk_b,
      bram_en_a => bram_en_a,
      bram_en_b => bram_en_b,
      bram_rddata_a(63 downto 0) => bram_rddata_a(63 downto 0),
      bram_rddata_b(63 downto 0) => bram_rddata_b(63 downto 0),
      bram_rst_a => bram_rst_a,
      bram_rst_b => bram_rst_b,
      bram_we_a(7 downto 0) => bram_we_a(7 downto 0),
      bram_we_b(7 downto 0) => bram_we_b(7 downto 0),
      bram_wrdata_a(63 downto 0) => bram_wrdata_a(63 downto 0),
      bram_wrdata_b(63 downto 0) => bram_wrdata_b(63 downto 0),
      ecc_interrupt => NLW_U0_ecc_interrupt_UNCONNECTED,
      ecc_ue => NLW_U0_ecc_ue_UNCONNECTED,
      s_axi_aclk => s_axi_aclk,
      s_axi_araddr(15 downto 0) => s_axi_araddr(15 downto 0),
      s_axi_arburst(1 downto 0) => s_axi_arburst(1 downto 0),
      s_axi_arcache(3 downto 0) => s_axi_arcache(3 downto 0),
      s_axi_aresetn => s_axi_aresetn,
      s_axi_arid(3 downto 0) => s_axi_arid(3 downto 0),
      s_axi_arlen(7 downto 0) => s_axi_arlen(7 downto 0),
      s_axi_arlock => s_axi_arlock,
      s_axi_arprot(2 downto 0) => s_axi_arprot(2 downto 0),
      s_axi_arready => s_axi_arready,
      s_axi_arsize(2 downto 0) => s_axi_arsize(2 downto 0),
      s_axi_arvalid => s_axi_arvalid,
      s_axi_awaddr(15 downto 0) => s_axi_awaddr(15 downto 0),
      s_axi_awburst(1 downto 0) => s_axi_awburst(1 downto 0),
      s_axi_awcache(3 downto 0) => s_axi_awcache(3 downto 0),
      s_axi_awid(3 downto 0) => s_axi_awid(3 downto 0),
      s_axi_awlen(7 downto 0) => s_axi_awlen(7 downto 0),
      s_axi_awlock => s_axi_awlock,
      s_axi_awprot(2 downto 0) => s_axi_awprot(2 downto 0),
      s_axi_awready => s_axi_awready,
      s_axi_awsize(2 downto 0) => s_axi_awsize(2 downto 0),
      s_axi_awvalid => s_axi_awvalid,
      s_axi_bid(3 downto 0) => s_axi_bid(3 downto 0),
      s_axi_bready => s_axi_bready,
      s_axi_bresp(1 downto 0) => s_axi_bresp(1 downto 0),
      s_axi_bvalid => s_axi_bvalid,
      s_axi_ctrl_araddr(31 downto 0) => B"00000000000000000000000000000000",
      s_axi_ctrl_arready => NLW_U0_s_axi_ctrl_arready_UNCONNECTED,
      s_axi_ctrl_arvalid => '0',
      s_axi_ctrl_awaddr(31 downto 0) => B"00000000000000000000000000000000",
      s_axi_ctrl_awready => NLW_U0_s_axi_ctrl_awready_UNCONNECTED,
      s_axi_ctrl_awvalid => '0',
      s_axi_ctrl_bready => '0',
      s_axi_ctrl_bresp(1 downto 0) => NLW_U0_s_axi_ctrl_bresp_UNCONNECTED(1 downto 0),
      s_axi_ctrl_bvalid => NLW_U0_s_axi_ctrl_bvalid_UNCONNECTED,
      s_axi_ctrl_rdata(31 downto 0) => NLW_U0_s_axi_ctrl_rdata_UNCONNECTED(31 downto 0),
      s_axi_ctrl_rready => '0',
      s_axi_ctrl_rresp(1 downto 0) => NLW_U0_s_axi_ctrl_rresp_UNCONNECTED(1 downto 0),
      s_axi_ctrl_rvalid => NLW_U0_s_axi_ctrl_rvalid_UNCONNECTED,
      s_axi_ctrl_wdata(31 downto 0) => B"00000000000000000000000000000000",
      s_axi_ctrl_wready => NLW_U0_s_axi_ctrl_wready_UNCONNECTED,
      s_axi_ctrl_wvalid => '0',
      s_axi_rdata(63 downto 0) => s_axi_rdata(63 downto 0),
      s_axi_rid(3 downto 0) => s_axi_rid(3 downto 0),
      s_axi_rlast => s_axi_rlast,
      s_axi_rready => s_axi_rready,
      s_axi_rresp(1 downto 0) => s_axi_rresp(1 downto 0),
      s_axi_rvalid => s_axi_rvalid,
      s_axi_wdata(63 downto 0) => s_axi_wdata(63 downto 0),
      s_axi_wlast => s_axi_wlast,
      s_axi_wready => s_axi_wready,
      s_axi_wstrb(7 downto 0) => s_axi_wstrb(7 downto 0),
      s_axi_wvalid => s_axi_wvalid
    );
end STRUCTURE;
