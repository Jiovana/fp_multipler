module int_to_fp32 (
    input  wire [31:0] int_in,
    output wire        Exception,
    output wire        Overflow,
    output wire        Underflow,
    output wire [31:0] result
);

wire        sign;
wire [31:0] abs_val;
wire [4:0]  leading_zeros;
wire [7:0]  exponent_raw;
wire [22:0] mantissa;
wire        round_up, guard_bit, round_bit, sticky_bit;
wire [55:0] shifted_val;
wire [31:0] int_abs_shifted;
wire [23:0] mantissa_round, mantissa_ext;
wire [7:0]  exponent_final;
wire        mantissa_overflow;
wire        is_zero;
wire [4:0] out_lzc;
wire v_lzc;

wire [5:0] num_bits, num_exp;
wire [22:0] mantissa_piece;

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

assign num_bits = 'd32 - leading_zeros;
assign num_exp = num_bits - 1;

// Shifted value aligned to MSB for mantissa extraction
assign int_abs_shifted = abs_val << leading_zeros;

assign mantissa_piece = int_abs_shifted[31:8]; 

//assign exponent_raw = 'd127 + num_exp;

// Mantissa bits
//assign shifted_val = {int_abs_shifted, 24'd0};  // for GRS
assign guard_bit  = int_abs_shifted[7]; // bit after the mantissa
assign round_bit  = int_abs_shifted[6]; // next bit after
assign sticky_bit = |int_abs_shifted[5:0]; // the rest
assign round_up   = guard_bit & (round_bit | sticky_bit | mantissa_piece[0]);

assign mantissa_ext = {1'b0, mantissa_piece}; //extend for carry
assign mantissa_round = mantissa_ext + round_up;

assign mantissa_overflow = mantissa_round[23]; // means shift was necessary

assign mantissa = mantissa_overflow ? mantissa_round[22:0] >> 1 : mantissa_round[22:0];

//assign exponent_raw = 8'd127 - leading_zeros + mantissa_overflow; // 127 - LZ + overflow adjust
assign exponent_raw = 8'd127 + num_exp + mantissa_overflow;

assign exponent_final = is_zero ? 8'd0 : exponent_raw;

// Exception/Overflow/Underflow logic
assign Exception = 1'b0; // Not used for integers
assign Overflow  = (exponent_final >= 8'd255) && !is_zero;
assign Underflow = (abs_val != 0) && (exponent_final == 0);
assign result    = is_zero   ? 32'd0 :
                   Overflow  ? {sign, 8'hFF, 23'd0} :
                   Underflow ? {sign, 31'd0} :
                   {sign, exponent_final, mantissa_piece};

endmodule
