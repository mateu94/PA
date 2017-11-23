`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2017 11:57:35
// Design Name: 
// Module Name: Decoder
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

module Decoder(
    input clk,
    input [31:0] ir,
    
    output [6:0] op,
    output y_sel,           //Selector for reading src2 or offset
    output write,           //write enabled
    output [4:0] addr_a,
    output [4:0] addr_b,
    output [4:0] addr_d,
    output [31:0] offset,
    output [9:0] offsetLo,
    output [0:4] offsetHi
    );
        
    assign op = ir[31:25];
    assign addr_a = ir[19:15];
    assign addr_b = ir[14:10];
    assign addr_d = ir[24:20];
    assign offset = $signed(ir[14:0]);
    assign offsetLo = ir[9:0];
    assign offsetHi = ir[24:20];
    assign y_sel = (ir[31:25] == 7'h10 || ir[31:25] == 7'h11 || ir[31:25] == 7'h12 || ir[31:25] == 7'h13) ? 0 : 1;

endmodule

