`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/19/2018 04:10:22 AM
// Design Name: 
// Module Name: MULT_RESULT
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


module MULT_RESULT(
    input [31:0] x, 
    input [31:0] y, 
    output [31:0] w
    );
    
    assign w = x*y;
endmodule
