//d flipflop

module dff(input d, clk, clr,output reg q);
always @(negedge clk)
if (clr) q <= 0;
else q <= d;
endmodule
