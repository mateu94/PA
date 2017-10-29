`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.10.2017 16:28:27
// Design Name: 
// Module Name: FlipFlop
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


module FlipFlop(
    input clk,
    input data,
    input write,
    output q
);

reg q;
//reg p;

//Registers r1(clk, data, write, q);

always @(posedge clk)
    begin
        if (write == 1)
            q <= data;
            //p <= data;
    end
   
endmodule