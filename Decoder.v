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
    output [4:0] addr_a,
    output [4:0] addr_b,
    output [4:0] addr_d,
    output [31:0] immed,
    
    output read_mmu,
    output write_mmu,
    output byte_select_mmu,
    output write,           //write enabled
    output branch_instr,    //Indicate branch instruction or not
    output load_instr       //Indicate load instruction or not
    );
        
    reg [4:0] addr_a_sign;
    reg [4:0] addr_b_sign;
    reg [4:0] addr_d_sign;
    reg [31:0] immed_sign;
    reg [13:0] op_output_sign;
    reg y_sel_sign;
    reg read_mmu_sign;
    reg write_mmu_sign;
    reg byte_select_mmu_sign;
    reg write_sign;
    reg branch_instr_sign;
    reg load_instr_sign;
    
    wire [6:0] op_code;
    wire [13:0] op_funct3_sign;
    wire [13:0] op_funct7_sign;
    
    assign op_code = ir[6:0];
    assign op_funct3_sign = {ir[6:0], ir[14:12]};
    assign op_funct7_sign = {ir[6:0], ir[31:25]};   
    
    always @(ir) begin
        addr_a_sign = ir[19:15];
        addr_b_sign = ir[24:20];
        addr_d_sign = ir[11:7];
        case (op_code)
            `R: begin   //ADD, SUB, MUL
                    op_output_sign = op_funct7_sign;
                    y_sel_sign = 1'b1;
                    write_sign = 1'b1;
                    read_mmu_sign = 1'b0;
                    write_mmu_sign = 1'b0;
                    load_instr_sign = 1'b0;
                    branch_instr_sign = 1'b0;
                end
            `I1: begin  //LDB, LDW
                    op_output_sign = op_funct3_sign;
                    immed_sign = $signed(ir[31:20]);
                    y_sel_sign = 1'b0;
                    write_sign = 1'b1;
                    read_mmu_sign = 1'b1;
                    write_mmu_sign = 1'b0;
                    byte_select_mmu_sign = (op_funct3_sign == `LDB) ? 1 : 0;
                    branch_instr_sign = 1'b0;
                    load_instr_sign = 1'b1;
                end
            `I2: begin  //ADDI
                    op_output_sign = op_funct3_sign;
                    immed_sign = $signed(ir[31:20]);
                    y_sel_sign = 1'b0;
                    write_sign = 1'b1;
                    read_mmu_sign = 1'b0;
                    write_mmu_sign = 1'b0;
                    branch_instr_sign = 1'b0;
                    load_instr_sign = 1'b0;
                end
            `S: begin   //STB, STW
                    immed_sign = $signed({ir[31:25], addr_d_sign});
                    op_output_sign = op_funct3_sign;
                    write_sign = 1'b0;
                    y_sel_sign = 1'b0;
                    read_mmu_sign = 1'b0;
                    write_mmu_sign = 1'b1;
                    byte_select_mmu_sign = (op_funct3_sign == `STB) ? 1 : 0;
                    branch_instr_sign = 1'b0;
                    load_instr_sign = 1'b0;
                end
            `B: begin   //BEW
                    immed_sign = $signed({ir[31], ir[7], ir[30:25], addr_d, 1'b0});
                    op_output_sign = op_funct3_sign;
                    write_sign = 1'b0;
                    y_sel_sign = 1'b1;
                    read_mmu_sign = 1'b0;
                    write_mmu_sign = 1'b0;
                    branch_instr_sign = 1'b1;
                    load_instr_sign = 1'b0;
                end
            `J: begin   //JUMP
                    //Not sure right now how to decode this instruction
                    immed_sign = $signed({ir[31], ir[19:12], ir[20:20], ir[30:21], 1'b0});
                    op_output_sign = op_code;
                    y_sel_sign = 0;
                    write_sign = 1'b1;
                    y_sel_sign = 1'b0;
                    read_mmu_sign = 1'b0;
                    write_mmu_sign = 1'b0;
                    branch_instr_sign = 1'b0;
                    load_instr_sign = 1'b0;
                    //jump_instr_sign = 1'b1;
                end
            default: begin
                    immed_sign = `X32;
                    op_output_sign = `X32;
                    y_sel_sign = 1'bX;
                    read_mmu_sign = 1'b0;
                    write_mmu_sign = 1'b0;
                    byte_select_mmu_sign = 1'b0;
                    write_sign = 1'b0;
                    branch_instr_sign = 1'b0;
                    load_instr_sign = 1'b0;
                end
        endcase
    end
    
    assign addr_a = addr_a_sign;
    assign addr_b = addr_b_sign;
    assign addr_d = addr_d_sign;
    assign immed = immed_sign;
    assign op = op_output_sign;
    assign y_sel = y_sel_sign;
    
    assign read_mmu = read_mmu_sign;
    assign write_mmu = write_mmu_sign;
    assign byte_select_mmu = byte_select_mmu_sign;
    assign write = write_sign;
    assign branch_instr = branch_instr_sign;
    assign load_instr = load_instr_sign;

endmodule

