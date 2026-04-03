//datapath

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

