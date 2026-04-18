`timescale 1ps/1ps

module mux16_1(out, i, sel);

		output logic out;
		input logic [15:0] i; 
		input logic [3:0] sel;
		wire v0, v1;
		

		
		mux8_1 m0(.out(v0), .i(i[7:0]), .sel(sel[2:0]));

		mux8_1 m1(.out(v1), .i(i[15:8]), .sel(sel[2:0]));
		
		mux2_1 m (.out(out), .a(v0), .b(v1), .sel(sel[3]));
endmodule

module mux16_1_testbench();

	logic [15:0] i;
	logic [3:0] sel;
	logic out;
	
	mux16_1 dut (.out(out), .i(i), .sel(sel));
	integer j;
	initial begin
			for(j=0; j<2097152; j++) begin
				{sel[3],sel[2] ,sel[1], sel[0], i[0], i[1], i[2], i[3], i[4], i[5], i[6], i[7], i[8], i[9], i[10], i[11], i[12], i[13], i[14], i[15] } = j; #10;
			end
		end
endmodule
