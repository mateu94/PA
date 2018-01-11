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
    
    /*CONTROL[4:0]:
    CONTROL[0] -> Read From Cache
    CONTROL[1] -> Write To Cache
    CONTROL[2] -> Byte Selector (Cache)
    CONTROL[3] -> Write enable on register
    CONTROL[4] -> Branch instruction or not
    CONTROL[5] -> Load instruction or not
    */ 
    
    //Connections in the processor
    wire write_enable;
    wire take_branch;
    
    //Connections between DECODER and EX stages    
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
    wire [5:0] control_ID_EX_OUT;
    
    //Connections between EX and MEM stages
        //INPUTS
    wire [31:0] w_out_EX_M_IN;
    wire [31:0] w_pc_EX_M_IN;
    wire [31:0] w_zero_EX_M_IN;
    wire [31:0] rgS2_data_ID_EX_OUT;
    wire [5:0] control_ID_EX_OUT;
    wire [4:0] rgD_index_ID_EX_OUT;
    
        //OUTPUTS
    wire [31:0] w_out_EX_M_OUT;
    wire [31:0] w_pc_EX_M_OUT;
    wire [31:0] w_zero_EX_M_OUT;
    wire [31:0] rgS2_data_EX_M_OUT;
    wire [5:0] control_EX_M_OUT;
    wire [4:0] rgD_index_EX_M_OUT;
    
    //Connection between M and WB stages
        //INPUTS
        
        //OUTPUTS
    wire [31:0] mem_data_out;
    wire [31:0] w_out_M_WB_OUT;
    wire [5:0] control_M_WB_OUT;
    wire [4:0] addr_d_out_M_WB_OUT;
    
    //Memory();
    
        
    Decode dec(clk, ir, rgD_index_in, rgD_data_in, write_in, op_ID_EX_IN, rgS1_data_ID_EX_IN, rgS2_data_ID_EX_IN, immed_ID_EX_IN, y_sel_ID_EX_IN, rgD_index_out_ID_EX_IN, write_out_ID_EX_IN, read_mmu_ID_EX_IN, write_mmu_ID_EX_IN, byte_select_mmu_ID_EX_IN);
    
    Reg_ID_EX ID_EX(clk, reset, write_enable, next_pc_IF_ID_OUT, read_mmu_ID_EX_IN, write_mmu_ID_EX_IN, byte_select_mmu_ID_EX_IN, write_out_ID_EX_IN, op_ID_EX_IN, rgS1_data_ID_EX_IN, rgS2_data_ID_EX_IN, immed_ID_EX_IN, y_sel_ID_EX_IN, rgD_index_out_ID_EX_IN,
                    next_pc_ID_EX_OUT, op_ID_EX_OUT, rgS1_data_ID_EX_OUT, rgS2_data_ID_EX_OUT, immed_ID_EX_OUT, y_sel_ID_EX_OUT, control_ID_EX_OUT, rgD_index_ID_EX_OUT);

    ALU alu(op_ID_EX_OUT, rgS1_data_ID_EX_OUT, rgS2_data_ID_EX_OUT, next_pc_ID_EX_OUT, w_out_EX_M_IN, w_pc_EX_M_IN, w_zero_EX_M_IN);
    
    Reg_EX_M EX_M(clk, reset, write_enable, w_out_EX_M_IN, w_pc_EX_M_IN, w_zero_EX_M_IN, rgS2_data_ID_EX_OUT, control_ID_EX_OUT, rgD_index_ID_EX_OUT,
                 w_out_EX_M_OUT, w_pc_EX_M_OUT, w_zero_EX_M_OUT, rgS2_data_EX_M_OUT, control_EX_M_OUT, rgD_index_ID_EX_OUT);
    
    //take_branch = (if_branch && zero)
    
    Cache Data_Cache(clk, reset, control_EX_M_OUT[0], control_EX_M_OUT[1], control_EX_M_OUT[2], rgS2_data_EX_M_OUT, w_out_EX_M_OUT, stall_pc, ready_mem, Data_Mem, Addr_Mem, read_Mem, write_Mem );    
    
    Reg_M_WB M_WB(clk, reset, write_enable, w_out_EX_M_OUT, Data_CPU, control_EX_M_OUT, rgD_index_ID_EX_OUT,
                  mem_data_out, w_out_M_WB_OUT, control_M_WB_OUT, addr_d_out_M_WB_OUT);
    
    //if (control_M_WB_OUT[5] == 1) rgD_data_in = mem_data_out; else rgD_data_in = w_out_M_WB_OUT
    //write_in = control_M_WB_OUT[3]
    
    write_enable = !stall_pc;
    
endmodule
