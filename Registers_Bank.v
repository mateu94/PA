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
    input data,
    input write,
    output q
);

Register r[31:0] (clk, data, write, q);
   
endmodule
