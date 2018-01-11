`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/10/2018 07:05:47 PM
// Design Name: 
// Module Name: Decode
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Decode(
    input clk,
    input reset,
    input [31:0] ir,        //Instruction code
    input [4:0] addr_d_in,  //REG addr where to be written from a previous instruction
    input [31:0] d_in,      //DATA to be written on a REG from a previous instruction
    input write_in,         //Indicate if previous instruction has to write on a REG
    
    output [13:0] op,       //ALU operation
    output [31:0] a_out,    //Value REG SRC1
    output [31:0] b_out,    //Value REG SRC2
    output [31:0] immed,    //Value immediate
    output y_sel,           //Selector for reading src2 or offset
    output [4:0] addr_d_out,//REG addr that will be written
    output write_out,       //Indicate if the instruction writes on a REG
    output read_mmu,        //Indicate if the instruction reads from CACHE/MEM
    output write_mmu,       //Indicate if the instruction writes to CACHE/MEM
    output byte_select_mmu  ////Indicate if the read/write from/to CACHE/MEM is byte/word
    );
    
    wire addr_a;
    wire addr_b;
        
    Decoder dec(clk, ir, op, y_sel, write_out, addr_a, addr_b, addr_d_out, immed, read_mmu, write_mmu, byte_select_mmu);
    Registers_Bank registers(clk, reset, addr_a, addr_b, addr_d_in, d_in, write_in, a_out, b_out);

endmodule
