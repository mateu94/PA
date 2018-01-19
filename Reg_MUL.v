`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/19/2018 04:12:01 AM
// Design Name: 
// Module Name: Reg_MUL
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


module Reg_MUL(
    input clk, 
    input reset, 
    input write, 
    input [31:0] w_in, 
    input control_in,
    input [31:0] rgD_index_in,
    
    output [31:0] w_out, 
    output control_out,
    output [31:0] rgD_index_out
    );
   
    generate
           genvar i;              
               FlipFlop r(clk, reset, control_in, write, control_out);
           
           for(i=0; i<32; i = i+1) begin
               FlipFlop r(clk, reset, w_in[i], write, w_out[i]);
           end
           
            for(i=0; i<32; i = i+1) begin
                FlipFlop r(clk, reset, rgD_index_in[i], write, rgD_index_out[i]);
            end
            
    endgenerate
               
endmodule
