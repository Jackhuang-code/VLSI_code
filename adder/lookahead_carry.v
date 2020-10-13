module lookahead_carry_4(
    input [3:0] a, b,
    input cin,
    output [3:0] sum,
    output cout
);
wire [3:0] p, g, c;
pg u0(a, b, p, g);
assign c[0] = g[0] | (p[0] & cin);
assign c[1] = g[1] | (g[0] & p[1]) | (cin & p[1] & p[0]);
assign c[2] = g[2] | (g[1] & p[2]) | (g[0] & p[2] & p[1]) | (cin & p[2] & p[1] & p[0]);
assign c[3] = g[3] | (g[2] & p[3]) | (g[1] & p[3] & p[2]) | (g[0] & p[3] & p[2] & p[1]) | (cin & p[3] & p[2] & p[1] & p[0]);
assign sum = p ^ {c[2:0], cin};
assign cout = c[3];
endmodule

module carry_chain_4(
    input [3:0] p,g,
    input cin,
    output [3:0] c
);
assign c[0] = g[0] | (p[0] & cin);
assign c[1] = g[1] | (g[0] & p[1]) | (cin & p[1] & p[0]);
assign c[2] = g[2] | (g[1] & p[2]) | (g[0] & p[2] & p[1]) | (cin & p[2] & p[1] & p[0]);
assign c[3] = g[3] | (g[2] & p[3]) | (g[1] & p[3] & p[2]) | (g[0] & p[3] & p[2] & p[1]) | (cin & p[3] & p[2] & p[1] & p[0]);
endmodule

module lookahead_carry_16(
    input [15:0] a, b,
    input cin,
    output [15:0] sum,
    output cout
);

wire [4:0] carry;
wire [3:0] tmp_p, tmp_g, unuse;
wire [15:0] p, g;
assign carry[0] = cin;
assign cout = carry[4];

genvar i;
generate
for (i = 0; i < 4; i = i + 1)
begin
  lookahead_carry_4 u0(a[4*i+3:4*i], b[4*i+3:4*i], carry[i], sum[4*i+3:4*i], unuse[i]);
  pg  u1(a[4*i + 3:4*i], b[4*i + 3:4*i], p[4*i+3:4*i], g[4*i+3:4*i]);
  assign tmp_p[i] = &p[4*i+3:4*i];
  assign tmp_g[i] = g[4*i+3] | (g[4*i+2] & p[4*i+3]) | (g[4*i+1] & p[4*i+3] & p[4*i+2]) | (g[4*i] & p[4*i+3] & p[4*i+2] & p[4*i+1]);
end
endgenerate

carry_chain_4 u0(tmp_p, tmp_g, cin, carry[4:1]);
endmodule

module lookahead_carry_32(
    input [31:0] a, b,
    output [31:0] sum,
    output cout
);
wire carry;
lookahead_carry_16 u0(a[15:0], b[15:0], 0, sum[15:0], carry);
lookahead_carry_16 u1(a[31:16], b[31:16], carry, sum[31:16], cout);

endmodule