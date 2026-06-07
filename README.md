# EE469 - Digital Design Labs

**University of Washington | Spring 2026**

This repository contains lab implementations for EE469, where we incrementally build a pipelined ARMv8 (LEGv8) 64-bit microprocessor using structural Verilog. All datapath logic is gate-level (AND, OR, NAND, NOR, XOR, multiplexors, etc.) with no behavioral RTL. Development and simulation using Quartus II and ModelSim.

## Labs

| Lab | Description |
|-----|-------------|
| Lab 1 | **32×64 ARM Register File** — Implemented using D flip-flops, 5:32 decoder, dual-read / single-write multiplexor tree. Zero-register (X31) protection from writes. |
| Lab 2 | **64-bit ALU** — Gate-level adder/subtractor, logic operations (AND, OR, XOR), shift/rotate, condition flags (N, Z, C, V). Supports all LEGv8 data-processing instructions. |
| Lab 3 | **Single-Cycle CPU** — Complete datapath integrating register file, ALU, control logic, and memory interface. Executes LDUR, STUR, arithmetic, logical, and branch instructions in one cycle. |
| Lab 4 | **5-Stage Pipelined CPU** — IF / ID / EX / MEM / WB pipeline with full forwarding unit, hazard detection, and branch delay slot handling. Debugged gate-delay timing issues and flush-logic edge cases. Passes 10+ test cases including forwarding-dependent and branch-heavy workloads. |
| Lab 5 | **Cache Hierarchy Characterization** — Reverse-engineered a hidden 3-level cache through experimental testbenches. Measured blocksize, capacity, associativity, replacement policy (Random), write policies (write-through / write-back), and write-buffer presence for L1, L2, and L3. |

## Key Learnings

- **Forwarding priority & sources**: ALU and memory are valid forwarding sources; branch and load cannot forward. X31 protected from all datapath writes.
- **Pipeline hazards**: Data hazards resolved via forwarding and stalls; control hazards handled with delay slots and flush logic using `takebranch_prev` to avoid consuming the delay-slot instruction.
- **Gate-delay timing**: Propagation delays in multiplexor chains can corrupt multi-cycle forwarded values; zero-delay `assign` statements provide a fix.
- **Cache design tradeoffs**: Capacity vs. hit time vs. associativity; write policies and buffering impact memory subsystem latency.

## Tools & Environment

- **Quartus II 17.0** (Intel FPGA Edition)
- **ModelSim** (Intel FPGA Edition)
- **SystemVerilog / Verilog**


## Repository Structure
