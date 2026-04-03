
// SEVEN SEGMENT DISPLAY MODULE


module seven_seg_display (input clk,done,input signed [7:0] number,output reg [6:0] seg,output reg [3:0] an);
reg [15:0] refresh_counter = 0;
always @(posedge clk) 
refresh_counter <= refresh_counter + 1;
wire [1:0] scan = refresh_counter[15:14]; //300-400hz scan rate for multiplexing

reg signed [7:0] abs_num;
reg [3:0] digit0, digit1; 
reg sign;

always @(*) 
begin
if(number < 0) 
begin
sign = 1;
abs_num = -number;
end 
else 
begin
sign = 0;
abs_num = number;
end

digit0 = abs_num % 10;
digit1 = (abs_num / 10) % 10;
end

function [6:0] segmap(input [3:0] d);
case(d)
4'd0: segmap = 7'b1000000; //0
4'd1: segmap = 7'b1111001; //1
4'd2: segmap = 7'b0100100; //2
4'd3: segmap = 7'b0110000; //3
4'd4: segmap = 7'b0011001; //4
4'd5: segmap = 7'b0010010; //5
4'd6: segmap = 7'b0000010; //6
4'd7: segmap = 7'b1111000; //7
4'd8: segmap = 7'b0000000; //8
4'd9: segmap = 7'b0010000; //9
4'hA: segmap = 7'b0111111; // -
default: segmap = 7'b1111111;
endcase
endfunction

always @(*) begin
if(!done) begin
an = 4'b1111;
seg = 7'b1111111;
end 
else begin
case(scan)
2'b00: begin an = 4'b1110; seg = segmap(digit0); end
2'b01: begin 
an = 4'b1101;
if(digit1 == 0 && !sign) seg = 7'b1111111;
else seg = segmap(digit1);
end
2'b10: begin 
an = 4'b1011; 
if(sign) seg = segmap(4'hA);
else seg = 7'b1111111;
end
default: begin an = 4'b0111; seg = 7'b1111111; end
endcase
end
end
endmodule
