`timescale 1ps/1ps

module mux2_1 (a, b, sel, out);
	output logic out;
	input logic a, b, sel;
	
	wire notSel, x, y;
	
	not #50 (notSel, sel);
	and #50 (x, notSel, a);
	and #50 (y, sel, b);
	or  #50 (out, y, x);
endmodule

module mux2_1_testbench();
	logic a, b, sel;
	logic out;
	
	mux2_1 dut (.out, .a, .b, .sel);
	
	initial begin
			sel=0; a=0; b=0; #10;
			sel=0; a=0; b=1; #10;
			sel=0; a=1; b=0; #10;
			sel=0; a=1; b=1; #10;
			sel=1; a=0; b=0; #10;
			sel=1; a=0; b=1; #10;
			sel=1; a=1; b=0; #10;
			sel=1; a=1; b=1; #10;
		end
endmodule
