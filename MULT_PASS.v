`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/19/2018 04:07:24 AM
// Design Name: 
// Module Name: MULT_PASS
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


module MULT_PASS(
    input [31:0] w_out_M1_OUT, 
    output [31:0] w_out_M2_IN
    );
    
    assign w_out_M2_IN = w_out_M1_OUT;
endmodule
