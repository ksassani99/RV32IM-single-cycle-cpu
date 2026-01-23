# RV32IM Single-Cycle RISC-V Processor

(in-progress) A synthesizable, single-cycle 32-bit RISC-V processor core designed in Verilog. This implementation is based on the **UC Berkeley CS 61C "Project 3"** datapath specifications but expands upon the standard educational curriculum by integrating the **RV32M Standard Extension** (Multiplication Subset) and robust signed/unsigned arithmetic handling.

## Key Technical Features

* **ISA Compliance:** Implements the **RV32I** Base Integer Set and a subset of the **RV32M** Extension.

* **Single-Cycle Microarchitecture:** Executes the full Fetch-Decode-Execute-Memory-Writeback logic sequence within a single clock cycle.

* **Partial M-Extension Support:** Hardware support for `MUL`, `MULH`, `MULHSU`, and `MULHU` operations. *(Note: Hardware division and remainder operations are not currently implemented).*

* **Memory Operations:** Dedicated alignment logic for partial loads/stores (`LB`, `LH`, `SB`, `SH`) with correct sign-extension and data masking.

* **Branching:** Signed and unsigned comparison logic for conditional branching (`BEQ`, `BNE`, `BLT`, `BGE`, `BLTU`, `BGEU`).

## Processor Architecture

The core utilizes a classic single-cycle datapath architecture, utilizing separate instruction and data memory interfaces.

<img width="4369" height="2202" alt="Single-Cycle CPU Datapath" src="https://github.com/user-attachments/assets/0902d332-a4cd-40db-b330-988dc4452317" />

### Logical Datapath Stages

Although this is a single-cycle processor (where the CPI is 1), the combinational logic is organized into five distinct phases that execute sequentially during the clock period:

1. **Fetch:** The Program Counter (PC) addresses the Instruction Memory (IMEM) to retrieve the current 32-bit instruction.

2. **Decode:** The `Control Logic` decodes the opcode/funct fields, while the `RegFile` reads source operands (`rs1`, `rs2`) and `ImmGen` extends immediate values.

3. **Execute:** The `ALU` performs arithmetic/logical operations on operands selected by multiplexers. The `BranchComp` evaluates conditions (`==`, `<`) to determine if a branch should be taken.

4. **Memory:** If the instruction is a Load or Store, the `DMEM` is accessed. Address calculation happens in the ALU during the Execute phase.

5. **Writeback:** The result (from ALU, Memory, or PC+4) is selected and written back into the destination register (`rd`) in the `RegFile`.

## System Architecture & File List

The project is modularized to correspond with the standard RISC-V datapath components.

### Core Logic

* **`cpu.v` (Top-Level):** Instantiates the PC and connects all sub-modules (ALU, RegFile, Control, Memory) to form the complete processor.

* **`control_logic.v`:** The main decoder unit. Translates `opcode`, `funct3`, and `funct7` instruction fields into hardware control signals (`RegWEn`, `ImmSel`, `ALUSel`, `MemRW`, etc.).

* **`alu.v`:** Arithmetic Logic Unit. Implements `ADD`, `SUB`, `AND`, `OR`, `XOR`, shifts (`SLL`/`SRL`/`SRA`), comparisons (`SLT`/`SLTU`), and hardware multiplication (`MUL` family).

* **`branch_comp.v`:** Branch Comparator. Compares two 32-bit register values to output `BrEq` (Equal) and `BrLt` (Less Than) flags, supporting both signed and unsigned modes.

* **`imm_gen.v`:** Immediate Generator. Decodes and sign-extends immediate values from I, S, B, U, and J instruction formats.

### Memory & State

* **`regfile.v`:** A 32x32-bit register file with two asynchronous read ports and one synchronous write port. Register `x0` is hardwired to 0.

* **`dmem.v`:** Data Memory. A 4KB (1024-word) SRAM module used for data storage.

* **`partial_load.v`:** Load Alignment Unit. Post-processes memory reads for `LB`, `LH`, `LBU`, and `LHU` by selecting specific bytes/half-words and handling sign-extension.

* **`partial_store.v`:** Store Alignment Unit. Pre-processes memory writes for `SB` and `SH` by shifting data to the correct byte alignment and generating the write mask.

### Verification

* **`tb_cpu.v`:** System Testbench. Generates clock/reset signals and loads hex programs into instruction memory to verify the core against reference outputs.

## Supported Instruction Set (RV32IM Subset)

| **Type** | **Syntax** | **Instructions Implemented** | 
| :--- | :--- | :--- |
| **Arithmetic (R-Type)** | `OP rd, rs1, rs2` | `ADD`, `SUB`, `SLT`, `SLTU`, `XOR`, `OR`, `AND`, `SLL`, `SRL`, `SRA` | 
| **Multiply (M-Ext)** | `OP rd, rs1, rs2` | **`MUL`**, **`MULH`** (Signed High), **`MULHSU`** (Signed/Unsigned), **`MULHU`** (Unsigned) | 
| **Immediate (I-Type)** | `OP rd, rs1, imm` | `ADDI`, `SLTI`, `SLTIU`, `XORI`, `ORI`, `ANDI`, `SLLI`, `SRLI`, `SRAI` | 
| **Loads (I-Type)** | `OP rd, offset(rs1)` | `LB`, `LH`, `LW`, `LBU`, `LHU` | 
| **Stores (S-Type)** | `OP rs2, offset(rs1)` | `SB`, `SH`, `SW` | 
| **Branch (B-Type)** | `OP rs1, rs2, offset` | `BEQ`, `BNE`, `BLT`, `BGE`, `BLTU`, `BGEU` | 
| **Jump (J-Type)** | `JAL rd, offset` | `JAL` | 
| **Jump (I-Type)** | `JALR rd, offset(rs1)` | `JALR` | 
| **Upper (U-Type)** | `OP rd, imm` | `LUI`, `AUIPC` |
