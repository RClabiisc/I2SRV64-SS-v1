# This file contains the nets in design that can be used to debug.
# enable corresponding commands below to mark wires for debug.
# NOTE: While Adding this file to project, select to copy it to project
#       Folder and edit as per your need.

# General Global Signals
#set_property MARK_DEBUG true [get_nets SoC/Processor/sys_rst]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/IFU/FetchPC[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/EX/Retire_Unit/Retire_PC[*]}]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/SysCtl_Redirect]

# DCache Read and Write Request Debug Signals
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DCache/DCache_RdReq_Valid]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DCache/DCache_RdReq_Paddr[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DCache/DCache_RdResp_Data[*]}]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DCache/DCache_RdReq_Abort]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DCache/DCache_RdResp_Done]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DCache/DCache_RdResp_Ready]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DCache/DCache_WrReq_Valid]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DCache/DCache_WrReq_Paddr[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DCache/DCache_WrReq_Data[*]}]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DCache/DCache_WrResp_Done]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DCache/DCache_WrResp_Ready]

# DMMU Debug Signals
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DMMU/MMU_Req0_Valid]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DMMU/MMU_Req1_Valid]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DMMU/MMU_Req0_Vaddr[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DMMU/MMU_Req1_Vaddr[*]}]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DMMU/MMU_Req0_Abort]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DMMU/MMU_Req1_Abort]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DMMU/MMU_Resp0_Done]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DMMU/MMU_Resp1_Done]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DMMU/MMU_Resp0_Paddr[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DMMU/MMU_Resp1_Paddr[11]}]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DMMU/MMU_Resp0_Exception]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DMMU/MMU_Resp1_Exception]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DMMU/MMU_Resp0_Ready]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DMMU/MMU_Resp1_Ready]

# IRQ Debug Signals
#set_property MARK_DEBUG true [get_nets {SoC/Processor/global_irqs[*]}]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/irq_machine_ext]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/irq_machine_soft]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/irq_machine_timer]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/irq_supervisor_ext]

# PLIC Debug Signals
#set_property MARK_DEBUG true [get_nets {SoC/Processor/PLIC/AXI_LITE_SLAVE_PLIC/interrupt_pending[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/PLIC/PLIC/GATEWAY/interrupt_completion_ID[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/PLIC/AXI_LITE_SLAVE_PLIC/interrupt_active_0[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/PLIC/AXI_LITE_SLAVE_PLIC/interrupt_claim_notif[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/PLIC/AXI_LITE_SLAVE_PLIC/interrupt_completion_notif[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/PLIC/PLIC/GATEWAY/interrupt_request[*]}]

# AXI DBUS Debug Signals
#set_property MARK_DEBUG true [get_nets {SoC/M_AXI_DBUS_AWADDR[*]}]
#set_property MARK_DEBUG true [get_nets SoC/M_AXI_DBUS_AWREADY]
#set_property MARK_DEBUG true [get_nets SoC/M_AXI_DBUS_AWVALID]
#set_property MARK_DEBUG true [get_nets {SoC/M_AXI_DBUS_ARADDR[*]}]
#set_property MARK_DEBUG true [get_nets SoC/M_AXI_DBUS_ARREADY]
#set_property MARK_DEBUG true [get_nets SoC/M_AXI_DBUS_ARVALID]
#set_property MARK_DEBUG true [get_nets {SoC/M_AXI_DBUS_WDATA[*]}]
#set_property MARK_DEBUG true [get_nets SoC/M_AXI_DBUS_WREADY]
#set_property MARK_DEBUG true [get_nets SoC/M_AXI_DBUS_WVALID]
#set_property MARK_DEBUG true [get_nets SoC/M_AXI_DBUS_WLAST]
#set_property MARK_DEBUG true [get_nets {SoC/M_AXI_DBUS_RDATA[*]}]
#set_property MARK_DEBUG true [get_nets SoC/M_AXI_DBUS_RREADY]
#set_property MARK_DEBUG true [get_nets SoC/M_AXI_DBUS_RVALID]
#set_property MARK_DEBUG true [get_nets SoC/M_AXI_DBUS_RLAST]

# SysCtl Trap Debug Signals

