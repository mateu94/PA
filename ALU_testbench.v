`timescale 1ns / 1ps
`include "CONSTANTS.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.11.2017 11:44:29
// Design Name: 
// Module Name: ALU_testbench
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


module ALU_testbench(
    /*
    input clk,
    input [6:0] op,
    input [31:0] x,
    input [31:0] y,
    output [31:0] w
    */
    );
    reg clk;
    reg [6:0] op;
    reg [31:0] x;
    reg [31:0] y;
    wire [31:0] w;
    ALU test(clk, op, x, y, w);
        
    initial
        clk=1'b0;
        always #10 clk = ~clk;
    initial
    #20
    begin
        op = `ADD;
        x = 32'h00000001;
        y = 32'h00000002;
    end
endmodule
