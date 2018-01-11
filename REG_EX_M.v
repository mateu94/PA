module Reg_EX_M(
    input clk,
    input reset,
    input write,

   
    input [31:0] address_in,
    input [31:0] next_pc_in,
    input ALU_zero_in,
    input [31:0] data_in,

    input [5:0] control_in,
    input [4:0] rgD_index_in,
 
    
    output [31:0] address_out,
    output [31:0] next_pc_out,
    output ALU_zero_out,
    output [31:0] data_out,

    output [5:0] control_out,
    output [4:0] rgD_index_out 
);

    wire [31:0] address_hold;
    wire [31:0] next_pc_hold;
    wire ALU_zero;
    wire [31:0] data_hold;

    wire [3:0] control_hold;
    wire [4:0] rgD_index_hold;
 

    generate
        genvar i;      
        for(i=0; i<31; i = i+1) begin
            FlipFlop r(clk, reset, address_in[i], write, address_hold[i]);
        end

        for(i=0; i<31; i = i+1) begin
            FlipFlop r(clk, reset, next_pc_in[i], write, next_pc_hold[i]);
        end
        
        FlipFlop r(clk, reset, ALU_zero_in, write, ALU_zero_hold);

        for(i=0; i<31; i = i+1) begin
            FlipFlop r(clk, reset, data_in[i], write, data_hold[i]);
        end
       
       
        for(i=0; i<3; i = i+1) begin
            FlipFlop r(clk, reset, control_in[i], write, control_hold[i]);
        end
 
       
        for(i=0; i<4; i = i+1) begin
            FlipFlop r(clk, reset, rgD_index_in[i], write, rgD_index_hold[i]);
        end
    endgenerate
            
    assign address_out = address_hold;
    assign next_pc_out = next_pc_hold;
    assign ALU_zero_out = ALU_zero_hold;
    assign data_out = data_hold;
    assign control_out = control_hold;
    assign rdD_index_out = rgD_index_hold;
   
endmodule
