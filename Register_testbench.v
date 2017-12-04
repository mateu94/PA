`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2017 07:31:51 PM
// Design Name: 
// Module Name: Register_testbench
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


module Register_testbench();

    reg clk;
    reg reset;
    reg [31:0] data;
    reg write;
    wire [31:0] q;
    
    Register test(clk, reset, data, write, q);
    
    always #1 clk = ~clk;
    
    initial
    begin
        clk = 1'b0;
        #2
        
        reset = 1'b1;
        data = 32'h00000001;
        write = 1'b1;
        #2
        
        reset = 1'b0;
        data = 32'h00000001;
        write = 1'b0;
        #2
        
        data = 32'h00000002;
        write = 1'b1;
        #2
        
        data = 32'h00000003;
        write = 1'b0;
        #2
        
        $finish;
    end

endmodule
