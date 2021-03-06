module datapath(
input clk,
input rst,
output [31:0] DataDest
);

wire [31:0] DataD;

////////// Program Counter //////////

wire [31:0] pc_out;
wire [31:0] pc_out_new;
wire [31:0] pc_in;

PC pc1 (clk,pc_in,pc_out);

////////// Instruction Memory /////////
wire [31:0] instruction;
IMEM Imem_1 (pc_out,instruction);


Addr PcAdd(pc_out,pc_out_new);

///////////  Some Wires ///////////////

wire BrEq;
wire BrLT;
wire Bne;
wire Bge;
wire Bltu;
wire Bgeu;

//////////// Control Unit /////////////
wire PCSel;
wire [2:0] ImmSel; 
wire RegWEn; 
wire BrUn;
wire BSel; 
wire ASel;
wire MemRW; 
wire [1:0] WBSel;
wire [2:0] Size;
Control Ctrl (instruction[6:0],instruction[14:12],instruction[31:25],PCSel,ImmSel,RegWEn,BrUn,BSel,ASel,MemRW,WBSel,Size,BrEq,BrLT,Bne,Bge,Bltu,Bgeu);


//////////// Register Memory ///////////// 

wire [31:0] DataA;
wire [31:0] DataB;
RegisterFile RegFile (clk,rst,RegWEn,instruction[11:7],instruction[19:15],instruction[24:20],DataD,DataA,DataB);


//////////// Immediate generator /////////

wire [31:0] immediate_out;

SignExt Sign1 (instruction[31:0],immediate_out[31:0],ImmSel);

//////////// Branch Instruction //////////

branch branch1 (instruction[14:12],DataA,DataB,BrUn,BrEq,BrLT,Bne,Bge,Bltu,Bgeu);


//////////// 2x1 Muxs ////////////////////

wire [31:0] rsB;
wire [31:0] rsA;
mux2x1 MuxB (BSel,DataB,immediate_out,rsB); 
mux2x1 MuxA (ASel,DataA,pc_out,rsA);


//////////// ALU Control ///////////////////

wire [3 :0] ALUControl;
ALU_Control alu_ctrl1(instruction[6:0],instruction[14:12],instruction[31:25],ALUControl);



//////////// ALU Unit ///////////////////////

wire [31:0] alu_out;
wire a_is_zero;
alu ALU1 (rsA,rsB,ALUControl,alu_out,a_is_zero);

///////////// PC Sel //////////

muxer Mux1A(PCSel,pc_out_new,alu_out,pc_in);


///////////// Data Memory /////////////////
wire [31:0] DataR; 
DMEM Data1 (Size,MemRW,alu_out,DataB,DataR,clk);


//////////// 4x2 Mux Select //////////////////

mux4x2 Mux_2(DataR, alu_out, pc_out_new,immediate_out,WBSel,DataD);

assign DataDest =  DataD;
endmodule 