`define DEL 10
module syn_tb;

reg clock,reset_n,read_n,write_n;
reg [7:0] in_data;
wire [7:0] out_data;
wire full,empty;

integer fifo_count;
reg [7:0] exp_data;
reg fast_read,fast_write;
reg filled_flag;
reg cycle_count;

Syns_FIFO synfifo_tb(.clk(clock),.rst(reset_n),.din(in_data),.rd_en(read_n),.wr_en(write_n),.dout(out_data),.full(full),.empty(empty));

initial
   begin
      in_data=0;
      exp_data=0;
      fifo_count=0;
      read_n=1;
      write_n=1;
      filled_flag=0;
      cycle_count=0;
      clock=1;

      fast_read=0;
      fast_write=1;

      reset_n=1;
      #20 reset_n=0;
      #20  reset_n=1;

     if(empty!==1)
         begin
           $display("\nerror at time %0t:",$time);
           $display("after reset,empty status not asserted\n");
           $stop;
         end
    if(full!==0)
          begin
            $display("\nerror at time %0t:",$time);
            $display("\nerror  at time %0t:",$time);
            $stop;
          end
  end

always #100 clock=~clock;

always @(posedge clock)
   begin
       if(~write_n && read_n)
          fifo_count=fifo_count+1;
       else if(write_n && ~read_n)
          fifo_count=fifo_count-1;
   end

always @(negedge clock)
      begin
        if(~read_n && (out_data!==exp_data))
             begin
                $display("\nerror at time %0t:",$time);
                $display("expected data ut=%h",exp_data);
                $display("actual data ut=%h\n",out_data);
                $stop;
             end
        if((fast_write||(cycle_count&1'b1))&&~full)//?
             begin
                write_n=0;
                in_data=in_data+1;
             end
        else
             write_n=1;
        if((fast_read||(cycle_count&1'b1))&&~empty)//?
             begin
                read_n=0;
                exp_data=exp_data+1;
             end
        else
             read_n=1;
        if(full)
           begin
               fast_read=1;
               fast_write=0;
               filled_flag=1;
            end
        if(filled_flag&&empty)
            begin
             $display("\nsimulation complete -no errors\n");
             $finish;
            end
         cycle_count=cycle_count+1;
      end
always@(fifo_count)
       begin
        # `DEL;
        # `DEL;
        # `DEL;
        case (fifo_count)
        0:begin
             if((empty!==1)||(full!==0))
                begin
                   $display("\nerror at time %0t:",$time);
                   $display("fifo_count=%h",fifo_count);
                   $display("empty=%h\n",empty);
                   $display("full=%h\n",full);
                   $stop;
             end
             if(filled_flag==1)
                  begin
                   $display("\nsimulation complete -no error\n");
                   $finish;
                   end
          end
        15:begin
            if((empty!==0)||(full!==1))
              begin
                   $display("\nerror at time %0t:",$time);
                   $display("fifo_count=%h",fifo_count);
                   $display("empty=%h\n",empty);
                   $display("full=%h\n",full);
                   $stop;
              end
            filled_flag=1;
            fast_write=0;
            fast_read=1;
           end
        default:begin
                 if((empty!==0)||(full!==0))
                     begin
                        $display("\nerror at time %0t:",$time);
                        $display("fifo_count=%h",fifo_count);
                        $display("empty=%h\n",empty);
                        $display("full=%h\n",full);
                        $stop;
                      end
                 end
        endcase
      end
endmodule