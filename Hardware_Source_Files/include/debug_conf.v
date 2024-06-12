`include "core_defines.vh"

`ifdef DEBUG_FULL
    `define DEBUG_IFU
    `define DEBUG_IFU_BG
    `define DEBUG_IFU_BG_STS
    `define DEBUG_IFU_BG_ENTRY
    //`define DEBUG_IFU_BQD
    //    `define DEBUG_IFU_BQD_STS
    //    `define DEBUG_IFU_BQD_ENTRY
    `define DEBUG_IFU_UBTB
    `define DEBUG_IFU_DP
    `define DEBUG_IFU_BC
    `define DEBUG_IFU_BC_STS
    `define DEBUG_IFU_BC_ENTRY
    `define DEBUG_IFU_IB


    `define DEBUG_EX
    //    `define DEBUG_IRF_VALUE
    //    `define DEBUG_FRF_VALUE
    `define DEBUG_DECODER
    `define DEBUG_RENAME
    //    `define DEBUG_SPEC
    //        `define DEBUG_SPEC_ENTRY
    //    `define DEBUG_FREELIST

    `define DEBUG_DISPATCH
    `define DEBUG_DISPATCH_STS
    `define DEBUG_DISPATCH_ENTRY
    //    `define DEBUG_RSINT
    //        `define DEBUG_RSINT_ENTRY
    //    `define DEBUG_RSFP
    //        `define DEBUG_RSFP_ENTRY
    //    `define DEBUG_RSBR
    //        `define DEBUG_RSBR_ENTRY
    //    `define DEBUG_RSMEM
    //        `define DEBUG_RSMEM_ENTRY
    //    `define DEBUG_RSSYS
    //        `define DEBUG_RSSYS_ENTRY
    //    `define DEBUG_ROB
    //        `define DEBUG_ROB_ENTRY
    `define DEBUG_ISSUE
    `define DEBUG_EU
    //    `define DEBUG_EU_RESULT
    `define DEBUG_FU_RESULT
    `define DEBUG_FUBR
    `define DEBUG_MMU
    `define DEBUG_RETIRE
    //  `define DEBUG_RETIRE_STS
    `define DEBUG_SYSCTL
`else
    `define DEBUG_FU_RESULT
    `define DEBUG_FUBR
    `define DEBUG_RETIRE
    `define DEBUG_SYSCTL
`endif

//Custom Functions for better debugging
function [7:0] B2C(input [2:0] btype);
    begin
        case(btype)
            `BRANCH_TYPE_NONE: B2C="N";
            `BRANCH_TYPE_COND: B2C="B";
            `BRANCH_TYPE_JMP:  B2C="J";
            `BRANCH_TYPE_RET:  B2C="R";
            `BRANCH_TYPE_IJMP: B2C="I";
            `BRANCH_TYPE_CALL: B2C="C";
            `BRANCH_TYPE_ICALL:B2C="F";
            default:           B2C="X";
        endcase
    end
endfunction
function [(8*4)-1:0] FU2Str(input [3:0] FUtype);
    begin
        case(FUtype)
            `FU_TYPE_IALU   : FU2Str="IALU";
            `FU_TYPE_IMUL   : FU2Str="IMUL";
            `FU_TYPE_IDIV   : FU2Str="IDIV";
            `FU_TYPE_FALU   : FU2Str="FALU";
            `FU_TYPE_FMUL   : FU2Str="FMUL";
            `FU_TYPE_FDIV   : FU2Str="FDIV";
            `FU_TYPE_LOAD   : FU2Str="FULD";
            `FU_TYPE_STORE  : FU2Str="FUST";
            `FU_TYPE_SYSTEM : FU2Str="FSYS";
            `FU_TYPE_BRANCH : FU2Str="FUBR";
            default         : FU2Str="X--X";
        endcase
    end
endfunction
function [7:0] RegChar(input Prd_Type);
    begin
        case(Prd_Type)
            `REG_TYPE_INT: RegChar = "x";
            `REG_TYPE_FP : RegChar = "f";
        endcase
    end
