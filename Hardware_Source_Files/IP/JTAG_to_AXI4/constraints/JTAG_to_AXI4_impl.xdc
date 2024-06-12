################################################################################
# (c) Copyright 2012 - 2013 Xilinx, Inc. All rights reserved.
# 
# This file contains confidential and proprietary information
# of Xilinx, Inc. and is protected under U.S. and
# international copyright and other intellectual property
# laws.
# 
# DISCLAIMER
# This disclaimer is not a license and does not grant any
# rights to the materials distributed herewith. Except as
# otherwise provided in a valid license issued to you by
# Xilinx, and to the maximum extent permitted by applicable
# law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
# WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
# AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
# BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
# INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
# (2) Xilinx shall not be liable (whether in contract or tort,
# including negligence, or under any other theory of
# liability) for any loss or damage of any kind or nature
# related to, arising under or in connection with these
# materials, including for any direct, or any indirect,
# special, incidental, or consequential loss or damage
# (including loss of data, profits, goodwill, or any type of
# loss or damage suffered as a result of any action brought
# by a third party) even if such damage or loss was
# reasonably foreseeable or Xilinx had been advised of the
# possibility of the same.
# 
# CRITICAL APPLICATIONS
# Xilinx products are not designed or intended to be fail-
# safe, or for use in any application requiring fail-safe
# performance, such as life-support or safety devices or
# systems, Class III medical devices, nuclear facilities,
# applications related to the deployment of airbags, or any
# other applications that could lead to death, personal
# injury, or severe property or environmental damage
# (individually and collectively, "Critical
# Applications"). Customer assumes the sole risk and
# liability of any use of Xilinx products in Critical
# Applications, subject only to applicable laws and
# regulations governing limitations on product liability.
# 
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
# PART OF THIS FILE AT ALL TIMES.

################################################################################

# This XDC is used only for OOC mode of synthesis, implementation
# User should update the correct clock period before proceeding further
# This constraints file contains default clock frequencies to be used during 
# out-of-context flows such as OOC Synthesis and Hierarchical Designs. 
# For best results the frequencies should be modified# to match the target 
# frequencies. 
# This constraints file is not used in normal top-down synthesis (the default flow of Vivado)
################################################################################


## axi4_lite interface and core_clock false path
## This constraint applies with cdc_module
#set aclk [get_clocks -of_objects [get_ports aclk]]
#set xsdb_clk  [get_clocks -of_objects [get_pins -hierarchical -filter {NAME=~*jtag_axi_engine_u/U_XSDB_SLAVE/s_dclk_o}]]

#set_false_path -quiet -from [filter [all_fanout -from [get_pins -hierarchical *U_XSDB_SLAVE/s_dclk_o] -flat -endpoints_only] {IS_LEAF}] -to [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/wr_cmd_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.mem/gdm.dm_gen.dm*/gpr1.dout_i_reg*}]

#set_false_path -quiet -from [filter [all_fanout -from [get_pins -hierarchical *U_XSDB_SLAVE/s_dclk_o] -flat -endpoints_only] {IS_LEAF}] -to [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/rd_cmd_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.mem/gdm.dm_gen.dm*/gpr1.dout_i_reg*}]

set_false_path -quiet -from [filter [all_fanout -from [get_pins -hierarchical *U_XSDB_SLAVE/s_dclk_o] -flat -endpoints_only] {IS_LEAF}] -to [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/tx_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.mem/gdm.dm_gen.dm*/gpr1.dout_i_reg*}]

#set_false_path -quiet -from [filter [all_fanout -from [get_ports aclk] -flat -endpoints_only] {IS_LEAF}] -to [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/rx_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.mem/gdm.dm_gen.dm*/gpr1.dout_i_reg*}]


# Set max delay on cross clock domain path for Block/Distributed RAM based FIFO
## set_max_delay -quiet -from [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/wr_cmd_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*rd_pntr_gc_reg[*]}] -to [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/wr_cmd_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[*].wr_stg_inst/Q_reg_reg[*]}] -datapath_only [get_property  -min PERIOD $aclk]
## set_max_delay -quiet -from [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/wr_cmd_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*wr_pntr_gc_reg[*]}] -to [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/wr_cmd_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[*].rd_stg_inst/Q_reg_reg[*]}] -datapath_only [get_property  -min PERIOD $xsdb_clk]
 
