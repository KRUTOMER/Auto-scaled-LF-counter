`timescale 1ns / 100ps

module testbench;

reg clk, reset;
reg start;
wire [7:0] sseg;
wire [3:0] an;
//wire [19:0] quo_test;
//wire [15:0] prd_test;
reg si;
//wire [4:0] dig3_in, dig2_in, dig1_in, dig0_in;
//wire [4:0] dig3_out, dig2_out, dig1_out, dig0_out;

top top_uut
(.clk(clk), .reset(reset), .start(start), .an(an), .sseg(sseg), .si(si));


initial begin
clk = 0;
reset = 1;
start = 0;
si = 0;
#100 reset = 0; end

always #10 clk = ~clk;
always #200_000 si = ~si;

initial begin
#1_000_000 start = 1;
#1_100_000 start = 0;
#1000
$stop;
end



endmodule
