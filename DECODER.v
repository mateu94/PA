`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2017 10:55:24
// Design Name: 
// Module Name: DECODER
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


module DECODER(
    input clk,
    input [31:0] ir,
    output [6:0] op,
    output [4:0] addr_a,
    output addr_b,
    output addr_d
    );
    
    assign op = ir[31:25];
    assign addr_a = ir[19:15];
    assign addr_b = ir[14:10];
    assign addr_d = ir[24:20];
    assign offset = ir[14:0];
    assign offsetLo = ir[9:0];
    
endmodule
