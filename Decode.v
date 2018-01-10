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
    input [31:0] ir,
    input [4:0] addr_d_in,
    input [31:0] d_in,
    input write,
    
    output [13:0] op,
    output [31:0] a_out,
    output [31:0] b_out,
    output [4:0] addr_d_out,
    output read_mmu,
    output write_mmu, 
    output byte_select_mmu
    );
    
    Decoder dec(clk, ir, op, y_sel, write, addr_a, addr_b, addr_d, immed, read_mmu, write_mmu, byte_select_mmu);
    Registers_Bank registers(clk, reset, addr_a, addr_b, addr_d, d_sign, write, a_out, b_out);

endmodule
