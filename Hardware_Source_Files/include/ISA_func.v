//Function: ISA_get_offset
//Returns Sign extended offset for control flow instructions
//param [instr]   : 32 bit instruction (in case of 16 bit upper half word is ignored)
//param [is16bit] : 1=> 16 bit instruction (RVC)
//param [isJtype] : 1=> J type encoding
//param [isBtype] : 1=> B type encoding
//param [isItype] : 1=> I type encoding
function [63:0] ISA_get_offset
(
    input [31:0] instr,
    input is16bit,
    input isJtype,
    input isBtype,
    input isItype
);
begin
    if(is16bit==1'b1) begin
        if(isJtype==1'b1) begin //C.J
            ISA_get_offset[ 11]   = instr[  12];
            ISA_get_offset[  4]   = instr[  11];
            ISA_get_offset[9:8]   = instr[10:9];
            ISA_get_offset[ 10]   = instr[   8];
            ISA_get_offset[  6]   = instr[   7];
            ISA_get_offset[  7]   = instr[   6];
            ISA_get_offset[3:1]   = instr[ 5:3];
            ISA_get_offset[  5]   = instr[   2];
            ISA_get_offset[  0]   = 1'b0;
            ISA_get_offset[63:12] = {52{instr[12]}};
        end
        else if(isBtype==1'b1) begin  //C.BEQZ or C.BNEZ
            ISA_get_offset[  8]   = instr[   12];
            ISA_get_offset[4:3]   = instr[11:10];
            ISA_get_offset[7:6]   = instr[ 6: 5];
            ISA_get_offset[2:1]   = instr[ 4: 3];
            ISA_get_offset[  5]   = instr[    2];
            ISA_get_offset[  0]   = 1'b0;
            ISA_get_offset[63: 9] = {55{instr[12]}};
        end
        //C.JALR & C.JR has no offset
        else
            ISA_get_offset = 64'd0;

    end
    else begin
        if(isJtype==1'b1) begin      //JAL
            ISA_get_offset[   20]   = instr[   31];
            ISA_get_offset[10: 1]   = instr[30:21];
            ISA_get_offset[   11]   = instr[   20];
            ISA_get_offset[19:12]   = instr[19:12];
            ISA_get_offset[    0]   = 1'b0;
            ISA_get_offset[63:21]   = {43{instr[31]}};
        end
        else if(isItype==1'b1) begin //JALR
            ISA_get_offset[11: 0]   = instr[31:20];
            ISA_get_offset[63:12]   = {52{instr[31]}};
        end
        else if(isBtype==1'b1) begin //Branch
            ISA_get_offset[  12]   = instr[   31];
            ISA_get_offset[10:5]   = instr[30:25];
            ISA_get_offset[ 4:1]   = instr[11: 8];
            ISA_get_offset[  11]   = instr[    7];
            ISA_get_offset[  0]    = 1'b0;
            ISA_get_offset[63:13]  = {51{instr[31]}};
        end
        else
            ISA_get_offset = 64'd0;
    end
end
endfunction

//Immediate Unpacking functions
//Extracts 32-bit immediate from 32-bit instructions
function [31:0] Unpack_I(input [31:0] instr);
begin
    Unpack_I[11: 0]   = instr[31:20];
    Unpack_I[31:12]   = {20{instr[31]}};
end
endfunction

function [31:0] Unpack_S(input [31:0] instr);
begin
    Unpack_S[11: 5]   = instr[31:25];
    Unpack_S[4 : 0]   = instr[11:7];
    Unpack_S[31:12]   = {20{instr[31]}};
end
endfunction

function [31:0] Unpack_B(input [31:0] instr);
begin
    Unpack_B[   12]   = instr[   31];
    Unpack_B[10: 5]   = instr[30:25];
    Unpack_B[ 4: 1]   = instr[11: 8];
    Unpack_B[   11]   = instr[    7];
    Unpack_B[    0]   = 1'b0;
    Unpack_B[31:13]   = {19{instr[31]}};
end
endfunction

function [31:0] Unpack_U(input [31:0] instr);
begin
    Unpack_U[31:12]   = instr[31:12];
    Unpack_U[11: 0]   = 12'd0;
end
endfunction

function [31:0] Unpack_J(input [31:0] instr);
begin
    Unpack_J[   20]   = instr[   31];
    Unpack_J[10: 1]   = instr[30:21];
    Unpack_J[   11]   = instr[   20];
    Unpack_J[19:12]   = instr[19:12];
    Unpack_J[    0]   = 1'b0;
    Unpack_J[31:21]   = {11{instr[31]}};
end
endfunction

//Packs 32-bit immediate and 32-bit instruction (without immediate)
//into complete 32-bit instr
function [31:0] Pack_I(input [31:0] instr, input [31:0] imm);
begin
    Pack_I        = instr;
    Pack_I[31:20] = imm[11:0];
end
endfunction

function [31:0] Pack_S(input [31:0] instr, input [31:0] imm);
begin
    Pack_S        = instr;
    Pack_S[31:25] = imm[11:5];
    Pack_S[11: 7] = imm[4:0];
end
endfunction

function [31:0] Pack_B(input [31:0] instr, input [31:0] imm);
begin
    Pack_B        = instr;
    Pack_B[   31] = imm[   12];
    Pack_B[30:25] = imm[10: 5];
    Pack_B[11: 8] = imm[ 4: 1];
    Pack_B[    7] = imm[   11];
end
endfunction

function [31:0] Pack_U(input [31:0] instr, input [31:0] imm);
begin
    Pack_U        = instr;
    Pack_U[31:12] = imm[31:12];
end
endfunction

function [31:0] Pack_J(input [31:0] instr, input [31:0] imm);
begin
    Pack_J        = instr;
    Pack_J[   31] = imm[   20];
    Pack_J[30:21] = imm[10: 1];
    Pack_J[   20] = imm[   11];
    Pack_J[19:12] = imm[19:12];
end
endfunction

