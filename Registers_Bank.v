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
    
    reg [31:0] write_array;
    reg [31:0] q_array [31:0];
    
    reg i;
    initial
        begin
            for(i=0; i<32; i = i+1)
                write_array[i] = 0;
        end

    Register rbank[31:0] (clk, data, write_array, q_array);

    //reg [31:0] a;
    //reg [31:0] b;

    always @(addr_a, addr_b)
        begin
            a <= q_array[addr_a];
            b <= q_array[addr_b];
        end
   
endmodule
