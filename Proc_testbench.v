`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2017 04:07:34 PM
// Design Name: 
// Module Name: Proc_testbench
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


module Proc_testbench();   
    reg clk;
    reg reset;
    reg [31:0] ir;
    wire [31:0] a_out;
    wire [31:0] b_out;
    wire [31:0] w_out;
    Proc test(clk, reset, ir, a_out, b_out, w_out);
    
    always #1 clk = ~clk;
        
    initial 
    begin
        clk = 1'b1;
        reset = 1'b1;
        #2
        
        //ADDI REG0, 5 -> REG0
        reset = 1'b0;
        ir = 32'b000000000101_00000_000_00000_0010011;
        #2 
        $finish;
    end

endmodule
