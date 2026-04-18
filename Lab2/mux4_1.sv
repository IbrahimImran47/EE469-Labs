`timescale 1ps/1ps

module mux4_1(out, i, sel);

		output logic out;
		input logic [3:0] i; 
		input logic [1:0] sel;
		wire v0, v1;
		
		mux2_1 m0(.out(v0), .a(i[0]), .b(i[1]), .sel(sel[0]));

		mux2_1 m1(.out(v1), .a(i[2]), .b(i[3]), .sel(sel[0]));
		
		mux2_1 m (.out(out), .a(v0), .b(v1), .sel(sel[1]));
endmodule

module mux4_1_testbench();

	logic [3:0] i;
	logic [1:0] sel;
	logic out;
	
	mux4_1 dut (.out(out), .i(i), .sel(sel));
	integer j;
	initial begin
			for(j=0; j<64; j++) begin
				{sel[1], sel[0], i[0], i[1], i[2], i[3]} = j; #10;
			end
		end
endmodule
