module lab2_task2(input  logic clk, reset,
                     input  logic n, s, e, w,
                     output logic win, die);
logic sword1, sword2;

roomfsm room(clk, reset, n, s, e, w, sword1, sword2, win, die);

swordfsm sword(clk, reset, sword2, sword1);
					
endmodule

module roomfsm(input logic clk, reset,
	       input logic n, s, e, w, sword_in,
               output logic sword_out, win, die);

  typedef enum logic [2:0] {S0, S1, S2, S3, S4, S8, S5, S6} statetype;
  statetype state, nextstate;

  always @(posedge clk, posedge reset)
    begin
    	if (reset) 	state <= S0;
        else		state <= nextstate;
    end

  always_comb
    case (state)
      S0: if (e) nextstate = S1;
          else   nextstate = S0;
      S1: if (s) nextstate = S2;
          else if (w) nextstate = S0;
          else nextstate = S1;
      S2: if (w) nextstate = S3;
          else if (e) nextstate = S4;
			 else nextstate = S2;
      S3: if (e) nextstate = S2;
          else if(s) nextstate=S8;
          else nextstate = S3;
      S4: if (sword_in) nextstate = S6;
          else nextstate = S5;
      S8: nextstate = S5;
      S5: nextstate = S5;
      S6: nextstate = S6;
      default: nextstate = S0;
    endcase

  assign sword_out = (state == S3);
  assign win = (state == S6);
  assign die = (state == S5);

endmodule


module swordfsm(input logic clk, reset,
		input logic sword_in,
		output logic sword_out);

  logic state, nextstate;

  always @(posedge clk, posedge reset)
    begin
    	if (reset) 	state <= 0;
        else		state <= nextstate;
    end


   always_comb
     case (state)
       0: if (sword_in) nextstate = 1;
          else nextstate = 0;
       1: nextstate = 1;
     endcase

   assign sword_out = (state == 1);
endmodule