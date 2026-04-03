//down counter

module counter  #(parameter N=4)(input decr, ld, clk,output reg [$clog2(N+1)-1:0]out);
always @(negedge clk) begin
if(ld) out <= N;
else if(decr) out <= out - 1;
end
endmodule