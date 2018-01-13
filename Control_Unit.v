`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2018 06:40:49 PM
// Design Name: 
// Module Name: Control_Unit
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


module Control_Unit(
    input clk, 
    input reset, 
    input [4:0] rgS1_index_ID_EX_IN, 
    input rgS2_index_ID_EX_IN, 
    input rgD_index_ID_EX_IN, 
    input stall_pc,
    
    output write_enable_IF_ID, 
    output write_enable_ID_EX, 
    output write_enable_EX_M, 
    output write_enable_M_WB
    );
endmodule
