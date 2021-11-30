module Control(
input [6:0] opcode,
input [2:0] funct3,
input [6:0] funct7,
output reg PCSel,
output reg [2:0] ImmSel,
output reg RegWEn, 
output reg BrUn, 
output reg BSel, 
output reg ASel, 
output reg MemRW, 
output reg [1:0] WBSel,
output reg [2:0] Size,
input BrEq,
input BrLT,
input Bne,
input Bge,
input Bltu,
input Bgeu
);

reg [5:0] temp;
reg [5:0] branch;

always@*
begin
	case(opcode)
	7'b0110011:  //R-Type
		begin
		temp <=6'b010000;
		WBSel<= 2'b01;
		//ImmSel<=3'b000; //No Immediate Needed
		end
	7'b0010011 : //Basic I-Type
		begin
		temp <= 6'b010100;
		WBSel<= 2'b01;
		ImmSel <= 3'b000; 
		end
	7'b0000011 : //I-Type Load Word
		begin 
		temp <= 6'b010100;
		WBSel<= 2'b00;
		ImmSel <= 3'b000;
			case(funct3)
			3'b000 : Size = 3'b000;
			3'b001 : Size = 3'b001;
			3'b010 : Size = 3'b010;
			//3'b011 : Size = 3'b011;
			3'b100 : Size = 3'b100;
			3'b101 : Size = 3'b101;
			3'b110 : Size = 3'b110;
			endcase
		end
	7'b0100011 : //S-Type Word
		begin 
		temp <= 6'b000101;
		WBSel <= 2'b00;
		ImmSel <= 3'b001;
			case(funct3)
			3'b000 : Size = 3'b000;
			3'b001 : Size = 3'b001;
			3'b010 : Size = 3'b010;
			endcase
		end
	7'b1100011 : //SB-Type
		begin 
		//WBSel <= 2'b
		Size =3'b000;
		ImmSel <= 3'b010;
		 case(funct3)
		  3'b000 : begin
			if(BrEq)
			temp <= 6'b100110;
			end
		  3'b001 : begin
			if(Bne)
			temp <= 6'b100110;
			end
		  3'b100 : begin
			if(BrLT)
			temp <= 6'b100110;
			end
		  3'b101 : begin
			if(Bge)
			temp <= 6'b100110;
			end
		  3'b110 : begin
			if(Bltu)
			temp <= 6'b101110;
			end
		  3'b111 : begin
			if(Bgeu)
			temp <= 6'b101110;
			end
		endcase
		end
	7'b1100111: begin //I-Type Jalr
		ImmSel <= 3'b000;
		WBSel <=2'b10;
		temp <= 6'b110010;
		Size <='b0;
		end
	7'b1101111: begin  ///UJ-Type
		ImmSel <= 3'b011;
		WBSel <=2'b10;
		temp <= 6'b110110;
		Size <=3'b000;
		end
	7'b0010111: begin // U-Type (AUIPC)
		ImmSel <= 3'b100; //For U-Type
		WBSel <= 2'b01;  // Passes the ALU Output
		temp <= 6'b010110; 
		end
	7'b0110111: begin //U-Type (LUI)
		ImmSel <= 3'b100; 
		WBSel <= 2'b11;
		temp <= 6'b010111;
	end
	endcase
end

always@*
begin
	{PCSel,RegWEn,BrUn,BSel,ASel,MemRW}<=temp;
end

endmodule 