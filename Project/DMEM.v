module DMEM(Size,MemRW,Addr,DataW,DataR,clk);
// Initiliaze input, output, register, wire, integer
    input clk;
    input MemRW;
    input [31:0] Addr;
    input [31:0] DataW; //Write Data
    input [2:0] Size;
    output reg [31:0] DataR; // Read Data
    
localparam Address_bit=8;
    reg  [Address_bit-1:0] memory [127:0]; //initate memory

//////////Store Word  /////////

    always@(posedge clk) begin            
        if(MemRW)  	
		case(Size) //store byte
            	3'b000: begin
		memory[Addr] <= DataW[7:0];
		end

		3'b001: begin // store half
		memory[Addr] <= DataW[7:0];
		memory[Addr+1] <= DataW[15:8];
		end

		3'b010: begin //store Word
		memory[Addr] <= DataW[7:0];
		memory[Addr+1] <= DataW[15:8];
	  	memory[Addr+2] <= DataW[23:16];
		memory[Addr+3] <= DataW[31:24];
		end
		
        endcase
	end 

///////////////Load Word

always@*
	begin    
	 case(Size)  
             000: begin  // Load Byte
          DataR[7:0] = memory[Addr];
          DataR[15:8]  = 8'b0;
          DataR[23:16] = 8'b0;
          DataR[31:24] = 8'b0;
             end
	     001: begin // Load Half
	  DataR[7:0] = memory[Addr];
          DataR[15:8] = memory[Addr+1];
          DataR[23:16] = 8'b0;
          DataR[31:24] = 8'b0;
	     end
	     010: begin //Load Word
	  DataR[7:0] = memory[Addr];
          DataR[15:8] = memory[Addr+1];
          DataR[23:16] = memory[Addr+2];
          DataR[31:24] = memory[Addr+3];
		end

		/////// Signed //////

	    100: begin  //Load byte Signed  
	  DataR[7:0] = memory[Addr];
          DataR[15:8] = {Address_bit{DataR[7]}};
          DataR[23:16] = {Address_bit{DataR[7]}};
          DataR[31:24] = {Address_bit{DataR[7]}};
		end
	    101: begin  //Load half Signed  
	  DataR[7:0] = memory[Addr];
          DataR[15:8] = memory[Addr+1];
          DataR[23:16] = {Address_bit{DataR[15]}};
          DataR[31:24] = {Address_bit{DataR[15]}};
		end
	   110: begin  //Load Word Signed  
	  DataR[7:0] = memory[Addr];
          DataR[15:8] = memory[Addr+1];
          DataR[23:16] = memory[Addr+2];
          DataR[31:24] = memory[Addr+3];
		end
	endcase
	end
endmodule

         







