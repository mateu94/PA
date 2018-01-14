`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/14/2018 07:36:24 PM
// Design Name: 
// Module Name: Hazard_Unit
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


module Hazard_Unit(
    input clk, 
    input reset,
    input [4:0] rgS1_index_ID_EX_IN,
    input [4:0] rgS2_index_ID_EX_IN,
    input [4:0] rgD_index_ID_EX_OUT,
    input control_ID_EX_OUT,   //Indicate if it is a Load
    
    output HZ_U_stall
    );
    
    reg HZ_U_stall_sign;
    
    always @(*) begin
        HZ_U_stall_sign = 1'b0;
        
        if (control_ID_EX_OUT && ( (rgS1_index_ID_EX_IN == rgD_index_ID_EX_OUT) || (rgS2_index_ID_EX_IN == rgD_index_ID_EX_OUT) ) )
            HZ_U_stall_sign = 1'b1;            
    end
    
    assign HZ_U_stall = HZ_U_stall_sign;
    
endmodule
