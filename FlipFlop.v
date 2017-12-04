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
    input reset,
    input data,
    input write,
    output q
);

    reg q_out;
    
    always @(posedge clk, posedge reset)
        begin
            if (reset == 1'b1)
                q_out <= 1'b0;
            else if (clk == 1'b1) begin
                if (write == 1'b1)
                    q_out <= data;
            end
        end   
        
    assign q = q_out;
    
endmodule