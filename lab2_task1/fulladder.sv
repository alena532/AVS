//
//
module flopr(input logic clk, input logic reset,
	input logic [5:0] d, output logic [5:0] q);
// синхронный сброс 
	always_ff @(posedge clk)
		if (reset) q <= 5'b0;
		else q <= d; 
endmodule


module lab2_5(input logic clk, input logic reset,
	input logic left, right,output logic la,lb,lc,ra,rb,rc);

	logic l,r,a,b,c;
	logic l1,r1,a1,b1,c1;
	flopr fl(clk,reset,{l,r,a,b,c},{l1,r1,a1,b1,c1});
	next_state next(left,right,l1,r1,a1,b1,c1,l,r,a,b,c);
	decoder dec(l,r,a,b,c,la,lb,lc,ra,rb,rc);
endmodule





module decoder (input logic input_l,input_r,input_a,input_b,input_c,output logic la,lb,lc,ra,rb,rc);
	assign la=input_l & input_a;
	assign lb=input_l & input_b;
	assign lc=input_l & input_c;
	
	assign ra=input_r & input_a;
	assign rb=input_r & input_b;
	assign rc=input_r & input_c;
endmodule



module next_state(input logic left,right,input_l,input_r,input_a,input_b,input_c,output logic l,r,a,b,c);
	assign l =(~input_l & ~input_r & left)| ((input_l&input_b)&((input_a & ~input_c)|(~input_a & input_c));
	assign r=(~input_l & ~input_r & right)|((input_r&input_b)&((input_a & ~input_c)|(~input_a & input_c)));
	assign a=(~input_a & ~input_b&~input_c)|((left|right)&(~input_a & input_b & input_c)));
	assign b=(~input_a & ~input_b&~input_c)|((left|right)&((input_a & input_b&~input_c)|(~input_a & input_b&input_c)));
	assign c=input_a & input_b&~input_c;
endmodule