`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2017 07:25:16 PM
// Design Name: 
// Module Name: FlipFlop_testbench
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


module FlipFlop_testbench();
    
    reg clk;
    reg data;
    reg write;
    wire q;

    FlipFlop test(clk, data, write, q);
    
    always #1 clk = ~clk;
    
    initial 
    begin
        clk = 1'b0;
        
        data = 1'b1;
        write = 1'b0;
        #2
        
        data = 1'b1;
        write = 1'b1;
        #2
        
        data = 1'b0;
        write = 1'b0;
        #2
        
        $finish;
    end

endmodule
