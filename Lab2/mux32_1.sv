`timescale 1ps/1ps

module mux32_1(out, i, sel);

		output logic out;
		input logic [31:0] i; 
		input logic [4:0] sel;
		wire v0, v1;
		

		
		mux16_1 m0(.out(v0), .i(i[15:0]), .sel(sel[3:0]));

		mux16_1 m1(.out(v1), .i(i[31:16]), .sel(sel[3:0]));
		
		mux2_1 m (.out(out), .a(v0), .b(v1), .sel(sel[4]));
endmodule

module mux32_1_testbench();

	logic [31:0] i;
	logic [4:0] sel;
	logic out;
	
	mux32_1 dut (.out(out), .i(i), .sel(sel));
	integer j;
	initial begin
			for(j=0; j<2097152000; j++) begin
				{sel[4], sel[3],sel[2] ,sel[1], sel[0], i[0], i[1], i[2], i[3], i[4], i[5], i[6], i[7], i[8], i[9], i[10], i[11], i[12], i[13], i[14], i[15], i[16], i[17], i[18], i[19], i[20], i[21], i[22], i[23], i[24], i[25], i[26], i[27], i[28], i[29], i[30], i[31] } = j; #10;
			end
		end
endmodule
