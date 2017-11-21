`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2017 03:35:36 PM
// Design Name: 
// Module Name: Proc
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


module Proc(
    input clk,
    input boot,
    input ir,
    
    output [31:0] a_out,
    output [31:0] b_out,
    output [31:0] w_out
    );
    
    reg [6:0]op;
    reg y_sel;
    reg write;
    reg [4:0] addr_a;
    reg [4:0] addr_b;
    reg [4:0] addr_d;
    reg [31:0] offset;
    reg [9:0] offsetLo;
    reg [0:4] offsetHi;
    
    reg [31:0] a_out;
    reg [31:0] b_out;
    reg [31:0] w_out;
    
    Decoder dec(clk, ir, op, y_sel, write, addr_a, addr_b, addr_d, offset, offsetLo, offsetHi);
    DataPath datp(clk, op, addr_a, addr_b, addr_d, offset, y_sel, write, a_out, b_out, w_out);

endmodule
