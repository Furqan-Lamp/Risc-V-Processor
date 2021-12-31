module Final_Tb;

reg clk;
reg rst;
wire [31:0]DataDest;

datapath finalpath(
.clk(clk),
.rst(rst),
.DataDest(DataDest)
);

 initial begin  
           clk =0;  
           forever #10 clk = ~clk;  
      end  

initial 
begin 
	rst=0;

end
endmodule 