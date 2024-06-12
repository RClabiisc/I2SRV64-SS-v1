
//Creates 16 bit mask from Address and Data Type. Each bit in mask represents
//that the corresponding byte is used from 64-bit aligned base.
function [15:0] AddrType2Mask(input [55:0] paddr, input [2:0] DataType);
    reg [15:0] mask;
    begin
        case (DataType)
            `DATA_TYPE_B,`DATA_TYPE_BU  : mask = 16'h0001;
            `DATA_TYPE_H,`DATA_TYPE_HU  : mask = 16'h0003;
            `DATA_TYPE_W,`DATA_TYPE_WU  : mask = 16'h000f;
            `DATA_TYPE_D                : mask = 16'h00ff;
            default                     : mask = 16'h0000;
        endcase

        AddrType2Mask = mask<<paddr[2:0];
    end
endfunction

//Aligns the data as to 64-bit aligned base address paddr(hence 8 bytes are kept for
//overflow)
//e.g. data = 0x12345678_90abcdef addr=0x---5
//output=0x00000012_34567890_abcdef00_00000000
function [127:0] AlignDataByAddr(input [63:0] data, input [55:0] paddr);
    reg [127:0] ExtendedData;
    begin
        ExtendedData    = {64'b0,data};
        AlignDataByAddr = ExtendedData<<{paddr[2:0],3'b000};
    end
endfunction


//Converts LSU Operation to Access Type
function [`MEM_ACCESS__LEN-1:0] LSUoper2AccessType(input [`LSU_OPER__LEN-1:0] LSUoper);
    begin
        case(LSUoper)
            `LSU_OPER_LOAD     : LSUoper2AccessType = `MEM_ACCESS_READ;
            `LSU_OPER_STORE    : LSUoper2AccessType = `MEM_ACCESS_WRITE;
            `LSU_OPER_AMOLOAD  : LSUoper2AccessType = `MEM_ACCESS_READ;
            `LSU_OPER_AMOSTORE : LSUoper2AccessType = `MEM_ACCESS_WRITE;
            `LSU_OPER_AMOLR    : LSUoper2AccessType = `MEM_ACCESS_READ;
            `LSU_OPER_AMOSC    : LSUoper2AccessType = `MEM_ACCESS_WRITE;
            default            : LSUoper2AccessType = `MEM_ACCESS_NONE;
        endcase
    end
endfunction


//Finds if LSU Operation is Atomic
function IsLSUOperAtomic(input [`LSU_OPER__LEN-1:0] LSUoper);
    begin
        case(LSUoper)
            `LSU_OPER_LOAD     : IsLSUOperAtomic = 1'b0;
            `LSU_OPER_STORE    : IsLSUOperAtomic = 1'b0;
            `LSU_OPER_AMOLOAD  : IsLSUOperAtomic = 1'b1;
            `LSU_OPER_AMOSTORE : IsLSUOperAtomic = 1'b1;
            `LSU_OPER_AMOLR    : IsLSUOperAtomic = 1'b1;
            `LSU_OPER_AMOSC    : IsLSUOperAtomic = 1'b1;
            default            : IsLSUOperAtomic = 1'b0;
        endcase
    end
endfunction


//Function to check overlap based on addr and data_type
function IsAddrOverlap(input [63:0] Addr0, input [2:0] DataType0, input [63:0] Addr1, input [2:0] DataType1);
    reg [15:0] mask0, mask1;
    reg [15:0] mask0_alligned, mask1_alligned;
    begin
        //generate mask for both requests
        mask0 = AddrType2Mask(Addr0[55:0],DataType0);
        mask1 = AddrType2Mask(Addr1[55:0],DataType1);

        //align mask1 keeping mask0 as reference
        mask0_alligned = mask0;
        mask1_alligned = (Addr0[63:3]   == Addr1[63:3])   ? mask1                 : (
                         (Addr0[63:3]+1 == Addr1[63:3])   ? {8'b0, mask1[15:8]}   : (
                         (Addr0[63:3]-1 == Addr1[63:3])   ? {mask1[7:0],8'b0}     : 16'b0 ));

        //Check if mask overlaps
        IsAddrOverlap = |(mask0_alligned & mask1_alligned);
    end
endfunction

