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
    input reset //,
 //   input [31:0] ir
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
    wire stall_pc_incrementer;

    wire stall_pc;
    
    wire read_mmu;
    wire write_mmu;
    wire byte_select_mmu;
    wire br_ins;
    wire ld_ins;
    wire mul_ins;
    
    //Connections between IF and ID stages    
            //INPUTS
    wire [31:0] next_pc_IF_ID_IN;
    wire [31:0] ir_IF_ID_IN;
            //OUTPUTS
    wire [31:0] next_pc_IF_ID_OUT;
    wire [31:0] ir_IF_ID_OUT;
    wire reset_IF_ID;
    
    //Connections between DECODER and EX stages    
        //INPUTS
    wire read_mmu_ID_EX_IN;
    wire write_mmu_ID_EX_IN;
    wire byte_select_mmu_ID_EX_IN;
    wire br_ins_ID_EX_IN;
    wire ld_ins_ID_EX_IN;
    wire mul_ins_ID_EX_IN;
    wire [31:0] ir_DEC_IN;
    
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
    wire [6:0] control_ID_EX_OUT;
    wire [31:0] ALU_S2_DATA;
    wire [4:0] rgS1_index_ID_EX_OUT;
    wire [4:0] rgS2_index_ID_EX_OUT;
    wire [4:0] rgD_index_ID_EX_OUT;
    
    //Connections between EX and MEM stages
        //INPUTS
    wire [31:0] w_out_EX_M_IN;
    wire [31:0] w_pc_EX_M_IN;
    wire [31:0] w_take_branch_EX_M_IN;
  //  wire [31:0] rgS2_data_ID_EX_OUT;
  //  wire [5:0] control_ID_EX_OUT;
    wire [31:0] immed_sl2;
    wire [5:0] control_EX_M_IN;
    
        //OUTPUTS
    wire [31:0] w_out_EX_M_OUT;
    wire [31:0] w_pc_EX_M_OUT;
    wire w_take_branch_EX_M_OUT;
    wire [31:0] rgS2_data_EX_M_OUT;
    wire [5:0] control_EX_M_OUT;
    wire [4:0] rgD_index_EX_M_OUT;
    wire PCSrc;
    
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
    
    //Connections between mult pipeline stages
    wire write_enable_M1;
    wire write_enable_M2;
    wire write_enable_M3;
    wire write_enable_M4;
    wire write_enable_MUL_WB;
    
    wire [31:0] w_out_M1_IN;
    wire [31:0] w_out_M2_IN;
    wire [31:0] w_out_M3_IN;
    wire [31:0] w_out_M4_IN;
    wire [31:0] w_out_MUL_WB_IN;
    
    wire [31:0] w_out_M1_OUT;
    wire [31:0] w_out_M2_OUT;
    wire [31:0] w_out_M3_OUT;
    wire [31:0] w_out_M4_OUT;
    wire [31:0] w_out_MUL_WB_OUT;
    
    wire control_M1_IN;
    wire control_M1_OUT;
    wire control_M2_OUT;
    wire control_M3_OUT;
    wire control_M4_OUT;
    wire control_MUL_WB_OUT;
    
    wire [4:0] rgD_M1_index_out;
    wire [4:0] rgD_M2_index_out;
    wire [4:0] rgD_M3_index_out;
    wire [4:0] rgD_M4_index_out;
    wire [4:0] rgD_MUL_WB_index_out;
    
    wire [4:0] rgD_mul_index_in;
    wire [31:0] rgD_mul_data_in;
    wire write_mul_in;
   
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
   wire [127:0] Data_Mem_read;
   wire [127:0] Data_Mem_write;
   wire ready_mem; 


   //Connections between Instr_Cache and Cache_Controller
   wire read_Mem_instr;
   wire write_Mem_instr;
   wire [31:0] Addr_Mem_instr;
   wire [127:0] Data_Mem_instr_read;
   wire [127:0] Data_Mem_instr_write;
   wire ready_mem_instr; 
   wire mem_busy_instr; 


   //Connections between Data_Cache and Cache_Controller
   wire read_Mem_data;
   wire write_Mem_data;
   wire [31:0] Addr_Mem_data;
   wire [127:0] Data_Mem_data_read;
   wire [127:0] Data_Mem_data_write;
   wire ready_mem_data; 
   wire mem_busy_data; 


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

    MainMem RAM(.clk(clk), .CS(CS), .OE(read_Mem), .WE(write_Mem), .Addr(Addr_Mem), .Data_in(Data_Mem_write), .Data_out(Data_Mem_read), .Ready_Mem(ready_mem));
    
    Cache2 Data_Cache(clk, reset, control_EX_M_OUT[0], control_EX_M_OUT[1], control_EX_M_OUT[2], rgS2_data_EX_M_OUT, Data_Load, w_out_EX_M_OUT, stall_pc_data, ready_mem_data, mem_busy_data, Data_Mem_data_read, Data_Mem_data_write, Addr_Mem_data, read_Mem_data, write_Mem_data );    

    Cache2 Instr_Cache(clk, reset,read_instr, write_instr, bytesel_instr, data_write_instr, data_read_instr, PC, stall_pc_instr, ready_mem_instr, mem_busy_instr, Data_Mem_instr_read, Data_Mem_instr_write, Addr_Mem_instr, read_Mem_instr, write_Mem_instr );    
    
    Cache_Controller cache_controller(clk, read_Mem_data, write_Mem_data, read_Mem_instr, write_Mem_instr, Addr_Mem_data, Data_Mem_data_read, Data_Mem_data_write, Addr_Mem_instr, Data_Mem_instr_read, Data_Mem_instr_write, ready_mem,
                      read_Mem, write_Mem, Addr_Mem, Data_Mem_read, Data_Mem_write, ready_mem_data, ready_mem_instr, mem_busy_data, mem_busy_instr);
    
    PC_Incrementer PC_incrementer(clk, reset, stall_pc_incrementer, PCSrc, w_pc_EX_M_OUT, PC, next_pc_IF_ID_IN); 
   
    Hazard_Unit hz_u(clk, reset, rgS1_index_ID_EX_IN, rgS2_index_ID_EX_IN, rgD_index_ID_EX_OUT, control_ID_EX_OUT[5],
                HZ_U_stall);
                 
    Forwarding_Unit forw_unit(clk, reset, rgS1_index_ID_EX_OUT, rgS2_index_ID_EX_OUT, rgD_index_EX_M_OUT, rgD_index_M_WB_OUT, rgS1_data_ID_EX_OUT, rgS2_data_ID_EX_OUT, w_out_EX_M_OUT, rgD_data_in, control_EX_M_OUT[3], control_M_WB_OUT[0],
                    fwS1_data, fwS2_data);
    
    Reg_IF_ID IF_ID(clk, reset_IF_ID, write_enable_IF_ID, next_pc_IF_ID_IN, data_read_instr,
                    next_pc_IF_ID_OUT, ir_IF_ID_OUT);
                    
    // Multiplexor in case there is a taken branch
    assign ir_DEC_IN = (w_take_branch_EX_M_OUT) ? 32'h00000000 : ir_IF_ID_OUT;
    
    Decode dec(clk, reset, ir_DEC_IN , rgD_index_in, rgD_data_in, write_in, op_ID_EX_IN, rgS1_data_ID_EX_IN, rgS2_data_ID_EX_IN, immed_ID_EX_IN, y_sel_ID_EX_IN, rgS1_index_ID_EX_IN, rgS2_index_ID_EX_IN, rgD_index_ID_EX_IN, read_mmu, write_mmu, byte_select_mmu, write_out, br_ins, ld_ins, mul_ins);
    
    // Multiplexor in case there is a hazard stall or a taken branch
    assign read_mmu_ID_EX_IN = (HZ_U_stall || w_take_branch_EX_M_OUT) ? 0 : read_mmu;
    assign write_mmu_ID_EX_IN = (HZ_U_stall || w_take_branch_EX_M_OUT) ? 0 : write_mmu;
    assign byte_select_mmu_ID_EX_IN = (HZ_U_stall || w_take_branch_EX_M_OUT) ? 0 : byte_select_mmu;
    assign write_out_ID_EX_IN = (HZ_U_stall || w_take_branch_EX_M_OUT) ? 0 : write_out;
    assign br_ins_ID_EX_IN = (HZ_U_stall || w_take_branch_EX_M_OUT) ? 0 : br_ins;
    assign ld_ins_ID_EX_IN = (HZ_U_stall || w_take_branch_EX_M_OUT) ? 0 : ld_ins;
    assign mul_ins_ID_EX_IN = (HZ_U_stall || w_take_branch_EX_M_OUT) ? 0 : mul_ins;
    
    Reg_ID_EX ID_EX(clk, reset, write_enable_ID_EX, next_pc_IF_ID_OUT, read_mmu_ID_EX_IN, write_mmu_ID_EX_IN, byte_select_mmu_ID_EX_IN, write_out_ID_EX_IN, br_ins_ID_EX_IN, ld_ins_ID_EX_IN, mul_ins_ID_EX_IN, op_ID_EX_IN, rgS1_data_ID_EX_IN, rgS2_data_ID_EX_IN, immed_ID_EX_IN, y_sel_ID_EX_IN, rgS1_index_ID_EX_IN, rgS2_index_ID_EX_IN, rgD_index_ID_EX_IN,
                    next_pc_ID_EX_OUT, op_ID_EX_OUT, rgS1_data_ID_EX_OUT, rgS2_data_ID_EX_OUT, immed_ID_EX_OUT, y_sel_ID_EX_OUT, control_ID_EX_OUT, rgS1_index_ID_EX_OUT, rgS2_index_ID_EX_OUT, rgD_index_ID_EX_OUT);

    assign ALU_S2_DATA = y_sel_ID_EX_OUT ? fwS2_data : immed_ID_EX_OUT;
    assign immed_sl2 = immed_ID_EX_OUT << 2;
    
    ALU alu(op_ID_EX_OUT, fwS1_data, ALU_S2_DATA, immed_sl2, next_pc_ID_EX_OUT, w_out_EX_M_IN, w_pc_EX_M_IN, w_take_branch_EX_M_IN);
    
    // Multiplexor in case there is a taken branch or a multiplication
    assign control_EX_M_IN[0] = (w_take_branch_EX_M_OUT || control_ID_EX_OUT[6]) ? 0 : control_ID_EX_OUT[0];
    assign control_EX_M_IN[1] = (w_take_branch_EX_M_OUT || control_ID_EX_OUT[6]) ? 0 : control_ID_EX_OUT[1];
    assign control_EX_M_IN[2] = (w_take_branch_EX_M_OUT || control_ID_EX_OUT[6]) ? 0 : control_ID_EX_OUT[2];
    assign control_EX_M_IN[3] = (w_take_branch_EX_M_OUT || control_ID_EX_OUT[6]) ? 0 : control_ID_EX_OUT[3];
    assign control_EX_M_IN[4] = (w_take_branch_EX_M_OUT || control_ID_EX_OUT[6]) ? 0 : control_ID_EX_OUT[4];
    assign control_EX_M_IN[5] = (w_take_branch_EX_M_OUT || control_ID_EX_OUT[6]) ? 0 : control_ID_EX_OUT[5];
    
    Reg_EX_M EX_M(clk, reset, write_enable_EX_M, w_out_EX_M_IN, w_pc_EX_M_IN, w_take_branch_EX_M_IN, fwS2_data, control_EX_M_IN, rgD_index_ID_EX_OUT,
                 w_out_EX_M_OUT, w_pc_EX_M_OUT, w_take_branch_EX_M_OUT, rgS2_data_EX_M_OUT, control_EX_M_OUT, rgD_index_EX_M_OUT);
    
    assign PCSrc = (w_take_branch_EX_M_OUT && control_EX_M_OUT[4]) ? 1 : 0;
    
      
    Reg_M_WB M_WB(clk, reset, write_enable_M_WB, Data_Load, w_out_EX_M_OUT, control_EX_M_OUT[3], control_EX_M_OUT[5], rgD_index_EX_M_OUT,
                  mem_data_out, w_out_M_WB_OUT, control_M_WB_OUT, rgD_index_M_WB_OUT);
                  
    // Multiplication pipeline
    // Multiplexor in case there is a multiplication, only consider if it has to write to reg
    assign control_M1_IN = (w_take_branch_EX_M_OUT || !control_ID_EX_OUT[6]) ? 0 : control_ID_EX_OUT[3];
    
    MULT_RESULT mult1(fwS1_data, fwS2_data, w_out_M1_IN);
    Reg_MUL M1(clk, reset, write_enable_M1, w_out_M1_IN, control_M1_IN, rgD_index_ID_EX_OUT,
            w_out_M1_OUT, control_M1_OUT, rgD_M1_index_out);
            
    MULT_PASS mult2(w_out_M1_OUT, w_out_M2_IN);
    Reg_MUL M2(clk, reset, write_enable_M2, w_out_M2_IN, control_M1_OUT, rgD_M1_index_out,
            w_out_M2_OUT, control_M2_OUT, rgD_M2_index_out);
            
    MULT_PASS mult3(w_out_M2_OUT, w_out_M3_IN);
    Reg_MUL M3(clk, reset, write_enable_M3, w_out_M3_IN, control_M2_OUT, rgD_M2_index_out,
            w_out_M3_OUT, control_M3_OUT, rgD_M3_index_out);
            
    MULT_PASS mult4(w_out_M3_OUT, w_out_M4_IN);
    Reg_MUL M4(clk, reset, write_enable_M4, w_out_M4_IN, control_M3_OUT, rgD_M3_index_out,
            w_out_M4_OUT, control_M4_OUT, rgD_M4_index_out);
            
    MULT_PASS mult5(w_out_M4_OUT, w_out_MUL_WB_IN);
    Reg_MUL MUL_WB(clk, reset, write_enable_MUL_WB, w_out_MUL_WB_IN, control_M4_OUT, rgD_M4_index_out,
            w_out_MUL_WB_OUT, control_MUL_WB_OUT, rgD_MUL_WB_index_out);
                         
                      
    assign rgD_index_in = control_MUL_WB_OUT ? rgD_MUL_WB_index_out : rgD_index_M_WB_OUT;
    assign rgD_data_in = control_MUL_WB_OUT ? w_out_MUL_WB_OUT : (control_M_WB_OUT[1] ? mem_data_out : w_out_M_WB_OUT);
    assign write_in = (control_MUL_WB_OUT || control_M_WB_OUT[0]) ? 1 : 0;

    assign stall_pc = (stall_pc_data || stall_pc_instr);
    
    assign write_enable = !stall_pc;
    assign write_enable_IF_ID = (!stall_pc &&  !HZ_U_stall);
    assign write_enable_ID_EX = !stall_pc;
    assign write_enable_EX_M = !stall_pc;
    assign write_enable_M1 = !stall_pc;
    assign write_enable_M2 = !stall_pc;
    assign write_enable_M3 = !stall_pc;
    assign write_enable_M4 = !stall_pc;
    assign write_enable_MUL_WB = !stall_pc;
    assign write_enable_M_WB = !stall_pc;
    assign stall_pc_incrementer = stall_pc ||  HZ_U_stall;
    
    assign reset_IF_ID = reset || PCSrc;
 
    
endmodule

