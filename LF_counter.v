`timescale 1ns / 100ps

module LF_counter(
     input wire clk, reset,
     input wire start, si,
     output wire [4:0] dig3, dig2, dig1, dig0
    );
    
//signal declaration
reg [2:0] state_reg, state_next;
wire [15:0] prd;
wire [19:0] dvnd, dvsr, quo;
reg prd_start, div_start, b2b_start, adj_start;
wire prd_done_tick, div_done_tick, b2b_done_tick, adj_done_tick;
wire [3:0]  bcd10, bcd9, bcd8, bcd7, bcd6, bcd5, bcd4, bcd3, bcd2, bcd1, bcd0;


//state declaration
localparam [2:0] idle = 3'b000,
                 count = 3'b001,
                 frq = 3'b010,
                 b2b = 3'b011,
                 adjust = 3'b100;
                 
///////////////////////////////
//==COMPONENT instantiation==//                 
///////////////////////////////
//perid counter
counter counter_unit
(.clk(clk), .reset(reset), .start(prd_start), .si(si), .ready(),
.done_tick(prd_done_tick), .prd(prd));
//division circuit
division #(.W(20), .CBIT(6)) div_unit
(.clk(clk), .reset(reset), .start(div_start), .dvnd(dvnd), .dvsr(dvsr),
.quo(quo), .rmd(), .ready(), .done_tick(div_done_tick));
//BCD convertor
BCD b2b_unit
(.clk(clk), .reset(reset), .start(b2b_start), .bin(quo[19:0]), .ready(),
.done_tick(b2b_done_tick), .bcd10(bcd10), .bcd9(bcd9), .bcd8(bcd8), .bcd7(bcd7), .bcd6(bcd6), 
.bcd5(bcd5), .bcd4(bcd4),  .bcd3(bcd3), .bcd2(bcd2), .bcd1(bcd1), .bcd0(bcd0));
adjust adjust_unit
(.clk(clk), .reset(reset), .bcd10(bcd10), .bcd9(bcd9), .bcd8(bcd8), .bcd7(bcd7), .bcd6(bcd6),
.bcd5(bcd5), .bcd4(bcd4),  .bcd3(bcd3), .bcd2(bcd2), .bcd1(bcd1), .bcd0(bcd0), .done_tick(adj_done_tick), .start(adj_start),
.dig3(dig3), .dig2(dig2), .dig1(dig1), .dig0(dig0));

assign dvnd = 20'd1000000; //one second
assign dvsr =  prd;

////////////////////////
//==FSMD master body==//
////////////////////////
//register body
always @(posedge clk)
  if (reset)
    state_reg <= idle;
  else
    state_reg <= state_next;
    
//next-state logic
always @*
  begin
    state_next = state_reg;
    prd_start = 1'b0;
    div_start = 1'b0;
    b2b_start = 1'b0;
    adj_start = 1'b0;
      case (state_reg)
        idle: if (start) begin
              prd_start = 1'b1;
              state_next = count; end
        count: if (prd_done_tick) begin
               div_start = 1'b1;
               state_next = frq; end
        frq: if (div_done_tick) begin
             b2b_start = 1'b1;
             state_next = b2b; end
        b2b: if (b2b_done_tick) begin
             adj_start = 1'b1;
             state_next = adjust; end
        adjust: if (adj_done_tick)
                state_next = idle;
        default: state_next = idle;
      endcase
  end 
              
endmodule