endfunction
function [(3*8)-1:0] RegAbiName(input [4:0] Reg, input RegType);
    begin
        case(Reg)
            5'd0 : RegAbiName = RegType==`REG_TYPE_INT ? "zro" : "ft0";
            5'd1 : RegAbiName = RegType==`REG_TYPE_INT ? "ra " : "ft1";
            5'd2 : RegAbiName = RegType==`REG_TYPE_INT ? "sp " : "ft2";
            5'd3 : RegAbiName = RegType==`REG_TYPE_INT ? "gp " : "ft3";
            5'd4 : RegAbiName = RegType==`REG_TYPE_INT ? "tp " : "ft4";
            5'd5 : RegAbiName = RegType==`REG_TYPE_INT ? "t0 " : "ft5";
            5'd6 : RegAbiName = RegType==`REG_TYPE_INT ? "t1 " : "ft6";
            5'd7 : RegAbiName = RegType==`REG_TYPE_INT ? "t2 " : "ft7";
            5'd8 : RegAbiName = RegType==`REG_TYPE_INT ? "s0 " : "fs0";
            5'd9 : RegAbiName = RegType==`REG_TYPE_INT ? "s1 " : "fs1";
            5'd10: RegAbiName = RegType==`REG_TYPE_INT ? "a0 " : "fa0";
            5'd11: RegAbiName = RegType==`REG_TYPE_INT ? "a1 " : "fa1";
            5'd12: RegAbiName = RegType==`REG_TYPE_INT ? "a2 " : "fa2";
            5'd13: RegAbiName = RegType==`REG_TYPE_INT ? "a3 " : "fa3";
            5'd14: RegAbiName = RegType==`REG_TYPE_INT ? "a4 " : "fa4";
            5'd15: RegAbiName = RegType==`REG_TYPE_INT ? "a5 " : "fa5";
            5'd16: RegAbiName = RegType==`REG_TYPE_INT ? "a6 " : "fa6";
            5'd17: RegAbiName = RegType==`REG_TYPE_INT ? "a7 " : "fa7";
            5'd18: RegAbiName = RegType==`REG_TYPE_INT ? "s2 " : "fs2";
            5'd19: RegAbiName = RegType==`REG_TYPE_INT ? "s3 " : "fs3";
            5'd20: RegAbiName = RegType==`REG_TYPE_INT ? "s4 " : "fs4";
            5'd21: RegAbiName = RegType==`REG_TYPE_INT ? "s5 " : "fs5";
            5'd22: RegAbiName = RegType==`REG_TYPE_INT ? "s6 " : "fs6";
            5'd23: RegAbiName = RegType==`REG_TYPE_INT ? "s7 " : "fs7";
            5'd24: RegAbiName = RegType==`REG_TYPE_INT ? "s8 " : "fs8";
            5'd25: RegAbiName = RegType==`REG_TYPE_INT ? "s9 " : "fs9";
            5'd26: RegAbiName = RegType==`REG_TYPE_INT ? "s10" : "fS0";
            5'd27: RegAbiName = RegType==`REG_TYPE_INT ? "s11" : "fS1";
            5'd28: RegAbiName = RegType==`REG_TYPE_INT ? "t3 " : "ft8";
            5'd29: RegAbiName = RegType==`REG_TYPE_INT ? "t4 " : "ft9";
            5'd30: RegAbiName = RegType==`REG_TYPE_INT ? "t5 " : "fT0";
            5'd31: RegAbiName = RegType==`REG_TYPE_INT ? "t6 " : "fT1";
        endcase
    end
