
`timescale 1ns / 1ps
`include "CONSTANTS.v"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.11.2017 16:42:11
// Design Name: 
// Module Name: ALU
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

module ALU(
//    input clk,
    input [6:0] op,
    input [31:0] x,
    input [31:0] y,
    output [31:0] w
);

reg [31:0] w_out;

       always @(*) begin    
        case (op)
            `ADD : assign w_out = x + y;
            `SUB : assign w_out = x - y;
            `MUL : assign w_out = x * y;
            `LDB : ;
            `LDW : ;
            `STB : ;
            `STW : ;
            `MOV : ;
            `BEQ : ;
            `JUMP : ;
            `TLBWRITE : ;
            `IRET : ;
            default: assign w_out = `ALU_X;
         
        endcase
       end
       
   assign w = w_out;
endmodule

