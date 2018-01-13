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
    output [5:0] addr_a,    //REG addr of src1
    output [5:0] addr_b,    //REG addr of src2
    output [4:0] addr_d_out,//REG addr that will be written
    
    output read_mmu,        //Indicate if the instruction reads from CACHE/MEM
    output write_mmu,       //Indicate if the instruction writes to CACHE/MEM
    output byte_select_mmu,  //Indicate if the read/write from/to CACHE/MEM is byte/word
    output write_out,       //Indicate if the instruction writes on a REG
    output branch_instr,    //Indicate branch instruction or not
    output load_instr    //Indicate load instruction or not
    ); 
        
    wire [4:0] addr_a_sign;
    wire [4:0] addr_b_sign;
        
    Decoder dec(clk, ir, op, y_sel, addr_a_sign, addr_b_sign, addr_d_out, immed, read_mmu, write_mmu, byte_select_mmu, write_out, branch_instr, load_instr);
    Registers_Bank registers(clk, reset, addr_a_sign, addr_b_sign, addr_d_in, d_in, write_in, a_out, b_out);
    
    assign addr_a = addr_a_sign;
    assign addr_b = addr_b_sign;

endmodule
