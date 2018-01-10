`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/10/2018 05:55:13 PM
// Design Name: 
// Module Name: RISCV_testbench
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


module RISCV_testbench();
    reg clk;
    reg reset;
    reg [31:0] ir;
    wire [31:0] a_out;
    wire [31:0] b_out;
    wire [31:0] w_out;
    RISCV test(clk, reset, ir);
    
    always #1 clk = ~clk;
        
    initial 
    begin
        clk = 1'b1;
        reset = 1'b1;
        #2
        
        $finish;
    end
endmodule
