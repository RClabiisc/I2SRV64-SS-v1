-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.1 (lin64) Build 2902540 Wed May 27 19:54:35 MDT 2020
-- Date        : Wed Mar  2 16:43:07 2022
-- Host        : rclab-H410M-H running 64-bit Ubuntu 20.04.3 LTS
-- Command     : write_vhdl -force -mode funcsim /home/anuj/work_sajin/RISCV/IP/rst_ctrl/rst_ctrl_sim_netlist.vhdl
-- Design      : rst_ctrl
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7vx485tffg1761-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rst_ctrl_cdc_sync is
  port (
    lpf_asr_reg : out STD_LOGIC;
    scndry_out : out STD_LOGIC;
    lpf_asr : in STD_LOGIC;
    lpf_asr_reg_0 : in STD_LOGIC;
    asr_lpf : in STD_LOGIC_VECTOR ( 0 to 0 );
    p_2_in : in STD_LOGIC;
    p_1_in : in STD_LOGIC;
    lpf_asr_reg_1 : in STD_LOGIC;
    lpf_asr_reg_2 : in STD_LOGIC;
    lpf_asr_reg_3 : in STD_LOGIC;
    aux_reset_in : in STD_LOGIC;
    slowest_sync_clk : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of rst_ctrl_cdc_sync : entity is "cdc_sync";
end rst_ctrl_cdc_sync;

architecture STRUCTURE of rst_ctrl_cdc_sync is
  signal asr_nand : STD_LOGIC;
  signal lpf_asr_i_2_n_0 : STD_LOGIC;
  signal s_level_out_d1_cdc_to : STD_LOGIC;
  signal s_level_out_d2 : STD_LOGIC;
  signal s_level_out_d3 : STD_LOGIC;
  signal \^scndry_out\ : STD_LOGIC;
  attribute ASYNC_REG : boolean;
  attribute ASYNC_REG of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_IN_cdc_to\ : label is std.standard.true;
  attribute XILINX_LEGACY_PRIM : string;
  attribute XILINX_LEGACY_PRIM of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_IN_cdc_to\ : label is "FDR";
  attribute box_type : string;
  attribute box_type of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_IN_cdc_to\ : label is "PRIMITIVE";
  attribute ASYNC_REG of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d2\ : label is std.standard.true;
  attribute XILINX_LEGACY_PRIM of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d2\ : label is "FDR";
  attribute box_type of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d2\ : label is "PRIMITIVE";
  attribute ASYNC_REG of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d3\ : label is std.standard.true;
  attribute XILINX_LEGACY_PRIM of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d3\ : label is "FDR";
  attribute box_type of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d3\ : label is "PRIMITIVE";
  attribute ASYNC_REG of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d4\ : label is std.standard.true;
  attribute XILINX_LEGACY_PRIM of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d4\ : label is "FDR";
  attribute box_type of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d4\ : label is "PRIMITIVE";
begin
  scndry_out <= \^scndry_out\;
\GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_IN_cdc_to\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => aux_reset_in,
      Q => s_level_out_d1_cdc_to,
      R => '0'
    );
\GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d2\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => s_level_out_d1_cdc_to,
      Q => s_level_out_d2,
      R => '0'
    );
\GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d3\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => s_level_out_d2,
      Q => s_level_out_d3,
      R => '0'
    );
\GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d4\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => s_level_out_d3,
      Q => \^scndry_out\,
      R => '0'
    );
lpf_asr_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"BA"
    )
        port map (
      I0 => lpf_asr_i_2_n_0,
      I1 => asr_nand,
      I2 => lpf_asr,
      O => lpf_asr_reg
    );
lpf_asr_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000000000000000"
    )
        port map (
      I0 => lpf_asr_reg_0,
      I1 => asr_lpf(0),
      I2 => \^scndry_out\,
      I3 => p_2_in,
      I4 => p_1_in,
      I5 => lpf_asr_reg_1,
      O => lpf_asr_i_2_n_0
    );
