module NOP(
input NOP_1,
input [31:0] instruction, 
output reg [31:0] instruction_out);

always@*
begin
if(NOP_1==1)
	instruction_out = 0;
else 
	instruction_out = instruction;

end
endmodule 