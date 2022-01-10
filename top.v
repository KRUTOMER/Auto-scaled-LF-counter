`timescale 1ns / 100ps

module top(
     input wire clk, reset,
     input wire start, si,
     output wire [3:0] an,
     output wire [7:0] sseg
    );
    
wire [4:0] dig3_in, dig2_in, dig1_in, dig0_in;
wire [4:0] dig3_out, dig2_out, dig1_out, dig0_out;

LF_counter top_unit
(.clk(clk), .reset(reset), .start(start), .si(si),
.dig3(dig3_in), .dig2(dig2_in), .dig1(dig1_in), .dig0(dig0_in));

my_register register_unit
(.clk(clk), .reset(reset), .data3_in(dig3_in), .data2_in(dig2_in), .data1_in(dig1_in), .data0_in(dig0_in), 
.data3_out(dig3_out), .data2_out(dig2_out), .data1_out(dig1_out), .data0_out(dig0_out));

seg7 seg7_unit
(.clk(clk), .reset(reset), .sseg(sseg), .an(an),
.in3(dig3_out), .in2(dig2_out), .in1(dig1_out), .in0(dig0_out));  
    
endmodule
