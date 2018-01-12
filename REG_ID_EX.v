module Reg_ID_EX(
    input clk,
    input reset,
    input write_enable, //Enable writes on the intermediate reg
    input [31:0] next_pc,   //PC of the next instruction
    
    input read_mmu,
    input write_mmu,
    input byte_select_mmu,
    input write_reg,
    input br_ins,
    input ld_ins,

    input [13:0] opcode_in,
    input [31:0] rgS1_data_in,
    input [31:0] rgS2_data_in,
    input [31:0] immed_in,
    input y_sel_in,

    input [4:0] rgD_index_in,
 
    output [31:0] next_pc_ID_EX_OUT,
    output [13:0] opcode_out,
    output [31:0] rgS1_data_out,
    output [31:0] rgS2_data_out,
    output [31:0] immed_out,
    output y_sel_out,

    output [5:0] control_out,
    output [4:0] rgD_index_out 
);

    wire [13:0] opcode_hold;
    wire [31:0] rgS1_data_hold;
    wire [31:0] rgS2_data_hold;

    wire [5:0] control_hold;
    wire [4:0] rgD_index_hold;
 

    generate
        genvar i;
        for(i=0; i<14; i = i+1) begin
            FlipFlop r(clk, reset, opcode_in[i], write_enable, opcode_hold[i]);
        end

       
        for(i=0; i<32; i = i+1) begin
            FlipFlop r(clk, reset, rgS1_data_in[i], write_enable, rgS1_data_hold[i]);
        end

        
        for(i=0; i<32; i = i+1) begin
            FlipFlop r(clk, reset, rgS2_data_in[i], write_enable, rgS2_data_hold[i]);
        end
              
        FlipFlop r_c0(clk, reset, read_mmu, write_enable, control_hold[0]);    //Read from mem
        FlipFlop r_c1(clk, reset, write_mmu, write_enable, control_hold[1]);   //Write to mem
        FlipFlop r_c2(clk, reset, byte_select_mmu, write_enable, control_hold[2]); //Byte select for accessing mem
        FlipFlop r_c3(clk, reset, write_reg, write_enable, control_hold[3]);   //Write to a reg
        FlipFlop r_c4(clk, reset, write_reg, br_ins, control_hold[4]);   //Branch instruction or not
        FlipFlop r_c5(clk, reset, write_reg, ld_ins, control_hold[5]);   //Load instruction or not

       
        for(i=0; i<5; i = i+1) begin
            FlipFlop r(clk, reset, rgD_index_in[i], write_enable, rgD_index_hold[i]);
        end
    endgenerate
        
    assign opcode_out = opcode_hold;
    assign rgS1_data_out = rgS1_data_hold;
    assign rgS2_data_out = rgS2_data_hold;
    assign control_out = control_hold;
    assign rdD_index_out = rgD_index_hold;
   
endmodule