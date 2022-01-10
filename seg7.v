`timescale 1ns / 100ps

module seg7(
    input wire clk, reset,
    input wire [4:0] in3, in2, in1, in0,
    //input wire [3:0] dot_in,
    output reg [3:0] an, // enable 4th to 1st digits, active low
    output reg [7:0] sseg //led segmets
    );

//constant declaration
//refreshing rate about 1,5 KHz
localparam N = 18;

//signal declaration
reg [N-1:0] q_reg;
wire [N-1:0] q_next;
//reg dot; //deciminal of digit
reg [3:0] hex_in;
wire [3:0] digit3, digit2, digit1, digit0;
wire  dot3, dot2, dot1, dot0;
reg dot;

//digits assigment
assign digit3 = in3 [3:0];
assign digit2 = in2 [3:0];
assign digit1 = in1 [3:0];
assign digit0 = in0 [3:0];

//dots assigment
assign dot3 = in3 [4];
assign dot2 = in2 [4];
assign dot1 = in1 [4];
assign dot0 = in0 [4];

//N-bit counter
//register
always @(posedge clk)
  if (reset)
    q_reg <= 0; 
  else
    q_reg <= q_next;

//next-stage logic
assign q_next = q_reg + 1;

//2 MSBs of counter control 4 to 1 multiplex
// and generate active-low signal
always @*
begin
  case (q_reg[N-1:N-2])
    2'b00:
      begin
        an = 4'b1110;
        hex_in = digit0;
        dot = dot0;
      end
    2'b01:
      begin
        an = 4'b1101;
        hex_in = digit1;
        dot = dot1;
      end
    2'b10:
      begin
        an = 4'b1011;
        hex_in = digit2;
        dot = dot2;
      end
    default:
      begin
        an = 4'b0111;
        hex_in = digit3;
        dot = dot3;
      end
    endcase
end


//7seg decording circuit
always @*
  begin
    case (hex_in)
      4'h0: sseg [6:0] = 7'b1111110;
      4'h1: sseg [6:0] = 7'b0110000;
      4'h2: sseg [6:0] = 7'b1101101;
      4'h3: sseg [6:0] = 7'b1111001;
      4'h4: sseg [6:0] = 7'b0110011;
      4'h5: sseg [6:0] = 7'b1011011;
      4'h6: sseg [6:0] = 7'b1011111;
      4'h7: sseg [6:0] = 7'b1110000;
      4'h8: sseg [6:0] = 7'b1111111;
      4'h9: sseg [6:0] = 7'b1111011;
      4'ha: sseg [6:0] = 7'b1110111;
      4'hb: sseg [6:0] = 7'b0011111;
      4'hc: sseg [6:0] = 7'b1001110;
      4'hd: sseg [6:0] = 7'b0111101;
      4'he: sseg [6:0] = 7'b1001111;
      default: sseg [6:0] =  7'b1000111; // F letter
    endcase
    sseg[7] = dot;
  end
  

endmodule