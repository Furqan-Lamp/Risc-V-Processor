module mux4x2 #(parameter WIDTH=32) (
input [WIDTH-1:0] in1,
input [WIDTH-1:0] in2,
input [WIDTH-1:0] in3,
input [WIDTH-1:0] in4,
input [1:0] WBSel,
output reg [WIDTH-1:0] DataD );

 always @* begin
    case(WBSel)
        2'b00: DataD<=in1;
        2'b01: DataD<=in2;
        2'b10: DataD<=in3;
        2'b11: DataD<=in4;
    endcase    
 end
endmodule 