lpf_asr_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000200000000"
    )
        port map (
      I0 => lpf_asr_reg_2,
      I1 => asr_lpf(0),
      I2 => \^scndry_out\,
      I3 => p_2_in,
      I4 => p_1_in,
      I5 => lpf_asr_reg_3,
      O => asr_nand
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rst_ctrl_cdc_sync_0 is
  port (
    lpf_exr_reg : out STD_LOGIC;
    scndry_out : out STD_LOGIC;
    ext_reset_in : in STD_LOGIC;
    mb_debug_sys_rst : in STD_LOGIC;
    lpf_exr : in STD_LOGIC;
    lpf_exr_reg_0 : in STD_LOGIC;
    exr_lpf : in STD_LOGIC_VECTOR ( 0 to 0 );
    p_2_in15_in : in STD_LOGIC;
    p_1_in16_in : in STD_LOGIC;
    lpf_exr_reg_1 : in STD_LOGIC;
    lpf_exr_reg_2 : in STD_LOGIC;
    lpf_exr_reg_3 : in STD_LOGIC;
    slowest_sync_clk : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of rst_ctrl_cdc_sync_0 : entity is "cdc_sync";
end rst_ctrl_cdc_sync_0;

architecture STRUCTURE of rst_ctrl_cdc_sync_0 is
  signal exr_d1 : STD_LOGIC;
  signal exr_nand : STD_LOGIC;
  signal lpf_exr_i_2_n_0 : STD_LOGIC;
  signal s_level_out_d1_cdc_to : STD_LOGIC;
  signal s_level_out_d2 : STD_LOGIC;
  signal s_level_out_d3 : STD_LOGIC;
  signal \^scndry_out\ : STD_LOGIC;
  attribute ASYNC_REG : boolean;
  attribute ASYNC_REG of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_IN_cdc_to\ : label is std.standard.true;
  attribute XILINX_LEGACY_PRIM : string;
  attribute XILINX_LEGACY_PRIM of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_IN_cdc_to\ : label is "FDR";
  attribute box_type : string;
  attribute box_type of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_IN_cdc_to\ : label is "PRIMITIVE";
  attribute ASYNC_REG of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d2\ : label is std.standard.true;
  attribute XILINX_LEGACY_PRIM of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d2\ : label is "FDR";
  attribute box_type of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d2\ : label is "PRIMITIVE";
  attribute ASYNC_REG of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d3\ : label is std.standard.true;
  attribute XILINX_LEGACY_PRIM of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d3\ : label is "FDR";
  attribute box_type of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d3\ : label is "PRIMITIVE";
  attribute ASYNC_REG of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d4\ : label is std.standard.true;
  attribute XILINX_LEGACY_PRIM of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d4\ : label is "FDR";
  attribute box_type of \GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d4\ : label is "PRIMITIVE";
begin
  scndry_out <= \^scndry_out\;
\GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_IN_cdc_to\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => exr_d1,
      Q => s_level_out_d1_cdc_to,
      R => '0'
    );
\GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_IN_cdc_to_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => ext_reset_in,
      I1 => mb_debug_sys_rst,
      O => exr_d1
    );
\GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d2\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => s_level_out_d1_cdc_to,
      Q => s_level_out_d2,
      R => '0'
    );
\GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d3\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => s_level_out_d2,
      Q => s_level_out_d3,
      R => '0'
    );
\GENERATE_LEVEL_P_S_CDC.SINGLE_BIT.CROSS_PLEVEL_IN2SCNDRY_s_level_out_d4\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => s_level_out_d3,
      Q => \^scndry_out\,
      R => '0'
    );
lpf_exr_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"BA"
    )
        port map (
      I0 => lpf_exr_i_2_n_0,
      I1 => exr_nand,
      I2 => lpf_exr,
      O => lpf_exr_reg
    );
lpf_exr_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000000000000000"
    )
        port map (
      I0 => lpf_exr_reg_0,
      I1 => exr_lpf(0),
      I2 => \^scndry_out\,
      I3 => p_2_in15_in,
      I4 => p_1_in16_in,
      I5 => lpf_exr_reg_1,
      O => lpf_exr_i_2_n_0
    );
lpf_exr_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000200000000"
    )
        port map (
      I0 => lpf_exr_reg_2,
      I1 => exr_lpf(0),
      I2 => \^scndry_out\,
      I3 => p_2_in15_in,
      I4 => p_1_in16_in,
      I5 => lpf_exr_reg_3,
      O => exr_nand
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rst_ctrl_upcnt_n is
  port (
    Q : out STD_LOGIC_VECTOR ( 5 downto 0 );
    seq_clr : in STD_LOGIC;
    seq_cnt_en : in STD_LOGIC;
    slowest_sync_clk : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of rst_ctrl_upcnt_n : entity is "upcnt_n";
end rst_ctrl_upcnt_n;

architecture STRUCTURE of rst_ctrl_upcnt_n is
  signal \^q\ : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal clear : STD_LOGIC;
  signal q_int0 : STD_LOGIC_VECTOR ( 5 downto 0 );
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \q_int[1]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \q_int[2]_i_1\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \q_int[3]_i_1\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \q_int[4]_i_1\ : label is "soft_lutpair0";
begin
  Q(5 downto 0) <= \^q\(5 downto 0);
\q_int[0]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^q\(0),
      O => q_int0(0)
    );
\q_int[1]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \^q\(0),
      I1 => \^q\(1),
      O => q_int0(1)
    );
\q_int[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"78"
    )
        port map (
      I0 => \^q\(0),
      I1 => \^q\(1),
      I2 => \^q\(2),
      O => q_int0(2)
    );
\q_int[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7F80"
    )
        port map (
      I0 => \^q\(1),
      I1 => \^q\(0),
      I2 => \^q\(2),
      I3 => \^q\(3),
      O => q_int0(3)
    );
\q_int[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"7FFF8000"
    )
        port map (
      I0 => \^q\(2),
      I1 => \^q\(0),
      I2 => \^q\(1),
      I3 => \^q\(3),
      I4 => \^q\(4),
      O => q_int0(4)
    );
\q_int[5]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => seq_clr,
      O => clear
    );
\q_int[5]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7FFFFFFF80000000"
    )
        port map (
      I0 => \^q\(3),
      I1 => \^q\(1),
      I2 => \^q\(0),
      I3 => \^q\(2),
      I4 => \^q\(4),
      I5 => \^q\(5),
      O => q_int0(5)
    );
\q_int_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '1'
    )
        port map (
      C => slowest_sync_clk,
      CE => seq_cnt_en,
      D => q_int0(0),
      Q => \^q\(0),
      R => clear
    );
