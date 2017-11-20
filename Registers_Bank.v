`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2017 22:36:23
// Design Name: 
// Module Name: Registers_Bank
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


module Registers_Bank(
    input clk,
    input [4:0] addr_a,
    input [4:0] addr_b,
    input [4:0] addr_d,
    input [31:0] data,
    input write,
    output [31:0] a,
    output [31:0] b
);

    Register rb[31:0] (clk, data, write, q);

    reg [31:0] a;
    reg [31:0] b;

    always @(addr_a, addr_b)
        begin
            a <= rb[addr_a];
            b <= rb[addr_b];
        end
   
endmodule
