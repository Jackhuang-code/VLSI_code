`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/09 11:26:04
// Design Name: 
// Module Name: Syns_FIFO
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


module Syns_FIFO
#(parameter WIDTH = 4'd8, LOG2DEPTH = 2'd2)
(
    input clk, rst, wr_en, rd_en,
    input [WIDTH-1:0] din,
    output [WIDTH-1:0] dout,
    output reg empty,
    output reg full
    );


reg [WIDTH-1:0] ram [(1<<LOG2DEPTH)-1:0];
reg [LOG2DEPTH-1:0] rp, wp;

//write
always @(posedge clk)
    begin
        if ((wr_en & ~full) || (full & wr_en & rd_en))
            begin
                ram[wp] <= din;
                end
    end
    
//read
assign dout = (rd_en & ~empty)? ram[rp] : 0;

//generate write pointer
always @(posedge clk)
begin
    if (rst)
        wp <= 0;
    else if ((wr_en & ~full) || (full & wr_en & rd_en))
        wp <= wp + 1;          
end

//generate read pointer
always@ (posedge clk)
begin
    if (rst)
        rp <= 0;
    else if (rd_en & ~empty)
        rp <= rp + 1;
end

//generate full flag
always @(posedge clk)
begin
    if (rst)
        full <= 0;
    //list the condition that may change the full status
    else if ((wr_en & ~rd_en) && (rp == wp + 1))
        full <= 1;
    else if (full & rd_en)
        full <= 0;
end

//generate empty flag
always @ (posedge clk)
begin
    if (rst)
        empty <= 1;
     else if (wr_en & empty)
        empty <= 0;
     else if ((rd_en & ~wr_en) && (wp == rp + 1))
        empty <= 1;
end
endmodule
