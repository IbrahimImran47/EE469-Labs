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
	logic takebranch_prev;
	
	//Dummy
	logic dN1, dV1, dC1, dZ1, dN2, dV2, dC2, dZ2;
	
	assign four = 64'd4;
	assign x30addr = 5'd30;
	
	
	
	//IF/ID Pipeline Reg singlas;
	logic [63:0] IF_ID_PC4;
	logic [31:0] IF_ID_instructions;
	logic [63:0] IF_ID_PC;
	logic [63:0] ID_EX_PC;
	
	// ID/EX Pipeline Reg Signals;
	
	logic [63:0] ID_EX_PC_4, ID_EX_ReadData_1, ID_EX_ReadData_2, ID_EX_imm;
	logic [4:0] ID_EX_Rd, ID_EX_Rn, ID_EX_Rm;
	logic [31:0] ID_EX_instructions;
	logic ID_EX_AluSrc, ID_EX_RWrite, ID_EX_FWrite, ID_EX_MWrite, ID_EX_MRead, ID_EX_BL, ID_EX_BRse, ID_EX_CBZBr, ID_EX_LTBr, ID_EX_UncondBranch, ID_EX_ImmSrc;
	logic [2:0] ID_EX_AOp;
	logic [1:0] ID_EX_Mem2Reg;
	
	// EX/MEM Piepline Register Signals;
	logic [63:0] EX_MEM_AluRes, EX_MEM_readData2, EX_MEM_PC_4;
	logic [4:0] EX_MEM_WriteReg;
	logic EX_MEM_RWrite, EX_MEM_MWrite, EX_MEM_MRead;
	logic [1:0] EX_MEM_Mem2Reg;
	
	// MEM/WB Pipeline Register Signals
	logic [63:0] MEM_WB_AluRes, MEM_WB_memoryData, MEM_WB_PC_4;
	logic [4:0] MEM_WB_writeReg;
	logic [1:0] MEM_WB_Mem2Reg;
	logic MEM_WB_RWrite;
	logic [63:0] prev_wb_writedata;
	logic [4:0] prev_wb_write_reg;
	logic prev_wb_RegWrite;
	
	
	// forward signals;
	
	logic [1:0] ForwardA, ForwardB, ForwardRd;
	logic [63:0] fA, fB, fRd;
	logic [63:0] fwdB_final;
	logic [63:0] MEM_WB_writeData;
	
	//flush
	logic [31:0] flushed_instruction;
	
	
	assign flushed_instruction = takebranch ? 32'b10010001000000000000001111111111 : instruction;
	always_ff @(posedge clk) takebranch_prev <= takebranch;
	//==================================================================
	//Pipeline REg IF/ID
	//==================================================================
	
always_ff @(posedge clk) begin
    if(reset) begin
        IF_ID_PC4 <= 0;
        IF_ID_instructions <= 0;
        IF_ID_PC <= 0;
    end else begin
        IF_ID_PC4 <= PC4;
        IF_ID_instructions <= flushed_instruction;
        IF_ID_PC <= PC;
    end
end
	//==================================================================
	// Pipeline Reg ID/EX
	//==================================================================
	
	
	always_ff @(posedge clk) begin
		if(reset) begin
		ID_EX_PC_4 <= 0;
		ID_EX_ReadData_1 <= 0;
		ID_EX_ReadData_2 <= 0;
		ID_EX_imm <= 0;
		ID_EX_instructions <= 0;
		ID_EX_Rd <= 0;
		ID_EX_Rn <= 0;
		ID_EX_Rm <= 0;
		ID_EX_RWrite <= 0;
		ID_EX_FWrite <= 0;
		ID_EX_MWrite <= 0;
		ID_EX_MRead <= 0;
		ID_EX_BL <= 0;
		ID_EX_BRse <= 0;
		ID_EX_CBZBr <= 0;
		ID_EX_LTBr <= 0;
		ID_EX_UncondBranch <= 0;
		ID_EX_Mem2Reg <= 0;
		ID_EX_AOp <= 0;
		ID_EX_AluSrc <= 0;
		ID_EX_ImmSrc <= 0;
		ID_EX_PC <= 0;
	end else begin
		ID_EX_PC_4 <= IF_ID_PC4;
		ID_EX_ReadData_1 <= readData1;
		ID_EX_ReadData_2 <= readData2;
		ID_EX_imm <= imm;
		ID_EX_instructions <= IF_ID_instructions;
		ID_EX_Rd <= IF_ID_instructions[4:0];
		ID_EX_Rn <= IF_ID_instructions[9:5];
		ID_EX_Rm <= IF_ID_instructions[20:16];
		ID_EX_RWrite <= RWrite;
		ID_EX_FWrite <= FWrite;
		ID_EX_MWrite <= MWrite;
		ID_EX_MRead  <= MRead;
		ID_EX_BL <= BL;
		ID_EX_BRse <= BRsel;
		ID_EX_CBZBr<= CBZBr;
		ID_EX_LTBr <= LTBr;
		ID_EX_UncondBranch <= UncondBranch;
		ID_EX_Mem2Reg <= Mem2Reg;
		ID_EX_AOp <= AOp;
		ID_EX_AluSrc <= AluSrc;
		ID_EX_ImmSrc <= iSel;
		ID_EX_PC <= IF_ID_PC;
	end
