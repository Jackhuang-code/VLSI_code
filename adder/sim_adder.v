`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/11 23:14:17
// Design Name: 
// Module Name: sim_adder
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


module sim_adder();
reg [31:0] a,b;
wire [31:0] sum;
//reg [3:0] a,b;
//wire [3:0] sum;
wire cout;

initial begin
  a = 32'h1233_ab71;
  b = 32'h0756_bdef;
  //198A 6960
  #10
  a = 32'hffde_1234;
  b = 32'hfede_ffd1;
  //1 FEBD 1205
  #10
  a = 32'hf3a1_565f;
  b = 32'h156a_1dfe;
  //1 090B 745D
  #10
  a = 32'hf3f7_565f;
  b = 32'h156a_1aae;
  #10
  a = 32'hf241_142f;
  b = 32'h1542_57fe;
  #10
  a = 32'hffe1_575f;
  b = 32'h1524_199e;
  #10
  a = 32'hfed1_595f;
  b = 32'h175a_1d5e;
//  a = 4'ha;
//  b = 4'hb;
end

//ripple_carry u0(a, b, 0, sum, cout);
//carry_skip u1(a,b,sum,cout);
//carry_select u2(a,b,sum,cout);
//lookahead_carry_32 u3(a,b,sum,cout);
kogge_stone_32 u4(a,b,sum,cout);
endmodule
