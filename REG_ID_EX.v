module Reg_ID_EX(
    input clk,
    input reset,
    input write_enable, //Enable writes on the intermediate reg
    input [31:0] next_pc_in,   //PC of the next instruction
    
    input read_mmu,
    input write_mmu,
    input byte_select_mmu,
    input write_reg,
    input br_ins,
    input ld_ins,
    input mul_ins,

    input [13:0] opcode_in,
    input [31:0] rgS1_data_in,
    input [31:0] rgS2_data_in,
    input [31:0] immed_in,
    input y_sel_in,
    
    input [4:0] rgS1_index_in,
    input [4:0] rgS2_index_in,
    input [4:0] rgD_index_in,
 
    output [31:0] next_pc_ID_EX_OUT,
    output [13:0] opcode_out,
    output [31:0] rgS1_data_out,
    output [31:0] rgS2_data_out,
    output [31:0] immed_out,
    output y_sel_out,

    output [6:0] control_out,
    output [4:0] rgS1_index_out,
    output [4:0] rgS2_index_out,
    output [4:0] rgD_index_out 
);

    wire [31:0] next_pc_hold;
    wire [13:0] opcode_hold;
    wire [31:0] rgS1_data_hold;
    wire [31:0] rgS2_data_hold;
    wire [31:0] immed_hold;
    wire y_sel_hold;

    wire [6:0] control_hold;
    wire [4:0] rgD_index_hold;
 

    generate
        genvar i;
        for(i=0; i<32; i = i+1) begin
            FlipFlop r(clk, reset, next_pc_in[i], write_enable, next_pc_hold[i]);
        end
        
        for(i=0; i<14; i = i+1) begin
            FlipFlop r(clk, reset, opcode_in[i], write_enable, opcode_hold[i]);
        end

       
        for(i=0; i<32; i = i+1) begin
            FlipFlop r(clk, reset, rgS1_data_in[i], write_enable, rgS1_data_hold[i]);
        end

        
        for(i=0; i<32; i = i+1) begin
            FlipFlop r(clk, reset, rgS2_data_in[i], write_enable, rgS2_data_hold[i]);
        end
        
        for(i=0; i<5; i = i+1) begin
                FlipFlop r(clk, reset, rgS1_index_in[i], write_enable, rgS1_index_out[i]);
        end
        
        for(i=0; i<5; i = i+1) begin
                FlipFlop r(clk, reset, rgS2_index_in[i], write_enable, rgS2_index_out[i]);
        end
        
        for(i=0; i<5; i = i+1) begin
            FlipFlop r(clk, reset, rgD_index_in[i], write_enable, rgD_index_hold[i]);
        end
        
        for(i=0; i<32; i = i+1) begin
            FlipFlop r(clk, reset, immed_in[i], write_enable, immed_hold[i]);
        end
        
        
        
        FlipFlop r_ys(clk, reset, y_sel_in, write_enable, y_sel_hold);
              
        FlipFlop r_c0(clk, reset, read_mmu, write_enable, control_out[0]);    //Read from mem
        FlipFlop r_c1(clk, reset, write_mmu, write_enable, control_out[1]);   //Write to mem
        FlipFlop r_c2(clk, reset, byte_select_mmu, write_enable, control_out[2]); //Byte select for accessing mem
        FlipFlop r_c3(clk, reset, write_reg, write_enable, control_out[3]);//_hold[3]);   //Write to a reg
        FlipFlop r_c4(clk, reset, br_ins, write_enable, control_out[4]);   //Branch instruction or not
        FlipFlop r_c5(clk, reset, ld_ins, write_enable, control_out[5]);   //Load instruction or not
        FlipFlop r_c6(clk, reset, mul_ins, write_enable, control_out[6]);   //Mul instruction or not
              
    endgenerate
        
    assign next_pc_ID_EX_OUT = next_pc_hold;
    assign opcode_out = opcode_hold;
    assign rgS1_data_out = rgS1_data_hold;
    assign rgS2_data_out = rgS2_data_hold;
    assign immed_out = immed_hold;
    assign y_sel_out = y_sel_hold;
    //assign control_out = control_hold;
    assign rgD_index_out = rgD_index_hold;
   
endmodule