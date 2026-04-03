
//shift register

module shiftreg #(parameter N=4)(output reg[N-1:0]out,input[N-1:0]in,input s_in, clk, ld, sft, clr);
always @(negedge clk)
if (clr) out <= 0;
else if (ld) out <= in;
else if (sft) out <= {s_in, out[N-1:1]}; //shift right
endmodule