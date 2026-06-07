`timescale 1ps/1ps

module extend(ins, ImmSrc, extended);
	input logic [31:0] ins;
	input logic ImmSrc;
	output logic [63:0] extended;
	
	wire [63:0] se_imm9;
	wire [63:0] ze_imm12;
	
	assign se_imm9  = {{55{ins[20]}}, ins[20:12]};
	assign ze_imm12 = {52'b0, ins[21:10]};
	mux64_2_1 m (.out(extended), .a(se_imm9), .b(ze_imm12), .sel(ImmSrc));
endmodule
