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
    input reset,
    input [31:0] ir,
    
    output [31:0] a_out,
    output [31:0] b_out,
    output [31:0] w_out
    );
    
    wire [13:0]op;
    wire y_sel;
    wire write;
    wire [4:0] addr_a;
    wire [4:0] addr_b;
    wire [4:0] addr_d;
    wire [31:0] immed;
        
    Decoder dec(clk, ir, op, y_sel, write, addr_a, addr_b, addr_d, immed);
    DataPath datp(clk, reset, op, addr_a, addr_b, addr_d, immed, y_sel, write, a_out, b_out, w_out);

endmodule
