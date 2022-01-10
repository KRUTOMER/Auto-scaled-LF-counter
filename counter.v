`timescale 1ns / 100ps

module counter(
    input wire clk, reset,
    input wire start, si,
    output reg ready, done_tick,
    output wire [19:0] prd
    );
    
//parameter declaration
localparam [15:0] MAX_COUNTER_NUMBER = 50; //1 microsecond

//signal declaration
reg [1:0] state_reg, state_next;
reg [6:0] t_reg, t_next; //count MAX_COUNTER_NUMBER
reg [19:0] p_reg, p_next; //store number of microsec
reg delay_reg;
wire edg;   

//state declaration
localparam [1:0] idle = 2'b00,
                 waite = 2'b01,//wait till locked 1st posedge of clk
                 count = 2'b10,
                 done = 2'b11;
                 
/////////////////
//==FSMD body==//
/////////////////
//register body
always @(posedge clk)
  if (reset)
    begin
      state_reg <= idle;
      t_reg <= 0;
      p_reg <= 0;
      delay_reg <= 0;
    end
  else
    begin
      state_reg <= state_next;
      t_reg <= t_next;
      p_reg <= p_next;
      delay_reg <= si; 
    end
 //rising edge tick
 assign edg = ~delay_reg & si;
   
//next-state logic
always @*
  begin
    state_next = state_reg;
    ready = 1'b0;
    done_tick = 1'b0;
    t_next = t_reg;
    p_next = p_reg;
    case (state_reg)
      idle: begin ready = 1'b1;
              if (start == 1)
                state_next = waite;
            end
      waite: if (edg == 1) begin //wait till 1st edge
             state_next = count;
             t_next = 0;
             p_next = 0; end
      count: if (edg == 1) //2nd edge
               state_next = done;
             else begin //count
               t_next = t_reg + 1;
                 if (t_reg == MAX_COUNTER_NUMBER - 1) begin
                   t_next = 0;
                   p_next = p_reg + 1; end
               end
       done: begin done_tick = 1'b1;
               state_next = idle; end
       default: state_next = idle;
     endcase
  end
     
//output
assign prd = p_reg;
                             
    
endmodule
