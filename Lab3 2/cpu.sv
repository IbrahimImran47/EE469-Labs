`timescale 1ps/1ps

	module cpu (clk, reset);
	input logic clk, reset;
	
	//==================================================================
	//All of my signals are declared here!
	//==================================================================
	// This is for the Program Counter and Program Counter update
	logic [63:0] PC, nPC, PC4, PCBr;
	logic [63:0] four;
	logic [63:0] BrOffset;
	
	// Insturction signal
	logic [31:0] instruction;
	
	//Control Signals
	logic Reg2Loc, UncondBranch, Branch, AluSrc, RWrite, FWrite, MWrite, MRead, BL, BRsel, CBZBr, LTBr;
	logic [1:0] Mem2Reg;
	logic iSel;
	logic [2:0] AOp;
	
	
	//Register File Signals
	logic [4:0] readReg2, writeReg;
	logic [63:0] readData1, readData2, writeData;
	logic [4:0] x30addr;
	logic [4:0] readReg1;
	
	// Sign Extend Signal
	logic [63:0] imm;
	
	//AlU and flags
	logic [63:0] aluB, aluRes;
	logic neg, overflow, carryout, zero;
	
	// Reg Flags;
	logic NFlag, VFlag, ZFlag, CFlag;
	
	//Data Memoryu
	
	logic [63:0] memoryData;
	logic [63:0] wb1;
	
	// Branch Decision
	
	logic takebranch;
	logic [63:0] nPCstage1;
	
	//Dummy
	logic dN1, dV1, dC1, dZ1, dN2, dV2, dC2, dZ2;
	
	assign four = 64'd4;
	assign x30addr = 5'd30;
	
	//==================================================================
	//Program Counter and Register
	//==================================================================
	ProgramCounter programCounter (.NextPC(nPC), .clk(clk), .reset(reset), .currPC(PC));
	
	//==================================================================
	//Program Counter and + 4 adder
	//==================================================================
	
	alu pcAdder (.A(PC), .B(four), .cntrl(3'b010), .result(PC4), .negative(dN1), .overflow(dV1), .carry_out(dC1), .zero(dZ1));
	//==================================================================
	//Instruction mem
	//==================================================================
	
	instructmem imem (.address(PC), .instruction(instruction), .clk(clk));
	
	
	//==================================================================
	// Control Unit
	//==================================================================
	control ctrl (
		.Opcodes(instruction[31:21]), .Reg2Loc(Reg2Loc), .UncondBranch(UncondBranch), .Branch(Branch), .AluSrc(AluSrc), .RWrite(RWrite), .FWrite(FWrite), .MWrite(MWrite), .MRead(MRead), .BL(BL), .BRsel(BRsel), .CBZBr(CBZBr), .LTBr(LTBr), .ImmSrc(iSel), .Mem2Reg(Mem2Reg), .AOp(AOp)
	);
	
	
	//==================================================================
	// Reg2Loc Mux to pic for Rd or Rm for our second read port
	//==================================================================
	mux5_2_1 reg2locMux (.out(readReg2), .a(instruction[4:0]), .b(instruction[20:16]), .sel(Reg2Loc));
	mux5_2_1 reg1locMux (.out(readReg1), .a(instruction[9:5]), .b(instruction[4:0]), .sel(BRsel));
	
	//==================================================================
	// Write reg mux (x30 for BL, everything else is Rd) 
	//==================================================================
	mux5_2_1 writeMux (.out(writeReg), .a(instruction[4:0]), .b(x30addr), .sel(BL));
	
	//==================================================================
	// Register File
	//==================================================================
	regfile regf (
		.ReadData1(readData1), .ReadData2(readData2), .WriteData(writeData), .ReadRegister1(readReg1), .ReadRegister2(readReg2), .WriteRegister(writeReg), .RegWrite(RWrite), .clk(clk)
	);
	
	//==================================================================
	// Extender
	//==================================================================
	
	extend singExtend (.ins(instruction), .ImmSrc(iSel), .extended(imm));
	
	//==================================================================
	// ALU Src Mux
	//==================================================================
	mux64_2_1 aluSrcMux (.out(aluB), .a(readData2), .b(imm), .sel(AluSrc));
	
	//==================================================================
	// Main ALU Instantiation
	//==================================================================
	
	alu Alu (.A(readData1), .B(aluB), .cntrl(AOp), .result(aluRes), .negative(neg), .overflow(overflow), .carry_out(carryout), .zero(zero)
	);
	
	//==================================================================
	// Flag Register
	//==================================================================
	flags flagRegister (
		.clk(clk), .reset(reset), .FWrite(FWrite), .Nin(neg), .Vin(overflow), .Zin(zero), .Cin(carryout), .N(NFlag), .V(VFlag), .Z(ZFlag), .C(CFlag)
	);
	
	
	//==================================================================
	// Data 
	//==================================================================
	
	datamem dMemory(
	.address(aluRes), .write_enable(MWrite), .read_enable(MRead), .write_data(readData2), .clk(clk), .xfer_size(4'd8), .read_data(memoryData)
	);
	
	//==================================================================
	// Write-back Mux (00=ALU, 01=Mem, 10=PC+4)
	//==================================================================
	
	mux64_2_1 wb_s1 (.out(wb1),  .a(aluRes),   .b(memoryData), .sel(Mem2Reg[0]));
	mux64_2_1 wb_s2 (.out(writeData), .a(wb1), .b(PC4),        .sel(Mem2Reg[1]));
	
	//==================================================================
	// Branch Offset
	//==================================================================
	Offset branchOff (.instruction(instruction), .UncondBranch(UncondBranch), .BranchOffset(BrOffset));
	
	//==================================================================
	// PC + BR OFF adder
	//==================================================================
	alu brAdder (
		.A(PC), .B(BrOffset), .cntrl(3'b010), .result(PCBr), .negative(dN2), .overflow(dV2), .carry_out(dC2), .zero(dZ2)
	);
	
	
	//==================================================================
	// Take Branch?
	//==================================================================
	brancher branchDecision (
		.UncondBranch(UncondBranch), .CBZBr(CBZBr), .Z(zero), .LTBr(LTBr), .Nf(NFlag), .Vf(VFlag), .branch(takebranch)
	);
	
	//==================================================================
	// Next PC Mux (PC4 / PCBr / readData1 for BR)
	//==================================================================
	mux64_2_1 npcs1 (.out(nPCstage1), .a(PC4),        .b(PCBr),     .sel(takebranch));
	mux64_2_1 npcs2 (.out(nPC),        .a(nPCstage1), .b(readData1),.sel(BRsel));

endmodule
	