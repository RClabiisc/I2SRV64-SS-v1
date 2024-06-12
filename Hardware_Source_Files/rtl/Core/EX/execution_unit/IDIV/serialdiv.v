//******************************************************************************
// Copyright (c) 2018 - 2023, Indian Institute of Science, Bangalore.
// All Rights Reserved. See LICENSE for license details.
//------------------------------------------------------------------------------

// Contributors // Manish Kumar(manishkumar5@iisc.ac.in), Shubham Yadav(shubhamyadav@iisc.ac.in)
// Sajin S (sajins@alum.iisc.ac.in), Shubham Sunil Garag (shubhamsunil@alum.iisc.ac.in)
// Anuj Phegade (anujphegade@alum.iisc.ac.in), Deepshikha Gusain (deepshikhag@alum.iisc.ac.in)
// Ronit Patel (ronitpatel@alum.iisc.ac.in), Vishal Kumar (vishalkumar@alum.iisc.ac.in)
// Kuruvilla Varghese (kuru@iisc.ac.in)
//******************************************************************************
`timescale 1ns/1ps

(* keep_hierarchy = "yes" *)
module serialdiv
#(
  parameter WIDTH       = 64
)
(
  input  wire clk,
  input  wire rst,
  input  wire flush,                            //1=>cancel current division process

  input  wire [WIDTH-1:0]          input1,      //input 1
  input  wire [WIDTH-1:0]          input2,      //input 2
  input  wire [1:0]                operation,   // 00:DIVU, 10:REMU, 01:DIV, 11:REM
  input  wire                      input_valid, //1=>input data will be latched & division will be started

  output reg                       ready,       //1=>FU is ready to receive input
  output reg                       output_valid,//1=>output is valid
  output wire [WIDTH-1:0]          result       //result for input1/input2 according to operation selected
);

//FSM states
localparam [1:0] IDLE = 2'b00;
localparam [1:0] DIVIDE = 2'b01;
localparam [1:0] FINISH = 2'b11;

reg  [1:0]                  state_d, state;     //state of FSM
reg  [WIDTH-1:0]            res;                //residue register also results in remainder
reg  [WIDTH-1:0]            op1;                //latched input1 also results in quotient
reg  [WIDTH-1:0]            op2;                //latched input2
reg                         op2_zero;           //latched (input2==0) result
reg                         rem_sel;            //latched operation[1] 1=>rem 0=>div
reg                         comp_inv;           //latched main comparator result invert signal (depends on input2 sign & operation[0])
reg                         res_inv;            //latched control for output result inversion. (depends on signs of inputs & operation)
reg                         div_res_zero;       //latched signal indicating |input1|<|input2| (i.e. div_result=0, rem_result=input1)
reg  [$clog2(WIDTH+1)-1:0]  cnt;                //register to count no. of shift operations after alignment

//next value wires
wire [WIDTH-1:0]            res_d, op1_d, op2_d;
wire                        op2_zero_d;
wire                        rem_sel_d;
wire                        comp_inv_d;
wire                        res_inv_d;
wire                        div_res_zero_d;
wire [$clog2(WIDTH+1)-1:0]  cnt_d;

//internal signal wires
wire                        input2_zero;
wire                        op1_sign, op2_sign;
wire                        lzc_a_no_one, lzc_b_no_one;
wire                        ab_comp, pm_sel;
wire                        cnt_zero;
wire [WIDTH-1:0]            add_mux;
wire [WIDTH-1:0]            add_out;
wire [WIDTH-1:0]            add_tmp;
wire [WIDTH-1:0]            b_mux;
wire [WIDTH-1:0]            out_mux;
wire [WIDTH-1:0]            lzc_a_input;
wire [WIDTH-1:0]            lzc_b_input;
wire [WIDTH-1:0]            op2_shifted;
wire [$clog2(WIDTH)-1:0]    lzc_a_result;
wire [$clog2(WIDTH)-1:0]    lzc_b_result;
wire [$clog2(WIDTH+1)-1:0]  shift_a;
wire [$clog2(WIDTH+1):0]    div_shift;
reg                         a_reg_en;
reg                         b_reg_en;
reg                         res_reg_en;
reg                         load_en;


///////////////////////////////////////////////////////////////////////////////
// align the input operands for faster division
assign input2_zero = (input2 == 0);
assign op1_sign = input1[WIDTH-1];
assign op2_sign = input2[WIDTH-1];

assign lzc_a_input = (operation[0] & op1_sign) ? {~input1, 1'b0} : input1;
assign lzc_b_input = (operation[0] & op2_sign) ? ~input2         : input2;

lzc #(.MODE(1), .WIDTH(WIDTH)) lzc_a // count leading zeros
(
  .in    ( lzc_a_input  ),
  .cnt   ( lzc_a_result ),
  .empty ( lzc_a_no_one )
);

lzc #(.MODE(1), .WIDTH(WIDTH)) lzc_b // count leading zeros
(
  .in    ( lzc_b_input  ),
  .cnt   ( lzc_b_result ),
  .empty ( lzc_b_no_one )
);

assign shift_a      = (lzc_a_no_one) ? WIDTH : lzc_a_result;
assign div_shift    = (lzc_b_no_one) ? WIDTH : lzc_b_result-shift_a;

assign op2_shifted  = input2 <<< $unsigned(div_shift);

//if |opB| > |opA| then division is zero and can be terminated
assign div_res_zero_d = (load_en) ? ($signed(div_shift) < 0) : div_res_zero;

assign pm_sel      = load_en & ~(operation[0] & (op1_sign ^ op2_sign));

assign add_mux     = (load_en)   ? input1  : op2;

assign b_mux       = (load_en)   ? op2_shifted : {comp_inv, (op2[WIDTH-1:1])};  //logical shift by one in case of negative operand B!

assign out_mux     = (rem_sel) ? op1 : res;

assign result      = (res_inv) ? -$signed(out_mux) : out_mux;      //invert result if required

assign ab_comp     = ((op1 == op2) | ((op1 > op2) ^ comp_inv)) & ((|op1) | op2_zero); // main comparator

assign add_tmp     = (load_en) ? 0 : op1;
assign add_out     = (pm_sel)  ? add_tmp + add_mux : add_tmp - $signed(add_mux);


assign cnt_zero = (cnt == 0);
assign cnt_d    = (load_en) ? div_shift : (~cnt_zero) ? (cnt-1) : cnt;

always @* begin
  // default
  state_d        = state;
  ready          = 1'b0;
  output_valid   = 1'b0;
  load_en        = 1'b0;
  a_reg_en       = 1'b0;
  b_reg_en       = 1'b0;
  res_reg_en     = 1'b0;

  case(state)
      IDLE: begin
          ready = 1'b1;
          if (input_valid) begin
              a_reg_en  = 1'b1;
              b_reg_en  = 1'b1;
              load_en   = 1'b1;
              ready     = 1'b0;
              state_d   = DIVIDE;
          end
      end
    DIVIDE: begin
        output_valid = 1'b0;
        ready        = 1'b0;
        if(~div_res_zero) begin
            a_reg_en     = ab_comp;
            b_reg_en     = 1'b1;
            res_reg_en   = 1'b1;
        end
        if(div_res_zero | cnt_zero) begin
            state_d = FINISH;
        end
    end
    FINISH: begin
        output_valid = 1'b1;
        ready        = 1'b1;
        state_d      = IDLE;
    end
    default : state_d = IDLE;
  endcase

  if (flush) begin
      ready         = 1'b1;
      output_valid  = 1'b0;
      a_reg_en      = 1'b0;
      b_reg_en      = 1'b0;
      load_en       = 1'b0;
      state_d       = IDLE;
  end
end


assign rem_sel_d    = (load_en) ? operation[1] : rem_sel;
assign comp_inv_d   = (load_en) ? operation[0] & op2_sign : comp_inv;
assign op2_zero_d   = (load_en) ? input2_zero : op2_zero;
assign res_inv_d    = (load_en) ? (~input2_zero | operation[1]) & operation[0] & (op1_sign ^ op2_sign) : res_inv;

assign op1_d   = (a_reg_en)  ? add_out : op1;
assign op2_d   = (b_reg_en)  ? b_mux   : op2;
assign res_d   = (load_en)   ? 0       : (res_reg_en) ? {res[WIDTH-1:0], ab_comp} : res;

always @(posedge clk) begin
  if (rst) begin
    state        <= IDLE;
    op1          <= 0;
    op2          <= 0;
    res          <= 0;
    cnt          <= 0;
    rem_sel      <= 1'b0;
    comp_inv     <= 1'b0;
    res_inv      <= 1'b0;
    op2_zero     <= 1'b0;
    div_res_zero <= 1'b0;
  end
  else begin
    state        <= state_d;
    op1          <= op1_d;
    op2          <= op2_d;
    res          <= res_d;
    cnt          <= cnt_d;
    rem_sel      <= rem_sel_d;
    comp_inv     <= comp_inv_d;
    res_inv      <= res_inv_d;
    op2_zero     <= op2_zero_d;
    div_res_zero <= div_res_zero_d;
  end
end

endmodule


///////////////////////////////////////////////////////////////////////////////
// A trailing zero counter / leading zero counter.
// Set MODE to 0 for trailing zero counter => cnt is the number of trailing zeros (from the LSB)
// Set MODE to 1 for leading zero counter  => cnt is the number of leading zeros  (from the MSB)
// If the input does not contain a zero, `empty` is asserted. Additionally `cnt` contains
// the maximum number of zeros - 1. For example:
//   in = 000_0000, empty = 1, cnt = 6 (mode = 0)
//   in = 000_0001, empty = 0, cnt = 0 (mode = 0)
//   in = 000_1000, empty = 0, cnt = 3 (mode = 0)

module lzc
#(
  parameter WIDTH = 32,
  parameter MODE  = 1'b0 // 0=>trailing zero, 1=>leading zero
)
(
  input  wire [WIDTH-1:0]           in,
  output wire [$clog2(WIDTH)-1:0]   cnt,
  output wire                       empty // asserted if all bits in in are zero
);

    localparam NUM_LEVELS = $clog2(WIDTH);

    wire [NUM_LEVELS-1:0]       index_lut[WIDTH-1:0] ;
    wire [2**NUM_LEVELS-1:0]    sel_nodes;
    wire [NUM_LEVELS-1:0]       index_nodes[2**NUM_LEVELS-1:0];
    wire [WIDTH-1:0]            in_tmp;

    // reverse vector if required
    genvar i;
    generate
        for (i=0; i<WIDTH; i=i+1) begin
            assign in_tmp[i] = (MODE) ? in[WIDTH-1-i] : in[i];
        end
    endgenerate

    genvar j;
    generate
        for (j=0;j< WIDTH;j=j+1) begin
            assign index_lut[j] = j;
        end
    endgenerate

    genvar level, k, l;
    generate
        for (level = 0;level< NUM_LEVELS; level=level+1) begin
            if (level== NUM_LEVELS-1) begin : g_last_level
                for (k=0;k<2**level;k=k+1) begin : g_level
                    if (2*k < WIDTH-1) begin
                        assign sel_nodes[2**level-1+k]   = in_tmp[k*2] | in_tmp[k*2+1];
                        assign index_nodes[2**level-1+k] = (in_tmp[k*2] == 1'b1) ? index_lut[k*2] :
                            index_lut[k*2+1];
                    end

                    if (2*k == WIDTH-1) begin
                        assign sel_nodes[2**level-1+k]   = in_tmp[k*2];
                        assign index_nodes[2**level-1+k] = index_lut[k*2];
                    end

                    if (2*k> WIDTH-1) begin
                        assign sel_nodes[2**level-1+k]   = 1'b0;
                        assign index_nodes[2**level-1+k] = 0;
                    end
                end
            end else begin
                for (l=0; l<2**level; l=l+1) begin : g_level
                    assign sel_nodes[2**level-1+l]   = sel_nodes[2**(level+1)-1+l*2] | sel_nodes[2**(level+1)-1+l*2+1];
                    assign index_nodes[2**level-1+l] = (sel_nodes[2**(level+1)-1+l*2] == 1'b1) ? index_nodes[2**(level+1)-1+l*2] :
                        index_nodes[2**(level+1)-1+l*2+1];
                end
            end
        end

        assign cnt   = NUM_LEVELS>0 ? index_nodes[0] : {($clog2(WIDTH)){1'b0}};
        assign empty = NUM_LEVELS>0 ? ~sel_nodes[0]  : ~(|in);

    endgenerate

endmodule

