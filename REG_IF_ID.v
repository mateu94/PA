module Reg_IF_ID(
    input clk,
    input reset,
    input write,

    input [31:0] next_PC_in,
    input [31:0] ir_in,
   
    output [31:0] next_PC_out,
    output [31:0] ir_out  
    
);

    wire [31:0] PC_hold;
    wire [31:0] next_PC_hold;
    wire [31:0] ir_hold;

    generate
        genvar i;              
        for(i=0; i<32; i = i+1) begin
            FlipFlop r(clk, reset, next_PC_in[i], write, next_PC_hold[i]);
        end
        
        for(i=0; i<32; i = i+1) begin
            FlipFlop r(clk, reset, ir_in[i], write, ir_hold[i]);
        end
         
    endgenerate
            
    assign next_PC_out = next_PC_hold;
    assign ir_out = ir_hold;
 
endmodule
