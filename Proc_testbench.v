`timescale 1ns / 1ps
`include "CONSTANTS.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2017 04:07:34 PM
// Design Name: 
// Module Name: Proc_testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: This testbench doesn't write on regs bank, only to see if the decoding and output is correct
// 
//////////////////////////////////////////////////////////////////////////////////


module Proc_testbench();   
    reg clk;
    reg reset;
    //reg [31:0] ir;
    Proc test(clk, reset);
    
    reg [15:0] Memorytest [31:0];
    
    always #1 clk = ~clk;
    
    initial $readmemb("data.dat", Memorytest);
        
    initial 
    begin
        clk = 1'b0;
        reset = 1'b1;
        #4
        reset = 1'b0;
        #200
        
        /*
        //ADDI REG0, 2 -> REG1
        #30
        /*ir = 32'b000000000010_00000_000_00001_0010011;
        #2
                
        //STW REG1, 4(REG0)
        ir = 32'b0000000_00001_00000_010_00100_0100011;
        #2
        
        //LW 4(REG0), REG2
        ir = 32'b000000000100_00000_010_00010_0000011;
        #2
        
        //ADD REG1, REG2 -> REG3
        ir = 32'b0000000_00010_00001_000_00011_0110011;
        #2
        
        //ADDI REG0, 5 -> REG7
        reset = 1'b0;
        ir = 32'b000000000101_00000_000_00111_0010011;
        #10
        */        
        
        /*
        //SUB REG2, REG1 -> REG3
        ir = 32'b0100000_00010_00001_000_00011_0110011;
        #10
        */
        
        /*
        //ADDI REG0, 2 -> REG1
        reset = 1'b0;
        ir = 32'b000000000010_00000_000_00001_0010011;
        #2
        
        //ADDI REG0, 5 -> REG2
        reset = 1'b0;
        ir = 32'b000000000101_00000_000_00010_0010011;
        #2
        
        //SUB REG2, REG1 -> REG3
        ir = 32'b0100000_00010_00001_000_00011_0110011;
        #10
        
        
        //ADDI REG0, 3 -> REG2
        ir = 32'b000000000011_00000_000_00010_0010011;
        #10
        
        //ADDI REG0, 4 -> REG3
        ir = 32'b000000000100_00000_000_00011_0010011;
        #2
        
        //ADDI REG0, 5 -> REG4
        ir = 32'b000000000101_00000_000_00100_0010011;
        #10
        
        //ADD REG1, REG2 -> REG5
        ir = 32'b0000000_00010_00001_000_00101_0110011;
        #2
        
        //SUB REG4, REG3 -> REG6
        ir = 32'b0100000_00011_00100_000_00110_0110011;
        #22
        */
        
        /*
        //STW REG1, 4(REG0)
        ir = 32'b0000000_00001_00000_010_00100_0100011;
        #20
        
        //ADDI REG0, 5 -> REG1
        reset = 1'b0;
        ir = 32'b000000000101_00000_000_00011_0010011;
        #10
        
        //LW 4(REG0), REG2
        ir = 32'b000000000100_00000_010_00010_0000011;
        #10
        */
        
        /*
        //ADDI REG0, 2 -> REG2
        reset = 1'b0;
        ir = 32'b000000000010_00000_000_00010_0010011;
        #2
        
        //ADD REG1, REG2 -> REG1
        reset = 1'b0;
        ir = 32'b0000000_00010_00001_000_00001_0110011;
        #2
        
        //SUB REG1, REG2 -> REG1
        reset = 1'b0;
        ir = 32'b0100000_00010_00001_000_00001_0110011;
        #2
        
        //LDB REG0, 6(REG0)
        ir = 32'b000000000110_00000_000_00000_0000011;
        #2
        
        //LDW REG0, 8(REG0)
        ir = 32'b000000001000_00000_010_00000_0000011;
        #2
        
        //STB 10(REG0), REG0
        ir = 32'b0000000_00000_00000_000_01010_0100011;
        #2
        
        //STW 12(REG0), REG0
        ir = 32'b0000000_00000_00000_010_01100_0100011;
        #2
        
        //BEQ 12, REG0, REG1
        ir = 32'b0000000_00001_00000_000_11000_1100011;
        #2
        
        //JUMP 4000, REG1
        ir = 32'b0_1111010000_1_0000000_00000_1101111;
        #2
        */
        
        $finish;
    end

endmodule