\q_int_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '1'
    )
        port map (
      C => slowest_sync_clk,
      CE => seq_cnt_en,
      D => q_int0(1),
      Q => \^q\(1),
      R => clear
    );
\q_int_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '1'
    )
        port map (
      C => slowest_sync_clk,
      CE => seq_cnt_en,
      D => q_int0(2),
      Q => \^q\(2),
      R => clear
    );
\q_int_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '1'
    )
        port map (
      C => slowest_sync_clk,
      CE => seq_cnt_en,
      D => q_int0(3),
      Q => \^q\(3),
      R => clear
    );
\q_int_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '1'
    )
        port map (
      C => slowest_sync_clk,
      CE => seq_cnt_en,
      D => q_int0(4),
      Q => \^q\(4),
      R => clear
    );
\q_int_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '1'
    )
        port map (
      C => slowest_sync_clk,
      CE => seq_cnt_en,
      D => q_int0(5),
      Q => \^q\(5),
      R => clear
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rst_ctrl_lpf is
  port (
    lpf_int : out STD_LOGIC;
    slowest_sync_clk : in STD_LOGIC;
    dcm_locked : in STD_LOGIC;
    ext_reset_in : in STD_LOGIC;
    mb_debug_sys_rst : in STD_LOGIC;
    aux_reset_in : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of rst_ctrl_lpf : entity is "lpf";
end rst_ctrl_lpf;

architecture STRUCTURE of rst_ctrl_lpf is
  signal \ACTIVE_HIGH_AUX.ACT_HI_AUX_n_0\ : STD_LOGIC;
  signal \ACTIVE_HIGH_EXT.ACT_HI_EXT_n_0\ : STD_LOGIC;
  signal Q : STD_LOGIC;
  signal asr_lpf : STD_LOGIC_VECTOR ( 0 to 0 );
  signal exr_lpf : STD_LOGIC_VECTOR ( 0 to 0 );
  signal lpf_asr : STD_LOGIC;
  signal lpf_asr_i_4_n_0 : STD_LOGIC;
  signal lpf_asr_i_5_n_0 : STD_LOGIC;
  signal lpf_asr_i_6_n_0 : STD_LOGIC;
  signal lpf_asr_i_7_n_0 : STD_LOGIC;
  signal lpf_exr : STD_LOGIC;
  signal lpf_exr_i_4_n_0 : STD_LOGIC;
  signal lpf_exr_i_5_n_0 : STD_LOGIC;
  signal lpf_exr_i_6_n_0 : STD_LOGIC;
  signal lpf_exr_i_7_n_0 : STD_LOGIC;
  signal \lpf_int0__0\ : STD_LOGIC;
  signal p_10_in : STD_LOGIC;
  signal p_10_in7_in : STD_LOGIC;
  signal p_11_in : STD_LOGIC;
  signal p_11_in6_in : STD_LOGIC;
  signal p_12_in : STD_LOGIC;
  signal p_12_in5_in : STD_LOGIC;
  signal p_13_in : STD_LOGIC;
  signal p_13_in4_in : STD_LOGIC;
  signal p_14_in : STD_LOGIC;
  signal p_14_in3_in : STD_LOGIC;
  signal p_15_in18_in : STD_LOGIC;
  signal p_15_in1_in : STD_LOGIC;
  signal p_1_in : STD_LOGIC;
  signal p_1_in16_in : STD_LOGIC;
  signal p_2_in : STD_LOGIC;
  signal p_2_in15_in : STD_LOGIC;
  signal p_3_in : STD_LOGIC;
  signal p_3_in14_in : STD_LOGIC;
  signal p_4_in : STD_LOGIC;
  signal p_4_in13_in : STD_LOGIC;
  signal p_5_in : STD_LOGIC;
  signal p_5_in12_in : STD_LOGIC;
  signal p_6_in : STD_LOGIC;
  signal p_6_in11_in : STD_LOGIC;
  signal p_7_in : STD_LOGIC;
  signal p_7_in10_in : STD_LOGIC;
  signal p_8_in : STD_LOGIC;
  signal p_8_in9_in : STD_LOGIC;
  signal p_9_in : STD_LOGIC;
  signal p_9_in8_in : STD_LOGIC;
  attribute XILINX_LEGACY_PRIM : string;
  attribute XILINX_LEGACY_PRIM of POR_SRL_I : label is "SRL16";
  attribute box_type : string;
  attribute box_type of POR_SRL_I : label is "PRIMITIVE";
  attribute srl_name : string;
  attribute srl_name of POR_SRL_I : label is "U0/\EXT_LPF/POR_SRL_I ";
begin
\ACTIVE_HIGH_AUX.ACT_HI_AUX\: entity work.rst_ctrl_cdc_sync
     port map (
      asr_lpf(0) => asr_lpf(0),
      aux_reset_in => aux_reset_in,
      lpf_asr => lpf_asr,
      lpf_asr_reg => \ACTIVE_HIGH_AUX.ACT_HI_AUX_n_0\,
      lpf_asr_reg_0 => lpf_asr_i_4_n_0,
      lpf_asr_reg_1 => lpf_asr_i_5_n_0,
      lpf_asr_reg_2 => lpf_asr_i_6_n_0,
      lpf_asr_reg_3 => lpf_asr_i_7_n_0,
      p_1_in => p_1_in,
      p_2_in => p_2_in,
      scndry_out => p_15_in1_in,
      slowest_sync_clk => slowest_sync_clk
    );
\ACTIVE_HIGH_EXT.ACT_HI_EXT\: entity work.rst_ctrl_cdc_sync_0
     port map (
      exr_lpf(0) => exr_lpf(0),
      ext_reset_in => ext_reset_in,
      lpf_exr => lpf_exr,
      lpf_exr_reg => \ACTIVE_HIGH_EXT.ACT_HI_EXT_n_0\,
      lpf_exr_reg_0 => lpf_exr_i_4_n_0,
      lpf_exr_reg_1 => lpf_exr_i_5_n_0,
      lpf_exr_reg_2 => lpf_exr_i_6_n_0,
      lpf_exr_reg_3 => lpf_exr_i_7_n_0,
      mb_debug_sys_rst => mb_debug_sys_rst,
      p_1_in16_in => p_1_in16_in,
      p_2_in15_in => p_2_in15_in,
      scndry_out => p_15_in18_in,
      slowest_sync_clk => slowest_sync_clk
    );
\AUX_LPF[10].asr_lpf_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_6_in,
      Q => p_5_in,
      R => '0'
    );
\AUX_LPF[11].asr_lpf_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_5_in,
      Q => p_4_in,
      R => '0'
    );
