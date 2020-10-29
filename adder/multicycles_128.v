`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/28 10:56:00
// Design Name: 
// Module Name: multicycles_128
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


module multicycles_128(
    input clk,
    input rst,
    input [127:0] a, b,
    output reg [127:0] sum,
    output reg cout
    );
    reg [31:0] addera, adderb;
    wire [31:0] tmp_sum;
    reg carry = 1'b0;
    wire carry_nxt;

    ripple_carry_32 u0(addera, adderb, carry, tmp_sum, carry_nxt);

    localparam [1:0]
    s0 = 2'b00,
    s1 = 2'b01,
    s2 = 2'b10,
    s3 = 2'b11;

    reg [1:0] state = 2'b11, state_nxt;
    always @(posedge clk)
    begin
        if (rst)
            state <= s0;
        else
            state <= state_nxt;
        carry <= carry_nxt;
    end

    always @*
    begin
        if (state == s0)
            state_nxt <= s1;
        else if (state == s1)
            state_nxt <= s2;
        else if (state == s2)
            state_nxt <= s3;
        else
            state_nxt <= s0;
    end

    always @*
    begin
        if (state == s0)
        begin
            addera <= a[31:0];
            adderb <= b[31:0];
            sum[31:0] <= tmp_sum;
        end
        else if (state == s1)
        begin
            addera <= a[63:32];
            adderb <= b[63:32];
            sum[63:32] <= tmp_sum;
        end
        else if (state == s2)
        begin
            addera <= a[95:64];
            adderb <= b[95:64];
            sum[95:64] <= tmp_sum;
        end
        else
        begin
            addera <= a[127:96];
            adderb <= b[127:96];
            sum[127:96] <= tmp_sum;
            cout <= carry_nxt;
        end
    end
endmodule
 