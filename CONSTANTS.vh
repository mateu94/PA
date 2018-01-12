//OPCODE for each instruction type (ir[6:0]
`define R 7'h33
`define I1 7'h03
`define I2 7'h13
`define S 7'h23
`define B 7'h63
`define J 7'h6F

//OPCODE for each instruction (OPCODE + funct3/funct7)
`define ADD 14'h1980
`define ADDI 14'h98
`define SUB 14'h19A0
`define MUL 14'h1981
`define LDB 14'h18
`define LDW 14'h1A
`define STB 14'h118
`define STW 14'h11A
`define MOV 14'h13  //REVISE
`define BEQ 14'h318
`define JUMP 14'h6F
`define TLBWRITE 14'hXX //REVISE
`define IRET 14'hXX //REVISE
`define X32 32'hXXXXXXXX    //REVISE