\AUX_LPF[12].asr_lpf_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_4_in,
      Q => p_3_in,
      R => '0'
    );
\AUX_LPF[13].asr_lpf_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_3_in,
      Q => p_2_in,
      R => '0'
    );
\AUX_LPF[14].asr_lpf_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_2_in,
      Q => p_1_in,
      R => '0'
    );
\AUX_LPF[15].asr_lpf_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_1_in,
      Q => asr_lpf(0),
      R => '0'
    );
\AUX_LPF[1].asr_lpf_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_15_in1_in,
      Q => p_14_in,
      R => '0'
    );
\AUX_LPF[2].asr_lpf_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_14_in,
      Q => p_13_in,
      R => '0'
    );
\AUX_LPF[3].asr_lpf_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_13_in,
      Q => p_12_in,
      R => '0'
    );
\AUX_LPF[4].asr_lpf_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_12_in,
      Q => p_11_in,
      R => '0'
    );
\AUX_LPF[5].asr_lpf_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_11_in,
      Q => p_10_in,
      R => '0'
    );
\AUX_LPF[6].asr_lpf_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_10_in,
      Q => p_9_in,
      R => '0'
    );
\AUX_LPF[7].asr_lpf_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_9_in,
      Q => p_8_in,
      R => '0'
    );
\AUX_LPF[8].asr_lpf_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_8_in,
      Q => p_7_in,
      R => '0'
    );
\AUX_LPF[9].asr_lpf_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_7_in,
      Q => p_6_in,
      R => '0'
    );
\EXT_LPF[10].exr_lpf_reg[10]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_6_in11_in,
      Q => p_5_in12_in,
      R => '0'
    );
\EXT_LPF[11].exr_lpf_reg[11]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_5_in12_in,
      Q => p_4_in13_in,
      R => '0'
    );
\EXT_LPF[12].exr_lpf_reg[12]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_4_in13_in,
      Q => p_3_in14_in,
      R => '0'
    );
\EXT_LPF[13].exr_lpf_reg[13]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_3_in14_in,
      Q => p_2_in15_in,
      R => '0'
    );
\EXT_LPF[14].exr_lpf_reg[14]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_2_in15_in,
      Q => p_1_in16_in,
      R => '0'
    );
\EXT_LPF[15].exr_lpf_reg[15]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_1_in16_in,
      Q => exr_lpf(0),
      R => '0'
    );
\EXT_LPF[1].exr_lpf_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_15_in18_in,
      Q => p_14_in3_in,
      R => '0'
    );
\EXT_LPF[2].exr_lpf_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_14_in3_in,
      Q => p_13_in4_in,
      R => '0'
    );
\EXT_LPF[3].exr_lpf_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_13_in4_in,
      Q => p_12_in5_in,
      R => '0'
    );
\EXT_LPF[4].exr_lpf_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_12_in5_in,
      Q => p_11_in6_in,
      R => '0'
    );
\EXT_LPF[5].exr_lpf_reg[5]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_11_in6_in,
      Q => p_10_in7_in,
      R => '0'
    );
\EXT_LPF[6].exr_lpf_reg[6]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_10_in7_in,
      Q => p_9_in8_in,
      R => '0'
    );
\EXT_LPF[7].exr_lpf_reg[7]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_9_in8_in,
      Q => p_8_in9_in,
      R => '0'
    );
\EXT_LPF[8].exr_lpf_reg[8]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_8_in9_in,
      Q => p_7_in10_in,
      R => '0'
    );
\EXT_LPF[9].exr_lpf_reg[9]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_7_in10_in,
      Q => p_6_in11_in,
      R => '0'
    );
POR_SRL_I: unisim.vcomponents.SRL16E
    generic map(
      INIT => X"FFFF"
    )
        port map (
      A0 => '1',
      A1 => '1',
      A2 => '1',
      A3 => '1',
      CE => '1',
      CLK => slowest_sync_clk,
      D => '0',
      Q => Q
    );
lpf_asr_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000000000000000"
    )
        port map (
      I0 => p_11_in,
      I1 => p_12_in,
      I2 => p_9_in,
      I3 => p_10_in,
      I4 => p_14_in,
      I5 => p_13_in,
      O => lpf_asr_i_4_n_0
    );