end

	//==================================================================
	// Pipeline Reg EX/MEM
	//==================================================================
	
	
	always_ff @(posedge clk) begin
	if(reset) begin
		EX_MEM_AluRes   <= 0; 
		EX_MEM_readData2 <= 0;
		EX_MEM_WriteReg <= 0; 
		EX_MEM_RWrite   <= 0;
		EX_MEM_MWrite   <= 0; 
		EX_MEM_MRead    <= 0;
		EX_MEM_Mem2Reg  <= 0; 
		EX_MEM_PC_4 <= 0;
	end else begin
		EX_MEM_AluRes <= aluRes;
		EX_MEM_readData2 <= fRd;
		EX_MEM_WriteReg <= ID_EX_RWrite ? ID_EX_Rd : 5'd31;
		EX_MEM_RWrite <= ID_EX_RWrite;
		EX_MEM_MWrite <= ID_EX_MWrite;
		EX_MEM_MRead <= ID_EX_MRead;
		EX_MEM_Mem2Reg <= ID_EX_Mem2Reg;
		EX_MEM_PC_4 <= ID_EX_PC_4;
	end
end

	//==================================================================
	// Pipeline Reg MEM/WB
	//==================================================================
	
	always_ff @(posedge clk) begin
		if (reset) begin
		
		MEM_WB_AluRes <= 0; 
		MEM_WB_memoryData <= 0;
		MEM_WB_writeReg <= 0; 
		MEM_WB_RWrite <= 0;
		MEM_WB_Mem2Reg <= 0; 
		MEM_WB_PC_4 <= 0;
	end else begin
		MEM_WB_AluRes <= EX_MEM_AluRes;
		MEM_WB_memoryData <= memoryData;
		MEM_WB_writeReg <= EX_MEM_WriteReg;
		MEM_WB_RWrite <= EX_MEM_RWrite;
		MEM_WB_Mem2Reg <= EX_MEM_Mem2Reg;
		MEM_WB_PC_4 <= EX_MEM_PC_4;
	end
end
	
	
	//Forward
	
always_ff @(posedge clk) begin
    prev_wb_writedata <= MEM_WB_AluRes;
    prev_wb_write_reg <= MEM_WB_writeReg;
    prev_wb_RegWrite  <= MEM_WB_RWrite;
end
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
		.Opcodes(IF_ID_instructions[31:21]), .Reg2Loc(Reg2Loc), .UncondBranch(UncondBranch), .Branch(Branch), .AluSrc(AluSrc), .RWrite(RWrite), .FWrite(FWrite), .MWrite(MWrite), .MRead(MRead), .BL(BL), .BRsel(BRsel), .CBZBr(CBZBr), .LTBr(LTBr), .ImmSrc(iSel), .Mem2Reg(Mem2Reg), .AOp(AOp)
	);
	
	
	//==================================================================
	// Reg2Loc Mux to pic for Rd or Rm for our second read port 
	//==================================================================
	mux5_2_1 reg2locMux (.out(readReg2), .a(IF_ID_instructions[4:0]), .b(IF_ID_instructions[20:16]), .sel(Reg2Loc));
	mux5_2_1 reg1locMux (.out(readReg1), .a(IF_ID_instructions[9:5]), .b(IF_ID_instructions[4:0]), .sel(BRsel));

	//==================================================================
	// Write reg mux (x30 for BL, everything else is Rd) 
	//==================================================================
mux5_2_1 WriteMux (.out(writeReg), .a(ID_EX_Rd), .b(x30addr), .sel(ID_EX_BL));
	
	//==================================================================
	// Register File
	//==================================================================
	regfile regf (
		.ReadData1(readData1), .ReadData2(readData2), .WriteData(writeData), .ReadRegister1(readReg1), .ReadRegister2(readReg2), .WriteRegister(MEM_WB_writeReg), .RegWrite(MEM_WB_RWrite), .clk(clk)
	);
	
	//==================================================================
	// Extender
	//==================================================================
	
	extend singExtend (.ins(IF_ID_instructions), .ImmSrc(iSel), .extended(imm));
	
	//==================================================================
	// ALU Src Mux
	//==================================================================
