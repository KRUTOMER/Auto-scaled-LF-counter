`timescale 1ns / 100ps

module BCD(
    input wire [19:0] bin,
    input wire clk, reset, start,
    output reg ready, done_tick,
    output wire [3:0] bcd10, bcd9, bcd8, bcd7, bcd6, bcd5, bcd4, bcd3, bcd2, bcd1, bcd0
    );
    
//signal declaration  
reg [19:0] p2s_reg, p2s_next; //store value of bin
reg [1:0] state_reg, state_next;
reg [3:0] bcd10_reg, bcd9_reg, bcd8_reg, bcd7_reg, bcd6_reg, bcd5_reg, bcd4_reg, bcd3_reg, bcd2_reg, bcd1_reg, bcd0_reg;
wire [3:0] bcd10_tmp, bcd9_tmp, bcd8_tmp, bcd7_tmp, bcd6_tmp, bcd5_tmp, bcd4_tmp, bcd3_tmp, bcd2_tmp, bcd1_tmp, bcd0_tmp;
reg [3:0] bcd10_next, bcd9_next, bcd8_next, bcd7_next, bcd6_next, bcd5_next, bcd4_next, bcd3_next, bcd2_next, bcd1_next, bcd0_next;
reg [6:0] n_reg, n_next; //number of shifts

//state declaration 
 localparam [1:0] idle = 2'b00,
                  op = 2'b01,
                  done = 2'b10;
                  
/////////////////
//==FSMD body==//
/////////////////
//register body
always @(posedge clk)
  begin
    if (reset)
      begin
        p2s_reg <= 0;
        state_reg <= idle;
        n_reg <= 0;
        bcd10_reg <= 0;
        bcd9_reg <= 0;
        bcd8_reg <= 0;
        bcd7_reg <= 0;
        bcd6_reg <= 0;
        bcd5_reg <= 0;
        bcd4_reg <= 0;
        bcd3_reg <= 0;
        bcd2_reg <= 0;
        bcd1_reg <= 0;
        bcd0_reg <= 0;
      end
    else
      begin
         p2s_reg <= p2s_next;
         state_reg <= state_next;
         n_reg <= n_next;
         bcd10_reg <= bcd10_next;
         bcd9_reg <= bcd9_next;
         bcd8_reg <= bcd8_next;
         bcd7_reg <= bcd7_next;
         bcd6_reg <= bcd6_next;
         bcd5_reg <= bcd5_next;
         bcd4_reg <= bcd4_next;
         bcd3_reg <= bcd3_next;
         bcd2_reg <= bcd2_next;
         bcd1_reg <= bcd1_next;
         bcd0_reg <= bcd0_next;
       end
   end
        
//next-state logic
always @*
  begin
    state_next = state_reg;
    p2s_next = p2s_reg;
    n_next = n_reg;
    bcd10_next = bcd10_reg;
    bcd9_next = bcd9_reg;
    bcd8_next = bcd8_reg;
    bcd7_next = bcd7_reg;
    bcd6_next = bcd6_reg;
    bcd5_next = bcd5_reg;
    bcd4_next = bcd4_reg;
    bcd3_next = bcd3_reg;
    bcd2_next = bcd2_reg;
    bcd1_next = bcd1_reg;
    bcd0_next = bcd0_reg;
    ready = 1'b0;
    done_tick = 1'b0;
      case (state_reg)
        idle: begin ready = 1'b1;
               if (start == 1'b1) begin
               state_next = op;
               n_next = 6'b010100; //20 shifts
               bcd10_next = 0;
               bcd9_next = 0;
               bcd8_next = 0;
               bcd7_next = 0;
               bcd6_next = 0;
               bcd5_next = 0;
               bcd4_next = 0;
               bcd3_next = 0;
               bcd2_next = 0;
               bcd1_next = 0;
               bcd0_next = 0;
               p2s_next = bin; end end
        op: begin p2s_next = p2s_reg << 1;
            // shift 4 BCD digits
            // {bcd3_next, bcd2_next, bcd1_next, bcd0_next} =
            // {bcd3_tmp [2:0], bcd2_tmp, bcd1_tmp, bcd0_tmp, p2s_reg[12:0]
            bcd0_next = {bcd0_tmp [2:0], p2s_reg [19]};
            bcd1_next = {bcd1_tmp [2:0], bcd0_tmp [3]};
            bcd2_next = {bcd2_tmp [2:0], bcd1_tmp [3]};
            bcd3_next = {bcd3_tmp [2:0], bcd2_tmp [3]};
            bcd4_next = {bcd4_tmp [2:0], bcd3_tmp [3]};
            bcd5_next = {bcd5_tmp [2:0], bcd4_tmp [3]};
            bcd6_next = {bcd6_tmp [2:0], bcd5_tmp [3]};
            bcd7_next = {bcd7_tmp [2:0], bcd6_tmp [3]};
            bcd8_next = {bcd8_tmp [2:0], bcd7_tmp [3]};
            bcd9_next = {bcd9_tmp [2:0], bcd8_tmp [3]};
            bcd10_next = {bcd10_tmp [2:0], bcd9_tmp [3]};
            n_next = n_reg - 1;
              if (n_next == 0)
                state_next = done;
            end
        done: begin done_tick = 1'b1;
              state_next = idle; end
        default: state_next = idle;
      endcase
  end
 
//data path function
assign bcd0_tmp = (bcd0_reg > 4) ? bcd0_reg + 3 : bcd0_reg;
assign bcd1_tmp = (bcd1_reg > 4) ? bcd1_reg + 3 : bcd1_reg;
assign bcd2_tmp = (bcd2_reg > 4) ? bcd2_reg + 3 : bcd2_reg;
assign bcd3_tmp = (bcd3_reg > 4) ? bcd3_reg + 3 : bcd3_reg;
assign bcd4_tmp = (bcd4_reg > 4) ? bcd4_reg + 3 : bcd4_reg;
assign bcd5_tmp = (bcd5_reg > 4) ? bcd5_reg + 3 : bcd5_reg;
assign bcd6_tmp = (bcd6_reg > 4) ? bcd6_reg + 3 : bcd6_reg;
assign bcd7_tmp = (bcd7_reg > 4) ? bcd7_reg + 3 : bcd7_reg;
assign bcd8_tmp = (bcd8_reg > 4) ? bcd8_reg + 3 : bcd8_reg;
assign bcd9_tmp = (bcd9_reg > 4) ? bcd9_reg + 3 : bcd9_reg;
assign bcd10_tmp = (bcd10_reg > 4) ? bcd10_reg + 3 : bcd10_reg;

//output
assign bcd10 = bcd10_reg;
assign bcd9 = bcd9_reg;
assign bcd8 = bcd8_reg;
assign bcd7 = bcd7_reg;
assign bcd6 = bcd6_reg;
assign bcd5 = bcd5_reg;
assign bcd4 = bcd4_reg;
assign bcd3 = bcd3_reg;
assign bcd2 = bcd2_reg;
assign bcd1 = bcd1_reg;
assign bcd0 = bcd0_reg;
  
endmodule



