`timescale 1ns/10ps

module register64bit (q, d, reset, clk, enable);
	output [63:0] q;
	input [63:0] d; 
	input reset, clk, enable;
	wire [63:0] muxOutput;

genvar i;
generate
	for(i = 0; i < 64; i = i+1) begin : genReg
	mux2_1 m (.out(muxOutput[i]), .a(q[i]), .b(d[i]), .sel(enable));
	D_FF dff_instantiations(q[i], muxOutput[i], reset, clk);
	end
endgenerate
endmodule
