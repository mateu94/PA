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
    reg [31:0] ir;
    wire [31:0] a_out;
    wire [31:0] b_out;
    wire [31:0] w_out;
    Proc test(clk, reset, ir, a_out, b_out, w_out);
    
    always #1 clk = ~clk;
        
    initial 
    begin
        clk = 1'b1;
        reset = 1'b1;
        #2
        
        //ADDI REG0, 5 -> REG1
        reset = 1'b0;
        ir = 32'b000000000101_00000_000_00001_0010011;
        #2
        
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
        
        $finish;
    end

endmodule
