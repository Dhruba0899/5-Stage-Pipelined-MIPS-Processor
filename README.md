# 5-Stage-Pipelined-MIPS-Processor

This project implements a 5 stage pipelined MIPS processor in Verilog with a forwarding unit and basic hazard handling logic.

---

## Features

- Classic 5-stage MIPS pipeline:
  1. Instruction Fetch (IF)
  2. Instruction Decode (ID)
  3. Execute (EX)
  4. Memory Access (MEM)
  5. Write Back (WB)
- Pipeline registers: `IF/ID`, `ID/EX`, `EX/MEM`, `MEM/WB`
- Forwarding unit to resolve data hazards
- Load-use hazard stalling mechanism
- Supports basic R-type, I-type, and J-type instructions

---

## Architecture details 

- **Registers**: 32 general purpose 32 bit registers (R0–R31) and R0 is always 0
- **Instruction Memory (IMEM)**: 32 bit wide
- **Data Memory (DMEM)**: 8 bit wide; supports 32 bit data in big-endian format
- **Hazard Handling**: Forwarding and stalling logic to prevent incorrect data usage

- **Architectural Diagram** : 
  
![image](https://github.com/user-attachments/assets/20788052-d1e1-49a3-be48-37a5f0d39f2d)



---

## Instruction Format

### **Load and Store**
- `lw destinationReg, offset(sourceReg)` – Opcode: `100011`
  - | opcode | rs(sourceReg) | rt(destinationReg) | imm(offset) |
    |----------|----------|----------| ----------|
    | 6 bits(31:26) | 5 bits (25:21) | 5 bits (20:16) | 16 bits (15:0) |

- `sw sourceReg1, offset(sourceReg2)` – Opcode: `101011`
  - | opcode | rs(sourceReg2) | rs(sourceReg1) | imm(offset) |
    |----------|----------|----------| ----------|
    | 6 bits(31:26) | 5 bits (25:21) | 5 bits (20:16) | 16 bits (15:0) |

### **R-type**
- `mul destinationReg, sourceReg1, sourceReg2`  
  - Opcode: `000000`, shamt: `00000`, funct: `011000`
  - | opcode | rs(sourceReg) | rt(destinationReg) | imm(offset) | shamt | funct |
    |----------|----------|----------| ----------| ----------| ----------|
    | 6 bits(31:26) | 5 bits (25:21) | 5 bits (20:16) | 5 bits (15:11) | 5 bits (10:6) | 5 bits (5:0) |

### **Shift**
- `srl destinationReg, sourceReg, offset`  
  - Opcode: `000001`, funct: `000010`
  - | opcode | rs(sourceReg) | rt(destinationReg) | imm(offset) |
    |----------|----------|----------| ----------|
    | 6 bits(31:26) | 5 bits (25:21) | 5 bits (20:16) | 16 bits (15:0) |

### **Jump**
- `j address` – Opcode: `000010`
  - | opcode | address |
    |----------|----------|
    | 6 bits(31:26) | 26 bits (25:0) |
  -  Jump instruction is unconditional and therefore the branch is always taken, thus the branch can be resolved immediately to fetch the correct instruction instead of waiting till the execution stage for resolution as in the case of beq.  

---

## Preloaded Instructions

The following program is loaded into instruction memory at reset:

```assembly
lw r1, 0(r0)
lw r2, 1(r0)
mul r1, r1, r2
j L
mul r2, r1, r2
L:
srl r6, r1, 3
sw r6, 4(r0)
