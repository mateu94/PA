`timescale 1ns / 1ps
`include "CONSTANTS.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/19/2017 09:01:09 PM
// Design Name: 
// Module Name: DataPath
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


module DataPath(
    input clk,
    input [6:0] op,
    input [4:0] addr_a,
    input [4:0] addr_b,
    input [4:0] addr_d,
    input [31:0] immed,
    input y_sel,
    input write,
    
    output [31:0] a_out,
    output [31:0] b_out,
    output [31:0] w_out
    );
    
    reg [31:0]a_sign;   //output of reg a
    reg [31:0]b_sign;   //output of reg b
    reg [31:0]w_sign;   //output of alu
    reg [31:0]d_sign;   //data to store in the regs (usually w_sign)
    
    reg [31:0]y_sign;

    Registers_Bank registers(clk, addr_a, addr_b, addr_d, d_sign, write, a_sign, b_sign);
    ALU alu(op, a_sign, y_sign, w_sign);
    
    case (y_sel)
        1'b0: y_sign = immed;
        1'b1: y_sign = b_sign;
        default: y_sign = `X32;
    endcase
    
    assign a_out = a_sign;
    assign b_out = b_sign;
    assign w_out = w_sign;
endmodule
