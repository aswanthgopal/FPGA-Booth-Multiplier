`timescale 1ns / 1ps


module tb_booth;
parameter N=4;
reg clk, start,rst;
reg signed [N-1:0] data_in_Q,data_in_M;
wire done;

wire ldA, ldQ, ldM, clrA, clrQ, clrff, sftA, sftQ, add, decr, ldcnt;
wire qff, eqz, q0;
wire [N-1:0] A, Q;

booth #(.N(N))dp(
.q0(q0), .A(A), .Q(Q), 
.ldA(ldA), .ldQ(ldQ), .ldM(ldM), 
.clrA(clrA), .clrQ(clrQ), .clrff(clrff), 
.sftA(sftA), .sftQ(sftQ), .add(add),  
.decr(decr), .ldcnt(ldcnt), 
.data_in_Q(data_in_Q),.data_in_M(data_in_M), .clk(clk), 
.qff(qff), .count_check(eqz));
    
controller ctrl(
.ldA(ldA), .ldQ(ldQ), .ldM(ldM), 
.clrA(clrA), .clrQ(clrQ), .clrff(clrff), 
.sftA(sftA), .sftQ(sftQ), .add(add),   
.decr(decr), .ldcnt(ldcnt), .done(done),
.start(start), .clk(clk),     
.qff(qff), .q0(q0), .count_check(eqz),.rst(rst));

initial
begin 
clk=0;
rst=1;#2 rst=0;
end
always #5 clk=~clk;

initial begin
$display("Time\tA\t\tQ\t\tQ-1\tDone\t");
$monitor("%0t\t%b\t%b\t%b\t%b", $time, A, Q,qff, done);
start = 0;
data_in_M = 4'd2;   // multiplicand M
#12 start = 1;      
#10 start = 0;      
#1; 
data_in_Q = -4'd3;  //multiplier Q
wait(done);         
#10;
$display("\nFinal Product : %b", {A, Q});
$display("\nFinal Product : %0d", $signed({A, Q}));

rst=1;#5
rst=0;

data_in_M = -4'd5;   // multiplicand M
#12 start = 1;      
#10 start = 0;      
#1; 
data_in_Q = -4'd3;  //multiplier Q
wait(done);         
#10;
$display("\nFinal Product : %b", {A, Q});
$display("\nFinal Product : %0d", $signed({A, Q}));

$finish;
end
endmodule