`timescale 1ps/1ps
module ProgramCounter (input logic [63:0] NextPC, input logic clk, input logic reset, output [63:0] currPC);

genvar i;
generate
for(i = 0; i<64; i++) begin: PC
	D_FF dffs(.q(currPC[i]), .d(NextPC[i]), .reset(reset), .clk(clk));
	
	end
	endgenerate
	endmodule
	