lpf_asr_i_5: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000000000000000"
    )
        port map (
      I0 => p_5_in,
      I1 => p_6_in,
      I2 => p_3_in,
      I3 => p_4_in,
      I4 => p_8_in,
      I5 => p_7_in,
      O => lpf_asr_i_5_n_0
    );
lpf_asr_i_6: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000001"
    )
        port map (
      I0 => p_11_in,
      I1 => p_12_in,
      I2 => p_9_in,
      I3 => p_10_in,
      I4 => p_14_in,
      I5 => p_13_in,
      O => lpf_asr_i_6_n_0
    );
lpf_asr_i_7: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000001"
    )
        port map (
      I0 => p_5_in,
      I1 => p_6_in,
      I2 => p_3_in,
      I3 => p_4_in,
      I4 => p_8_in,
      I5 => p_7_in,
      O => lpf_asr_i_7_n_0
    );
lpf_asr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => \ACTIVE_HIGH_AUX.ACT_HI_AUX_n_0\,
      Q => lpf_asr,
      R => '0'
    );
lpf_exr_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000000000000000"
    )
        port map (
      I0 => p_11_in6_in,
      I1 => p_12_in5_in,
      I2 => p_9_in8_in,
      I3 => p_10_in7_in,
      I4 => p_14_in3_in,
      I5 => p_13_in4_in,
      O => lpf_exr_i_4_n_0
    );
lpf_exr_i_5: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8000000000000000"
    )
        port map (
      I0 => p_5_in12_in,
      I1 => p_6_in11_in,
      I2 => p_3_in14_in,
      I3 => p_4_in13_in,
      I4 => p_8_in9_in,
      I5 => p_7_in10_in,
      O => lpf_exr_i_5_n_0
    );
lpf_exr_i_6: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000001"
    )
        port map (
      I0 => p_11_in6_in,
      I1 => p_12_in5_in,
      I2 => p_9_in8_in,
      I3 => p_10_in7_in,
      I4 => p_14_in3_in,
      I5 => p_13_in4_in,
      O => lpf_exr_i_6_n_0
    );
lpf_exr_i_7: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000001"
    )
        port map (
      I0 => p_5_in12_in,
      I1 => p_6_in11_in,
      I2 => p_3_in14_in,
      I3 => p_4_in13_in,
      I4 => p_8_in9_in,
      I5 => p_7_in10_in,
      O => lpf_exr_i_7_n_0
    );
lpf_exr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => \ACTIVE_HIGH_EXT.ACT_HI_EXT_n_0\,
      Q => lpf_exr,
      R => '0'
    );
lpf_int0: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FFFD"
    )
        port map (
      I0 => dcm_locked,
      I1 => lpf_exr,
      I2 => lpf_asr,
      I3 => Q,
      O => \lpf_int0__0\
    );
lpf_int_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => \lpf_int0__0\,
      Q => lpf_int,
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rst_ctrl_sequence_psr is
  port (
    MB_out : out STD_LOGIC;
    Bsr_out : out STD_LOGIC;
    Pr_out : out STD_LOGIC;
    bsr_reg_0 : out STD_LOGIC;
    pr_reg_0 : out STD_LOGIC;
    lpf_int : in STD_LOGIC;
    slowest_sync_clk : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of rst_ctrl_sequence_psr : entity is "sequence_psr";
end rst_ctrl_sequence_psr;

architecture STRUCTURE of rst_ctrl_sequence_psr is
  signal \^bsr_out\ : STD_LOGIC;
  signal Core_i_1_n_0 : STD_LOGIC;
  signal \^mb_out\ : STD_LOGIC;
  signal \^pr_out\ : STD_LOGIC;
  signal \bsr_dec_reg_n_0_[0]\ : STD_LOGIC;
  signal \bsr_dec_reg_n_0_[2]\ : STD_LOGIC;
  signal bsr_i_1_n_0 : STD_LOGIC;
  signal \core_dec[0]_i_1_n_0\ : STD_LOGIC;
  signal \core_dec[2]_i_1_n_0\ : STD_LOGIC;
  signal \core_dec_reg_n_0_[0]\ : STD_LOGIC;
  signal \core_dec_reg_n_0_[1]\ : STD_LOGIC;
  signal from_sys_i_1_n_0 : STD_LOGIC;
  signal p_0_in : STD_LOGIC;
  signal p_3_out : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal p_5_out : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \pr_dec0__0\ : STD_LOGIC;
  signal \pr_dec_reg_n_0_[0]\ : STD_LOGIC;
  signal \pr_dec_reg_n_0_[2]\ : STD_LOGIC;
  signal pr_i_1_n_0 : STD_LOGIC;
  signal seq_clr : STD_LOGIC;
  signal seq_cnt : STD_LOGIC_VECTOR ( 5 downto 0 );
  signal seq_cnt_en : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \ACTIVE_LOW_BSR_OUT_DFF[0].FDRE_BSR_N_i_1\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \ACTIVE_LOW_PR_OUT_DFF[0].FDRE_PER_N_i_1\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of Core_i_1 : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \bsr_dec[0]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \bsr_dec[2]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of bsr_i_1 : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \core_dec[0]_i_1\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \core_dec[2]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of from_sys_i_1 : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of pr_i_1 : label is "soft_lutpair5";
begin
  Bsr_out <= \^bsr_out\;
  MB_out <= \^mb_out\;
  Pr_out <= \^pr_out\;
\ACTIVE_LOW_BSR_OUT_DFF[0].FDRE_BSR_N_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^bsr_out\,
      O => bsr_reg_0
    );
