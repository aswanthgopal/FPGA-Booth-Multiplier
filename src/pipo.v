//parallel in parallel out register

module PIPO #(parameter N=4)(input [N-1:0]in,input clk,ld,output reg[N-1:0]out);
always @(negedge clk)
if (ld) out <= in;
endmodule