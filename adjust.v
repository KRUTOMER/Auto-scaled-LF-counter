`timescale 1ns / 100ps

module adjust(
    input wire clk, reset,
    input wire start,
    input wire [3:0] bcd10, bcd9, bcd8, bcd7, bcd6, bcd5, bcd4, bcd3, bcd2, bcd1, bcd0,
    output wire [4:0] dig3, dig2, dig1, dig0,
    output reg done_tick, ready
    );
    
//signal declaration
reg [1:0] state_reg, state_next;
reg [4:0] bcd10_reg, bcd9_reg, bcd8_reg, bcd7_reg, bcd6_reg, bcd5_reg, bcd4_reg, bcd3_reg, bcd2_reg, bcd1_reg, bcd0_reg;
reg [4:0] bcd10_next, bcd9_next, bcd8_next, bcd7_next, bcd6_next, bcd5_next, bcd4_next, bcd3_next, bcd2_next, bcd1_next, bcd0_next;

//state declaration
localparam [1:0] idle = 2'b00,
                 op = 2'b01,
                 done = 2'b10;
                 
//register body
always @(posedge clk)
  if (reset)
    begin
      state_reg <= 0;
      bcd0_reg <= 0;
      bcd1_reg <= 0;
      bcd2_reg <= 0;
      bcd3_reg <= 0;
      bcd4_reg <= 0;
      bcd5_reg <= 0;
      bcd6_reg <= 0;
      bcd7_reg <= 0;
      bcd8_reg <= 0;
      bcd9_reg <= 0;
      bcd10_reg <= 0;
    end
  else
    begin
      state_reg <= state_next;
      bcd0_reg <= bcd0_next;
      bcd1_reg <= bcd1_next;
      bcd2_reg <= bcd2_next;
      bcd3_reg <= bcd3_next;
      bcd4_reg <= bcd4_next;
      bcd5_reg <= bcd5_next;
      bcd6_reg <= bcd6_next;
      bcd7_reg <= bcd7_next;
      bcd8_reg <= bcd8_next;
      bcd9_reg <= bcd9_next;
      bcd10_reg <= bcd10_next;
    end
    
// FSM next-state logic
always @*
  begin
    state_next = state_reg;
    bcd0_next = bcd0_reg;
    bcd1_next = bcd1_reg;
    bcd2_next = bcd2_reg;
    bcd3_next = bcd3_reg;
    bcd4_next = bcd4_reg;
    bcd5_next = bcd5_reg;
    bcd6_next = bcd6_reg;
    bcd7_next = bcd7_reg;
    bcd8_next = bcd8_reg;
    bcd9_next = bcd9_reg;
    bcd10_next = bcd10_reg;
    done_tick = 1'b0;
    ready = 1'b0;
      case (state_reg) idle: begin ready = 1'b1;
                               if (start == 1'b1) begin
                               bcd0_next = {1'b1, bcd0};
                               bcd1_next = {1'b0, bcd1};
                               bcd2_next = {1'b0, bcd2};
                               bcd3_next = {1'b0, bcd3};
                               bcd4_next = {1'b0, bcd4};
                               bcd5_next = {1'b0, bcd5};
                               bcd6_next = {1'b0, bcd6};
                               bcd7_next = {1'b0, bcd7};
                               bcd8_next = {1'b0, bcd8};
                               bcd9_next = {1'b0, bcd9};
                               bcd10_next = {1'b0, bcd10};
                               state_next = op; end
                             else state_next = idle; end
                       op: if (bcd10_next == 0) begin
                             {bcd10_next, bcd9_next, bcd8_next, bcd7_next, bcd6_next, bcd5_next, bcd4_next, bcd3_next, bcd2_next, bcd1_next, bcd0_next} =
                             {bcd10_next, bcd9_next, bcd8_next, bcd7_next, bcd6_next, bcd5_next, bcd4_next, bcd3_next, bcd2_next, bcd1_next, bcd0_next} << 5;
                             end
                           else
                             state_next = done;
                      done: begin done_tick = 1'b1;
                            state_next = idle; end
                      default: state_next = idle;
        endcase
  end
     
//output
assign dig3 = bcd10_reg;
assign dig2 = bcd9_reg;
assign dig1 = bcd8_reg;
assign dig0 = bcd7_reg; 
    
    
endmodule
