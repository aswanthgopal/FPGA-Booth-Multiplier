
// CLOCK DIVIDER MODULE

module clock_divider #(parameter DIV_VALUE = 100000000)(input clk_in,output reg clk_out = 0);
reg [31:0] counter = 0;
always @(posedge clk_in) begin
if (counter >= DIV_VALUE - 1) begin
counter <= 0;
clk_out <= ~clk_out;
end 
else begin
counter <= counter + 1;
end
end
endmodule