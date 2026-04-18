`timescale 1ps/1ps
module aluOneBitSlice (A, B, cntrl, result, carry_out, carry_in );
	input logic A, B, carry_in;
	input logic [2:0] cntrl;
	output logic result;
	output logic carry_out;
	
	wire x, y, z, invertedB, fullsum, halfsum ,and1, and2, and3; 
	wire [7:0] muxInputs;
	
	and #50 (x, A, B);
	or #50 (y, A, B);
	xor #50 (z, A, B);
	xor #50 (invertedB, B, cntrl[0]);
	xor #50 (halfsum, A, invertedB);
	xor #50 (fullsum, carry_in, halfsum);
	and #50 (and1, A, invertedB);
	and #50 (and2, invertedB, carry_in);
	and #50 (and3, A, carry_in);
	or #50 (carry_out, and1, and2, and3);
	
	
	assign muxInputs[0] = B;
	assign muxInputs[1] = 1'b0;
	assign muxInputs [2] = fullsum;
	assign muxInputs [3] = fullsum;
	assign muxInputs [4] = x;
	assign muxInputs [5] = y;
	assign muxInputs [6] = z;
	assign muxInputs [7] = 1'b0;
	
	
	mux8_1 m0(.out(result), .i(muxInputs), .sel(cntrl));
endmodule
	