module watch(
    input clk, rst
    output [3:0] d0, d1, d2
);

reg div_clk;
reg [22:0] cnt;
always @(posedge clk)
begin
   if (cnt == 23'd5000000)//分频10Hz
   begin
     cnt <= 0;
     div_clk <= ~div_clk;
   end
   else
    cnt = cnt + 23'b1;
end

always @(posedge div_clk)
begin
  if (rst)
  begin
    d0 <= 0;
    d1 <= 0;
    d2 <= 0;
  end
  else
  begin
    if (d0 != 4'b1001)
        d0 <= d0 + 4'b1;
    else
    begin
      d0 <= 4'b0;
      if (d1 != 4'b1001)
        d1 <= d1 + 4'b1;
      else
      begin
        d1 <= 4'b0;
        if (d2 != 4'b1001)
            d2 <= d2 + 4'b1;
        else
            d2 <= 4'b0;
      end
    end
  end
end
endmodule

module seg(
    input clk,
    input [3:0] d0, d1, d2
    output [7:0] sw,
    output [3:0] an
);

reg div_clk;
reg [16:0] cnt;
always @(posedge clk)
begin
   if (cnt == 17'b1_0000_0000_0000_0000)//分频800Hz左右
   begin
     cnt <= 0;
     div_clk <= ~div_clk;
   end
   else
    cnt = cnt + 23'b1;
end

reg [3:0] select = 4'b1000;
always @(posedge div_clk)
begin
  select = {select[2:0], select[3]};
end

reg [4:0] data_orin;
always@(select)
begin
  case (select)
  4'b1000: data_orin = 5'0_1111;
  4'b0100: data_orin = {1'b0,d2};
  4'b0010: data_orin = {1'b1,d1};
  4'b0001: data_orin = {1'b0,d0};
end

reg [7:0] data;
always @(data_orin)
begin
  case (data_orin)
    5'b0_0000:data=8'b1100_0000;//0 
    5'b0_0001:data=8'b1111_1001;//1 
    5'b0_0010:data=8'b1010_0100;//2 
    5'b0_0011:data=8'b1011_0000;//3 
    5'b0_0100:data=8'b1001_1001;//4 
    5'b0_0101:data=8'b1001_0010;//5 
    5'b0_0110:data=8'b1000_0010;//6 
    5'b0_0111:data=8'b1111_1000;//7 
    5'b0_1000:data=8'b1000_0000;//8 
    5'b0_1001:data=8'b1001_0000;//9
    5'b1_0000:data=8'b0100_0000;//0 
    5'b1_0001:data=8'b0111_1001;//1 
    5'b1_0010:data=8'b0010_0100;//2 
    5'b1_0011:data=8'b0011_0000;//3 
    5'b1_0100:data=8'b0001_1001;//4 
    5'b1_0101:data=8'b0001_0010;//5 
    5'b1_0110:data=8'b0000_0010;//6 
    5'b1_0111:data=8'b0111_1000;//7 
    5'b1_1000:data=8'b0000_0000;//8 
    5'b1_1001:data=8'b0001_0000;//9  
    default:data=8'1111_1111;//
end
assign an = select;
assign sw = data;
endmodule