always_comb begin
    if(ID_EX_AluSrc)
        fwdB_final = ID_EX_imm;
    else
        fwdB_final = fB;
end
	
	
	
	//==================================================================
	// Forwarding Unit Instantiation
	//==================================================================
forwarding_unit forwardingUnit (.ID_EX_Rn(ID_EX_Rn), .ID_EX_Rm(ID_EX_Rm), .ID_EX_Rd(ID_EX_Rd), .EX_MEM_WriteReg(EX_MEM_WriteReg), .EX_MEM_RWrite(EX_MEM_RWrite), .MEM_WB_WriteReg(MEM_WB_writeReg), .MEM_WB_RWrite(MEM_WB_RWrite), .prev_wb_write_reg(prev_wb_write_reg), .prev_wb_RegWrite(prev_wb_RegWrite), .ForwardA(ForwardA), .ForwardB(ForwardB), .ForwardRd(ForwardRd));

	always_comb begin	
	case(ForwardA)
		2'b00: fA = ID_EX_ReadData_1;
		2'b01: fA = MEM_WB_AluRes; 
		2'b10: fA = EX_MEM_AluRes;
		2'b11: fA = prev_wb_writedata;
		default: fA = ID_EX_ReadData_1;
	endcase
end

always_comb begin	
    case(ForwardB)
        2'b00: fB = ID_EX_ReadData_2;
        2'b01: fB = MEM_WB_AluRes;
        2'b10: fB = EX_MEM_AluRes;
		  2'b11: fB = prev_wb_writedata;
        default: fB = ID_EX_ReadData_2;
    endcase
end

	always_comb begin	
	case(ForwardRd)
		2'b00: fRd = ID_EX_ReadData_2;
		2'b01: fRd = MEM_WB_writeData;
		2'b10: fRd = EX_MEM_AluRes;
		default: fRd = ID_EX_ReadData_2;
	endcase
end

	
	
	//==================================================================
	// Main ALU Instantiation
	//==================================================================
	
	alu Alu (.A(fA), .B(fwdB_final), .cntrl(ID_EX_AOp), .result(aluRes), .negative(neg), .overflow(overflow), .carry_out(carryout), .zero(zero));
	
	
	//==================================================================
	// Flag Register
	//==================================================================
	flags flagRegister (
		.clk(clk), .reset(reset), .FWrite(ID_EX_FWrite), .Nin(neg), .Vin(overflow), .Zin(zero), .Cin(carryout), .N(NFlag), .V(VFlag), .Z(ZFlag), .C(CFlag)
	);
	
	
	//==================================================================
	// Data 
	//==================================================================
	
	datamem dMemory(
	.address(EX_MEM_AluRes), .write_enable(EX_MEM_MWrite), .read_enable(EX_MEM_MRead), .write_data(EX_MEM_readData2), .clk(clk), .xfer_size(4'd8), .read_data(memoryData)
	);
	
	//==================================================================
	// Write-back Mux (00=ALU, 01=Mem, 10=PC+4)
	//==================================================================
	
	mux64_2_1 wb_s1 (.out(wb1),  .a(MEM_WB_AluRes),   .b(MEM_WB_memoryData), .sel(MEM_WB_Mem2Reg[0]));
	mux64_2_1 wb_s2 (.out(writeData), .a(wb1), .b(MEM_WB_PC_4),        .sel(MEM_WB_Mem2Reg[1]));
	assign MEM_WB_writeData = writeData;
	
	//==================================================================
	// Branch Offset
	//==================================================================
	Offset branchOff (.instruction(ID_EX_instructions), .UncondBranch(ID_EX_UncondBranch), .BranchOffset(BrOffset));
	
	//==================================================================
	// PC + BR OFF adder
	//==================================================================
	alu brAdder (
		.A(ID_EX_PC), .B(BrOffset), .cntrl(3'b010), .result(PCBr), .negative(dN2), .overflow(dV2), .carry_out(dC2), .zero(dZ2)
	);
	
	
	//==================================================================
	// Take Branch?
	//==================================================================
	brancher branchDecision (
		.UncondBranch(ID_EX_UncondBranch), .CBZBr(ID_EX_CBZBr), .Z(zero), .LTBr(ID_EX_LTBr), .Nf(NFlag), .Vf(VFlag), .branch(takebranch)
	);
	
	//==================================================================
	// Next PC Mux (PC4 / PCBr / readData1 for BR)
	//==================================================================
	mux64_2_1 npcs1 (.out(nPCstage1), .a(PC4),        .b(PCBr),     .sel(takebranch));
	mux64_2_1 npcs2 (.out(nPC),        .a(nPCstage1), .b(ID_EX_ReadData_1),.sel(ID_EX_BRse));

endmodule
	