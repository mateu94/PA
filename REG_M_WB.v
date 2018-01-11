module Reg_M_WB(
    input clk,
    input reset,
    input write,

   
    input [31:0] mem_data_in,
    input [31:0] data_in,
   
    input [4:0] rgD_index_in,
 
    
    output [31:0] mem_data_out,
    output [31:0] data_out,
  
    output [4:0] rgD_index_out 
);

    wire [31:0] mem_data_hold;
    wire [31:0] data_hold;

    wire [4:0] rgD_index_hold;
 

    generate
        genvar i;      
        for(i=0; i<31; i = i+1) begin
            FlipFlop r(clk, reset, mem_data_in[i], write, mem_data_hold[i]);
        end
        
        for(i=0; i<31; i = i+1) begin
            FlipFlop r(clk, reset, data_in[i], write, data_hold[i]);
        end
 
        for(i=0; i<4; i = i+1) begin
            FlipFlop r(clk, reset, rgD_index_in[i], write, rgD_index_hold[i]);
        end
    endgenerate
            
    assign meme_data_out = mem_data_hold;
    assign data_out = data_hold;
    assign rdD_index_out = rgD_index_hold;
   
endmodule
