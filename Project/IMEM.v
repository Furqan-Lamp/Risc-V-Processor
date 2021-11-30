module IMEM(
input [31:0] address,
output [31:0] instruction );

reg [7:0] rom[128:0];

initial 
begin

	///////////////////////////////// Program //////////////////////////////////////////////////////

	{rom[3],rom[2],rom[1],rom[0]}     =	 32'b0000000_01111_00001_000_00001_0110011; //Adding two Numbers 15 + 1 = 16 (Storing them in Reg 1)// PC 000
	{rom[7],rom[6],rom[5],rom[4]}     =	 32'b0100000_01111_00001_000_00010_0110011; //Adding two Numbers 16 - 15 = 1 (Storing them in Reg 2)// PC 100
	{rom[11],rom[10],rom[9],rom[8]}   =	 32'b0000000_00001_00011_000_00100_0100011;  //Storing reg 1 to reg 3+offset(100)) to   PC 1000
	{rom[15],rom[14],rom[13],rom[12]} =	 32'b0000000_00010_00100_000_00100_0100011; //Storing reg 2 to reg 4+offset 100     //1100
	{rom[19],rom[18],rom[17],rom[16]}   =	 32'b0000001_00010_00001_001_00000_1100011; //Comparing reg "10" and "01" (If Branch Not Equal go to address 10000)  // PC 10000
	// Jumped Instructions
	//{rom[23],rom[22],rom[21],rom[20]}   =	 32'b0000000_00001_00010_000_00100_0100011; //It will be jumped What ever it maybe     //PC 10100
	//{rom[27],rom[26],rom[25],rom[24]}   =	 32'b0000000_00001_00010_000_00100_0100011; 	//PC 11000
	//{rom[31],rom[30],rom[29],rom[28]}   =	 32'b0000000_00001_00010_000_00100_0100011;		//PC 11100
	//{rom[35],rom[34],rom[33],rom[32]}   =	 32'b0000000_00001_00010_000_00100_0100011;		//PC 100000
	//{rom[39],rom[38],rom[37],rom[36]}   =	 32'b0000000_00001_00010_000_00100_0100011;		//PC 100100
	//{rom[43],rom[42],rom[41],rom[40]}   =	 32'b0000000_00001_00010_000_00100_0100011;		//PC 101000
	//{rom[47],rom[46],rom[45],rom[44]}   =	 32'b0000000_00001_00010_000_00100_0100011;		//PC 101100
	//{rom[51],rom[50],rom[49],rom[48]}   =	 32'b0000000_00001_00010_000_00100_0100011;
	//{rom[55],rom[54],rom[53],rom[52]}   =	 32'b0000000_00001_00010_000_00100_0100011;
	
	{rom[51],rom[50],rom[49],rom[48]}   =	 32'b000000000100_00100_000_00101_0000011; 	//loading the Values from 3+ offset 100 to reg 5//PC 110000
	{rom[55],rom[54],rom[53],rom[52]}    =	 32'b000000000100_00011_000_00111_0000011;	//loading the Values from 4+ offset 100	to reg 7//PC 110100
	{rom[59],rom[58],rom[57],rom[56]}   =	 32'b000000000000_00101_000_01111_0010011;
	{rom[63],rom[62],rom[61],rom[60]}   =	 32'b000000000000_00111_000_10001_0010011;
	//////////////////////////////// End Program ///////////////////////////////////////////////////


	///////////U Type ///////////////////////

	//{rom[3],rom[2],rom[1],rom[0]}       	=	 32'b0000000000000001000_10000_0010111;  //AUIPC
	//{rom[7],rom[6],rom[5],rom[4]}       	=	 32'b0000000000000011000_01100_0110111;  //LUI

	////////// J-Type ///////////////////////

	//{rom[3],rom[2],rom[1],rom[0]}       	=	 32'b0000000000000001000_10000_1101111;  //Jal

	////////// jalr Instr ////////////////////

	//{rom[3],rom[2],rom[1],rom[0]}       	=	 32'b000000010000_00010_000_10000_1100111; //JALr

	////////// Branch instruction ////////////

	//{rom[3],rom[2],rom[1],rom[0]}         	=	 32'b0000000_00010_00010_000_10000_1100011; //BEQ
	//{rom[3],rom[2],rom[1],rom[0]}      		=	 32'b0000000_00010_00011_001_10000_1100011; //BNE 
	//{rom[3],rom[2],rom[1],rom[0]}       		=	 32'b0000000_01011_00111_100_10000_1100011; //BLT
	//{rom[3],rom[2],rom[1],rom[0]}       		=	 32'b0000000_01011_01111_101_10000_1100011; //BGE
	//{rom[3],rom[2],rom[1],rom[0]}       		=	 32'b0000000_11000_11111_110_10000_1100011; //BLTu
	//{rom[3],rom[2],rom[1],rom[0]}       		=	 32'b0000000_10000_10111_111_10000_1100011; //BGEu


	////////// S-Type and I-Load Type /////////////////
	//{rom[3],rom[2],rom[1],rom[0]}     	=	 32'b0000000_00001_00010_000_00100_0100011; //Sb
	//{rom[7],rom[6],rom[5],rom[4]}     	=	 32'b000000000100_00010_000_00101_0000011; //lb
	//{rom[11],rom[10],rom[9],rom[8]}       =	 32'b0000000_00010_00010_000_00100_0100011; //Sb
	//{rom[15],rom[14],rom[13],rom[12]}     =	 32'b000000000100_00010_000_00110_0000011; //lb
	

	////////// I-Type basic /////////

	//{rom[3],rom[2],rom[1],rom[0]}       =	 32'b000000001110_00001_000_01111_0010011; //Addi
	//{rom[7],rom[6],rom[5],rom[4]}	 	  =	 32'b0000000_01101_00001_001_01111_0010011; //SLLi
	//{rom[11],rom[10],rom[9],rom[8]}	  =	 32'b000000001110_00001_010_01111_0010011; //SLTi
	//{rom[15],rom[14],rom[13],rom[12]}	  =	 32'b000000001110_00001_011_01111_0010011; //SLTiu
	//{rom[19],rom[18],rom[17],rom[16]}	  =	 32'b000000001110_00001_100_01111_0010011; //XORi
	//{rom[23],rom[22],rom[21],rom[20]}	  =	 32'b0000000_00001_01101_101_01111_0010011; //SRLi
	//{rom[27],rom[26],rom[25],rom[24]}	  =	 32'b0100000_00001_01101_101_01111_0010011; //SRAi
	//{rom[31],rom[30],rom[29],rom[28]}	  =	 32'b000000001110_00001_110_01111_0010011; //ORi
	//{rom[35],rom[34],rom[33],rom[32]}	  =	 32'b000000001110_00001_111_01111_0010011; //ANDi
	
	/////////// R-Type Instructions //////////////

	//{rom[3],rom[2],rom[1],rom[0]}     =	 32'b000000001110_01101_000_01100_0110011; //Add
	//{rom[7],rom[6],rom[5],rom[4]}     =	 32'b01000000111001101_000_01100_0110011; //SUB
	//{rom[11],rom[10],rom[9],rom[8]}   = 	 32'b00000000111001101_001_01100_0110011; //SLL
	//{rom[15],rom[14],rom[13],rom[12]} = 	 32'b00000000111001101_010_01100_0110011; //SLT
	//{rom[19],rom[18],rom[17],rom[16]} = 	 32'b00000000111001101_011_01100_0110011; //SLTu
	//{rom[23],rom[22],rom[21],rom[20]} = 	 32'b00000000111001101_100_01100_0110011; //XOR
	//{rom[27],rom[26],rom[25],rom[24]} = 	 32'b00000000111001101_101_01100_0110011; //SRL
	//{rom[31],rom[30],rom[29],rom[28]} = 	 32'b00000000111001101_110_01100_0110011; //OR
	//{rom[35],rom[34],rom[33],rom[32]} = 	 32'b00000000111001101_111_01100_0110011; //AND
	//{rom[39],rom[38],rom[37],rom[36]} = 	 32'b00000000111001101_110_01100_0110011; //OR
	//{rom[43],rom[42],rom[41],rom[40]} = 	 32'b01000000111001101_101_01100_0110011; //SRA
end
	assign instruction = {rom[address+3],rom[address+2],rom[address+1],rom[address+0]}; 
endmodule 