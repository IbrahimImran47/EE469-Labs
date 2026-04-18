`timescale 1ps/1ps
module alu (A, B, cntrl, result, negative, overflow, carry_out, zero);

	input [63:0] A;
	input [63:0] B;
	input [2:0] cntrl;
	output [63:0] result;
	output negative, zero, overflow, carry_out;
	
	wire [64:0] chain;
	assign chain[0] = cntrl[0];
	
	
genvar i;
generate
	for(i = 0; i < 64; i = i+1) begin : genSlices
	aluOneBitSlice slices(.A(A[i]), .B(B[i]), .cntrl(cntrl), .result(result[i]), .carry_out(chain[i+1]), .carry_in(chain[i]) );
	end
endgenerate


	assign negative = result[63];
	assign carry_out = chain[64];
	xor #50 (overflow, chain[64], chain[63]);
	
	wire [15:0] level1;
	wire [3:0] level2;
	wire level3;
	
genvar j;
generate
    for (j = 0; j < 16; j = j+1) begin : genLevel1
            or #50 or1 (level1[j], result[j*4+3], result[j*4+2], result[j*4+1], result[j*4]);
        end
endgenerate

genvar k;
generate
    for (k = 0; k < 4; k = k+1) begin : genLevel2
            or #50 or2 (level2[k], level1[k*4+3], level1[k*4+2], level1[k*4+1], level1[k*4]);
        end
endgenerate

or #50 or3 (level3, level2[3], level2[2], level2[1], level2[0]);
not #50 z0 (zero, level3);

endmodule
