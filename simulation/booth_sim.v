`timescale 1ns / 1ps



//BOOTH MULTIPLIER 

//DATA PATH

//shift register
module shiftreg #(parameter N=4)(output reg[N-1:0]out,input[N-1:0]in,input s_in, clk, ld, sft, clr);
always @(negedge clk)
if (clr) out <= 0;
else if (ld) out <= in;
else if (sft) out <= {s_in, out[N-1:1]}; //shift right
endmodule

//parallel in parallel out register
module PIPO #(parameter N=4)(input [N-1:0]in,input clk,ld,output reg[N-1:0]out);
always @(negedge clk)
if (ld) out <= in;
endmodule

//d flipflop
module dff(input d, clk, clr,output reg q);
always @(negedge clk)
if (clr) q <= 0;
else q <= d;
endmodule

//ALU for addition & subtraction
module ALU #(parameter N=4)(input [N-1:0] in1, in2, input add ,output reg [N-1:0]out);
always @(*) begin
if (add) out  = in1 + in2; //addition
else out = in1 - in2; //subtraction
end
endmodule

//down counter
module counter  #(parameter N=4)(input decr, ld, clk,output reg [$clog2(N+1)-1:0]out);
always @(negedge clk) begin
if(ld) out <= N;
else if(decr) out <= out - 1;
end
endmodule

module booth #(parameter N=4)(q0, A, Q, ldA, ldQ, ldM, clrA, clrQ, clrff, sftA, sftQ, add, decr, ldcnt, data_in_Q,data_in_M, clk, qff, count_check);
input ldA, ldQ, ldM, clrA, clrQ, clrff, sftA, sftQ, add, decr, ldcnt, clk;
input [N-1:0] data_in_Q,data_in_M;
output qff,count_check,q0;
output [N-1:0]Q,A;

wire [N-1:0] A_inner, Q_inner, M, Z;
wire [$clog2(N+1)-1:0] count;
wire qff_inner;

assign A = A_inner;
assign Q = Q_inner;
assign q0 = Q_inner[0];
assign count_check = ~|count; // count_check=1 when count=0
assign qff = qff_inner;

shiftreg ACC(.out(A_inner),.in(Z),.s_in(A_inner[N-1]), .clk(clk),.ld(ldA),.sft(sftA),.clr(clrA)); //accumulator A
shiftreg QM(.out(Q_inner), .in(data_in_Q), .s_in(A_inner[0]),.clk(clk),.ld(ldQ),.sft(sftQ),.clr(clrQ)); //multiplier Q
dff FF(.d(Q_inner[0]), .clk(clk), .clr(clrff),.q(qff_inner)); // Q-1 
PIPO MM (.in(data_in_M), .clk(clk), .ld(ldM),.out(M)); //multiplicand M
ALU AS( .in1(A_inner),.in2(M),.add(add),.out(Z)); // ALU 
counter CO( .decr(decr), .ld(ldcnt),.clk(clk),.out(count)); // down counter
endmodule



// CONTROL PATH
module controller(ldA, ldQ, ldM, clrA, clrQ, clrff, sftA, sftQ, add, decr, ldcnt, done, start, clk,rst, qff, q0, count_check);
output reg ldA, ldQ, ldM, clrA, clrQ, clrff, sftA, sftQ, add, decr, ldcnt, done;
input start, clk ,rst, qff, q0,count_check;

reg [2:0] state;
parameter S0=3'b000, S1=3'b001, S2=3'b010, S3=3'b011, S4=3'b100, S5=3'b101, S6=3'b110;

always @(posedge clk or posedge rst)
begin
if(rst)
state<=S0;
else
begin
case (state)
S0: state<=start?S1:S0;
S1: state <= S2;
S2: begin 
    case({q0,qff})
    2'b01: state <= S3;
    2'b10: state <= S4;
    default: state <= S5;
    endcase
    end
S3: state <= S5;
S4: state <= S5;
S5: begin 
    if (!count_check) begin
    case ({q0, qff})
    2'b01: state <= S3;
    2'b10: state <= S4;
    default: state <= S5;
    endcase
    end 
    else state <= S6;
    end
S6: state <= S6;
default: state <= S0;
endcase
end
end

always @(state) 
begin
ldA = 0; ldQ = 0; ldM = 0; clrA = 0; clrQ = 0; clrff = 0;
sftA = 0; sftQ = 0; add = 0; decr = 0; ldcnt = 0; done = 0;
case (state)
S1: begin clrA=1; clrff=1; clrQ=1; ldcnt=1; ldM=1;  end
S2: begin ldQ=1; end
S3: begin ldA=1; add=1; end
S4: begin ldA=1; add=0; end
S5: begin sftA=1; sftQ=1; decr=1; end
S6: done=1;
default: ;
endcase
end
endmodule
