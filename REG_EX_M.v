module Reg_EX_M(
    input clk,
    input reset,
    input write,

   
    input [31:0] alu_output_in, //ALU output
    input [31:0] next_pc_in,    //Next PC (PC + 4)
    input ALU_take_branch_in,          //ALU zero signal
    input [31:0] data_in,       //Data to write to mem

    input [5:0] control_in,
    input [4:0] rgD_index_in,
 
    
    output [31:0] alu_output_out,
    output [31:0] next_pc_out,
    output ALU_take_branch_out,
    output [31:0] data_out,

    output [5:0] control_out,
    output [4:0] rgD_index_out 
);

    wire [31:0] alu_output_hold;
    wire [31:0] next_pc_hold;
    wire ALU_take_branch_hold;
    wire [31:0] data_hold;

    wire [5:0] control_hold;
    wire [4:0] rgD_index_hold;
 

    generate
        genvar i;      
        for(i=0; i<32; i = i+1) begin
            FlipFlop r(clk, reset, alu_output_in[i], write, alu_output_hold[i]);
        end

        for(i=0; i<32; i = i+1) begin
            FlipFlop r(clk, reset, next_pc_in[i], write, next_pc_hold[i]);
        end
        
        FlipFlop r(clk, reset, ALU_take_branch_in, write, ALU_take_branch_hold);

        for(i=0; i<32; i = i+1) begin
            FlipFlop r(clk, reset, data_in[i], write, data_hold[i]);
        end
       
       
        for(i=0; i<6; i = i+1) begin
            FlipFlop r(clk, reset, control_in[i], write, control_hold[i]);
        end
 
       
        for(i=0; i<5; i = i+1) begin
            FlipFlop r(clk, reset, rgD_index_in[i], write, rgD_index_hold[i]);
        end
    endgenerate
            
    assign alu_output_out = alu_output_hold;
    assign next_pc_out = next_pc_hold;
    assign ALU_take_branch_out = ALU_take_branch_hold;
    assign data_out = data_hold;
    assign control_out = control_hold;
    assign rgD_index_out = rgD_index_hold;
   
endmodule
