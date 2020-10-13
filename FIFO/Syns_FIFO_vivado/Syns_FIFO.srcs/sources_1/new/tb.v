`timescale 1ns / 1ps

module FIFO_tb();
reg clk, rst, wr_en, rd_en;
reg [7:0] din;
wire [7:0] dout;
wire empty, full;

always #5 clk = ~clk;

initial begin
  clk = 0;
  rst = 1; wr_en = 0; rd_en = 0; din = 8'h00;
  #10
  rst = 0; wr_en = 1; rd_en = 0; din = 8'h01;
  #10
  rst = 0; wr_en = 1; rd_en = 0; din = 8'h02;
  #10
  rst = 0; wr_en = 1; rd_en = 0; din = 8'h03;
  #10
  rst = 0; wr_en = 1; rd_en = 0; din = 8'h04;
  #10
  rst = 0; wr_en = 1; rd_en = 0; din = 8'h05;
  #10
  rst = 0; wr_en = 1; rd_en = 1; din = 8'hff;
  #10
  rst = 0; wr_en = 1; rd_en = 0; din = 8'hfe;
  #10
  rst = 0; wr_en = 1; rd_en = 0; din = 8'hfd;
  #10
  rst = 0; wr_en = 0; rd_en = 1; din = 8'h06;
  #10
  rst = 0; wr_en = 0; rd_en = 1; din = 8'h07;
  #10
  rst = 0; wr_en = 0; rd_en = 1; din = 8'h08;
  #10
  rst = 0; wr_en = 0; rd_en = 1; din = 8'h09;
  #10
  rst = 0; wr_en = 0; rd_en = 1; din = 8'h0a;
  #10
  rst = 0; wr_en = 1; rd_en = 1; din = 8'hff;
  #10
  $finish;
end

Syns_FIFO u0(clk, rst, wr_en, rd_en, din, dout, empty, full);
endmodule