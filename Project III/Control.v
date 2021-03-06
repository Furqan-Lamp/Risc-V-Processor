module Control(
input [31:0] inst_x,
input [31:0] inst_m,
input [31:0] inst_w,
input NOP,
output reg PCSel,
output reg [2:0] ImmSel,
output reg RegWEn_m,
output reg RegWEn_w, 
output reg BrUn, 
output reg BSel, 
output reg ASel, 
output reg MemRW, 
output reg [1:0] WBSel,
output reg [2:0] Size ,
output reg [3:0] ALUControl);

/// Reg_X ///
reg [6:0] opcode_x;
reg [2:0] funct3_x;
reg [6:0] funct7_x;
always@*
begin
	opcode_x = inst_x[6:0];
	funct3_x = inst_x[14:12];
	funct7_x = inst_x[31:25];
	case(opcode_x)
	7'b0110011:  //R-Type
		begin
		ASel = 0;
		BSel = 0;
		case(funct3_x)
			3'b000: begin
				if(funct7_x[5]==0)
				ALUControl <= 4'b0000; // ADD
				else if(funct7_x[5]==1)
				ALUControl <= 4'b0001;    // SUB
   				end
                        3'b001: ALUControl <= 4'b0010;    // SLL
                    	3'b010: ALUControl <= 4'b0011;   // SLT
                    	3'b011: ALUControl <= 4'b0100;   // SLTU
                    	3'b100: ALUControl <= 4'b0101;   // XOR
                    	3'b101: begin
				if(funct7_x[5]==0)   
				ALUControl <= 4'b0110; // SRL
				else if (funct7_x[5]==1)
				ALUControl <= 4'b0111; //SRA
				end
                    	3'b110: ALUControl <= 4'b1000;   // OR
                    	3'b111: ALUControl <= 4'b1001;   // AND
		endcase
		//ImmSel<=3'b000; //No Immediate Needed
		end
	7'b0010011 : //Basic I-Type
		begin
		ASel = 0;
		BSel = 1;
		ImmSel <= 3'b000; 
		case(funct3_x)
			3'b000: ALUControl <= 4'b0000;   // ADD
                    	3'b001: ALUControl <= 4'b0010;   // SLLi
                    	3'b010: ALUControl <= 4'b0011;   // SLTi
                    	3'b011: ALUControl <= 4'b0100;   // SLTUi
                    	3'b100: ALUControl <= 4'b0101;   // XORi
                    	3'b101: begin
				if(funct7_x[5]==0)   
				ALUControl <= 4'b0110; // SRLi
				else if (funct7_x[5]==1)
				ALUControl <= 4'b0111; // SRAi
				end
                    	3'b110: ALUControl <= 4'b1000;   // ORi
                    	3'b111: ALUControl <= 4'b1001;   // ANDi
		endcase
		end
	7'b0000011 : //I-Type Load Word
		begin 
		ASel = 0;
		BSel = 1;
		ALUControl <= 4'b0000; //Add Immediate
		ImmSel <= 3'b000;
		Size <= 000;
		end
	7'b0100011 : //S-Type Word
		begin 
		ASel <= 0;
		BSel <= 1;
		ALUControl <= 4'b0000; //Add Immediate
		ImmSel <= 3'b001;
		end
	7'b1100111: begin //I-Type Jalr
		ASel = 0;
		BSel = 1;
		ALUControl <= 4'b0000;
		ImmSel <= 3'b000;
		//WBSel <=2'b10;
		end
	7'b1101111: begin  ///UJ-Type (Jal)
		BSel = 1;
		ASel = 1;
		ALUControl <= 4'b0000;
		ImmSel <= 3'b011;
		end
	7'b0010111: begin // U-Type (AUIPC)
		BSel = 1;
		ASel = 1;
		ALUControl <= 4'b0000;
		ImmSel <= 3'b100; //For U-Type 
		end
	 //7'b0110111: begin //U-Type (LUI)
		//BSel = 1;
		//ASel = 1;
		//ALUControl <= 4'b0000;
		//ImmSel <= 3'b100;
		//end
	endcase
		/*begin
		ASel <= 0;
		BSel <= 0;
		ALUControl <= 0; //Add Immediate
		ImmSel <= 0;
		end*/
end
/// Reg_m ///
reg [6:0] opcode_m;
reg [2:0] funct3_m;
reg [6:0] funct7_m;
always@*
begin
	opcode_m = inst_m[6:0];
	funct3_m = inst_m[14:12];
	funct7_m = inst_m[31:25];
	case(opcode_m)
	7'b0110011 :  //R-Type 
		begin
		MemRW =0;
		RegWEn_m = 1;
		end
	7'b0100011 : //S-Type Word
		begin 
		MemRW =1;
		RegWEn_m = 0; 
			case(funct3_m)
			3'b000 : Size = 3'b000;
			3'b001 : Size = 3'b001;
			3'b010 : Size = 3'b010;
			endcase
		end 
	7'b0000011 : //I-Type Load Word
		begin
		RegWEn_m = 1; 
		MemRW =0;
			case(funct3_m)
			3'b000 : Size = 3'b000;
			3'b001 : Size = 3'b001;
			3'b010 : Size = 3'b010;
			//3'b011 : Size = 3'b011;
			3'b100 : Size = 3'b100;
			3'b101 : Size = 3'b101;
			3'b110 : Size = 3'b110;
			endcase
		end
		default : MemRW = 0;
	endcase
end
 
/// Reg_w ///
reg [6:0] opcode_w;
reg [2:0] funct3_w;
reg [6:0] funct7_w;
always@*
begin
	opcode_w = inst_w[6:0];
	funct3_w = inst_w[14:12];
	funct7_w = inst_w[31:25];
	case(opcode_w)
		7'b0110011 : 
			begin
			WBSel = 2'b01; //R-Type
			RegWEn_w = 1;
			end
		7'b0010011 : begin
			WBSel = 2'b01; //Basic I-Type
			RegWEn_w = 1;
			end
		7'b0000011 : begin
			WBSel = 2'b00; //I-Type Load Word
			RegWEn_w = 1;
			end 
		7'b0100011 : begin
			WBSel = 2'b11;
			RegWEn_w = 0; //S-Type Word
			end
		7'b1100111 : begin
			WBSel = 2'b10;
			RegWEn_w = 1;
			end
		7'b1101111 : begin
			WBSel = 2'b10; //UJ-Type
			RegWEn_w = 1;
			end
		7'b0010111 : begin
			WBSel = 2'b01; //U-Type
			RegWEn_w = 1;
			end
		default : WBSel=2'bxx;
	endcase
	end
	/*else begin
		WBSel=11;
		RegWEn_w = 0;
		end	*/		
endmodule 