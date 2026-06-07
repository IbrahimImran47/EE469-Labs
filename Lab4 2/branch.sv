`timescale 1ps/1ps
module Offset(instruction, UncondBranch, BranchOffset);
	input logic [31:0] instruction;
	input logic UncondBranch;
	output logic [63:0] BranchOffset;
	
	wire [63:0] UNCOff;
	wire [63:0] condOff;
	
	assign UNCOff = {{36{instruction[25]}}, instruction[25:0], 2'b00};
	assign condOff   = {{43{instruction[23]}}, instruction[23:5], 2'b00};
	
	mux64_2_1 m (.out(BranchOffset), .a(condOff), .b(UNCOff), .sel(UncondBranch));
endmodule

module brancher(UncondBranch, CBZBr, Z, LTBr, Nf, Vf, branch);
	input logic UncondBranch, CBZBr, Z, LTBr, Nf, Vf;
	output logic branch;
	
	wire cbzAnd;
	wire LTXor;
	wire LTAnd;
	wire temp;
	
	and #50 a (cbzAnd, CBZBr, Z);
	xor #50 x0 (LTXor, Nf, Vf);
	and #50 a1 (LTAnd, LTBr, LTXor);
	or  #50 o0 (temp, UncondBranch, cbzAnd);
	or  #50 o1 (branch, temp, LTAnd);
endmodule
