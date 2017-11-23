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

    reg q_out;
    
    always @(posedge clk)
        begin
            if (write == 1)
                q_out <= data;
        end   
        
    assign q = q_out;
    
endmodule