module RegisterFile(
 input clk,
 input rst,
 input RegWEn,
 input [4:0] AddrD, //Destination Address
 input [4:0] AddrA,
 input [4:0] AddrB,
 input [31:0] DataD, // Incoming Processed Data
 output [31:0] DataA,
 output [31:0] DataB
);
	reg [31:0] reg_array [31:0];
	integer i;
	integer k;
always@*
begin
	if(rst) begin
	 	for(i=0 ; i<32; i=i+1)
		reg_array[i] <= 32'b0;
  	end 
end

always@(negedge clk)
begin
	if(RegWEn)
	begin
		reg_array[AddrD]<= DataD;
	end
end

assign DataA = reg_array[AddrA];
assign DataB = reg_array[AddrB];

initial 
begin
 for(k=0 ; k<32 ; k=k+1) 
	reg_array[k]= k;
end
endmodule


