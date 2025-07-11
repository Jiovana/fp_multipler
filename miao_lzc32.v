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

// ignore this name, it is not based on paper anymore but quartus demands to have it the same name as the file
module miao_lzc32 (
  input  [31:0] in,
  output [4:0]  out_z,
  output        v
);

  wire [3:0] group_valid;
  wire [3:0] group_lzc [3:0];

  // Generate 8-bit LZCs for each byte of the input
  assign group_valid[3] = |in[31:24];
  assign group_lzc[3] = (in[31]) ? 3'd0 :
                        (in[30]) ? 3'd1 :
                        (in[29]) ? 3'd2 :
                        (in[28]) ? 3'd3 :
                        (in[27]) ? 3'd4 :
                        (in[26]) ? 3'd5 :
                        (in[25]) ? 3'd6 :
                        (in[24]) ? 3'd7 : 4'd8;

  assign group_valid[2] = |in[23:16];
  assign group_lzc[2] = (in[23]) ? 3'd0 :
                        (in[22]) ? 3'd1 :
                        (in[21]) ? 3'd2 :
                        (in[20]) ? 3'd3 :
                        (in[19]) ? 3'd4 :
                        (in[18]) ? 3'd5 :
                        (in[17]) ? 3'd6 :
                        (in[16]) ? 3'd7 : 4'd8;

  assign group_valid[1] = |in[15:8];
  assign group_lzc[1] = (in[15]) ? 3'd0 :
                        (in[14]) ? 3'd1 :
                        (in[13]) ? 3'd2 :
                        (in[12]) ? 3'd3 :
                        (in[11]) ? 3'd4 :
                        (in[10]) ? 3'd5 :
                        (in[9])  ? 3'd6 :
                        (in[8])  ? 3'd7 : 4'd8;

  assign group_valid[0] = |in[7:0];
  assign group_lzc[0] = (in[7]) ? 3'd0 :
                        (in[6]) ? 3'd1 :
                        (in[5]) ? 3'd2 :
                        (in[4]) ? 3'd3 :
                        (in[3]) ? 3'd4 :
                        (in[2]) ? 3'd5 :
                        (in[1]) ? 3'd6 :
                        (in[0]) ? 3'd7 : 4'd8;

  // Bitwise priority encoder (no casex)
  wire [1:0] sel;
  wire [1:0] sel2;
  assign sel = (group_valid[3]) ? 2'd3 :
               (group_valid[2]) ? 2'd2 :
               (group_valid[1]) ? 2'd1 :
               (group_valid[0]) ? 2'd0 : 2'd0;
					
					
  assign sel2 = (group_valid[3]) ? 2'd0 :
                (group_valid[2]) ? 2'd1 :
                (group_valid[1]) ? 2'd2 :
                (group_valid[0]) ? 2'd3 : 2'd0;

  wire [3:0] local_lzc;
  assign local_lzc = group_lzc[sel];
  

  assign out_z = {sel2,local_lzc[2:0]} ;

  assign v = |in;

endmodule

