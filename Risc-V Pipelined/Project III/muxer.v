
module muxer(sel, in0, in1, Y);
input [31:0] in0;
input [31:0] in1; 
input sel;
output reg [31:0] Y;

always @(in0 or in1 or sel)
begin

if(sel) 
Y= in1;
else
Y= in0;

end

endmodule 