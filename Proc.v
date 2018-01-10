`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2017 03:35:36 PM
// Design Name: 
// Module Name: Proc
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


module Proc(
    input clk,
    input reset,
    input [31:0] ir,
    input stall_pc,
    
    output [31:0] addr_mmu,
    output read_mmu,
    output write_mmu,
    output byte_select_mmu,
    inout [31:0] data_mmu
    );
    
    wire [13:0]op;
    wire y_sel;
    wire write;
    wire [4:0] addr_a;
    wire [4:0] addr_b;
    wire [4:0] addr_d;
    wire [31:0] immed;
    wire [31:0] a_out;
    wire [31:0] b_out;
    
    //Memory();
    
        
    Decode dec(clk, ir, op, y_sel, write, addr_a, addr_b, addr_d, immed, read_mmu, write_mmu, byte_select_mmu);
    REGISTERS
    ALU alu(op, a_sign, y_sign, pc, w_sign, w_pc, zero);
    REGISTERS
    Cache Data_Cache (clk, reset, read_CPU, write_CPU, Bytesel, Data_CPU, Addr_CPU, Stall_PC, ready_mem, Data_Mem, Addr_Mem, read_Mem, write_Mem );
    REGISTERS
    SELECT_DATA_TO_REGS
    
endmodule
