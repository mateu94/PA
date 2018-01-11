`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/21/2017 03:35:36 PM
// Design Name: 
// Module Name: Proc
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


module Proc(
    input clk,
    input reset,
    input [31:0] ir,
    input stall_pc,
    
    output [31:0] addr_mmu,
    output read_mmu,
    output write_mmu,
    output byte_select_mmu,
    inout [31:0] data_mmu
    );
    
    //Connections between DECODER and EX stages
    wire write_enable_ID_EX;    //Enable writes on ID/EX reg
    
        //INPUTS
    wire [31:0] next_pc_IF_ID_OUT
    wire read_mmu_ID_EX_IN;
    wire write_mmu_ID_EX_IN;
    wire byte_select_mmu_ID_EX_IN;
    wire [13:0] op_ID_EX_IN;
    wire write_out_ID_EX_IN;
    wire [31:0] rgS1_data_ID_EX_IN;
    wire [31:0] rgS2_data_ID_EX_IN;
    wire [31:0] immed_ID_EX_IN;
    wire y_sel_ID_EX_IN;
    wire [4:0] rgD_index_out_ID_EX_IN;
    
        //OUTPUTS
    wire [31:0] next_pc_ID_EX_OUT;
    wire [13:0] op_ID_EX_OUT;
    wire [31:0] rgS1_data_ID_EX_OUT;
    wire [31:0] rgS2_data_ID_EX_OUT;
    wire [31:0] immed_ID_EX_OUT;
    wire y_sel_ID_EX_OUT;
    wire [4:0] rgD_index_out_ID_EX_OUT;
    wire [3:0] control_ID_EX_OUT;
    
    //Connections between EX and MEM stages
    wire write_enable_EX_M;    //Enable writes on EX/M reg

        //INPUTS
    wire [31:0] w_out_EX_M_IN;
    wire [31:0] w_pc_EX_M_IN;
    wire [31:0] w_zero_EX_M_IN;
    wire [31:0] rgS2_data_ID_EX_OUT;
    wire [3:0] control_ID_EX_OUT;
    wire [4:0] rgD_index_ID_EX_OUT;
    
        //OUTPUTS
    wire [31:0] w_out_EX_M_OUT;
    wire [31:0] w_pc_EX_M_OUT;
    wire [31:0] w_zero_EX_M_OUT;
    wire [31:0] rgS2_data_EX_M_OUT;
    wire [3:0] control_EX_M_OUT;
    wire [4:0] rgD_index_EX_M_OUT;
    
    //Connection between M and WB stages

    
    //Memory();
    
        
    Decode dec(clk, ir, rgD_index_in, rgD_data_in, write_in, op_ID_EX_IN, rgS1_data_ID_EX_IN, rgS2_data_ID_EX_IN, immed_ID_EX_IN, y_sel_ID_EX_IN, rgD_index_out_ID_EX_IN, write_out_ID_EX_IN, read_mmu_ID_EX_IN, write_mmu_ID_EX_IN, byte_select_mmu_ID_EX_IN);
    
    Reg_ID_EX ID_EX(clk, reset, write_enable_ID_EX, next_pc_IF_ID_OUT, read_mmu_ID_EX_IN, write_mmu_ID_EX_IN, byte_select_mmu_ID_EX_IN, write_out_ID_EX_IN, op_ID_EX_IN, rgS1_data_ID_EX_IN, rgS2_data_ID_EX_IN, immed_ID_EX_IN, y_sel_ID_EX_IN, rgD_index_out_ID_EX_IN,
                    next_pc_ID_EX_OUT, op_ID_EX_OUT, rgS1_data_ID_EX_OUT, rgS2_data_ID_EX_OUT, immed_ID_EX_OUT, y_sel_ID_EX_OUT, control_ID_EX_OUT, rgD_index_ID_EX_OUT);

    ALU alu(op_ID_EX_OUT, rgS1_data_ID_EX_OUT, rgS2_data_ID_EX_OUT, next_pc_ID_EX_OUT, w_out_EX_M_IN, w_pc_EX_M_IN, w_zero_EX_M_IN);
    
    RegEX_M EX_M(clk, reset, write_enable_EX_M, w_out_EX_M_IN, w_pc_EX_M_IN, w_zero_EX_M_IN, rgS2_data_ID_EX_OUT, control_ID_EX_OUT, rgD_index_ID_EX_OUT,
                 w_out_EX_M_OUT, w_pc_EX_M_OUT, w_zero_EX_M_OUT, rgS2_data_EX_M_OUT, control_EX_M_OUT, rgD_index_ID_EX_OUT);
    
    Cache Data_Cache (clk, reset, read_mmu_EX_M_OUT, write_mmu_EX_M_OUT, byte_select_mmu_EX_M_OUT, DATA_CPU, b_out_EX_M_OUT, Stall_PC, ready_mem, Data_Mem, Addr_Mem, read_Mem, write_Mem );
    
    Reg_M_WB M_WB(clk, reset, w_out_EX_M_OUT, mem_data_in, w_out_EX_M_OUT, addr_d_out_EX_M_OUT,
                  mem_data_out, w_out_M_WB_OUT, addr_d_out_M_WB_OUT);
    
    //SELECT_DATA_TO_REGS
    
endmodule
