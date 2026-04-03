
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