endfunction
function [(9*8)-1:0] PrintReg(input [4:0] Reg, input RegType);
    begin
        case(Reg)
            5'd0 : PrintReg = RegType==`REG_TYPE_INT ? "x0(zero)" : "f0(ft0)"  ;
            5'd1 : PrintReg = RegType==`REG_TYPE_INT ? "x1(ra)"   : "f1(ft1)"  ;
            5'd2 : PrintReg = RegType==`REG_TYPE_INT ? "x2(sp)"   : "f2(ft2)"  ;
            5'd3 : PrintReg = RegType==`REG_TYPE_INT ? "x3(gp)"   : "f3(ft3)"  ;
            5'd4 : PrintReg = RegType==`REG_TYPE_INT ? "x4(tp)"   : "f4(ft4)"  ;
            5'd5 : PrintReg = RegType==`REG_TYPE_INT ? "x5(t0)"   : "f5(ft5)"  ;
            5'd6 : PrintReg = RegType==`REG_TYPE_INT ? "x6(t1)"   : "f6(ft6)"  ;
            5'd7 : PrintReg = RegType==`REG_TYPE_INT ? "x7(t2)"   : "f7(ft7)"  ;
            5'd8 : PrintReg = RegType==`REG_TYPE_INT ? "x8(s0)"   : "f8(fs0)"  ;
            5'd9 : PrintReg = RegType==`REG_TYPE_INT ? "x9(s1)"   : "f9(fs1)"  ;
            5'd10: PrintReg = RegType==`REG_TYPE_INT ? "x10(a0)"  : "f10(fa0)" ;
            5'd11: PrintReg = RegType==`REG_TYPE_INT ? "x11(a1)"  : "f11(fa1)" ;
            5'd12: PrintReg = RegType==`REG_TYPE_INT ? "x12(a2)"  : "f12(fa2)" ;
            5'd13: PrintReg = RegType==`REG_TYPE_INT ? "x13(a3)"  : "f13(fa3)" ;
            5'd14: PrintReg = RegType==`REG_TYPE_INT ? "x14(a4)"  : "f14(fa4)" ;
            5'd15: PrintReg = RegType==`REG_TYPE_INT ? "x15(a5)"  : "f15(fa5)" ;
            5'd16: PrintReg = RegType==`REG_TYPE_INT ? "x16(a6)"  : "f16(fa6)" ;
            5'd17: PrintReg = RegType==`REG_TYPE_INT ? "x17(a7)"  : "f17(fa7)" ;
            5'd18: PrintReg = RegType==`REG_TYPE_INT ? "x18(s2)"  : "f18(fs2)" ;
            5'd19: PrintReg = RegType==`REG_TYPE_INT ? "x19(s3)"  : "f19(fs3)" ;
            5'd20: PrintReg = RegType==`REG_TYPE_INT ? "x20(s4)"  : "f20(fs4)" ;
            5'd21: PrintReg = RegType==`REG_TYPE_INT ? "x21(s5)"  : "f21(fs5)" ;
            5'd22: PrintReg = RegType==`REG_TYPE_INT ? "x22(s6)"  : "f22(fs6)" ;
            5'd23: PrintReg = RegType==`REG_TYPE_INT ? "x23(s7)"  : "f23(fs7)" ;
            5'd24: PrintReg = RegType==`REG_TYPE_INT ? "x24(s8)"  : "f24(fs8)" ;
            5'd25: PrintReg = RegType==`REG_TYPE_INT ? "x25(s9)"  : "f25(fs9)" ;
            5'd26: PrintReg = RegType==`REG_TYPE_INT ? "x26(s10)" : "f26(fs10)";
            5'd27: PrintReg = RegType==`REG_TYPE_INT ? "x27(s11)" : "f27(fs11)";
            5'd28: PrintReg = RegType==`REG_TYPE_INT ? "x28(t3)"  : "f28(ft8)" ;
            5'd29: PrintReg = RegType==`REG_TYPE_INT ? "x29(t4)"  : "f29(ft9)" ;
            5'd30: PrintReg = RegType==`REG_TYPE_INT ? "x30(t5)"  : "f30(ft10)";
            5'd31: PrintReg = RegType==`REG_TYPE_INT ? "x31(t6)"  : "f31(ft11)";
        endcase
    end
endfunction
function [15:0] DT2C(input [`DATA_TYPE__LEN-1:0] DataType);
    begin
        case(DataType)
            `DATA_TYPE_B  : DT2C = "B";
            `DATA_TYPE_H  : DT2C = "H";
            `DATA_TYPE_W  : DT2C = "W";
            `DATA_TYPE_D  : DT2C = "D";
            `DATA_TYPE_BU : DT2C = "BU";
            `DATA_TYPE_HU : DT2C = "HU";
            `DATA_TYPE_WU : DT2C = "DU";
            default:        DT2C = "XX";
        endcase
    end
endfunction

function [(36*8)-1:0] PrintEcauseStr(input [`ECAUSE_LEN-1:0] Ecause);
    begin
        case(Ecause)
            `EXC_IADDR_MISALIGN : PrintEcauseStr = "trap_instruction_address_misaligned";
            `EXC_IACCESS_FAULT  : PrintEcauseStr = "trap_instruction_access_fault";
            `EXC_ILLEGAL_INSTR  : PrintEcauseStr = "trap_illegal_instruction";
            `EXC_BREAKPOINT     : PrintEcauseStr = "trap_breakpoint";
            `EXC_LADDR_MISALIGN : PrintEcauseStr = "trap_load_address_misaligned";
            `EXC_LACCESS_FAULT  : PrintEcauseStr = "trap_load_access_fault";
            `EXC_SADDR_MISALIGN : PrintEcauseStr = "trap_store_address_misaligned";
            `EXC_SACCESS_FAULT  : PrintEcauseStr = "trap_store_access_fault";
            `EXC_ECALL_UMODE    : PrintEcauseStr = "trap_user_ecall";
            `EXC_ECALL_SMODE    : PrintEcauseStr = "trap_supervisor_ecall";
            `EXC_ECALL_MMODE    : PrintEcauseStr = "trap_machine_ecall";
            `EXC_IPAGE_FAULT    : PrintEcauseStr = "trap_instruction_page_fault";
            `EXC_LPAGE_FAULT    : PrintEcauseStr = "trap_load_page_fault";
            `EXC_SPAGE_FAULT    : PrintEcauseStr = "trap_store_page_fault";
            default             : PrintEcauseStr = "trap_unknown";
        endcase
    end
endfunction

