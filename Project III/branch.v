module branch(
input [2:0] funct3,
input [31:0] DataA,
input [31:0] DataB,
input BrUn,
output reg BrEq,
output reg BrLT,
output reg Bne,
output reg Bge,
output reg Bltu,
output reg Bgeu
);

always@*
begin
	case(funct3)
	3'b000: begin
		if($signed(DataA) == $signed(DataB))
			begin
			BrEq=1;
			//PCSel=1;
			end
		else 
			BrEq=0;
	end
	3'b001: begin
		if($signed(DataA)!= $signed(DataB))
			Bne=1;
		else 
			Bne=0;
	end
	3'b100: begin
		if($signed(DataA) < $signed(DataB))
			BrLT=1;
		else 
			BrLT=0;
	end
	3'b101: begin
		if($signed(DataA) >= $signed(DataB))
			Bge=1;
		else 
			Bge=0;
	end

	3'b110: begin 
		if(DataA < DataB)
		Bltu=1;
	else
		Bltu=0;
	end
	
	3'b111 : begin
		if(DataA >= DataB)
		Bgeu =1;
	else
		Bgeu =0;
	end
	endcase
end 
endmodule 