\ACTIVE_LOW_PR_OUT_DFF[0].FDRE_PER_N_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => \^pr_out\,
      O => pr_reg_0
    );
Core_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \^mb_out\,
      I1 => p_0_in,
      O => Core_i_1_n_0
    );
Core_reg: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => Core_i_1_n_0,
      Q => \^mb_out\,
      S => lpf_int
    );
SEQ_COUNTER: entity work.rst_ctrl_upcnt_n
     port map (
      Q(5 downto 0) => seq_cnt(5 downto 0),
      seq_clr => seq_clr,
      seq_cnt_en => seq_cnt_en,
      slowest_sync_clk => slowest_sync_clk
    );
\bsr_dec[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0090"
    )
        port map (
      I0 => seq_cnt_en,
      I1 => seq_cnt(4),
      I2 => seq_cnt(3),
      I3 => seq_cnt(5),
      O => p_5_out(0)
    );
\bsr_dec[2]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \core_dec_reg_n_0_[1]\,
      I1 => \bsr_dec_reg_n_0_[0]\,
      O => p_5_out(2)
    );
\bsr_dec_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_5_out(0),
      Q => \bsr_dec_reg_n_0_[0]\,
      R => '0'
    );
\bsr_dec_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_5_out(2),
      Q => \bsr_dec_reg_n_0_[2]\,
      R => '0'
    );
bsr_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \^bsr_out\,
      I1 => \bsr_dec_reg_n_0_[2]\,
      O => bsr_i_1_n_0
    );
bsr_reg: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => bsr_i_1_n_0,
      Q => \^bsr_out\,
      S => lpf_int
    );
\core_dec[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9000"
    )
        port map (
      I0 => seq_cnt_en,
      I1 => seq_cnt(4),
      I2 => seq_cnt(3),
      I3 => seq_cnt(5),
      O => \core_dec[0]_i_1_n_0\
    );
\core_dec[2]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \core_dec_reg_n_0_[1]\,
      I1 => \core_dec_reg_n_0_[0]\,
      O => \core_dec[2]_i_1_n_0\
    );
\core_dec_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => \core_dec[0]_i_1_n_0\,
      Q => \core_dec_reg_n_0_[0]\,
      R => '0'
    );
\core_dec_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => \pr_dec0__0\,
      Q => \core_dec_reg_n_0_[1]\,
      R => '0'
    );
\core_dec_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => \core_dec[2]_i_1_n_0\,
      Q => p_0_in,
      R => '0'
    );
from_sys_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \^mb_out\,
      I1 => seq_cnt_en,
      O => from_sys_i_1_n_0
    );
from_sys_reg: unisim.vcomponents.FDSE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => from_sys_i_1_n_0,
      Q => seq_cnt_en,
      S => lpf_int
    );
pr_dec0: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0018"
    )
        port map (
      I0 => seq_cnt_en,
      I1 => seq_cnt(0),
      I2 => seq_cnt(2),
      I3 => seq_cnt(1),
      O => \pr_dec0__0\
    );
\pr_dec[0]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0480"
    )
        port map (
      I0 => seq_cnt_en,
      I1 => seq_cnt(3),
      I2 => seq_cnt(5),
      I3 => seq_cnt(4),
      O => p_3_out(0)
    );
\pr_dec[2]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => \core_dec_reg_n_0_[1]\,
      I1 => \pr_dec_reg_n_0_[0]\,
      O => p_3_out(2)
    );
\pr_dec_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_3_out(0),
      Q => \pr_dec_reg_n_0_[0]\,
      R => '0'
    );
\pr_dec_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => p_3_out(2),
      Q => \pr_dec_reg_n_0_[2]\,
      R => '0'
    );
pr_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \^pr_out\,
      I1 => \pr_dec_reg_n_0_[2]\,
      O => pr_i_1_n_0
    );
pr_reg: unisim.vcomponents.FDSE
    generic map(
      INIT => '1'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => pr_i_1_n_0,
      Q => \^pr_out\,
      S => lpf_int
    );
