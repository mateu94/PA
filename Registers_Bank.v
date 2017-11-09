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
    input addr_b,
    input addr_d,
    input data,
    input write,
    output a,
    output b
);

    Register rb[4:0] (clk, data, write, q);

    integer addr_a_int;
    
    always @(addr_a)
        addr_a_int = addr_a;

    assign a = rb[addr_a_int];
   
endmodule
