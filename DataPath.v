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
    input op,
    input [4:0] addr_a,
    input [4:0] addr_b,
    input [4:0] addr_d,
    input [31:0] immed,
    input y_sel,
    input [31:0] data,
    input write
    );
    
    reg [31:0]a_sign;
    reg [31:0]b_sign;
    reg [31:0]w_sign;
    
    reg [31:0]x_sign;
    reg [31:0]y_sign;

    Registers_Bank registers(clk, addr_a, addr_b, addr_d, data, write, a_sign, b_sign);
    ALU alu(op, x_sign, y_sign, w_sign);
    
    case (y_sel)
        1'b0: y_sign = immed;
        1'b1: y_sign = b_sign;
        default: y_sign = `X32;
    endcase
    
endmodule
