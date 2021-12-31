module ALU_Control(
input [6:0] opcode,
input [2:0] funct3,
input [6:0] funct7,
output reg [3:0] ALUControl
);

always@*
begin
	case(opcode)
	7'b0110011: begin  //R-Type
		case(funct3)
			3'b000: begin
				if(funct7[5]==0)
				ALUControl <= 4'b0000; // ADD
				else if(funct7[5]==1)
				ALUControl <= 4'b0001;    // SUB
   				end
                        3'b001: ALUControl <= 4'b0010;    // SLL
                    	3'b010: ALUControl <= 4'b0011;   // SLT
                    	3'b011: ALUControl <= 4'b0100;   // SLTU
                    	3'b100: ALUControl <= 4'b0101;   // XOR
                    	3'b101: begin
				if(funct7[5]==0)   
				ALUControl <= 4'b0110; // SRL
				else if (funct7[5]==1)
				ALUControl <= 4'b0111; //SRA
				end
                    	3'b110: ALUControl <= 4'b1000;   // OR
                    	3'b111: ALUControl <= 4'b1001;   // AND
		endcase
		end 
	
	7'b0010011 : begin //I-Type Basic
		case(funct3)
			3'b000: ALUControl <= 4'b0000;   // ADD
                    	3'b001: ALUControl <= 4'b0010;   // SLLi
                    	3'b010: ALUControl <= 4'b0011;   // SLTi
                    	3'b011: ALUControl <= 4'b0100;   // SLTUi
                    	3'b100: ALUControl <= 4'b0101;   // XORi
                    	3'b101: begin
				if(funct7[5]==0)   
				ALUControl <= 4'b0110; // SRLi
				else if (funct7[5]==1)
				ALUControl <= 4'b0111; // SRAi
				end
                    	3'b110: ALUControl <= 4'b1000;   // ORi
                    	3'b111: ALUControl <= 4'b1001;   // ANDi
		endcase
		end 
	7'b0000011 : begin //I-Type Load 
		case(funct3)
			3'b000: ALUControl <= 4'b0000; //Add Immediate
			default : ALUControl <= 4'b0000;
		endcase
		end
	
	7'b1100011 : begin //SB-Type Load 
		case(funct3)
			3'b000: begin 
			ALUControl <= 4'b0000; //Add Immediate
			end
			default : ALUControl <= 4'b0000;
		endcase
		end
	7'b1100111:begin   //<
		ALUControl <= 4'b0000; 
		end
	default: ALUControl <= 4'b0000; 
	endcase
end

endmodule 