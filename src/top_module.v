
`timescale 1ns / 1ps

//BOOTH MULTIPLIER FPGA

//TOP MODULE
module booth_multiplier_top #(parameter N=4)(
input clk_100MHz,          // Basys3 100MHz clock
input rst,                 // reset signal from button
input start,               // Start signal from switch
input [N-1:0] data_in_Q,   // Multiplier input from switches
input [N-1:0] data_in_M,   // Multiplicand input from switches  
output done,               // Done LED indicator
output [2*N-1:0] result,   // Product output on LEDs
output [3:0] an,           // 7-segment anodes
output [6:0] seg           // 7-segment segments
);

// Clock divider instantiation (100MHz -> 1 Hz)
wire clk;
clock_divider #(.DIV_VALUE(100000000)) clk_div (.clk_in(clk_100MHz),.clk_out(clk));


wire ldA, ldQ, ldM, clrA, clrQ, clrff, sftA, sftQ, add, decr, ldcnt;
wire qff, q0, count_check;
wire [N-1:0] A, Q;


wire signed [2*N-1:0] product;
assign product = {A, Q};  
assign result  = {A, Q};

// Seven segment display instantiation
seven_seg_display ssd (.clk(clk_100MHz),.done(done),.number(product),.an(an),.seg(seg) );

// Data Path instantiation
booth #(.N(N)) data_path (.q0(q0), .A(A), .Q(Q),.ldA(ldA), .ldQ(ldQ), .ldM(ldM),.clrA(clrA), .clrQ(clrQ), .clrff(clrff),.sftA(sftA), .sftQ(sftQ), .add(add),
                          .decr(decr), .ldcnt(ldcnt),.data_in_Q(data_in_Q),.data_in_M(data_in_M),.clk(clk),.qff(qff), .count_check(count_check));

// Control Path instantiation
controller control_path (.ldA(ldA), .ldQ(ldQ), .ldM(ldM),.clrA(clrA), .clrQ(clrQ), .clrff(clrff),.sftA(sftA), .sftQ(sftQ), .add(add),.decr(decr), .ldcnt(ldcnt),
                         .done(done),.start(start), .clk(clk), .rst(rst),.qff(qff), .q0(q0), .count_check(count_check) );
endmodule
