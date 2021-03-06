module Pipe_Reg #(parameter Width=32)
(	input [Width-1:0] DataIn,
	input clk,
	input rst,
	output reg [Width-1:0] DataOut );	
	
 always@(posedge clk)
  begin
  if (rst)
  DataOut <= 0;
  else
  DataOut <= DataIn;
 end
endmodule 