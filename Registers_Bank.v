`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2017 22:36:23
// Design Name: 
// Module Name: Registers_Bank
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


module Registers_Bank(
    input clk,
    input reset,
    input [4:0] addr_a,
    input [4:0] addr_b,
    input [4:0] addr_d,
    input [31:0] data,
    input write,
    output [31:0] a,
    output [31:0] b
);
    
    reg [31:0] write_array;
    wire [31:0] q_array [31:0];
    reg [4:0] addr_d_previous;  //To disbale write signal
    reg [31:0] a_out;
    reg [31:0] b_out;
    
    
    integer i;
    initial
        begin
            for(i=0; i<32; i = i+1)
                write_array[i] = 1'b0;
            addr_d_previous = 5'h0;
        end
    
    generate
        genvar j;
        for(j=1; j<32; j = j+1) begin
            Register rbank(clk, reset, data, write_array[j], q_array[j]);
        end
    endgenerate
    
    always @(*)
        begin
            a_out <= q_array[addr_a];
            b_out <= q_array[addr_b];
        end
    
    always @(addr_d, write)
            begin
                write_array[addr_d] <= write;
                if (addr_d != addr_d_previous) write_array[addr_d_previous] <= 1'b0;
                addr_d_previous = addr_d;
            end
        
    assign q_array[0] = 32'h00000000;
        
    assign a = a_out;
    assign b = b_out;
   
endmodule
