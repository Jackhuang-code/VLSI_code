`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/12 13:13:29
// Design Name: 
// Module Name: kogge_stone_32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module black_cell(
  input Gik, Pik, Gk_1j, Pk_1j,
  output Gij, Pij
);
assign Gij = Gik | (Pik & Gk_1j);
assign Pij = Pik & Pk_1j;
endmodule

module gray_cell(
  input Gik, Pik, Gk_1j,
  output Gij
);
assign Gij = Gik | (Pik & Gk_1j);
endmodule

module buffer(
  input a,
  output b
);
buf u0(b,a);
endmodule

module kogge_stone_32(
  input [31:0] a, b,
  output [31:0] sum,
  output cout
);

wire [31:0] p,g;
pg #(.width(32)) u0(a, b, p, g);
//first floor
wire buf0_0;
buffer u7(g[0], buf0_0);

wire g0_1;
gray_cell u1(g[1], p[1], g[0], g0_1);

wire [29:0] bg_1, bp_1;
genvar i;
generate
for (i = 2; i < 32; i = i + 1)
begin
  black_cell u8(g[i], p[i], g[i-1], p[i-1], bg_1[i-2], bp_1[i-2]);
end
endgenerate

//second floor
wire buf1_1;
buffer u6(g0_1, buf1_1);

wire g1_1, g1_2;
gray_cell u9(bg_1[0], bp_1[0], buf0_0, g1_1);
gray_cell u10(bg_1[1], bp_1[1], g0_1, g1_2);

wire [27:0] bg_2, bp_2;
genvar i1;
generate
for (i1 = 4; i1 < 32; i1 = i1 + 1)
begin
  black_cell u2(bg_1[i1-2], bp_1[i1-2], bg_1[i1-4], bp_1[i1-4], bg_2[i1-4], bp_2[i1-4]);
end
endgenerate

//third floor
//buffer
wire [1:0] buff_2;
buffer u11(g1_1, buff_2[0]);
buffer u12(g1_2, buff_2[1]);
//gray_cell
wire [3:0] g2, pre_g2;
assign pre_g2 = {g1_2,g1_1,buf1_1,buf0_0};
genvar i2;
generate
for (i2 = 4; i2 < 8; i2 = i2 + 1)
begin
  gray_cell u2(bg_2[i2-4], bp_2[i2-4], pre_g2[i2-4], g2[i2-4]);
end
endgenerate
//black_cell
wire [23:0] bg_3, bp_3;
genvar i3;
generate
for (i3 = 8; i3 < 32; i3 = i3 + 1)
begin
  black_cell u2(bg_2[i3-4], bp_2[i3-4], bg_2[i3-8], bp_2[i3-8], bg_3[i3-8], bp_3[i3-8]);
end
endgenerate

//fourth floor
wire [3:0] buff_3;
genvar i4;
generate
for (i4 = 4; i4 < 8; i4 = i4 + 1)
begin
  buffer u3(g2[i4-4], buff_3[i4-4]);
end
endgenerate

wire [7:0] g3, pre_g3;
assign pre_g3 = {g2, buff_2, buf1_1,buf0_0};
genvar i5;
generate
for (i5 = 8; i5 < 16; i5 = i5 + 1)
begin
  gray_cell u2(bg_3[i5-8], bp_3[i5-8], pre_g3[i5-8], g3[i5-8]);
end
endgenerate

wire [15:0] bg_4, bp_4;
genvar i6;
generate
for (i6 = 16; i6 < 32; i6 = i6 + 1)
begin
  black_cell u2(bg_3[i6-8], bp_3[i6-8], bg_3[i6-16], bp_3[i6-16], bg_4[i6-16], bp_4[i6-16]);
end
endgenerate

//fifth floor
wire [7:0] buff_4;
genvar i7;
generate
for (i7 = 8; i7 < 16; i7 = i7 + 1)
begin
  buffer u3(g3[i7-8], buff_4[i7-8]);
end
endgenerate

wire [15:0] g4, pre_g4;
assign pre_g4 = {g3, buff_3, buff_2, buf1_1, buf0_0};
genvar i8;
generate
for (i8 = 16; i8 < 32; i8 = i8 + 1)
begin
  gray_cell u2(bg_4[i8-16], bp_4[i8-16], pre_g4[i8-16], g4[i8-16]);
end
endgenerate

assign sum = p ^ {g4[14:0], buff_4, buff_3, buff_2, buf1_1, buf0_0, 1'b0};
assign cout = g4[15];

endmodule
