
module lab2_task1(input  logic clk,
                input  logic reset,
                input  logic left, right,
                output logic lc, lb, la, ra, rb, rc);

logic s0, s1;
logic en, r_lr;
logic a, b, c;



logic nexts1, nexts0;
xor nextS1State(nexts1, s0, s1); //s1' = s1 xor s0
not nextS0State(nexts0, s0); //s0' = ^s0



logic ns1, ns0,orns1ns0;
not notS1(ns1, s1);
not notS0(ns0, s0);


logic tempCh, tempEn;
xor startmode(tempCh, left, right); //temp check (left = 0 and right = 0) or (left = 1 and right = 1)
and EN0(tempEn, ns0, ns1); // en = ^s1 and ^s0
and EN1(en, tempCh, tempEn); // en = (right xor left) and (^s1 and ^s0) 

logic sCl;
logic temp;
or f(temp,s1,s0);
or stateCalc(sCl, en, temp);



flopren reg_lr(clk, reset, en, left, r_lr);// to preserve Left/Right control  // left = 0 => right
flopren reg_state0(clk, reset, sCl, nexts0, s0);
flopren reg_state1(clk, reset, sCl, nexts1, s1);



and (a,s0, s0); // a = s0
or (b, s1, s0); // b = s1 or s0
and(c, ns0, s1); // c = s1 and ^s0

//---------------------------------

logic pLa, pLb, pLc, pRa, pRb, pRc;

and preOutLa(pLa, r_lr, a);
and preOutLb(pLb, r_lr, b);
and preOutLc(pLc, r_lr, c);

logic nt;
not nTurn(nt, r_lr);

and preOutRa(pRa, nt, a);
and preOutRb(pRb, nt, b);
and preOutRc(pRc, nt, c);

assign la = pLa;
assign lb = pLb;
assign lc = pLc;

assign ra = pRa;
assign rb = pRb;
assign rc = pRc;


endmodule



module flopren(input  logic clk, reset, en, d,
            output logic q);
            
  always_ff @(posedge clk, posedge reset)
    if (reset) q <= 0;
    else if (en) q <= d;
endmodule

