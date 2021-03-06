module tb;

reg clk;
reg rst;
reg RegWEn;
reg [4:0] AddrD;
reg [4:0] AddrA;
reg [4:0] AddrB;
reg [31:0] DataD;
wire [31:0] DataA;
wire [31:0] DataB;

RegisterFile reg1 (
.clk(clk),
.rst(rst),
.RegWEn(RegWEn),
.AddrA(AddrA),
.AddrB(AddrB),
.AddrD(AddrD),
.DataD(DataD),
.DataA(DataA),
.DataB(DataB)
);

always
begin
#5 clk =1; #5 clk=0; 
end

initial 
begin
	
rst = 1;
#10
RegWEn = 1;
AddrA = 11001;
AddrB = 00111;
AddrD = 10101;
DataD = 1244;


end
endmodule 