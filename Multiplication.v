///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//File Name: Multiplication.v
//Created By: Sheetal Swaroop Burada
//Date: 30-04-2019
//Project Name: Design of 32 Bit Floating Point ALU Based on Standard IEEE-754 in Verilog and its implementation on FPGA.
//University: Dayalbagh Educational Institute
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module Multiplication(
		input [31:0] a_operand,
		input [31:0] b_operand,
		output Exception,Overflow,Underflow,
		output [31:0] result
		);

wire sign,product_round,normalised,zero;
wire [8:0] exponent,sum_exponent;
wire [22:0] product_mantissa;
wire [23:0] operand_a,operand_b;
wire [47:0] product,product_normalised; //48 Bits
wire guard_bit, round_bit, sticky_bit, round_up;


assign sign = a_operand[31] ^ b_operand[31];

//Exception flag sets 1 if either one of the exponent is 255.
assign Exception = (&a_operand[30:23]) | (&b_operand[30:23]);

//Assigining significand values according to Hidden Bit.
//If exponent is equal to zero then hidden bit will be 0 for that respective significand else it will be 1

assign operand_a = (|a_operand[30:23]) ? {1'b1,a_operand[22:0]} : {1'b0,a_operand[22:0]};

assign operand_b = (|b_operand[30:23]) ? {1'b1,b_operand[22:0]} : {1'b0,b_operand[22:0]};

assign product = operand_a * operand_b;			//Calculating Product

//assign product_round = |product_normalised[22:0];  //Ending 22 bits are OR'ed for rounding operation.

assign normalised = product[47] ? 1'b1 : 1'b0;	

assign product_normalised = normalised ? product : product << 1;	//Assigning Normalised value based on 48th bit

// new rounding logic nearest to even
assign guard_bit = product_normalised[23];
assign round_bit = product_normalised[22];
assign sticky_bit = |product_normalised[21:0];

assign round_up = guard_bit & (round_bit | sticky_bit | product_normalised[24]);

assign product_mantissa = product_normalised[46:24] + round_up;

//Final Manitssa.
//assign product_mantissa = product_normalised[46:24] + (product_normalised[23] & product_round); 
wire a_is_zero = (a_operand[30:23] == 8'd0) && (a_operand[22:0] == 23'd0);
wire b_is_zero = (b_operand[30:23] == 8'd0) && (b_operand[22:0] == 23'd0);
wire either_operands_zero = a_is_zero | b_is_zero;

assign zero = Exception ? 1'b0 : either_operands_zero ? 1'b1 : 
((product_mantissa == 23'd0) && (exponent == 0));

assign sum_exponent = a_operand[30:23] + b_operand[30:23];

assign exponent = sum_exponent - 8'd127 + normalised;

assign Overflow = ((exponent[8] & !exponent[7]) && !zero) ; //If overall exponent is greater than 255 then Overflow condition.
//Exception Case when exponent reaches its maximu value that is 384.

//If sum of both exponents is less than 127 then Underflow condition.
assign Underflow = ((exponent[8] & exponent[7]) && !zero) ? 1'b1 : 1'b0; 

assign result = Exception ? 32'd0 : zero ? {sign,31'd0} : Overflow ? {sign,8'hFF,23'd0} : Underflow ? {sign,31'd0} : {sign,exponent[7:0],product_mantissa};


endmodule