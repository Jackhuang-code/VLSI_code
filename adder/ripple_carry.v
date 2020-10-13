module full_adder(
    input a, b, cin,
    output sum, cout
);

assign sum = a ^ b ^ cin;
assign cout = (a & b) | ((a ^ b) & cin);
endmodule

module pg #(parameter width = 4)
(
    input [width-1:0] a, b,
    output [width-1:0] p,g
);

assign p = a ^ b;
assign g = a & b;
endmodule

module ripple_carry #(parameter width = 32)
(
    input [width-1:0] a,b,
    input cin,
    output [width-1:0] sum,
    output cout
);

wire [width:0] carry;
assign carry[0] = cin;
assign cout = carry[width];
genvar i;
generate
for ( i = 0; i < width; i = i + 1)
begin
  full_adder u0(a[i], b[i], carry[i], sum[i], carry[i + 1]);
end
endgenerate
endmodule