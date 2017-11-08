`timescale 1ns / 1ps
`include "CONSTANTS.v"
module ALU_testbench(
    /*
    input clk,
    input [6:0] op,
    input [31:0] x,
    input [31:0] y,
    output [31:0] w
    */
    );
 //   reg clk;
    reg [6:0] op;
    reg [31:0] x;
    reg [31:0] y;
    wire [31:0] w;
    ALU test(op, x, y, w);
        
/*    initial
        clk=1'b0;
        always #10 clk = ~clk;
*/
    initial
    #20
    begin
        op = `ADD;
        x = 32'h00000001;
        y = 32'h00000002;
    end
endmodule