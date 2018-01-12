//OPCODE for each instruction type (ir[6:0]
`define R 7'h33
`define I1 7'h03
`define I2 7'h13
`define S 7'h23
`define B 7'h63
`define J 7'h6F

//OPCODE for each instruction (OPCODE + funct3/funct7)
`define ADD 7'h33
`define ADDI 7'h13
`define SUB 7'h33
`define MUL 7'h33
`define LDB 7'h03
`define LDW 7'h03
`define STB 7'h23
`define STW 7'h23
`define MOV 7'h13
`define BEQ 7'h63
`define JUMP 7'h6F
`define TLBWRITE 7'hXX
`define IRET 7'hXX
`define X32 32'hXXXXXXXX