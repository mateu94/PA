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
    input signed [31:0] immed_sl2,
    input signed [31:0] pc,
    output [31:0] w,
    output signed [31:0] w_pc,
    output take_branch
);

    reg [31:0] w_sign;
    reg signed [31:0] w_pc_sign;
    reg take_branch_sign;
           
    always @(*) begin
        w_pc_sign = pc + immed_sl2;
        take_branch_sign = 1'b0;
        case (op)
            `ADD : w_sign = x + y;
            `ADDI : w_sign = x + y;
            `SUB : w_sign = x - y;
            `MUL : w_sign = x * y;
            `LDB : w_sign = x + y;
            `LDW : w_sign = x + y;
            `STB : w_sign = x + y;
            `STW : w_sign = x + y;
            `MOV : ;
            `BEQ : take_branch_sign = (x == y);
            `BNE : take_branch_sign = (x != y);
            `JUMP : ;
            `TLBWRITE : ;
            `IRET : ;
            default: w_sign = `X32;
        endcase
    end
       
    assign w = w_sign;
    assign w_pc = w_pc_sign;
    assign take_branch = take_branch_sign;

endmodule