#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/SysCtl/ICache_Flush_Req}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/SysCtl/ICache_Flush_Done}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/SysCtl/DCache_Flush_Req}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/SysCtl/DCache_Flush_Done}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/SysCtl/ITLB_Flush_Req}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/SysCtl/ITLB_Flush_Done}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/SysCtl/DTLB_Flush_Req}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/SysCtl/DTLB_Flush_Done}]

#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/SysCtl/dbg_trap_type[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/SysCtl/dbg_trap_to_priv_lvl[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/SysCtl/SysCtl_RedirectPC[*]}]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/SysCtl/dbg_trap_valid]

# Retire Unit Debug Signals
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/EX/Retire_Unit/dbg_retire_instr[*][*]} ]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/EX/Retire_Unit/dbg_retire_pc[*][*]} ]

# Store Buffer Debug Signals
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/LSU/Store_Queue/SB_UsedEntries[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/LSU/Store_Queue/rd_ptr_reg_n_0_[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/LSU/Store_Queue/SB_Index[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/LSU/Store_Queue/StoreBuff_reg_n_0_[*][0]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/LSU/Store_Queue/StoreBuff_reg_n_0_[*][1]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/LSU/Store_Queue/StoreBuff_reg_n_0_[*][2]}]

# AXI DCache Debug Signals
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/FSM_Dcache/allocate_line_a]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/FSM_Dcache/allocate_line_b]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/FSM_Dcache/start_burst]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/FSM_Dcache/tag_match_read]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/FSM_Dcache/tag_match_write]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/comp_rd[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/comp_wr[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/burst_len_full[*]}]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/burst_type_full]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/mem_ack_axi_full]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/FSM_Dcache/prstate[*]}]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/FSM_Dcache/write_replace_reg]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/FSM_Dcache/write_replaced]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/FSM_Dcache/read_replace_reg]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/FSM_Dcache/mem_ack]
#set_property MARK_DEBUG false [get_nets SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/FSM_Dcache/replace_signal_a]
#set_property MARK_DEBUG false [get_nets SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/FSM_Dcache/replace_signal_b]
#set_property MARK_DEBUG false [get_nets SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/FSM_Dcache/write_allocate_reg]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/FSM_Dcache/AccessAllowed_read_reg]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/FSM_Dcache/AccessAllowed_write_reg]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/FSM_Dcache/PMA_cacheable_read]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/FSM_Dcache/PMA_cacheable_write]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/FSM_Dcache/private_bus_busy]

#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/FSM_Dcache/valid_way0[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/FSM_Dcache/valid_way1[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/FSM_Dcache/valid_way2[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/FSM_Dcache/valid_way3[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/dirty_way0[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/dirty_way1[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/dirty_way2[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DCache/DCACHE.AXI_DCache/DCACHE/dirty_way3[*]}]

# AXI MMU Debug Signals
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DMMU/DMMU.AXI_DMMU/DTLB_top/port0_FSM/prstate[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DMMU/DMMU.AXI_DMMU/DTLB_top/port1_FSM/prstate[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DMMU/DMMU.AXI_DMMU/DTLB_top/port0_FSM/tlb_address[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DMMU/DMMU.AXI_DMMU/DTLB_top/port1_FSM/tlb_address[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DMMU/DMMU.AXI_DMMU/DTLB_top/port0_FSM/write_data_tlb[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DMMU/DMMU.AXI_DMMU/DTLB_top/port1_FSM/write_data_tlb[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DMMU/DMMU.AXI_DMMU/DTLB_top/port0_FSM/count[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DMMU/DMMU.AXI_DMMU/DTLB_top/port1_FSM/count[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DMMU/DMMU.AXI_DMMU/DTLB_top/tlb_memory/comp1[*]}]
#set_property MARK_DEBUG true [get_nets {SoC/Processor/Core0/DMMU/DMMU.AXI_DMMU/DTLB_top/tlb_memory/comp2[*]}]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DMMU/DMMU.AXI_DMMU/DTLB_top/tlb_start_burst]
#set_property MARK_DEBUG true [get_nets SoC/Processor/Core0/DMMU/DMMU.AXI_DMMU/DTLB_top/mem_ack]