seq_clr_reg: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => '1',
      Q => seq_clr,
      R => lpf_int
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rst_ctrl_proc_sys_reset is
  port (
    slowest_sync_clk : in STD_LOGIC;
    ext_reset_in : in STD_LOGIC;
    aux_reset_in : in STD_LOGIC;
    mb_debug_sys_rst : in STD_LOGIC;
    dcm_locked : in STD_LOGIC;
    mb_reset : out STD_LOGIC;
    bus_struct_reset : out STD_LOGIC_VECTOR ( 0 to 0 );
    peripheral_reset : out STD_LOGIC_VECTOR ( 0 to 0 );
    interconnect_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 );
    peripheral_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute C_AUX_RESET_HIGH : string;
  attribute C_AUX_RESET_HIGH of rst_ctrl_proc_sys_reset : entity is "1'b1";
  attribute C_AUX_RST_WIDTH : integer;
  attribute C_AUX_RST_WIDTH of rst_ctrl_proc_sys_reset : entity is 16;
  attribute C_EXT_RESET_HIGH : string;
  attribute C_EXT_RESET_HIGH of rst_ctrl_proc_sys_reset : entity is "1'b1";
  attribute C_EXT_RST_WIDTH : integer;
  attribute C_EXT_RST_WIDTH of rst_ctrl_proc_sys_reset : entity is 16;
  attribute C_FAMILY : string;
  attribute C_FAMILY of rst_ctrl_proc_sys_reset : entity is "virtex7";
  attribute C_NUM_BUS_RST : integer;
  attribute C_NUM_BUS_RST of rst_ctrl_proc_sys_reset : entity is 1;
  attribute C_NUM_INTERCONNECT_ARESETN : integer;
  attribute C_NUM_INTERCONNECT_ARESETN of rst_ctrl_proc_sys_reset : entity is 1;
  attribute C_NUM_PERP_ARESETN : integer;
  attribute C_NUM_PERP_ARESETN of rst_ctrl_proc_sys_reset : entity is 1;
  attribute C_NUM_PERP_RST : integer;
  attribute C_NUM_PERP_RST of rst_ctrl_proc_sys_reset : entity is 1;
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of rst_ctrl_proc_sys_reset : entity is "proc_sys_reset";
end rst_ctrl_proc_sys_reset;

architecture STRUCTURE of rst_ctrl_proc_sys_reset is
  signal Bsr_out : STD_LOGIC;
  signal MB_out : STD_LOGIC;
  signal Pr_out : STD_LOGIC;
  signal SEQ_n_3 : STD_LOGIC;
  signal SEQ_n_4 : STD_LOGIC;
  signal lpf_int : STD_LOGIC;
  attribute box_type : string;
  attribute box_type of \ACTIVE_LOW_BSR_OUT_DFF[0].FDRE_BSR_N\ : label is "PRIMITIVE";
  attribute box_type of \ACTIVE_LOW_PR_OUT_DFF[0].FDRE_PER_N\ : label is "PRIMITIVE";
  attribute box_type of \BSR_OUT_DFF[0].FDRE_BSR\ : label is "PRIMITIVE";
  attribute box_type of FDRE_inst : label is "PRIMITIVE";
  attribute box_type of \PR_OUT_DFF[0].FDRE_PER\ : label is "PRIMITIVE";
begin
\ACTIVE_LOW_BSR_OUT_DFF[0].FDRE_BSR_N\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0',
      IS_C_INVERTED => '0',
      IS_D_INVERTED => '0',
      IS_R_INVERTED => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => SEQ_n_3,
      Q => interconnect_aresetn(0),
      R => '0'
    );
\ACTIVE_LOW_PR_OUT_DFF[0].FDRE_PER_N\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0',
      IS_C_INVERTED => '0',
      IS_D_INVERTED => '0',
      IS_R_INVERTED => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => SEQ_n_4,
      Q => peripheral_aresetn(0),
      R => '0'
    );
\BSR_OUT_DFF[0].FDRE_BSR\: unisim.vcomponents.FDRE
    generic map(
      INIT => '1',
      IS_C_INVERTED => '0',
      IS_D_INVERTED => '0',
      IS_R_INVERTED => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => Bsr_out,
      Q => bus_struct_reset(0),
      R => '0'
    );
EXT_LPF: entity work.rst_ctrl_lpf
     port map (
      aux_reset_in => aux_reset_in,
      dcm_locked => dcm_locked,
      ext_reset_in => ext_reset_in,
      lpf_int => lpf_int,
      mb_debug_sys_rst => mb_debug_sys_rst,
      slowest_sync_clk => slowest_sync_clk
    );
FDRE_inst: unisim.vcomponents.FDRE
    generic map(
      INIT => '1',
      IS_C_INVERTED => '0',
      IS_D_INVERTED => '0',
      IS_R_INVERTED => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => MB_out,
      Q => mb_reset,
      R => '0'
    );
\PR_OUT_DFF[0].FDRE_PER\: unisim.vcomponents.FDRE
    generic map(
      INIT => '1',
      IS_C_INVERTED => '0',
      IS_D_INVERTED => '0',
      IS_R_INVERTED => '0'
    )
        port map (
      C => slowest_sync_clk,
      CE => '1',
      D => Pr_out,
      Q => peripheral_reset(0),
      R => '0'
    );
