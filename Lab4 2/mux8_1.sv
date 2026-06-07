`timescale 1ps/1ps

module mux8_1(out, i, sel);

		output logic out;
		input logic [7:0] i; 
		input logic [2:0] sel;
		wire v0, v1;
		

		
		mux4_1 m0(.out(v0), .i(i[3:0]), .sel(sel[1:0]));

		mux4_1 m1(.out(v1), .i(i[7:4]), .sel(sel[1:0]));
		
		mux2_1 m (.out(out), .a(v0), .b(v1), .sel(sel[2]));
endmodule

module mux8_1_testbench();

	logic [7:0] i;
	logic [2:0] sel;
	logic out;
	
	mux8_1 dut (.out(out), .i(i), .sel(sel));
	integer j;
	initial begin
			for(j=0; j<2048; j++) begin
				{sel[2] ,sel[1], sel[0], i[0], i[1], i[2], i[3], i[4], i[5], i[6], i[7] } = j; #10;
			end
		end
endmodule
