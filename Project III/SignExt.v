module SignExt(sign_in, sign_out,ImmSel);
	input [2:0] ImmSel;
	input [31:0] sign_in;
	output reg [31:0] sign_out;
	always@(ImmSel,sign_in)
	begin
	case(ImmSel)
		3'b000 : begin //I-Type
		sign_out[11:00]=sign_in[31:20];
		sign_out[27:12]=sign_in[31] ? 16'b1111111111111111:16'b0;
		sign_out[31:28]=sign_in[31] ? 4'b1111:4'b0;
		end 
		3'b001 : begin //S-Type
		sign_out[4:0] = sign_in[11:7];
		sign_out[11:5]= sign_in[31:25];
		sign_out[27:12]=sign_in[31] ? 16'b1111111111111111:16'b0;
		sign_out[31:28]=sign_in[31] ? 4'b1111:4'b0;
		end		
		3'b010: begin //SB-Type (branch)
		sign_out[0] = 'b0;
		sign_out[4:1] = sign_in[11:8];
		sign_out[10:5] = sign_in[30:25];
		sign_out[11] = sign_in[7];
		sign_out[12] = sign_in[31];
		sign_out[27:13]=sign_in[31] ? 15'b111111111111111:15'b0;
		sign_out[31:28]=sign_in[31] ? 4'b1111:4'b0;
		end
		3'b011: begin //UJ-Type
		sign_out[0] = 0;
		sign_out[10:1] = sign_in[30:21];
		sign_out[11] = sign_in[20];
		sign_out[19:12] = sign_in[19:12];
		sign_out[20] = sign_in[31];
		sign_out[27:21]=sign_in[31] ? 7'b1111111:7'b0;
		sign_out[31:28]=sign_in[31] ? 4'b1111:4'b0;
		end
		3'b100: begin //U-Type
		sign_out[11:0] = 'b0;
		sign_out[31:12] = sign_in[31:12];
		end
	endcase
	end	
		
endmodule
