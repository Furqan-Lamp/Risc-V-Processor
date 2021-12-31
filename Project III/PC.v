module PC(
input clk,
input [31:0] pc_in,
input NOP,
output reg [31:0] pc_out
);

initial
begin
	pc_out=0;
end

always@(posedge clk)
begin
	if(NOP)
	begin
	pc_out <= pc_out;
	end
	else
	pc_out <= pc_in;
	
end
endmodule 