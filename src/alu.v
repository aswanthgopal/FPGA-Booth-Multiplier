
//ALU for addition & subtraction

module ALU #(parameter N=4)(input [N-1:0] in1, in2, input add ,output reg [N-1:0]out);
always @(*) begin
if (add) out = in1 + in2; //addition
else out = in1 - in2; //subtraction
end
endmodule
