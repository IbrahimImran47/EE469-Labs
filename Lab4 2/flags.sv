`timescale 1ps/1ps


module flags(clk, reset, FWrite, Nin, Vin, Zin, Cin, N, V, Z, C);
	input logic clk, reset, FWrite, Nin, Vin, Zin, Cin;
	output logic N, V, Z, C;
	wire muxN, muxV, muxC, muxZ;
	
	
	mux2_1 m0 (.out(muxN), .a(N), .b(Nin), .sel(FWrite));
	mux2_1 m1 (.out(muxV), .a(V), .b(Vin), .sel(FWrite));
	mux2_1 m2 (.out(muxZ), .a(Z), .b(Zin), .sel(FWrite));
	mux2_1 m3 (.out(muxC), .a(C), .b(Cin), .sel(FWrite));
	
	D_FF dffN (.q(N), .d(muxN), .reset(reset), .clk(clk));
	D_FF dffV (.q(V), .d(muxV), .reset(reset), .clk(clk));
	D_FF dffC (.q(C), .d(muxC), .reset(reset), .clk(clk));
	D_FF dffZ (.q(Z), .d(muxZ), .reset(reset), .clk(clk));
endmodule
