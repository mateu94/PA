module Reg_M_WB(
    input clk,
    input reset,
    input write,

   
    input [31:0] mem_data_in,
    input [31:0] data_in,
   
    input write_reg,
    input ld_ins,
    input [4:0] rgD_index_in,
 
    
    output [31:0] mem_data_out,
    output [31:0] data_out,
  
    output [1:0] control_out,
    output [4:0] rgD_index_out 
);

    wire [31:0] mem_data_hold;
    wire [31:0] data_hold;
    wire [1:0] control_hold;

    wire [4:0] rgD_index_hold;
 

    generate
        genvar i;      
        for(i=0; i<32; i = i+1) begin
            FlipFlop r(clk, reset, mem_data_in[i], write, mem_data_hold[i]);
        end
        
        for(i=0; i<32; i = i+1) begin
            FlipFlop r(clk, reset, data_in[i], write, data_hold[i]);
        end
 
        for(i=0; i<5; i = i+1) begin
            FlipFlop r(clk, reset, rgD_index_in[i], write, rgD_index_hold[i]);
        end
        
        FlipFlop r_c0(clk, reset, write_reg, write, control_hold[0]);   //Write to a reg
        FlipFlop r_c1(clk, reset, ld_ins, write, control_hold[1]);   //Load instruction or not
        
    endgenerate
            
    assign mem_data_out = mem_data_hold;
    assign data_out = data_hold;
    assign rgD_index_out = rgD_index_hold;
    assign control_out = control_hold;
   
endmodule
