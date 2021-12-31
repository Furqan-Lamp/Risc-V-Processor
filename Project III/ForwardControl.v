module ForwardControl (
input [31:0] instruction,
input [31:0] inst_d,
input [31:0] inst_x,
input [31:0] inst_m,
input [31:0] inst_w,
input RegWEn_m,
input RegWEn_w,
input MemRW,
output reg [1:0] F_SelA,
output reg [1:0] F_SelB,
output reg NOP
);
reg [4:0] inst_x_rs1;
reg [4:0] inst_x_rs2;
reg [4:0] inst_m_rd;
reg [4:0] inst_w_rd;

// For NOP //
reg [4:0] inst_rs1;
reg [4:0] inst_rs2;
reg [4:0] inst_d_rd;
reg [6:0] opcode_d;

always@*   //For Forward Mux A
 begin
inst_x_rs1 = inst_x [19:15];
inst_x_rs2 = inst_x [24:20];
inst_m_rd  = inst_m [11:7];
inst_w_rd  = inst_w [11:7]; 

    if(RegWEn_m && inst_m_rd!=0 && (inst_x_rs1==inst_m_rd))
        F_SelA=2'b01;
    else if (RegWEn_w && inst_w_rd!=0 && (inst_x_rs1==inst_w_rd))
        F_SelA=2'b10;
    else
        F_SelA='b0;
end

always@* 
 begin
	opcode_d = inst_d [6:0];
	inst_d_rd = inst_d [11:7];
	inst_rs1 = instruction [19:15];
	inst_rs2 = instruction [24:20];
	if(opcode_d==7'b0000011) 
	 begin
	  if(inst_rs1 == inst_d_rd || inst_rs2 == inst_d_rd)	
		NOP =1;
	  else 
		NOP=0;
	end
	else NOP =0;
 end

always@*  //For Forward Mux B
begin
    if(RegWEn_m & (inst_m_rd!=0) & (inst_x_rs2==inst_m_rd))
        F_SelB=2'b01;
    else if (RegWEn_w & (inst_w_rd!=0) & (inst_x_rs2==inst_w_rd))
        F_SelB=2'b10;
    else
        F_SelB='b0;
end
endmodule 