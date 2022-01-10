`timescale 1ns / 100ps

module my_register(
    input wire clk, reset,
    input wire [4:0] data3_in, data2_in, data1_in, data0_in,
    output reg [4:0] data3_out, data2_out, data1_out, data0_out
    );



always @(posedge clk)
  if (reset)
    begin
      data3_out <= 0; 
      data2_out <= 0;  
      data1_out <= 0;  
      data0_out <= 0;
    end
  else
    begin
      data3_out <= data3_in;   
      data2_out <= data2_in; 
      data1_out <= data1_in; 
      data0_out <= data0_in;   
    end
    
endmodule
