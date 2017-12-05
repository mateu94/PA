`timescale 1ns / 1ps
`include "CONSTANTS.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.11.2017 11:57:35
// Design Name: 
// Module Name: Decoder
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

module Decoder(
    input clk,
    input [31:0] ir,
    
    output [13:0] op,
    output y_sel,           //Selector for reading src2 or offset
    output write,           //write enabled
    output [4:0] addr_a,
    output [4:0] addr_b,
    output [4:0] addr_d,
    output [31:0] immed
    );
    
    reg [31:0] immed_sign;
    reg [13:0] op_output_sign;
    
    wire [13:0] op_funct3_sign;
    wire [13:0] op_funct7_sign;
    
    assign addr_a = ir[19:15];
    assign addr_b = ir[24:20];
    assign addr_d = ir[11:7];
    assign op_funct3_sign = {ir[6:0], ir[14:12]};
    assign op_funct7_sign = {ir[6:0], ir[31:25]};   
    
    always @(ir) begin
        case (ir[6:0])
            `R: begin
                    op_output_sign = op_funct7_sign;
                end
            `I1, `I2: begin
                    op_output_sign = op_funct3_sign;
                    immed_sign = $signed(ir[31:20]);
                end
            `S: begin
                immed_sign = $signed({ir[31:25], addr_d});
                op_output_sign = op_funct3_sign;
                end
            `B: begin
                immed_sign = $signed({ir[31], ir[7], ir[30:25], addr_d, 1'b0});
                op_output_sign = op_funct3_sign;
                end
            `J: begin
                immed_sign = $signed({ir[31], ir[19:12], ir[20:20], ir[30:21]});
                op_output_sign = op_funct3_sign;
                end
            default: begin
                immed_sign = `X32;
                op_output_sign = `X32;
                end
        endcase
    end
    
    assign immed = immed_sign;
    assign op = op_output_sign;
    assign y_sel = (ir[6:0] == `LDB || ir[6:0] == `LDW || ir[6:0] == `ADDI || ir[6:0] == `JUMP) ? 0 : 1;

endmodule

