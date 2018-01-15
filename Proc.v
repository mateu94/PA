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
    input [31:0] ir
    /*
    input stall_pc,
    
    output [31:0] addr_mmu,
    output read_mmu,
    output write_mmu,
    output byte_select_mmu,
    inout [31:0] data_mmu
    */
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
    wire write_enable_IF_ID;
    wire write_enable_ID_EX;
    wire write_enable_EX_M;
    wire write_enable_M_WB;
    wire take_branch;

    wire stall_pc;
    
    wire read_mmu;
    wire write_mmu;
    wire byte_select_mmu;
    wire br_ins;
    wire ld_ins;
    
    //Connections between IF and ID stages    
            //INPUTS
    wire [31:0] next_pc_IF_ID_IN;
    wire [31:0] ir_IF_ID_IN;
            //OUTPUTS
    wire [31:0] next_pc_IF_ID_OUT;
    wire [31:0] ir_IF_ID_OUT;
    
    //Connections between DECODER and EX stages    
        //INPUTS
    wire read_mmu_ID_EX_IN;
    wire write_mmu_ID_EX_IN;
    wire byte_select_mmu_ID_EX_IN;
    wire br_ins_ID_EX_IN;
    wire ld_ins_ID_EX_IN;
    
    wire [13:0] op_ID_EX_IN;
    wire write_out_ID_EX_IN;
    wire [31:0] rgS1_data_ID_EX_IN;
    wire [31:0] rgS2_data_ID_EX_IN;
    wire [31:0] immed_ID_EX_IN;
    wire y_sel_ID_EX_IN;
    wire [4:0] rgS1_index_ID_EX_IN;
    wire [4:0] rgS2_index_ID_EX_IN;
    wire [4:0] rgD_index_ID_EX_IN;
    
        //OUTPUTS
    wire [31:0] next_pc_ID_EX_OUT;
    wire [13:0] op_ID_EX_OUT;
    wire [31:0] rgS1_data_ID_EX_OUT;
    wire [31:0] rgS2_data_ID_EX_OUT;
    wire [31:0] immed_ID_EX_OUT;
    wire y_sel_ID_EX_OUT;
    wire [5:0] control_ID_EX_OUT;
    wire [31:0] ALU_S2_DATA;
    wire [4:0] rgS1_index_ID_EX_OUT;
    wire [4:0] rgS2_index_ID_EX_OUT;
    wire [4:0] rgD_index_ID_EX_OUT;
    
    //Connections between EX and MEM stages
        //INPUTS
    wire [31:0] w_out_EX_M_IN;
    wire [31:0] w_pc_EX_M_IN;
    wire [31:0] w_zero_EX_M_IN;
  //  wire [31:0] rgS2_data_ID_EX_OUT;
  //  wire [5:0] control_ID_EX_OUT;
    
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
    wire [31:0] Data_Load;
    wire [31:0] mem_data_out;
    wire [31:0] w_out_M_WB_OUT;
    wire [1:0] control_M_WB_OUT;
    wire [4:0] rgD_index_M_WB_OUT;
    
    wire [31:0] rgD_data_in;
    wire [4:0] rgD_index_in;
    wire write_in;
    
   
   
   //Connections of Forwarding Unit
        //INPUTS
    
        //OUTPUTS
    wire [31:0] fwS1_data;
    wire [31:0] fwS2_data;
    
    //Connections of Hazard Unit
        //INPUTS
        
        //OUTPUTS
    wire HZ_U_stall;

  //Connections between MainMem and Cache_Controller
   wire read_Mem;
   wire write_Mem;
   wire [31:0] Addr_Mem;
   wire [31:0] Data_Mem;
   wire ready_mem; 

   //Connections between Instr_Cache and Cache_Controller
   wire read_Mem_instr;
   wire write_Mem_instr;
   wire [31:0] Addr_Mem_instr;
   wire [31:0] Data_Mem_instr;
   wire ready_mem_instr; 

   //Connections between Data_Cache and Cache_Controller
   wire read_Mem_data;
   wire write_Mem_data;
   wire [31:0] Addr_Mem_data;
   wire [31:0] Data_Mem_data;
   wire ready_mem_data; 

   // Instr_cache signals 
   wire read_instr;
   assign read_instr = 1'b1;       
   wire write_instr;
   assign write_instr = 1'b0;
   wire bytesel_instr;
   assign bytesel_instr = 1'b0;
   wire [31:0] data_write_instr;
   assign data_write_instr = 32'd0;
   wire [31:0] data_read_instr;
   wire stall_pc_instr;

   // Data_cache signals 
   wire stall_pc_data;

   // MainMemory signals
   wire CS;
   assign CS= 1'b1;

   //PC increment
    wire [31:0] PC;
    wire [31:0] next_PC;

    MainMem RAM(.clk(clk), .CS(CS), .OE(read_Mem), .WE(write_Mem), .Addr(Addr_Mem), .Data(Data_Mem), .Ready_Mem(ready_mem));
    
    Cache2 Data_Cache(clk, reset, control_EX_M_OUT[0], control_EX_M_OUT[1], control_EX_M_OUT[2], rgS2_data_EX_M_OUT, Data_Load, w_out_EX_M_OUT, stall_pc_data, ready_mem_data, Data_Mem_data, Addr_Mem_data, read_Mem_data, write_Mem_data );    

    Cache2 Instr_Cache(clk, reset,read_instr, write_instr, bytesel_instr, data_write_instr, data_read_instr, PC, stall_pc_instr, ready_mem_instr, Data_Mem_instr, Addr_Mem_instr, read_Mem_instr, write_Mem_instr );    
    
    Cache_Controller(read_Mem_data, write_Mem_data, read_Mem_instr, write_Mem_instr, Addr_Mem_data, Data_Mem_data, Addr_Mem_instr, Data_Mem_instr, ready_mem,
                      read_Mem, write_Mem, Addr_Mem, Data_Mem, ready_mem_data, ready_mem_instr);
    
    PC_Incrementer(clk, reset, stall_pc, PC, next_PC); 
   
    Hazard_Unit hz_u(clk, reset, rgS1_index_ID_EX_IN, rgS2_index_ID_EX_IN, rgD_index_ID_EX_OUT, control_ID_EX_OUT[5],
                HZ_U_stall);
                 
    Forwarding_Unit forw_unit(clk, reset, rgS1_index_ID_EX_OUT, rgS2_index_ID_EX_OUT, rgD_index_EX_M_OUT, rgD_index_M_WB_OUT, rgS1_data_ID_EX_OUT, rgS2_data_ID_EX_OUT, w_out_EX_M_OUT, rgD_data_in, control_EX_M_OUT[3], control_M_WB_OUT[0],
                    fwS1_data, fwS2_data);
    
    Reg_IF_ID IF_ID(clk, reset, write_enable_IF_ID, next_pc_IF_ID_IN, data_read_instr,
                    next_pc_IF_ID_OUT, ir_IF_ID_OUT);
    
    Decode dec(clk, reset, ir_IF_ID_OUT , rgD_index_in, rgD_data_in, write_in, op_ID_EX_IN, rgS1_data_ID_EX_IN, rgS2_data_ID_EX_IN, immed_ID_EX_IN, y_sel_ID_EX_IN, rgS1_index_ID_EX_IN, rgS2_index_ID_EX_IN, rgD_index_ID_EX_IN, read_mmu, write_mmu, byte_select_mmu, write_out, br_ins, ld_ins);
    
    assign read_mmu_ID_EX_IN = HZ_U_stall ? 0 : read_mmu;
    assign write_mmu_ID_EX_IN = HZ_U_stall ? 0 : write_mmu;
    assign byte_select_mmu_ID_EX_IN = HZ_U_stall ? 0 : byte_select_mmu;
    assign write_out_ID_EX_IN = HZ_U_stall ? 0 : write_out;
    assign br_ins_ID_EX_IN = HZ_U_stall ? 0 : br_ins;
    assign ld_ins_ID_EX_IN = HZ_U_stall ? 0 : ld_ins;
    
    Reg_ID_EX ID_EX(clk, reset, write_enable_ID_EX, next_pc_IF_ID_OUT, read_mmu_ID_EX_IN, write_mmu_ID_EX_IN, byte_select_mmu_ID_EX_IN, write_out_ID_EX_IN, br_ins_ID_EX_IN, ld_ins_ID_EX_IN, op_ID_EX_IN, rgS1_data_ID_EX_IN, rgS2_data_ID_EX_IN, immed_ID_EX_IN, y_sel_ID_EX_IN, rgS1_index_ID_EX_IN, rgS2_index_ID_EX_IN, rgD_index_ID_EX_IN,
                    next_pc_ID_EX_OUT, op_ID_EX_OUT, rgS1_data_ID_EX_OUT, rgS2_data_ID_EX_OUT, immed_ID_EX_OUT, y_sel_ID_EX_OUT, control_ID_EX_OUT, rgS1_index_ID_EX_OUT, rgS2_index_ID_EX_OUT, rgD_index_ID_EX_OUT);

    assign ALU_S2_DATA = y_sel_ID_EX_OUT ? fwS2_data : immed_ID_EX_OUT;
    
    ALU alu(op_ID_EX_OUT, fwS1_data, ALU_S2_DATA, next_pc_ID_EX_OUT, w_out_EX_M_IN, w_pc_EX_M_IN, w_zero_EX_M_IN);
    
    Reg_EX_M EX_M(clk, reset, write_enable_EX_M, w_out_EX_M_IN, w_pc_EX_M_IN, w_zero_EX_M_IN, fwS2_data, control_ID_EX_OUT, rgD_index_ID_EX_OUT,
                 w_out_EX_M_OUT, w_pc_EX_M_OUT, w_zero_EX_M_OUT, rgS2_data_EX_M_OUT, control_EX_M_OUT, rgD_index_EX_M_OUT);
    
    //take_branch = (if_branch && zero)
    
      
    Reg_M_WB M_WB(clk, reset, write_enable_M_WB, Data_Load, w_out_EX_M_OUT, control_EX_M_OUT[3], control_EX_M_OUT[5], rgD_index_EX_M_OUT,
                  mem_data_out, w_out_M_WB_OUT, control_M_WB_OUT, rgD_index_M_WB_OUT);                
                      
    assign rgD_index_in = rgD_index_M_WB_OUT;
    assign rgD_data_in = control_M_WB_OUT[1] ? mem_data_out : w_out_M_WB_OUT;
    assign write_in = control_M_WB_OUT[0];

    assign stall_pc = (stall_pc_data || stall_pc_instr);
    
    assign write_enable = !stall_pc;
    assign write_enable_IF_ID = (!stall_pc &&  !HZ_U_stall);
    assign write_enable_ID_EX = !stall_pc;
    assign write_enable_EX_M = !stall_pc;
    assign write_enable_M_WB = !stall_pc;
    
endmodule

