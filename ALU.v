`timescale 1ns / 1ps
`include "CONSTANTS.vh"
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
    input [13:0] op,
    input [31:0] x,
    input [31:0] y,
    output [31:0] w
);

    reg [31:0] w_out;
           
    always @(*) begin
        case (op)
            `ADD : w_out <= x + y;
            //`ADDI : w_out <= x + y;
            `SUB : w_out <= x - y;
            `MUL : w_out <= x * y;
            `LDB : w_out <= x + y;
            `LDW : w_out <= x + y;
            `STB : w_out <= x + y;
            `STW : w_out <= x + y;
            `MOV : ;
            `BEQ : ;
            `JUMP : ;
            `TLBWRITE : ;
            `IRET : ;
            default: w_out <= `X32;
        endcase
    end
       
   assign w = w_out;
endmodule
