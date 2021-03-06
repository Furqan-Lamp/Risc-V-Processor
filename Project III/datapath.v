module datapath(
	input  clk,
	input  rst,
	output [31:0] DataDest );
wire [31:0] DataD_w;
wire [31:0] inst_x;
wire [31:0] inst_w;
wire [31:0] inst_m;
wire NOP;

/// Program Counter ///
wire [31:0] PC_f;
wire [31:0] PC_plus_4;
wire [31:0] PC_in;
PC PC_1 	(clk,PC_in,NOP,PC_f); 

/// Instruction Memory ///
wire [31:0] instruction;
IMEM Imem_1	(PC_f,instruction); //Instruction Ready
Addr PC_Adder	(PC_f,PC_plus_4);
assign PC_in = PC_plus_4;

/////////////////// Register (PC_d and inst_D) ///////////
wire [31:0] inst_D;
wire [31:0] PC_D;
wire [31:0] instruction_D;
NOP Nop_1 (NOP,instruction,instruction_D);
Pipe_Reg REG_Inst_D	(instruction_D,clk,rst,inst_D);
Pipe_Reg REG_PC_D	(PC_f ,clk,rst, PC_D);
//////////////////////////////////////////////////////////
//Test_D_Hazard Bubble_d 	(inst_D,clk,NOP,inst_T);	
/// Control Unit ///
wire PCSel;
wire [2:0] ImmSel; 
wire RegWEn_w; 
wire RegWEn_m;
wire BrUn;
wire BSel; 
wire ASel;
wire MemRW; 
wire [1:0] WBSel; 
wire [2:0] Size;
wire [3:0] ALUControl;
Control Control_Unit 	(inst_x,inst_m,inst_w,NOP,PCSel,ImmSel,RegWEn_m,RegWEn_w,BrUn,BSel,ASel,MemRW,WBSel,Size,ALUControl);

/// Register Memory /// 
wire [31:0] DataA;
wire [31:0] DataB;
RegisterFile RegFile	(clk,rst,RegWEn_w,inst_w[11:7],inst_D[19:15],inst_D[24:20],DataD_w,DataA,DataB);

/////////// Register (PC_x, inst_x, rs_1, & rs_2) ////////
wire [31:0] PC_x;
wire [31:0] rs1_x;
wire [31:0] rs2_x;
//wire [31:0] inst_D_tested;
//Test_D_Hazard Bubble_x 	(inst_D,clk,NOP,inst_D_tested);
Pipe_Reg REG_PC_x	(PC_D  ,clk,rst, PC_x);
Pipe_Reg REG_rs1_x	(DataA ,clk,rst,rs1_x);  //DataA
Pipe_Reg REG_rs2_x	(DataB ,clk,rst,rs2_x);  //DataB
Pipe_Reg REG_inst_x	(inst_D,clk,rst,inst_x);
//////////////////////////////////////////////////////////

/// Branch Instruction ///
//branch branch1	(inst_x[14:12],DataA,DataB,BrUn,BrEq,BrLT,Bne,Bge,Bltu,Bgeu);

/// Immediate generator ///
wire [31:0] imm_x;
SignExt ImmediateGen 	(inst_x,imm_x,ImmSel);


/// Forward Path Muxes ///
wire [31:0] alu_m;
wire [31:0] rsB;
wire [31:0] rsA;
wire [1:0] F_SelA;
wire [1:0] F_SelB;
mux4x2 ForwardB (rs2_x,alu_m,DataD_w,32'b0,F_SelB,rsB); 
mux4x2 ForwardA (rs1_x,alu_m,DataD_w,32'b0,F_SelA,rsA);

/// 2x1 Control Muxes ////
wire [31:0] final_rsB;
wire [31:0] final_rsA;
mux2x1 MuxB (BSel,rsB,imm_x,final_rsB); 
mux2x1 MuxA (ASel,rsA,PC_x,final_rsA);	


/// FORWARD CONTROL UNIT ///
ForwardControl F_Control (instruction,inst_D,inst_x,inst_m,inst_w,RegWEn_m,RegWEn_w,MemRW,F_SelA,F_SelB,NOP);

/// ALU Unit ///
wire [31:0] alu_out;
wire a_is_zero;
alu alu_output (final_rsA,final_rsB,ALUControl,alu_out,a_is_zero);


/////////// Register (PC_m, inst_m, alu_m, & rs2_m) ////////
wire [31:0] PC_m;
wire [31:0] rs2_m;
//wire inst_m;
Pipe_Reg REG_PC_m	(PC_x ,clk,rst, PC_m);
Pipe_Reg REG_ALU_m	(alu_out ,clk,rst, alu_m);  //Output from the ALU_Out
Pipe_Reg REG_rs2_m	(rsB ,clk,rst, rs2_m);
Pipe_Reg REG_inst_m	(inst_x,clk,rst, inst_m);
////////////////////////////////////////////////////////////

/// Data Memory ///
wire [31:0] DataR_m; 
DMEM Data1 	(Size,MemRW,alu_m,rs2_m,DataR_m,clk);

/// PC+4 ///
wire [31:0] PC_plus_4_m;
Addr PC_Adder2	(PC_m,PC_plus_4_m);

/////////// Register (PC_w, inst_w, alu_w & DataR_w) ////////
wire [31:0] alu_w;
//wire inst_w;
wire [31:0] PC_w;
wire [31:0] DataR_w;
Pipe_Reg REG_alu_w	(alu_m ,clk,rst, alu_w);
Pipe_Reg REG_DataR_w	(DataR_m,clk,rst, DataR_w);
Pipe_Reg REG_inst_w	(inst_m,clk,rst, inst_w);
Pipe_Reg REG_PC_w	(PC_plus_4_m,clk,rst, PC_w);
////////////////////////////////////////////////////////////

/// 4x1 Mux Select ///
wire [31:0] open;
mux4x2 Mux_2	(DataR_w, alu_w, PC_w,open,WBSel,DataD_w);

assign DataDest =  DataD_w; //Testing Output
endmodule 