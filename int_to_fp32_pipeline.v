module int_to_fp32_pipeline (
    input wire         clk, rst,
    input  wire [31:0] int_in,
    output wire        Exception,
    output wire        Overflow,
    output wire        Underflow,
    output wire [31:0] result
);

wire        sign;
wire [31:0] abs_val;
wire [4:0]  leading_zeros;
wire [8:0]  exponent_raw;
wire [22:0] mantissa;
wire        round_up, guard_bit, round_bit, sticky_bit;
wire [55:0] shifted_val;
wire [31:0] int_abs_shifted;
wire [23:0] mantissa_round, mantissa_ext;
wire [8:0]  exponent_final;
wire        mantissa_overflow;
wire        is_zero;
wire [4:0] out_lzc;
wire v_lzc;

wire [5:0] num_bits, num_exp;
wire [22:0] mantissa_piece;

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/// pipeline stage 1
assign sign = int_in[31];

// Absolute value
assign abs_val = sign ? (~int_in + 1) : int_in;

// Detect zero
assign is_zero = (abs_val == 32'd0);

// leading zeros counter module 
miao_lzc32 lzc (
    .in     (abs_val),
    .out_z  (out_lzc),
    .v      (v_lzc)
  );

assign leading_zeros = out_lzc;

// Shifted value aligned to MSB for mantissa extraction
assign int_abs_shifted = abs_val << leading_zeros;

assign num_bits = 'd32 - leading_zeros;
assign num_exp = num_bits - 'b1;

reg is_zero_reg, sign_reg;
reg [5:0] num_exp_reg;
reg [31:0] int_abs_shifted_reg;
always @(posedge clk) begin
    if (!rst) begin
      is_zero_reg         <= 'b0;
      num_exp_reg         <= 'b0;
      int_abs_shifted_reg <= 'b0;
      sign_reg            <= 'b0;
    end else begin
      is_zero_reg         <= is_zero;
      num_exp_reg         <= num_exp;
      int_abs_shifted_reg <= int_abs_shifted;
      sign_reg            <= sign;
    end
end

/////////////////////////////////////////////////////////////////////////////////////////////////////
/// pipeline stage 2


assign mantissa_piece = int_abs_shifted_reg[31:8]; 

//assign exponent_raw = 'd127 + num_exp;

// Mantissa bits
//assign shifted_val = {int_abs_shifted, 24'd0};  // for GRS
assign guard_bit  = int_abs_shifted_reg[7]; // bit after the mantissa
assign round_bit  = int_abs_shifted_reg[6]; // next bit after
assign sticky_bit = |int_abs_shifted_reg[5:0]; // the rest
assign round_up   = guard_bit & (round_bit | sticky_bit | mantissa_piece[0]);

assign mantissa_ext = {1'b0, mantissa_piece}; //extend for carry
assign mantissa_round = mantissa_ext + round_up;

assign mantissa_overflow = mantissa_round[23]; // means shift was necessary

assign mantissa = mantissa_overflow ? mantissa_round[22:0] >> 1 : mantissa_round[22:0];

//assign exponent_raw = 8'd127 - leading_zeros + mantissa_overflow; // 127 - LZ + overflow adjust
assign exponent_raw = 8'd127 + num_exp_reg + mantissa_overflow;

assign exponent_final = is_zero_reg ? 8'd0 : exponent_raw;

// Exception/Overflow/Underflow logic
assign Exception = 1'b0; // Not used for integers
assign Overflow  = (exponent_final[8] & !exponent_final[7]) && !is_zero_reg;
assign Underflow = !is_zero_reg && (~|exponent_final);
assign result    = is_zero_reg   ? 32'd0 :
                   Overflow  ? {sign_reg, 8'hFF, 23'd0} :
                   Underflow ? {sign_reg, 31'd0} :
                   {sign_reg, exponent_final[7:0], mantissa};

endmodule
