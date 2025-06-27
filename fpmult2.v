// by gpt

module Multiplication2 (
    input  [31:0] a_operand,
    input  [31:0] b_operand,
    output        Exception,
    output        Overflow,
    output        Underflow,
    output [31:0] result
);

wire sign, normalised, zero;
wire [8:0] exponent, sum_exponent;
wire [22:0] product_mantissa;
wire [23:0] operand_a, operand_b;
wire [47:0] product, product_normalised;
wire guard_bit, round_bit, sticky_bit, round_up;

// Determine sign
assign sign = a_operand[31] ^ b_operand[31];

// Check for NaNs or Infs (exponent 255)
assign Exception = (&a_operand[30:23]) | (&b_operand[30:23]);

// Normalize significands
assign operand_a = (|a_operand[30:23]) ? {1'b1, a_operand[22:0]} : {1'b0, a_operand[22:0]};
assign operand_b = (|b_operand[30:23]) ? {1'b1, b_operand[22:0]} : {1'b0, b_operand[22:0]};

// Multiply 24-bit significands
assign product = operand_a * operand_b;

// Normalization: check if MSB (bit 47) is set
assign normalised = product[47];

// Normalize: shift left by 1 if MSB is 0
assign product_normalised = normalised ? product : product << 1;

// Extract rounding bits (round to nearest, ties to even)
assign guard_bit  = product_normalised[23];
assign round_bit  = product_normalised[22];
assign sticky_bit = |product_normalised[21:0];

assign round_up = guard_bit & (round_bit | sticky_bit | product_normalised[24]);

// Apply rounding
wire [22:0] mantissa_pre_round = product_normalised[46:24];
wire [22:0] mantissa_rounded   = mantissa_pre_round + round_up;

// Detect mantissa overflow after rounding (e.g., 0xFFFFFF + 1 => 0x1000000)
wire mantissa_overflow = &mantissa_pre_round & round_up;

// Adjust exponent for normalization and rounding overflow
wire [8:0] raw_exponent = a_operand[30:23] + b_operand[30:23] - 8'd127 + normalised + mantissa_overflow;
assign sum_exponent = raw_exponent;

// Final mantissa (if overflow occurred, shift right)
assign product_mantissa = mantissa_overflow ? mantissa_rounded >> 1 : mantissa_rounded;

// Zero detection
wire a_is_zero = (a_operand[30:23] == 8'd0) && (a_operand[22:0] == 23'd0);
wire b_is_zero = (b_operand[30:23] == 8'd0) && (b_operand[22:0] == 23'd0);
wire either_operands_zero = a_is_zero | b_is_zero;
assign zero = Exception ? 1'b0 :
              either_operands_zero ? 1'b1 :
              ((product_mantissa == 23'd0) && (exponent == 0));

// Overflow & Underflow
assign Overflow  = (sum_exponent >= 9'd255) && !zero;
assign Underflow = (sum_exponent <= 9'd0) && !zero;

// Final output
assign exponent = (Overflow || Underflow || zero) ? 9'd0 : sum_exponent;

assign result = Exception ? 32'd0 :
                zero     ? {sign, 31'd0} :
                Overflow ? {sign, 8'hFF, 23'd0} :
                Underflow ? {sign, 31'd0} :
                {sign, exponent[7:0], product_mantissa};

endmodule