SEQ: entity work.rst_ctrl_sequence_psr
     port map (
      Bsr_out => Bsr_out,
      MB_out => MB_out,
      Pr_out => Pr_out,
      bsr_reg_0 => SEQ_n_3,
      lpf_int => lpf_int,
      pr_reg_0 => SEQ_n_4,
      slowest_sync_clk => slowest_sync_clk
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity rst_ctrl is
  port (
    slowest_sync_clk : in STD_LOGIC;
    ext_reset_in : in STD_LOGIC;
    aux_reset_in : in STD_LOGIC;
    mb_debug_sys_rst : in STD_LOGIC;
    dcm_locked : in STD_LOGIC;
    mb_reset : out STD_LOGIC;
    bus_struct_reset : out STD_LOGIC_VECTOR ( 0 to 0 );
    peripheral_reset : out STD_LOGIC_VECTOR ( 0 to 0 );
    interconnect_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 );
    peripheral_aresetn : out STD_LOGIC_VECTOR ( 0 to 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of rst_ctrl : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of rst_ctrl : entity is "rst_ctrl,proc_sys_reset,{}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of rst_ctrl : entity is "yes";
  attribute x_core_info : string;
  attribute x_core_info of rst_ctrl : entity is "proc_sys_reset,Vivado 2020.1";
end rst_ctrl;

architecture STRUCTURE of rst_ctrl is
  attribute C_AUX_RESET_HIGH : string;
  attribute C_AUX_RESET_HIGH of U0 : label is "1'b1";
  attribute C_AUX_RST_WIDTH : integer;
  attribute C_AUX_RST_WIDTH of U0 : label is 16;
  attribute C_EXT_RESET_HIGH : string;
  attribute C_EXT_RESET_HIGH of U0 : label is "1'b1";
  attribute C_EXT_RST_WIDTH : integer;
  attribute C_EXT_RST_WIDTH of U0 : label is 16;
  attribute C_FAMILY : string;
  attribute C_FAMILY of U0 : label is "virtex7";
  attribute C_NUM_BUS_RST : integer;
  attribute C_NUM_BUS_RST of U0 : label is 1;
  attribute C_NUM_INTERCONNECT_ARESETN : integer;
  attribute C_NUM_INTERCONNECT_ARESETN of U0 : label is 1;
  attribute C_NUM_PERP_ARESETN : integer;
  attribute C_NUM_PERP_ARESETN of U0 : label is 1;
  attribute C_NUM_PERP_RST : integer;
  attribute C_NUM_PERP_RST of U0 : label is 1;
  attribute x_interface_info : string;
  attribute x_interface_info of aux_reset_in : signal is "xilinx.com:signal:reset:1.0 aux_reset RST";
  attribute x_interface_parameter : string;
  attribute x_interface_parameter of aux_reset_in : signal is "XIL_INTERFACENAME aux_reset, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute x_interface_info of ext_reset_in : signal is "xilinx.com:signal:reset:1.0 ext_reset RST";
  attribute x_interface_parameter of ext_reset_in : signal is "XIL_INTERFACENAME ext_reset, BOARD.ASSOCIATED_PARAM RESET_BOARD_INTERFACE, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute x_interface_info of mb_debug_sys_rst : signal is "xilinx.com:signal:reset:1.0 dbg_reset RST";
  attribute x_interface_parameter of mb_debug_sys_rst : signal is "XIL_INTERFACENAME dbg_reset, POLARITY ACTIVE_HIGH, INSERT_VIP 0";
  attribute x_interface_info of mb_reset : signal is "xilinx.com:signal:reset:1.0 mb_rst RST";
  attribute x_interface_parameter of mb_reset : signal is "XIL_INTERFACENAME mb_rst, POLARITY ACTIVE_HIGH, TYPE PROCESSOR, INSERT_VIP 0";
  attribute x_interface_info of slowest_sync_clk : signal is "xilinx.com:signal:clock:1.0 clock CLK";
  attribute x_interface_parameter of slowest_sync_clk : signal is "XIL_INTERFACENAME clock, ASSOCIATED_RESET mb_reset:bus_struct_reset:interconnect_aresetn:peripheral_aresetn:peripheral_reset, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, INSERT_VIP 0";
  attribute x_interface_info of bus_struct_reset : signal is "xilinx.com:signal:reset:1.0 bus_struct_reset RST";
  attribute x_interface_parameter of bus_struct_reset : signal is "XIL_INTERFACENAME bus_struct_reset, POLARITY ACTIVE_HIGH, TYPE INTERCONNECT, INSERT_VIP 0";
  attribute x_interface_info of interconnect_aresetn : signal is "xilinx.com:signal:reset:1.0 interconnect_low_rst RST";
  attribute x_interface_parameter of interconnect_aresetn : signal is "XIL_INTERFACENAME interconnect_low_rst, POLARITY ACTIVE_LOW, TYPE INTERCONNECT, INSERT_VIP 0";
  attribute x_interface_info of peripheral_aresetn : signal is "xilinx.com:signal:reset:1.0 peripheral_low_rst RST";
  attribute x_interface_parameter of peripheral_aresetn : signal is "XIL_INTERFACENAME peripheral_low_rst, POLARITY ACTIVE_LOW, TYPE PERIPHERAL, INSERT_VIP 0";
  attribute x_interface_info of peripheral_reset : signal is "xilinx.com:signal:reset:1.0 peripheral_high_rst RST";
  attribute x_interface_parameter of peripheral_reset : signal is "XIL_INTERFACENAME peripheral_high_rst, POLARITY ACTIVE_HIGH, TYPE PERIPHERAL, INSERT_VIP 0";
begin
U0: entity work.rst_ctrl_proc_sys_reset
     port map (
      aux_reset_in => aux_reset_in,
      bus_struct_reset(0) => bus_struct_reset(0),
      dcm_locked => dcm_locked,
      ext_reset_in => ext_reset_in,
      interconnect_aresetn(0) => interconnect_aresetn(0),
      mb_debug_sys_rst => mb_debug_sys_rst,
      mb_reset => mb_reset,
      peripheral_aresetn(0) => peripheral_aresetn(0),
      peripheral_reset(0) => peripheral_reset(0),
      slowest_sync_clk => slowest_sync_clk
    );
end STRUCTURE;