## set_max_delay -quiet -from [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/rd_cmd_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*rd_pntr_gc_reg[*]}] -to [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/rd_cmd_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[*].wr_stg_inst/Q_reg_reg[*]}] -datapath_only [get_property  -min PERIOD $aclk]
## set_max_delay -quiet -from [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/rd_cmd_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*wr_pntr_gc_reg[*]}] -to [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/rd_cmd_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[*].rd_stg_inst/Q_reg_reg[*]}] -datapath_only [get_property  -min PERIOD $xsdb_clk]
 
## set_max_delay -quiet -from [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/tx_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*rd_pntr_gc_reg[*]}] -to [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/tx_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[*].wr_stg_inst/Q_reg_reg[*]}] -datapath_only [get_property  -min PERIOD $aclk]
## set_max_delay -quiet -from [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/tx_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*wr_pntr_gc_reg[*]}] -to [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/tx_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[*].rd_stg_inst/Q_reg_reg[*]}] -datapath_only [get_property  -min PERIOD $xsdb_clk]
 
##set rd_clk [get_property -min PERIOD $aclk]
##set wr_clk [get_property -min PERIOD $xsdb_clk]
##set skew_value [expr {($wr_clk < $rd_clk) ? $wr_clk : $rd_clk} ]

##set_bus_skew -quiet -from [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/wr_cmd_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*rd_pntr_gc_reg[*]}] -to [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/wr_cmd_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[1].wr_stg_inst/Q_reg_reg[*]}] $skew_value
##set_bus_skew -quiet -from [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/wr_cmd_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*wr_pntr_gc_reg[*]}] -to [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/wr_cmd_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[1].rd_stg_inst/Q_reg_reg[*]}] $skew_value

##set_bus_skew -quiet -from [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/rd_cmd_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*rd_pntr_gc_reg[*]}] -to [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/rd_cmd_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[1].wr_stg_inst/Q_reg_reg[*]}] $skew_value
##set_bus_skew -quiet -from [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/rd_cmd_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*wr_pntr_gc_reg[*]}] -to [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/rd_cmd_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[1].rd_stg_inst/Q_reg_reg[*]}] $skew_value

##set_bus_skew -quiet -from [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/tx_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*rd_pntr_gc_reg[*]}] -to [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/tx_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[1].wr_stg_inst/Q_reg_reg[*]}] $skew_value
##set_bus_skew -quiet -from [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/tx_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*wr_pntr_gc_reg[*]}] -to [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/tx_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[1].rd_stg_inst/Q_reg_reg[*]}] $skew_value



## set_max_delay -quiet -from [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/rx_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*rd_pntr_gc_reg[*]}] -to [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/rx_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[*].wr_stg_inst/Q_reg_reg[*]}] -datapath_only [get_property  -min PERIOD $xsdb_clk]
## set_max_delay -quiet -from [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/rx_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*wr_pntr_gc_reg[*]}] -to [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/rx_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[*].rd_stg_inst/Q_reg_reg[*]}] -datapath_only [get_property  -min PERIOD $aclk]
 
##set rd_clk1 [get_property -min PERIOD $xsdb_clk]
##set wr_clk1 [get_property -min PERIOD $aclk]
##set skew_value1 [expr {($rd_clk1 < $wr_clk1) ? $rd_clk1 : $wr_clk1} ]

##set_bus_skew -quiet -from [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/rx_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*rd_pntr_gc_reg[*]}] -to [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/rx_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[1].wr_stg_inst/Q_reg_reg[*]}] $skew_value1
##set_bus_skew -quiet -from [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/rx_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*wr_pntr_gc_reg[*]}] -to [get_cells -hierarchical -filter {NAME =~*jtag_axi_engine_u/rx_fifo_i/inst_fifo_gen/gconvfifo.rf/grf.rf/gntv_or_sync_fifo.gcx.clkx/*gsync_stage[1].rd_stg_inst/Q_reg_reg[*]}] $skew_value1





################################################################################
