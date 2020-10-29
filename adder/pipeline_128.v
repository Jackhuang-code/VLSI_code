`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/28 19:58:40
// Design Name: 
// Module Name: pipeline_128
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

module DFF #(parameter width = 1)
(
    input clk,
    input rst,
    input [width - 1:0] din,
    output reg [width - 1:0] dout
);
    always @ (posedge clk)
    begin
        if (rst)
            dout <= 0;
        else
            dout <= din;
    end
endmodule


module pipeline_128(
    input clk,
    input rst,
    input [127:0] a,
    input [127:0] b,
    output [127:0] sum,
    output cout
    );
    
    wire [127:0] tmp_sum;
    wire [3:0] tmp_carry;

    //第一级
    wire [95:0] dff1a, dff1b;
    DFF #(96) u0(clk, rst, a[127:32], dff1a);
    DFF #(96) u1(clk, rst, b[127:32], dff1b);

    ripple_carry_32 u4(a[31:0], b[31:0], 1'b0, tmp_sum[31:0], tmp_carry[0]);
    wire [31:0] dff1s;
    DFF #(32) u2(clk, rst, tmp_sum[31:0], dff1s);
    wire dff1c;
    DFF u3(clk, rst, tmp_carry[0], dff1c);

    //第二级
    ripple_carry_32 u5(dff1a[31:0], dff1b[31:0], dff1c, tmp_sum[63:32], tmp_carry[1]);
    wire [63:0] dff2s;
    DFF #(64) u8(clk, rst, {tmp_sum[63:32], dff1s}, dff2s);
    wire dff2c;
    DFF u9(clk, rst, tmp_carry[1], dff2c);


    wire [63:0] dff2a, dff2b;
    DFF #(64) u6(clk, rst, dff1a[95:32], dff2a);
    DFF #(64) u7(clk, rst, dff1b[95:32], dff2b);

    //第三级
    ripple_carry_32 u10(dff2a[31:0], dff2b[31:0], dff2c, tmp_sum[95:64], tmp_carry[2]);
    wire [95:0] dff3s;
    DFF #(96) u11(clk, rst, {tmp_sum[95:64], dff2s}, dff3s);
    wire dff3c;
    DFF u12(clk, rst, tmp_carry[2], dff3c);

    wire [31:0] dff3a, dff3b;
    DFF #(32) u13(clk, rst, dff2a[63:32], dff3a);
    DFF #(32) u14(clk, rst, dff2b[63:32], dff3b);

    
    //第四级
    ripple_carry_32 u15(dff3a, dff3b, dff3c, tmp_sum[127:96], tmp_carry[3]);
    DFF #(128) u16(clk, rst, {tmp_sum[127:96], dff3s}, sum);
    DFF u17(clk, rst, tmp_carry[3], cout);

endmodule
