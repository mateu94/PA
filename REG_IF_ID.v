module Reg_IF_ID(
    input clk,
    input reset,
    input write,

   
    input [31:0] PC_in,
    input [31:0] next_PC_in,
   
       
    output [31:0] PC_out,
    output [31:0] next_PC_out  
    
);

    wire [31:0] PC_hold;
    wire [31:0] next_PC_hold;

    generate
        genvar i;      
        for(i=0; i<31; i = i+1) begin
            FlipFlop r(clk, reset, PC_in[i], write, PC_hold[i]);
        end
        
        for(i=0; i<31; i = i+1) begin
            FlipFlop r(clk, reset, next_PC_in[i], write, next_PC_hold[i]);
        end
         
    endgenerate
            
    assign PC_out = PC_hold;
    assign next_PC_out = next_PC_hold;
 
endmodule
