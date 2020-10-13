module carry_select #(parameter width = 32)
(
    input [width-1:0] a,b,
    output [width-1:0] sum,
    output cout
);

wire [width>>2 - 1:0] select;
wire [width>>2 - 2:0] select0, select1;
wire [width - 5:0] tmp_sum0, tmp_sum1;
assign cout = select[width>>2 - 1];

ripple_carry #(.width(4)) u0(a[3:0], b[3:0], 1'b0, sum[3:0], select[0]);

genvar i;
generate
for (i = 1; i < width >> 2; i = i + 1)
begin:carry_select
    ripple_carry #(.width(4)) u1(a[4*i + 3:4*i], b[4*i+3:4*i], 1'b0, tmp_sum0[4*i-1:4*i-4], select0[i-1]);
    ripple_carry #(.width(4)) u2(a[4*i + 3:4*i], b[4*i+3:4*i], 1'b1, tmp_sum1[4*i-1:4*i-4], select1[i-1]);
    assign select[i] = select[i-1]? select1[i-1]:select0[i-1];
    assign sum[4*i + 3:4*i] = select[i-1]? tmp_sum1[4*i-1:4*i-4]:tmp_sum0[4*i-1:4*i-4];
end
endgenerate
endmodule
