`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/29/2017 02:29:24 PM
// Design Name: 
// Module Name: registers_testbench
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


module registers_testbench();
    reg clk;
    reg [4:0] addr_a;
    reg [4:0] addr_b;
    reg [4:0] addr_d;
    reg [31:0] data;
    reg write;
    wire [31:0] a;
    wire [31:0] b;

    Registers_Bank test(clk, addr_a, addr_b, addr_d, data, write, a, b);
    
    always #1 clk = ~clk;
    
    initial 
    begin
        clk = 1'b0;
                
        #2
        //REG0 <- 1
        addr_a = 5'h1;
        addr_b = 5'h2;
        addr_d = 5'h0;
        data = 32'h00000001;
        write = 1'h1;
        #2
        
        //READ R0
        addr_a = 5'h0;
        addr_b = 5'h1;
        addr_d = 5'h2;
        data = 32'h00000001;
        write = 1'h0;
        #2
        
        //data = 5
        data = 32'h00000005;
        #2
        
        $finish;
    end
endmodule
