`timescale 1ns / 1ps
`include "CONSTANTS.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2017 08:10:46 PM
// Design Name: 
// Module Name: DataPath_testbench
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


module DataPath_testbench();

    reg clk;
    reg [6:0] op;
    reg [4:0] addr_a;
    reg [4:0] addr_b;
    reg [4:0] addr_d;
    reg [31:0] immed;
    reg y_sel;
    reg write;
    
    wire [31:0] a_out;
    wire [31:0] b_out;
    wire [31:0] w_out;
    
    DataPath test(clk, op, addr_a, addr_b, addr_d, immed, y_sel, write, a_out, b_out, w_out);
    
    always #1 clk = ~clk;
    
    initial
    begin
        clk = 1'b0;
        
        //
        op = `ADD;
        addr_a = 5'h0;
        addr_b = 5'h0;
        addr_d = 5'h0;
        immed = 32'h00000005;
        y_sel = 1;
        write = 1;
        #2
                
        $finish;
    end

endmodule
