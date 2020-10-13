module carry_skip #(parameter width = 32)
(
    input [width-1:0] a,b,
    output [width-1:0] sum,
    output cout
);

wire [width>>2:0] carry;
wire [width>>2 - 1:0] skip;
wire [width-1:0] p, g;
assign carry[0] = 1'b0;
assign cout = carry[width>>2];

genvar i;
generate
for (i = 0; i < width>>2;i = i + 1)
begin:carry_skip
    ripple_carry #(.width(4)) u0(a[4*i + 3:4*i], b[4*i + 3:4*i], carry[i], sum[4*i+3:4*i], skip[i]);
    pg  u1(a[4*i + 3:4*i], b[4*i + 3:4*i], p[4*i+3:4*i], g[4*i+3:4*i]);
    assign carry[i+1] = (&p[4*i+3:4*i])? carry[i] : skip[i];  //&
end
endgenerate
endmodule
