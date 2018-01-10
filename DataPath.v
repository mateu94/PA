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
    input reset,
    input [13:0] op,
    input [4:0] addr_a,
    input [4:0] addr_b,
    input [4:0] addr_d,
    input [31:0] immed,
    input y_sel,
    input write,
    
    output [31:0] a_out,
    output [31:0] b_out,
    output [31:0] addr_m
    );
    
    wire [31:0] a_sign;   //output of reg a
    wire [31:0] b_sign;   //output of reg b
    wire [31:0] w_sign;   //output of alu
    reg [31:0] d_sign;   //data to store in the regs (usually w_sign)
    reg [31:0] y_sign;

    Registers_Bank registers(clk, reset, addr_a, addr_b, addr_d, d_sign, write, a_sign, b_sign);
    ALU alu(op, a_sign, y_sign, w_sign, zero);
    
    always @(y_sel, b_sign, immed) begin
        case (y_sel)
            1'b0: y_sign = immed;
            1'b1: y_sign = b_sign;
            default: y_sign = `X32;
        endcase
    end
    
    always @(w_sign) begin
        d_sign = w_sign;
    end
    
    assign a_out = a_sign;
    assign b_out = b_sign;
    assign addr_m = w_sign;
    
endmodule
