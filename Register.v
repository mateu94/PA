`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2017 22:32:02
// Design Name: 
// Module Name: Register
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


module Register(
    input clk,
    input [31:0] data,
    input write,
    output [31:0] q
);

    wire [31:0] q_array;

    generate
        genvar i;
        for(i=0; i<32; i = i+1) begin
            FlipFlop r[31:0] (clk, data[i], write, q_array[i]);
        end
    endgenerate
        
    assign q = q_array;
   
endmodule

