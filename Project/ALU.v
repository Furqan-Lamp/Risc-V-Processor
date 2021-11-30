module alu#(parameter WIDTH=32)(in_a, in_b, control, alu_out, a_is_zero);

input [WIDTH-1 :0] in_a;
input [WIDTH-1 :0] in_b;
input [3:0] control;
output reg a_is_zero;
output reg [WIDTH-1 :0] alu_out;

always@(*)
begin
	case(control)
	4'b0000: 
		alu_out = in_a + in_b; //Add
	4'b0001:
		alu_out = in_a - in_b; //Sub
	4'b0010:
		alu_out = in_a << in_b;// SLL
	4'b0011:
		begin
		if($signed(in_a) < $signed(in_b))
		alu_out = 32'b1;
		else
		alu_out = 32'b0; //SLT
		end
		
	4'b0100:
		begin
		if(in_a < in_b) //SLTU
		alu_out = 32'b1;
		else 
		alu_out = 32'b0;
		end

		
	4'b0101:
		alu_out = in_a ^ in_b;//XOR
	4'b0110:
		alu_out = in_a >> in_b;//SRL
	4'b0111:
		alu_out = in_a >>> in_b; //SRA
	4'b1000: 
		alu_out = in_a | in_b;//OR
	4'b1001: 
		alu_out = in_a & in_b; // AND
	default:
		alu_out = 'bz;
	endcase	
		a_is_zero = in_a ? 0 : 1;
end
endmodule 
