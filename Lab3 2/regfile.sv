`timescale 1ps/1ps

module regfile(ReadData1, ReadData2, WriteData, ReadRegister1, ReadRegister2, WriteRegister, RegWrite, clk);
	input  [4:0] 	ReadRegister1, ReadRegister2, WriteRegister;
	input  [63:0]	WriteData;
	input  RegWrite, clk;
	output [63:0]	ReadData1, ReadData2;
	
	wire [31:0] decoderOut;
	wire [63:0] registerOut [31:0];
	decoder5_32 d(.out(decoderOut), .a(WriteRegister), .enable(RegWrite));
	assign registerOut[31] = 64'b0; //this is allowed i believe, because we ae hardcoding x32
	
	genvar i, j;
generate
	for(i = 0; i < 31; i = i+1) begin : genRegs
	register64bit Rs(.q(registerOut[i]), .d(WriteData), .enable(decoderOut[i]), .clk(clk), .reset(1'b0)) ;
	end



	for(i = 0; i < 64; i = i+1) begin: genMuxes
	wire [31:0] topMuxes;
		for(j = 0; j < 32; j  =j+1) begin: attach
			assign topMuxes[j] = registerOut[j][i];
			end
	mux32_1 mux1(.out(ReadData1[i]), .i(topMuxes), .sel(ReadRegister1));
	mux32_1 mux2(.out(ReadData2[i]), .i(topMuxes), .sel(ReadRegister2));
	end
endgenerate
endmodule
