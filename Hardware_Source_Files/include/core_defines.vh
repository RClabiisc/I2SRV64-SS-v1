//NOTE: This is generated include file from 'core_defines.cfg'
//      Do NOT Modify here. Change the config file and generate this file again

`ifndef INC_CORE_DEFINES
`define INC_CORE_DEFINES

//--------------------------------------------------------------------
// Linting Defines
//--------------------------------------------------------------------
`default_nettype none

//--------------------------------------------------------------------
// Include Global Config and Typedefs
//--------------------------------------------------------------------
`include "core_config.vh"
`include "core_typedefs.vh"
`include "ISA_defines.vh"
`include "ISA_priv_defines.vh"

//--------------------------------------------------------------------
// Additional Core Defines
//--------------------------------------------------------------------

// uArch Defines
`define DECODE_RATE                     4
`define RENAME_RATE                     4

// I/D Cache Defines
`define CACHE_INDEX_START               5
`define CACHE_INDEX_END                 11

// TLB Defines
`define TLB_WIDTH                       91
`define PPN_end                         53
`define PPN_start                       10
`define ICACHE_TAG_WIDTH                44
`define VPN_end                         90
`define VPN_start                       64
`define LEVELS                          3
`define PAGESIZE                        12
`define PTESIZE                         3

// ICache Defines
`define ICACHE_LINE_SIZE_LEN            5
`define ICACHE_LINE_SIZEHW              16
`define ICACHE_LINE_LEN                 256

// IFU Defines
`define FETCHPCL_LEN                    5
`define FETCHPCL_RANGE                  0+:5
`define FETCH_RATE_HW                   8
`define FETCH_RATE_HW_LEN               3
`define BINDX_LEN                       3

// uBTB Defines
`define BTB_WAYS                        4
`define BTB_SETS                        256
`define BTB_SETS_LEN                    8
`define BTB_WAYS_LEN                    2
`define BTB_ADDR_TAG                    63:9
`define BTB_ADDR_INDEX                  8:1

// RAS Defines
`define RAS_DEPTH_LEN                   5

// Direction Predictor (G-Share) Defines
`define DP_GHR_WIDTH                    8
`define DP_PHT_WIDTH                    11

// Instruction Buffer (IB) defines
`define IB_DEPTH_LEN                    5

// Rename and Physical Regfile Defines
`define INT_PRF_LEN                     6
`define FP_PRF_LEN                      6
`define PRF_MAX_LEN                     6

// ROB Defines
`define ROB_DEPTH_LEN                   6

// Store Buffer Defines
`define SB_DEPTH                        8
`define SB_DEPTH_LEN                    3

`endif

// Generated File 'core_defines.vh' Ends

