`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/10/2018 05:02:47 PM
// Design Name: 
// Module Name: RISCV
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


module RISCV(
    input clk,
    input reset,
    
    input ir //Now it is done by the user
    );
    
    wire stall_pc;
    wire [31:0] addr_mmu;
    wire read_mmu;
    wire write_mmu;
    wire byte_select_mmu;
    wire [31:0] data_mmu;
    
    Proc processor(clk, reset, ir, stall_pc, addr_mmu, read_mmu, write_mmu, byte_select_mmu, data_mmu);
    Cache_Mem test( clk, reset, read_mmu, write_mmu, byte_select_mmu, data_mmu, addr_mmu, stall_pc);

endmodule
