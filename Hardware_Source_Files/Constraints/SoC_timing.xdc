# System Differential Input will be automatically defined by clocking wizard

#Add Generated clock from CLINT_clkdiv based on divider value
create_generated_clock -name rtclk -source [get_pins -hierarchical Processor/sys_clk] -divide_by 16 [get_pins -hierarchical CLINT_clkdiv/clk_out]

# Add Multicycle Paths for Flopoco IPs
set _xlnx_shared_i0 [get_cells -hierarchical *FPADD_DP*]
set_multicycle_path -setup -through $_xlnx_shared_i0 4
set _xlnx_shared_i1 [get_cells -hierarchical *FPADD_SP*]
set_multicycle_path -setup -through $_xlnx_shared_i1 3
set_multicycle_path -setup -through [get_cells -hierarchical *FMAADD_DP*] 4
set_multicycle_path -setup -through [get_cells -hierarchical *FMAADD_SP*] 3
set _xlnx_shared_i2 [get_cells -hierarchical *FPMULT_DP*]
set_multicycle_path -setup -through $_xlnx_shared_i2 3
set_multicycle_path -setup -through [get_cells -hierarchical *FPMULT_SP*] 2
set _xlnx_shared_i3 [get_cells -hierarchical *FPDIV_DP*]
set_multicycle_path -setup -through $_xlnx_shared_i3 15
set_multicycle_path -setup -through [get_cells -hierarchical *FPDIV_SP*] 6
set _xlnx_shared_i4 [get_cells -hierarchical *FPSQRT_DP*]
set_multicycle_path -setup -through $_xlnx_shared_i4 12
set_multicycle_path -setup -through [get_cells -hierarchical *FPSQRT_SP*] 5
set_multicycle_path -setup -through [get_cells -hierarchical *IMUL_65sx65s*] 2

set_multicycle_path -hold -through $_xlnx_shared_i0 3
set_multicycle_path -hold -through $_xlnx_shared_i1 2
set_multicycle_path -hold -through [get_cells -hierarchical *FMAADD_DP*] 3
set_multicycle_path -hold -through [get_cells -hierarchical *FMAADD_SP*] 2
set_multicycle_path -hold -through $_xlnx_shared_i2 2
set_multicycle_path -hold -through [get_cells -hierarchical *FPMULT_SP*] 1
set_multicycle_path -hold -through $_xlnx_shared_i3 14
set_multicycle_path -hold -through [get_cells -hierarchical *FPDIV_SP*] 5
set_multicycle_path -hold -through $_xlnx_shared_i4 11
set_multicycle_path -hold -through [get_cells -hierarchical *FPSQRT_SP*] 4
set_multicycle_path -hold -through [get_cells -hierarchical *IMUL_65sx65s*] 1

##False Paths
#1. False path when exception or interrupt comes, path through Flush Signal, the path going through any FU to RS+ROB+Port_S2E+PRF is False
# as they are handled directly at respective modules. No need to go though FU
set_false_path -through [get_nets {SoC/Processor/Core0/EX/Execution_Unit/EU0/FALU.FU_FALU/Flush SoC/Processor/Core0/EX/Execution_Unit/EU0/FMUL.FU_FMUL/Flush SoC/Processor/Core0/EX/Execution_Unit/EU0/IALU.FU_IALU/Flush SoC/Processor/Core0/EX/Execution_Unit/EU0/IDIV.FU_IDIV/Flush SoC/Processor/Core0/EX/Execution_Unit/EU1/FALU.FU_FALU/Flush SoC/Processor/Core0/EX/Execution_Unit/EU1/FDIV.FU_FDIV/Flush SoC/Processor/Core0/EX/Execution_Unit/EU1/IALU.FU_IALU/Flush SoC/Processor/Core0/EX/Execution_Unit/EU2/IALU.FU_IALU/Flush SoC/Processor/Core0/EX/Execution_Unit/EU2/IMUL.FU_IMUL/Flush SoC/Processor/Core0/EX/Execution_Unit/EU3/FULD.FU_Load/Flush SoC/Processor/Core0/EX/Execution_Unit/EU4/FUST.FU_Store/Flush SoC/Processor/Core0/EX/Execution_Unit/EU5/FUBR.FU_Branch/Flush}] -to [get_cells -hierarchical -filter { NAME =~  "*ROB_reg[*][*]" || NAME =~  "*Port*_reg[*]" || NAME =~  "*preg_reg[*][*]" || NAME =~  "*RS_*_reg[*][*]" }]

#2. D$ Arbiter false path: InReq0_Valid -> InResp0_Done. Done comes from OutResp_Done, not dependent on input valid.
set_false_path -through [get_nets -hierarchical *InReq0_Valid*] -through [get_nets SoC/Processor/Core0/DCache_Read_Arbiter/InResp0_Done]

#3. D$ Arbiter false path: InReq0_Valid -> InResp0_Data. Data comes from OutResp_Data, not dependent on input valid.
set_false_path -through [get_nets -hierarchical *InReq0_Valid*] -through [get_nets -hierarchical {*InResp0_Data[*]}]

#4. False path due to DCache Abort source select mux. It creates false paths from MMU response done/exception to DCache Abort. Both are not related. NOTE: LBReadReq[1] = Killed
set_false_path -through [get_nets {SoC/Processor/Core0/DMMU/MMU_Resp0_Exception SoC/Processor/Core0/DMMU/MMU_Resp1_Exception}] -through [get_nets -hierarchical {*LBReadReq0[1]}]
set_false_path -through [get_nets -hierarchical *MMU_Resp*_Done*] -through [get_nets -hierarchical {*LBReadReq0[1]}]

#5. False path from MMU_req_Abort to MMU_resp_exception/done. The path from done/exception are not used when abort i.e. exception/killed
set_false_path -through [get_nets SoC/Processor/Core0/DMMU/DMMU.AXI_DMMU/DTLB_top/port0_FSM/port0_req_abort] -through [get_nets {SoC/Processor/Core0/DMMU/DMMU.AXI_DMMU/DTLB_top/port0_FSM/port0_resp_exception SoC/Processor/Core0/DMMU/DMMU.AXI_DMMU/DTLB_top/port0_resp_done SoC/Processor/Core0/DMMU/DMMU.AXI_DMMU/DTLB_top/port1_resp_done}]

