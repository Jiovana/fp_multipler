 /*
@INPROCEEDINGS{8355536,
  author={Miao, Jia and Li, Shuguo},
  booktitle={2017 IEEE International Symposium on Consumer Electronics (ISCE)},
  title={A design for high speed leading-zero counter},
  year={2017},
  volume={},
  number={},
  pages={22-23},
  doi={10.1109/ISCE.2017.8355536}
} */

module lzc_miao_8_old (
  input [7:0] in,
  output wire [2:0] out_z,
  output wire v
  );
  wire q1, q2, q3, q4, q5, q6, q7;
  wire g1, g2, g3, g4;

  assign q1 = !(in[7] | in[6]);
  assign q2 = !(in[7] | (!in[6] & in[5]));
  assign q3 = !(in[5] | in[4]);
  assign q4 = in[4] | in[6];
  assign q5 = !(in[3] | in[2]);
  assign q6 = !(in[3] | (!in[2] & in[1]));
  assign q7 = !(in[1] | in[0]);

  assign g1 = !(q1 & q3);
  assign g2 = !(q1 & (!q3 | q5));
  assign g3 = !(q2 & (q4 | q6));
  assign g4 = !(q5 & q7);

  assign out_z[0] = g3;
  assign out_z[1] = g2;
  assign out_z[2] = g1;
  assign v = (g1 | g4);
endmodule

module lzc_miao_16 (
  input [15:0] in,
  output wire [3:0] out_z,
  output wire v
  );
  wire [2:0] zh, zl;
  wire vh, vl;
  lzc_miao_8 lzc_8_h (.in (in[15:8]), .out_z (zh), .v (vh));
  lzc_miao_8 lzc_8_l (.in (in[7:0]), .out_z (zl), .v (vl));

  assign out_z[0] = !(!zh[0] & (!vh & zl[0]));
  assign out_z[1] = !(!zh[1] & (!vh & zl[1]));
  assign out_z[2] = !(!zh[2] & (!vh & zl[2]));
  assign out_z[3] = !vh;
  assign v = !(vh | vl);
endmodule


module lzc_miao_8 (
  input  [7:0] in,
  output reg [2:0] out_z,
  output wire v
);

  assign v = |in;

  always @(*) begin
    casex (in)
      8'b1???????: out_z = 3'd0;
      8'b01??????: out_z = 3'd1;
      8'b001?????: out_z = 3'd2;
      8'b0001????: out_z = 3'd3;
      8'b00001???: out_z = 3'd4;
      8'b000001??: out_z = 3'd5;
      8'b0000001?: out_z = 3'd6;
      8'b00000001: out_z = 3'd7;
      default:     out_z = 3'd0; // undefined, v = 0
    endcase
  end
endmodule
 
module miao_lzc32 (
  input  [31:0] in,
  output reg [4:0] out_z,
  output wire v
);
	
	wire [2:0] z0, z1, z2, z3;
	wire v0, v1, v2, v3;
	

  lzc_miao_8 lzc_8_0 (.in (in[31:24]), .out_z (z0), .v (v0));
  lzc_miao_8 lzc_8_1 (.in (in[23:16]), .out_z (z1), .v (v1));
  lzc_miao_8 lzc_8_2 (.in (in[15:8]), .out_z (z2), .v (v2));
  lzc_miao_8 lzc_8_3 (.in (in[7:0]), .out_z (z3), .v (v3));
  
  assign v = (v3 | v2 | v1 | v0);
  
  always @(*) begin
    if (v0)
      out_z = 5'd0 + z0;               // bits 31–24
    else if (v1)
      out_z = 5'd8  + z1;       // bits 23–16
    else if (v2)
      out_z = 5'd16 +  z2;       // bits 15–8
    else if (v3)
      out_z = 5'd24 + z3;       // bits 7–0
    else
      out_z = 5'd0;             // undefined
  end

endmodule
