`timescale 1ns / 1ps
`include "CONSTANTS.vh"
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.11.2017 11:44:29
// Design Name: 
// Module Name: ALU_testbench
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


module ALU_testbench();
    reg clk;
    reg [6:0] op;
    reg [31:0] x;
    reg [31:0] y;
    wire [31:0] w;
    ALU test(op, x, y, w);
    
    reg [31:0] prova;
    reg [14:0] imm;
            
    always #1 clk = ~clk;
    
    initial 
    begin
        clk = 1'b0;
        imm = 15'b100000000000111;
        prova <= $signed(imm);
                
        //SUM of 2 positive numbers
        op = `ADD;
        x = 32'h00000001;
        y = 32'h00000002;
        #10
        
        //SUM of 2 negative numbers
        op = `ADD;
        x = 32'hFFFFFFFF;
        y = 32'hFFFFFFFE;
        #10
        
        //SUM of 1 positive number and 1 negative number
        op = `ADD;
        x = 32'h00000001;
        y = 32'hFFFFFFFF;
        #10
        
        //SUM of 1 negative number and 1 positive number
        op = `ADD;
        x = 32'hFFFFFFFF;
        y = 32'h00000001;
        #10
        
        //SUM of 2 positive numbers with overflow
        op = `ADD;
        x = 32'h0FFFFFFF;
        y = 32'h00000001;
        #10
        
        //SUM of 2 negative numbers with overflow
        op = `ADD;
        x = 32'h80000000;
        y = 32'hFFFFFFFF;
        #10
        
        //SUB of 2 positive numbers
        op = `SUB;
        x = 32'h00000003;
        y = 32'h00000002;
        #10
        
        //SUB of 2 negative numbers
        op = `SUB;
        x = 32'hFFFFFFFD;
        y = 32'hFFFFFFFF;
        #10
        
        //SUB of 1 positive number and 1 negative number
        op = `SUB;
        x = 32'h00000003;
        y = 32'hFFFFFFFF;
        #10
        
        //SUB of 1 negative number and 1 positive number
        op = `SUB;
        x = 32'hFFFFFFFF;
        y = 32'h00000003;
        #10
        
        //MUL of 2 positive numbers
        op = `MUL;
        x = 32'h00000003;
        y = 32'h00000002;
        #10
        
        //MUL of 2 negative numbers
        op = `MUL;
        x = 32'hFFFFFFFD;
        y = 32'hFFFFFFFE;
        #10
        
        //MUL of 1 positive number and 1 negative number
        op = `MUL;
        x = 32'h00000003;
        y = 32'hFFFFFFFE;
        #10
        
        //MUL of 1 negative number and 1 positive number
        op = `MUL;
        x = 32'hFFFFFFFE;
        y = 32'h00000003;
        #10
        
        //MUL of 1 negative number and 1 positive number
        op = `MUL;
        x = 32'hFFFFFFFE;
        y = 32'h00000003;
        #10
        
        //MUL of 2 positive numbers with overflow
        op = `MUL;
        x = 32'h0FFFFFFF;
        y = 32'h00000002;
        #10
        
        //MUL of 2 negative numbers with overflow
        op = `MUL;
        x = 32'h80000000;
        y = 32'hFFFFFFFE;
        #10
        
        //MUL of 1 positive number with 1 negative number with overflow
        op = `MUL;
        x = 32'h0FFFFFFF;
        y = 32'hF0000002;
                
        $finish;
    end
    

endmodule
